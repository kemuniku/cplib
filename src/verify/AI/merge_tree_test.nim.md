---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/merge_tree.nim
    title: cplib/graph/merge_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/merge_tree.nim
    title: cplib/graph/merge_tree.nim
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


    import cplib/graph/merge_tree


    var mt = initMergeTree(4, @[(0, 1), (2, 3), (1, 2)])

    assert mt.get_id(0) == 0

    mt.unite(0, 1)

    assert mt.get_id(0) == 4

    assert mt.get_id(1) == 4

    assert mt.get_range(0).len == 2

    mt.unite(2, 3)

    assert mt.get_id(2) == 5

    mt.unite(1, 2)

    assert mt.get_id(0) == 6

    assert mt.get_range(3).len == 4

    let ordered = mt.make_seq(@["a", "b", "c", "d"])

    assert mt.restore_seq(ordered) == @["a", "b", "c", "d"]

    assert mt.index(0) in 0..<4

    '
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/merge_tree.nim
  - cplib/collections/unionfind.nim
  - cplib/graph/graph.nim
  - cplib/graph/merge_tree.nim
  - cplib/collections/unionfind.nim
  isVerificationFile: true
  path: verify/AI/merge_tree_test.nim
  requiredBy: []
  timestamp: '2026-07-09 02:51:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/merge_tree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/merge_tree_test.nim
- /verify/verify/AI/merge_tree_test.nim.html
title: verify/AI/merge_tree_test.nim
---
