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
  _extendedVerifiedWith:
  - icon: ':x:'
    path: verify/graph/dynamic/grid_to_graph_abc151d_test.nim
    title: verify/graph/dynamic/grid_to_graph_abc151d_test.nim
  - icon: ':x:'
    path: verify/graph/dynamic/grid_to_graph_abc151d_test.nim
    title: verify/graph/dynamic/grid_to_graph_abc151d_test.nim
  - icon: ':x:'
    path: verify/graph/static/grid_to_graph_abc151d_test.nim
    title: verify/graph/static/grid_to_graph_abc151d_test.nim
  - icon: ':x:'
    path: verify/graph/static/grid_to_graph_abc151d_test.nim
    title: verify/graph/static/grid_to_graph_abc151d_test.nim
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_GRIDTOGRAPH:\n    const CPLIB_GRAPH_GRIDTOGRAPH*\
    \ = 1\n    import sequtils\n    import cplib/graph/graph\n    proc grid_to_graph_impl*[T](a:\
    \ seq[seq[T]], ok: T, return_static: static[bool] = false): auto =\n        var\
    \ h = a.len\n        if h == 0:\n            when return_static: result = initUnWeightedUnDirectedStaticGraph(0)\n\
    \            else: result = initUnWeightedUnDirectedGraph(0)\n        var w =\
    \ a[0].len\n        when return_static: result = initUnWeightedUnDirectedStaticGraph(h*w)\n\
    \        else: result = initUnWeightedUnDirectedGraph(h*w)\n        for i in 0..<h:\n\
    \            for j in 0..<w:\n                if a[i][j] == ok:\n            \
    \        for (dx, dy) in [(1, 0), (0, 1)]:\n                        if i+dx in\
    \ 0..<h and j+dy in 0..<w and a[i+dx][j+dy] == ok:\n                         \
    \   result.add_edge(i*w+j, (i+dx)*w+j+dy)\n    proc grid_to_graph*(a: seq[seq[char]],\
    \ ok: char = '.', return_static: static[bool] = false): auto = grid_to_graph_impl(a,\
    \ ok, return_static)\n    proc grid_to_graph*[T](a: seq[seq[T]], ok: T, return_static:\
    \ static[bool] = false): auto = grid_to_graph_impl(a, ok, return_static)\n   \
    \ proc grid_to_graph*(a: seq[string], ok: char = '.', return_static: static[bool]\
    \ = false): auto = grid_to_graph(a.mapIt(it.toSeq), ok, return_static)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/grid_to_graph.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: LIBRARY_ALL_WA
  verifiedWith:
  - verify/graph/static/grid_to_graph_abc151d_test.nim
  - verify/graph/static/grid_to_graph_abc151d_test.nim
  - verify/graph/dynamic/grid_to_graph_abc151d_test.nim
  - verify/graph/dynamic/grid_to_graph_abc151d_test.nim
documentation_of: cplib/graph/grid_to_graph.nim
layout: document
redirect_from:
- /library/cplib/graph/grid_to_graph.nim
- /library/cplib/graph/grid_to_graph.nim.html
title: cplib/graph/grid_to_graph.nim
---
