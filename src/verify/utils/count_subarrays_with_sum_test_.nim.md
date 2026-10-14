---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/count_subarrays_with_sum.nim
    title: cplib/utils/count_subarrays_with_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/count_subarrays_with_sum.nim
    title: cplib/utils/count_subarrays_with_sum.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc233/tasks/abc233_d
    links:
    - https://atcoder.jp/contests/abc233/tasks/abc233_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://atcoder.jp/contests/abc233/tasks/abc233_d

    import sequtils, strutils

    import cplib/utils/count_subarrays_with_sum


    let nk = stdin.readLine.splitWhitespace.map(parseBiggestInt)

    let a = stdin.readLine.splitWhitespace.map(parseBiggestInt)

    echo count_subarrays_with_sum(a, nk[1])

    '
  dependsOn:
  - cplib/utils/count_subarrays_with_sum.nim
  - cplib/utils/count_subarrays_with_sum.nim
  isVerificationFile: false
  path: verify/utils/count_subarrays_with_sum_test_.nim
  requiredBy: []
  timestamp: '2026-10-05 11:50:12+00:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/utils/count_subarrays_with_sum_test_.nim
layout: document
redirect_from:
- /library/verify/utils/count_subarrays_with_sum_test_.nim
- /library/verify/utils/count_subarrays_with_sum_test_.nim.html
title: verify/utils/count_subarrays_with_sum_test_.nim
---
