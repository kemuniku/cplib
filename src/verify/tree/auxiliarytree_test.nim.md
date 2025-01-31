---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':question:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc340/tasks/abc340_g
    links:
    - https://atcoder.jp/contests/abc340/tasks/abc340_g
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc340/tasks/abc340_g\n\
    import sequtils,sets\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\n\
    proc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\nimport cplib/graph/graph\n\
    import cplib/tree/heavylightdecomposition\nimport atcoder/modint\ntype mint =\
    \ modint998244353\nvar N = ii()\nvar A = newseqwith(N,ii())\n\nvar G = initUnWeightedUnDirectedGraph(N)\n\
    \nfor i in 0..<(N-1):\n    var u,v = ii()-1\n    G.add_edge(u,v)\n\nvar T = G.initHld(0)\n\
    \nvar X = newseq[seq[int]](N)\nfor i in 0..<(N):\n    X[A[i]-1].add(i)\n\nvar\
    \ anss = mint(0)\n\nfor i in 0..<(N):\n    if len(X[i]) > 0:\n        var HX =\
    \ X[i].toHashSet()\n        var G = T.initAuxiliaryTree(X[i])\n        var ans\
    \ = mint(0)\n        proc dfs(x,p:int):(mint,mint)=\n            #(i\u304C\u7AEF\
    \u3067\u306A\u3044\u3088\u3046\u306A\u3082\u306E\u3001i\u304C\u7AEF\u306E\u3082\
    \u306E)\n            for y in G[x]:\n                if y != p:\n            \
    \        var (a,b) = dfs(y,x)\n                    result[0] += (result[0]+result[1])*(a+b)\n\
    \                    result[1] += (a+b)\n            if x in HX:\n           \
    \     result[1] += 1\n                ans += result[1]+result[0]\n           \
    \ else:\n                ans += result[0]\n            return result\n       \
    \ discard dfs(G.v[0],-1)\n        anss += ans\n\necho anss\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  isVerificationFile: true
  path: verify/tree/auxiliarytree_test.nim
  requiredBy: []
  timestamp: '2025-01-30 13:56:50+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/tree/auxiliarytree_test.nim
layout: document
redirect_from:
- /verify/verify/tree/auxiliarytree_test.nim
- /verify/verify/tree/auxiliarytree_test.nim.html
title: verify/tree/auxiliarytree_test.nim
---
