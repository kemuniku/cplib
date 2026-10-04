---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/slopetrick.nim
    title: cplib/collections/slopetrick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/slopetrick.nim
    title: cplib/collections/slopetrick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport cplib/collections/slopetrick\n\nlet st = initSlopeTrick(0)\n\
    doAssert st.min == 0\nst.add_abs(3)\ndoAssert st.min == 0\ndoAssert st.min_index\
    \ == 3\ndoAssert st.get_value(1) == 2\nst.add_x_minus_a(5)\ndoAssert st.get_value(6)\
    \ == 4\nst.add_a_minus_x(0)\nst.add_all(7)\ndoAssert st.min >= 7\nst.shift(2)\n\
    doAssert st.get_value(5) >= st.min\nst.shift(-1, 1)\ndoAssert st.get_value(5)\
    \ >= st.min\nst.clearL()\nst.clearR()\ndoAssert st.get_value(0) == st.min\n\n\
    import cplib/utils/constants\n\nblock:\n  let constant = initSlopeTrick(7)\n \
    \ doAssert constant.get_value(INF64 + 1) == 7\n  doAssert constant.get_value(-INF64\
    \ - 1) == 7\n  constant.shift(INF64 - 1)\n  doAssert constant.get_value(-2) ==\
    \ 7\n  constant.add_x_minus_a(-2)\n  doAssert constant.min == 7\n  doAssert constant.get_value(-3)\
    \ == 7\n  doAssert constant.get_value(0) == 9\n\nblock:\n  let constant = initSlopeTrick(7)\n\
    \  constant.shift(-INF64 + 1)\n  doAssert constant.get_value(2) == 7\n  constant.add_a_minus_x(2)\n\
    \  doAssert constant.min == 7\n  doAssert constant.get_value(3) == 7\n  doAssert\
    \ constant.get_value(0) == 9\n\nblock:\n  let cleared = initSlopeTrick(0)\n  cleared.shift(10)\n\
    \  cleared.add_abs(3)\n  cleared.clearL()\n  doAssert cleared.get_value(-INF64\
    \ - 1) == 0\n  doAssert cleared.get_value(4) == 1\n  cleared.clearR()\n  doAssert\
    \ cleared.get_value(INF64 + 1) == 0\n  cleared.shift(INF64 - 1)\n  cleared.add_abs(2)\n\
    \  doAssert cleared.min == 0\n  doAssert cleared.min_index == 2\n  doAssert cleared.get_value(0)\
    \ == 2\n  doAssert cleared.get_value(4) == 2\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/collections/slopetrick.nim
  - cplib/collections/slopetrick.nim
  isVerificationFile: true
  path: verify/AI/slopetrick_test.nim
  requiredBy: []
  timestamp: '2026-10-01 02:34:47+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/slopetrick_test.nim
layout: document
redirect_from:
- /verify/verify/AI/slopetrick_test.nim
- /verify/verify/AI/slopetrick_test.nim.html
title: verify/AI/slopetrick_test.nim
---
