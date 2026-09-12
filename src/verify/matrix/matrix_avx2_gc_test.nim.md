---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2.nim
    title: cplib/matrix/matrix_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2.nim
    title: cplib/matrix/matrix_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_field_impl.nim
    title: cplib/matrix/matrix_avx2_field_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_field_impl.nim
    title: cplib/matrix/matrix_avx2_field_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_kernel.nim
    title: cplib/matrix/matrix_avx2_kernel.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_kernel.nim
    title: cplib/matrix/matrix_avx2_kernel.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
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
    import cplib/matrix/matrix_avx2\nimport cplib/modint/modint\nimport cplib/collections/segtree\n\
    \ntype Mint = modint998244353_montgomery\ntype Mat = Matrix[Mint]\n\nproc make(value:\
    \ int): Mat =\n    initMatrix[Mint](1, 1, value)\n\nproc merge(a, b: Mat): Mat\
    \ = a * b\n\nvar inputs = newSeq[Mat](100000)\nfor i in 0 ..< inputs.len: inputs[i]\
    \ = make(i)\nvar noise = newSeq[Mat](100000)\nfor i in 0 ..< noise.len: noise[i]\
    \ = make(i + 100000)\nGC_fullCollect()\n\nvar copied = inputs\ncopied[7][0, 0]\
    \ = 9\nvar nested = @[inputs]\nnested[0][8][0, 0] = 10\nGC_fullCollect()\nfor\
    \ i in 0 ..< inputs.len:\n    doAssert inputs[i][0, 0].val == i\n    doAssert\
    \ noise[i][0, 0].val == i + 100000\n    doAssert copied[i][0, 0].val == (if i\
    \ == 7: 9 else: i)\n    doAssert nested[0][i][0, 0].val == (if i == 8: 10 else:\
    \ i)\n\nvar views = newSeq[MutableMatrixRow[Mint]](1000)\nfor i in 0 ..< views.len:\n\
    \    var owner = make(i)\n    views[i] = owner[0]\nGC_fullCollect()\nfor i in\
    \ 0 ..< views.len:\n    doAssert views[i][0].val == i\n    views[i][0] += Mint.init(1)\n\
    GC_fullCollect()\nfor i in 0 ..< views.len: doAssert views[i][0].val == i + 1\n\
    \nlet tree = initSegmentTree(inputs, merge, make(1))\nGC_fullCollect()\ndoAssert\
    \ tree.get(2, 5)[0, 0].val == 24\ntree.update(3, make(7))\nGC_fullCollect()\n\
    doAssert tree.get(2, 5)[0, 0].val == 56\ndoAssert inputs[3][0, 0].val == 3\n\n\
    var empty: Mat\ndoAssert empty.clone().h == 0 and empty.clone().w == 0\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/matrix/matrix_avx2.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/matrix/matrix_avx2_field_impl.nim
  - cplib/collections/segtree.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/modint/modint.nim
  - cplib/collections/segtree.nim
  - cplib/matrix/matrix_avx2.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix_avx2_kernel.nim
  - cplib/matrix/matrix_avx2_kernel.nim
  - cplib/matrix/matrix_avx2_field_impl.nim
  isVerificationFile: true
  path: verify/matrix/matrix_avx2_gc_test.nim
  requiredBy: []
  timestamp: '2026-09-11 02:58:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_avx2_gc_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_avx2_gc_test.nim
- /verify/verify/matrix/matrix_avx2_gc_test.nim.html
title: verify/matrix/matrix_avx2_gc_test.nim
---
