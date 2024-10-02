when not declared CPLIB_TREE_DIAMETER:
    const CPLIB_TREE_DIAMETER* = 1
    import cplib/graph/graph
    proc diameter_and_edge*(g:UnDirectedGraph): auto =
        var u, v: int
        when g is WeightedGraph:
            type Cost = g.T
        else:
            type Cost = int
        var cur = Cost(0)
        proc dfs(x, par: int, d: Cost, u: var int) =
            if d > cur:
                cur = d
                u = x
            for (y, cost) in g.to_and_cost(x):
                if y == par: continue
                dfs(y, x, d + cost, u)
        dfs(0, -1, Cost(0), u)
        cur = Cost(0)
        dfs(u, -1, Cost(0), v)
        return (cur, u, v)

    proc diameter*(g: UnDirectedGraph): auto =
        var (d, _, _) = g.diameter_and_edge
        return d

    proc diameter_path*(g: UnDirectedGraph): auto =
        var (d, u, v) = g.diameter_and_edge
        var path = newSeq[int]()
        proc dfs(x, par: int): bool =
            result = false
            path.add(x)
            if x == v: return true
            for (y, cost) in g.to_and_cost(x):
                if y == par: continue
                result = result or dfs(y, x)
                if result: break
            if not result:
                discard path.pop
        discard dfs(u, -1)
        return (d, path)
