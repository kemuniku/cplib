---
data:
  _extendedDependsOn: []
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
    echo \"Hello World\"\n\nimport cplib/matrix/matrix as dynamicMatrix\nimport cplib/matrix/static_matrix\
    \ as staticMatrix\n\nlet d = dynamicMatrix.initMatrix(@[@[2, 3], @[4, 5]])\nlet\
    \ s = staticMatrix.initMatrix([[2, 3], [4, 5]])\nassert (10 - d) == dynamicMatrix.initMatrix(@[@[8,\
    \ 7], @[6, 5]])\nassert (10 - s) == staticMatrix.initMatrix([[8, 7], [6, 5]])\n\
    \ntemplate checkScalarLeft(op: untyped) =\n    block:\n        let ld = op(19,\
    \ d)\n        let ls = op(19, s)\n        let rd = op(d, 2)\n        let rs =\
    \ op(s, 2)\n        for i in 0..<2:\n            for j in 0..<2:\n           \
    \     assert ld[i, j] == op(19, d[i, j])\n                assert ls[i, j] == op(19,\
    \ s[i, j])\n                assert rd[i, j] == op(d[i, j], 2)\n              \
    \  assert rs[i, j] == op(s[i, j], 2)\ncheckScalarLeft(`+`)\ncheckScalarLeft(`-`)\n\
    checkScalarLeft(`div`)\ncheckScalarLeft(`mod`)\ncheckScalarLeft(`shl`)\ncheckScalarLeft(`shr`)\n\
    checkScalarLeft(`and`)\ncheckScalarLeft(`or`)\ncheckScalarLeft(`xor`)\nassert\
    \ d == dynamicMatrix.initMatrix(@[@[2, 3], @[4, 5]])\nassert s == staticMatrix.initMatrix([[2,\
    \ 3], [4, 5]])\nlet fd = dynamicMatrix.initMatrix(@[@[1.5, -2.0]])\nlet fs = staticMatrix.initMatrix([[1.5,\
    \ -2.0]])\nassert 3.0 - fd == dynamicMatrix.initMatrix(@[@[1.5, 5.0]])\nassert\
    \ 3.0 - fs == staticMatrix.initMatrix([[1.5, 5.0]])\nlet empty = dynamicMatrix.initMatrix(0,\
    \ 3, 0)\nlet emptyResult = 10 - empty\nassert emptyResult.h == 0 and emptyResult.w\
    \ == 3\nlet emptyStatic = staticMatrix.initMatrix[0, 3, int](0)\nassert (10 -\
    \ emptyStatic).h == 0\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/matrix/scalar_left_operations_test.nim
  requiredBy: []
  timestamp: '2026-09-18 01:13:21+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/scalar_left_operations_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/scalar_left_operations_test.nim
- /verify/verify/matrix/scalar_left_operations_test.nim.html
title: verify/matrix/scalar_left_operations_test.nim
---
