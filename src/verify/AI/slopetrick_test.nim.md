---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/slopetrick.nim
    title: cplib/collections/slopetrick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/slopetrick.nim
    title: cplib/collections/slopetrick.nim
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':question:'
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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/collections/slopetrick


    let st = initSlopeTrick(0)

    assert st.min == 0

    st.add_abs(3)

    assert st.min == 0

    assert st.min_index == 3

    assert st.get_value(1) == 2

    st.add_x_minus_a(5)

    assert st.get_value(6) == 4

    st.add_a_minus_x(0)

    st.add_all(7)

    assert st.min >= 7

    st.shift(2)

    assert st.get_value(5) >= st.min

    st.shift(-1, 1)

    assert st.get_value(5) >= st.min

    st.clearL()

    st.clearR()

    assert st.get_value(0) == st.min

    '
  dependsOn:
  - cplib/collections/slopetrick.nim
  - cplib/utils/constants.nim
  - cplib/collections/slopetrick.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/AI/slopetrick_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/slopetrick_test.nim
layout: document
redirect_from:
- /verify/verify/AI/slopetrick_test.nim
- /verify/verify/AI/slopetrick_test.nim.html
title: verify/AI/slopetrick_test.nim
---
