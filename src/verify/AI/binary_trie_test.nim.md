---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/binary_trie.nim
    title: cplib/collections/binary_trie.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/binary_trie.nim
    title: cplib/collections/binary_trie.nim
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


    import cplib/collections/binary_trie


    var trie = initBineryTrie(3)

    trie.incl(1)

    trie.incl(4)

    trie.incl(7, 2)

    assert trie.len == 4

    assert trie.count(7) == 2

    assert trie.contains(4)

    assert not trie.contains(2)

    assert trie.get_kth(0) == 1

    assert trie.get_kth(1) == 4

    assert trie.get_kth(2) == 7

    assert trie[3] == 7

    assert trie.get_kth(4) == -1

    assert trie.get_kth(1, 2) == 7

    assert trie.lowerBound(4) == 1

    assert trie.upperBound(4) == 2

    assert trie.lowerBound(5, 2) == 1

    assert trie.upperBound(5, 2) == 3

    trie.excl(7)

    assert trie.count(7) == 1

    assert $trie == "@[(1, 1), (4, 1), (7, 1)]"

    '
  dependsOn:
  - cplib/collections/binary_trie.nim
  - cplib/collections/binary_trie.nim
  isVerificationFile: true
  path: verify/AI/binary_trie_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/binary_trie_test.nim
layout: document
redirect_from:
- /verify/verify/AI/binary_trie_test.nim
- /verify/verify/AI/binary_trie_test.nim.html
title: verify/AI/binary_trie_test.nim
---
