---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/dp/tasks/dp_r
    links:
    - https://atcoder.jp/contests/dp/tasks/dp_r
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://atcoder.jp/contests/dp/tasks/dp_r

    include cplib/matrix/matrix

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)

    import atcoder/modint

    type mint = modint1000000007


    var n, k = ii()

    var a = newSeqWith(n, newSeqWith(n, mint(ii()))).toMatrix

    echo a.pow(k).sum

    '
  dependsOn:
  - cplib/matrix/matrix.nim
  - cplib/matrix/matrix.nim
  isVerificationFile: true
  path: verify/matrix/matrix_dpr_test.nim
  requiredBy: []
  timestamp: '2024-03-28 20:27:50+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_dpr_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_dpr_test.nim
- /verify/verify/matrix/matrix_dpr_test.nim.html
title: verify/matrix/matrix_dpr_test.nim
---
