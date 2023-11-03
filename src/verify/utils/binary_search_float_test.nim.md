---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/binary_search.nim
    title: cplib/utils/binary_search.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/binary_search.nim
    title: cplib/utils/binary_search.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    ERROR: 1e-5
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_4_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_4_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_4_A

    # verification-helper: ERROR 1e-5

    include cplib/tmpl/citrus

    import cplib/utils/binary_search


    var a, b = input(int)

    var div_int = meguru_bisect(0, a+1, proc(x: int): bool = a >= b * x)

    var rem = a - b * div_int

    var div_flaot = meguru_bisect(0.0, float64(a + 1), (x)=>(a >= b * x))

    print(div_int, rem, div_flaot)

    '
  dependsOn:
  - cplib/utils/binary_search.nim
  - cplib/tmpl/citrus.nim
  - cplib/tmpl/citrus.nim
  - cplib/utils/binary_search.nim
  isVerificationFile: true
  path: verify/utils/binary_search_float_test.nim
  requiredBy: []
  timestamp: '2023-11-04 04:14:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/binary_search_float_test.nim
layout: document
redirect_from:
- /verify/verify/utils/binary_search_float_test.nim
- /verify/verify/utils/binary_search_float_test.nim.html
title: verify/utils/binary_search_float_test.nim
---
