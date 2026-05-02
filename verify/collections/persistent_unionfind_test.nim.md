---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_array.nim
    title: cplib/collections/persistent_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_array.nim
    title: cplib/collections/persistent_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_unionfind.nim
    title: cplib/collections/persistent_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_unionfind.nim
    title: cplib/collections/persistent_unionfind.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/persistent_unionfind
    links:
    - https://judge.yosupo.jp/problem/persistent_unionfind
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/persistent_unionfind\n\
    \nimport cplib/collections/persistent_unionfind\n\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\nimport tables\nvar N,Q = ii()\nvar UFS : Table[int,PersistentUnionFind]\n\
    UFS[-1] = initPersistentUnionFind(N)\nfor i in 0..<Q:\n    var t,k,u,v = ii()\n\
    \    if t == 0:\n        UFS[i] = UFS[k].unite(u,v)\n    else:\n        echo if\
    \ UFS[k].issame(u,v):1 else:0\n"
  dependsOn:
  - cplib/collections/persistent_array.nim
  - cplib/collections/persistent_array.nim
  - cplib/collections/persistent_unionfind.nim
  - cplib/collections/persistent_unionfind.nim
  isVerificationFile: true
  path: verify/collections/persistent_unionfind_test.nim
  requiredBy: []
  timestamp: '2024-09-25 01:01:29+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/persistent_unionfind_test.nim
layout: document
redirect_from:
- /verify/verify/collections/persistent_unionfind_test.nim
- /verify/verify/collections/persistent_unionfind_test.nim.html
title: verify/collections/persistent_unionfind_test.nim
---
