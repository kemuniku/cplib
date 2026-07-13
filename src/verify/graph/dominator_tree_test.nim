import cplib/graph/dominator_tree
import cplib/graph/graph
import std/sequtils

block:
    var g = initUnWeightedDirectedGraph(7)
    for (u, v) in @[(0, 1), (0, 2), (1, 3), (2, 3), (3, 4),
                     (1, 5), (5, 4), (4, 1), (6, 4)]:
        g.add_edge(u, v)
    doAssert g.dominator_tree(0) == @[0, 0, 0, 0, 0, 1, -1]

block:
    var g = initWeightedDirectedStaticGraph(6, int)
    for (u, v, c) in @[(2, 0, 4), (2, 1, 8), (0, 3, 1), (1, 3, 2),
                        (3, 4, 3), (0, 4, 5), (4, 3, 6)]:
        g.add_edge(u, v, c)
    g.build()
    doAssert g.dominator_tree(2) == @[2, 2, 2, 2, 2, -1]

block:
    var g = initUnWeightedDirectedStaticGraph(4)
    g.add_edge(0, 1)
    g.add_edge(1, 2)
    g.add_edge(2, 3)
    g.build()
    doAssert g.dominator_tree(0) == @[0, 0, 1, 2]

# 3 頂点の全有向グラフについて、素朴な dominator 集合と比較する。
block:
    const n = 3
    for mask in 0..<(1 shl (n * n)):
        var g = initUnWeightedDirectedGraph(n)
        var rev = newSeq[seq[int]](n)
        for u in 0..<n:
            for v in 0..<n:
                if ((mask shr (u * n + v)) and 1) != 0:
                    g.add_edge(u, v)
                    rev[v].add(u)

        for root in 0..<n:
            var reachable = newSeq[bool](n)
            reachable[root] = true
            var stack = @[root]
            while stack.len > 0:
                let u = stack.pop()
                for v in g[u]:
                    if not reachable[v]:
                        reachable[v] = true
                        stack.add(v)

            var dom = newSeqWith(n, newSeq[bool](n))
            for v in 0..<n:
                if v == root:
                    dom[v][v] = true
                elif reachable[v]:
                    for u in 0..<n:
                        dom[v][u] = reachable[u]

            var changed = true
            while changed:
                changed = false
                for v in 0..<n:
                    if not reachable[v] or v == root:
                        continue
                    var next = newSeq[bool](n)
                    for u in 0..<n:
                        next[u] = reachable[u]
                    for p in rev[v]:
                        if reachable[p]:
                            for u in 0..<n:
                                next[u] = next[u] and dom[p][u]
                    next[v] = true
                    if next != dom[v]:
                        dom[v] = next
                        changed = true

            var expected = newSeqWith(n, -1)
            expected[root] = root
            for v in 0..<n:
                if not reachable[v] or v == root:
                    continue
                for d in 0..<n:
                    if d != v and dom[v][d]:
                        var deepest = true
                        for other in 0..<n:
                            if other != v and other != d and dom[v][other] and
                               not dom[d][other]:
                                deepest = false
                        if deepest:
                            expected[v] = d
            doAssert g.dominator_tree(root) == expected
