when not declared CPLIB_COLLECTIONS_DYNAMIC_BPLUS_SUM:
    const CPLIB_COLLECTIONS_DYNAMIC_BPLUS_SUM* = 1
    ## 挿入・削除できるint列の区間和。葉は値の代わりに累積和を保持する。
    ## B=sumBranch、C=sumCapacity、h=O(log_B(N/C+1)+1)。問合せO(Bh)、更新O((B+C)h)償却。
    ## 保持する累積和・演算途中の和・差はintに収まる必要がある。
    ## 削除後の空きノードは再利用する。領域は過去最大長に比例する。
    import cplib/collections/dynamic_bplus_kernels
    when not compileOption("overflowChecks") and sizeof(int) == 8:
        import cplib/collections/dynamic_bplus_sum_kernels
    const sumBranch {.intdefine.} = 48
    const sumCapacity {.intdefine.} = 128
    static:
        assert sumBranch >= 4 and sumBranch <= 64 and sumBranch mod 2 == 0
        assert sumCapacity >= 4 and sumCapacity mod 2 == 0
    type
        SumNode = object
            used, size: int
            total: int
            case leaf: bool
            of true:
                prefix: array[sumCapacity+2, int]
            of false:
                child: array[sumBranch+1, int]
                sizes: array[sumBranch+1, int32]
                sums: array[sumBranch+1, int]
        DynamicBPlusSum* = ref object
            nodes: seq[SumNode]
            free: seq[int]
            root: int
            kernel: BPlusKernel
            cachedLeaves, cachedStarts, cachedEnds: array[2, int]
            cacheNext: int

    proc clearCache(t: DynamicBPlusSum) {.inline.} =
        ## 更新で位置が変わるため、直近の葉の位置キャッシュを無効化する。
        t.cachedEnds[0] = 0
        t.cachedEnds[1] = 0

    proc allocNode(t: DynamicBPlusSum, leaf: bool): int =
        ## 空きノードを再利用する。プール拡張は償却O(1)。
        if t.free.len > 0: result = t.free.pop()
        else:
            result = t.nodes.len
            t.nodes.add(default(SumNode))
        if leaf: t.nodes[result] = SumNode(leaf: true)
        else: t.nodes[result] = SumNode(leaf: false)

    proc rebuild(t: DynamicBPlusSum, v: int) =
        ## 葉または子の累積情報から長さと総和を再構築する。O(B)。
        if t.nodes[v].leaf:
            t.nodes[v].size = t.nodes[v].used
            t.nodes[v].total = t.nodes[v].prefix[t.nodes[v].used]
        else:
            var size, total: int
            for j in 0..<t.nodes[v].used:
                let c = t.nodes[v].child[j]
                size += t.nodes[c].size
                total += t.nodes[c].total
                t.nodes[v].sizes[j] = int32(size)
                t.nodes[v].sums[j] = total
            t.nodes[v].size = size
            t.nodes[v].total = total

    proc initDynamicBPlusSum*(values: openArray[int]): DynamicBPlusSum =
        ## 葉・内部ノードを均等に詰めてO(N)で構築する。
        assert values.len <= int32.high.int
        result = DynamicBPlusSum(kernel: resolveKernel(bpkAvx2))
        let count = max(1, (values.len+sumCapacity-1) div sumCapacity)
        var layer: seq[int]
        var p = 0
        for j in 0..<count:
            let v = result.allocNode(true)
            let n = values.len div count + int(j < values.len mod count)
            result.nodes[v].used = n
            for i in 0..<n:
                result.nodes[v].prefix[i+1] = result.nodes[v].prefix[i]+values[p+i]
            p += n
            result.rebuild(v)
            layer.add(v)
        while layer.len > 1:
            let count = (layer.len+sumBranch-1) div sumBranch
            var next: seq[int]
            var p = 0
            for j in 0..<count:
                let v = result.allocNode(false)
                let n = layer.len div count + int(j < layer.len mod count)
                result.nodes[v].used = n
                for i in 0..<n: result.nodes[v].child[i] = layer[p+i]
                p += n
                result.rebuild(v)
                next.add(v)
            layer = move(next)
        result.root = layer[0]

    proc len*(t: DynamicBPlusSum): int =
        ## 要素数をO(1)で返す。
        t.nodes[t.root].size

    proc storageBytes*(t: DynamicBPlusSum): int =
        ## プールの論理確保量。capacityとallocator領域は含まない。
        t.nodes.len*sizeof(SumNode)+t.free.len*sizeof(int)

    proc findChild(t: DynamicBPlusSum, v, p: int): int {.inline.} =
        ## pを含む子をO(B)で返す。末尾への挿入は最後の子を使う。
        min(t.nodes[v].used-1, prefixFind(unsafeAddr t.nodes[v].sizes[0], t.nodes[v].used, p, t.kernel))

    proc prefixFrom(t: DynamicBPlusSum, v, p: int): int =
        ## 指定した部分木の先頭p個の和をO(Bh)で返す。
        var v = v
        var p = p
        while p > 0:
            if p == t.nodes[v].size: return result+t.nodes[v].total
            if t.nodes[v].leaf: return result+t.nodes[v].prefix[p]
            let j = t.findChild(v, p)
            if j > 0:
                p -= int(t.nodes[v].sizes[j-1])
                result += t.nodes[v].sums[j-1]
            v = t.nodes[v].child[j]

    proc range_sum*(t: DynamicBPlusSum, l, r: int): int =
        ## 共通経路を一度だけ降下し、[l,r)の和をO(Bh)で返す。
        assert 0 <= l and l <= r and r <= t.len
        if l == r: return 0
        for j in 0..1:
            if t.cachedStarts[j] <= l and r <= t.cachedEnds[j]:
                let leaf = t.cachedLeaves[j]
                let start = t.cachedStarts[j]
                return t.nodes[leaf].prefix[r-start]-t.nodes[leaf].prefix[l-start]
        let originalL = l
        var v = t.root
        var l = l
        var r = r
        while true:
            if l == 0 and r == t.nodes[v].size: return t.nodes[v].total
            if t.nodes[v].leaf:
                let j = t.cacheNext
                t.cachedLeaves[j] = v
                t.cachedStarts[j] = originalL-l
                t.cachedEnds[j] = originalL-l+t.nodes[v].used
                t.cacheNext = j xor 1
                return t.nodes[v].prefix[r]-t.nodes[v].prefix[l]
            let a = t.findChild(v, l)
            let b = t.findChild(v, r-1)
            let offset = if a == 0: 0 else: int(t.nodes[v].sizes[a-1])
            if a != b:
                let before = if a == 0: 0 else: t.nodes[v].sums[a-1]
                result = t.nodes[v].sums[b-1]-before
                result -= t.prefixFrom(t.nodes[v].child[a], l-offset)
                result += t.prefixFrom(t.nodes[v].child[b], r-int(t.nodes[v].sizes[b-1]))
                return
            l -= offset
            r -= offset
            v = t.nodes[v].child[a]

    proc adjust(t: DynamicBPlusSum, v, first, last, sizeDelta, old, value: int) {.inline.} =
        ## 内部ノードの指定した累積範囲へ長さと和の差分を同時に反映する。
        when compileOption("overflowChecks") or sizeof(int) != 8:
            for j in first..<last:
                t.nodes[v].sizes[j] += int32(sizeDelta)
                t.nodes[v].sums[j] = t.nodes[v].sums[j]-old+value
        else:
            sumAdjustRaw(addr t.nodes[v].sizes[first], cast[ptr uint64](addr t.nodes[v].sums[first]),
                cint(last-first), cint(sizeDelta), cast[uint64](value)-cast[uint64](old), cint(t.kernel == bpkAvx2))

    proc replaceNode(t: DynamicBPlusSum, v, p, x: int): int =
        ## 一点を置換し旧値を返す。差分自体がintを越えないよう減算・加算を分ける。
        if t.nodes[v].leaf:
            result = t.nodes[v].prefix[p+1]-t.nodes[v].prefix[p]
            if result == x: return
            when compileOption("overflowChecks") or sizeof(int) != 8:
                for i in p+1..t.nodes[v].used:
                    t.nodes[v].prefix[i] = t.nodes[v].prefix[i]-result+x
            else:
                sumShiftRaw(cast[ptr uint64](addr t.nodes[v].prefix[p+1]), cint(t.nodes[v].used-p), cast[uint64](x)-cast[uint64](result), 0, cint(t.kernel == bpkAvx2))
        else:
            let j = t.findChild(v, p)
            let offset = if j == 0: 0 else: int(t.nodes[v].sizes[j-1])
            result = t.replaceNode(t.nodes[v].child[j], p-offset, x)
            if result == x: return
            t.adjust(v, j, t.nodes[v].used, 0, result, x)
        t.nodes[v].total = t.nodes[v].total-result+x

    proc `[]=`*(t: DynamicBPlusSum, p, x: int) =
        ## p番目をxに置換する。O(Bh+C)。
        assert 0 <= p and p < t.len
        t.clearCache()
        discard t.replaceNode(t.root, p, x)

    proc replace*(t: DynamicBPlusSum, p, x: int): int =
        ## 一点を置換して旧値を返す。O(Bh+C)。
        assert 0 <= p and p < t.len
        t.clearCache()
        t.replaceNode(t.root, p, x)

    proc insertNode(t: DynamicBPlusSum, v, p, x: int): int =
        ## 挿入し、分割した場合は新しい右ノード、それ以外は-1を返す。
        result = -1
        if t.nodes[v].leaf:
            when compileOption("overflowChecks") or sizeof(int) != 8:
                for i in countdown(t.nodes[v].used, p):
                    t.nodes[v].prefix[i+1] = t.nodes[v].prefix[i]+x
            else:
                sumShiftRaw(cast[ptr uint64](addr t.nodes[v].prefix[p]), cint(t.nodes[v].used-p+1), cast[uint64](x), 1, cint(t.kernel == bpkAvx2))
            inc t.nodes[v].used
            if t.nodes[v].used > sumCapacity:
                let right = t.allocNode(true)
                let middle = sumCapacity div 2
                let base = t.nodes[v].prefix[middle]
                t.nodes[right].used = t.nodes[v].used-middle
                for i in 1..t.nodes[right].used:
                    t.nodes[right].prefix[i] = t.nodes[v].prefix[middle+i]-base
                t.nodes[v].used = middle
                t.rebuild(right)
                result = right
            t.rebuild(v)
            return
        let j = t.findChild(v, p)
        let offset = if j == 0: 0 else: int(t.nodes[v].sizes[j-1])
        let right = t.insertNode(t.nodes[v].child[j], p-offset, x)
        if right < 0:
            t.adjust(v, j, t.nodes[v].used, 1, 0, x)
            inc t.nodes[v].size
            t.nodes[v].total += x
            return
        for i in countdown(t.nodes[v].used, j+2): t.nodes[v].child[i] = t.nodes[v].child[i-1]
        t.nodes[v].child[j+1] = right
        inc t.nodes[v].used
        if t.nodes[v].used > sumBranch:
            let right = t.allocNode(false)
            let middle = sumBranch div 2
            t.nodes[right].used = t.nodes[v].used-middle
            for i in 0..<t.nodes[right].used: t.nodes[right].child[i] = t.nodes[v].child[middle+i]
            t.nodes[v].used = middle
            t.rebuild(right)
            result = right
        t.rebuild(v)

    proc insert*(t: DynamicBPlusSum, p, x: int) =
        ## p番目へ挿入する。分割とプール拡張を含め償却O((B+C)h)。
        assert 0 <= p and p <= t.len and t.len < int32.high.int
        t.clearCache()
        let right = t.insertNode(t.root, p, x)
        if right >= 0:
            let v = t.allocNode(false)
            t.nodes[v].used = 2
            t.nodes[v].child[0] = t.root
            t.nodes[v].child[1] = right
            t.rebuild(v)
            t.root = v

    proc underfull(t: DynamicBPlusSum, v: int): bool {.inline.} =
        ## 根以外の最低占有率を割っているか調べる。
        t.nodes[v].used < (if t.nodes[v].leaf: sumCapacity div 2 else: sumBranch div 2)

    proc balancePair(t: DynamicBPlusSum, parent, j: int) =
        ## 隣接する子を結合または均等再配分する。O(B+C)。
        let a = t.nodes[parent].child[j]
        let b = t.nodes[parent].child[j+1]
        let na = t.nodes[a].used
        let n = na+t.nodes[b].used
        let capacity = if t.nodes[a].leaf: sumCapacity else: sumBranch
        let target = if n <= capacity: n else: n div 2
        if t.nodes[a].leaf:
            var joined: array[sumCapacity*2+1, int]
            for i in 0..na: joined[i] = t.nodes[a].prefix[i]
            for i in 1..t.nodes[b].used: joined[na+i] = joined[na]+t.nodes[b].prefix[i]
            for i in 0..target: t.nodes[a].prefix[i] = joined[i]
            for i in 0..n-target: t.nodes[b].prefix[i] = joined[target+i]-joined[target]
        else:
            var joined: array[sumBranch*2, int]
            for i in 0..<na: joined[i] = t.nodes[a].child[i]
            for i in 0..<t.nodes[b].used: joined[na+i] = t.nodes[b].child[i]
            for i in 0..<target: t.nodes[a].child[i] = joined[i]
            for i in 0..<n-target: t.nodes[b].child[i] = joined[target+i]
        t.nodes[a].used = target
        t.rebuild(a)
        if target == n:
            t.free.add(b)
            for i in j+1..<t.nodes[parent].used-1: t.nodes[parent].child[i] = t.nodes[parent].child[i+1]
            dec t.nodes[parent].used
        else:
            t.nodes[b].used = n-target
            t.rebuild(b)

    proc eraseNode(t: DynamicBPlusSum, v, p: int): int =
        ## 要素を削除し旧値を返す。帰り道で不足した子を補修する。
        if t.nodes[v].leaf:
            result = t.nodes[v].prefix[p+1]-t.nodes[v].prefix[p]
            when compileOption("overflowChecks") or sizeof(int) != 8:
                for i in p+1..<t.nodes[v].used: t.nodes[v].prefix[i] = t.nodes[v].prefix[i+1]-result
            else:
                sumShiftRaw(cast[ptr uint64](addr t.nodes[v].prefix[p+1]), cint(t.nodes[v].used-p-1), 0'u64-cast[uint64](result), -1, cint(t.kernel == bpkAvx2))
            dec t.nodes[v].used
            t.rebuild(v)
            return
        let j = t.findChild(v, p)
        let offset = if j == 0: 0 else: int(t.nodes[v].sizes[j-1])
        let child = t.nodes[v].child[j]
        result = t.eraseNode(child, p-offset)
        if t.underfull(child) and t.nodes[v].used > 1:
            t.balancePair(v, min(j, t.nodes[v].used-2))
            t.rebuild(v)
        else:
            t.adjust(v, j, t.nodes[v].used, -1, result, 0)
            dec t.nodes[v].size
            t.nodes[v].total -= result

    proc erase*(t: DynamicBPlusSum, p: int): int {.discardable.} =
        ## p番目を削除し旧値を返す。償却O((B+C)h)。
        assert 0 <= p and p < t.len
        t.clearCache()
        result = t.eraseNode(t.root, p)
        if not t.nodes[t.root].leaf and t.nodes[t.root].used == 1:
            let old = t.root
            t.root = t.nodes[old].child[0]
            t.free.add(old)

    type SumPath = object
        nodes, children: array[32, int]
        depth, leaf, position: int

    proc locate(t: DynamicBPlusSum, p: int, path: var SumPath) =
        ## 根から葉までの経路を保存する。配列上限はN<=int32.highとB>=4から32。
        var v = t.root
        var p = p
        path.depth = 0
        while not t.nodes[v].leaf:
            let j = t.findChild(v, p)
            path.nodes[path.depth] = v
            path.children[path.depth] = j
            inc path.depth
            if j > 0: p -= int(t.nodes[v].sizes[j-1])
            v = t.nodes[v].child[j]
        path.leaf = v
        path.position = p

    proc moveReplace*(t: DynamicBPlusSum, source, destination, x: int) =
        ## sourceを削除し、削除後のdestinationへxを挿入する。償却O((B+C)h)。
        ## 葉の分割・結合が不要なら経路を保存し、再帰と再探索を省く。
        assert 0 <= source and source < t.len and 0 <= destination and destination < t.len
        t.clearCache()
        if source == destination:
            discard t.replaceNode(t.root, source, x)
            return
        var oldPath, newPath {.noinit.}: SumPath
        t.locate(source, oldPath)
        t.locate(destination+int(destination >= source), newPath)
        let a = oldPath.leaf
        let b = newPath.leaf
        if a != b and (t.nodes[a].used <= sumCapacity div 2 or t.nodes[b].used == sumCapacity):
            discard t.erase(source)
            t.insert(destination, x)
            return
        let old = t.eraseNode(a, oldPath.position)
        let p = newPath.position-int(a == b and destination >= source)
        discard t.insertNode(b, p, x)
        if a == b:
            for h in 0..<oldPath.depth:
                let v = oldPath.nodes[h]
                t.adjust(v, oldPath.children[h], t.nodes[v].used, 0, old, x)
                t.nodes[v].total = t.nodes[v].total-old+x
        else:
            var common = 0
            while common < oldPath.depth and common < newPath.depth and oldPath.nodes[common] == newPath.nodes[common]:
                let v = oldPath.nodes[common]
                let a = oldPath.children[common]
                let b = newPath.children[common]
                if a < b: t.adjust(v, a, b, -1, old, 0)
                elif b < a: t.adjust(v, b, a, 1, 0, x)
                t.adjust(v, max(a, b), t.nodes[v].used, 0, old, x)
                t.nodes[v].total = t.nodes[v].total-old+x
                inc common
            for h in common..<oldPath.depth:
                let v = oldPath.nodes[h]
                t.adjust(v, oldPath.children[h], t.nodes[v].used, -1, old, 0)
                dec t.nodes[v].size
                t.nodes[v].total -= old
            for h in common..<newPath.depth:
                let v = newPath.nodes[h]
                t.adjust(v, newPath.children[h], t.nodes[v].used, 1, 0, x)
                inc t.nodes[v].size
                t.nodes[v].total += x

    proc validate*(t: DynamicBPlusSum) =
        ## 木の占有率・累積情報・高さ・空きリストを検査する。O(確保領域)。
        var seen = newSeq[bool](t.nodes.len)
        proc visit(v: int, root: bool): int =
            ## 部分木を検査し高さを返す。
            assert 0 <= v and v < t.nodes.len and not seen[v]
            seen[v] = true
            let n = t.nodes[v].used
            if not root: assert not t.underfull(v)
            if t.nodes[v].leaf:
                assert n <= sumCapacity and t.nodes[v].prefix[0] == 0
                assert t.nodes[v].size == n and t.nodes[v].total == t.nodes[v].prefix[n]
                return 0
            assert n >= (if root: 2 else: sumBranch div 2) and n <= sumBranch
            var size, total: int
            var height = -1
            for i in 0..<n:
                let c = t.nodes[v].child[i]
                let h = visit(c, false)
                if height < 0: height = h
                assert height == h
                size += t.nodes[c].size
                total += t.nodes[c].total
                assert size == t.nodes[v].sizes[i] and total == t.nodes[v].sums[i]
            assert size == t.nodes[v].size and total == t.nodes[v].total
            height+1
        discard visit(t.root, true)
        for v in t.free:
            assert 0 <= v and v < t.nodes.len and not seen[v]
            seen[v] = true
        for present in seen: assert present
