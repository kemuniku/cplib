---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':question:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree2d.nim
    title: cplib/collections/segtree2d.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree2d.nim
    title: cplib/collections/segtree2d.nim
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


    import cplib/collections/segtree2d


    var seg2d = initSegmentTree2D(@[@[1, 2, 3], @[4, 5, 6]], proc(x, y: int): int
    = x + y, 0)

    assert seg2d.get(0, 2, 0, 3) == 21

    assert seg2d.get(1, 2, 1, 3) == 11

    seg2d.update(0, 1, 10)

    assert seg2d.get(0, 1, 0, 3) == 14

    assert seg2d.get(0, 2, 1, 2) == 15

    '
  dependsOn:
  - cplib/collections/segtree2d.nim
  - cplib/collections/segtree2d.nim
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/AI/segtree2d_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/segtree2d_test.nim
layout: document
redirect_from:
- /verify/verify/AI/segtree2d_test.nim
- /verify/verify/AI/segtree2d_test.nim.html
title: verify/AI/segtree2d_test.nim
---
