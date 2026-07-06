---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/gridutils.nim
    title: cplib/utils/gridutils.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/gridutils.nim
    title: cplib/utils/gridutils.nim
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


    import algorithm, sequtils

    import cplib/utils/gridutils


    let grid = @[@[1, 2, 3], @[4, 5, 2]]

    assert grid.height == 2

    assert grid.width == 3

    assert grid.gridfind(2) == (0, 1)

    assert grid.gridfind(9) == (-1, -1)

    assert grid.gridfinds(2) == @[(0, 1), (1, 2)]

    assert grid.getid(1, 2) == 5

    assert grid.to_pos(4) == (1, 1)

    assert toSeq(griditer(0, 0, 2, 3)).sorted == @[(0, 1), (1, 0)]

    assert toSeq(griditer(0, 0, 2, 3, dij8)).sorted == @[(0, 1), (1, 0), (1, 1)]

    '
  dependsOn:
  - cplib/utils/gridutils.nim
  - cplib/utils/gridutils.nim
  isVerificationFile: true
  path: verify/AI/gridutils_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/gridutils_test.nim
layout: document
redirect_from:
- /verify/verify/AI/gridutils_test.nim
- /verify/verify/AI/gridutils_test.nim.html
title: verify/AI/gridutils_test.nim
---
