---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/matrix/matops.nim
    title: cplib/matrix/matops.nim
  - icon: ':question:'
    path: cplib/matrix/matops.nim
    title: cplib/matrix/matops.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc237/tasks/abc237_b
    links:
    - https://atcoder.jp/contests/abc237/tasks/abc237_b
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://atcoder.jp/contests/abc237/tasks/abc237_b

    import strutils, sequtils

    import cplib/matrix/matops

    var h, w: int

    (h, w) = stdin.readLine.split.map(parseInt)

    var a = newSeqWith(h, stdin.readLine.split.map(parseInt))

    for ai in a.transposed: echo ai.join(" ")

    '
  dependsOn:
  - cplib/matrix/matops.nim
  - cplib/matrix/matops.nim
  isVerificationFile: true
  path: verify/matrix/transposed_abc237b_test.nim
  requiredBy: []
  timestamp: '2024-01-31 11:34:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/transposed_abc237b_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/transposed_abc237b_test.nim
- /verify/verify/matrix/transposed_abc237b_test.nim.html
title: verify/matrix/transposed_abc237b_test.nim
---
