---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/group_unionfind.nim
    title: cplib/collections/group_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/group_unionfind.nim
    title: cplib/collections/group_unionfind.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/unionfind
    links:
    - https://judge.yosupo.jp/problem/unionfind
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind\n\
    import cplib/collections/group_unionfind\n\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar N, Q = ii()\nvar uf = initUnionFind(N)\nfor i in 0..<Q:\n   \
    \ var t, u, v = ii()\n    if t == 0:\n        uf.unite(u, v)\n    else:\n    \
    \    if uf.issame(u, v):\n            echo 1\n        else:\n            echo\
    \ 0\n"
  dependsOn:
  - cplib/collections/group_unionfind.nim
  - cplib/collections/group_unionfind.nim
  isVerificationFile: true
  path: verify/collections/groupunionfind_test.nim
  requiredBy: []
  timestamp: '2025-06-13 11:57:18+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/groupunionfind_test.nim
layout: document
redirect_from:
- /verify/verify/collections/groupunionfind_test.nim
- /verify/verify/collections/groupunionfind_test.nim.html
title: verify/collections/groupunionfind_test.nim
---
