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
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
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
    path: cplib/matrix/static_matrix.nim
    title: cplib/matrix/static_matrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/static_matrix.nim
    title: cplib/matrix/static_matrix.nim
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
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "import cplib/modint/modint\nimport options, random, sequtils\nwhen defined(testStaticMatrix):\n\
    \    import cplib/matrix/static_matrix\nelif defined(testAvxMatrix):\n    import\
    \ cplib/matrix/matrix_avx2\nelse:\n    import cplib/matrix/matrix\n\ntype Mint\
    \ = modint998244353_montgomery\n\nproc bruteDet(a: seq[seq[Mint]]): Mint =\n \
    \   if a.len == 0: return Mint(1)\n    for col in 0..<a.len:\n        var minor:\
    \ seq[seq[Mint]]\n        for i in 1..<a.len:\n            var row: seq[Mint]\n\
    \            for j in 0..<a.len:\n                if j != col: row.add(a[i][j])\n\
    \            minor.add(row)\n        if col mod 2 == 0: result += a[0][col]*bruteDet(minor)\n\
    \        else: result -= a[0][col]*bruteDet(minor)\n\nproc bruteHaf(a: seq[seq[Mint]],\
    \ vertices: seq[int]): Mint =\n    if vertices.len == 0: return Mint(1)\n    for\
    \ k in 1..<vertices.len:\n        var rest: seq[int]\n        for i in 1..<vertices.len:\n\
    \            if i != k: rest.add(vertices[i])\n        result += a[vertices[0]][vertices[k]]*bruteHaf(a,\
    \ rest)\n\nproc checkSquare[N: static int](rng: var Rand) =\n    for trial in\
    \ 0..<50:\n        var rows = newSeqWith(N, newSeq[Mint](N))\n        for i in\
    \ 0..<N:\n            for j in 0..<N: rows[i][j] = Mint(rng.rand(4))\n       \
    \ if trial mod 3 == 0 and N > 1: rows[N-1] = rows[0]\n        when defined(testStaticMatrix):\n\
    \            var a: StaticMatrix[N,N,Mint]\n        else:\n            var a =\
    \ initMatrix(N,N,Mint(0))\n        for i in 0..<N:\n            for j in 0..<N:\
    \ a[i,j] = rows[i][j]\n        let before = a\n        let det = bruteDet(rows)\n\
    \        doAssert a.determinant.val == det.val\n        let adj = a.adjugate\n\
    \        for i in 0..<N:\n            for j in 0..<N:\n                var minor:\
    \ seq[seq[Mint]]\n                for r in 0..<N:\n                    if r ==\
    \ j: continue\n                    var row: seq[Mint]\n                    for\
    \ c in 0..<N:\n                        if c != i: row.add(rows[r][c])\n      \
    \              minor.add(row)\n                var expected = bruteDet(minor)\n\
    \                if (i+j) mod 2 != 0: expected = -expected\n                doAssert\
    \ adj[i,j].val == expected.val, $N & \" \" & $trial & \" \" & $rows & \" at \"\
    \ & $i & \",\" & $j & \" actual=\" & $adj[i,j] & \" expected=\" & $expected\n\
    \        let inv = a.inverse\n        doAssert inv.isSome == (det.val != 0)\n\
    \        if inv.isSome:\n            for i in 0..<N:\n                for j in\
    \ 0..<N:\n                    var v = Mint(0)\n                    for k in 0..<N:\
    \ v += a[i,k]*inv.get[k,j]\n                    doAssert v.val == int(i==j)\n\
    \        doAssert a == before\n        when N mod 2 == 0:\n            for i in\
    \ 0..<N:\n                for j in 0..<i:\n                    rows[j][i] = rows[i][j]\n\
    \                    a[j,i] = rows[i][j]\n            doAssert a.hafnian.val ==\
    \ bruteHaf(rows, toSeq(0..<N)).val\n\nproc checkRect[H: static int, W: static\
    \ int](rng: var Rand) =\n    for trial in 0..<80:\n        when defined(testStaticMatrix):\n\
    \            var a: StaticMatrix[H,W,Mint]\n        else:\n            var a =\
    \ initMatrix(H,W,Mint(0))\n        var b = newSeq[Mint](H)\n        var known\
    \ = newSeq[Mint](W)\n        for j in 0..<W: known[j] = Mint(rng.rand(3))\n  \
    \      for i in 0..<H:\n            for j in 0..<W:\n                a[i,j] =\
    \ Mint(rng.rand(2))\n                b[i] += a[i,j]*known[j]\n        if trial\
    \ mod 3 == 0 and H > 0: b[H-1] += 1\n        let before = a\n        let answer\
    \ = a.solveLinearSystem(b)\n        let rank = a.rank\n        if answer.isSome:\n\
    \            let s = answer.get\n            doAssert s.particular.len == W\n\
    \            doAssert s.basis.len == W-rank\n            for i in 0..<H:\n   \
    \             var value = Mint(0)\n                for j in 0..<W: value += a[i,j]*s.particular[j]\n\
    \                doAssert value.val == b[i].val\n                for v in s.basis:\n\
    \                    value = Mint(0)\n                    for j in 0..<W: value\
    \ += a[i,j]*v[j]\n                    doAssert value.val == 0\n            var\
    \ leaders: seq[int]\n            for v in s.basis:\n                var last =\
    \ -1\n                for j in 0..<W:\n                    if v[j].val != 0: last\
    \ = j\n                doAssert last >= 0 and last notin leaders\n           \
    \     leaders.add(last)\n        else:\n            doAssert trial mod 3 == 0\
    \ and H > 0\n        doAssert a == before\n\nvar rng = initRand(123456)\ncheckSquare[0](rng)\n\
    checkSquare[1](rng)\ncheckSquare[2](rng)\ncheckSquare[3](rng)\ncheckSquare[4](rng)\n\
    checkSquare[5](rng)\ncheckSquare[6](rng)\ncheckRect[0,0](rng)\ncheckRect[0,3](rng)\n\
    checkRect[3,0](rng)\ncheckRect[2,4](rng)\ncheckRect[4,2](rng)\ncheckRect[4,4](rng)\n\
    template checkOtherField(T: typedesc) =\n    block:\n        when defined(testStaticMatrix):\n\
    \            var a: StaticMatrix[2,2,T]\n        else:\n            var a = initMatrix(2,2,T(0))\n\
    \        a[0,0] = T(2)\n        a[0,1] = T(3)\n        a[1,0] = T(3)\n       \
    \ a[1,1] = T(4)\n        doAssert a.determinant.val == T(-1).val\n        doAssert\
    \ a.rank == 2\n        doAssert a.inverse.get[0,0].val == T(-4).val\n        doAssert\
    \ a.adjugate[0,1].val == T(-3).val\n        doAssert a.hafnian.val == T(3).val\n\
    \        let solution = a.solveLinearSystem(@[T(5),T(7)]).get\n        doAssert\
    \ solution.basis.len == 0\n        doAssert solution.particular[0].val == T(1).val\n\
    \        doAssert solution.particular[1].val == T(1).val\n        a[1,0] = T(2)+T(7)-T(7)\n\
    \        a[1,1] = T(3)\n        doAssert a.rank == 1\n        doAssert a.determinant.val\
    \ == 0\n        doAssert a.inverse.isNone\n        doAssert a.solveLinearSystem(@[T(0),T(1)]).isNone\n\
    \        doAssert a.adjugate[1,0].val == T(-2).val\n\ncheckOtherField(modint998244353_barrett)\n\
    modint_montgomery.setMod(17)\ncheckOtherField(modint_montgomery)\nmodint_barrett.setMod(17)\n\
    checkOtherField(modint_barrett)\nwhen not defined(testAvxMatrix):\n    modint_barrett.setMod(2)\n\
    \    checkOtherField(modint_barrett)\nwhen defined(testStaticMatrix):\n    var\
    \ padded: StaticMatrix[5,6,Mint]\n    padded[0,1] = Mint(2)\n    padded[1,0] =\
    \ Mint(3)\n    padded[4,5] = Mint(123)\n    doAssert padded.rank(2,3) == 2\n \
    \   doAssert padded.determinant(2).val == Mint(-6).val\n    doAssert padded.inverse(2).get[4,5].val\
    \ == 0\n    doAssert padded.adjugate(2)[4,5].val == 0\n    doAssert padded.solveLinearSystem(@[Mint(0),Mint(0)],2,3).get.basis.len\
    \ == 1\nelse:\n    let empty = initMatrix(0,3,Mint(0))\n    doAssert (-empty).w\
    \ == 3\n    doAssert empty != initMatrix(0,2,Mint(0))\necho \"Hello World\"\n"
  dependsOn:
  - cplib/matrix/static_matrix.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/matrix/static_matrix.nim
  - cplib/matrix/matrix_avx2_kernel.nim
  - cplib/modint/modint.nim
  - cplib/matrix/matrix_avx2_kernel.nim
  - cplib/matrix/matrix_avx2_field_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix_avx2_field_impl.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix_avx2.nim
  - cplib/matrix/matrix_avx2.nim
  - cplib/matrix/matrix.nim
  - cplib/modint/barrett_impl.nim
  - cplib/matrix/matrix.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: false
  path: verify/matrix/linear_algebra/field_algorithms_unit.nim
  requiredBy: []
  timestamp: '2026-09-11 02:58:09+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/matrix/linear_algebra/field_algorithms_unit.nim
layout: document
redirect_from:
- /library/verify/matrix/linear_algebra/field_algorithms_unit.nim
- /library/verify/matrix/linear_algebra/field_algorithms_unit.nim.html
title: verify/matrix/linear_algebra/field_algorithms_unit.nim
---
