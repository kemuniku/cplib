---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_var.nim
    title: cplib/collections/segtree_var.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_var.nim
    title: cplib/collections/segtree_var.nim
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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport cplib/collections/segtree_var\n\nlet merge = proc(x,\
    \ y: int): int = x + y\nvar original = initSegmentTree(@[1, 2, 3, 4], merge, 0)\n\
    var copied = original\ncopied[0] += 10\nassert copied.get_all() == 20\nassert\
    \ original.get_all() == 10\nassert int(original[0]) == 1\noriginal[1] *= 3\nassert\
    \ original.get_all() == 14\nassert copied.get_all() == 20\nassert copied.get(0,\
    \ 2) == 13\ncopied[2] = 8\ncopied[2] -= 3\nassert copied.get_all() == 22\nassert\
    \ original.get_all() == 14\nassert copied.max_right(0, proc(x: int): bool = x\
    \ <= 13) == 2\nassert copied.min_left(4, proc(x: int): bool = x <= 9) == 2\n\n\
    proc makeCopy(): typeof(original) =\n    var local = initSegmentTree(@[5, 6],\
    \ merge, 0)\n    result = local\n    assert local.get_all() == 11\n\nvar returned\
    \ = makeCopy()\nreturned[1] += 7\nassert returned.get_all() == 18\nvar trees =\
    \ @[original, returned]\ntrees[0][0] += 2\ntrees[1][1] -= 1\nassert trees[0].get_all()\
    \ == 16\nassert trees[1].get_all() == 17\nassert original.get_all() == 14\nassert\
    \ returned.get_all() == 18\nswap(trees[0], trees[1])\ntrees[0][0] += 3\nassert\
    \ trees[0].get_all() == 20\nassert trees[1].get_all() == 16\n\nvar sized = initSegmentTree(3,\
    \ merge, 0)\nvar sizedCopy = sized\nsizedCopy[2] += 9\nassert sizedCopy.get_all()\
    \ == 9\nassert sized.get_all() == 0\n"
  dependsOn:
  - cplib/collections/segtree_var.nim
  - cplib/collections/segtree_var.nim
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: true
  path: verify/collections/segtree_var/copy_test.nim
  requiredBy: []
  timestamp: '2026-09-18 12:10:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/segtree_var/copy_test.nim
layout: document
redirect_from:
- /verify/verify/collections/segtree_var/copy_test.nim
- /verify/verify/collections/segtree_var/copy_test.nim.html
title: verify/collections/segtree_var/copy_test.nim
---
