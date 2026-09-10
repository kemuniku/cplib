---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
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
    import cplib/modint/modint\nimport cplib/matrix/matrix as plain\nimport cplib/matrix/matrix_avx2\
    \ as avx\nimport cplib/matrix/matrix_product_avx2 as product\nimport random, options\n\
    \nvar rng = initRand(8042026)\n\nproc randomElement[T](): T =\n    let choice\
    \ = rng.rand(3)\n    result = T.init(if choice == 0: 0 elif choice == 1: 1 elif\
    \ choice == 2: T.umod.int-1 else: rng.rand(T.umod.int-1))\n    when T is MontgomeryModint:\n\
    \        if rng.rand(1) == 1:\n            let raw = cast[uint32](result)\n  \
    \          result = cast[T](if raw >= T.umod: raw - T.umod else: raw + T.umod)\n\
    \nproc compareMatrix[T](a: avx.Matrix[T], b: plain.Matrix[T]) =\n    doAssert\
    \ a.h == b.h and a.w == b.w\n    for i in 0..<a.h:\n        for j in 0..<a.w:\
    \ doAssert a[i,j].val == b[i,j].val\n\nproc compareSolution[T](a, b: Option[LinearSystemSolution[T]])\
    \ =\n    doAssert a.isSome == b.isSome\n    if a.isNone: return\n    let x = a.get\n\
    \    let y = b.get\n    doAssert x.particular.len == y.particular.len and x.basis.len\
    \ == y.basis.len\n    for i in 0..<x.particular.len: doAssert x.particular[i].val\
    \ == y.particular[i].val\n    for i in 0..<x.basis.len:\n        for j in 0..<x.particular.len:\
    \ doAssert x.basis[i][j].val == y.basis[i][j].val\n\nproc checkField[T]() =\n\
    \    for n in [0,1,2,7,8,9,15,16,17,31,32,33]:\n        for trial in 0..<4:\n\
    \            var a = avx.initMatrix[T](n,n)\n            var b = plain.initMatrix(n,n,T.init(0))\n\
    \            for i in 0..<n:\n                for j in 0..<n:\n              \
    \      let value = if trial == 0: T.init(0) else: randomElement[T]()\n       \
    \             a[i,j] = value\n                    b[i,j] = value\n           \
    \ if n > 1 and trial == 1:\n                for j in 0..<n:\n                \
    \    a[n-1,j] = a[0,j]\n                    b[n-1,j] = b[0,j]\n            if\
    \ n > 2 and trial == 2:\n                for j in 0..<n:\n                   \
    \ a[n-1,j] = a[0,j]\n                    a[n-2,j] = a[0,j]\n                 \
    \   b[n-1,j] = b[0,j]\n                    b[n-2,j] = b[0,j]\n            let\
    \ saved = a\n            doAssert a.rank == b.rank\n            doAssert a.determinant.val\
    \ == b.determinant.val\n            compareMatrix(a.adjugate,b.adjugate)\n   \
    \         let ai = a.inverse\n            let bi = b.inverse\n            doAssert\
    \ ai.isSome == bi.isSome\n            if ai.isSome: compareMatrix(ai.get,bi.get)\n\
    \            doAssert a == saved\n    for (h,w) in [(0,9),(9,0),(3,65),(65,3),(8,17),(17,8),(31,33),(33,31)]:\n\
    \        for trial in 0..<3:\n            var a = avx.initMatrix[T](h,w)\n   \
    \         var b = plain.initMatrix(h,w,T.init(0))\n            var rhs = newSeq[T](h)\n\
    \            for i in 0..<h:\n                rhs[i] = randomElement[T]()\n  \
    \              for j in 0..<w:\n                    let value = if trial == 0:\
    \ T.init(0) else: randomElement[T]()\n                    a[i,j] = value\n   \
    \                 b[i,j] = value\n            let saved = a\n            doAssert\
    \ a.rank == b.rank\n            compareSolution(a.solveLinearSystem(rhs),b.solveLinearSystem(rhs))\n\
    \            doAssert a == saved\n    for n in [0,2,8,16,18,20]:\n        var\
    \ a = avx.initMatrix[T](n,n)\n        var b = plain.initMatrix(n,n,T.init(0))\n\
    \        for i in 0..<n:\n            a[i,i] = T.init(1)\n            b[i,i] =\
    \ T.init(1)\n            for j in 0..<i:\n                let value = randomElement[T]()\n\
    \                a[i,j] = value\n                a[j,i] = value\n            \
    \    b[i,j] = value\n                b[j,i] = value\n        let saved = a\n \
    \       doAssert a.hafnian.val == b.hafnian.val\n        doAssert a == saved\n\
    \    var a = avx.initMatrix[T](17,17)\n    var b = plain.initMatrix(17,17,T.init(0))\n\
    \    for i in 0..<17:\n        a[i,i] = T.init(1)\n        b[i,i] = T.init(1)\n\
    \        for j in 0..<i:\n            let zero = when T is MontgomeryModint: cast[T](T.umod)\
    \ else: T.init(0)\n            a[i,j] = zero\n            b[i,j] = zero\n    doAssert\
    \ a.rank == 17 and a.determinant.val == 1\n    compareMatrix(a*a,product.matrixProduct(b,b))\n\
    \ncheckField[modint998244353_montgomery]()\ncheckField[modint998244353_barrett]()\n\
    checkField[modint1000000007_montgomery]()\ncheckField[modint1000000007_barrett]()\n\
    for modulus in [3,17,1073741789]:\n    modint_montgomery.setMod(modulus)\n   \
    \ checkField[modint_montgomery]()\n    modint_barrett.setMod(modulus)\n    checkField[modint_barrett]()\n\
    \ntemplate rejects(body: untyped) =\n    block:\n        var raised = false\n\
    \        try: body\n        except AssertionDefect: raised = true\n        doAssert\
    \ raised\n\nmodint_montgomery.setMod(17)\nlet stale = avx.initMatrix[modint_montgomery](2,2)\n\
    modint_montgomery.setMod(19)\nrejects: discard stale.rank\nrejects: discard stale.determinant\n\
    rejects: discard stale.inverse\nrejects: discard stale.adjugate\nrejects: discard\
    \ stale.hafnian\nrejects: discard stale.solveLinearSystem(@[modint_montgomery.init(0),modint_montgomery.init(0)])\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/matrix/matrix_avx2_field_differential_test.nim
  requiredBy: []
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_avx2_field_differential_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_avx2_field_differential_test.nim
- /verify/verify/matrix/matrix_avx2_field_differential_test.nim.html
title: verify/matrix/matrix_avx2_field_differential_test.nim
---
