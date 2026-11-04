# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, sets, sequtils, random
import cplib/graph/graph
import cplib/graph/is_dfs_preorder

type OpaqueCost = object
    label: string

proc permutations(n: int): seq[seq[int]] =
    var p = toSeq(0..<n)
    result.add(p)
    while p.nextPermutation(): result.add(p)

proc oracle(rows: seq[seq[int]]): tuple[single, forest: HashSet[seq[int]]] =
    var chosen = newSeq[seq[int]](rows.len)
    let roots = permutations(rows.len)
    var single, forest: HashSet[seq[int]]
    proc enumerateRows(v: int) =
        if v == rows.len:
            for rootOrder in roots:
                var seen = newSeq[bool](rows.len)
                var discovery: seq[int]
                proc dfs(u: int) =
                    seen[u] = true
                    discovery.add(u)
                    for dst in chosen[u]:
                        if not seen[dst]: dfs(dst)
                if rootOrder.len == 0:
                    single.incl(discovery)
                else:
                    dfs(rootOrder[0])
                    if discovery.len == rows.len: single.incl(discovery)
                for root in rootOrder:
                    if not seen[root]: dfs(root)
                forest.incl(discovery)
            return
        var row = rows[v].sorted()
        chosen[v] = row
        enumerateRows(v + 1)
        while row.nextPermutation():
            chosen[v] = row
            enumerateRows(v + 1)
    enumerateRows(0)
    (single, forest)

proc checkGraph(g: DirectedGraph or UnDirectedGraph,
                expected: tuple[single, forest: HashSet[seq[int]]]) =
    let before = g.edge_info
    var rows = newSeq[seq[(int, int)]](g.len)
    for v in 0..<g.len: rows[v] = toSeq(g.to_and_id(v))
    for order in permutations(g.len):
        let original = order
        doAssert g.is_dfs_preorder(order) == (order in expected.single), $order
        doAssert g.is_dfs_preorder(order, forest = true) == (order in expected.forest), $order
        doAssert order == original
    doAssert g.edge_info == before
    for v in 0..<g.len: doAssert toSeq(g.to_and_id(v)) == rows[v]
    if g.len > 0:
        var bad = toSeq(0..<g.len)
        bad.setLen(g.len - 1)
        doAssert not g.is_dfs_preorder(bad)
        doAssert not g.is_dfs_preorder(bad, true)
        bad.add(0)
        bad.add(0)
        doAssert not g.is_dfs_preorder(bad)
        doAssert not g.is_dfs_preorder(bad, true)
        for invalid in [-1, g.len, low(int), high(int)]:
            bad = toSeq(0..<g.len)
            bad[0] = invalid
            doAssert not g.is_dfs_preorder(bad)
            doAssert not g.is_dfs_preorder(bad, true)
        if g.len > 1:
            bad = toSeq(0..<g.len)
            bad[^1] = bad[0]
            doAssert not g.is_dfs_preorder(bad)
            doAssert not g.is_dfs_preorder(bad, true)
    else:
        doAssert not g.is_dfs_preorder([0])
        doAssert not g.is_dfs_preorder([0], true)

proc check(n: int, edges: seq[(int, int)], directed: bool) =
    var rows = newSeq[seq[int]](n)
    for (u, v) in edges:
        rows[u].add(v)
        if not directed: rows[v].add(u)
    let expected = oracle(rows)
    if directed:
        var ud = initUnWeightedDirectedGraph(n)
        var usd = initUnWeightedDirectedStaticGraph(n)
        var wd = initWeightedDirectedGraph(n, OpaqueCost)
        var wsd = initWeightedDirectedStaticGraph(n, OpaqueCost)
        for i, (u, v) in edges:
            ud.add_edge(u, v)
            usd.add_edge(u, v)
            wd.add_edge(u, v, OpaqueCost(label: $i))
            wsd.add_edge(u, v, OpaqueCost(label: $i))
        usd.build()
        wsd.build()
        checkGraph(ud, expected)
        checkGraph(usd, expected)
        checkGraph(wd, expected)
        checkGraph(wsd, expected)
    else:
        var uu = initUnWeightedUnDirectedGraph(n)
        var usu = initUnWeightedUnDirectedStaticGraph(n)
        var wu = initWeightedUnDirectedGraph(n, OpaqueCost)
        var wsu = initWeightedUnDirectedStaticGraph(n, OpaqueCost)
        for i, (u, v) in edges:
            uu.add_edge(u, v)
            usu.add_edge(u, v)
            wu.add_edge(u, v, OpaqueCost(label: $i))
            wsu.add_edge(u, v, OpaqueCost(label: $i))
        usu.build()
        wsu.build()
        checkGraph(uu, expected)
        checkGraph(usu, expected)
        checkGraph(wu, expected)
        checkGraph(wsu, expected)

for directed in [false, true]: check(0, @[], directed)
for n in 1..3:
    for mask in 0..<(1 shl (n * n)):
        var edges: seq[(int, int)]
        for u in 0..<n:
            for v in 0..<n:
                if (mask and (1 shl (u * n + v))) != 0: edges.add((u, v))
        check(n, edges, true)
for n in 1..4:
    var pairs: seq[(int, int)]
    for u in 0..<n:
        for v in u+1..<n: pairs.add((u, v))
    for mask in 0..<(1 shl pairs.len):
        var edges: seq[(int, int)]
        for i, edge in pairs:
            if (mask and (1 shl i)) != 0: edges.add(edge)
        check(n, edges, false)

var rng = initRand(566)
for directed in [false, true]:
    for trial in 0..<60:
        let n = rng.rand(1..4)
        var edges: seq[(int, int)]
        var degree = newSeq[int](n)
        for i in 0..<8:
            let u = rng.rand(n-1)
            let v = rng.rand(n-1)
            if degree[u] + 1 + ord(not directed and u == v) > 3: continue
            if not directed and degree[v] + 1 + ord(u == v) > 3: continue
            edges.add((u, v))
            inc degree[u]
            if not directed: inc degree[v]
        check(n, edges, directed)

block:
    var g = initUnWeightedDirectedGraph(4)
    g.add_edge(0, 2)
    g.add_edge(0, 1)
    g.add_edge(1, 3)
    g.add_edge(2, 1)
    doAssert g.is_dfs_preorder([0, 1, 3, 2])
    doAssert g.is_dfs_preorder([0, 2, 1, 3])
    doAssert not g.is_dfs_preorder([0, 1, 2, 3])
    doAssert not g.is_dfs_preorder([0, 1, 2, 3], true)

block:
    var g = initUnWeightedDirectedGraph(3)
    g.add_edge(1, 0)
    doAssert not g.is_dfs_preorder([0, 1, 2])
    doAssert g.is_dfs_preorder([0, 1, 2], true)
    doAssert g.is_dfs_preorder([2, 1, 0], true)
    doAssert not g.is_dfs_preorder([1, 2, 0], true)

block:
    var g = initUnWeightedDirectedStaticGraph(1)
    var rejected = false
    try: discard g.is_dfs_preorder([0])
    except ValueError: rejected = true
    doAssert rejected
    g.build()
    doAssert g.is_dfs_preorder([0])
    g.add_edge(0, 0)
    rejected = false
    try: discard g.is_dfs_preorder([0], true)
    except ValueError: rejected = true
    doAssert rejected
    g.build()
    doAssert g.is_dfs_preorder([0])

block:
    const n = 100000
    var chain = initUnWeightedDirectedGraph(n)
    var star = initWeightedUnDirectedStaticGraph(n, OpaqueCost)
    var order = toSeq(0..<n)
    for v in 1..<n:
        chain.add_edge(v-1, v)
        star.add_edge(0, n-v, OpaqueCost(label: "unused"))
    star.build()
    doAssert chain.is_dfs_preorder(order)
    doAssert star.is_dfs_preorder(order)
    order.reverse()
    doAssert not chain.is_dfs_preorder(order)
    doAssert chain.is_dfs_preorder(order, true)
    swap(order[0], order[^1])
    doAssert star.is_dfs_preorder(order)
    doAssert not chain.is_dfs_preorder(order, true)

echo "Hello World"
