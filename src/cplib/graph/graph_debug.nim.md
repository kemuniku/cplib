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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_GRAPHDEBUG:\n    const CPLIB_GRAPH_GRAPHDEBUG*\
    \ = 1\n    import streams\n    import cplib/graph/graph\n    proc dump_graph*(G:\
    \ WeightedDirectedGraph or WeightedDirectedStaticGraph,output:File=stdout)=\n\
    \        var M = 0\n        for x in 0..<len(G):\n            for (y,c) in G[x]:\n\
    \                M += 1\n        output.writeLine($len(G)&\" \" & $M)\n      \
    \  for x in 0..<len(G):\n            for (y,c) in G[x]:\n                output.writeLine($x\
    \ & \" \" & $y & \" \" & $c)\n    \n    proc dump_graph*(G: WeightedUnDirectedGraph\
    \ or WeightedUnDirectedStaticGraph,output:File=stdout)=\n        var M = 0\n \
    \       for x in 0..<len(G):\n            for (y,c) in G[x]:\n               \
    \ if y >= x:\n                    M += 1\n        output.writeLine($len(G)&\"\
    \ \" & $M)\n        for x in 0..<len(G):\n            for (y,c) in G[x]:\n   \
    \             if y >= x:\n                    output.writeLine($x & \" \" & $y\
    \ &\" \" & $c)\n    \n    proc dump_graph*(G: UnWeightedDirectedGraph or UnWeightedDirectedStaticGraph,output:File=stdout)=\n\
    \        var M = 0\n        for x in 0..<len(G):\n            for y in G[x]:\n\
    \                M += 1\n        output.writeLine($len(G)&\" \" & $M)\n      \
    \  for x in 0..<len(G):\n            for y in G[x]:\n                output.writeLine($x\
    \ & \" \" & $y)\n    \n    proc dump_graph*(G: UnWeightedUnDirectedGraph or UnWeightedUnDirectedStaticGraph,output:File=stdout)=\n\
    \        var M = 0\n        for x in 0..<len(G):\n            for y in G[x]:\n\
    \                if y >= x:\n                    M += 1\n        output.writeLine($len(G)&\"\
    \ \" & $M)\n        for x in 0..<len(G):\n            for y in G[x]:\n       \
    \         if y >= x:\n                    output.writeLine($x & \" \" & $y)"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/graph_debug.nim
  requiredBy: []
  timestamp: '2024-11-05 09:47:22+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/graph/graph_debug.nim
layout: document
redirect_from:
- /library/cplib/graph/graph_debug.nim
- /library/cplib/graph/graph_debug.nim.html
title: cplib/graph/graph_debug.nim
---
