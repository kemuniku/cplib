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


    import cplib/matrix/matops


    let a = @[@[1, 2, 3], @[4, 5, 6]]

    assert a.rotated(1) == @[@[4, 1], @[5, 2], @[6, 3]]

    assert a.rotated(2) == @[@[6, 5, 4], @[3, 2, 1]]

    assert a.rotated(-1) == @[@[3, 6], @[2, 5], @[1, 4]]

    assert a.transposed == @[@[1, 4], @[2, 5], @[3, 6]]

    var b = a

    b.rotate()

    assert b == @[@[4, 1], @[5, 2], @[6, 3]]

    b.transpose()

    assert b == @[@[4, 5, 6], @[1, 2, 3]]

    var c = @[@[0, 0, 0], @[0, 1, 0], @[0, 0, 0]]

    c.trim(0)

    assert c == @[@[1]]


    let s = @["10", "01"]

    assert s.rotated == @["01", "10"]

    assert s.transposed == @["10", "01"]

    var t = @["000", "010", "000"]

    t.trim(''0'')

    assert t == @["1"]

    '
  dependsOn:
  - cplib/matrix/matops.nim
  - cplib/matrix/matops.nim
  isVerificationFile: true
  path: verify/AI/matops_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/matops_test.nim
layout: document
redirect_from:
- /verify/verify/AI/matops_test.nim
- /verify/verify/AI/matops_test.nim.html
title: verify/AI/matops_test.nim
---
