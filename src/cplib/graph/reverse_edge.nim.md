---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/SCC.nim
    title: cplib/graph/SCC.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/SCC.nim
    title: cplib/graph/SCC.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/SCCG_test.nim
    title: verify/graph/SCCG_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/SCCG_test.nim
    title: verify/graph/SCCG_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/SCC_test.nim
    title: verify/graph/SCC_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/SCC_test.nim
    title: verify/graph/SCC_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/scc_abc335e_test.nim
    title: verify/graph/scc_abc335e_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/scc_abc335e_test.nim
    title: verify/graph/scc_abc335e_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_REVERSE_EDGE:\n    const CPLIB_GRAPH_REVERSE_EDGE*\
    \ = 1\n    import cplib/graph/graph\n    proc reverse_edge*[T](G: WeightedDirectedGraph[T]):\
    \ WeightedDirectedGraph[T] =\n        result = WeightedDirectedGraph[T](edges:\
    \ newSeq[seq[(int, T)]](G.N), N: G.N)\n        for i in 0..<G.N:\n           \
    \ for (j, c) in G.edges[i]:\n                result.add_edge(j, i, c)\n    proc\
    \ reverse_edge*(G: UnWeightedDirectedGraph): UnWeightedDirectedGraph =\n     \
    \   result = UnWeightedDirectedGraph(edges: newSeq[seq[(int, int)]](G.N), N: G.N)\n\
    \        for i in 0..<G.N:\n            for (j, _) in G.edges[i]:\n          \
    \      result.add_edge(j, i)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/reverse_edge.nim
  requiredBy:
  - cplib/graph/SCC.nim
  - cplib/graph/SCC.nim
  timestamp: '2024-01-07 18:41:40+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/SCCG_test.nim
  - verify/graph/SCCG_test.nim
  - verify/graph/scc_abc335e_test.nim
  - verify/graph/scc_abc335e_test.nim
  - verify/graph/SCC_test.nim
  - verify/graph/SCC_test.nim
documentation_of: cplib/graph/reverse_edge.nim
layout: document
redirect_from:
- /library/cplib/graph/reverse_edge.nim
- /library/cplib/graph/reverse_edge.nim.html
title: cplib/graph/reverse_edge.nim
---
