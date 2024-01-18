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
    path: cplib/graph/reverse_edge.nim
    title: cplib/graph/reverse_edge.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/reverse_edge.nim
    title: cplib/graph/reverse_edge.nim
  _extendedRequiredBy: []
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
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_SCC:\n    const CPLIB_GRAPH_SCC* = 1\n    import\
    \ cplib/graph/graph\n    import sequtils\n    import cplib/graph/reverse_edge\n\
    \    proc SCC*(G: UnweightedDirectedGraph): seq[seq[int]] =\n        ##\u5F37\u9023\
    \u7D50\u6210\u5206\u5206\u89E3\u3092\u3057\u3066\u3001\u5F37\u9023\u7D50\u6210\
    \u5206\u3092\u8FD4\u3057\u307E\u3059\u3002\u30EA\u30B9\u30C8\u306F\u30C8\u30DD\
    \u30ED\u30B8\u30AB\u30EB\u30BD\u30FC\u30C8\u3055\u308C\u3066\u3044\u307E\u3059\
    \u3002\n        var postorder = newseqwith(G.N, -1)\n        var used = newSeqWith(G.N,\
    \ false)\n        var count = G.N-1\n\n        proc fdfs(x: int) =\n         \
    \   for (i, _) in G.edges[x]:\n                if not used[i]:\n             \
    \       used[i] = true\n                    fdfs(i)\n            postorder[count]\
    \ = x\n            count -= 1\n\n\n\n        for i in 0..<G.N:\n            if\
    \ not used[i]:\n                used[i] = true\n                fdfs(i)\n\n  \
    \      var gout = newseq[seq[int]](G.N)\n        for i in 0..<G.N:\n         \
    \   for (j, _) in G.edges[i]:\n                gout[j].add(i)\n        var group:\
    \ seq[seq[int]]\n        used = newSeqWith(G.N, false)\n        count = 0\n\n\
    \        proc sdfs(x: int) =\n            group[count].add(x)\n            for\
    \ i in gout[x]:\n                if not used[i]:\n                    used[i]\
    \ = true\n                    sdfs(i)\n        for i in postorder:\n         \
    \   if not used[i]:\n                used[i] = true\n                group.add(@[])\n\
    \                sdfs(i)\n                count += 1\n        return group\n \
    \   proc SCCG*(G: UnweightedDirectedGraph): (UnweightedDirectedGraph, seq[int],\
    \ seq[seq[int]]) =\n        ##\u5F37\u9023\u7D50\u6210\u5206\u5206\u89E3\u3092\
    \u3057\u307E\u3059\u3002\n        ##\u7D50\u679C\u3092\u3001(\u9802\u70B9\u3092\
    \u307E\u3068\u3081\u305F\u30B0\u30E9\u30D5,\u5143\u306E\u9802\u70B9\u2192\u65B0\
    \u9802\u70B9\u3078\u306E\u5BFE\u5FDC,\u65B0\u9802\u70B9\u306B\u542B\u307E\u308C\
    \u308B\u9802\u70B9\u4E00\u89A7)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        var\
    \ group = SCC(G)\n        var i_to_group = newSeqWith(G.N, -1)\n        for i\
    \ in 0..<len(group):\n            for j in group[i]:\n                i_to_group[j]\
    \ = i\n        var newG = initUnWeightedDirectedGraph(len(group))\n        for\
    \ i in 0..<G.N:\n            for (j, _) in G.edges[i]:\n                if i_to_group[i]\
    \ != i_to_group[j]:\n                    newG.add_edge(i_to_group[i], i_to_group[j])\n\
    \        return (newG, i_to_group, group)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/reverse_edge.nim
  - cplib/graph/graph.nim
  - cplib/graph/reverse_edge.nim
  isVerificationFile: false
  path: cplib/graph/SCC.nim
  requiredBy: []
  timestamp: '2024-01-08 08:28:16+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/SCC_test.nim
  - verify/graph/SCC_test.nim
  - verify/graph/SCCG_test.nim
  - verify/graph/SCCG_test.nim
documentation_of: cplib/graph/SCC.nim
layout: document
redirect_from:
- /library/cplib/graph/SCC.nim
- /library/cplib/graph/SCC.nim.html
title: cplib/graph/SCC.nim
---
