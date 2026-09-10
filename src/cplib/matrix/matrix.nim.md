---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_product_avx2.nim
    title: cplib/matrix/matrix_product_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_product_avx2.nim
    title: cplib/matrix/matrix_product_avx2.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/field_algorithms_unit.nim
    title: verify/matrix/linear_algebra/field_algorithms_unit.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/field_algorithms_unit.nim
    title: verify/matrix/linear_algebra/field_algorithms_unit.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/judge_driver.nim
    title: verify/matrix/linear_algebra/judge_driver.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/judge_driver.nim
    title: verify/matrix/linear_algebra/judge_driver.nim
  - icon: ':warning:'
    path: verify/matrix/matrix_dpr_test_.nim
    title: verify/matrix/matrix_dpr_test_.nim
  - icon: ':warning:'
    path: verify/matrix/matrix_dpr_test_.nim
    title: verify/matrix/matrix_dpr_test_.nim
  - icon: ':warning:'
    path: verify/modint/barrett/dpr_dynamic_test_.nim
    title: verify/modint/barrett/dpr_dynamic_test_.nim
  - icon: ':warning:'
    path: verify/modint/barrett/dpr_dynamic_test_.nim
    title: verify/modint/barrett/dpr_dynamic_test_.nim
  - icon: ':warning:'
    path: verify/modint/barrett/dpr_static_test_.nim
    title: verify/modint/barrett/dpr_static_test_.nim
  - icon: ':warning:'
    path: verify/modint/barrett/dpr_static_test_.nim
    title: verify/modint/barrett/dpr_static_test_.nim
  - icon: ':warning:'
    path: verify/modint/montgomery/dpr_dynamic_test_.nim
    title: verify/modint/montgomery/dpr_dynamic_test_.nim
  - icon: ':warning:'
    path: verify/modint/montgomery/dpr_dynamic_test_.nim
    title: verify/modint/montgomery/dpr_dynamic_test_.nim
  - icon: ':warning:'
    path: verify/modint/montgomery/dpr_static_test_.nim
    title: verify/modint/montgomery/dpr_static_test_.nim
  - icon: ':warning:'
    path: verify/modint/montgomery/dpr_static_test_.nim
    title: verify/modint/montgomery/dpr_static_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/matrix_test.nim
    title: verify/AI/matrix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/matrix_test.nim
    title: verify/AI/matrix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_pow_test.nim
    title: verify/matrix/matrix_pow_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_pow_test.nim
    title: verify/matrix/matrix_pow_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_avx2_test.nim
    title: verify/matrix/matrix_product_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_avx2_test.nim
    title: verify/matrix/matrix_product_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_avx2_unit_test.nim
    title: verify/matrix/matrix_product_avx2_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_avx2_unit_test.nim
    title: verify/matrix/matrix_product_avx2_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_test.nim
    title: verify/matrix/matrix_product_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_test.nim
    title: verify/matrix/matrix_product_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_unit_test.nim
    title: verify/matrix/matrix_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_unit_test.nim
    title: verify/matrix/matrix_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_zoistring_test.nim
    title: verify/matrix/matrix_zoistring_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_zoistring_test.nim
    title: verify/matrix/matrix_zoistring_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATRIX_MATRIX:\n    const CPLIB_MATRIX_MATRIX* =\
    \ 1\n    import sequtils, strutils, hashes, std/math\n    type Matrix*[T] = object\n\
    \        arr: seq[seq[T]]\n        emptyWidth: int\n    proc initMatrix*[T](arr:\
    \ openArray[seq[T]]): Matrix[T] =\n        assert arr.len == 0 or arr.mapIt(it.len).allIt(it\
    \ == arr[0].len), \"all elements in arr must be the same size.\"\n        Matrix[T](arr:\
    \ @arr)\n    proc toMatrix*[T](arr: openArray[seq[T]]): Matrix[T] = initMatrix(arr)\n\
    \    proc initMatrix*[T](arr: openArray[T], vertical: bool = false): Matrix[T]\
    \ =\n        if vertical: Matrix[T](arr: arr.mapIt(@[it]), emptyWidth: 1)\n  \
    \      else: Matrix[T](arr: @[@arr])\n    proc initMatrix*[T](h, w: int, val:\
    \ T): Matrix[T] = Matrix[T](arr: newSeqWith(h, newSeqWith(w, val)), emptyWidth:\
    \ w)\n\n    proc h*[T](m: Matrix[T]): int = m.arr.len\n    proc w*[T](m: Matrix[T]):\
    \ int =\n        if m.h == 0: return m.emptyWidth\n        m.arr[0].len\n    proc\
    \ `$`*[T](m: Matrix[T]): string =\n        for i in 0..<m.arr.len:\n         \
    \   result &= m.arr[i].mapIt($it).join(\" \")\n            if i != m.arr.len -\
    \ 1: result &= \"\\n\"\n    proc `==`*[T](a, b: Matrix[T]): bool = a.h == b.h\
    \ and a.w == b.w and a.arr == b.arr\n    proc `[]`*[T](m: Matrix[T], r: int):\
    \ seq[T] = m.arr[r]\n    proc `[]`*[T](m: var Matrix[T], r: int): var seq[T] =\
    \ m.arr[r]\n    proc `[]=`*[T](m: var Matrix[T], r: int, row: openArray[T]) =\
    \ m.arr[r] = @row\n\n    proc `[]`*[T](m: Matrix[T], r: int, c: int): T = m.arr[r][c]\n\
    \    proc `[]`*[T](m: var Matrix[T], r: int, c: int): var T = m.arr[r][c]\n  \
    \  proc `[]=`*[T](m: var Matrix[T], r: int, c: int, val: T) = m.arr[r][c] = val\n\
    \n    proc `-`*[T](m: Matrix[T]): Matrix[T] = Matrix[T](arr: m.arr.mapIt(it.mapIt(-it)),\
    \ emptyWidth: m.emptyWidth)\n    proc `*=`*[T](a: var Matrix[T], b: Matrix[T])\
    \ =\n        assert a.w == b.h\n        var ans = initMatrix[T](a.h, b.w, 0)\n\
    \        for i in 0..<a.h:\n            for j in 0..<b.w:\n                for\
    \ k in 0..<a.w:\n                    ans[i, j] += a[i, k] * b[k, j]\n        swap(ans,\
    \ a)\n    proc `*=`*[T](a: var Matrix[T], x: T) =\n        for i in 0..<a.h:\n\
    \            for j in 0..<a.w:\n                a[i, j] *= x\n    proc `*`*[T](a,\
    \ b: Matrix[T]): Matrix[T] = (result = a; result *= b)\n    proc `*`*[T](a: Matrix[T],\
    \ x: T): Matrix[T] = (result = a; result *= x)\n    proc `*`*[T](x: T, a: Matrix[T]):\
    \ Matrix[T] = a * x\n    template defineMatrixAssignmentOp(assign, op: untyped)\
    \ =\n        proc assign*[T](a: var Matrix[T], b: Matrix[T]) =\n            assert\
    \ a.h == b.h and a.w == b.w\n            for i in 0..<a.h:\n                for\
    \ j in 0..<a.w:\n                    assign(a[i, j], b[i, j])\n        proc assign*[T](a:\
    \ var Matrix[T], x: T) =\n            for i in 0..<a.h:\n                for j\
    \ in 0..<a.w:\n                    assign(a[i, j], x)\n        proc op*[T](a,\
    \ b: Matrix[T]): Matrix[T] = (result = a; assign(result, b))\n        proc op*[T](a:\
    \ Matrix[T], x: T): Matrix[T] = (result = a; assign(result, x))\n        proc\
    \ op*[T](x: T, a: Matrix[T]): Matrix[T] = op(a, x)\n    defineMatrixAssignmentOp(`+=`,\
    \ `+`)\n    defineMatrixAssignmentOp(`-=`, `-`)\n\n    template defineMatrixIntOps(assign,\
    \ op: untyped) =\n        proc assign*(a: var Matrix[int], b: Matrix[int]) =\n\
    \            assert a.h == b.h and a.w == b.w\n            for i in 0..<a.h:\n\
    \                for j in 0..<a.w:\n                    a[i, j] = op(a[i, j],\
    \ b[i, j])\n        proc assign*(a: var Matrix[int], x: int) =\n            for\
    \ i in 0..<a.h:\n                for j in 0..<a.w:\n                    a[i, j]\
    \ = op(a[i, j], x)\n        proc op*(a, b: Matrix[int]): Matrix[int] = (result\
    \ = a; assign(result, b))\n        proc op*(a: Matrix[int], x: int): Matrix[int]\
    \ = (result = a; assign(result, x))\n        proc op*(x: int, a: Matrix[int]):\
    \ Matrix[int] = op(a, x)\n    defineMatrixIntOps(`and=`, `and`)\n    defineMatrixIntOps(`or=`,\
    \ `or`)\n    defineMatrixIntOps(`xor=`, `xor`)\n    defineMatrixIntOps(`shl=`,\
    \ `shl`)\n    defineMatrixIntOps(`shr=`, `shr`)\n    defineMatrixIntOps(`div=`,\
    \ `div`)\n    defineMatrixIntOps(`mod=`, `mod`)\n\n    proc hash*[T](m: Matrix[T]):\
    \ Hash = hash(m.arr)\n    proc identity_matrix*[T](n: int, one, zero: T): Matrix[T]\
    \ =\n        result = initMatrix[T](n, n, zero)\n        for i in 0..<n: result[i][i]\
    \ = one\n    proc identity_matrix*[T](n: int): Matrix[T] = identity_matrix[T](n,\
    \ 1, 0)\n    proc pow*[T](m: Matrix[T], n: int): Matrix[T] =\n        result =\
    \ identity_matrix[T](m.h)\n        var m = m\n        var n = n\n        while\
    \ n > 0:\n            if (n and 1) == 1: result *= m\n            m *= m\n   \
    \         n = n shr 1\n    proc `**`*[T](m: Matrix[T], n: int): Matrix[T] = m.pow(n)\n\
    \    proc sum*[T](m: Matrix[T]): T = m.arr.mapit(it.sum).sum\n\n    import options\n\
    \    import cplib/matrix/field_matrix_ops\n    export LinearSystemSolution\n\n\
    \    proc rank*[T](a: Matrix[T]): int =\n        ## \u968E\u6570\u3092\u6C42\u3081\
    \u308B\u3002O(h*w*min(h,w))\u3002\n        fieldRank(matrixRows(a, a.h, a.w),\
    \ a.w)\n\n    proc determinant*[T](a: Matrix[T]): T =\n        ## \u884C\u5217\
    \u5F0F\u3092\u6C42\u3081\u308B\u3002\u7A7A\u884C\u5217\u306F1\u3002O(n^3)\u3002\
    \n        assert a.h == a.w\n        fieldDeterminant(matrixRows(a, a.h, a.h))\n\
    \n    proc hafnian*[T](a: Matrix[T]): T =\n        ## \u5BFE\u79F0\u306A\u5076\
    \u6570\u6B21\u884C\u5217\u306Ehafnian\u3092\u6C42\u3081\u308B\u3002O(n^2*2^(n/2))\u3002\
    \n        assert a.h == a.w\n        fieldHafnian(matrixRows(a, a.h, a.h))\n\n\
    \    proc solveLinearSystem*[T](a: Matrix[T], b: openArray[T]): Option[LinearSystemSolution[T]]\
    \ =\n        ## Ax=b\u306E\u7279\u6B8A\u89E3\u3068\u6838\u306E\u57FA\u5E95\u3092\
    \u8FD4\u3059\u3002\u89E3\u306A\u3057\u306Fnone\u3002\u6D88\u53BB\u3068\u5F8C\u9000\
    \u4EE3\u5165\u3092\u884C\u3046\u3002\n        fieldSolve(matrixRows(a, a.h, a.w),\
    \ a.w, b)\n\n    proc inverse*[T](a: Matrix[T]): Option[Matrix[T]] =\n       \
    \ ## \u9006\u884C\u5217\u3092\u8FD4\u3059\u3002\u7279\u7570\u884C\u5217\u306F\
    none\u3002O(n^3)\u3002\n        bind initMatrix\n        assert a.h == a.w\n \
    \       let rows = fieldAdjugateInverse(matrixRows(a, a.h, a.h), false)\n    \
    \    if rows.isNone: return none(Matrix[T])\n        var answer = initMatrix(a.h,\
    \ a.h, T(0))\n        for i in 0..<a.h:\n            for j in 0..<a.h: answer[i,\
    \ j] = rows.get[i][j]\n        some(answer)\n\n    proc adjugate*[T](a: Matrix[T]):\
    \ Matrix[T] =\n        ## \u7279\u7570\u884C\u5217\u3092\u542B\u3080\u4F59\u56E0\
    \u5B50\u884C\u5217\u3092\u8FD4\u3059\u3002O(n^3)\u3002\n        bind initMatrix\n\
    \        assert a.h == a.w\n        let rows = fieldAdjugateInverse(matrixRows(a,\
    \ a.h, a.h), true)\n        var answer = initMatrix(a.h, a.h, T(0))\n        for\
    \ i in 0..<a.h:\n            for j in 0..<a.h: answer[i, j] = rows.get[i][j]\n\
    \        answer\n"
  dependsOn:
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  isVerificationFile: false
  path: cplib/matrix/matrix.nim
  requiredBy:
  - verify/modint/barrett/dpr_dynamic_test_.nim
  - verify/modint/barrett/dpr_dynamic_test_.nim
  - verify/modint/barrett/dpr_static_test_.nim
  - verify/modint/barrett/dpr_static_test_.nim
  - verify/modint/montgomery/dpr_dynamic_test_.nim
  - verify/modint/montgomery/dpr_dynamic_test_.nim
  - verify/modint/montgomery/dpr_static_test_.nim
  - verify/modint/montgomery/dpr_static_test_.nim
  - verify/matrix/matrix_dpr_test_.nim
  - verify/matrix/matrix_dpr_test_.nim
  - verify/matrix/linear_algebra/field_algorithms_unit.nim
  - verify/matrix/linear_algebra/field_algorithms_unit.nim
  - verify/matrix/linear_algebra/judge_driver.nim
  - verify/matrix/linear_algebra/judge_driver.nim
  - cplib/matrix/matrix_product_avx2.nim
  - cplib/matrix/matrix_product_avx2.nim
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/matrix_test.nim
  - verify/AI/matrix_test.nim
  - verify/matrix/matrix_unit_test.nim
  - verify/matrix/matrix_unit_test.nim
  - verify/matrix/matrix_product_test.nim
  - verify/matrix/matrix_product_test.nim
  - verify/matrix/matrix_product_avx2_unit_test.nim
  - verify/matrix/matrix_product_avx2_unit_test.nim
  - verify/matrix/matrix_zoistring_test.nim
  - verify/matrix/matrix_zoistring_test.nim
  - verify/matrix/matrix_product_avx2_test.nim
  - verify/matrix/matrix_product_avx2_test.nim
  - verify/matrix/matrix_pow_test.nim
  - verify/matrix/matrix_pow_test.nim
documentation_of: cplib/matrix/matrix.nim
layout: document
redirect_from:
- /library/cplib/matrix/matrix.nim
- /library/cplib/matrix/matrix.nim.html
title: cplib/matrix/matrix.nim
---
