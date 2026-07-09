---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/rolling_hash_2d.nim
    title: cplib/matrix/rolling_hash_2d.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/rolling_hash_2d.nim
    title: cplib/matrix/rolling_hash_2d.nim
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


    import cplib/matrix/rolling_hash_2d


    let hm = initHashMatrix(@[@[1, 2, 1], @[3, 4, 3]])

    assert hm[0, 1] == 2

    assert hm[1][2] == 3

    let leftCol = hm[0..1, 0..0]

    let rightCol = hm.get(0..1, 2..2)

    let middleCol = hm[0..1, 1..1]

    assert leftCol == rightCol

    assert leftCol.gethash == rightCol.gethash

    assert leftCol != middleCol

    '
  dependsOn:
  - cplib/matrix/rolling_hash_2d.nim
  - cplib/matrix/rolling_hash_2d.nim
  isVerificationFile: true
  path: verify/AI/rolling_hash_2d_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:15:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/rolling_hash_2d_test.nim
layout: document
redirect_from:
- /verify/verify/AI/rolling_hash_2d_test.nim
- /verify/verify/AI/rolling_hash_2d_test.nim.html
title: verify/AI/rolling_hash_2d_test.nim
---
