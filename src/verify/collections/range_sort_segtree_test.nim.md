---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_sort_segtree.nim
    title: cplib/collections/range_sort_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_sort_segtree.nim
    title: cplib/collections/range_sort_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/point_set_range_sort_range_composite
    links:
    - https://judge.yosupo.jp/problem/point_set_range_sort_range_composite
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_set_range_sort_range_composite\n\
    import algorithm\nimport cplib/collections/range_sort_segtree\n\nproc scanf(formatstr:\
    \ cstring): cint {.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.}\
    \ = discard scanf(\"%lld\", addr result)\n\nconst MOD = 998244353\ntype Affine\
    \ = tuple[a, b: int]\n\nproc compose(f, g: Affine): Affine =\n    (g.a * f.a mod\
    \ MOD, (g.a * f.b + g.b) mod MOD)\n\nlet n = ii()\nlet q = ii()\nvar keys = newSeq[int](n)\n\
    var values = newSeq[Affine](n)\nfor i in 0..<n:\n    keys[i] = ii()\n    values[i]\
    \ = (ii(), ii())\nlet seg = initRangeSortSegmentTree(keys, values, 1_000_000_001,\
    \ compose, (1, 0))\nfor _ in 0..<q:\n    case ii()\n    of 0:\n        let i =\
    \ ii()\n        let p = ii()\n        let a = ii()\n        let b = ii()\n   \
    \     seg.update(i, p, (a, b))\n    of 1:\n        let l = ii()\n        let r\
    \ = ii()\n        let x = ii()\n        let f = seg.get(l, r)\n        echo (f.a\
    \ * x + f.b) mod MOD\n    of 2:\n        let l = ii()\n        let r = ii()\n\
    \        seg.sort(l, r)\n    of 3:\n        let l = ii()\n        let r = ii()\n\
    \        seg.sort(l, r, Descending)\n    else:\n        discard\n"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  - cplib/collections/range_sort_segtree.nim
  - cplib/collections/range_sort_segtree.nim
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: true
  path: verify/collections/range_sort_segtree_test.nim
  requiredBy: []
  timestamp: '2026-09-28 03:02:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/range_sort_segtree_test.nim
layout: document
redirect_from:
- /verify/verify/collections/range_sort_segtree_test.nim
- /verify/verify/collections/range_sort_segtree_test.nim.html
title: verify/collections/range_sort_segtree_test.nim
---
