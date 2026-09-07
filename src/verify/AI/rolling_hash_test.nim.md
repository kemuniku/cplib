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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport cplib/str/rolling_hash\n\nlet rh = initRollingHash(@[1,\
    \ 2, 3, 1, 2, 3])\nassert rh.query(0..2) == rh.query(3..5)\nassert rh.query(0..1)\
    \ != rh.query(1..2)\n\nlet arrayRh = initRollingHash([1, 2, 3, 1, 2, 3])\nassert\
    \ arrayRh.query(0..2) == arrayRh.query(3..5)\n\nproc checkOpenArray(s: openArray[int])\
    \ =\n    let openArrayRh = initRollingHash(s)\n    assert openArrayRh.query(0..2)\
    \ == openArrayRh.query(3..5)\n\ncheckOpenArray([1, 2, 3, 1, 2, 3])\n\nvar rh2\
    \ = initRollingHash(\"abcabc\")\nrh2.build(seed = 1)\nassert rh2.query(0..2) ==\
    \ rh2.query(3..5)\nlet typedStringRh: RollingHash[string] = initRollingHash(\"\
    abcabc\")\nassert typedStringRh.query(0..2) == typedStringRh.query(3..5)\n"
  dependsOn:
  - cplib/str/rolling_hash.nim
  - cplib/str/rolling_hash.nim
  isVerificationFile: true
  path: verify/AI/rolling_hash_test.nim
  requiredBy: []
  timestamp: '2026-09-04 08:24:17+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/rolling_hash_test.nim
layout: document
redirect_from:
- /verify/verify/AI/rolling_hash_test.nim
- /verify/verify/AI/rolling_hash_test.nim.html
title: verify/AI/rolling_hash_test.nim
---
