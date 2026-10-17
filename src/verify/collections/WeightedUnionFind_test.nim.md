---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/weightedunionfind.nim
    title: cplib/collections/weightedunionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/weightedunionfind.nim
    title: cplib/collections/weightedunionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/unionfind_with_potential
    links:
    - https://judge.yosupo.jp/problem/unionfind_with_potential
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind_with_potential\n\
    import strutils\nimport cplib/collections/weightedunionfind\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\n\nvar N,Q = ii()\nimport cplib/modint/modint\ntype\
    \ mint = modint998244353_barrett\nvar uf = initWeightedUnionFind(N,mint)\nfor\
    \ i in 0..<Q:\n    var t = ii()\n    if t == 0:\n        var u,v,x = ii()\n  \
    \      if uf.unite(u,v,x):\n            echo 1\n        else:\n            echo\
    \ 0\n    else:\n        var u,v = ii()\n        if uf.issame(u,v):\n         \
    \   echo uf.diff(u,v)\n        else:\n            echo -1\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/collections/weightedunionfind.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/collections/weightedunionfind.nim
  - cplib/modint/montgomery_impl.nim
  isVerificationFile: true
  path: verify/collections/WeightedUnionFind_test.nim
  requiredBy: []
  timestamp: '2026-10-15 15:23:06+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/WeightedUnionFind_test.nim
layout: document
redirect_from:
- /verify/verify/collections/WeightedUnionFind_test.nim
- /verify/verify/collections/WeightedUnionFind_test.nim.html
title: verify/collections/WeightedUnionFind_test.nim
---
