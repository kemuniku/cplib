---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/argsort.nim
    title: cplib/geometry/argsort.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/argsort.nim
    title: cplib/geometry/argsort.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
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


    import cplib/geometry/argsort


    var dirs = @[(0, -1), (1, 0), (0, 1), (-1, 0)]

    argsort(dirs)

    assert dirs == @[(1, 0), (0, 1), (-1, 0), (0, -1)]

    assert argsorted(@[(0, 1), (1, 0), (-1, 0)]) == @[(1, 0), (0, 1), (-1, 0)]

    assert argcmp((1, 0), (0, 1)) < 0

    '
  dependsOn:
  - cplib/math/int128.nim
  - cplib/geometry/argsort.nim
  - cplib/math/int128.nim
  - cplib/geometry/argsort.nim
  isVerificationFile: true
  path: verify/AI/argsort_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/argsort_test.nim
layout: document
redirect_from:
- /verify/verify/AI/argsort_test.nim
- /verify/verify/AI/argsort_test.nim.html
title: verify/AI/argsort_test.nim
---
