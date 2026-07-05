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

    import cplib/collections/avlset


    # Test empty AVLSortedSet string conversion

    var emptySet = initAvlSortedSet[int]()

    assert $emptySet == ""

    assert emptySet.len == 0


    # Test empty AvlSortedMultiSet string conversion

    var emptyMultiSet = initAvlSortedMultiSet[int]()

    assert $emptyMultiSet == ""

    assert emptyMultiSet.len == 0


    # Test non-empty AVLSortedSet string conversion

    var nonEmptySet = initAvlSortedSet(@[3, 1, 2])

    assert nonEmptySet.len == 3

    var nonEmptySetStr = $nonEmptySet

    assert nonEmptySetStr == "1 2 3"


    # Test non-empty AvlSortedMultiSet string conversion

    var nonEmptyMultiSet = initAvlSortedMultiSet(@[3, 1, 2, 2])

    assert nonEmptyMultiSet.len == 4

    var nonEmptyMultiSetStr = $nonEmptyMultiSet

    assert nonEmptyMultiSetStr == "1 2 2 3"


    # Test set becoming empty after removal

    var setWithItem = initAvlSortedSet(@[42])

    assert setWithItem.len == 1

    assert $setWithItem == "42"

    discard setWithItem.excl(42)

    assert setWithItem.len == 0

    assert $setWithItem == ""

    '
  dependsOn:
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avlset.nim
  isVerificationFile: true
  path: verify/collections/avlset/avlset_empty_string_test.nim
  requiredBy: []
  timestamp: '2025-11-08 19:42:23+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avlset/avlset_empty_string_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avlset/avlset_empty_string_test.nim
- /verify/verify/collections/avlset/avlset_empty_string_test.nim.html
title: verify/collections/avlset/avlset_empty_string_test.nim
---
