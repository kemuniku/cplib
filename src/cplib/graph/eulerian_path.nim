when not declared CPLIB_GRAPH_EULERIAN_PATH:
    const CPLIB_GRAPH_EULERIAN_PATH* = 1

    import algorithm
    import cplib/graph/graph

    proc eulerian_path_impl(g: DirectedGraph or UnDirectedGraph, start: int): seq[int] =
        ## 全ての辺をちょうど一度ずつ通る頂点列を返す。
        ## オイラー路が存在しない場合は空列を返す。
        ## `start` が指定された場合、その頂点から始まるオイラー路を求める。
        let n = g.len
        if start < -1 or start >= n:
            return @[]

        var adj = newSeq[seq[(int, int)]](n)
        var indeg, outdeg = newSeq[int](n)
        var edge_count = 0

        template add_directed_edge(u, v: int) =
            adj[u].add((v, edge_count))
            outdeg[u] += 1
            indeg[v] += 1
            edge_count += 1

        template add_undirected_edge(u, v: int) =
            adj[u].add((v, edge_count))
            adj[v].add((u, edge_count))
            outdeg[u] += 1
            outdeg[v] += 1
            edge_count += 1

        when g is DirectedGraph:
            when g is DynamicGraphTypes:
                for u in 0..<n:
                    for e in g.edges[u]:
                        add_directed_edge(u, e[0].int)
            else:
                g.static_graph_initialized_check()
                for i in 0..<g.src.len:
                    add_directed_edge(g.src[i].int, g.dst[i].int)
        else:
            when g is DynamicGraphTypes:
                # add_edge は各無向辺を両端の隣接リストへ同じ順で追加する。
                # 自己ループだけは同じリストに二回入るので、一つおきに採用する。
                var self_loop_count = newSeq[int](n)
                for u in 0..<n:
                    for e in g.edges[u]:
                        let v = e[0].int
                        if u < v:
                            add_undirected_edge(u, v)
                        elif u == v:
                            if self_loop_count[u] mod 2 == 0:
                                add_undirected_edge(u, v)
                            self_loop_count[u] += 1
            else:
                g.static_graph_initialized_check()
                # 無向 static graph は一辺につき (u,v), (v,u) の順で保持する。
                var i = 0
                while i < g.src.len:
                    add_undirected_edge(g.src[i].int, g.dst[i].int)
                    i += 2

        var first = start
        when g is DirectedGraph:
            var required_start = -1
            var required_goal = -1
            for v in 0..<n:
                let d = outdeg[v] - indeg[v]
                if d == 1:
                    if required_start != -1: return @[]
                    required_start = v
                elif d == -1:
                    if required_goal != -1: return @[]
                    required_goal = v
                elif d != 0:
                    return @[]
            if (required_start == -1) != (required_goal == -1):
                return @[]
            if first == -1:
                first = required_start
                if first == -1:
                    for v in 0..<n:
                        if outdeg[v] > 0:
                            first = v
                            break
            elif edge_count > 0:
                if required_start != -1 and first != required_start: return @[]
                if outdeg[first] == 0: return @[]
        else:
            var odd: seq[int]
            for v in 0..<n:
                if outdeg[v] mod 2 == 1:
                    odd.add(v)
            if odd.len != 0 and odd.len != 2:
                return @[]
            if first == -1:
                if odd.len == 2:
                    first = odd[0]
                else:
                    for v in 0..<n:
                        if outdeg[v] > 0:
                            first = v
                            break
            elif edge_count > 0:
                if odd.len == 2 and first != odd[0] and first != odd[1]: return @[]
                if outdeg[first] == 0: return @[]

        if edge_count == 0:
            if first != -1: return @[first]
            if n > 0: return @[0]
            return @[]

        var used = newSeq[bool](edge_count)
        var next = newSeq[int](n)
        var stack = @[first]
        while stack.len > 0:
            let v = stack[^1]
            while next[v] < adj[v].len and used[adj[v][next[v]][1]]:
                next[v] += 1
            if next[v] == adj[v].len:
                result.add(stack.pop())
            else:
                let (to, id) = adj[v][next[v]]
                next[v] += 1
                if not used[id]:
                    used[id] = true
                    stack.add(to)

        if result.len != edge_count + 1:
            return @[]
        result.reverse()

    proc eulerian_path*(g: DirectedGraph, start: int = -1): seq[int] =
        g.eulerian_path_impl(start)

    proc eulerian_path*(g: UnDirectedGraph, start: int = -1): seq[int] =
        g.eulerian_path_impl(start)

    proc eulerian_trail*(g: DirectedGraph, start: int = -1): seq[int] =
        ## `eulerian_path` の別名。
        g.eulerian_path(start)

    proc eulerian_trail*(g: UnDirectedGraph, start: int = -1): seq[int] =
        ## `eulerian_path` の別名。
        g.eulerian_path(start)
