# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, sequtils, sets
import cplib/utils/itertools
import cplib/graph/graph

proc rootedCode(g: UnWeightedUnDirectedGraph, u: int, parent: int = -1): string =
    var children: seq[string]
    for v in g[u]:
        if v != parent: children.add(rootedCode(g, v, u))
    children.sort()
    result = "("
    for child in children: result.add(child)
    result.add(')')

proc unrootedCode(g: UnWeightedUnDirectedGraph): string =
    result = rootedCode(g, 0)
    for root in 1..<g.len:
        result = min(result, rootedCode(g, root))

proc checkTree(g: UnWeightedUnDirectedGraph, n: int) =
    doAssert g.len == n and g.edge_count == n - 1
    var reached = newSeq[bool](n)
    var queue = @[0]
    reached[0] = true
    var head = 0
    while head < queue.len:
        for v in g[queue[head]]:
            doAssert v in 0..<n and v != queue[head]
            if not reached[v]:
                reached[v] = true
                queue.add(v)
        inc head
    doAssert queue.len == n

const rootedCounts = [1, 1, 2, 4, 9, 20, 48, 115, 286, 719, 1842, 4766]
const unrootedCounts = [1, 1, 1, 2, 3, 6, 11, 23, 47, 106, 235, 551]

for n in 1..rootedCounts.len:
    var rooted, unrooted = initHashSet[string]()
    for tree in rooted_trees(n):
        checkTree(tree, n)
        let code = rootedCode(tree, 0)
        doAssert code notin rooted
        rooted.incl(code)
    for tree in unlabeled_trees(n):
        checkTree(tree, n)
        let code = unrootedCode(tree)
        doAssert code notin unrooted
        unrooted.incl(code)
    doAssert rooted.len == rootedCounts[n - 1]
    doAssert unrooted.len == unrootedCounts[n - 1]
    if n <= 6:
        var expectedRooted, expectedUnrooted = initHashSet[string]()
        for tree in labeled_trees(n):
            expectedUnrooted.incl(unrootedCode(tree))
            for root in 0..<n:
                expectedRooted.incl(rootedCode(tree, root))
        doAssert rooted == expectedRooted
        doAssert unrooted == expectedUnrooted

block:
    let rooted = toSeq(rooted_trees(6))
    let unrooted = toSeq(unlabeled_trees(6))
    doAssert rooted.mapIt(rootedCode(it, 0)).toHashSet.len == rootedCounts[5]
    doAssert unrooted.mapIt(unrootedCode(it)).toHashSet.len == unrootedCounts[5]
    let saved = rootedCode(rooted[1], 0)
    var changed = rooted[0]
    changed.add_edge(0, 0)
    doAssert rootedCode(rooted[1], 0) == saved
    var outerCount = 0
    for outer in unlabeled_trees(6):
        let before = unrootedCode(outer)
        doAssert toSeq(rooted_trees(4)).len == 4
        doAssert toSeq(unlabeled_trees(4)).len == 2
        doAssert unrootedCode(outer) == before
        inc outerCount
    doAssert outerCount == 6

block:
    var count = 0
    for tree in rooted_trees(10_000):
        checkTree(tree, 10_000)
        inc count
        break
    doAssert count == 1

for n in [-1, 0]:
    var rejected = false
    try:
        for tree in rooted_trees(n): discard tree
    except AssertionDefect:
        rejected = true
    doAssert rejected
    rejected = false
    try:
        for tree in unlabeled_trees(n): discard tree
    except AssertionDefect:
        rejected = true
    doAssert rejected
