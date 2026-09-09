# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils, algorithm, sets, options, math
import cplib/utils/itertools
import cplib/graph/graph

proc `<`(a, b: seq[int]): bool =
    for i in 0..<min(a.len, b.len):
        if a[i] != b[i]: return a[i] < b[i]
    return a.len < b.len

# 制約なしの全探索を絞り込んだ結果と、制約付き列挙を比較する。
proc monotone(a: seq[int], strict: bool): bool =
    for i in 1..<a.len:
        if a[i - 1] > a[i] or (strict and a[i - 1] == a[i]): return false
    return true

for n in 0..4:
    for l in -2..1:
        for r in l..3:
            var all: seq[seq[int]]
            if n == 0: all = @[newSeq[int]()]
            elif l < r: all = toSeq(product(toSeq(l..<r), n)).sorted()
            let weak = all.filterIt(monotone(it, false))
            let strict = all.filterIt(monotone(it, true))
            doAssert toSeq(nondecreasing_sequences(n, l, r)) == weak
            doAssert toSeq(strictly_increasing_sequences(n, l, r)) == strict
            for s in -9..9:
                doAssert toSeq(bounded_sum_sequences(n, s, l, r)) == all.filterIt(it.sum == s)
                doAssert toSeq(nondecreasing_sequences(n, s, l, r)) == weak.filterIt(it.sum == s)
                doAssert toSeq(strictly_increasing_sequences(n, s, l, r)) == strict.filterIt(it.sum == s)

let rangeChoices = @[(l: -2, r: 0), (l: 0, r: 3), (l: -1, r: 2), (l: 1, r: 1), (l: 2, r: 0)]
for n in 0..3:
    for bounds in product(rangeChoices, n):
        var all: seq[seq[int]]
        for a in product(toSeq(-2..2), n):
            var valid = true
            for i in 0..<n:
                if a[i] < bounds[i].l or a[i] >= bounds[i].r: valid = false
            if valid: all.add(a)
        all.sort()
        for s in -7..7:
            doAssert toSeq(bounded_sum_sequences(s, bounds)) == all.filterIt(it.sum == s)

doAssert toSeq(cartesian_product(@[@[0, 1], @[2, 4, 6], @[3]])) == @[
    @[0, 2, 3], @[0, 4, 3], @[0, 6, 3], @[1, 2, 3], @[1, 4, 3], @[1, 6, 3]]
doAssert toSeq(cartesian_product(newSeq[seq[int]]())) == @[newSeq[int]()]
doAssert toSeq(cartesian_product(@[@[1], newSeq[int](), @[2]])).len == 0
doAssert toSeq(cartesian_product(@[@["a", "a"], @["b"]])) == @[@["a", "b"], @["a", "b"]]

# 全てのグループ割当を正規化して集合分割の期待値を作る。
for n in 0..5:
    var expected = initHashSet[seq[int]]()
    for assignment in product(toSeq(0..<n), n):
        var labels: seq[int]
        var normalized: seq[int]
        for group in assignment:
            if group notin labels: labels.add(group)
            normalized.add(labels.find(group))
        expected.incl(normalized)
    let actual = toSeq(set_partitions(n))
    doAssert actual.len == expected.len and actual.toHashSet == expected
    doAssert actual == actual.sorted()
    for k in 0..n + 1:
        doAssert toSeq(set_partitions(n, k)) == actual.filterIt(it.toHashSet.len == k)

# 順列を2個ずつ組にして正規化した結果とペア分けを比較する。
for n in 0..8:
    var expected = initHashSet[seq[tuple[u, v: int]]]()
    if n mod 2 == 0:
        for permutation in permutations(toSeq(0..<n)):
            var pairs: seq[tuple[u, v: int]]
            for i in countup(0, n - 1, 2):
                pairs.add((min(permutation[i], permutation[i + 1]), max(permutation[i], permutation[i + 1])))
            pairs.sort()
            expected.incl(pairs)
    let actual = toSeq(pairings(n))
    doAssert actual.len == expected.len and actual.toHashSet == expected

for n in 0..6:
    var expected: seq[seq[int]]
    if n == 0: expected = @[@[0]]
    else:
        for mask in 0..<(1 shl (n - 1)):
            var boundaries = @[0]
            for i in 1..<n:
                if (mask and (1 shl (i - 1))) != 0: boundaries.add(i)
            boundaries.add(n)
            expected.add(boundaries)
    doAssert toSeq(contiguous_partitions(n)).sorted() == expected.sorted()
    for k in 0..n + 1:
        doAssert toSeq(contiguous_partitions(n, k)).sorted() == expected.filterIt(it.len == k + 1).sorted()

for n in 0..5:
    var expected: seq[string]
    for chars in product(@['(', ')'], 2 * n):
        var balance = 0
        var valid = true
        var s = ""
        for c in chars:
            balance += (if c == '(': 1 else: -1)
            if balance < 0: valid = false
            s.add(c)
        if valid and balance == 0: expected.add(s)
    doAssert toSeq(parenthesis_sequences(n)) == expected.sorted()

proc graphEdges(g: UnWeightedUnDirectedGraph): seq[tuple[u, v: int]] =
    for u in 0..<g.len:
        for v in g[u]:
            doAssert u != v
            if u < v: result.add((u, v))
    result.sort()

for n in 1..5:
    let trees = toSeq(labeled_trees(n))
    doAssert trees.len == (if n == 1: 1 else: n ^ (n - 2))
    var seen = initHashSet[seq[tuple[u, v: int]]]()
    for tree in trees:
        let edges = graphEdges(tree)
        doAssert tree.len == n and edges.len == n - 1
        doAssert edges.toHashSet.len == edges.len and edges notin seen
        seen.incl(edges)
        var reached = newSeq[bool](n)
        var queue = @[0]
        reached[0] = true
        var head = 0
        while head < queue.len:
            for v in tree[queue[head]]:
                if not reached[v]:
                    reached[v] = true
                    queue.add(v)
            inc head
        doAssert queue.len == n

for n in 0..4:
    let graphs = toSeq(simple_graphs(n))
    doAssert graphs.len == 1 shl (n * (n - 1) div 2)
    let allEdges = graphs.mapIt(graphEdges(it))
    doAssert allEdges.toHashSet.len == allEdges.len
    for m in 0..n * (n - 1) div 2 + 1:
        let expected = allEdges.filterIt(it.len == m)
        let actual = toSeq(simple_graphs(n, m)).mapIt(graphEdges(it))
        doAssert actual.toHashSet == expected.toHashSet and actual.len == expected.len

proc bruteOrders(adj: seq[seq[int]]): seq[seq[int]] =
    for order in permutations(toSeq(0..<adj.len)):
        var position = newSeq[int](adj.len)
        for i, u in order: position[u] = i
        var valid = true
        for u, edges in adj:
            for v in edges:
                if position[u] >= position[v]: valid = false
        if valid: result.add(order)

for n in 0..3:
    # 自己ループを含む全ての有向グラフで検証する。
    for mask in 0..<(1 shl (n * n)):
        var adj = newSeq[seq[int]](n)
        var graph = initUnWeightedDirectedGraph(n)
        for u in 0..<n:
            for v in 0..<n:
                if (mask and (1 shl (u * n + v))) != 0:
                    adj[u].add(v)
                    graph.add_edge(u, v)
        let expected = bruteOrders(adj)
        doAssert toSeq(topological_orders(adj)) == expected
        doAssert toSeq(topological_orders(graph)) == expected

block:
    let adj = @[@[2, 2], @[2], newSeq[int](), newSeq[int]()]
    var graph = initWeightedDirectedGraph(4)
    var staticGraph = initWeightedDirectedStaticGraph(4)
    var unweightedStaticGraph = initUnWeightedDirectedStaticGraph(4)
    for u, edges in adj:
        for v in edges:
            graph.add_edge(u, v, -7)
            staticGraph.add_edge(u, v, 3)
            unweightedStaticGraph.add_edge(u, v)
    staticGraph.build()
    unweightedStaticGraph.build()
    let expected = bruteOrders(adj)
    doAssert toSeq(topological_orders(graph)) == expected
    doAssert toSeq(topological_orders(staticGraph)) == expected
    doAssert toSeq(topological_orders(unweightedStaticGraph)) == expected

for n in 0..4:
    doAssert toSeq(integer_vectors_l1(n, -1)).len == 0
    for s in 0..3:
        let expected = toSeq(product(toSeq(-s..s), n)).filterIt(it.mapIt(abs(it)).sum <= s).sorted()
        doAssert toSeq(integer_vectors_l1(n, s)) == expected

block:
    proc solve(a: seq[int]): int = a.sum + (if 3 in a: 1 else: 0)
    proc naive(a: seq[int]): int = a.sum
    let cases = @[@[0], @[1, 3], @[3]]
    let mismatch = find_counterexample(cases, solve, naive)
    doAssert mismatch.isSome
    doAssert mismatch.get == (input: @[1, 3], actual: 5, expected: 4)
    doAssert find_counterexample(cases, naive, naive).isNone
    doAssert find_counterexample(newSeq[seq[int]](), solve, naive).isNone
    var generated = 0
    iterator inputs(): seq[int] {.closure.} =
        for a in cases:
            inc generated
            yield a
    doAssert find_counterexample(inputs, solve, naive) == mismatch
    doAssert generated == 2
    iterator emptyInputs(): seq[int] {.closure.} =
        discard
    doAssert find_counterexample(emptyInputs, solve, naive).isNone

block:
    let original = @[100, 80, -7]
    proc fails(a: seq[int]): bool = a.anyIt(it >= 3)
    let shrunk = shrink_counterexample(original, fails)
    doAssert shrunk == @[3] and fails(shrunk)
    doAssert original == @[100, 80, -7]
    doAssert shrink_counterexample(@[-100, 0], proc(a: seq[int]): bool = a.anyIt(it <= -3)) == @[-3]
    doAssert shrink_counterexample(@[low(int)], proc(a: seq[int]): bool = a.anyIt(it < 0)) == @[-1]
    doAssert shrink_counterexample(@[high(int)], proc(a: seq[int]): bool = a.anyIt(it > 0)) == @[1]
    doAssert shrink_counterexample(@[1, 2], proc(a: seq[int]): bool = true).len == 0
    doAssert shrink_counterexample(@[1_000_000_000], proc(a: seq[int]): bool = a.anyIt(it >= 600_000_000)) == @[600_000_000]

# 全結果を蓄積せず、最初の1件だけを取得して中断できる。
block:
    for a in bounded_sum_sequences(100, 100, 0, 101):
        doAssert a.len == 100 and a.sum == 100
        break
    for a in set_partitions(100):
        doAssert a == newSeq[int](100)
        break
    for pairs in pairings(100):
        doAssert pairs.len == 50
        break
    for s in parenthesis_sequences(100):
        doAssert s.len == 200
        break
    for order in topological_orders(newSeq[seq[int]](100)):
        doAssert order == toSeq(0..<100)
        break
