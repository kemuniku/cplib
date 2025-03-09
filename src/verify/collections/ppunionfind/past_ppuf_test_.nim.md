---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/ppunionfind.nim
    title: cplib/collections/ppunionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/ppunionfind.nim
    title: cplib/collections/ppunionfind.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
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
  isVerificationFile: false
  path: verify/collections/ppunionfind/past_ppuf_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/ppunionfind/past_ppuf_test_.nim
layout: document
redirect_from:
- /library/verify/collections/ppunionfind/past_ppuf_test_.nim
- /library/verify/collections/ppunionfind/past_ppuf_test_.nim.html
title: verify/collections/ppunionfind/past_ppuf_test_.nim
---
