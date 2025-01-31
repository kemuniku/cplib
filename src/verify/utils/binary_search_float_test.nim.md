---
data:
  _extendedDependsOn:
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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_4_A

    # verification-helper: ERROR 1e-5

    import sequtils, strutils

    import cplib/utils/binary_search


    var a, b: int

    (a, b) = stdin.readLine.split.map(parseInt)

    var div_int = meguru_bisect(0, a+1, proc(x: int): bool = a >= b * x)

    var rem = a - b * div_int

    var div_flaot = meguru_bisect(0.0, float64(a + 1), proc(x: float64): bool = (float64(a)
    >= float64(b) * x))

    echo div_int, " ", rem, " ", div_flaot

    '
  dependsOn:
  - cplib/utils/binary_search.nim
  - cplib/utils/binary_search.nim
  isVerificationFile: true
  path: verify/utils/binary_search_float_test.nim
  requiredBy: []
  timestamp: '2023-12-25 07:39:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/binary_search_float_test.nim
layout: document
redirect_from:
- /verify/verify/utils/binary_search_float_test.nim
- /verify/verify/utils/binary_search_float_test.nim.html
title: verify/utils/binary_search_float_test.nim
---
