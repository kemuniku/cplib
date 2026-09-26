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
    echo \"Hello World\"\n\nimport algorithm, sequtils, sets\nimport cplib/utils/itertools\n\
    import cplib/graph/graph\n\nproc rootedCode(g: UnWeightedUnDirectedGraph, u: int,\
    \ parent: int = -1): string =\n    var children: seq[string]\n    for v in g[u]:\n\
    \        if v != parent: children.add(rootedCode(g, v, u))\n    children.sort()\n\
    \    result = \"(\"\n    for child in children: result.add(child)\n    result.add(')')\n\
    \nproc unrootedCode(g: UnWeightedUnDirectedGraph): string =\n    result = rootedCode(g,\
    \ 0)\n    for root in 1..<g.len:\n        result = min(result, rootedCode(g, root))\n\
    \nproc checkTree(g: UnWeightedUnDirectedGraph, n: int) =\n    doAssert g.len ==\
    \ n and g.edge_count == n - 1\n    var reached = newSeq[bool](n)\n    var queue\
    \ = @[0]\n    reached[0] = true\n    var head = 0\n    while head < queue.len:\n\
    \        for v in g[queue[head]]:\n            doAssert v in 0..<n and v != queue[head]\n\
    \            if not reached[v]:\n                reached[v] = true\n         \
    \       queue.add(v)\n        inc head\n    doAssert queue.len == n\n\nconst rootedCounts\
    \ = [1, 1, 2, 4, 9, 20, 48, 115, 286, 719, 1842, 4766]\nconst unrootedCounts =\
    \ [1, 1, 1, 2, 3, 6, 11, 23, 47, 106, 235, 551]\n\nfor n in 1..rootedCounts.len:\n\
    \    var rooted, unrooted = initHashSet[string]()\n    for tree in rooted_trees(n):\n\
    \        checkTree(tree, n)\n        let code = rootedCode(tree, 0)\n        doAssert\
    \ code notin rooted\n        rooted.incl(code)\n    for tree in unlabeled_trees(n):\n\
    \        checkTree(tree, n)\n        let code = unrootedCode(tree)\n        doAssert\
    \ code notin unrooted\n        unrooted.incl(code)\n    doAssert rooted.len ==\
    \ rootedCounts[n - 1]\n    doAssert unrooted.len == unrootedCounts[n - 1]\n  \
    \  if n <= 6:\n        var expectedRooted, expectedUnrooted = initHashSet[string]()\n\
    \        for tree in labeled_trees(n):\n            expectedUnrooted.incl(unrootedCode(tree))\n\
    \            for root in 0..<n:\n                expectedRooted.incl(rootedCode(tree,\
    \ root))\n        doAssert rooted == expectedRooted\n        doAssert unrooted\
    \ == expectedUnrooted\n\nblock:\n    let rooted = toSeq(rooted_trees(6))\n   \
    \ let unrooted = toSeq(unlabeled_trees(6))\n    doAssert rooted.mapIt(rootedCode(it,\
    \ 0)).toHashSet.len == rootedCounts[5]\n    doAssert unrooted.mapIt(unrootedCode(it)).toHashSet.len\
    \ == unrootedCounts[5]\n    let saved = rootedCode(rooted[1], 0)\n    var changed\
    \ = rooted[0]\n    changed.add_edge(0, 0)\n    doAssert rootedCode(rooted[1],\
    \ 0) == saved\n    var outerCount = 0\n    for outer in unlabeled_trees(6):\n\
    \        let before = unrootedCode(outer)\n        doAssert toSeq(rooted_trees(4)).len\
    \ == 4\n        doAssert toSeq(unlabeled_trees(4)).len == 2\n        doAssert\
    \ unrootedCode(outer) == before\n        inc outerCount\n    doAssert outerCount\
    \ == 6\n\nblock:\n    var count = 0\n    for tree in rooted_trees(10_000):\n \
    \       checkTree(tree, 10_000)\n        inc count\n        break\n    doAssert\
    \ count == 1\n\nfor n in [-1, 0]:\n    var rejected = false\n    try:\n      \
    \  for tree in rooted_trees(n): discard tree\n    except AssertionDefect:\n  \
    \      rejected = true\n    doAssert rejected\n    rejected = false\n    try:\n\
    \        for tree in unlabeled_trees(n): discard tree\n    except AssertionDefect:\n\
    \        rejected = true\n    doAssert rejected\n"
  dependsOn:
  - cplib/utils/itertools.nim
  - cplib/tree/prufer.nim
  - cplib/utils/itertools.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/tree/prufer.nim
  isVerificationFile: true
  path: verify/AI/itertools_trees_test.nim
  requiredBy: []
  timestamp: '2026-09-22 15:33:23+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/itertools_trees_test.nim
layout: document
redirect_from:
- /verify/verify/AI/itertools_trees_test.nim
- /verify/verify/AI/itertools_trees_test.nim.html
title: verify/AI/itertools_trees_test.nim
---
