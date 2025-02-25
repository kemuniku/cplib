---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/collections/ppunionfind.nim
    title: cplib/collections/ppunionfind.nim
  - icon: ':question:'
    path: cplib/collections/ppunionfind.nim
    title: cplib/collections/ppunionfind.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/past202004-open/tasks/past202004_o
    links:
    - https://atcoder.jp/contests/past202004-open/tasks/past202004_o
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/past202004-open/tasks/past202004_o\n\
    import cplib/collections/ppunionfind\nimport algorithm\n\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N,M = ii()\nvar UF = initPartialPersistentUnionFind(N)\n\
    \nvar edges : seq[(int,int,int)]\nfor i in 0..<(M):\n    var a,b  = ii()-1\n \
    \   var c = ii()\n    edges.add((c,a,b))\nvar save = edges\nedges.sort()\nvar\
    \ tmp = 0\nfor i in 0..<(M):\n    var (c,a,b) = edges[i]\n    if UF.unite(a,b,i):\n\
    \        tmp += c\n\nfor i in 0..<(M):\n    var (c,a,b) = save[i]\n    echo tmp+c-edges[UF.when_unite(a,b)][0]"
  dependsOn:
  - cplib/collections/ppunionfind.nim
  - cplib/collections/ppunionfind.nim
  isVerificationFile: true
  path: verify/collections/ppunionfind/past_ppuf_test.nim
  requiredBy: []
  timestamp: '2025-02-26 01:40:00+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/collections/ppunionfind/past_ppuf_test.nim
layout: document
redirect_from:
- /verify/verify/collections/ppunionfind/past_ppuf_test.nim
- /verify/verify/collections/ppunionfind/past_ppuf_test.nim.html
title: verify/collections/ppunionfind/past_ppuf_test.nim
---
