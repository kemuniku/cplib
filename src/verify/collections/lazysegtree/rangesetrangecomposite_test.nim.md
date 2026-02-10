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
    PROBLEM: https://judge.yosupo.jp/problem/range_set_range_composite
    links:
    - https://judge.yosupo.jp/problem/range_set_range_composite
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_set_range_composite\n\
    import sequtils, strutils\nimport cplib/collections/lazysegtree\nimport cplib/modint/modint\n\
    \ntype mint = modint998244353_barrett\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar N, Q = ii()\n\ntype S = (mint, mint, int)\ntype F = (bool, mint,\
    \ mint)\nvar v = newSeqWith(N, (mint(ii()), mint(ii()), 1))\nproc op(l, r: S):\
    \ S = (r[0] * l[0], r[0] * l[1] + r[1], l[2] + r[2])\nproc mapping(f: F, x: S):\
    \ S =\n    if f[0]:\n        var pw = f[1].pow(x[2])\n        (pw, f[2] * (1 -\
    \ pw) / (1 - f[1]), x[2])\n    else:\n        x\nproc composition(f: F, g: F):\
    \ F = (if f[0]: f else: g)\nvar seg = initLazySegmentTree(v, op, (mint(1), mint(0),\
    \ 0), mapping, composition, (false, mint(1), mint(0)))\n\nvar ans = newSeq[mint]()\n\
    for i in 0..<Q:\n    var t = ii()\n    if t == 0:\n        var l, r, c, d = ii()\n\
    \        seg.apply(l..<r, (true, mint(c), mint(d)))\n    else:\n        var l,\
    \ r, x = ii()\n        var (a, b, _) = seg[l..<r]\n        ans.add(a * x + b)\n\
    echo ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/collections/lazysegtree.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/collections/lazysegtree.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/collections/lazysegtree/rangesetrangecomposite_test.nim
  requiredBy: []
  timestamp: '2025-04-27 18:34:28+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/lazysegtree/rangesetrangecomposite_test.nim
layout: document
redirect_from:
- /verify/verify/collections/lazysegtree/rangesetrangecomposite_test.nim
- /verify/verify/collections/lazysegtree/rangesetrangecomposite_test.nim.html
title: verify/collections/lazysegtree/rangesetrangecomposite_test.nim
---
