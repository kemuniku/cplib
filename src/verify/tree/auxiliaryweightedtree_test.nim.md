---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/SWAG.nim
    title: cplib/collections/SWAG.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/SWAG.nim
    title: cplib/collections/SWAG.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0439
    links:
    - https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0439
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0439\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nimport cplib/graph/graph\nimport\
    \ cplib/tree/heavylightdecomposition\nimport sequtils,sets,tables,sugar,strutils\n\
    import cplib/utils/constants\nimport cplib/collections/SWAG\n\n\nvar N = ii()\n\
    var C = newseqwith(N,ii())\nvar G = initUnWeightedUnDirectedGraph(N)\n\nfor i\
    \ in 0..<(N-1):\n    var s,t = ii()-1\n    G.add_edge(s,t)\n\nvar T = G.initHld(0)\n\
    var X = newseq[seq[int]](N)\nfor i in 0..<N:\n    X[C[i]-1].add(i)\nvar ans =\
    \ newseqwith(N,0)\nfor i in 0..<N:\n    if len(X[i]) != 0:\n        var G = T.initAuxiliaryWeightedTree(X[i])\n\
    \        var HX = X[i].toHashset()\n        var memo = initTable[int,int]()\n\
    \        proc dfs(x,p:int):int {.discardable.}=\n            var now = INF64\n\
    \            for (y,c) in G[x]:\n                if p != y:\n                \
    \    now = min(now,dfs(y,x)+c)\n            \n            if x in HX:\n      \
    \          memo[x] = 0\n                return 0\n            else:\n        \
    \        memo[x] = now\n                return now\n        dfs(G.v[0],-1)\n \
    \       proc dfs2(x,p,v:int)=\n            var swag = initSWAG((x,y:int) => min(x,y),INF64)\n\
    \            var now = v\n            for (y,c) in G[x]:\n                if y\
    \ != p:\n                    swag.addLast(memo[y]+c)\n            if x in HX:\n\
    \                ans[x] = min(swag.fold(),v)\n            for (y,c) in G[x]:\n\
    \                if y != p:\n                    var tmp = swag.popFirst()\n \
    \                   if x in HX:\n                        dfs2(y,x,c)\n       \
    \             else:\n                        dfs2(y,x,min(now,swag.fold())+c)\n\
    \                    now = min(now,tmp)\n        dfs2(G.v[0],-1,INF64)\necho ans.join(\"\
    \\n\")\n\n\n\n\n\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/collections/SWAG.nim
  - cplib/utils/constants.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/utils/constants.nim
  - cplib/collections/SWAG.nim
  - cplib/tree/heavylightdecomposition.nim
  isVerificationFile: true
  path: verify/tree/auxiliaryweightedtree_test.nim
  requiredBy: []
  timestamp: '2024-09-21 04:00:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/auxiliaryweightedtree_test.nim
layout: document
redirect_from:
- /verify/verify/tree/auxiliaryweightedtree_test.nim
- /verify/verify/tree/auxiliaryweightedtree_test.nim.html
title: verify/tree/auxiliaryweightedtree_test.nim
---
