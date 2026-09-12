---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dualsegtree_static_op.nim
    title: cplib/collections/dualsegtree_static_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dualsegtree_static_op.nim
    title: cplib/collections/dualsegtree_static_op.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/range_affine_point_get
    links:
    - https://judge.yosupo.jp/problem/range_affine_point_get
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_affine_point_get\n\
    import sequtils\nimport cplib/collections/dualsegtree_static_op\nimport cplib/modint/modint\n\
    \ntype mint = modint998244353_barrett\nproc scanf(formatstr: cstring) {.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} =\n    scanf(\"%lld\\n\"\
    , addr result)\n\nproc initrangeaffinepointget[T](v: seq[T]): auto =\n    type\
    \ S = T\n    type F = (T, T)\n    proc mapping(f: F, x: S): S =\n        f[0]\
    \ * x + f[1]\n    proc composition(f, g: F): F =\n        (f[0] * g[0], f[0] *\
    \ g[1] + f[1])\n    initDualSegmentTree(v, mapping, composition, (T(1), T(0)))\n\
    \nlet N, Q = ii()\nlet A = newSeqWith(N, mint(ii()))\nvar st = initrangeaffinepointget(A)\n\
    for _ in 0..<Q:\n    let t = ii()\n    if t == 0:\n        let l, r, b, c = ii()\n\
    \        st.apply(l, r, (mint(b), mint(c)))\n    else:\n        let i = ii()\n\
    \        echo st[i]\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/collections/dualsegtree_static_op.nim
  - cplib/collections/dualsegtree_static_op.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  isVerificationFile: true
  path: verify/collections/dualsegtree/rangeaffinepointget_static_op_test.nim
  requiredBy: []
  timestamp: '2026-09-08 13:38:06+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/dualsegtree/rangeaffinepointget_static_op_test.nim
layout: document
redirect_from:
- /verify/verify/collections/dualsegtree/rangeaffinepointget_static_op_test.nim
- /verify/verify/collections/dualsegtree/rangeaffinepointget_static_op_test.nim.html
title: verify/collections/dualsegtree/rangeaffinepointget_static_op_test.nim
---
