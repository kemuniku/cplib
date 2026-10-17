when not declared CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_VECTOR:
    const CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_VECTOR* = 1
    import bitops
    import cplib/collections/dynamic_bplus_kernels
    import cplib/collections/dynamic_quaternary_kernels
    ## 2bit桁を詰めた葉と4種類の累積個数を持つB+木。64bit int、N<=int32.high。
    ## Bは偶数4..32、葉はWワード(1..128)、容量C=32W桁。根以外は常に半分以上を使用する。
    ## h=O(log_B(N/C+1)+1)。問い合わせO(Bh+W)、更新の木操作O((B+W)h)。
    ## seqプール再確保時は全ノードを移すので更新は償却。空きノードは再利用し、縮小しない。
    type
        QuadPacked[W: static int] = object
            words: array[W+1, uint64]
            n: int
            counts: array[4, int]
        QuadNode[B, W: static int] = object
            used: int
            size: int32
            totals: array[4, int32]
            case leaf: bool
            of true: bits: QuadPacked[W]
            of false:
                child: array[B+1, int]
                sizes: array[B+1, int32]
                counts: array[4, array[B+1, int32]]
        QuadVector*[B, W: static int] = ref object
            nodes: seq[QuadNode[B, W]]
            free: seq[int]
            root: int
            kernel: BPlusKernel
    proc quadMask(n: int): uint64 {.inline.} =
        ## 下位n bitを返す。0<=n<64。
        (1'u64 shl n)-1
    proc matches(word: uint64, d: int): uint64 {.inline.} =
        ## dと等しい2bit桁の下位bitだけを立てる。
        let x = word xor (0x5555555555555555'u64*uint64(d))
        not (x or (x shr 1)) and 0x5555555555555555'u64
    proc packedRank[W](a: QuadPacked[W], p, d: int, k: BPlusKernel): int {.inline.} =
        ## 2bit桁dのprefix rankをO(W)で返す。kは解決済み。
        if a.counts[d] == 0: return 0
        if a.counts[d] == a.n: return p
        int(quadRankRaw(unsafeAddr a.words[0], cint(p), cint(d), cint(ord(k)+1)))
    proc packedRanks[W](a: QuadPacked[W], p: int): array[4, int] =
        ## 全4桁のprefix rankを同じword走査で返す。O(W)。
        for d in 0..3:
            if a.counts[d] == a.n:
                result[d] = p
                return
        var counts: array[4, cint]
        quadRanksRaw(unsafeAddr a.words[0], cint(p), addr counts[0])
        for d in 0..3: result[d] = int(counts[d])
    proc packedRanksPair[W](a: QuadPacked[W], l, r: int): tuple[left, right: array[4, int]] =
        ## 全4桁の両端rankを共通wordの走査を共有して返す。O(W)。
        for d in 0..3:
            if a.counts[d] == a.n:
                result.left[d] = l
                result.right[d] = r
                return
        var left, right: array[4, cint]
        quadRanksPairRaw(unsafeAddr a.words[0], cint(l), cint(r), addr left[0], addr right[0])
        for d in 0..3:
            result.left[d] = int(left[d])
            result.right[d] = int(right[d])
    proc packedAccess[W](a: QuadPacked[W], p: int): int {.inline.} =
        ## p番目の2bit桁をO(1)で返す。
        int((a.words[p shr 5] shr (2*(p and 31))) and 3)
    proc packedInsert[W](a: var QuadPacked[W], p, d: int, k: BPlusKernel) =
        ## 2bitシフトし桁を挿入する。O(W)。
        quadInsertRaw(addr a.words[0], cint(a.n), cint(p), cint(d), cint(ord(k)+1))
        inc a.n
        inc a.counts[d]
    proc packedErase[W](a: var QuadPacked[W], p: int, k: BPlusKernel): int =
        ## 削除桁を返し2bitシフトする。O(W)。
        result = a.packedAccess(p)
        quadEraseRaw(addr a.words[0], cint(a.n), cint(p), cint(ord(k)+1))
        dec a.n
        dec a.counts[result]
    proc packedSlice[W](a: QuadPacked[W], first, length: int, k: BPlusKernel): QuadPacked[W] =
        ## 桁区間をワード単位で取り出す。O(W)。
        result.n = length
        for i in 0..<(length+31) div 32:
            let p = 2*first+i*64
            let q = p shr 6
            let shift = p and 63
            result.words[i] = a.words[q] shr shift
            if shift != 0 and q+1 < a.words.len: result.words[i] = result.words[i] or (a.words[q+1] shl (64-shift))
        if (length and 31) != 0: result.words[length shr 5] = result.words[length shr 5] and quadMask(2*(length and 31))
        result.counts = result.packedRanks(length)
    proc packedJoin[W](a, b: QuadPacked[W], k: BPlusKernel): QuadPacked[W] =
        ## 合計32W+1桁以下の2列をO(W)で連結する。
        result = a
        for i in 0..<(b.n+31) div 32:
            let p = 2*a.n+i*64
            let q = p shr 6
            let shift = p and 63
            result.words[q] = result.words[q] or (b.words[i] shl shift)
            if shift != 0 and q+1 < result.words.len: result.words[q+1] = b.words[i] shr (64-shift)
        result.n = a.n+b.n
        for d in 0..3: result.counts[d] = a.counts[d]+b.counts[d]
    proc allocNode[B, W](t: QuadVector[B, W], leaf: bool): int =
        ## プールの空きノードを再利用する。償却 O(1)。
        if t.free.len > 0:
            result = t.free.pop()

        else:
            result = t.nodes.len
            t.nodes.add(default(QuadNode[B, W]))
        if leaf: t.nodes[result] = QuadNode[B, W](leaf: true)
        else: t.nodes[result] = QuadNode[B, W](leaf: false)

    proc rebuild[B, W](t: QuadVector[B, W], v: int) =
        ## 子から長さと4桁の累積個数を再構築する。O(B)。
        if t.nodes[v].leaf:
            t.nodes[v].size = int32(t.nodes[v].bits.n)
            for d in 0..3: t.nodes[v].totals[d] = int32(t.nodes[v].bits.counts[d])
        else:
            var n: int32
            var counts: array[4, int32]
            for i in 0..<t.nodes[v].used:
                let c = t.nodes[v].child[i]
                n+=t.nodes[c].size
                t.nodes[v].sizes[i] = n
                for d in 0..3:
                    counts[d]+=t.nodes[c].totals[d]
                    t.nodes[v].counts[d][i] = counts[d]
            t.nodes[v].size = n
            t.nodes[v].totals = counts
    proc initQuadVector*[B, W](T: typedesc[QuadVector[B, W]], values: openArray[int],
            kernel: BPlusKernel = bpkAuto): T =
        ## O(N) で構築する。B は偶数 4..32、W は 1..128（葉は 32W桁、64W bit）。N <= int32.high。
        ## auto は B>=16,W>=16 で AVX2 が使える場合だけ AVX2、それ以外は scalar。
        static:
            assert B >= 4 and B <= 32 and B mod 2 == 0
            assert W >= 1 and W <= 128
        assert values.len <= int32.high.int
        let selected = if kernel == bpkAuto and B >= 16 and W >= 16 and kernelAvailable(bpkAvx2): bpkAvx2 else: resolveKernel(kernel)
        result = T(kernel: selected)
        var layer: seq[int]
        let count = max(1, (values.len+W*32-1) div (W*32))
        var p = 0
        for j in 0..<count:
            let v = result.allocNode(true)
            let n = values.len div count + int(j < values.len mod count)
            result.nodes[v].bits.n = n
            for i in 0..<n:
                let d = values[p+i]
                assert 0 <= d and d < 4
                result.nodes[v].bits.words[i shr 5] = result.nodes[v].bits.words[i shr 5] or (uint64(d) shl (2*(i and 31)))
                inc result.nodes[v].bits.counts[d]
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

    proc activeKernel*[B, W](t: QuadVector[B, W]): BPlusKernel =
        ## 実際のISAを返す。
        t.kernel
    proc len*[B, W](t: QuadVector[B, W]): int =
        ## 桁数をO(1)で返す。
        int(t.nodes[t.root].size)
    proc total*[B, W](t: QuadVector[B, W], d: int): int =
        ## 桁dの個数をO(1)で返す。
        assert 0 <= d and d < 4
        int(t.nodes[t.root].totals[d])
    proc storageBytes*[B, W](t: QuadVector[B, W]): int =
        ## pool論理長。余剰capacityとallocator領域を含まない。
        t.nodes.len*sizeof(QuadNode[B, W])+t.free.len*sizeof(int)
    proc rankAccessNode[B, W](t: QuadVector[B, W], v, p: int): tuple[rank, digit: int] =
        ## 値が分かってから帰り道でその桁のprefixを加算する。
        if t.nodes[v].leaf:
            result.digit = t.nodes[v].bits.packedAccess(p)
            result.rank = t.nodes[v].bits.packedRank(p, result.digit, t.kernel)
            return
        let j = prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, p, t.kernel)
        let offset = if j == 0: 0 else: int(t.nodes[v].sizes[j-1])
        result = t.rankAccessNode(t.nodes[v].child[j], p-offset)
        if j > 0: result.rank+=int(t.nodes[v].counts[result.digit][j-1])
    proc rankAccess*[B, W](t: QuadVector[B, W], p: int): tuple[rank, digit: int] =
        ## pの桁とその桁の[0,p)個数を返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p < t.len
        t.rankAccessNode(t.root, p)
    proc replaceRankNode[B, W](t: QuadVector[B, W], v, p, digit: int): tuple[oldDigit, oldRank, newRank: int] =
        ## 1回の降下で桁を置換し、旧桁と新旧rankを帰り道で累積する。
        if t.nodes[v].leaf:
            result.oldDigit = t.nodes[v].bits.packedAccess(p)
            if result.oldDigit == digit:
                result.oldRank = t.nodes[v].bits.packedRank(p, digit, t.kernel)
                result.newRank = result.oldRank
                return
            let counts = t.nodes[v].bits.packedRanks(p)
            result.oldRank = counts[result.oldDigit]
            result.newRank = counts[digit]
            t.nodes[v].bits.words[p shr 5] = t.nodes[v].bits.words[p shr 5] xor (uint64(result.oldDigit xor digit) shl (2*(p and 31)))
            dec t.nodes[v].bits.counts[result.oldDigit]
            inc t.nodes[v].bits.counts[digit]
            dec t.nodes[v].totals[result.oldDigit]
            inc t.nodes[v].totals[digit]
            return
        let j = prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, p, t.kernel)
        let offset = if j == 0: 0 else: int(t.nodes[v].sizes[j-1])
        result = t.replaceRankNode(t.nodes[v].child[j], p-offset, digit)
        if j > 0:
            result.oldRank+=int(t.nodes[v].counts[result.oldDigit][j-1])
            result.newRank+=int(t.nodes[v].counts[digit][j-1])
        if result.oldDigit != digit:
            prefixAdd(addr t.nodes[v].counts[result.oldDigit][j], t.nodes[v].used-j, -1, t.kernel)
            prefixAdd(addr t.nodes[v].counts[digit][j], t.nodes[v].used-j, 1, t.kernel)
            dec t.nodes[v].totals[result.oldDigit]
            inc t.nodes[v].totals[digit]
    proc replaceRank*[B, W](t: QuadVector[B, W], p, digit: int): tuple[oldDigit, oldRank, newRank: int] {.discardable.} =
        ## pをdigitへ置換し、旧桁と新旧桁の[0,p)rankを返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p < t.len and 0 <= digit and digit < 4
        if t.nodes[t.root].totals[digit] == t.nodes[t.root].size:
            return (digit, p, p)
        t.replaceRankNode(t.root, p, digit)
    proc `[]`*[B, W](t: QuadVector[B, W], p: int): int =
        ## p番目の桁を返す。
        t.rankAccess(p).digit
    proc rankFrom[B, W](t: QuadVector[B, W], start, p, d: int): int =
        ## 部分木から桁dのprefix rankを求める。
        var v = start
        var p = p
        if p == 0: return 0
        if p == int(t.nodes[v].size): return int(t.nodes[v].totals[d])
        while not t.nodes[v].leaf:
            let j = prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, p, t.kernel)
            if j > 0:
                p-=int(t.nodes[v].sizes[j-1])
                result+=int(t.nodes[v].counts[d][j-1])
            v = t.nodes[v].child[j]
        result+=t.nodes[v].bits.packedRank(p, d, t.kernel)
    proc rank*[B, W](t: QuadVector[B, W], p, d: int): int =
        ## 桁dの[0,p)個数を返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p <= t.len and 0 <= d and d < 4
        t.rankFrom(t.root, p, d)
    proc ranksFrom[B, W](t: QuadVector[B, W], start, p: int): array[4, int] =
        ## 部分木から全4桁のprefix rankを共有経路で求める。
        var p = p
        var v = start
        if p == 0: return
        if p == int(t.nodes[v].size):
            for d in 0..3: result[d] = int(t.nodes[v].totals[d])
            return
        while not t.nodes[v].leaf:
            let j = prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, p, t.kernel)
            if j > 0:
                p-=int(t.nodes[v].sizes[j-1])
                for d in 0..3: result[d]+=int(t.nodes[v].counts[d][j-1])
            v = t.nodes[v].child[j]
        let counts = t.nodes[v].bits.packedRanks(p)
        for d in 0..3: result[d]+=counts[d]
    proc ranks*[B, W](t: QuadVector[B, W], p: int): array[4, int] =
        ## 4桁のprefix rankを共有経路で返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p <= t.len
        t.ranksFrom(t.root, p)
    proc ranksPair*[B, W](t: QuadVector[B, W], l, r: int): tuple[left, right: array[4, int]] =
        ## 全4桁の両端rankで木の経路と葉のprefix走査を共有する。O(B log_B(N/W)+W)。
        assert 0 <= l and l <= r and r <= t.len
        var v = t.root
        var l = l
        var r = r
        var before: array[4, int]
        while true:
            if l == r:
                let a = t.ranksFrom(v, l)
                for d in 0..3:
                    result.left[d] = before[d]+a[d]
                    result.right[d] = result.left[d]
                return
            if l == 0:
                let b = t.ranksFrom(v, r)
                result.left = before
                for d in 0..3: result.right[d] = before[d]+b[d]
                return
            if r == int(t.nodes[v].size):
                let a = t.ranksFrom(v, l)
                for d in 0..3:
                    result.left[d] = before[d]+a[d]
                    result.right[d] = before[d]+int(t.nodes[v].totals[d])
                return
            if t.nodes[v].leaf:
                let a = t.nodes[v].bits.packedRanksPair(l, r)
                for d in 0..3:
                    result.left[d] = before[d]+a.left[d]
                    result.right[d] = before[d]+a.right[d]
                return
            let a = prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, l, t.kernel)
            let b = if r <= int(t.nodes[v].sizes[a]): a else: prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, r-1, t.kernel)
            let offset = if a == 0: 0 else: int(t.nodes[v].sizes[a-1])
            if a != b:
                let offsetB = int(t.nodes[v].sizes[b-1])
                let left = t.ranksFrom(t.nodes[v].child[a], l-offset)
                let right = t.ranksFrom(t.nodes[v].child[b], r-offsetB)
                for d in 0..3:
                    let count = if a == 0: 0 else: int(t.nodes[v].counts[d][a-1])
                    result.left[d] = before[d]+count+left[d]
                    result.right[d] = before[d]+int(t.nodes[v].counts[d][b-1])+right[d]
                return
            if a > 0:
                for d in 0..3: before[d]+=int(t.nodes[v].counts[d][a-1])
            l-=offset
            r-=offset
            v = t.nodes[v].child[a]
    proc rankPair*[B, W](t: QuadVector[B, W], l, r, d: int): tuple[left, right: int] =
        ## 同じ桁の両端rankで共有経路を一度だけ辿る。O(B log_B(N/W)+W)。
        assert 0 <= l and l <= r and r <= t.len and 0 <= d and d < 4
        var v = t.root
        var l = l
        var r = r
        var before = 0
        while true:
            if l == r:
                let a = before+t.rankFrom(v, l, d)
                return (a, a)
            if l == 0: return (before, before+t.rankFrom(v, r, d))
            if r == int(t.nodes[v].size): return (before+t.rankFrom(v, l, d), before+int(t.nodes[v].totals[d]))
            if t.nodes[v].leaf: break
            let a = prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, l, t.kernel)
            let b = if r <= int(t.nodes[v].sizes[a]): a else: prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, r-1, t.kernel)
            let offset = if a == 0: 0 else: int(t.nodes[v].sizes[a-1])
            let count = if a == 0: 0 else: int(t.nodes[v].counts[d][a-1])
            if a != b:
                let offsetB = if b == 0: 0 else: int(t.nodes[v].sizes[b-1])
                let countB = if b == 0: 0 else: int(t.nodes[v].counts[d][b-1])
                return (before+count+t.rankFrom(t.nodes[v].child[a], l-offset, d), before+countB+t.rankFrom(t.nodes[v].child[b], r-offsetB, d))
            before+=count
            l-=offset
            r-=offset
            v = t.nodes[v].child[a]
        result.left = before+t.nodes[v].bits.packedRank(l, d, t.kernel)
        result.right = before+t.nodes[v].bits.packedRank(r, d, t.kernel)
    proc insertNode[B, W](t: QuadVector[B, W], v, p: int, digit: int,
            before: var int): int =
        ## 挿入し、分割した場合は右ノードを返す。分割なしは -1。
        result = -1
        if t.nodes[v].leaf:
            before += t.nodes[v].bits.packedRank(p, digit, t.kernel)
            t.nodes[v].bits.packedInsert(p, digit, t.kernel)
            if t.nodes[v].bits.n > W*32:
                let right = t.allocNode(true)
                t.nodes[right].bits = t.nodes[v].bits.packedSlice(W*16, W*16+1, t.kernel)
                t.nodes[v].bits = t.nodes[v].bits.packedSlice(0, W*16, t.kernel)
                t.rebuild(right)
                result = right
            t.rebuild(v)
            return
        let j = min(t.nodes[v].used-1, prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, p, t.kernel))
        let offset = if j == 0: 0 else: int(t.nodes[v].sizes[j-1])
        if j > 0: before += int(t.nodes[v].counts[digit][j-1])
        let right = t.insertNode(t.nodes[v].child[j], p-offset, digit, before)
        if right < 0:
            prefixAdd(addr t.nodes[v].sizes[j], t.nodes[v].used-j, 1, t.kernel)
            prefixAdd(addr t.nodes[v].counts[digit][j], t.nodes[v].used-j, 1, t.kernel)
            inc t.nodes[v].size
            inc t.nodes[v].totals[digit]
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

    proc insert*[B, W](t: QuadVector[B, W], p: int, digit: int): int {.discardable.} =
        ## p に挿入し挿入前の rank(p) を返す。木内 O((B+W)(log_B(N/W)+1))、プール拡張は償却。
        ## 削除後もプールを再利用するため、メモリは過去最大長に比例する。
        assert 0 <= p and p <= t.len and t.len < int32.high.int and 0 <= digit and digit < 4
        let r = t.insertNode(t.root, p, digit, result)
        if r >= 0:
            let v = t.allocNode(false)
            t.nodes[v].used = 2
            t.nodes[v].child[0] = t.root
            t.nodes[v].child[1] = r
            t.rebuild(v)
            t.root = v

    proc underfull[B, W](t: QuadVector[B, W], v: int): bool =
        ## 根以外の最小占有率を割ったか判定する。
        if t.nodes[v].leaf: t.nodes[v].bits.n < W*16 else: t.nodes[v].used < B div 2

    proc balancePair[B, W](t: QuadVector[B, W], parent, j: int) =
        ## 隣接する子を結合または均等再配分する。O(B+W)。
        let a = t.nodes[parent].child[j]
        let b = t.nodes[parent].child[j+1]
        var merged = false
        if t.nodes[a].leaf:
            let n = t.nodes[a].bits.n + t.nodes[b].bits.n
            if n <= W*32:
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

    proc eraseNode[B, W](t: QuadVector[B, W], v, p: int): tuple[rank, digit: int] =
        ## 削除前の rank と桁を返し、帰りがけに占有率を回復する。
        if t.nodes[v].leaf:
            result.digit = t.nodes[v].bits.packedAccess(p)
            result.rank = t.nodes[v].bits.packedRank(p, result.digit, t.kernel)
            discard t.nodes[v].bits.packedErase(p, t.kernel)
            t.rebuild(v)
            return
        let j = prefixFind(addr t.nodes[v].sizes[0], t.nodes[v].used, p, t.kernel)
        let offset = if j == 0: 0 else: int(t.nodes[v].sizes[j-1])
        let child = t.nodes[v].child[j]
        result = t.eraseNode(child, p-offset)
        if j > 0: result.rank+=int(t.nodes[v].counts[result.digit][j-1])
        if t.underfull(child) and t.nodes[v].used > 1:
            t.balancePair(v, min(j, t.nodes[v].used-2))
        else:
            prefixAdd(addr t.nodes[v].sizes[j], t.nodes[v].used-j, -1, t.kernel)
            prefixAdd(addr t.nodes[v].counts[result.digit][j], t.nodes[v].used-j, -1, t.kernel)
            dec t.nodes[v].size
            dec t.nodes[v].totals[result.digit]

    proc erase*[B, W](t: QuadVector[B, W], p: int): tuple[rank, digit: int] {.discardable.} =
        ## p を削除し、削除前の rank と桁を返す。木操作O((B+W)(log_B(N/W)+1))、プール管理は償却。
        assert 0 <= p and p < t.len
        result = t.eraseNode(t.root, p)
        if not t.nodes[t.root].leaf and t.nodes[t.root].used == 1:
            let old = t.root
            t.root = t.nodes[old].child[0]
            t.free.add(old)

    proc select*[B, W](t: QuadVector[B, W], d, k: int): int =
        ## 桁dのk番目の位置。存在しなければ-1。O(B log_B(N/W)+W)。
        assert 0 <= d and d < 4
        if k < 0 or k >= t.total(d): return -1
        var k = k
        var v = t.root
        while not t.nodes[v].leaf:
            let j = prefixFind(addr t.nodes[v].counts[d][0], t.nodes[v].used, k, t.kernel)
            if j > 0:
                result+=int(t.nodes[v].sizes[j-1])
                k-=int(t.nodes[v].counts[d][j-1])
            v = t.nodes[v].child[j]
        for j in 0..<(t.nodes[v].bits.n+31) div 32:
            var word = matches(t.nodes[v].bits.words[j], d)
            let remaining = t.nodes[v].bits.n-j*32
            if remaining < 32: word = word and quadMask(remaining*2)
            let count = popcount(word)
            if k < count:
                while k > 0:
                    word = word and (word-1)
                    dec k
                return result+j*32+countTrailingZeroBits(word) div 2
            k-=count
    proc validate*[B, W](t: QuadVector[B, W]) =
        ## 占有率・累積数・高さ・未使用bit・poolを検査する。O(N)。
        var seen = newSeq[bool](t.nodes.len)
        proc visit(v: int, root: bool): int =
            assert not seen[v]
            seen[v] = true
            if t.nodes[v].leaf:
                let a = t.nodes[v].bits
                assert a.n <= W*32 and (root or a.n >= W*16)
                var actual: array[4, cint]
                quadRanksRaw(unsafeAddr a.words[0], cint(a.n), addr actual[0])
                for d in 0..3: assert a.counts[d] == int(actual[d])
                assert t.nodes[v].size == int32(a.n)
                for d in 0..3: assert t.nodes[v].totals[d] == int32(a.counts[d])
                for i in a.n..<a.words.len*32: assert a.packedAccess(i) == 0
                return 0
            let n = t.nodes[v].used
            assert n <= B and n >= (if root: 2 else: B div 2)
            var size: int32
            var counts: array[4, int32]
            var height = -1
            for i in 0..<n:
                let child = t.nodes[v].child[i]
                let h = visit(child, false)
                if height < 0: height = h
                assert h == height
                size+=t.nodes[child].size
                assert t.nodes[v].sizes[i] == size
                for d in 0..3:
                    counts[d]+=t.nodes[child].totals[d]
                    assert t.nodes[v].counts[d][i] == counts[d]
            assert t.nodes[v].size == size and t.nodes[v].totals == counts
            return height+1
        discard visit(t.root, true)
        for v in t.free:
            assert not seen[v]
            seen[v] = true
        for x in seen: assert x
