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
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/warshall_floyd_aoj_test.nim
    title: verify/graph/dynamic/warshall_floyd_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/warshall_floyd_aoj_test.nim
    title: verify/graph/dynamic/warshall_floyd_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/warshall_floyd_aoj_test.nim
    title: verify/graph/static/warshall_floyd_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/warshall_floyd_aoj_test.nim
    title: verify/graph/static/warshall_floyd_aoj_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_WARSHALLFLOYD:\n    const CPLIB_GRAPH_WARSHALLFLOYD*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/utils/constants\n    import\
    \ sequtils\n    proc warshall_floyd_impl[T](g: DynamicGraph[T] or StaticGraph[T],\
    \ zero, inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] =\n        var d\
    \ = newSeqWith(g.len, newSeqWith(g.len, inf))\n        for i in 0..<g.len: d[i][i]\
    \ = zero\n        for i in 0..<g.len:\n            for (j, cost) in g.to_and_cost(i):\n\
    \                d[i][j] = cost\n        for k in 0..<g.len:\n            for\
    \ i in 0..<g.len:\n                for j in 0..<g.len:\n                    if\
    \ d[i][k] != inf and d[k][j] != inf:\n                        d[i][j] = min(d[i][j],\
    \ d[i][k] + d[k][j])\n            for i in 0..<g.len:\n                if d[i][i]\
    \ < 0: return (negative_cycle: true, d: d)\n        return (negative_cycle: false,\
    \ d: d)\n\n    proc warshall_floyd*(g: DynamicGraph[int] or StaticGraph[int],\
    \ zero: int = 0, inf: int = INF64): tuple[negative_cycle: bool, d: seq[seq[int]]]\
    \ = warshall_floyd_impl(g, zero, inf)\n    proc warshall_floyd*(g: DynamicGraph[int32]\
    \ or StaticGraph[int32], zero: int32 = 0.int32, inf: int = INF32): tuple[negative_cycle:\
    \ bool, d: seq[seq[int32]]] = warshall_floyd_impl(g, zero, inf)\n    proc warshall_floyd*(g:\
    \ DynamicGraph[SomeFloat] or StaticGraph[SomeFloat], zero: SomeFloat = 0.0, inf:\
    \ SomeFloat = 1e100): tuple[negative_cycle: bool, d: seq[seq[float]]] = warshall_floyd_impl(g,\
    \ zero, inf)\n    proc warshall_floyd*[T](g: DynamicGraph[T] or StaticGraph[T],\
    \ zero, inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] = warshall_floyd_impl(g,\
    \ zero, inf)\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/graph/warshall_floyd.nim
  requiredBy: []
  timestamp: '2024-06-25 03:55:23+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/dynamic/warshall_floyd_aoj_test.nim
  - verify/graph/dynamic/warshall_floyd_aoj_test.nim
  - verify/graph/static/warshall_floyd_aoj_test.nim
  - verify/graph/static/warshall_floyd_aoj_test.nim
documentation_of: cplib/graph/warshall_floyd.nim
layout: document
redirect_from:
- /library/cplib/graph/warshall_floyd.nim
- /library/cplib/graph/warshall_floyd.nim.html
title: cplib/graph/warshall_floyd.nim
---