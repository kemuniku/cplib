---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/dag_minimum_path_cover_hakata_test.nim
    title: verify/graph/dag_minimum_path_cover_hakata_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dag_minimum_path_cover_hakata_test.nim
    title: verify/graph/dag_minimum_path_cover_hakata_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_DAGMINIMUMPATHCOVER:\n    const CPLIB_GRAPH_DAGMINIMUMPATHCOVER*\
    \ = 1\n    import cplib/graph/graph\n    import atcoder/maxflow\n    when defined(debug):\n\
    \        import cplib/graph/topologicalsort\n\n    proc dag_minimum_path_cover*(G:UnWeightedDirectedGraph):int=\n\
    \        when defined(debug):\n            assert G.isDAG()\n        var MFG =\
    \ init_mf_graph[int](len(G)*2+2)\n        for i in 0..<len(G):\n            for\
    \ j in G[i]:\n                MFG.add_edge(i,len(G)+j,1)\n        for i in 0..<len(G):\n\
    \            MFG.add_edge(2*len(G),i,1)\n            MFG.add_edge(len(G)+i,2*len(G)+1,1)\n\
    \        return len(G)-MFG.flow(2*len(G),2*len(G)+1)"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/dag_minimum_path_cover.nim
  requiredBy: []
  timestamp: '2024-10-23 03:26:51+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/dag_minimum_path_cover_hakata_test.nim
  - verify/graph/dag_minimum_path_cover_hakata_test.nim
documentation_of: cplib/graph/dag_minimum_path_cover.nim
layout: document
redirect_from:
- /library/cplib/graph/dag_minimum_path_cover.nim
- /library/cplib/graph/dag_minimum_path_cover.nim.html
title: cplib/graph/dag_minimum_path_cover.nim
---
