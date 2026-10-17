when not declared CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_VECTOR:
    const CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_VECTOR* = 1
    import bitops
    import cplib/collections/dynamic_bplus_kernels
    import cplib/collections/dynamic_quaternary_kernels
    ## 2bit桁を詰めた葉と4種類の累積個数を持つB+木。64bit int、N<=int32.high。
    ## Bは偶数4..32、葉はWワード(1..512)、容量C=32W桁。根以外は常に半分以上を使用する。
    ## h=O(log_B(N/C+1)+1)。問い合わせO(Bh+W)、更新の木操作O((B+W)h)。
    ## seqプール再確保時は全ノードを移すので更新は償却。空きノードは再利用し、縮小しない。
    ## quadOptimizedは六つの内部最適化を有効にする。葉prefixはquadLeafPrefixで別に選ぶ。
    ## 公開assertとoverflow/range検査は保持し、trustedは私有helperの添字・variant検査だけを省く。
    const quadPrefixWords* {.intdefine.} = 4
    static: assert quadPrefixWords >= 1 and quadPrefixWords <= 128
    type
        QuadPacked[W: static int] = object
            words: array[W+1, uint64]
            n: int
            counts: array[4, int]
            when defined(quadLeafPrefix):
                prefixes: array[W div quadPrefixWords+2, array[4, uint16]]
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
    proc quadFind(p: ptr int32, n, x: int, k: BPlusKernel): int {.inline.} =
        ## 累積配列の探索を選択した実装へ渡す。
        when defined(quadOptimized) or defined(quadFastFind):
            int(quadPrefixFindRaw(p, cint(n), cint(x), cint(ord(k)+1)))
        else:
            prefixFind(p, n, x, k)
    proc quadMask(n: int): uint64 {.inline.} =
        ## 下位n bitを返す。0<=n<64。
        (1'u64 shl n)-1
    proc matches(word: uint64, d: int): uint64 {.inline.} =
        ## dと等しい2bit桁の下位bitだけを立てる。
        let x = word xor (0x5555555555555555'u64*uint64(d))
        not (x or (x shr 1)) and 0x5555555555555555'u64
    proc rebuildPrefixes[W](a: var QuadPacked[W], word = 0) =
        ## 変更されたワード群から後の累積個数を再計算する。
        when defined(quadLeafPrefix):
            quadPrefixesRaw(addr a.words[0], cint(a.n), cint(word div quadPrefixWords), cint(quadPrefixWords), addr a.prefixes[0][0])
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc packedRank[W](a: QuadPacked[W], p, d: int, k: BPlusKernel): int {.inline.} =
        ## 2bit桁dのprefix rankをO(W)で返す。kは解決済み。
        if a.counts[d] == 0: return 0
        if a.counts[d] == a.n: return p
        when defined(quadLeafPrefix):
            let group = p div (32*quadPrefixWords)
            int(a.prefixes[group][d])+int(quadRankRaw(unsafeAddr a.words[group*quadPrefixWords], cint(p mod (32*quadPrefixWords)), cint(d), cint(ord(k)+1)))
        else:
            int(quadRankRaw(unsafeAddr a.words[0], cint(p), cint(d), cint(ord(k)+1)))
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc packedRanks[W](a: QuadPacked[W], p: int): array[4, int] =
        ## 全4桁のprefix rankを同じword走査で返す。prefix有効時は末尾群だけ走査。
        for d in 0..3:
            if a.counts[d] == a.n:
                result[d] = p
                return
        var counts: array[4, cint]
        when defined(quadLeafPrefix):
            let group = p div (32*quadPrefixWords)
            quadRanksRaw(unsafeAddr a.words[group*quadPrefixWords], cint(p mod (32*quadPrefixWords)), addr counts[0])
            for d in 0..3: result[d] = int(a.prefixes[group][d])+int(counts[d])
        else:
            quadRanksRaw(unsafeAddr a.words[0], cint(p), addr counts[0])
            for d in 0..3: result[d] = int(counts[d])
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc packedRanksPair[W](a: QuadPacked[W], l, r: int): tuple[left, right: array[4, int]] =
        ## 同じ群なら一度の走査で両端を取得する。
        for d in 0..3:
            if a.counts[d] == a.n:
                result.left[d] = l
                result.right[d] = r
                return
        var x, y: array[4, cint]
        when defined(quadLeafPrefix):
            let group = l div (32*quadPrefixWords)
            if group != r div (32*quadPrefixWords): return (a.packedRanks(l), a.packedRanks(r))
            quadRanksPairRaw(unsafeAddr a.words[group*quadPrefixWords], cint(l mod (32*quadPrefixWords)), cint(r mod (32*quadPrefixWords)), addr x[0], addr y[0])
            for d in 0..3:
                result.left[d] = int(a.prefixes[group][d])+int(x[d])
                result.right[d] = int(a.prefixes[group][d])+int(y[d])
        else:
            quadRanksPairRaw(unsafeAddr a.words[0], cint(l), cint(r), addr x[0], addr y[0])
            for d in 0..3:
                result.left[d] = int(x[d])
                result.right[d] = int(y[d])
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc packedAccess[W](a: QuadPacked[W], p: int): int {.inline.} =
        ## p番目の2bit桁をO(1)で返す。
        int((a.words[p shr 5] shr (2*(p and 31))) and 3)
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc finishPrefixes[W](a: var QuadPacked[W]) =
        ## 最後の端数群の末尾には列全体の個数を保存する。
        when defined(quadLeafPrefix):
            let last = (a.n+32*quadPrefixWords-1) div (32*quadPrefixWords)
            for d in 0..3: a.prefixes[last][d] = uint16(a.counts[d])
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc packedInsert[W](a: var QuadPacked[W], p, d: int, k: BPlusKernel) =
        ## 群境界から押し出される1桁だけを引き、prefixを差分更新する。
        when defined(quadLeafPrefix):
            for j in p div (32*quadPrefixWords)+1..(a.n+1) div (32*quadPrefixWords):
                let boundary = j*32*quadPrefixWords
                if boundary <= a.n:
                    dec a.prefixes[j][a.packedAccess(boundary-1)]
                    inc a.prefixes[j][d]
                else:
                    for x in 0..3: a.prefixes[j][x] = uint16(a.counts[x]+int(x == d))
        quadInsertRaw(addr a.words[0], cint(a.n), cint(p), cint(d), cint(ord(k)+1))
        inc a.n
        inc a.counts[d]
        a.finishPrefixes()
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc packedErase[W](a: var QuadPacked[W], p: int, k: BPlusKernel): int =
        ## 群境界へ入る1桁だけを足し、prefixを差分更新する。
        result = a.packedAccess(p)
        when defined(quadLeafPrefix):
            for j in p div (32*quadPrefixWords)+1..(a.n-1) div (32*quadPrefixWords):
                dec a.prefixes[j][result]
                inc a.prefixes[j][a.packedAccess(j*32*quadPrefixWords)]
        quadEraseRaw(addr a.words[0], cint(a.n), cint(p), cint(ord(k)+1))
        dec a.n
        dec a.counts[result]
        a.finishPrefixes()
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
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
        result.rebuildPrefixes()
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
        result.rebuildPrefixes(a.n shr 5)
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
        ## O(N) で構築する。B は偶数 4..32、W は 1..512（葉は 32W桁、64W bit）。N <= int32.high。
        ## auto は B>=16,W>=16 で AVX2 が使える場合だけ AVX2、それ以外は scalar。
        static:
            assert B >= 4 and B <= 32 and B mod 2 == 0
            assert W >= 1 and W <= 512
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
            result.nodes[v].bits.rebuildPrefixes()
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
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc rankAccessNode[B, W](t: QuadVector[B, W], v, p: int): tuple[rank, digit: int] =
        ## 値が分かってから帰り道でその桁のprefixを加算する。
        when defined(quadOptimized) or defined(quadNodePointers):
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when defined(quadOptimized) or defined(quadNodePointers): node[]
            else: t.nodes[v]
        if currentNode().leaf:
            result.digit = currentNode().bits.packedAccess(p)
            result.rank = currentNode().bits.packedRank(p, result.digit, t.kernel)
            return
        let j = quadFind(addr currentNode().sizes[0], currentNode().used, p, t.kernel)
        let offset = if j == 0: 0 else: int(currentNode().sizes[j-1])
        result = t.rankAccessNode(currentNode().child[j], p-offset)
        if j > 0: result.rank+=int(currentNode().counts[result.digit][j-1])
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
    proc rankAccess*[B, W](t: QuadVector[B, W], p: int): tuple[rank, digit: int] =
        ## pの桁とその桁の[0,p)個数を返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p < t.len
        t.rankAccessNode(t.root, p)
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc replaceRankNode[B, W](t: QuadVector[B, W], v, p, digit: int): tuple[oldDigit, oldRank, newRank: int] =
        ## 1回の降下で桁を置換し、旧桁と新旧rankを帰り道で累積する。
        when defined(quadOptimized) or defined(quadNodePointers):
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when defined(quadOptimized) or defined(quadNodePointers): node[]
            else: t.nodes[v]
        if currentNode().leaf:
            result.oldDigit = currentNode().bits.packedAccess(p)
            if result.oldDigit == digit:
                result.oldRank = currentNode().bits.packedRank(p, digit, t.kernel)
                result.newRank = result.oldRank
                return
            let counts = currentNode().bits.packedRanks(p)
            result.oldRank = counts[result.oldDigit]
            result.newRank = counts[digit]
            currentNode().bits.words[p shr 5] = currentNode().bits.words[p shr 5] xor (uint64(result.oldDigit xor digit) shl (2*(p and 31)))
            dec currentNode().bits.counts[result.oldDigit]
            inc currentNode().bits.counts[digit]
            when defined(quadLeafPrefix):
                for j in p div (32*quadPrefixWords)+1..(currentNode().bits.n+32*quadPrefixWords-1) div (32*quadPrefixWords):
                    dec currentNode().bits.prefixes[j][result.oldDigit]
                    inc currentNode().bits.prefixes[j][digit]
            dec currentNode().totals[result.oldDigit]
            inc currentNode().totals[digit]
            return
        let j = quadFind(addr currentNode().sizes[0], currentNode().used, p, t.kernel)
        let offset = if j == 0: 0 else: int(currentNode().sizes[j-1])
        result = t.replaceRankNode(currentNode().child[j], p-offset, digit)
        if j > 0:
            result.oldRank+=int(currentNode().counts[result.oldDigit][j-1])
            result.newRank+=int(currentNode().counts[digit][j-1])
        if result.oldDigit != digit:
            prefixAdd(addr currentNode().counts[result.oldDigit][j], currentNode().used-j, -1, t.kernel)
            prefixAdd(addr currentNode().counts[digit][j], currentNode().used-j, 1, t.kernel)
            dec currentNode().totals[result.oldDigit]
            inc currentNode().totals[digit]
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
    proc replaceRank*[B, W](t: QuadVector[B, W], p, digit: int): tuple[oldDigit, oldRank, newRank: int] {.discardable.} =
        ## pをdigitへ置換し、旧桁と新旧桁の[0,p)rankを返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p < t.len and 0 <= digit and digit < 4
        if t.nodes[t.root].totals[digit] == t.nodes[t.root].size:
            return (digit, p, p)
        t.replaceRankNode(t.root, p, digit)
    proc `[]`*[B, W](t: QuadVector[B, W], p: int): int =
        ## p番目の桁を返す。
        t.rankAccess(p).digit
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc rankFrom[B, W](t: QuadVector[B, W], start, p, d: int): int =
        ## 部分木から桁dのprefix rankを求める。
        var v = start
        when defined(quadOptimized) or defined(quadNodePointers):
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when defined(quadOptimized) or defined(quadNodePointers): node[]
            else: t.nodes[v]
        var p = p
        if p == 0: return 0
        if p == int(currentNode().size): return int(currentNode().totals[d])
        while not currentNode().leaf:
            let j = quadFind(addr currentNode().sizes[0], currentNode().used, p, t.kernel)
            if j > 0:
                p-=int(currentNode().sizes[j-1])
                result+=int(currentNode().counts[d][j-1])
            v = currentNode().child[j]
            when defined(quadOptimized) or defined(quadNodePointers): node = addr t.nodes[v]
        result+=currentNode().bits.packedRank(p, d, t.kernel)
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
    proc rank*[B, W](t: QuadVector[B, W], p, d: int): int =
        ## 桁dの[0,p)個数を返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p <= t.len and 0 <= d and d < 4
        t.rankFrom(t.root, p, d)
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc ranksFrom[B, W](t: QuadVector[B, W], start, p: int): array[4, int] =
        ## 4桁のprefix rankを共有経路で返す。O(B log_B(N/W)+W)。
        var p = p
        var v = start
        when defined(quadOptimized) or defined(quadNodePointers):
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when defined(quadOptimized) or defined(quadNodePointers): node[]
            else: t.nodes[v]
        if p == 0: return
        if p == int(currentNode().size):
            for d in 0..3: result[d] = int(currentNode().totals[d])
            return
        while not currentNode().leaf:
            let j = quadFind(addr currentNode().sizes[0], currentNode().used, p, t.kernel)
            if j > 0:
                p-=int(currentNode().sizes[j-1])
                for d in 0..3: result[d]+=int(currentNode().counts[d][j-1])
            v = currentNode().child[j]
            when defined(quadOptimized) or defined(quadNodePointers): node = addr t.nodes[v]
        let counts = currentNode().bits.packedRanks(p)
        for d in 0..3: result[d]+=counts[d]
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
    proc ranks*[B, W](t: QuadVector[B, W], p: int): array[4, int] =
        ## 4桁のprefix rankを共有経路で返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p <= t.len
        t.ranksFrom(t.root, p)
    proc ranksPair*[B, W](t: QuadVector[B, W], l, r: int): tuple[left, right: array[4, int]] =
        ## 全4桁の両端rankで木の経路と葉のprefix走査を共有する。O(B log_B(N/W)+W)。
        assert 0 <= l and l <= r and r <= t.len
        var v = t.root
        when defined(quadOptimized) or defined(quadNodePointers):
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when defined(quadOptimized) or defined(quadNodePointers): node[]
            else: t.nodes[v]
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
            if r == int(currentNode().size):
                let a = t.ranksFrom(v, l)
                for d in 0..3:
                    result.left[d] = before[d]+a[d]
                    result.right[d] = before[d]+int(currentNode().totals[d])
                return
            if currentNode().leaf:
                let a = currentNode().bits.packedRanksPair(l, r)
                for d in 0..3:
                    result.left[d] = before[d]+a.left[d]
                    result.right[d] = before[d]+a.right[d]
                return
            let a = quadFind(addr currentNode().sizes[0], currentNode().used, l, t.kernel)
            let b = if r <= int(currentNode().sizes[a]): a else: quadFind(addr currentNode().sizes[0], currentNode().used, r-1, t.kernel)
            let offset = if a == 0: 0 else: int(currentNode().sizes[a-1])
            if a != b:
                let offsetB = int(currentNode().sizes[b-1])
                let left = t.ranksFrom(currentNode().child[a], l-offset)
                let right = t.ranksFrom(currentNode().child[b], r-offsetB)
                for d in 0..3:
                    let count = if a == 0: 0 else: int(currentNode().counts[d][a-1])
                    result.left[d] = before[d]+count+left[d]
                    result.right[d] = before[d]+int(currentNode().counts[d][b-1])+right[d]
                return
            if a > 0:
                for d in 0..3: before[d]+=int(currentNode().counts[d][a-1])
            l-=offset
            r-=offset
            v = currentNode().child[a]
            when defined(quadOptimized) or defined(quadNodePointers): node = addr t.nodes[v]
    proc rankPair*[B, W](t: QuadVector[B, W], l, r, d: int): tuple[left, right: int] =
        ## 同じ桁の両端rankで共有経路を一度だけ辿る。O(B log_B(N/W)+W)。
        assert 0 <= l and l <= r and r <= t.len and 0 <= d and d < 4
        var v = t.root
        when defined(quadOptimized) or defined(quadNodePointers):
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when defined(quadOptimized) or defined(quadNodePointers): node[]
            else: t.nodes[v]
        var l = l
        var r = r
        var before = 0
        while true:
            if l == r:
                let a = before+t.rankFrom(v, l, d)
                return (a, a)
            if l == 0: return (before, before+t.rankFrom(v, r, d))
            if r == int(currentNode().size): return (before+t.rankFrom(v, l, d), before+int(currentNode().totals[d]))
            if currentNode().leaf: break
            let a = quadFind(addr currentNode().sizes[0], currentNode().used, l, t.kernel)
            let b = if r <= int(currentNode().sizes[a]): a else: quadFind(addr currentNode().sizes[0], currentNode().used, r-1, t.kernel)
            let offset = if a == 0: 0 else: int(currentNode().sizes[a-1])
            let count = if a == 0: 0 else: int(currentNode().counts[d][a-1])
            if a != b:
                let offsetB = if b == 0: 0 else: int(currentNode().sizes[b-1])
                let countB = if b == 0: 0 else: int(currentNode().counts[d][b-1])
                return (before+count+t.rankFrom(currentNode().child[a], l-offset, d), before+countB+t.rankFrom(currentNode().child[b], r-offsetB, d))
            before+=count
            l-=offset
            r-=offset
            v = currentNode().child[a]
            when defined(quadOptimized) or defined(quadNodePointers): node = addr t.nodes[v]
        result.left = before+currentNode().bits.packedRank(l, d, t.kernel)
        result.right = before+currentNode().bits.packedRank(r, d, t.kernel)
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc addSizeCount[B, W](t: QuadVector[B, W], v, j, digit, delta: int) {.inline.} =
        ## 長さと一種類の累積個数をまとめて更新する。
        when defined(quadOptimized) or defined(quadFusedPrefixUpdate):
            quadPrefixAddPairRaw(addr t.nodes[v].sizes[j], addr t.nodes[v].counts[digit][j], cint(t.nodes[v].used-j), cint(delta), cint(ord(t.kernel)+1))
        else:
            prefixAdd(addr t.nodes[v].sizes[j], t.nodes[v].used-j, delta, t.kernel)
            prefixAdd(addr t.nodes[v].counts[digit][j], t.nodes[v].used-j, delta, t.kernel)
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc insertNode[B, W](t: QuadVector[B, W], v, p: int, digit: int,
            before: var int): int =
        ## 挿入し、分割した場合は右ノードを返す。分割なしは -1。
        when defined(quadOptimized) or defined(quadNodePointers):
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when defined(quadOptimized) or defined(quadNodePointers): node[]
            else: t.nodes[v]
        result = -1
        if currentNode().leaf:
            before += currentNode().bits.packedRank(p, digit, t.kernel)
            currentNode().bits.packedInsert(p, digit, t.kernel)
            if currentNode().bits.n > W*32:
                let right = t.allocNode(true)
                when defined(quadOptimized) or defined(quadNodePointers): node = addr t.nodes[v]
                t.nodes[right].bits = currentNode().bits.packedSlice(W*16, W*16+1, t.kernel)
                currentNode().bits = currentNode().bits.packedSlice(0, W*16, t.kernel)
                t.rebuild(right)
                result = right
            when defined(quadOptimized) or defined(quadDirectLeafCounts):
                if result < 0:
                    inc currentNode().size
                    inc currentNode().totals[digit]
                else: t.rebuild(v)
            else: t.rebuild(v)
            return
        let j = min(currentNode().used-1, quadFind(addr currentNode().sizes[0], currentNode().used, p, t.kernel))
        let offset = if j == 0: 0 else: int(currentNode().sizes[j-1])
        if j > 0: before += int(currentNode().counts[digit][j-1])
        let right = t.insertNode(currentNode().child[j], p-offset, digit, before)
        when defined(quadOptimized) or defined(quadNodePointers): node = addr t.nodes[v]
        if right < 0:
            t.addSizeCount(v, j, digit, 1)
            inc currentNode().size
            inc currentNode().totals[digit]
            return
        for i in countdown(currentNode().used, j+2): currentNode().child[i] = currentNode().child[i-1]
        currentNode().child[j+1] = right
        inc currentNode().used
        if currentNode().used > B:
            let r = t.allocNode(false)
            when defined(quadOptimized) or defined(quadNodePointers): node = addr t.nodes[v]
            t.nodes[r].used = B+1-B div 2
            for i in 0..<t.nodes[r].used: t.nodes[r].child[i] = currentNode().child[B div 2+i]
            currentNode().used = B div 2
            t.rebuild(r)
            result = r
        t.rebuild(v)
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
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

    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.push boundChecks: off, fieldChecks: off.}
    proc eraseNode[B, W](t: QuadVector[B, W], v, p: int): tuple[rank, digit: int] =
        ## 削除前の rank と桁を返し、帰りがけに占有率を回復する。
        when defined(quadOptimized) or defined(quadNodePointers):
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when defined(quadOptimized) or defined(quadNodePointers): node[]
            else: t.nodes[v]
        if currentNode().leaf:
            result.digit = currentNode().bits.packedAccess(p)
            result.rank = currentNode().bits.packedRank(p, result.digit, t.kernel)
            discard currentNode().bits.packedErase(p, t.kernel)
            when defined(quadOptimized) or defined(quadDirectLeafCounts):
                dec currentNode().size
                dec currentNode().totals[result.digit]
            else: t.rebuild(v)
            return
        let j = quadFind(addr currentNode().sizes[0], currentNode().used, p, t.kernel)
        let offset = if j == 0: 0 else: int(currentNode().sizes[j-1])
        let child = currentNode().child[j]
        result = t.eraseNode(child, p-offset)
        if j > 0: result.rank+=int(currentNode().counts[result.digit][j-1])
        if t.underfull(child) and currentNode().used > 1:
            t.balancePair(v, min(j, currentNode().used-2))
        else:
            t.addSizeCount(v, j, result.digit, -1)
            dec currentNode().size
            dec currentNode().totals[result.digit]
    when defined(quadOptimized) or defined(quadTrustedInternals):
        {.pop.}
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
        when defined(quadOptimized) or defined(quadNodePointers):
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when defined(quadOptimized) or defined(quadNodePointers): node[]
            else: t.nodes[v]
        while not currentNode().leaf:
            let j = quadFind(addr currentNode().counts[d][0], currentNode().used, k, t.kernel)
            if j > 0:
                result+=int(currentNode().sizes[j-1])
                k-=int(currentNode().counts[d][j-1])
            v = currentNode().child[j]
            when defined(quadOptimized) or defined(quadNodePointers): node = addr t.nodes[v]
        for j in 0..<(currentNode().bits.n+31) div 32:
            var word = matches(currentNode().bits.words[j], d)
            let remaining = currentNode().bits.n-j*32
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
                when defined(quadLeafPrefix):
                    for blockIndex in 0..a.n div (32*quadPrefixWords):
                        var expected: array[4, cint]
                        quadRanksRaw(unsafeAddr a.words[0], cint(blockIndex*32*quadPrefixWords), addr expected[0])
                        for d in 0..3: assert int(a.prefixes[blockIndex][d]) == int(expected[d])
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
