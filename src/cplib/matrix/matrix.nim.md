---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_dpr_test.nim
    title: verify/matrix/matrix_dpr_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_dpr_test.nim
    title: verify/matrix/matrix_dpr_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_pow_test.nim
    title: verify/matrix/matrix_pow_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_pow_test.nim
    title: verify/matrix/matrix_pow_test.nim
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
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/dpr_dynamic_test.nim
    title: verify/modint/barrett/dpr_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/dpr_dynamic_test.nim
    title: verify/modint/barrett/dpr_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/dpr_static_test.nim
    title: verify/modint/barrett/dpr_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/dpr_static_test.nim
    title: verify/modint/barrett/dpr_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/dpr_dynamic_test.nim
    title: verify/modint/montgomery/dpr_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/dpr_dynamic_test.nim
    title: verify/modint/montgomery/dpr_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/dpr_static_test.nim
    title: verify/modint/montgomery/dpr_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/dpr_static_test.nim
    title: verify/modint/montgomery/dpr_static_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATRIX_MATRIX:\n    const CPLIB_MATRIX_MATRIX* =\
    \ 1\n    import sequtils, strutils, hashes, std/math\n    type Matrix*[T] = object\n\
    \        arr: seq[seq[T]]\n    proc initMatrix*[T](arr: seq[seq[T]]): Matrix[T]\
    \ =\n        assert arr.len == 0 or arr.mapIt(it.len).allIt(it == arr[0].len),\
    \ \"all elements in arr must be the same size.\"\n        Matrix[T](arr: arr)\n\
    \    proc toMatrix*[T](arr: seq[seq[T]]): Matrix[T] = initMatrix(arr)\n    proc\
    \ initMatrix*[T](arr: seq[T], vertical: bool = false): Matrix[T] =\n        if\
    \ vertical: Matrix[T](arr: arr.mapIt(@[it]))\n        else: Matrix[T](arr: @[arr])\n\
    \    proc initMatrix*[T](h, w: int, val: T): Matrix[T] = Matrix[T](arr: newSeqWith(h,\
    \ newSeqWith(w, val)))\n\n    proc h*[T](m: Matrix[T]): int = m.arr.len\n    proc\
    \ w*[T](m: Matrix[T]): int =\n        if m.h == 0: return 0\n        m.arr[0].len\n\
    \    proc `$`*[T](m: Matrix[T]): string =\n        for i in 0..<m.arr.len:\n \
    \           result &= m.arr[i].mapIt($it).join(\" \")\n            if i != m.arr.len\
    \ - 1: result &= \"\\n\"\n    proc `==`*[T](a, b: Matrix[T]): bool = a.arr ==\
    \ b.arr\n    proc `[]`*[T](m: Matrix[T], r: int): seq[T] = m.arr[r]\n    proc\
    \ `[]`*[T](m: var Matrix[T], r: int): var seq[T] = m.arr[r]\n    proc `[]=`*[T](m:\
    \ var Matrix[T], r: int, row: seq[T]) = m.arr[r] = row\n\n    proc `[]`*[T](m:\
    \ Matrix[T], r: int, c: int): T = m.arr[r][c]\n    proc `[]`*[T](m: var Matrix[T],\
    \ r: int, c: int): var T = m.arr[r][c]\n    proc `[]=`*[T](m: var Matrix[T], r:\
    \ int, c: int, val: T) = m.arr[r][c] = val\n\n    proc `-`*[T](m: Matrix[T]):\
    \ Matrix[T] = Matrix[T](arr: m.arr.mapIt(it.mapIt(-it)))\n    proc `*=`*[T](a:\
    \ var Matrix[T], b: Matrix[T]) =\n        assert a.w == b.h\n        var ans =\
    \ initMatrix[T](a.h, b.w, 0)\n        for i in 0..<a.h:\n            for j in\
    \ 0..<b.w:\n                for k in 0..<a.w:\n                    ans[i, j] +=\
    \ a[i, k] * b[k, j]\n        swap(ans, a)\n    proc `*=`*[T](a: var Matrix[T],\
    \ x: T) =\n        for i in 0..<a.h:\n            for j in 0..<a.w:\n        \
    \        a[i, j] *= x\n    proc `*`*[T](a, b: Matrix[T]): Matrix[T] = (result\
    \ = a; result *= b)\n    proc `*`*[T](a: Matrix[T], x: T): Matrix[T] = (result\
    \ = a; result *= x)\n    proc `*`*[T](x: T, a: Matrix[T]): Matrix[T] = a * x\n\
    \    template defineMatrixAssignmentOp(assign, op: untyped) =\n        proc assign*[T](a:\
    \ var Matrix[T], b: Matrix[T]) =\n            assert a.h == b.h and a.w == b.w\n\
    \            for i in 0..<a.h:\n                for j in 0..<a.w:\n          \
    \          assign(a[i, j], b[i, j])\n        proc assign*[T](a: var Matrix[T],\
    \ x: T) =\n            for i in 0..<a.h:\n                for j in 0..<a.w:\n\
    \                    assign(a[i, j], x)\n        proc op*[T](a, b: Matrix[T]):\
    \ Matrix[T] = (result = a; assign(result, b))\n        proc op*[T](a: Matrix[T],\
    \ x: T): Matrix[T] = (result = a; assign(result, x))\n        proc op*[T](x: T,\
    \ a: Matrix[T]): Matrix[T] = op(a, x)\n    defineMatrixAssignmentOp(`+=`, `+`)\n\
    \    defineMatrixAssignmentOp(`-=`, `-`)\n\n    template defineMatrixIntOps(assign,\
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
    \    proc sum*[T](m: Matrix[T]): T = m.arr.mapit(it.sum).sum\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/matrix/matrix.nim
  requiredBy: []
  timestamp: '2024-03-28 20:50:59+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/modint/montgomery/dpr_dynamic_test.nim
  - verify/modint/montgomery/dpr_dynamic_test.nim
  - verify/modint/montgomery/dpr_static_test.nim
  - verify/modint/montgomery/dpr_static_test.nim
  - verify/modint/barrett/dpr_dynamic_test.nim
  - verify/modint/barrett/dpr_dynamic_test.nim
  - verify/modint/barrett/dpr_static_test.nim
  - verify/modint/barrett/dpr_static_test.nim
  - verify/matrix/matrix_pow_test.nim
  - verify/matrix/matrix_pow_test.nim
  - verify/matrix/matrix_unit_test.nim
  - verify/matrix/matrix_unit_test.nim
  - verify/matrix/matrix_zoistring_test.nim
  - verify/matrix/matrix_zoistring_test.nim
  - verify/matrix/matrix_product_test.nim
  - verify/matrix/matrix_product_test.nim
  - verify/matrix/matrix_dpr_test.nim
  - verify/matrix/matrix_dpr_test.nim
documentation_of: cplib/matrix/matrix.nim
layout: document
redirect_from:
- /library/cplib/matrix/matrix.nim
- /library/cplib/matrix/matrix.nim.html
title: cplib/matrix/matrix.nim
---
