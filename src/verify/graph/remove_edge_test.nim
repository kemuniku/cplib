# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import sequtils
import cplib/graph/graph
import cplib/graph/remove_edge

template checkGraph(init: untyped, weighted, undirected, isStatic: static bool) =
    block:
        var g = init
        template add(u, v, cost: int): int =
            when weighted: g.add_edge(u, v, cost)
            else: g.add_edge(u, v)
        discard add(2, 0, 5)
        discard add(0, 1, 7)
        discard add(0, 1, 9)
        discard add(0, 0, 11)
        let original = g.edge_info
        when isStatic:
            doAssert g.start.len == 0
        for removed in 0..<g.edge_count:
            var h = g.remove_edge(removed)
            static: doAssert h is typeof(g)
            doAssert h != g
            doAssert h.len == g.len
            doAssert h.edge_count == 3
            doAssert g.edge_info == original
            when isStatic:
                doAssert g.start.len == 0
            var expectedId = 0
            for oldId in 0..<g.edge_count:
                if oldId == removed: continue
                doAssert h.get_edge(expectedId) == g.get_edge(oldId)
                inc expectedId
            for u in 0..<g.len:
                var expected: seq[tuple[dst, id: int]]
                for id, e in h.edge_info:
                    if e.src == u: expected.add((e.dst, id))
                    when undirected:
                        if e.dst == u: expected.add((e.src, id))
                doAssert toSeq(h.to_and_id(u)) == expected
                for (dst, cost, id) in h.to_and_cost_and_id(u):
                    doAssert (dst, id) in expected
                    when weighted: doAssert cost == h.get_edge(id).cost
                    else: doAssert cost == 1
            when weighted: h.add_edge(1, 2, 13)
            else: h.add_edge(1, 2)
            doAssert h.edge_count == 4
            doAssert g.edge_info == original
        when isStatic: g.build()
        let originalAdjacent = toSeq(g.to_and_id(0))
        let all = toSeq(g.remove_each_edge())
        doAssert all.len == 4
        for id, h in all:
            doAssert h.edge_info == g.remove_edge(id).edge_info
        doAssert toSeq(g.to_and_id(0)) == originalAdjacent
        var h = all[0]
        when weighted: h.add_edge(1, 2, 17)
        else: h.add_edge(1, 2)
        doAssert all[1].edge_count == 3
        doAssert g.edge_info == original
        var single = init
        when weighted: single.add_edge(0, 0, 19)
        else: single.add_edge(0, 0)
        let empty = single.remove_edge(0)
        doAssert empty.len == single.len
        doAssert empty.edge_count == 0
        for u in 0..<empty.len:
            doAssert toSeq(empty.to_and_id(u)).len == 0
        doAssert toSeq(empty.remove_each_edge()).len == 0
        for id in [-1, g.edge_count, high(int)]:
            var raised = false
            try: discard g.remove_edge(id)
            except ValueError: raised = true
            doAssert raised
        var raised = false
        try: discard empty.remove_edge(0)
        except ValueError: raised = true
        doAssert raised

checkGraph(initWeightedDirectedGraph(4), true, false, false)
checkGraph(initWeightedUnDirectedGraph(4), true, true, false)
checkGraph(initUnWeightedDirectedGraph(4), false, false, false)
checkGraph(initUnWeightedUnDirectedGraph(4), false, true, false)
checkGraph(initWeightedDirectedStaticGraph(4), true, false, true)
checkGraph(initWeightedUnDirectedStaticGraph(4), true, true, true)
checkGraph(initUnWeightedDirectedStaticGraph(4), false, false, true)
checkGraph(initUnWeightedUnDirectedStaticGraph(4), false, true, true)

type Cost = object
    name: string
    value: float
var custom = initWeightedUnDirectedStaticGraph(2, Cost)
custom.add_edge(0, 1, Cost(name: "first", value: 1.5))
custom.add_edge(1, 0, Cost(name: "second", value: 2.5))
let copied = custom.remove_edge(0)
doAssert copied.get_edge(0).cost == Cost(name: "second", value: 2.5)
doAssert toSeq(copied[0]) == @[(1, Cost(name: "second", value: 2.5))]
doAssert custom.edge_count == 2
let noVertices = initUnWeightedDirectedGraph(0)
doAssert toSeq(noVertices.remove_each_edge()).len == 0
echo "Hello World"
