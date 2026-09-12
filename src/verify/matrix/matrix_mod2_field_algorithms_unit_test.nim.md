---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/bit_matrix_ops.nim
    title: cplib/matrix/bit_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/bit_matrix_ops.nim
    title: cplib/matrix/bit_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_mod2.nim
    title: cplib/matrix/matrix_mod2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_mod2.nim
    title: cplib/matrix/matrix_mod2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/static_matrix_mod2.nim
    title: cplib/matrix/static_matrix_mod2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/static_matrix_mod2.nim
    title: cplib/matrix/static_matrix_mod2.nim
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
    import cplib/matrix/matrix_mod2\nimport cplib/matrix/static_matrix_mod2\nimport\
    \ options, random, sequtils\n\nproc bruteDet(a: seq[seq[bool]]): bool =\n    if\
    \ a.len == 0: return true\n    for j in 0..<a.len:\n        var minor: seq[seq[bool]]\n\
    \        for r in 1..<a.len:\n            var row: seq[bool]\n            for\
    \ c in 0..<a.len:\n                if c != j: row.add(a[r][c])\n            minor.add(row)\n\
    \        result = result xor (a[0][j] and bruteDet(minor))\n\nproc bruteHaf(a:\
    \ seq[seq[bool]], vertices: seq[int]): bool =\n    if vertices.len == 0: return\
    \ true\n    for k in 1..<vertices.len:\n        var rest: seq[int]\n        for\
    \ i in 1..<vertices.len:\n            if i != k: rest.add(vertices[i])\n     \
    \   result = result xor (a[vertices[0]][vertices[k]] and bruteHaf(a,rest))\n\n\
    proc check[N: static int](rng: var Rand) =\n    for trial in 0..<100:\n      \
    \  var a = initMatrixMod2(N,N)\n        var s: StaticMatrixMod2[N,N]\n       \
    \ var rows = newSeqWith(N,newSeq[bool](N))\n        for i in 0..<N:\n        \
    \    for j in 0..<N:\n                rows[i][j] = rng.rand(1) == 1\n        \
    \        a[i,j] = rows[i][j]\n                s[i,j] = rows[i][j]\n        let\
    \ before = a\n        let adj = a.adjugate\n        let sadj = s.adjugate\n  \
    \      doAssert a.determinant == bruteDet(rows)\n        doAssert s.determinant\
    \ == a.determinant\n        for i in 0..<N:\n            for j in 0..<N:\n   \
    \             var minor: seq[seq[bool]]\n                for r in 0..<N:\n   \
    \                 if r == j: continue\n                    var row: seq[bool]\n\
    \                    for c in 0..<N:\n                        if c != i: row.add(rows[r][c])\n\
    \                    minor.add(row)\n                doAssert adj[i,j] == bruteDet(minor)\n\
    \                doAssert sadj[i,j] == adj[i,j]\n        var b = newSeq[bool](N)\n\
    \        for i in 0..<N: b[i] = rng.rand(1) == 1\n        let answer = a.solveLinearSystem(b)\n\
    \        doAssert answer == s.solveLinearSystem(b)\n        var count = 0\n  \
    \      for mask in 0..<(1 shl N):\n            var valid = true\n            for\
    \ i in 0..<N:\n                var value = false\n                for j in 0..<N:\
    \ value = value xor (a[i,j] and ((mask shr j) and 1) != 0)\n                if\
    \ value != b[i]: valid = false\n            if valid: inc count\n        doAssert\
    \ answer.isSome == (count > 0)\n        if answer.isSome:\n            let solution\
    \ = answer.get\n            doAssert count == 1 shl solution.basis.len\n     \
    \       var represented: seq[int]\n            for mask in 0..<(1 shl solution.basis.len):\n\
    \                var vector = solution.particular\n                for k,v in\
    \ solution.basis:\n                    if ((mask shr k) and 1) != 0:\n       \
    \                 for j in 0..<N: vector[j] = vector[j] xor v[j]\n           \
    \     var bits = 0\n                for j in 0..<N:\n                    if vector[j]:\
    \ bits = bits or (1 shl j)\n                doAssert bits notin represented\n\
    \                represented.add(bits)\n                for i in 0..<N:\n    \
    \                var value = false\n                    for j in 0..<N: value\
    \ = value xor (a[i,j] and vector[j])\n                    doAssert value == b[i]\n\
    \        doAssert a == before\n        when N mod 2 == 0:\n            for i in\
    \ 0..<N:\n                for j in 0..<i:\n                    rows[j][i] = rows[i][j]\n\
    \                    a[j,i] = rows[i][j]\n                    s[j,i] = rows[i][j]\n\
    \            doAssert a.hafnian == bruteHaf(rows,toSeq(0..<N))\n            doAssert\
    \ s.hafnian == a.hafnian\nvar rng = initRand(234)\ncheck[0](rng)\ncheck[1](rng)\n\
    check[2](rng)\ncheck[3](rng)\ncheck[4](rng)\ncheck[6](rng)\nlet empty = initMatrixMod2(0,5).solveLinearSystem(newSeq[bool]()).get\n\
    doAssert empty.particular.len == 5 and empty.basis.len == 5\ndoAssert initMatrixMod2(2,0).solveLinearSystem(@[false,true]).isNone\n\
    import cplib/matrix/field_matrix_ops\nfor (h, w) in [(0,0), (0,65), (65,0), (1,64),\
    \ (64,1), (63,65), (65,63), (64,128), (128,64), (67,129)]:\n    for trial in 0..<8:\n\
    \        var a = initMatrixMod2(h,w)\n        var padded: StaticMatrixMod2[131,133]\n\
    \        for i in 0..<131:\n            for j in 0..<133: padded[i,j] = true\n\
    \        var rows = newSeqWith(h,newSeq[bool](w))\n        var b = newSeq[bool](h)\n\
    \        for i in 0..<h:\n            b[i] = rng.rand(1) == 1\n            for\
    \ j in 0..<w:\n                let value = trial != 0 and rng.rand(1) == 1\n \
    \               a[i,j] = value\n                padded[i,j] = value\n        \
    \        rows[i][j] = value\n        let before = a\n        let savedPadded =\
    \ padded\n        let expected = fieldSolve(rows,w,b)\n        doAssert a.solveLinearSystem(b)\
    \ == expected\n        doAssert padded.solveLinearSystem(b,h,w) == expected\n\
    \        doAssert a == before and padded == savedPadded\n\nblock:\n    var a =\
    \ initMatrixMod2(2,65)\n    a[0,64] = true\n    a[1,64] = true\n    doAssert a.solveLinearSystem(@[false,true]).isNone\n\
    \    let solution = a.solveLinearSystem(@[true,true]).get\n    doAssert solution.particular[64]\
    \ and solution.basis.len == 64\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/matrix/static_matrix_mod2.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix_mod2.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/static_matrix_mod2.nim
  - cplib/matrix/matrix_mod2.nim
  - cplib/matrix/field_matrix_ops.nim
  isVerificationFile: true
  path: verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
  requiredBy: []
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
- /verify/verify/matrix/matrix_mod2_field_algorithms_unit_test.nim.html
title: verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
---
