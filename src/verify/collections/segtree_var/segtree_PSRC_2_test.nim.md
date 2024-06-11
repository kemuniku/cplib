---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_var.nim
    title: cplib/collections/segtree_var.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_var.nim
    title: cplib/collections/segtree_var.nim
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
    import sequtils\nimport cplib/collections/segtree_var\n\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N, Q = ii()\nvar A = newSeqWith(N, (ii(), ii()))\n\
    const MOD = 998244353\nproc op(a, b: (int, int)): (int, int) = (b[0]*a[0] mod\
    \ MOD, (b[0]*a[1] mod MOD)+b[1] mod MOD)\nvar st = initSegmentTree(A, op, (1,\
    \ 0))\nfor i in 0..<Q:\n    var T = ii()\n    if T == 0:\n        var p, c, d\
    \ = ii()\n        st.update(p, (c, d))\n    else:\n        var l, r, x = ii()\n\
    \        if r == len(st) and l == 0:\n            assert r == N\n            var\
    \ (a, b) = st.get_all\n            echo (a*x mod MOD + b) mod MOD\n        else:\n\
    \            var (a, b) = st.get(l, r)\n            echo (a*x mod MOD + b) mod\
    \ MOD\n"
  dependsOn:
  - cplib/collections/segtree_var.nim
  - cplib/collections/segtree_var.nim
  isVerificationFile: true
  path: verify/collections/segtree_var/segtree_PSRC_2_test.nim
  requiredBy: []
  timestamp: '2024-06-11 06:34:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/segtree_var/segtree_PSRC_2_test.nim
layout: document
redirect_from:
- /verify/verify/collections/segtree_var/segtree_PSRC_2_test.nim
- /verify/verify/collections/segtree_var/segtree_PSRC_2_test.nim.html
title: verify/collections/segtree_var/segtree_PSRC_2_test.nim
---
