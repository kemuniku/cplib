---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links:
    - https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=false&directed=false&data={len(G)}+{M}
    - https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=false&directed=true&data={len(G)}+{M}
    - https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=true&directed=false&data={len(G)}+{M}
    - https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=true&directed=true&data={len(G)}+{M}
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_GRAPHDEBUG:\n    const CPLIB_GRAPH_GRAPHDEBUG*\
    \ = 1\n    import streams\n    import strformat\n    import cplib/graph/graph\n\
    \    proc dump_graph*(G: WeightedDirectedGraph or WeightedDirectedStaticGraph,output:File=stdout)=\n\
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
    \         if y >= x:\n                    output.writeLine($x & \" \" & $y)\n\
    \    \n    proc to_graph_graph*(G: WeightedDirectedGraph or WeightedDirectedStaticGraph,indexed:bool=false):string=\n\
    \        var M = 0\n        for x in 0..<len(G):\n            for (y,c) in G[x]:\n\
    \                M += 1\n        result = fmt\"https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=true&directed=true&data={len(G)}+{M}\"\
    \n        var add = 0\n        if indexed:\n            add += 1\n        for\
    \ x in 0..<len(G):\n            for (y,c) in G[x]:\n                result &=\
    \ fmt\"%0A{x+add}+{y+add}+{c}\"\n\n    proc to_graph_graph*(G: WeightedUnDirectedGraph\
    \ or WeightedUnDirectedStaticGraph,indexed:bool=false):string=\n        var M\
    \ = 0\n        for x in 0..<len(G):\n            for (y,c) in G[x]:\n        \
    \        if y >= x:\n                    M += 1\n        result = fmt\"https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=true&directed=false&data={len(G)}+{M}\"\
    \n        var add = 0\n        if indexed:\n            add += 1\n        for\
    \ x in 0..<len(G):\n            for (y,c) in G[x]:\n                if y >= x:\n\
    \                    result &= fmt\"%0A{x+add}+{y+add}+{c}\"\n\n    proc to_graph_graph*(G:\
    \ UnWeightedDirectedGraph or UnWeightedDirectedStaticGraph,indexed:bool=false):string=\n\
    \        var M = 0\n        for x in 0..<len(G):\n            for y in G[x]:\n\
    \                M += 1\n        result = fmt\"https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=false&directed=true&data={len(G)}+{M}\"\
    \n        var add = 0\n        if indexed:\n            add += 1\n        for\
    \ x in 0..<len(G):\n            for y in G[x]:\n                result &= fmt\"\
    %0A{x+add}+{y+add}\"\n\n    proc to_graph_graph*(G: UnWeightedUnDirectedGraph\
    \ or UnWeightedUnDirectedStaticGraph,indexed:bool=false):string=\n        var\
    \ M = 0\n        for x in 0..<len(G):\n            for y in G[x]:\n          \
    \      if y >= x:\n                    M += 1\n        result = fmt\"https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=false&directed=false&data={len(G)}+{M}\"\
    \n        var add = 0\n        if indexed:\n            add += 1\n        for\
    \ x in 0..<len(G):\n            for y in G[x]:\n                if y >= x:\n \
    \                   result &= fmt\"%0A{x+add}+{y+add}\"\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/graph_debug.nim
  requiredBy: []
  timestamp: '2026-07-05 21:14:21+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/graph/graph_debug.nim
layout: document
redirect_from:
- /library/cplib/graph/graph_debug.nim
- /library/cplib/graph/graph_debug.nim.html
title: cplib/graph/graph_debug.nim
---
