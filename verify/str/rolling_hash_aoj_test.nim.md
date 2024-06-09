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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_14_B
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_14_B
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_14_B\n\
    import cplib/str/rolling_hash\n\nvar t, p = stdin.readLine\nvar rh_t = initRollingHash(t)\n\
    var rh_p = initRollingHash(p)\nfor i in 0..<t.len-p.len+1:\n    if rh_t.query(i..<i+p.len)\
    \ == rh_p.query(0..<p.len):\n        echo i\n"
  dependsOn:
  - cplib/str/rolling_hash.nim
  - cplib/str/rolling_hash.nim
  isVerificationFile: true
  path: verify/str/rolling_hash_aoj_test.nim
  requiredBy: []
  timestamp: '2024-06-07 22:14:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/rolling_hash_aoj_test.nim
layout: document
redirect_from:
- /verify/verify/str/rolling_hash_aoj_test.nim
- /verify/verify/str/rolling_hash_aoj_test.nim.html
title: verify/str/rolling_hash_aoj_test.nim
---
