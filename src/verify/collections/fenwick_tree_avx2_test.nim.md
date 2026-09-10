---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/fenwick_avx2.nim
    title: cplib/collections/fenwick_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/fenwick_avx2.nim
    title: cplib/collections/fenwick_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/point_add_range_sum
    links:
    - https://judge.yosupo.jp/problem/point_add_range_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum\n\
    include cplib/tmpl/fastio\nimport cplib/collections/fenwick_avx2\n\nproc main()\
    \ =\n    let n = input(int)\n    let q = input(int)\n    var bit = initFenwickTreeAvx2(input(n,\
    \ int))\n    var answers = newSeqOfCap[int](q)\n    for _ in 0..<q:\n        let\
    \ t = input(int)\n        let l = input(int)\n        let r = input(int)\n   \
    \     if t == 0:\n            bit.add(l, r)\n        else:\n            answers.add(bit.get(l,\
    \ r))\n    if answers.len > 0:\n        print(*answers, sep=\"\\n\")\n\nmain()\n"
  dependsOn:
  - cplib/collections/fenwick_avx2.nim
  - cplib/tmpl/fastio.nim
  - cplib/collections/fenwick_avx2.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/collections/fenwick_tree_avx2_test.nim
  requiredBy: []
  timestamp: '2026-09-09 17:07:19+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/fenwick_tree_avx2_test.nim
layout: document
redirect_from:
- /verify/verify/collections/fenwick_tree_avx2_test.nim
- /verify/verify/collections/fenwick_tree_avx2_test.nim.html
title: verify/collections/fenwick_tree_avx2_test.nim
---
