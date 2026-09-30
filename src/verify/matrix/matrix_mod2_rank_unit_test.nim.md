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
    import cplib/matrix/matrix_mod2\nimport cplib/matrix/field_matrix_ops\nimport\
    \ random, sequtils, strutils\n\nvar rng = initRand(712053)\nfor (h, w) in [(0,0),\
    \ (0,129), (256,0), (255,65), (256,7), (256,8), (257,9),\n        (256,63), (257,64),\
    \ (256,65), (257,129), (320,257), (511,33), (1024,1), (1024,7), (1024,8), (1024,65),\n\
    \        (1024,129), (1024,256), (1024,257), (8,256), (65,257)]:\n    for trial\
    \ in 0..<5:\n        var rows = newSeqWith(h, newSeq[bool](w))\n        var a\
    \ = initMatrixMod2(h,w)\n        for i in 0..<h:\n            for j in 0..<w:\n\
    \                var value = trial > 0 and rng.rand(1) == 1\n                if\
    \ trial == 2 and i >= 7:\n                    value = rows[i mod 7][j] xor rows[(i+1)\
    \ mod 7][j]\n                if trial == 3 and (j < 67 or j mod 8 < 4): value\
    \ = false\n                if trial == 4: value = j == w-1\n                rows[i][j]\
    \ = value\n                a[i,j] = value\n        let before = a\n        let\
    \ expected = fieldRank(rows,w)\n        doAssert a.rank == expected\n        doAssert\
    \ a == before\n\nfor n in [256,257,320]:\n    var a = initMatrixMod2(n,n)\n  \
    \  for i in 0..<n:\n        a[i,n-1-i] = true\n        for j in n-i..<n: a[i,j]\
    \ = rng.rand(1) == 1\n    let before = a\n    doAssert a.rank == n\n    doAssert\
    \ a.determinant\n    doAssert a == before\n    a.setRowBits(n-1, a.rowBits(0))\n\
    \    let singular = a\n    doAssert a.rank == n-1\n    doAssert not a.determinant\n\
    \    doAssert a == singular\n\nfor width in [0,1,7,8,63,64,65,129,193,257]:\n\
    \    var a = initMatrixMod2(2,width)\n    for length in [0,1,7,8,63,64,65,129,193,257]:\n\
    \        if length > width: continue\n        a.setRowBits(0,repeat('1',width))\n\
    \        a.setRowBits(1,repeat('1',width))\n        var text = newString(length)\n\
    \        for j in 0..<length: text[j] = \"01x\"[rng.rand(2)]\n        a.setRowBits(0,text)\n\
    \        for j in 0..<width:\n            doAssert a[0,j] == (j < length and text[j]\
    \ == '1')\n            doAssert a[1,j]\n\n# \u72EC\u7ACB\u306A\u884C\u304C\u63A2\
    \u7D22\u7BC4\u56F2\u306E\u5F8C\u65B9\u306B\u3057\u304B\u306A\u3044\u5834\u5408\
    \u3082\u3001\u672A\u78BA\u5B9A\u306E\u968E\u6570\u3067\u7D42\u4E86\u3057\u306A\
    \u3044\u3002\nfor width in [1,7,8,63,64,65,129,256,257]:\n    let height = 4096\n\
    \    var a = initMatrixMod2(height,width)\n    for j in 0..<width:\n        a[height-1-j,j]\
    \ = true\n    let before = a\n    doAssert a.rank == width\n    doAssert a ==\
    \ before\n    a[height-width,width-1] = false\n    doAssert a.rank == width-1\n\
    \n# \u30D4\u30DC\u30C3\u30C8\u306E\u5217\u756A\u53F7\u304C\u884C\u9806\u306B\u4E26\
    \u3093\u3067\u3044\u306A\u304F\u3066\u3082\u300164bit\u5883\u754C\u3092\u8D8A\u3048\
    \u3066\u6B63\u3057\u304F\u6D88\u53BB\u3059\u308B\u3002\nblock:\n    var a = initMatrixMod2(4096,129)\n\
    \    for i in 0..<129:\n        a[i,128-i] = true\n        for j in 129-i..<129:\
    \ a[i,j] = true\n    let before = a\n    doAssert a.rank == 129\n    doAssert\
    \ a == before\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/matrix_mod2.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix_mod2.nim
  - cplib/matrix/bit_matrix_ops.nim
  isVerificationFile: true
  path: verify/matrix/matrix_mod2_rank_unit_test.nim
  requiredBy: []
  timestamp: '2026-09-30 06:48:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_mod2_rank_unit_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_mod2_rank_unit_test.nim
- /verify/verify/matrix/matrix_mod2_rank_unit_test.nim.html
title: verify/matrix/matrix_mod2_rank_unit_test.nim
---
