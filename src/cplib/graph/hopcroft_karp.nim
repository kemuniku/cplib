when not declared CPLIB_GRAPH_HOPCROFT_KARP:
    const CPLIB_GRAPH_HOPCROFT_KARP* = 1

    type HopcroftKarp* = object
        edges: seq[tuple[left, right: int]]
        leftOffset, rightOffset, leftEdges, rightEdges: seq[int]
        leftMatch, rightMatch: seq[int]
        size: int
        built: bool

    proc initHopcroftKarp*(left, right: int): HopcroftKarp =
        ## 左側left頂点、右側right頂点の二部グラフを構築する。O(left+right)。
        assert left >= 0 and right >= 0
        result.leftMatch = newSeq[int](left)
        result.rightMatch = newSeq[int](right)
        for i in 0..<left:
            result.leftMatch[i] = -1
        for i in 0..<right:
            result.rightMatch[i] = -1

    proc add_edge*(g: var HopcroftKarp, left, right: int) =
        ## 左右それぞれ0始まりの頂点間に辺を追加する。多重辺も可。償却O(1)。
        assert left in 0..<g.leftMatch.len and right in 0..<g.rightMatch.len
        g.edges.add((left, right))
        g.built = false

    proc build(g: var HopcroftKarp) =
        ## 左右両方向の隣接辺をCSR形式にまとめる。辺追加後の初回のみO(V+E)。
        if g.built:
            return
        let left = g.leftMatch.len
        let right = g.rightMatch.len
        let m = g.edges.len
        g.leftOffset = newSeq[int](left + 1)
        g.rightOffset = newSeq[int](right + 1)
        for (v, u) in g.edges:
            inc g.leftOffset[v]
            inc g.rightOffset[u]
        for v in 1..<left:
            g.leftOffset[v] += g.leftOffset[v - 1]
        for u in 1..<right:
            g.rightOffset[u] += g.rightOffset[u - 1]
        g.leftOffset[left] = m
        g.rightOffset[right] = m
        g.leftEdges = newSeq[int](m)
        g.rightEdges = newSeq[int](m)
        for (v, u) in g.edges:
            dec g.leftOffset[v]
            dec g.rightOffset[u]
            g.leftEdges[g.leftOffset[v]] = u
            g.rightEdges[g.rightOffset[u]] = v
        g.built = true

    proc matching*(g: var HopcroftKarp, useRelabel: bool = true): int {.discardable.} =
        ## 最大マッチングの総サイズを返す。既定ではGlobal relabel前処理付き。再実行可。O((V+E)√V)、領域O(V+E)。
        let n = g.leftMatch.len
        let right = g.rightMatch.len
        let limit = min(n, right)
        if g.size == limit:
            return g.size
        g.build()
        var dist = newSeq[int](n)
        var queue = newSeq[int](n)
        if useRelabel:
            var active = newSeq[int](right)
            var head = 0
            var tail = 0
            var count = 0
            for u in 0..<right:
                if g.rightMatch[u] < 0 and g.rightOffset[u] < g.rightOffset[u + 1]:
                    active[tail] = u
                    inc tail
                    inc count
            if tail == right:
                tail = 0
            let period = n + right
            let workLimit = 16 * (n + right + g.edges.len)
            var work = 0
            var steps = 0
            while count > 0 and g.size < limit and work < workLimit:
                if steps == 0:
                    # 未マッチの左頂点から交互道の距離を計算する。マッチした辺の組を1段と数える。
                    var first = 0
                    var last = 0
                    for v in 0..<n:
                        if g.leftMatch[v] < 0:
                            dist[v] = 0
                            queue[last] = v
                            inc last
                        else:
                            dist[v] = n
                    work += n
                    while first < last:
                        let v = queue[first]
                        inc first
                        for i in g.leftOffset[v]..<g.leftOffset[v + 1]:
                            let w = g.rightMatch[g.leftEdges[i]]
                            if w >= 0 and dist[w] == n:
                                dist[w] = dist[v] + 1
                                queue[last] = w
                                inc last
                        work += g.leftOffset[v + 1] - g.leftOffset[v]
                    steps = period
                    if work >= workLimit:
                        break
                let u = active[head]
                inc head
                if head == right:
                    head = 0
                dec count
                dec steps
                var best = -1
                var bestHeight = n
                for i in g.rightOffset[u]..<g.rightOffset[u + 1]:
                    inc work
                    let v = g.rightEdges[i]
                    if dist[v] < bestHeight:
                        best = v
                        bestHeight = dist[v]
                        if bestHeight == 0:
                            break
                if best < 0:
                    continue
                let previous = g.leftMatch[best]
                if previous < 0:
                    inc g.size
                else:
                    g.rightMatch[previous] = -1
                    active[tail] = previous
                    inc tail
                    if tail == right:
                        tail = 0
                    inc count
                g.leftMatch[best] = u
                g.rightMatch[u] = best
                dist[best] = bestHeight + 1
            if g.size == limit:
                return g.size
        else:
            for v in 0..<n:
                if g.leftMatch[v] < 0:
                    for i in g.leftOffset[v]..<g.leftOffset[v + 1]:
                        let u = g.leftEdges[i]
                        if g.rightMatch[u] < 0:
                            g.leftMatch[v] = u
                            g.rightMatch[u] = v
                            inc g.size
                            break

        # 前処理が走査量の上限に達した場合も、最短増加路を処理するHK法で完了させる。
        var iter = newSeq[int](n)
        var freeLeft = newSeqOfCap[int](n - g.size)
        for v in 0..<n:
            if g.leftMatch[v] < 0 and g.leftOffset[v] < g.leftOffset[v + 1]:
                freeLeft.add(v)
        while g.size < limit:
            var head = 0
            var tail = 0
            for v in 0..<n:
                iter[v] = g.leftOffset[v]
                dist[v] = -1
            for v in freeLeft:
                dist[v] = 0
                queue[tail] = v
                inc tail
            var shortest = n
            while head < tail:
                let v = queue[head]
                inc head
                if dist[v] >= shortest:
                    break
                for i in g.leftOffset[v]..<g.leftOffset[v + 1]:
                    let u = g.leftEdges[i]
                    let w = g.rightMatch[u]
                    if w < 0:
                        shortest = dist[v]
                    elif dist[w] < 0 and dist[v] < shortest:
                        dist[w] = dist[v] + 1
                        queue[tail] = w
                        inc tail
            if shortest == n:
                break

            # BFSのキューをDFSの経路スタックとして再利用する。
            for root in freeLeft:
                if g.leftMatch[root] >= 0 or dist[root] != 0:
                    continue
                var depth = 0
                queue[0] = root
                while depth >= 0:
                    let v = queue[depth]
                    var descended = false
                    var endpoint = -1
                    while iter[v] < g.leftOffset[v + 1]:
                        let u = g.leftEdges[iter[v]]
                        inc iter[v]
                        let w = g.rightMatch[u]
                        if w < 0:
                            if dist[v] == shortest:
                                endpoint = u
                                break
                        elif dist[v] < shortest and dist[w] == dist[v] + 1:
                            inc depth
                            queue[depth] = w
                            descended = true
                            break
                    if endpoint >= 0:
                        while depth >= 0:
                            let x = queue[depth]
                            let previous = g.leftMatch[x]
                            g.leftMatch[x] = endpoint
                            g.rightMatch[endpoint] = x
                            endpoint = previous
                            dist[x] = -1
                            dec depth
                        inc g.size
                        break
                    if not descended:
                        dist[v] = -1
                        dec depth
            var remaining = 0
            for v in freeLeft:
                if g.leftMatch[v] < 0:
                    freeLeft[remaining] = v
                    inc remaining
            freeLeft.setLen(remaining)
        return g.size

    proc get_matching*(g: HopcroftKarp): seq[tuple[left, right: int]] =
        ## 現在のマッチングの辺を左頂点順で返す。最大化には先にmatchingを呼ぶ。O(left)。
        result = newSeqOfCap[tuple[left, right: int]](g.size)
        for left, right in g.leftMatch:
            if right >= 0:
                result.add((left, right))
