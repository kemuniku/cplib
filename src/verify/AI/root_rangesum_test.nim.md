---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/root_rangesum.nim
    title: cplib/collections/root_rangesum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/root_rangesum.nim
    title: cplib/collections/root_rangesum.nim
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


    import cplib/collections/root_rangesum


    var rs = initrangesum(@[1, 2, 3, 4, 5], 2, 0)

    assert rs.len == 5

    assert rs.get(0, 5) == 15

    assert rs.get(1, 4) == 9

    assert rs[2] == 3

    assert rs[1..3] == 9

    rs.update(2, 10)

    assert rs.get(0, 5) == 22

    rs[4] = 1

    assert rs.get(3, 5) == 5

    assert rs.max_right(0, proc(x: int): bool = x <= 13) == 3

    assert rs.max_right(4, proc(x: int): bool = x <= 1) == 5

    assert rs.min_left(5, proc(x: int): bool = x <= 5) == 3

    assert rs.min_left(1, proc(x: int): bool = x <= 1) == 0

    assert $rs == "@[1, 2, 10, 4, 1]"

    '
  dependsOn:
  - cplib/collections/root_rangesum.nim
  - cplib/collections/root_rangesum.nim
  isVerificationFile: true
  path: verify/AI/root_rangesum_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/root_rangesum_test.nim
layout: document
redirect_from:
- /verify/verify/AI/root_rangesum_test.nim
- /verify/verify/AI/root_rangesum_test.nim.html
title: verify/AI/root_rangesum_test.nim
---
