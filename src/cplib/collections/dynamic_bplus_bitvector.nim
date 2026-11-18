when not declared CPLIB_COLLECTIONS_DYNAMIC_BPLUS_BITVECTOR:
    const CPLIB_COLLECTIONS_DYNAMIC_BPLUS_BITVECTOR* = 1
    import bitops
    import cplib/collections/dynamic_bitvector_kernels
    import cplib/collections/dynamic_bplus_kernels

    type
        BPlusPackedBits*[W: static int] = object
            words*: array[W + 1, uint64]
            n*, ones*: int
        BPlusBitNode[B, W: static int] = object
            used: int
            size, ones: int32
            case leaf: bool
            of true:
                bits: BPlusPackedBits[W]
            of false:
                child: array[B + 1, int]
                sizes, counts: array[B + 1, int32]
        BPlusBitVector*[B, W: static int] = ref object
            nodes: seq[BPlusBitNode[B, W]]
            free: seq[int]
            root: int
            kernel: BPlusKernel

    proc lowMask(n: int): uint64 {.inline.} =
        ## 下位 n ビットを 1 にする。0 <= n < 64。
        (1'u64 shl n) - 1

    proc packedRank*[W](a: BPlusPackedBits[W], p: int, k: BPlusKernel): int {.inline.} =
        ## [0,p) の 1 の個数を O(W) で返す。
        int(packedRank(unsafeAddr a.words[0], cint(p), cint(if k == bpkAvx512: 3 elif k == bpkAvx2: 2 else: 1)))

    proc packedAccess*[W](a: BPlusPackedBits[W], p: int): bool {.inline.} =
        ## p 番目のビットを O(1) で返す。
        ((a.words[p shr 6] shr (p and 63)) and 1) != 0

    proc packedInsert*[W](a: var BPlusPackedBits[W], p: int, bit: bool, k = bpkScalar) =
        ## 葉内シフトを既存の検証済みscalar/AVX2/AVX-512 kernelで実行する。O(W)。
        packedInsert(addr a.words[0], cint(a.n), cint(p), cint(bit), cint(if k == bpkAvx512: 3 elif k == bpkAvx2: 2 else: 1))
        inc a.n
        a.ones+=int(bit)

    proc packedErase*[W](a: var BPlusPackedBits[W], p: int, k = bpkScalar): bool =
        ## 削除bitを保存し、既存の検証済みscalar/AVX2/AVX-512 kernelでシフトする。O(W)。
        result = a.packedAccess(p)
        packedErase(addr a.words[0], cint(a.n), cint(p), cint(if k == bpkAvx512: 3 elif k == bpkAvx2: 2 else: 1))
        dec a.n
        a.ones-=int(result)

    proc packedSlice*[W](a: BPlusPackedBits[W], first, length: int, k: BPlusKernel): BPlusPackedBits[W] =
        ## ビット区間をワード単位でコピーする。O(W)。
        result.n = length
        for i in 0..<(length + 63) div 64:
            let p = first + i*64
            let q = p shr 6
            let s = p and 63
            result.words[i] = a.words[q] shr s
            if s != 0 and q+1 < a.words.len:
                result.words[i] = result.words[i] or (a.words[q+1] shl (64-s))
        if (length and 63) != 0:
            result.words[length shr 6] = result.words[length shr 6] and lowMask(length and 63)
        result.ones = result.packedRank(length, k)

    proc packedJoin*[W](a, b: BPlusPackedBits[W], k: BPlusKernel): BPlusPackedBits[W] =
        ## 合計 64W+1 ビット以下の二列を O(W) で連結する。
        result = a
        for i in 0..<(b.n+63) div 64:
            let p = a.n+i*64
            let q = p shr 6
            let s = p and 63
            result.words[q] = result.words[q] or (b.words[i] shl s)
            if s != 0 and q+1 < result.words.len:
                result.words[q+1] = b.words[i] shr (64-s)
        result.n = a.n+b.n
        result.ones = a.ones+b.ones

    proc allocNode[B, W](t: BPlusBitVector[B, W], leaf: bool): int =
        ## プールの空きノードを再利用する。償却 O(1)。
        if t.free.len > 0:
            result = t.free.pop()

        else:
            result = t.nodes.len
            t.nodes.add(default(BPlusBitNode[B, W]))
        if leaf: t.nodes[result] = BPlusBitNode[B, W](leaf: true)
        else: t.nodes[result] = BPlusBitNode[B, W](leaf: false)

    proc rebuild[B, W](t: BPlusBitVector[B, W], v: int) =
        ## ノードの累積個数を子から再構築する。O(B)。
        if t.nodes[v].leaf:
            t.nodes[v].size = int32(t.nodes[v].bits.n)
            t.nodes[v].ones = int32(t.nodes[v].bits.ones)
        else:
            var n, s: int32
            for i in 0..<t.nodes[v].used:
                let c = t.nodes[v].child[i]
                n += t.nodes[c].size
                s += t.nodes[c].ones
                t.nodes[v].sizes[i] = n
                t.nodes[v].counts[i] = s
            t.nodes[v].size = n
            t.nodes[v].ones = s

    proc initBitVector*[B, W](T: typedesc[BPlusBitVector[B, W]], values: openArray[bool],
            kernel: BPlusKernel = bpkAuto): T =
        ## O(N) で構築する。B は偶数 4..32、W は 1..64（葉は 64W bit）。N <= int32.high。
        ## auto は B>=16,W>=16 で AVX2 が使える場合だけ AVX2、それ以外は scalar。
        static:
            assert B >= 4 and B <= 32 and B mod 2 == 0
            assert W >= 1 and W <= 64
        assert values.len <= int32.high.int
        let selected = if kernel == bpkAuto and B >= 16 and W >= 16 and kernelAvailable(bpkAvx2): bpkAvx2 else: resolveKernel(kernel)
        result = T(kernel: selected)
        var layer: seq[int]
        let count = max(1, (values.len+W*64-1) div (W*64))
        var p = 0
        for j in 0..<count:
            let v = result.allocNode(true)
            let n = values.len div count + int(j < values.len mod count)
            result.nodes[v].bits.n = n
            for i in 0..<n:
                if values[p+i]:
                    result.nodes[v].bits.words[i shr 6] = result.nodes[v].bits.words[i shr 6] or (1'u64 shl (i and 63))
                    inc result.nodes[v].bits.ones
            p += n
            result.rebuild(v)
            layer.add(v)
        while layer.len > 1:
            var next: seq[int]
            let groups = (layer.len+B-1) div B
            var p = 0
            for j in 0..<groups:
                let v = result.allocNode(false)
                let n = layer.len div groups + int(j < layer.len mod groups)
                result.nodes[v].used = n
                for i in 0..<n: result.nodes[v].child[i] = layer[p+i]
                p += n
                result.rebuild(v)
                next.add(v)
            layer = move(next)
        result.root = layer[0]

    proc activeKernel*[B, W](t: BPlusBitVector[B, W]): BPlusKernel =
        ## CPU と auto 方針を適用した実際の kernel を返す。
        t.kernel

    proc len*[B, W](t: BPlusBitVector[B, W]): int =
        ## ビット数を O(1) で返す。
        int(t.nodes[t.root].size)

    proc ones*[B, W](t: BPlusBitVector[B, W]): int =
        ## 1 の総数を O(1) で返す。
        int(t.nodes[t.root].ones)

    proc storageBytes*[B, W](t: BPlusBitVector[B, W]): int =
        ## プールの論理確保量。seq の余剰 capacity・ヘッダ・アロケータ領域は含まない。
        t.nodes.len*sizeof(BPlusBitNode[B, W]) + t.free.len*sizeof(int)

    proc rankAccess*[B, W](t: BPlusBitVector[B, W], p: int): tuple[rank: int, bit: bool] =
        ## [0,p) の 1 の個数と p のビットを O(B log_B(N/W)+W) で返す。p=N なら bit=false。
        assert p >= 0 and p <= t.len
        var p = p
        var v = t.root
        while not t.nodes[v].leaf:
            let j = min(t.nodes[v].used-1, prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, p, t.kernel))
            if j > 0:
                p -= int(t.nodes[v].sizes[j-1])
                result.rank += int(t.nodes[v].counts[j-1])
            v = t.nodes[v].child[j]
        result.rank += t.nodes[v].bits.packedRank(p, t.kernel)
        if p < t.nodes[v].bits.n: result.bit = t.nodes[v].bits.packedAccess(p)

    proc rank*[B, W](t: BPlusBitVector[B, W], p: int): int =
        ## [0,p) の 1 の個数を返す。
        t.rankAccess(p).rank

    proc rankFrom[B, W](t: BPlusBitVector[B, W], start, p: int): int =
        ## 部分木内のprefix rank。端点は集約済み個数で返す。
        var v = start
        var p = p
        if p == 0: return 0
        if p == int(t.nodes[v].size): return int(t.nodes[v].ones)
        while not t.nodes[v].leaf:
            let j = prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, p, t.kernel)
            if j > 0:
                p-=int(t.nodes[v].sizes[j-1])
                result+=int(t.nodes[v].counts[j-1])
            v = t.nodes[v].child[j]
        result+=t.nodes[v].bits.packedRank(p, t.kernel)

    proc rankPair*[B, W](t: BPlusBitVector[B, W], l, r: int): tuple[left, right: int] =
        ## 両端rankを同時に返す。共有探索経路と葉内popcountの重複を除く。O(B log_B(N/W)+W)。
        assert 0 <= l and l <= r and r <= t.len
        var v = t.root
        var l = l
        var r = r
        var before = 0
        while true:
            if l == r:
                let rank = before+t.rankFrom(v, l)
                return (rank, rank)
            if l == 0: return (before, before+t.rankFrom(v, r))
            if r == int(t.nodes[v].size): return (before+t.rankFrom(v, l), before+int(t.nodes[v].ones))
            if t.nodes[v].leaf: break
            let a = prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, l, t.kernel)
            let b = if r <= int(t.nodes[v].sizes[a]): a else: prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, r-1, t.kernel)
            let offset = if a == 0: 0 else: int(t.nodes[v].sizes[a-1])
            let count = if a == 0: 0 else: int(t.nodes[v].counts[a-1])
            if a != b:
                let offsetB = if b == 0: 0 else: int(t.nodes[v].sizes[b-1])
                let countB = if b == 0: 0 else: int(t.nodes[v].counts[b-1])
                return (before+count+t.rankFrom(t.nodes[v].child[a], l-offset),
                        before+countB+t.rankFrom(t.nodes[v].child[b], r-offsetB))
            before+=count
            l-=offset
            r-=offset
            v = t.nodes[v].child[a]
        result.left = before+t.nodes[v].bits.packedRank(l, t.kernel)
        let a = l shr 6
        let b = r shr 6
        var middle: int
        if a == b:
            middle = popcount(t.nodes[v].bits.words[a] and not lowMask(l and 63) and lowMask(r and 63))
        else:
            middle = popcount(t.nodes[v].bits.words[a] and not lowMask(l and 63))
            if b > a+1: middle+=wordPopcount(addr t.nodes[v].bits.words[a+1], b-a-1, t.kernel)
            middle+=popcount(t.nodes[v].bits.words[b] and lowMask(r and 63))
        result.right = result.left+middle

    proc `[]`*[B, W](t: BPlusBitVector[B, W], p: int): bool =
        ## p 番目のビットを返す。
        assert p >= 0 and p < t.len
        t.rankAccess(p).bit

    proc insertNode[B, W](t: BPlusBitVector[B, W], v, p: int, bit: bool,
            before: var int): int =
        ## 挿入し、分割した場合は右ノードを返す。分割なしは -1。
        result = -1
        if t.nodes[v].leaf:
            before += t.nodes[v].bits.packedRank(p, t.kernel)
            t.nodes[v].bits.packedInsert(p, bit, t.kernel)
            if t.nodes[v].bits.n > W*64:
                let right = t.allocNode(true)
                t.nodes[right].bits = t.nodes[v].bits.packedSlice(W*32, W*32+1, t.kernel)
                t.nodes[v].bits = t.nodes[v].bits.packedSlice(0, W*32, t.kernel)
                t.rebuild(right)
                result = right
            t.rebuild(v)
            return
        let j = min(t.nodes[v].used-1, prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, p, t.kernel))
        let offset = if j == 0: 0 else: int(t.nodes[v].sizes[j-1])
        if j > 0: before += int(t.nodes[v].counts[j-1])
        let right = t.insertNode(t.nodes[v].child[j], p-offset, bit, before)
        if right < 0:
            prefixAdd(addr t.nodes[v].sizes[j], t.nodes[v].used-j, 1, t.kernel)
            if bit: prefixAdd(addr t.nodes[v].counts[j], t.nodes[v].used-j, 1, t.kernel)
            inc t.nodes[v].size
            t.nodes[v].ones += int32(bit)
            return
        for i in countdown(t.nodes[v].used, j+2): t.nodes[v].child[i] = t.nodes[v].child[i-1]
        t.nodes[v].child[j+1] = right
        inc t.nodes[v].used
        if t.nodes[v].used > B:
            let r = t.allocNode(false)
            t.nodes[r].used = B+1-B div 2
            for i in 0..<t.nodes[r].used: t.nodes[r].child[i] = t.nodes[v].child[B div 2+i]
            t.nodes[v].used = B div 2
            t.rebuild(r)
            result = r
        t.rebuild(v)

    proc insert*[B, W](t: BPlusBitVector[B, W], p: int, bit: bool): int {.discardable.} =
        ## p に挿入し挿入前の rank(p) を返す。木内 O((B+W)(log_B(N/W)+1))、プール拡張は償却。
        ## 削除後もプールを再利用するため、メモリは過去最大長に比例する。
        assert 0 <= p and p <= t.len and t.len < int32.high.int
        let r = t.insertNode(t.root, p, bit, result)
        if r >= 0:
            let v = t.allocNode(false)
            t.nodes[v].used = 2
            t.nodes[v].child[0] = t.root
            t.nodes[v].child[1] = r
            t.rebuild(v)
            t.root = v

    proc underfull[B, W](t: BPlusBitVector[B, W], v: int): bool =
        ## 根以外の最小占有率を割ったか判定する。
        if t.nodes[v].leaf: t.nodes[v].bits.n < W*32 else: t.nodes[v].used < B div 2

    proc balancePair[B, W](t: BPlusBitVector[B, W], parent, j: int) =
        ## 隣接する子を結合または均等再配分する。O(B+W)。
        let a = t.nodes[parent].child[j]
        let b = t.nodes[parent].child[j+1]
        var merged = false
        if t.nodes[a].leaf:
            let n = t.nodes[a].bits.n + t.nodes[b].bits.n
            if n <= W*64:
                t.nodes[a].bits = packedJoin(t.nodes[a].bits, t.nodes[b].bits, t.kernel)
                merged = true
            else:
                let target = n div 2
                if t.nodes[a].bits.n < target:
                    let take = target-t.nodes[a].bits.n
                    let prefix = t.nodes[b].bits.packedSlice(0, take, t.kernel)
                    t.nodes[a].bits = packedJoin(t.nodes[a].bits, prefix, t.kernel)
                    t.nodes[b].bits = t.nodes[b].bits.packedSlice(take, n-target, t.kernel)
                else:
                    let suffix = t.nodes[a].bits.packedSlice(target, t.nodes[a].bits.n-target, t.kernel)
                    t.nodes[b].bits = packedJoin(suffix, t.nodes[b].bits, t.kernel)
                    t.nodes[a].bits = t.nodes[a].bits.packedSlice(0, target, t.kernel)
        else:
            var children: array[B*2, int]
            let na = t.nodes[a].used
            let n = na+t.nodes[b].used
            for i in 0..<na: children[i] = t.nodes[a].child[i]
            for i in 0..<t.nodes[b].used: children[na+i] = t.nodes[b].child[i]
            let target = if n <= B: n else: n div 2
            t.nodes[a].used = target
            for i in 0..<target: t.nodes[a].child[i] = children[i]
            t.nodes[b].used = n-target
            for i in 0..<n-target: t.nodes[b].child[i] = children[target+i]
            merged = n <= B
        t.rebuild(a)
        if merged:
            t.free.add(b)
            for i in j+1..<t.nodes[parent].used-1: t.nodes[parent].child[i] = t.nodes[parent].child[i+1]
            dec t.nodes[parent].used
        else:
            t.rebuild(b)
        t.rebuild(parent)

    proc eraseNode[B, W](t: BPlusBitVector[B, W], v, p: int): tuple[rank: int, bit: bool] =
        ## 削除前の rank とビットを返し、帰りがけに占有率を回復する。
        if t.nodes[v].leaf:
            result.rank = t.nodes[v].bits.packedRank(p, t.kernel)
            result.bit = t.nodes[v].bits.packedErase(p, t.kernel)
            t.rebuild(v)
            return
        let j = prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, p, t.kernel)
        let offset = if j == 0: 0 else: int(t.nodes[v].sizes[j-1])
        let count = if j == 0: 0 else: int(t.nodes[v].counts[j-1])
        let child = t.nodes[v].child[j]
        result = t.eraseNode(child, p-offset)
        result.rank += count
        if t.underfull(child) and t.nodes[v].used > 1:
            t.balancePair(v, min(j, t.nodes[v].used-2))
        else:
            prefixAdd(addr t.nodes[v].sizes[j], t.nodes[v].used-j, -1, t.kernel)
            if result.bit: prefixAdd(addr t.nodes[v].counts[j], t.nodes[v].used-j, -1, t.kernel)
            dec t.nodes[v].size
            t.nodes[v].ones -= int32(result.bit)

    proc erase*[B, W](t: BPlusBitVector[B, W], p: int): tuple[rank: int, bit: bool] {.discardable.} =
        ## p を削除し、削除前の rank とビットを返す。O(B log_B(N/W)+W)、プール管理は償却。
        assert 0 <= p and p < t.len
        result = t.eraseNode(t.root, p)
        if not t.nodes[t.root].leaf and t.nodes[t.root].used == 1:
            let old = t.root
            t.root = t.nodes[old].child[0]
            t.free.add(old)

    proc select*[B, W](t: BPlusBitVector[B, W], bit: bool, k: int): int =
        ## bit の k 番目(0 始まり)の位置。存在しなければ -1。O(B log_B(N/W)+W)。
        if k < 0 or k >= (if bit: t.ones else: t.len-t.ones): return -1
        var k = k
        var v = t.root
        while not t.nodes[v].leaf:
            var j = 0
            while j < t.nodes[v].used:
                let c = if bit: int(t.nodes[v].counts[j]) else: int(t.nodes[v].sizes[j]-t.nodes[v].counts[j])
                if c > k: break
                inc j
            if j > 0:
                let n = int(t.nodes[v].sizes[j-1])
                let s = int(t.nodes[v].counts[j-1])
                result += n
                k -= (if bit: s else: n-s)
            v = t.nodes[v].child[j]
        for j in 0..<(t.nodes[v].bits.n+63) div 64:
            var word = t.nodes[v].bits.words[j]
            if not bit: word = not word
            let remaining = t.nodes[v].bits.n-j*64
            if remaining < 64: word = word and lowMask(remaining)
            let count = popcount(word)
            if k < count:
                while k > 0:
                    word = word and (word-1)
                    dec k
                return result+j*64+countTrailingZeroBits(word)
            k -= count

    proc validate*[B, W](t: BPlusBitVector[B, W]) =
        ## 検証用にノードの占有率・高さ・累積個数・未使用ビットを O(N) で確認する。
        var seen = newSeq[bool](t.nodes.len)
        proc visit(v: int, root: bool): int =
            assert not seen[v]
            seen[v] = true
            if t.nodes[v].leaf:
                let a = t.nodes[v].bits
                assert a.n <= W*64 and (root or a.n >= W*32)
                assert a.ones == a.packedRank(a.n, t.kernel)
                assert t.nodes[v].size == int32(a.n) and t.nodes[v].ones == int32(a.ones)
                for i in a.n..<a.words.len*64: assert not a.packedAccess(i)
                return 0
            let n = t.nodes[v].used
            assert n <= B and n >= (if root: 2 else: B div 2)
            var size, ones: int32
            var height = -1
            for i in 0..<n:
                let child = t.nodes[v].child[i]
                let h = visit(child, false)
                if height < 0: height = h
                assert h == height
                size += t.nodes[child].size
                ones += t.nodes[child].ones
                assert t.nodes[v].sizes[i] == size and t.nodes[v].counts[i] == ones
            assert t.nodes[v].size == size and t.nodes[v].ones == ones
            return height+1
        discard visit(t.root, true)
        for v in t.free:
            assert not seen[v]
            seen[v] = true
        for x in seen: assert x
