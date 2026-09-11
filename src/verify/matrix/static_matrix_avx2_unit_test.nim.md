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
    import cplib/modint/modint\nimport cplib/matrix/static_matrix_avx2 as fixed\n\
    import cplib/matrix/matrix_avx2 as dynamic\nimport options, random\nvar rng =\
    \ initRand(73519)\nproc check[H: static int,W: static int,T]() =\n    for trial\
    \ in 0..<5:\n        var a = fixed.initMatrix[H,W,T]()\n        var b = dynamic.initMatrix[T](H,W)\n\
    \        for i in 0..<H:\n            for j in 0..<W:\n                let v =\
    \ T.init(if trial == 0: 0 else: rng.rand(100))\n                a[i,j] = v\n \
    \               b[i,j] = v\n        let saved = a\n        doAssert a.rank ==\
    \ b.rank\n        var rhs = newSeq[T](H)\n        for i in 0..<H: rhs[i] = T.init(rng.rand(10))\n\
    \        let x = a.solveLinearSystem(rhs)\n        let y = b.solveLinearSystem(rhs)\n\
    \        doAssert x.isSome == y.isSome\n        if x.isSome:\n            doAssert\
    \ x.get.basis.len == y.get.basis.len\n            for i in 0..<W: doAssert x.get.particular[i].val\
    \ == y.get.particular[i].val\n            for k in 0..<x.get.basis.len:\n    \
    \            for i in 0..<W: doAssert x.get.basis[k][i].val == y.get.basis[k][i].val\n\
    \        for n in 0..min(H,W):\n            var c = dynamic.initMatrix[T](n,n)\n\
    \            for i in 0..<n:\n                for j in 0..<n: c[i,j] = a[i,j]\n\
    \            doAssert a.determinant(n).val == c.determinant.val\n            let\
    \ inv = a.inverse(n)\n            let refInv = c.inverse\n            doAssert\
    \ inv.isSome == refInv.isSome\n            let adj = a.adjugate(n)\n         \
    \   let refAdj = c.adjugate\n            for i in 0..<H:\n                for\
    \ j in 0..<W:\n                    doAssert adj[i,j].val == (if i < n and j <\
    \ n: refAdj[i,j].val else: 0)\n                    if inv.isSome:\n          \
    \              doAssert inv.get[i,j].val == (if i < n and j < n: refInv.get[i,j].val\
    \ else: 0)\n        doAssert a == saved\n        var right = fixed.initMatrix[W,H,T]()\n\
    \        var refRight = dynamic.initMatrix[T](W,H)\n        for i in 0..<W:\n\
    \            for j in 0..<H:\n                right[i,j] = T.init(rng.rand(100))\n\
    \                refRight[i,j] = right[i,j]\n        let product = a * right\n\
    \        let refProduct = b * refRight\n        for i in 0..<H:\n            for\
    \ j in 0..<H: doAssert product[i,j].val == refProduct[i,j].val\n    var a = fixed.initMatrix[H,W,T]()\n\
    \    for n in countup(0,min(H,W),2):\n        var b = dynamic.initMatrix[T](n,n)\n\
    \        for i in 0..<n:\n            for j in 0..<i:\n                let v =\
    \ T.init(rng.rand(100))\n                a[i,j] = v\n                a[j,i] =\
    \ v\n                b[i,j] = v\n                b[j,i] = v\n        doAssert\
    \ a.hafnian(n).val == b.hafnian.val\n\ntemplate run(T: typedesc) =\n    check[0,0,T]()\n\
    \    check[0,9,T]()\n    check[9,0,T]()\n    check[1,1,T]()\n    check[2,2,T]()\n\
    \    check[3,4,T]()\n    check[4,4,T]()\n    check[4,5,T]()\n    check[5,4,T]()\n\
    \    check[7,9,T]()\n    check[9,7,T]()\n    check[17,18,T]()\nrun(modint998244353_montgomery)\n\
    run(modint1000000007_barrett)\nfor modulus in [3,17,1073741789]:\n    modint_montgomery.setMod(modulus)\n\
    \    run(modint_montgomery)\n    modint_barrett.setMod(modulus)\n    run(modint_barrett)\n\
    let a = fixed.toMatrix([[modint998244353_montgomery.init(1),modint998244353_montgomery.init(2)],[modint998244353_montgomery.init(3),modint998244353_montgomery.init(4)]])\n\
    doAssert a.pow(2) == a*a\ndoAssert a + a == a * modint998244353_montgomery.init(2)\n\
    doAssert a-a == fixed.initMatrix[2,2,modint998244353_montgomery]()\ndoAssert $a\
    \ == \"1 2\\n3 4\"\ndoAssert (a + modint998244353_montgomery.init(1)).sum.val\
    \ == 14\nmodint_montgomery.setMod(17)\nlet stale = fixed.initMatrix[2,2,modint_montgomery]()\n\
    modint_montgomery.setMod(19)\ntemplate rejects(body: untyped) =\n    block:\n\
    \        var raised = false\n        try: body\n        except AssertionDefect:\
    \ raised = true\n        doAssert raised\nrejects: discard stale.rank\nrejects:\
    \ discard stale.determinant\nrejects: discard stale.inverse\nrejects: discard\
    \ stale.adjugate\nrejects: discard stale.hafnian\nrejects: discard stale.solveLinearSystem(@[modint_montgomery.init(0),modint_montgomery.init(0)])\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/matrix/static_matrix_avx2_unit_test.nim
  requiredBy: []
  timestamp: '2026-09-11 02:58:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/static_matrix_avx2_unit_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/static_matrix_avx2_unit_test.nim
- /verify/verify/matrix/static_matrix_avx2_unit_test.nim.html
title: verify/matrix/static_matrix_avx2_unit_test.nim
---
