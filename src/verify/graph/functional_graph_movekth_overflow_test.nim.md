---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
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
    import cplib/graph/functional_graph\n\nproc expected(next: seq[int], start, count:\
    \ int): int =\n    var seen = newSeq[int](next.len)\n    for i in 0..<seen.len:\n\
    \        seen[i] = -1\n    var path: seq[int] = @[]\n    var v = start\n    while\
    \ seen[v] == -1:\n        seen[v] = path.len\n        path.add(v)\n        v =\
    \ next[v]\n    if count < path.len:\n        return path[count]\n    let prefix\
    \ = seen[v]\n    return path[prefix + (count-prefix) mod (path.len-prefix)]\n\n\
    for next in [@[0], @[1, 0], @[1, 2, 0], @[1, 2, 0, 2, 3], @[0, 2, 1, 4, 2]]:\n\
    \    let graph = initFunctionalGraph(next)\n    for start in 0..<next.len:\n \
    \       for count in 0..100:\n            doAssert graph.movekth(start, count)\
    \ == expected(next, start, count)\n        for count in [high(int)-2, high(int)-1,\
    \ high(int)]:\n            doAssert graph.movekth(start, count) == expected(next,\
    \ start, count)\necho \"Hello World\"\n"
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/graph/functional_graph.nim
  - cplib/graph/functional_graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/graph/functional_graph_movekth_overflow_test.nim
  requiredBy: []
  timestamp: '2026-10-01 00:36:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/functional_graph_movekth_overflow_test.nim
layout: document
redirect_from:
- /verify/verify/graph/functional_graph_movekth_overflow_test.nim
- /verify/verify/graph/functional_graph_movekth_overflow_test.nim.html
title: verify/graph/functional_graph_movekth_overflow_test.nim
---
