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
    path: cplib/utils/grid_searcher.nim
    title: cplib/utils/grid_searcher.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/grid_searcher.nim
    title: cplib/utils/grid_searcher.nim
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


    import algorithm, options

    import cplib/utils/grid_searcher


    var gs = initGridSearcher()

    gs.incl(1, 2)

    gs.incl((3, 2))

    gs.incl(2, 0)

    gs.incl(2, 5)

    assert gs.len == 4

    assert gs.contains(1, 2)

    assert gs.contains((2, 5))

    assert not gs.contains(0, 0)


    assert gs.up(2, 2).get == (1, 2)

    assert gs.down((2, 2)).get == (3, 2)

    assert gs.left(2, 2).get == (2, 0)

    assert gs.right((2, 2)).get == (2, 5)

    assert gs.up_move(2, 2).get == (2, 2)

    assert gs.down_move(2, 2).get == (2, 2)

    assert gs.left_move(2, 2).get == (2, 1)

    assert gs.right_move(2, 2).get == (2, 4)

    assert gs.up(0, 0).isNone


    assert gs.updownleftright_get(2, 2).sorted == @[(1, 2), (2, 0), (2, 5), (3, 2)]

    assert gs.updownleftright_move_get((2, 2)).sorted == @[(2, 1), (2, 2), (2, 2),
    (2, 4)]

    gs.excl(1, 2)

    gs.excl((3, 2))

    assert gs.len == 2

    assert gs.up(2, 2).isNone

    '
  dependsOn:
  - cplib/utils/grid_searcher.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  - cplib/utils/grid_searcher.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: true
  path: verify/AI/grid_searcher_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/grid_searcher_test.nim
layout: document
redirect_from:
- /verify/verify/AI/grid_searcher_test.nim
- /verify/verify/AI/grid_searcher_test.nim.html
title: verify/AI/grid_searcher_test.nim
---
