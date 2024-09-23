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
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/point_set_range_composite
    links:
    - https://judge.yosupo.jp/problem/point_set_range_composite
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_set_range_composite\n\
    import sequtils\nimport cplib/collections/segtree\n\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar N, Q = ii()\nvar A = newSeqWith(N, (ii(), ii()))\nconst MOD =\
    \ 998244353\nproc op(a, b: (int, int)): (int, int) = (b[0]*a[0] mod MOD, (b[0]*a[1]\
    \ mod MOD)+b[1] mod MOD)\nvar st = initSegmentTree(A, op, (1, 0))\nfor i in 0..<Q:\n\
    \    var T = ii()\n    if T == 0:\n        var p, c, d = ii()\n        st.update(p,\
    \ (c, d))\n    else:\n        var l, r, x = ii()\n        if r == len(st) and\
    \ l == 0:\n            assert r == N\n            var (a, b) = st.get_all\n  \
    \          echo (a*x mod MOD + b) mod MOD\n        else:\n            var (a,\
    \ b) = st.get(l, r)\n            echo (a*x mod MOD + b) mod MOD\n"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/collections/segtree/segtree_PSRC_2_test.nim
  requiredBy: []
  timestamp: '2024-09-16 02:10:51+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/segtree/segtree_PSRC_2_test.nim
layout: document
redirect_from:
- /verify/verify/collections/segtree/segtree_PSRC_2_test.nim
- /verify/verify/collections/segtree/segtree_PSRC_2_test.nim.html
title: verify/collections/segtree/segtree_PSRC_2_test.nim
---
