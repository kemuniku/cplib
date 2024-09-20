---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':question:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc185/tasks/abc185_f
    links:
    - https://atcoder.jp/contests/abc185/tasks/abc185_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
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
  isVerificationFile: true
  path: verify/collections/segtree/segtree_xor1_test.nim
  requiredBy: []
  timestamp: '2024-09-16 02:10:51+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/segtree/segtree_xor1_test.nim
layout: document
redirect_from:
- /verify/verify/collections/segtree/segtree_xor1_test.nim
- /verify/verify/collections/segtree/segtree_xor1_test.nim.html
title: verify/collections/segtree/segtree_xor1_test.nim
---
