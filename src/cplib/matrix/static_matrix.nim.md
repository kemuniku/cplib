---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_matrix_test.nim
    title: verify/AI/static_matrix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_matrix_test.nim
    title: verify/AI/static_matrix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/static_string/static_matrix_unit_test.nim
    title: verify/matrix/static_string/static_matrix_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/static_string/static_matrix_unit_test.nim
    title: verify/matrix/static_string/static_matrix_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/static_string/static_matrix_zoistring_test.nim
    title: verify/matrix/static_string/static_matrix_zoistring_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/static_string/static_matrix_zoistring_test.nim
    title: verify/matrix/static_string/static_matrix_zoistring_test.nim
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
  code: "when not declared CPLIB_MATRIX_STATIC_MATRIX:\n    const CPLIB_MATRIX_STATIC_MATRIX*\
    \ = 1\n    import sequtils, hashes\n    type StaticMatrix*[H: static int, W: static\
    \ int, T] = object\n        arr: array[H*W,T]\n    type SubArray*[H:static int,W:static\
    \ int,T] = object\n        mat: ref StaticMatrix[H,W,T]\n        idx : int\n \
    \   \n    proc initMatrix*[H:static int,W:static int,T](arr: array[H,array[W,T]]):\
    \ StaticMatrix[H,W,T] =\n        assert arr.len == 0 or arr.mapIt(it.len).allIt(it\
    \ == arr[0].len), \"all elements in arr must be the same size.\"\n        assert\
    \ arr[0].len == W\n        assert arr.len == H\n        var idx = 0\n        for\
    \ i in 0..<H:\n            for j in 0..<W:\n                result.arr[idx] =\
    \ arr[i][j]\n                idx += 1\n\n    proc toMatrix*[H:static int,W:static\
    \ int,T](arr: array[H,array[W,T]]): StaticMatrix[H,W,T] = initMatrix(arr)\n\n\
    \    proc initMatrix*[H: static int, W: static int, T](val: T): StaticMatrix[H,W,T]\
    \ =\n        for i in 0..<H*W:\n            result.arr[i] = val\n\n    proc h*[H:\
    \ static int, W: static int, T](m: StaticMatrix[H,W,T]): int = H\n    proc w*[H:\
    \ static int, W: static int, T](m: StaticMatrix[H,W,T]): int = W\n    proc `$`*[H:\
    \ static int, W: static int, T](m: StaticMatrix[H,W,T]): string =\n        for\
    \ i in 0..<H:\n            for j in 0..<W:\n                if j != 0: result\
    \ &= \" \"\n                result &= $m[i, j]\n            if i != H - 1: result\
    \ &= \"\\n\"\n    proc `==`*[H: static int, W: static int, T](a, b: StaticMatrix[H,W,T]):\
    \ bool = a.arr == b.arr\n    proc `[]`*[H: static int, W: static int, T](m: StaticMatrix[H,W,T],\
    \ r: int): array[W,T] =\n        for j in 0..<W:\n            result[j] = m[r,\
    \ j]\n    proc `[]=`*[H: static int, W: static int, T](m: var StaticMatrix[H,W,T],\
    \ r: int, row: array[W,T]) =\n        for j in 0..<W:\n            m[r, j] = row[j]\n\
    \n    proc `[]`*[H: static int, W: static int, T](m: StaticMatrix[H,W,T], r: int,\
    \ c: int): T = m.arr[r*W+c]\n    proc `[]`*[H: static int, W: static int, T](m:\
    \ var StaticMatrix[H,W,T], r: int, c: int): var T = m.arr[r*W+c]\n    proc `[]=`*[H:\
    \ static int, W: static int, T](m: var StaticMatrix[H,W,T], r: int, c: int, val:\
    \ T) = m.arr[r*W+c] = val\n\n    proc `-`*[H: static int, W: static int, T](m:\
    \ StaticMatrix[H,W,T]): StaticMatrix[H,W,T] =\n        for i in 0..<H*W:\n   \
    \         result.arr[i] = -m.arr[i]\n    proc `*=`*[H: static int, W: static int,\
    \ T](a: var StaticMatrix[H,W,T], b: StaticMatrix[W,W,T]) =\n        assert a.w\
    \ == b.h\n        var ans : StaticMatrix[H,W,T]\n        for i in 0..<a.h:\n \
    \           for j in 0..<b.w:\n                for k in 0..<a.w:\n           \
    \         ans[i, j] += a[i, k] * b[k, j]\n        swap(ans, a)\n    proc `*=`*[H:\
    \ static int, W: static int, T](a: var StaticMatrix[H,W,T], x: T) =\n        for\
    \ i in 0..<a.h:\n            for j in 0..<a.w:\n                a[i, j] *= x\n\
    \    proc `*`*[A: static int, B: static int, C: static int, T](a: StaticMatrix[A,B,T],b:StaticMatrix[B,C,T]):\
    \ StaticMatrix[A,C,T] =\n        for i in 0..<A:\n            for j in 0..<C:\n\
    \                for k in 0..<B:\n                    result[i, j] += a[i, k]\
    \ * b[k, j]\n\n    proc `*`*[H: static int, W: static int, T](a: StaticMatrix[H,W,T],\
    \ x: T): StaticMatrix[H,W,T] = (result = a; result *= x)\n    proc `*`*[H: static\
    \ int, W: static int, T](x: T, a: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] =\
    \ a * x\n    template defineMatrixAssignmentOp(assign, op: untyped) =\n      \
    \  proc assign*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], b:\
    \ StaticMatrix[H,W,T]) =\n            assert a.h == b.h and a.w == b.w\n     \
    \       for i in 0..<a.h:\n                for j in 0..<a.w:\n               \
    \     assign(a[i, j], b[i, j])\n        proc assign*[H: static int, W: static\
    \ int, T](a: var StaticMatrix[H,W,T], x: T) =\n            for i in 0..<a.h:\n\
    \                for j in 0..<a.w:\n                    assign(a[i, j], x)\n \
    \       proc op*[H: static int, W: static int, T](a, b: StaticMatrix[H,W,T]):\
    \ StaticMatrix[H,W,T] = (result = a; assign(result, b))\n        proc op*[H: static\
    \ int, W: static int, T](a: StaticMatrix[H,W,T], x: T): StaticMatrix[H,W,T] =\
    \ (result = a; assign(result, x))\n        proc op*[H: static int, W: static int,\
    \ T](x: T, a: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] = op(a, x)\n    defineMatrixAssignmentOp(`+=`,\
    \ `+`)\n    defineMatrixAssignmentOp(`-=`, `-`)\n\n    template defineMatrixIntOps(assign,\
    \ op: untyped) =\n        proc assign*[H: static int, W: static int](a: var StaticMatrix[H,W,int],\
    \ b: StaticMatrix[H,W,int]) =\n            assert a.h == b.h and a.w == b.w\n\
    \            for i in 0..<a.h:\n                for j in 0..<a.w:\n          \
    \          a[i, j] = op(a[i, j], b[i, j])\n        proc assign*[H: static int,\
    \ W: static int](a: var StaticMatrix[H,W,int], x: int) =\n            for i in\
    \ 0..<a.h:\n                for j in 0..<a.w:\n                    a[i, j] = op(a[i,\
    \ j], x)\n        proc op*[H: static int, W: static int](a, b: StaticMatrix[H,W,int]):\
    \ StaticMatrix[H,W,int] = (result = a; assign(result, b))\n        proc op*[H:\
    \ static int, W: static int](a: StaticMatrix[H,W,int], x: int): StaticMatrix[H,W,int]\
    \ = (result = a; assign(result, x))\n        proc op*[H: static int, W: static\
    \ int](x: int, a: StaticMatrix[H,W,int]): StaticMatrix[H,W,int] = op(a, x)\n \
    \   defineMatrixIntOps(`and=`, `and`)\n    defineMatrixIntOps(`or=`, `or`)\n \
    \   defineMatrixIntOps(`xor=`, `xor`)\n    defineMatrixIntOps(`shl=`, `shl`)\n\
    \    defineMatrixIntOps(`shr=`, `shr`)\n    defineMatrixIntOps(`div=`, `div`)\n\
    \    defineMatrixIntOps(`mod=`, `mod`)\n\n    proc hash*[H: static int, W: static\
    \ int, T](m: StaticMatrix[H,W,T]): Hash = hash(m.arr)\n    proc identity_matrix*[H:\
    \ static int, W: static int, T](n: int, one, zero: T): StaticMatrix[H,W,T] =\n\
    \        assert H == W and n == H\n        for i in 0..<H*W:\n            result.arr[i]\
    \ = zero\n        for i in 0..<H: result[i, i] = one\n    proc identity_matrix*[H:\
    \ static int, W: static int, T](n: int): StaticMatrix[H,W,T] =\n        assert\
    \ H == W and n == H\n        for i in 0..<H: result[i, i] = T(1)\n    proc pow*[H:\
    \ static int, W: static int, T](m: StaticMatrix[H,W,T], n: int): StaticMatrix[H,W,T]\
    \ =\n        assert H == W\n        for i in 0..<H: result[i, i] = T(1)\n    \
    \    var m = m\n        var n = n\n        while n > 0:\n            if (n and\
    \ 1) == 1: result *= m\n            m *= m\n            n = n shr 1\n    proc\
    \ `**`*[H: static int, W: static int, T](m: StaticMatrix[H,W,T], n: int): StaticMatrix[H,W,T]\
    \ = m.pow(n)\n    proc sum*[H: static int, W: static int, T](m: StaticMatrix[H,W,T]):\
    \ T =\n        for i in 0..<H*W:\n            result += m.arr[i]\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/matrix/static_matrix.nim
  requiredBy: []
  timestamp: '2026-05-26 07:51:33+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/static_matrix_test.nim
  - verify/AI/static_matrix_test.nim
  - verify/matrix/static_string/static_matrix_zoistring_test.nim
  - verify/matrix/static_string/static_matrix_zoistring_test.nim
  - verify/matrix/static_string/static_matrix_unit_test.nim
  - verify/matrix/static_string/static_matrix_unit_test.nim
documentation_of: cplib/matrix/static_matrix.nim
layout: document
redirect_from:
- /library/cplib/matrix/static_matrix.nim
- /library/cplib/matrix/static_matrix.nim.html
title: cplib/matrix/static_matrix.nim
---
