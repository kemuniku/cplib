---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_static_op.nim
    title: cplib/collections/segtree_static_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_static_op.nim
    title: cplib/collections/segtree_static_op.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/static_range_sum
    links:
    - https://judge.yosupo.jp/problem/static_range_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_sum\n\
    import sequtils, sugar\nimport cplib/collections/segtree_static_op\n\nproc scanf(formatstr:\
    \ cstring) {.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N, Q = ii()\nvar A = newSeqWith(N, ii())\nvar st\
    \ = initSegmentTree(A, (a, b: int) => a + b, 0)\nfor _ in 0..<Q:\n    var L, R\
    \ = ii()\n    echo st.get(L..<R)\n"
  dependsOn:
  - cplib/collections/segtree_static_op.nim
  - cplib/collections/segtree_static_op.nim
  isVerificationFile: true
  path: verify/collections/segtree/segtree_static_op_test.nim
  requiredBy: []
  timestamp: '2026-09-02 04:31:06+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/segtree/segtree_static_op_test.nim
layout: document
redirect_from:
- /verify/verify/collections/segtree/segtree_static_op_test.nim
- /verify/verify/collections/segtree/segtree_static_op_test.nim.html
title: verify/collections/segtree/segtree_static_op_test.nim
---
