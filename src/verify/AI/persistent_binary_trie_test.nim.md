---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_binary_trie.nim
    title: cplib/collections/persistent_binary_trie.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_binary_trie.nim
    title: cplib/collections/persistent_binary_trie.nim
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


    import cplib/collections/persistent_binary_trie


    let t0 = initPersistentBineryTrie(3)

    let t1 = t0.incl(1)

    let t2 = t1.incl(4).incl(7, 2)

    assert t0.count(1) == 0

    assert t1.contains(1)

    assert not t1.contains(4)

    assert t2.count(7) == 2

    assert t2.get_kth(0) == 1

    assert t2.get_kth(1) == 4

    assert t2.get_kth(2) == 7

    assert t2.get_kth(1, 2) == 7

    assert t2.lowerBound(4) == 1

    assert t2.upperBound(4) == 2

    let t3 = t2.excl(7)

    assert t2.count(7) == 2

    assert t3.count(7) == 1

    let t4 = t3.set_value(4, 3)

    assert t4.count(4) == 3

    assert t4.RLE() == @[(1, 1), (4, 3), (7, 1)]

    assert $t4 == "@[(1, 1), (4, 3), (7, 1)]"

    '
  dependsOn:
  - cplib/collections/persistent_binary_trie.nim
  - cplib/collections/persistent_binary_trie.nim
  isVerificationFile: true
  path: verify/AI/persistent_binary_trie_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/persistent_binary_trie_test.nim
layout: document
redirect_from:
- /verify/verify/AI/persistent_binary_trie_test.nim
- /verify/verify/AI/persistent_binary_trie_test.nim.html
title: verify/AI/persistent_binary_trie_test.nim
---
