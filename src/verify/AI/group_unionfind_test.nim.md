---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/group_unionfind.nim
    title: cplib/collections/group_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/group_unionfind.nim
    title: cplib/collections/group_unionfind.nim
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

    import cplib/collections/group_unionfind


    var uf = initUnionFind(4)

    uf.unite(0, 1)

    uf.unite(1, 2)

    assert uf.issame(0, 2)

    assert uf.siz(1) == 3

    assert uf.edge_count(0) == 2

    assert uf.is_tree(0)

    assert not uf.has_cycle(0)


    uf.unite(2, 0)

    assert uf.edge_count(1) == 3

    assert uf.is_namori(2)

    assert uf.has_cycle(2)


    var group = uf.get_group(0)

    group.sort()

    assert group == @[0, 1, 2]


    var groups = uf.groups().mapIt(sorted(it))

    groups.sort(proc(a, b: seq[int]): int = cmp(a[0], b[0]))

    assert groups == @[@[0, 1, 2], @[3]]


    var cp = uf.copy()

    assert cp.edge_count(0) == 3

    cp.unite(2, 3)

    assert cp.issame(0, 3)

    assert not uf.issame(0, 3)

    '
  dependsOn:
  - cplib/collections/group_unionfind.nim
  - cplib/collections/group_unionfind.nim
  isVerificationFile: true
  path: verify/AI/group_unionfind_test.nim
  requiredBy: []
  timestamp: '2026-07-09 02:51:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/group_unionfind_test.nim
layout: document
redirect_from:
- /verify/verify/AI/group_unionfind_test.nim
- /verify/verify/AI/group_unionfind_test.nim.html
title: verify/AI/group_unionfind_test.nim
---
