---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc308/tasks/abc308_c
    links:
    - https://atcoder.jp/contests/abc308/tasks/abc308_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc308/tasks/abc308_c\n\
    import algorithm, strutils, sequtils\nimport cplib/math/fractions\n\nvar n = stdin.readLine.parseint\n\
    var people: seq[(Fraction[int], int)]\nfor i in 0..<n:\n    var a, b: int\n  \
    \  (a, b) = stdin.readLine.split.map parseInt\n    var x = initFraction(a, a+b)\n\
    \    people.add((x, -i-1))\npeople.sort(Descending)\necho people.mapit(-it[1]).join(\"\
    \ \")\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/math/fractions_abc308c_test.nim
  requiredBy: []
  timestamp: '2024-01-20 04:30:03+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/fractions_abc308c_test.nim
layout: document
redirect_from:
- /verify/verify/math/fractions_abc308c_test.nim
- /verify/verify/math/fractions_abc308c_test.nim.html
title: verify/math/fractions_abc308c_test.nim
---
