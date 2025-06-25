---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree.nim
    title: cplib/collections/lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree.nim
    title: cplib/collections/lazysegtree.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/range_affine_range_sum
    links:
    - https://judge.yosupo.jp/problem/range_affine_range_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_affine_range_sum\n\
    import sequtils\nimport cplib/collections/lazysegtree\nimport cplib/modint/modint\n\
    \ntype mint = modint998244353_barrett\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar N, Q = ii()\n\ntype S = tuple[val: mint, siz: int]\ntype F =\
    \ tuple[a: mint, b: mint]\nvar v = newSeqWith(N, (mint(ii()), 1))\nproc op(L,\
    \ R: S): S = (L.val+R.val, L.siz+R.siz)\nproc e(): S = (mint(0), 0)\nproc mapping(f:\
    \ F, x: S): S = (f.a * x.val+f.b*x.siz, x.siz)\nproc composition(f: F, g: F):\
    \ F = (f.a*g.a, f.a*g.b+f.b)\nproc id(): F = (mint(1), mint(0))\nvar seg = initLazySegmentTree(v,\
    \ op, e(), mapping, composition, id())\n\nfor i in 0..<Q:\n    var t = ii()\n\
    \    if t == 0:\n        var l, r, b, c = ii()\n        seg.apply(l..<r, (mint(b),\
    \ mint(c)))\n    else:\n        var l, r = ii()\n        echo seg[l..<r][0]\n"
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/collections/lazysegtree.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/collections/lazysegtree.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/collections/lazysegtree/rangeaffinerangesum_test.nim
  requiredBy: []
  timestamp: '2025-04-27 18:34:28+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/lazysegtree/rangeaffinerangesum_test.nim
layout: document
redirect_from:
- /verify/verify/collections/lazysegtree/rangeaffinerangesum_test.nim
- /verify/verify/collections/lazysegtree/rangeaffinerangesum_test.nim.html
title: verify/collections/lazysegtree/rangeaffinerangesum_test.nim
---
