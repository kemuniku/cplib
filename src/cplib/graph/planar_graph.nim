when not declared CPLIB_GRAPH_PLANAR_GRAPH:
    const CPLIB_GRAPH_PLANAR_GRAPH* = 1
    import algorithm, sequtils, sets
    import cplib/graph/graph

    # 参考: Ulrik Brandes「The Left-Right Planarity Test」第6節。
    # https://www.uni-konstanz.de/algo/publications/b-lrpt-sub.pdf
    type
        PlanarInterval = object
            low, high: int
        PlanarConflict = object
            left, right: PlanarInterval

    proc is_planar_graph*(g: UnDirectedGraph): bool =
        ## 無向グラフの平面性を判定する。期待 O(V log V + E) 時間、O(V + E) 空間。
        ## 重み・自己ループ・多重辺は判定に影響しない。静的グラフは build 前でも使用可能。
        let n = g.len
        var seen = initHashSet[(int, int)]()
        var ends: seq[(int, int)]
        var adj = newSeq[seq[int]](n)
        for edge in g.edge_info:
            let u = min(edge.src, edge.dst)
            let v = max(edge.src, edge.dst)
            if u == v or (u, v) in seen: continue
            seen.incl((u, v))
            let id = ends.len
            ends.add((u, v))
            adj[u].add(id)
            adj[v].add(id)
        let m = ends.len
        if n > 2 and m > 3 * n - 6: return false
        var height = newSeqWith(n, -1)
        var parent = newSeqWith(n, -1)
        var low = newSeq[int](m)
        var low2 = newSeq[int](m)
        var nesting = newSeq[int](m)
        var oriented = newSeq[bool](m)
        var outgoing = newSeq[seq[int]](n)
        var cursor = newSeq[int](n)
        var roots: seq[int]

        proc finishEdge(e, p: int) =
            ## 辺の入れ子順を求め、親辺の lowpoint を更新する。O(1)。
            nesting[e] = 2 * low[e] + ord(low2[e] < height[ends[e][0]])
            if p == -1: return
            if low[e] < low[p]:
                low2[p] = min(low[p], low2[e])
                low[p] = low[e]
            elif low[e] > low[p]:
                low2[p] = min(low2[p], low[e])
            else:
                low2[p] = min(low2[p], low2[e])

        for root in 0..<n:
            if height[root] != -1: continue
            roots.add(root)
            height[root] = 0
            var stack = @[root]
            while stack.len > 0:
                let v = stack[^1]
                if cursor[v] == adj[v].len:
                    discard stack.pop()
                    let e = parent[v]
                    if e != -1: finishEdge(e, parent[ends[e][0]])
                    continue
                let e = adj[v][cursor[v]]
                inc cursor[v]
                if oriented[e]: continue
                oriented[e] = true
                let w = ends[e][0] xor ends[e][1] xor v
                ends[e] = (v, w)
                outgoing[v].add(e)
                low[e] = height[v]
                low2[e] = height[v]
                if height[w] == -1:
                    parent[w] = e
                    height[w] = height[v] + 1
                    stack.add(w)
                else:
                    low[e] = height[w]
                    finishEdge(e, parent[v])
        for v in 0..<n:
            outgoing[v].sort(proc(a, b: int): int = cmp(nesting[a], nesting[b]))

        let empty = PlanarInterval(low: -1, high: -1)
        var conflicts: seq[PlanarConflict]
        var bottom = newSeq[int](m)
        var reference = newSeqWith(m, -1)
        var lowEdge = newSeqWith(m, -1)

        proc conflicting(interval: PlanarInterval, e: int): bool =
            ## 区間に辺 e と同じ側に置けない戻り辺があるかを返す。O(1)。
            interval.high != -1 and low[interval.high] > low[e]

        proc addConstraints(e, p: int): bool =
            ## 戻り辺の左右の制約を統合する。全呼び出し合計 O(E)。
            var merged = PlanarConflict(left: empty, right: empty)
            while true:
                var q = conflicts.pop()
                if q.left.low != -1: swap(q.left, q.right)
                if q.left.low != -1: return false
                if low[q.right.low] > low[p]:
                    if merged.right.low == -1:
                        merged.right = q.right
                    else:
                        reference[merged.right.low] = q.right.high
                    merged.right.low = q.right.low
                else:
                    reference[q.right.low] = lowEdge[p]
                if conflicts.len == bottom[e]: break
            while conflicts.len > 0 and
                    (conflicting(conflicts[^1].left, e) or conflicting(conflicts[^1].right, e)):
                var q = conflicts.pop()
                if conflicting(q.right, e): swap(q.left, q.right)
                if conflicting(q.right, e): return false
                if merged.right.low != -1: reference[merged.right.low] = q.right.high
                if q.right.low != -1: merged.right.low = q.right.low
                if merged.left.low == -1:
                    merged.left = q.left
                else:
                    reference[merged.left.low] = q.left.high
                merged.left.low = q.left.low
            if merged.left.low != -1 or merged.right.low != -1:
                conflicts.add(merged)
            return true

        proc trimBackEdges(e: int) =
            ## 親に到達した戻り辺を制約から取り除く。全呼び出し合計 O(E)。
            let u = ends[e][0]
            while conflicts.len > 0:
                let q = conflicts[^1]
                let l = if q.left.low == -1: high(int) else: low[q.left.low]
                let r = if q.right.low == -1: high(int) else: low[q.right.low]
                if min(l, r) != height[u]: break
                discard conflicts.pop()
            if conflicts.len > 0:
                var q = conflicts.pop()
                while q.left.high != -1 and ends[q.left.high][1] == u:
                    q.left.high = reference[q.left.high]
                if q.left.high == -1 and q.left.low != -1:
                    reference[q.left.low] = q.right.low
                    q.left.low = -1
                while q.right.high != -1 and ends[q.right.high][1] == u:
                    q.right.high = reference[q.right.high]
                if q.right.high == -1 and q.right.low != -1:
                    reference[q.right.low] = q.left.low
                    q.right.low = -1
                conflicts.add(q)
            if low[e] < height[u]:
                let l = conflicts[^1].left.high
                let r = conflicts[^1].right.high
                reference[e] = if l != -1 and (r == -1 or low[l] > low[r]): l else: r

        cursor = newSeq[int](n)
        var entered = newSeq[bool](m)
        for root in roots:
            var stack = @[root]
            while stack.len > 0:
                let v = stack[^1]
                let p = parent[v]
                if cursor[v] == outgoing[v].len:
                    discard stack.pop()
                    if p != -1: trimBackEdges(p)
                    continue
                let e = outgoing[v][cursor[v]]
                let w = ends[e][1]
                if not entered[e]:
                    entered[e] = true
                    bottom[e] = conflicts.len
                    if parent[w] == e:
                        stack.add(w)
                        continue
                    lowEdge[e] = e
                    conflicts.add(PlanarConflict(left: empty, right: PlanarInterval(low: e, high: e)))
                if low[e] < height[v]:
                    if cursor[v] == 0:
                        lowEdge[p] = lowEdge[e]
                    elif not addConstraints(e, p):
                        return false
                inc cursor[v]
        return true
