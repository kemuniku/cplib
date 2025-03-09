---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc185/tasks/abc185_f
    links:
    - https://atcoder.jp/contests/abc185/tasks/abc185_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc185/tasks/abc185_f\n\
    import sequtils, sugar\nimport cplib/collections/segtree\n\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N, Q = ii()\nvar A = newSeqWith(N, ii())\nvar st\
    \ = initSegmentTree(A, (a, b: int)=>a xor b, 0)\nfor i in 0..<Q:\n    var T, X,\
    \ Y = ii()\n    if T == 1:\n        st.update(X-1, st.get(X-1, X) xor Y)\n   \
    \ else:\n        echo st.get(X-1, Y)\n"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: false
  path: verify/collections/segtree/segtree_xor1_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/segtree/segtree_xor1_test_.nim
layout: document
redirect_from:
- /library/verify/collections/segtree/segtree_xor1_test_.nim
- /library/verify/collections/segtree/segtree_xor1_test_.nim.html
title: verify/collections/segtree/segtree_xor1_test_.nim
---
