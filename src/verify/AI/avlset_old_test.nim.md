---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset_old.nim
    title: cplib/collections/avlset_old.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset_old.nim
    title: cplib/collections/avlset_old.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode_old.nim
    title: cplib/collections/avltreenode_old.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode_old.nim
    title: cplib/collections/avltreenode_old.nim
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


    import options, sequtils

    import cplib/collections/avlset_old


    var s = initAvlSortedSet[int](@[3, 1, 3])

    assert s.toSeq == @[1, 3]

    assert s.len == 2

    assert s.incl(2)

    assert not s.incl(2)

    assert s.toSeq == @[1, 2, 3]

    assert s.lowerBound(2) == 1

    assert s.upperBound(2) == 2

    assert s.index(3) == 2

    assert s.index_right(3) == 3

    assert s.count(2) == 1

    assert s.lt(2).get == 1

    assert s.le(2).get == 2

    assert s.gt(2).get == 3

    assert s.ge(2).get == 2

    assert 2 in s

    assert s[1] == 2

    assert s[^1] == 3

    assert s.pop(1) == 2

    assert s.excl(3)

    assert s.toSeq == @[1]


    var ms = initAvlSortedMultiSet[int](@[2, 1, 2])

    assert ms.toSeq == @[1, 2, 2]

    assert ms.count(2) == 2

    ms.incl(2)

    assert ms.count(2) == 3

    assert ms.pop() == 2

    assert ms.excl(2)

    assert ms.toSeq == @[1, 2]

    '
  dependsOn:
  - cplib/collections/avlset_old.nim
  - cplib/collections/avltreenode_old.nim
  - cplib/collections/avltreenode_old.nim
  - cplib/collections/avlset_old.nim
  isVerificationFile: true
  path: verify/AI/avlset_old_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/avlset_old_test.nim
layout: document
redirect_from:
- /verify/verify/AI/avlset_old_test.nim
- /verify/verify/AI/avlset_old_test.nim.html
title: verify/AI/avlset_old_test.nim
---
