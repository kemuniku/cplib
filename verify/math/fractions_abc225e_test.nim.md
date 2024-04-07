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
    PROBLEM: https://atcoder.jp/contests/abc225/tasks/abc225_e
    links:
    - https://atcoder.jp/contests/abc225/tasks/abc225_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc225/tasks/abc225_e\n\
    import strutils, sequtils, algorithm\nimport cplib/math/fractions\n\nvar n = stdin.readLine.parseint\n\
    var p = newSeq[(Fraction[int], Fraction[int])](n)\nfor i in 0..<n:\n    var x,\
    \ y: int\n    (x, y) = stdin.readLine.split.map parseInt\n    var lower = initFraction(y-1,\
    \ x)\n    var upper = if x != 1: initFraction(y, x-1) else: initFraction(int(2000000000),\
    \ 1)\n    p[i] = (lower, upper)\np.sort(proc(x, y: (Fraction[int], Fraction[int])):\
    \ int =\n    if x[1] != y[1]: return cmp(x[1], y[1])\n    return cmp(x[0], y[0])\n\
    )\nvar cur = initFraction(-2, 1)\nvar ans = 0\nfor i in 0..<n:\n    var (l, u)\
    \ = p[i]\n    if cur > l: continue\n    ans += 1\n    cur = u\necho ans\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/math/fractions_abc225e_test.nim
  requiredBy: []
  timestamp: '2024-03-28 19:09:38+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/fractions_abc225e_test.nim
layout: document
redirect_from:
- /verify/verify/math/fractions_abc225e_test.nim
- /verify/verify/math/fractions_abc225e_test.nim.html
title: verify/math/fractions_abc225e_test.nim
---
