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
  - icon: ':warning:'
    path: cplib/matrix/static_matrix_avx2.nim
    title: cplib/matrix/static_matrix_avx2.nim
  - icon: ':warning:'
    path: cplib/matrix/static_matrix_avx2.nim
    title: cplib/matrix/static_matrix_avx2.nim
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
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
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
  code: "include cplib/tmpl/fastio\nimport cplib/modint/modint\nimport options\nwhen\
    \ defined(testStaticAvxMatrix):\n    import cplib/matrix/static_matrix_avx2\n\
    elif defined(testStaticMatrix):\n    import cplib/matrix/static_matrix\nelif defined(testAvxMatrix):\n\
    \    import cplib/matrix/matrix_avx2\nelse:\n    import cplib/matrix/matrix\n\n\
    type Mint = modint998244353_montgomery\nlet n = input(int)\nwhen matrixProblem\
    \ in [\"matrix_rank\", \"system_of_linear_equations\"]:\n    let m = input(int)\n\
    else:\n    let m = n\n\ntemplate solve(a: untyped) =\n    for i in 0..<n:\n  \
    \      for j in 0..<m: a[i,j] = Mint(input(int))\n    when matrixProblem == \"\
    matrix_det\":\n        when defined(testStaticMatrix): echo a.determinant(n)\n\
    \        else: echo a.determinant\n    elif matrixProblem == \"matrix_rank\":\n\
    \        when defined(testStaticMatrix): echo a.rank(n,m)\n        else: echo\
    \ a.rank\n    elif matrixProblem == \"hafnian_of_matrix\":\n        when defined(testStaticMatrix):\
    \ echo a.hafnian(n)\n        else: echo a.hafnian\n    elif matrixProblem == \"\
    system_of_linear_equations\":\n        var b = newSeq[Mint](n)\n        for i\
    \ in 0..<n: b[i] = Mint(input(int))\n        when defined(testStaticMatrix):\n\
    \            let answer = a.solveLinearSystem(b,n,m)\n        else:\n        \
    \    let answer = a.solveLinearSystem(b)\n        if answer.isNone: echo -1\n\
    \        else:\n            let s = answer.get\n            echo s.basis.len\n\
    \            for j in 0..<m:\n                if j > 0: stdout.write \" \"\n \
    \               stdout.write $s.particular[j]\n            stdout.write \"\\n\"\
    \n            for v in s.basis:\n                for j in 0..<m:\n           \
    \         if j > 0: stdout.write \" \"\n                    stdout.write $v[j]\n\
    \                stdout.write \"\\n\"\n    else:\n        when matrixProblem ==\
    \ \"inverse_matrix\":\n            when defined(testStaticMatrix):\n         \
    \       let answer = a.inverse(n)\n            else:\n                let answer\
    \ = a.inverse\n        else:\n            when defined(testStaticMatrix):\n  \
    \              let answer = some(a.adjugate(n))\n            else:\n         \
    \       let answer = some(a.adjugate)\n        if answer.isNone: echo -1\n   \
    \     else:\n            let value = answer.get\n            for i in 0..<n:\n\
    \                for j in 0..<n:\n                    if j > 0: stdout.write \"\
    \ \"\n                    stdout.write $value[i,j]\n                stdout.write\
    \ \"\\n\"\n\nwhen defined(testStaticMatrix):\n    proc run[H: static int, W: static\
    \ int]() =\n        var storage: ref StaticMatrix[H,W,Mint]\n        new storage\n\
    \        solve(storage[])\n    when matrixProblem == \"matrix_rank\":\n      \
    \  if n <= m:\n            if n <= 1: run[1,250000]()\n            elif n <= 2:\
    \ run[2,250000]()\n            elif n <= 4: run[4,125000]()\n            elif\
    \ n <= 8: run[8,62500]()\n            elif n <= 16: run[16,31250]()\n        \
    \    elif n <= 32: run[32,15625]()\n            elif n <= 64: run[64,7812]()\n\
    \            elif n <= 128: run[128,3906]()\n            elif n <= 256: run[256,1953]()\n\
    \            else: run[512,976]()\n        else:\n            if m <= 1: run[250000,1]()\n\
    \            elif m <= 2: run[250000,2]()\n            elif m <= 4: run[125000,4]()\n\
    \            elif m <= 8: run[62500,8]()\n            elif m <= 16: run[31250,16]()\n\
    \            elif m <= 32: run[15625,32]()\n            elif m <= 64: run[7812,64]()\n\
    \            elif m <= 128: run[3906,128]()\n            elif m <= 256: run[1953,256]()\n\
    \            else: run[976,512]()\n    elif matrixProblem == \"hafnian_of_matrix\"\
    : run[38,38]()\n    else: run[500,500]()\nelse:\n    var a = initMatrix(n,m,Mint(0))\n\
    \    solve(a)\n"
  dependsOn:
  - cplib/matrix/matrix_avx2.nim
  - cplib/modint/modint.nim
  - cplib/matrix/static_matrix.nim
  - cplib/matrix/matrix_avx2_kernel.nim
  - cplib/modint/modint.nim
  - cplib/tmpl/fastio.nim
  - cplib/matrix/matrix_avx2_field_impl.nim
  - cplib/math/isqrt.nim
  - cplib/matrix/matrix.nim
  - cplib/matrix/matrix.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/modint/barrett_impl.nim
  - cplib/matrix/matrix_avx2.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/matrix/static_matrix_avx2.nim
  - cplib/matrix/matrix_avx2_field_impl.nim
  - cplib/matrix/static_matrix_avx2.nim
  - cplib/matrix/static_matrix.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix_avx2_kernel.nim
  - cplib/math/isqrt.nim
  - cplib/tmpl/fastio.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: false
  path: verify/matrix/linear_algebra/judge_driver.nim
  requiredBy: []
  timestamp: '2026-09-11 02:59:09+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/matrix/linear_algebra/judge_driver.nim
layout: document
redirect_from:
- /library/verify/matrix/linear_algebra/judge_driver.nim
- /library/verify/matrix/linear_algebra/judge_driver.nim.html
title: verify/matrix/linear_algebra/judge_driver.nim
---
