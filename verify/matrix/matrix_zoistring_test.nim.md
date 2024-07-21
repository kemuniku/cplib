---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  - icon: ':question:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://yukicoder.me/problems/no/2156
    links:
    - https://yukicoder.me/problems/no/2156
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://yukicoder.me/problems/no/2156

    include cplib/matrix/matrix

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)

    import atcoder/modint

    type mint = modint998244353


    var n = ii()

    var a = @[@[mint(1), mint(1)], @[mint(1), mint(0)]].toMatrix

    var ans = initMatrix(@[mint(1), mint(0)], true)

    ans = a.pow(n) * ans

    echo ans[0, 0] - 1

    '
  dependsOn:
  - cplib/matrix/matrix.nim
  - cplib/matrix/matrix.nim
  isVerificationFile: true
  path: verify/matrix/matrix_zoistring_test.nim
  requiredBy: []
  timestamp: '2024-03-29 02:44:59+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_zoistring_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_zoistring_test.nim
- /verify/verify/matrix/matrix_zoistring_test.nim.html
title: verify/matrix/matrix_zoistring_test.nim
---
