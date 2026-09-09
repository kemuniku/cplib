---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/matrix/inverse_matrix_mod_2_test.nim
    title: verify/matrix/inverse_matrix_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/inverse_matrix_mod_2_test.nim
    title: verify/matrix/inverse_matrix_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_det_mod_2_test.nim
    title: verify/matrix/matrix_det_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_det_mod_2_test.nim
    title: verify/matrix/matrix_det_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_mod_2_test.nim
    title: verify/matrix/matrix_product_mod_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_mod_2_test.nim
    title: verify/matrix/matrix_product_mod_2_test.nim
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
  code: "when not declared CPLIB_MATRIX_MATRIX_MOD2:\n    const CPLIB_MATRIX_MATRIX_MOD2*\
    \ = 1\n\n    import bitops,options\n\n    type MatrixMod2* = object\n        ##\
    \ A dynamically-sized matrix over GF(2).\n        height, width: int\n       \
    \ rows: seq[seq[uint64]]\n\n    proc initMatrixMod2*(h, w: int): MatrixMod2 =\n\
    \        assert h >= 0 and w >= 0\n        result.height = h\n        result.width\
    \ = w\n        result.rows = newSeq[seq[uint64]](h)\n        for i in 0..<h:\n\
    \            result.rows[i] = newSeq[uint64]((w + 63) div 64)\n\n    proc initMatrixMod2*[T:\
    \ SomeInteger](a: openArray[seq[T]]): MatrixMod2 =\n        let w = if a.len ==\
    \ 0: 0 else: a[0].len\n        result = initMatrixMod2(a.len, w)\n        for\
    \ i in 0..<a.len:\n            assert a[i].len == w\n            for j, x in a[i]:\n\
    \                if (x and 1) != 0:\n                    result.rows[i][j shr\
    \ 6] = result.rows[i][j shr 6] or (1'u64 shl (j and 63))\n\n    proc initMatrixMod2*(a:\
    \ openArray[seq[bool]]): MatrixMod2 =\n        let w = if a.len == 0: 0 else:\
    \ a[0].len\n        result = initMatrixMod2(a.len, w)\n        for i in 0..<a.len:\n\
    \            assert a[i].len == w\n            for j, x in a[i]:\n           \
    \     if x: result.rows[i][j shr 6] = result.rows[i][j shr 6] or (1'u64 shl (j\
    \ and 63))\n\n    proc toMatrixMod2*[T](a: openArray[seq[T]]): MatrixMod2 = initMatrixMod2(a)\n\
    \    proc h*(a: MatrixMod2): int {.inline.} = a.height\n    proc w*(a: MatrixMod2):\
    \ int {.inline.} = a.width\n\n    proc `[]`*(a: MatrixMod2, i, j: int): bool {.inline.}\
    \ =\n        assert i in 0..<a.height and j in 0..<a.width\n        (a.rows[i][j\
    \ shr 6] and (1'u64 shl (j and 63))) != 0\n\n    proc `[]=`*(a: var MatrixMod2,\
    \ i, j: int, x: bool) {.inline.} =\n        assert i in 0..<a.height and j in\
    \ 0..<a.width\n        let mask = 1'u64 shl (j and 63)\n        if x: a.rows[i][j\
    \ shr 6] = a.rows[i][j shr 6] or mask\n        else: a.rows[i][j shr 6] = a.rows[i][j\
    \ shr 6] and not mask\n\n    proc `[]=`*[T: SomeInteger](a: var MatrixMod2, i,\
    \ j: int, x: T) {.inline.} =\n        a[i, j] = (x and 1) != 0\n\n    proc `==`*(a,\
    \ b: MatrixMod2): bool =\n        a.height == b.height and a.width == b.width\
    \ and a.rows == b.rows\n\n    proc `$`*(a: MatrixMod2): string =\n        for\
    \ i in 0..<a.height:\n            if i > 0: result.add '\\n'\n            for\
    \ j in 0..<a.width:\n                if j > 0: result.add ' '\n              \
    \  result.add(if a[i, j]: '1' else: '0')\n\n    {.push checks: off.}\n    proc\
    \ setRowBitsUnchecked(a: var MatrixMod2, i: int, values: string) =\n        for\
    \ k in 0..<a.rows[i].len:\n            a.rows[i][k] = 0\n        for j in 0..<values.len:\n\
    \            if values[j] == '1':\n                a.rows[i][j shr 6] = a.rows[i][j\
    \ shr 6] or (1'u64 shl (j and 63))\n\n    proc rowBitsUnchecked(a: MatrixMod2,\
    \ i, width: int): string =\n        result = newString(width)\n        for j in\
    \ 0..<width:\n            result[j] = char(ord('0') + int((a.rows[i][j shr 6]\
    \ shr (j and 63)) and 1))\n    {.pop.}\n\n    proc setRowBits*(a: var MatrixMod2,\
    \ i: int, values: string) =\n        assert i in 0..<a.height and values.len <=\
    \ a.width\n        a.setRowBitsUnchecked(i, values)\n\n    proc rowBits*(a: MatrixMod2,\
    \ i, width: int): string =\n        assert i in 0..<a.height and width in 0..a.width\n\
    \        a.rowBitsUnchecked(i, width)\n\n    proc rowBits*(a: MatrixMod2, i: int):\
    \ string =\n        a.rowBits(i, a.width)\n\n    proc identityMatrixMod2*(n: int):\
    \ MatrixMod2 =\n        result = initMatrixMod2(n, n)\n        for i in 0..<n:\
    \ result[i, i] = true\n\n    proc transposed*(a: MatrixMod2): MatrixMod2 =\n \
    \       result = initMatrixMod2(a.width, a.height)\n        for i in 0..<a.height:\n\
    \            for j in 0..<a.width:\n                if a[i, j]: result[j, i] =\
    \ true\n\n    {.push checks: off.}\n    proc multiplyUnchecked(a, b: MatrixMod2):\
    \ MatrixMod2 =\n        result = initMatrixMod2(a.height, b.width)\n        if\
    \ a.height < 40 or a.width < 64:\n            let bt = b.transposed()\n      \
    \      for i in 0..<a.height:\n                for j in 0..<b.width:\n       \
    \             var parity = 0\n                    for k in 0..<a.rows[i].len:\n\
    \                        parity = parity xor ((a.rows[i][k] and bt.rows[j][k]).countSetBits\
    \ and 1)\n                    if parity != 0: result[i, j] = true\n        else:\n\
    \            # Method of Four Russians: process eight columns of a at once and\n\
    \            # look up the corresponding xor of rows of b.\n            const\
    \ BlockBits = 8\n            let wordCount = (b.width + 63) div 64\n         \
    \   if wordCount == 0: return\n            var table = newSeq[uint64]((1 shl BlockBits)\
    \ * wordCount)\n            let tableData = cast[ptr UncheckedArray[uint64]](table[0].addr)\n\
    \            var blockStart = 0\n            while blockStart < a.width:\n   \
    \             let bits = min(BlockBits, a.width - blockStart)\n              \
    \  for mask in 1..<(1 shl bits):\n                    let previous = mask and\
    \ (mask - 1)\n                    let bit = mask.countTrailingZeroBits\n     \
    \               let offset = mask * wordCount\n                    let previousOffset\
    \ = previous * wordCount\n                    let bRow = cast[ptr UncheckedArray[uint64]](\n\
    \                        unsafeAddr b.rows[blockStart + bit][0])\n           \
    \         for k in 0..<wordCount:\n                        tableData[offset +\
    \ k] = tableData[previousOffset + k] xor bRow[k]\n                let shift =\
    \ blockStart and 63\n                let mask = uint64((1 shl bits) - 1)\n   \
    \             for i in 0..<a.height:\n                    let aRow = cast[ptr\
    \ UncheckedArray[uint64]](unsafeAddr a.rows[i][0])\n                    let resultRow\
    \ = cast[ptr UncheckedArray[uint64]](result.rows[i][0].addr)\n               \
    \     let index = int((aRow[blockStart shr 6] shr shift) and mask)\n         \
    \           let offset = index * wordCount\n                    for k in 0..<wordCount:\n\
    \                        resultRow[k] = resultRow[k] xor tableData[offset + k]\n\
    \                blockStart += BlockBits\n    {.pop.}\n\n    proc `*`*(a, b: MatrixMod2):\
    \ MatrixMod2 =\n        assert a.width == b.height\n        multiplyUnchecked(a,\
    \ b)\n\n    proc `*=`*(a: var MatrixMod2, b: MatrixMod2) = a = a * b\n\n    proc\
    \ pow*(a: MatrixMod2, exponent: int): MatrixMod2 =\n        assert a.height ==\
    \ a.width and exponent >= 0\n        result = identityMatrixMod2(a.height)\n \
    \       var base = a\n        var e = exponent\n        while e > 0:\n       \
    \     if (e and 1) != 0: result *= base\n            e = e shr 1\n           \
    \ if e > 0: base *= base\n\n    proc `**`*(a: MatrixMod2, exponent: int): MatrixMod2\
    \ = a.pow(exponent)\n\n    proc rank*(a: MatrixMod2): int =\n        var b = a\n\
    \        for col in 0..<b.width:\n            var pivot = result\n           \
    \ while pivot < b.height and not b[pivot, col]: inc pivot\n            if pivot\
    \ == b.height: continue\n            swap(b.rows[result], b.rows[pivot])\n   \
    \         for i in result + 1..<b.height:\n                if b[i, col]:\n   \
    \                 for k in 0..<b.rows[i].len: b.rows[i][k] = b.rows[i][k] xor\
    \ b.rows[result][k]\n            inc result\n            if result == b.height:\
    \ break\n\n    proc determinant*(a: MatrixMod2): bool =\n        assert a.height\
    \ == a.width\n        a.rank == a.height\n\n    proc inverse*(a: MatrixMod2):\
    \ Option[MatrixMod2] =\n        assert a.height == a.width\n        let n = a.height\n\
    \        var aug = initMatrixMod2(n, 2 * n)\n        for i in 0..<n:\n       \
    \     for j in 0..<n:\n                if a[i, j]: aug[i, j] = true\n        \
    \    aug[i, n + i] = true\n        for col in 0..<n:\n            var pivot =\
    \ col\n            while pivot < n and not aug[pivot, col]: inc pivot\n      \
    \      if pivot == n: return none(MatrixMod2)\n            swap(aug.rows[col],\
    \ aug.rows[pivot])\n            for i in 0..<n:\n                if i != col and\
    \ aug[i, col]:\n                    for k in 0..<aug.rows[i].len: aug.rows[i][k]\
    \ = aug.rows[i][k] xor aug.rows[col][k]\n        var inv = initMatrixMod2(n, n)\n\
    \        for i in 0..<n:\n            for j in 0..<n:\n                if aug[i,\
    \ n + j]: inv[i, j] = true\n        some(inv)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/matrix/matrix_mod2.nim
  requiredBy: []
  timestamp: '2026-07-14 07:36:02+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/matrix/matrix_product_mod_2_test.nim
  - verify/matrix/matrix_product_mod_2_test.nim
  - verify/matrix/inverse_matrix_mod_2_test.nim
  - verify/matrix/inverse_matrix_mod_2_test.nim
  - verify/matrix/matrix_rank_mod_2_test.nim
  - verify/matrix/matrix_rank_mod_2_test.nim
  - verify/matrix/matrix_det_mod_2_test.nim
  - verify/matrix/matrix_det_mod_2_test.nim
documentation_of: cplib/matrix/matrix_mod2.nim
layout: document
redirect_from:
- /library/cplib/matrix/matrix_mod2.nim
- /library/cplib/matrix/matrix_mod2.nim.html
title: cplib/matrix/matrix_mod2.nim
---
