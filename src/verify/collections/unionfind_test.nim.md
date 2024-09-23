---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/unionfind
    links:
    - https://judge.yosupo.jp/problem/unionfind
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind\n\
    import math, sequtils\nimport cplib/collections/unionfind\n\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N, Q = ii()\nvar uf = initUnionFind(N)\nfor i in\
    \ 0..<Q:\n    var t, u, v = ii()\n    if t == 0:\n        uf.unite(u, v)\n   \
    \ else:\n        if uf.issame(u, v):\n            echo 1\n        else:\n    \
    \        echo 0\n"
  dependsOn:
  - cplib/collections/unionfind.nim
  - cplib/collections/unionfind.nim
  isVerificationFile: true
  path: verify/collections/unionfind_test.nim
  requiredBy: []
  timestamp: '2024-09-16 02:33:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/unionfind_test.nim
layout: document
redirect_from:
- /verify/verify/collections/unionfind_test.nim
- /verify/verify/collections/unionfind_test.nim.html
title: verify/collections/unionfind_test.nim
---
