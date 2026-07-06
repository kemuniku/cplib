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

    import cplib/collections/avlset


    var ms = initAvlSortedMultiSet(@[3, 1, 2, 2])

    assert ms.len == 4

    assert ms.toSeq == @[1, 2, 2, 3]

    assert ms.count(2) == 2

    assert ms.lowerBound(2) == 1

    assert ms.upperBound(2) == 3

    assert ms.index(3) == 3

    assert ms.index_right(2) == 3

    assert ms.lt(2).get == 1

    assert ms.le(2).get == 2

    assert ms.gt(2).get == 3

    assert ms.ge(2).get == 2

    assert ms[0] == 1

    assert ms[^1] == 3

    assert ms.pop(1) == 2

    assert ms.excl(2)

    assert not ms.excl(4)

    assert $ms == "1 3"


    var st = initAvlSortedSet(@[2, 1, 2])

    assert st.len == 2

    assert st.toSeq == @[1, 2]

    assert not st.incl(2)

    assert st.incl(3)

    assert st.contains(3)

    assert st.pop() == 3

    '
  dependsOn:
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: true
  path: verify/AI/avlset_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/avlset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/avlset_test.nim
- /verify/verify/AI/avlset_test.nim.html
title: verify/AI/avlset_test.nim
---
