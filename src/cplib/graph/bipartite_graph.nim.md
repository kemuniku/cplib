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
  - icon: ':warning:'
    path: verify/graph/is_bipartite_graph_test_.nim
    title: verify/graph/is_bipartite_graph_test_.nim
  - icon: ':warning:'
    path: verify/graph/is_bipartite_graph_test_.nim
    title: verify/graph/is_bipartite_graph_test_.nim
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_BIPATITE_GRAPH:\n    const CPLIB_GRAPH_BIPATITE_GRAPH*\
    \ = 1\n    import cplib/graph/graph\n    import sequtils\n    proc is_bipartite_graph*(G:UnDirectedGraph):bool=\n\
    \        var c = newseqwith(len(G),-1)\n        for i in 0..<len(G):\n       \
    \     if c[i] == -1:\n                proc dfs(x:int):bool=\n                \
    \    for (y,_) in G.to_and_cost(x):\n                        if c[y] == -1:\n\
    \                            c[y] = c[x] xor 1\n                            if\
    \ not dfs(y):\n                                return false\n                \
    \        elif c[y] != (c[x] xor 1):\n                            return false\n\
    \                    return true\n                c[i] = 0\n                if\
    \ not dfs(i):\n                    return false\n        return true"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/bipartite_graph.nim
  requiredBy:
  - verify/graph/is_bipartite_graph_test_.nim
  - verify/graph/is_bipartite_graph_test_.nim
  timestamp: '2024-10-02 17:52:12+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/graph/bipartite_graph.nim
layout: document
redirect_from:
- /library/cplib/graph/bipartite_graph.nim
- /library/cplib/graph/bipartite_graph.nim.html
title: cplib/graph/bipartite_graph.nim
---
