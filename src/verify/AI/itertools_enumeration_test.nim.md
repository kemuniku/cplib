---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/itertools.nim
    title: cplib/utils/itertools.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/itertools.nim
    title: cplib/utils/itertools.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport sequtils, algorithm, sets, options, math\nimport\
    \ cplib/utils/itertools\nimport cplib/graph/graph\n\nproc `<`(a, b: seq[int]):\
    \ bool =\n    for i in 0..<min(a.len, b.len):\n        if a[i] != b[i]: return\
    \ a[i] < b[i]\n    return a.len < b.len\n\n# \u5236\u7D04\u306A\u3057\u306E\u5168\
    \u63A2\u7D22\u3092\u7D5E\u308A\u8FBC\u3093\u3060\u7D50\u679C\u3068\u3001\u5236\
    \u7D04\u4ED8\u304D\u5217\u6319\u3092\u6BD4\u8F03\u3059\u308B\u3002\nproc monotone(a:\
    \ seq[int], strict: bool): bool =\n    for i in 1..<a.len:\n        if a[i - 1]\
    \ > a[i] or (strict and a[i - 1] == a[i]): return false\n    return true\n\nfor\
    \ n in 0..4:\n    for l in -2..1:\n        for r in l..3:\n            var all:\
    \ seq[seq[int]]\n            if n == 0: all = @[newSeq[int]()]\n            elif\
    \ l < r: all = toSeq(product(toSeq(l..<r), n)).sorted()\n            let weak\
    \ = all.filterIt(monotone(it, false))\n            let strict = all.filterIt(monotone(it,\
    \ true))\n            doAssert toSeq(nondecreasing_sequences(n, l, r)) == weak\n\
    \            doAssert toSeq(strictly_increasing_sequences(n, l, r)) == strict\n\
    \            for s in -9..9:\n                doAssert toSeq(bounded_sum_sequences(n,\
    \ s, l, r)) == all.filterIt(it.sum == s)\n                doAssert toSeq(nondecreasing_sequences(n,\
    \ s, l, r)) == weak.filterIt(it.sum == s)\n                doAssert toSeq(strictly_increasing_sequences(n,\
    \ s, l, r)) == strict.filterIt(it.sum == s)\n\nfor n in 0..4:\n    for a in product(@[0,\
    \ 1, 2], n):\n        var expected: seq[seq[int]]\n        for b in product(@[0,\
    \ 1, 2], n):\n            var valid = true\n            for i in 0..<n:\n    \
    \            if b[i] > a[i]: valid = false\n            if valid: expected.add(b)\n\
    \        doAssert toSeq(bounded_sequences(a)) == expected.sorted()\n\ndoAssert\
    \ toSeq(bounded_sequences([1, 2])) == @[\n    @[0, 0], @[0, 1], @[0, 2], @[1,\
    \ 0], @[1, 1], @[1, 2]]\ndoAssert toSeq(bounded_sequences(newSeq[int]())) == @[newSeq[int]()]\n\
    doAssert toSeq(bounded_sequences([0, 0])) == @[@[0, 0]]\nblock:\n    var count\
    \ = 0\n    for b in bounded_sequences([high(int), 0]):\n        doAssert b ==\
    \ @[count, 0]\n        inc count\n        if count == 3: break\n    doAssert count\
    \ == 3\n\nlet rangeChoices = @[(l: -2, r: 0), (l: 0, r: 3), (l: -1, r: 2), (l:\
    \ 1, r: 1), (l: 2, r: 0)]\nfor n in 0..3:\n    for bounds in product(rangeChoices,\
    \ n):\n        var all: seq[seq[int]]\n        for a in product(toSeq(-2..2),\
    \ n):\n            var valid = true\n            for i in 0..<n:\n           \
    \     if a[i] < bounds[i].l or a[i] >= bounds[i].r: valid = false\n          \
    \  if valid: all.add(a)\n        all.sort()\n        for s in -7..7:\n       \
    \     doAssert toSeq(bounded_sum_sequences(s, bounds)) == all.filterIt(it.sum\
    \ == s)\n\ndoAssert toSeq(cartesian_product(@[@[0, 1], @[2, 4, 6], @[3]])) ==\
    \ @[\n    @[0, 2, 3], @[0, 4, 3], @[0, 6, 3], @[1, 2, 3], @[1, 4, 3], @[1, 6,\
    \ 3]]\ndoAssert toSeq(cartesian_product(newSeq[seq[int]]())) == @[newSeq[int]()]\n\
    doAssert toSeq(cartesian_product(@[@[1], newSeq[int](), @[2]])).len == 0\ndoAssert\
    \ toSeq(cartesian_product(@[@[\"a\", \"a\"], @[\"b\"]])) == @[@[\"a\", \"b\"],\
    \ @[\"a\", \"b\"]]\n\n# \u5168\u3066\u306E\u30B0\u30EB\u30FC\u30D7\u5272\u5F53\
    \u3092\u6B63\u898F\u5316\u3057\u3066\u96C6\u5408\u5206\u5272\u306E\u671F\u5F85\
    \u5024\u3092\u4F5C\u308B\u3002\nfor n in 0..5:\n    var expected = initHashSet[seq[int]]()\n\
    \    for assignment in product(toSeq(0..<n), n):\n        var labels: seq[int]\n\
    \        var normalized: seq[int]\n        for group in assignment:\n        \
    \    if group notin labels: labels.add(group)\n            normalized.add(labels.find(group))\n\
    \        expected.incl(normalized)\n    let actual = toSeq(set_partitions_id(n))\n\
    \    doAssert actual.len == expected.len and actual.toHashSet == expected\n  \
    \  doAssert actual == actual.sorted()\n    for k in 0..n + 1:\n        doAssert\
    \ toSeq(set_partitions_id(n, k)) == actual.filterIt(it.toHashSet.len == k)\n \
    \   for k in -1..n + 1:\n        let grouped = toSeq(set_partitions(n, k))\n \
    \       var restored: seq[seq[int]]\n        for groups in grouped:\n        \
    \    doAssert groups.concat.sorted() == toSeq(0..<n)\n            var ids = newSeq[int](n)\n\
    \            for id, group in groups:\n                doAssert group.len > 0\
    \ and group == group.sorted()\n                if id > 0: doAssert groups[id -\
    \ 1][0] < group[0]\n                for element in group: ids[element] = id\n\
    \            restored.add(ids)\n        doAssert restored == toSeq(set_partitions_id(n,\
    \ k))\n\ndoAssert toSeq(set_partitions(3)) == @[\n    @[@[0, 1, 2]], @[@[0, 1],\
    \ @[2]], @[@[0, 2], @[1]],\n    @[@[0], @[1, 2]], @[@[0], @[1], @[2]]]\ndoAssert\
    \ toSeq(set_partitions(0)) == @[newSeq[seq[int]]()]\n\nblock:\n    let expected\
    \ = toSeq(set_partitions(4))\n    var saved: seq[seq[seq[int]]]\n    for groups\
    \ in set_partitions(4):\n        saved.add(groups)\n        var copied = groups\n\
    \        copied[0][0] = -1\n        doAssert groups == expected[saved.len - 1]\n\
    \        var innerCount = 0\n        for inner in set_partitions(3):\n       \
    \     doAssert inner.concat.sorted() == @[0, 1, 2]\n            inc innerCount\n\
    \        doAssert innerCount == 5\n        doAssert groups == expected[saved.len\
    \ - 1]\n    doAssert saved == expected\n\n# \u9806\u5217\u30922\u500B\u305A\u3064\
    \u7D44\u306B\u3057\u3066\u6B63\u898F\u5316\u3057\u305F\u7D50\u679C\u3068\u30DA\
    \u30A2\u5206\u3051\u3092\u6BD4\u8F03\u3059\u308B\u3002\nfor n in 0..8:\n    var\
    \ expected = initHashSet[seq[tuple[u, v: int]]]()\n    if n mod 2 == 0:\n    \
    \    for permutation in permutations(toSeq(0..<n)):\n            var pairs: seq[tuple[u,\
    \ v: int]]\n            for i in countup(0, n - 1, 2):\n                pairs.add((min(permutation[i],\
    \ permutation[i + 1]), max(permutation[i], permutation[i + 1])))\n           \
    \ pairs.sort()\n            expected.incl(pairs)\n    let actual = toSeq(pairings(n))\n\
    \    doAssert actual.len == expected.len and actual.toHashSet == expected\n\n\
    for n in 0..6:\n    var expected: seq[seq[int]]\n    if n == 0: expected = @[@[0]]\n\
    \    else:\n        for mask in 0..<(1 shl (n - 1)):\n            var boundaries\
    \ = @[0]\n            for i in 1..<n:\n                if (mask and (1 shl (i\
    \ - 1))) != 0: boundaries.add(i)\n            boundaries.add(n)\n            expected.add(boundaries)\n\
    \    doAssert toSeq(contiguous_partitions(n)).sorted() == expected.sorted()\n\
    \    for k in 0..n + 1:\n        doAssert toSeq(contiguous_partitions(n, k)).sorted()\
    \ == expected.filterIt(it.len == k + 1).sorted()\n\nfor n in 0..5:\n    var expected:\
    \ seq[string]\n    for chars in product(@['(', ')'], 2 * n):\n        var balance\
    \ = 0\n        var valid = true\n        var s = \"\"\n        for c in chars:\n\
    \            balance += (if c == '(': 1 else: -1)\n            if balance < 0:\
    \ valid = false\n            s.add(c)\n        if valid and balance == 0: expected.add(s)\n\
    \    doAssert toSeq(parenthesis_sequences(n)) == expected.sorted()\n\nproc graphEdges(g:\
    \ UnWeightedUnDirectedGraph): seq[tuple[u, v: int]] =\n    for u in 0..<g.len:\n\
    \        for v in g[u]:\n            doAssert u != v\n            if u < v: result.add((u,\
    \ v))\n    result.sort()\n\nfor n in 1..5:\n    let trees = toSeq(labeled_trees(n))\n\
    \    doAssert trees.len == (if n == 1: 1 else: n ^ (n - 2))\n    var seen = initHashSet[seq[tuple[u,\
    \ v: int]]]()\n    for tree in trees:\n        let edges = graphEdges(tree)\n\
    \        doAssert tree.len == n and edges.len == n - 1\n        doAssert edges.toHashSet.len\
    \ == edges.len and edges notin seen\n        seen.incl(edges)\n        var reached\
    \ = newSeq[bool](n)\n        var queue = @[0]\n        reached[0] = true\n   \
    \     var head = 0\n        while head < queue.len:\n            for v in tree[queue[head]]:\n\
    \                if not reached[v]:\n                    reached[v] = true\n \
    \                   queue.add(v)\n            inc head\n        doAssert queue.len\
    \ == n\n\nfor n in 0..4:\n    let graphs = toSeq(simple_graphs(n))\n    doAssert\
    \ graphs.len == 1 shl (n * (n - 1) div 2)\n    let allEdges = graphs.mapIt(graphEdges(it))\n\
    \    doAssert allEdges.toHashSet.len == allEdges.len\n    for m in 0..n * (n -\
    \ 1) div 2 + 1:\n        let expected = allEdges.filterIt(it.len == m)\n     \
    \   let actual = toSeq(simple_graphs(n, m)).mapIt(graphEdges(it))\n        doAssert\
    \ actual.toHashSet == expected.toHashSet and actual.len == expected.len\n\nproc\
    \ bruteOrders(adj: seq[seq[int]]): seq[seq[int]] =\n    for order in permutations(toSeq(0..<adj.len)):\n\
    \        var position = newSeq[int](adj.len)\n        for i, u in order: position[u]\
    \ = i\n        var valid = true\n        for u, edges in adj:\n            for\
    \ v in edges:\n                if position[u] >= position[v]: valid = false\n\
    \        if valid: result.add(order)\n\nfor n in 0..3:\n    # \u81EA\u5DF1\u30EB\
    \u30FC\u30D7\u3092\u542B\u3080\u5168\u3066\u306E\u6709\u5411\u30B0\u30E9\u30D5\
    \u3067\u691C\u8A3C\u3059\u308B\u3002\n    for mask in 0..<(1 shl (n * n)):\n \
    \       var adj = newSeq[seq[int]](n)\n        var graph = initUnWeightedDirectedGraph(n)\n\
    \        for u in 0..<n:\n            for v in 0..<n:\n                if (mask\
    \ and (1 shl (u * n + v))) != 0:\n                    adj[u].add(v)\n        \
    \            graph.add_edge(u, v)\n        let expected = bruteOrders(adj)\n \
    \       doAssert toSeq(topological_orders(adj)) == expected\n        doAssert\
    \ toSeq(topological_orders(graph)) == expected\n\nblock:\n    let adj = @[@[2,\
    \ 2], @[2], newSeq[int](), newSeq[int]()]\n    var graph = initWeightedDirectedGraph(4)\n\
    \    var staticGraph = initWeightedDirectedStaticGraph(4)\n    var unweightedStaticGraph\
    \ = initUnWeightedDirectedStaticGraph(4)\n    for u, edges in adj:\n        for\
    \ v in edges:\n            graph.add_edge(u, v, -7)\n            staticGraph.add_edge(u,\
    \ v, 3)\n            unweightedStaticGraph.add_edge(u, v)\n    staticGraph.build()\n\
    \    unweightedStaticGraph.build()\n    let expected = bruteOrders(adj)\n    doAssert\
    \ toSeq(topological_orders(graph)) == expected\n    doAssert toSeq(topological_orders(staticGraph))\
    \ == expected\n    doAssert toSeq(topological_orders(unweightedStaticGraph)) ==\
    \ expected\n\nfor n in 0..4:\n    doAssert toSeq(integer_vectors_l1(n, -1)).len\
    \ == 0\n    for s in 0..3:\n        let expected = toSeq(product(toSeq(-s..s),\
    \ n)).filterIt(it.mapIt(abs(it)).sum <= s).sorted()\n        doAssert toSeq(integer_vectors_l1(n,\
    \ s)) == expected\n\nblock:\n    proc solve(a: seq[int]): int = a.sum + (if 3\
    \ in a: 1 else: 0)\n    proc naive(a: seq[int]): int = a.sum\n    let cases =\
    \ @[@[0], @[1, 3], @[3]]\n    let mismatch = find_counterexample(cases, solve,\
    \ naive)\n    doAssert mismatch.isSome\n    doAssert mismatch.get == (input: @[1,\
    \ 3], actual: 5, expected: 4)\n    doAssert find_counterexample(cases, naive,\
    \ naive).isNone\n    doAssert find_counterexample(newSeq[seq[int]](), solve, naive).isNone\n\
    \    var generated = 0\n    iterator inputs(): seq[int] {.closure.} =\n      \
    \  for a in cases:\n            inc generated\n            yield a\n    doAssert\
    \ find_counterexample(inputs, solve, naive) == mismatch\n    doAssert generated\
    \ == 2\n    iterator emptyInputs(): seq[int] {.closure.} =\n        discard\n\
    \    doAssert find_counterexample(emptyInputs, solve, naive).isNone\n\nblock:\n\
    \    let original = @[100, 80, -7]\n    proc fails(a: seq[int]): bool = a.anyIt(it\
    \ >= 3)\n    let shrunk = shrink_counterexample(original, fails)\n    doAssert\
    \ shrunk == @[3] and fails(shrunk)\n    doAssert original == @[100, 80, -7]\n\
    \    doAssert shrink_counterexample(@[-100, 0], proc(a: seq[int]): bool = a.anyIt(it\
    \ <= -3)) == @[-3]\n    doAssert shrink_counterexample(@[low(int)], proc(a: seq[int]):\
    \ bool = a.anyIt(it < 0)) == @[-1]\n    doAssert shrink_counterexample(@[high(int)],\
    \ proc(a: seq[int]): bool = a.anyIt(it > 0)) == @[1]\n    doAssert shrink_counterexample(@[1,\
    \ 2], proc(a: seq[int]): bool = true).len == 0\n    doAssert shrink_counterexample(@[1_000_000_000],\
    \ proc(a: seq[int]): bool = a.anyIt(it >= 600_000_000)) == @[600_000_000]\n\n\
    # \u5168\u7D50\u679C\u3092\u84C4\u7A4D\u305B\u305A\u3001\u6700\u521D\u306E1\u4EF6\
    \u3060\u3051\u3092\u53D6\u5F97\u3057\u3066\u4E2D\u65AD\u3067\u304D\u308B\u3002\
    \nblock:\n    for a in bounded_sum_sequences(100, 100, 0, 101):\n        doAssert\
    \ a.len == 100 and a.sum == 100\n        break\n    for a in set_partitions_id(100):\n\
    \        doAssert a == newSeq[int](100)\n        break\n    for groups in set_partitions(100):\n\
    \        doAssert groups == @[toSeq(0..<100)]\n        break\n    for pairs in\
    \ pairings(100):\n        doAssert pairs.len == 50\n        break\n    for s in\
    \ parenthesis_sequences(100):\n        doAssert s.len == 200\n        break\n\
    \    for order in topological_orders(newSeq[seq[int]](100)):\n        doAssert\
    \ order == toSeq(0..<100)\n        break\n"
  dependsOn:
  - cplib/tree/prufer.nim
  - cplib/utils/itertools.nim
  - cplib/utils/itertools.nim
  - cplib/tree/prufer.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/itertools_enumeration_test.nim
  requiredBy: []
  timestamp: '2026-09-09 16:56:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/itertools_enumeration_test.nim
layout: document
redirect_from:
- /verify/verify/AI/itertools_enumeration_test.nim
- /verify/verify/AI/itertools_enumeration_test.nim.html
title: verify/AI/itertools_enumeration_test.nim
---
