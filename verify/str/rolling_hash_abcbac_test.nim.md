---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/rolling_hash.nim
    title: cplib/str/rolling_hash.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/rolling_hash.nim
    title: cplib/str/rolling_hash.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc284/tasks/abc284_f
    links:
    - https://atcoder.jp/contests/abc284/tasks/abc284_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc284/tasks/abc284_f\n\
    import strutils, algorithm\nimport cplib/str/rolling_hash\n\nvar n = stdin.readLine.parseInt\n\
    var t = stdin.readLine\nvar rh = initRollingHash(t)\nvar rhi = initRollingHash(t.reversed)\n\
    const rmod = (1u shl 61) - 1\nfor i in 0..n:\n    var sh = rh.query(0..<i)\n \
    \   sh += rh.query(n..<2*n)\n    sh += rmod - rh.query(n..<n+i)\n    sh = (sh\
    \ shr 61) + (sh and rmod)\n    if sh > rmod: sh -= rmod\n    var shi = rhi.query(n-i..<2*n-i)\n\
    \    if sh == shi:\n        echo t[0..<i] & t[n+i..<2*n]\n        echo i\n   \
    \     quit()\necho -1\n"
  dependsOn:
  - cplib/str/rolling_hash.nim
  - cplib/str/rolling_hash.nim
  isVerificationFile: true
  path: verify/str/rolling_hash_abcbac_test.nim
  requiredBy: []
  timestamp: '2024-06-07 22:14:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/rolling_hash_abcbac_test.nim
layout: document
redirect_from:
- /verify/verify/str/rolling_hash_abcbac_test.nim
- /verify/verify/str/rolling_hash_abcbac_test.nim.html
title: verify/str/rolling_hash_abcbac_test.nim
---
