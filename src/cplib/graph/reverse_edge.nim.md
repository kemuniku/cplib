---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
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
    \ for (j, c) in G[i]:\n                result.add_edge(j, i, c)\n    proc reverse_edge*(G:\
    \ UnWeightedDirectedGraph): UnWeightedDirectedGraph =\n        result = UnWeightedDirectedGraph(edges:\
    \ newSeq[seq[(int, int)]](G.N), N: G.N)\n        for i in 0..<G.N:\n         \
    \   for j in G[i]:\n                result.add_edge(j, i)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/reverse_edge.nim
  requiredBy: []
  timestamp: '2024-02-08 02:13:36+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/graph/reverse_edge.nim
layout: document
redirect_from:
- /library/cplib/graph/reverse_edge.nim
- /library/cplib/graph/reverse_edge.nim.html
title: cplib/graph/reverse_edge.nim
---
