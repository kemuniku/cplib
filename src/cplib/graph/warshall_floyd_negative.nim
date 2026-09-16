when not declared CPLIB_GRAPH_WARSHALL_FLOYD_NEGATIVE:
    const CPLIB_GRAPH_WARSHALL_FLOYD_NEGATIVE* = 1
    import sequtils

    proc warshall_floyd_negative_finish*[T](d: var seq[seq[T]], zero, inf: T,
            run: proc(a: var seq[seq[T]], zero, inf: T): bool) =
        ## 負閉路検出後の行列を完成させ、負閉路を経由できる組を-infにする。O(V^3)、追加領域O(V^2)。
        let n = d.len
        var seen = newSeq[bool](n)
        var order: seq[int]
        for root in 0..<n:
            if seen[root]: continue
            var stack = @[(root, 0)]
            seen[root] = true
            while stack.len > 0:
                let v = stack[^1][0]
                let j = stack[^1][1]
                if j == n:
                    order.add(v)
                    stack.setLen(stack.len - 1)
                else:
                    inc stack[^1][1]
                    if d[v][j] != inf and not seen[j]:
                        seen[j] = true
                        stack.add((j, 0))
        var component = newSeqWith(n, -1)
        var groups: seq[seq[int]]
        for index in countdown(order.len - 1, 0):
            let root = order[index]
            if component[root] != -1: continue
            let id = groups.len
            var vertices = @[root]
            component[root] = id
            var head = 0
            while head < vertices.len:
                let v = vertices[head]
                inc head
                for u in 0..<n:
                    if d[u][v] != inf and component[u] == -1:
                        component[u] = id
                        vertices.add(u)
            groups.add(vertices)

        var affected = newSeqWith(n, newSeq[bool](n))
        # 更新済みの有限要素も元の歩道を表すため、到達性と負閉路の有無は保存される。
        for vertices in groups:
            var negative = groups.len == 1
            for v in vertices:
                if d[v][v] < zero: negative = true
            if not negative and vertices.len > 1:
                var blockMatrix = newSeqWith(vertices.len, newSeq[T](vertices.len))
                for i, v in vertices:
                    for j, u in vertices:
                        blockMatrix[i][j] = d[v][u]
                negative = run(blockMatrix, zero, inf)
            if not negative: continue

            var before = newSeq[bool](n)
            var after = newSeq[bool](n)
            for reverse in [false, true]:
                var reached = newSeq[bool](n)
                var queue = @[vertices[0]]
                reached[vertices[0]] = true
                var head = 0
                while head < queue.len:
                    let v = queue[head]
                    inc head
                    for u in 0..<n:
                        let edge = if reverse: d[u][v] else: d[v][u]
                        if edge != inf and not reached[u]:
                            reached[u] = true
                            queue.add(u)
                if reverse: before = reached
                else: after = reached
            for i in 0..<n:
                if before[i]:
                    for j in 0..<n:
                        if after[j]: affected[i][j] = true

        # 影響を受ける組を除けば負閉路は残らず、残りの組の有限な最短距離は保存される。
        for i in 0..<n:
            for j in 0..<n:
                if affected[i][j]: d[i][j] = inf
        discard run(d, zero, inf)
        for i in 0..<n:
            for j in 0..<n:
                if affected[i][j]: d[i][j] = -inf
