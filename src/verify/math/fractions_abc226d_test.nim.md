---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':question:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc226/tasks/abc226_d
    links:
    - https://atcoder.jp/contests/abc226/tasks/abc226_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc226/tasks/abc226_d\n\
    import sequtils, strutils, sets\nimport cplib/math/fractions\n\nvar n = stdin.readLine.parseInt\n\
    var x, y = newSeqWith(n, 0)\nfor i in 0..<n: (x[i], y[i]) = stdin.readLine.split.map\
    \ parseInt\nvar st = initHashSet[Fraction[int]](0)\nfor i in 0..<n:\n    for j\
    \ in i+1..<n:\n        var x = initFraction(x[i] - x[j], y[i] - y[j])\n      \
    \  if x == initFraction(-1, 0): x = initFraction(1, 0)\n        st.incl(x)\necho\
    \ st.len * 2\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/math/fractions_abc226d_test.nim
  requiredBy: []
  timestamp: '2024-03-28 19:09:38+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/fractions_abc226d_test.nim
layout: document
redirect_from:
- /verify/verify/math/fractions_abc226d_test.nim
- /verify/verify/math/fractions_abc226d_test.nim.html
title: verify/math/fractions_abc226d_test.nim
---
