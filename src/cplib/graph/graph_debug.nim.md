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
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_debug_test.nim
    title: verify/AI/graph_debug_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_debug_test.nim
    title: verify/AI/graph_debug_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
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
    \ = 1\n    import strformat\n    import cplib/graph/graph\n    proc dump_graph*(G:\
    \ WeightedDirectedGraph or WeightedDirectedStaticGraph,indexed:int=0,output:File=stdout)=\n\
    \        ## \u9802\u70B9\u756A\u53F7\u306B indexed \u3092\u52A0\u3048\u3066\u30B0\
    \u30E9\u30D5\u3092\u51FA\u529B\u3059\u308B\u3002O(V + E)\u3002\n        var M\
    \ = 0\n        for x in 0..<len(G):\n            for (y,c) in G[x]:\n        \
    \        M += 1\n        output.writeLine($len(G)&\" \" & $M)\n        for x in\
    \ 0..<len(G):\n            for (y,c) in G[x]:\n                output.writeLine($(x\
    \ + indexed) & \" \" & $(y + indexed) & \" \" & $c)\n    \n    proc dump_graph*(G:\
    \ WeightedUnDirectedGraph or WeightedUnDirectedStaticGraph,indexed:int=0,output:File=stdout)=\n\
    \        ## \u9802\u70B9\u756A\u53F7\u306B indexed \u3092\u52A0\u3048\u3066\u30B0\
    \u30E9\u30D5\u3092\u51FA\u529B\u3059\u308B\u3002O(V + E)\u3002\n        var M\
    \ = 0\n        for x in 0..<len(G):\n            for (y,c) in G[x]:\n        \
    \        if y >= x:\n                    M += 1\n        output.writeLine($len(G)&\"\
    \ \" & $M)\n        for x in 0..<len(G):\n            for (y,c) in G[x]:\n   \
    \             if y >= x:\n                    output.writeLine($(x + indexed)\
    \ & \" \" & $(y + indexed) & \" \" & $c)\n    \n    proc dump_graph*(G: UnWeightedDirectedGraph\
    \ or UnWeightedDirectedStaticGraph,indexed:int=0,output:File=stdout)=\n      \
    \  ## \u9802\u70B9\u756A\u53F7\u306B indexed \u3092\u52A0\u3048\u3066\u30B0\u30E9\
    \u30D5\u3092\u51FA\u529B\u3059\u308B\u3002O(V + E)\u3002\n        var M = 0\n\
    \        for x in 0..<len(G):\n            for y in G[x]:\n                M +=\
    \ 1\n        output.writeLine($len(G)&\" \" & $M)\n        for x in 0..<len(G):\n\
    \            for y in G[x]:\n                output.writeLine($(x + indexed) &\
    \ \" \" & $(y + indexed))\n    \n    proc dump_graph*(G: UnWeightedUnDirectedGraph\
    \ or UnWeightedUnDirectedStaticGraph,indexed:int=0,output:File=stdout)=\n    \
    \    ## \u9802\u70B9\u756A\u53F7\u306B indexed \u3092\u52A0\u3048\u3066\u30B0\u30E9\
    \u30D5\u3092\u51FA\u529B\u3059\u308B\u3002O(V + E)\u3002\n        var M = 0\n\
    \        for x in 0..<len(G):\n            for y in G[x]:\n                if\
    \ y >= x:\n                    M += 1\n        output.writeLine($len(G)&\" \"\
    \ & $M)\n        for x in 0..<len(G):\n            for y in G[x]:\n          \
    \      if y >= x:\n                    output.writeLine($(x + indexed) & \" \"\
    \ & $(y + indexed))\n    \n    proc dump_graph*(G: DirectedGraph or UnDirectedGraph,\
    \ file: File) =\n        ## \u51FA\u529B\u5148\u3092\u7B2C\u4E8C\u5F15\u6570\u306B\
    \u6307\u5B9A\u3059\u308B\u5F93\u6765\u306E\u547C\u3073\u51FA\u3057\u306B\u5BFE\
    \u5FDC\u3059\u308B\u3002O(V + E)\u3002\n        G.dump_graph(0, file)\n\n    proc\
    \ to_graph_graph*(G: WeightedDirectedGraph or WeightedDirectedStaticGraph,indexed:bool=false):string=\n\
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
  timestamp: '2026-09-18 00:20:23+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/graph_debug_test.nim
  - verify/AI/graph_debug_test.nim
documentation_of: cplib/graph/graph_debug.nim
layout: document
redirect_from:
- /library/cplib/graph/graph_debug.nim
- /library/cplib/graph/graph_debug.nim.html
title: cplib/graph/graph_debug.nim
---
