---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rangeset.nim
    title: cplib/collections/rangeset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rangeset.nim
    title: cplib/collections/rangeset.nim
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


    import cplib/collections/rangeset


    var rs = initRangeSet[int](0)

    assert rs.get_segment(10) == (low(int), high(int), 0)

    rs.update(2, 5, 1)

    assert rs.get_segment(2) == (2, 5, 1)

    assert rs.get_segment(4) == (2, 5, 1)

    assert rs.get_segment(5)[2] == 0

    rs.update(5, 7, 1)

    assert rs.get_segment(6) == (2, 7, 1)

    rs.update(3, 4, 2)

    assert rs.get_segment(2) == (2, 3, 1)

    assert rs.get_segment(3) == (3, 4, 2)

    assert rs.get_segment(4) == (4, 7, 1)

    rs.update(0, 10, 0)

    assert rs.get_segment(3) == (low(int), high(int), 0)


    var names = initRangeSet[string]("none")

    names.update(1, 3, "hot")

    assert names.get_segment(2) == (1, 3, "hot")

    assert names.get_segment(3)[2] == "none"

    '
  dependsOn:
  - cplib/collections/rangeset.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  - cplib/collections/rangeset.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: true
  path: verify/AI/rangeset_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:12:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/rangeset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/rangeset_test.nim
- /verify/verify/AI/rangeset_test.nim.html
title: verify/AI/rangeset_test.nim
---
