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
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/system_mod2_driver.nim
    title: verify/matrix/linear_algebra/system_mod2_driver.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/system_mod2_driver.nim
    title: verify/matrix/linear_algebra/system_mod2_driver.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_matrix_mod2_test.nim
    title: verify/AI/static_matrix_mod2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_matrix_mod2_test.nim
    title: verify/AI/static_matrix_mod2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/inverse_matrix_mod_2_static_test.nim
    title: verify/matrix/inverse_matrix_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/inverse_matrix_mod_2_static_test.nim
    title: verify/matrix/inverse_matrix_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/inverse_matrix_mod_2_test.nim
    title: verify/matrix/inverse_matrix_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/inverse_matrix_mod_2_test.nim
    title: verify/matrix/inverse_matrix_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_det_mod_2_static_test.nim
    title: verify/matrix/matrix_det_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_det_mod_2_static_test.nim
    title: verify/matrix/matrix_det_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_det_mod_2_test.nim
    title: verify/matrix/matrix_det_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_det_mod_2_test.nim
    title: verify/matrix/matrix_det_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
    title: verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
    title: verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_mod_2_static_test.nim
    title: verify/matrix/matrix_product_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_mod_2_static_test.nim
    title: verify/matrix/matrix_product_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_mod_2_test.nim
    title: verify/matrix/matrix_product_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_mod_2_test.nim
    title: verify/matrix/matrix_product_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_rank_mod_2_static_test.nim
    title: verify/matrix/matrix_rank_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_rank_mod_2_static_test.nim
    title: verify/matrix/matrix_rank_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_rank_mod_2_test.nim
    title: verify/matrix/matrix_rank_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_rank_mod_2_test.nim
    title: verify/matrix/matrix_rank_mod_2_test.nim
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
  code: "when not declared CPLIB_MATRIX_BIT_MATRIX_OPS:\n    const CPLIB_MATRIX_BIT_MATRIX_OPS*\
    \ = 1\n    import options\n    import cplib/matrix/field_matrix_ops\n\n    proc\
    \ initBitLinearSystem*(height, width: int): seq[uint64] =\n        ## \u53F3\u8FBA\
    \u3092\u542B\u3080h\u884C(w+1)\u5217\u306E\u4F5C\u696D\u9818\u57DF\u3092\u78BA\
    \u4FDD\u3059\u308B\u3002O(h*(w div 64+1))\u3002\n        assert height >= 0 and\
    \ width >= 0\n        let stride = (width shr 6) + 1\n        assert height <=\
    \ high(int) div sizeof(uint64) div stride\n        newSeq[uint64](height * stride)\n\
    \n    proc solveBitLinearSystem*(rows: var seq[uint64], height, width: int): Option[LinearSystemSolution[bool]]\
    \ =\n        ## \u62E1\u5927\u884C\u5217\u309264bit\u5358\u4F4D\u3067\u6383\u304D\
    \u51FA\u3059\u3002r=min(h,w)\u3001L=w div 64+1\u3068\u3057\u3066O(h*r*L+w^2)\u3002\
    \n        ## \u5404\u884C\u306FL\u30EF\u30FC\u30C9\u3067\u53F3\u8FBA\u306Fwidth\u5217\
    \u76EE\u3002\u4F5C\u696D\u9818\u57DF\u3092\u5909\u66F4\u3057\u3001\u89E3\u306A\
    \u3057\u306A\u3089none\u3092\u8FD4\u3059\u3002\n        assert height >= 0 and\
    \ width >= 0\n        let stride = (width shr 6) + 1\n        assert height <=\
    \ high(int) div stride and rows.len == height * stride\n        var pivots: seq[int]\n\
    \        if height > 0:\n            let data = cast[ptr UncheckedArray[uint64]](addr\
    \ rows[0])\n            for col in 0..<width:\n                let rank = pivots.len\n\
    \                if rank == height: break\n                let firstWord = col\
    \ shr 6\n                let mask = 1'u64 shl (col and 63)\n                var\
    \ pivot = rank\n                while pivot < height and (data[pivot * stride\
    \ + firstWord] and mask) == 0:\n                    inc pivot\n              \
    \  if pivot == height: continue\n                let pivotRow = cast[ptr UncheckedArray[uint64]](addr\
    \ data[rank * stride])\n                # \u30D4\u30DC\u30C3\u30C8\u884C\u306E\
    \u524D\u306E\u5217\u306F\u3059\u3079\u3066\u96F6\u306A\u306E\u3067\u3001\u73FE\
    \u5728\u306E\u30EF\u30FC\u30C9\u4EE5\u964D\u3060\u3051\u64CD\u4F5C\u3059\u308B\
    \u3002\n                if pivot != rank:\n                    for k in firstWord..<stride:\n\
    \                        swap(pivotRow[k], data[pivot * stride + k])\n       \
    \         for i in 0..<height:\n                    if i == rank: continue\n \
    \                   let row = cast[ptr UncheckedArray[uint64]](addr data[i * stride])\n\
    \                    if (row[firstWord] and mask) != 0:\n                    \
    \    for k in firstWord..<stride: row[k] = row[k] xor pivotRow[k]\n          \
    \      pivots.add(col)\n            let rhsWord = width shr 6\n            let\
    \ rhsMask = 1'u64 shl (width and 63)\n            for i in pivots.len..<height:\n\
    \                if (data[i * stride + rhsWord] and rhsMask) != 0:\n         \
    \           return none(LinearSystemSolution[bool])\n\n        var solution: LinearSystemSolution[bool]\n\
    \        solution.particular = newSeq[bool](width)\n        var isPivot = newSeq[bool](width)\n\
    \        for i, col in pivots:\n            isPivot[col] = true\n            solution.particular[col]\
    \ = ((rows[i * stride + (width shr 6)] shr (width and 63)) and 1) != 0\n     \
    \   for free in 0..<width:\n            if isPivot[free]: continue\n         \
    \   var vector = newSeq[bool](width)\n            vector[free] = true\n      \
    \      for i, col in pivots:\n                vector[col] = ((rows[i * stride\
    \ + (free shr 6)] shr (free and 63)) and 1) != 0\n            solution.basis.add(vector)\n\
    \        some(solution)\n"
  dependsOn:
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  isVerificationFile: false
  path: cplib/matrix/bit_matrix_ops.nim
  requiredBy:
  - verify/matrix/linear_algebra/system_mod2_driver.nim
  - verify/matrix/linear_algebra/system_mod2_driver.nim
  - cplib/matrix/matrix_mod2.nim
  - cplib/matrix/matrix_mod2.nim
  - cplib/matrix/static_matrix_mod2.nim
  - cplib/matrix/static_matrix_mod2.nim
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/static_matrix_mod2_test.nim
  - verify/AI/static_matrix_mod2_test.nim
  - verify/matrix/matrix_rank_mod_2_static_test.nim
  - verify/matrix/matrix_rank_mod_2_static_test.nim
  - verify/matrix/matrix_product_mod_2_test.nim
  - verify/matrix/matrix_product_mod_2_test.nim
  - verify/matrix/inverse_matrix_mod_2_static_test.nim
  - verify/matrix/inverse_matrix_mod_2_static_test.nim
  - verify/matrix/matrix_det_mod_2_static_test.nim
  - verify/matrix/matrix_det_mod_2_static_test.nim
  - verify/matrix/matrix_product_mod_2_static_test.nim
  - verify/matrix/matrix_product_mod_2_static_test.nim
  - verify/matrix/inverse_matrix_mod_2_test.nim
  - verify/matrix/inverse_matrix_mod_2_test.nim
  - verify/matrix/matrix_rank_mod_2_test.nim
  - verify/matrix/matrix_rank_mod_2_test.nim
  - verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
  - verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
  - verify/matrix/matrix_det_mod_2_test.nim
  - verify/matrix/matrix_det_mod_2_test.nim
documentation_of: cplib/matrix/bit_matrix_ops.nim
layout: document
redirect_from:
- /library/cplib/matrix/bit_matrix_ops.nim
- /library/cplib/matrix/bit_matrix_ops.nim.html
title: cplib/matrix/bit_matrix_ops.nim
---
