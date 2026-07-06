---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':question:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/compressed_trie.nim
    title: cplib/str/compressed_trie.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/compressed_trie.nim
    title: cplib/str/compressed_trie.nim
  - icon: ':question:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':question:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
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

    import cplib/graph/graph

    import cplib/str/compressed_trie

    import cplib/str/static_string


    let words = toStaticStrings(@["a", "ab", "ab", "ac", "b"])

    let root = initCompressedTrie(words)

    let vr = root.get_virtualnode

    assert vr.get_cnt == 0

    assert vr.get_subtree_sum == 5

    assert vr.has_child(''a'')

    assert vr.has_child(''b'')


    let va = vr.get_child(''a'')

    assert va.get_cnt == 1

    assert va.get_subtree_sum == 4

    assert va.has_child(''b'')

    assert va.has_child(''c'')

    assert va.get_child(''b'').get_cnt == 2

    assert va.get_child(''c'').get_cnt == 1

    assert vr.get_child(''b'').get_cnt == 1


    let g = root.toGraph()

    assert g.len >= 3

    assert toSeq(g[0]).mapIt($it[1]).sorted == @["a", "b"]

    '
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/str/static_string.nim
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/compressed_trie.nim
  - cplib/str/compressed_trie.nim
  - cplib/collections/staticRMQ.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/compressed_trie_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/compressed_trie_test.nim
layout: document
redirect_from:
- /verify/verify/AI/compressed_trie_test.nim
- /verify/verify/AI/compressed_trie_test.nim.html
title: verify/AI/compressed_trie_test.nim
---
