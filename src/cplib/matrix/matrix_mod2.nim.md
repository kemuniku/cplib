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
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/system_mod2_driver.nim
    title: verify/matrix/linear_algebra/system_mod2_driver.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/system_mod2_driver.nim
    title: verify/matrix/linear_algebra/system_mod2_driver.nim
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
    path: verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
    title: verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
    title: verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_mod2_rank_unit_test.nim
    title: verify/matrix/matrix_mod2_rank_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_mod2_rank_unit_test.nim
    title: verify/matrix/matrix_mod2_rank_unit_test.nim
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
    \ GF(2)\u4E0A\u306E\u53EF\u5909\u30B5\u30A4\u30BA\u884C\u5217\u3002\u5404\u884C\
    \u309264bit\u5883\u754C\u306B\u63C3\u3048\u305F\u9023\u7D9A\u914D\u5217\u3067\u4FDD\
    \u6301\u3059\u308B\u3002\n        height, width, stride: int\n        words: seq[uint64]\n\
    \n    proc initMatrixMod2*(h, w: int): MatrixMod2 =\n        ## h\u884Cw\u5217\
    \u306E\u96F6\u884C\u5217\u3092O(h*ceil(w/64))\u6642\u9593\u30FB\u7A7A\u9593\u3067\
    \u4F5C\u308B\u3002\u884C\u3054\u3068\u306E\u78BA\u4FDD\u306F\u884C\u308F\u306A\
    \u3044\u3002\n        assert h >= 0 and w >= 0, \"\u884C\u5217\u306E\u884C\u6570\
    \u3068\u5217\u6570\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n        let stride = (w shr 6) + int((w and 63) != 0)\n\
    \        assert stride == 0 or h <= high(int) div sizeof(uint64) div stride, \"\
    \u884C\u5217\u306E\u8A18\u61B6\u9818\u57DF\u306E\u30B5\u30A4\u30BA\u304Cint\u306E\
    \u7BC4\u56F2\u3092\u8D85\u3048\u3066\u3044\u307E\u3059\"\n        result.height\
    \ = h\n        result.width = w\n        result.stride = stride\n        result.words\
    \ = newSeq[uint64](h * stride)\n\n    template word(a: MatrixMod2, i, k: int):\
    \ untyped =\n        a.words[i * a.stride + k]\n\n    proc initMatrixMod2*[T:\
    \ SomeInteger](a: openArray[seq[T]]): MatrixMod2 =\n        let w = if a.len ==\
    \ 0: 0 else: a[0].len\n        result = initMatrixMod2(a.len, w)\n        for\
    \ i in 0..<a.len:\n            assert a[i].len == w, \"\u884C\u5217\u306E\u5404\
    \u884C\u306E\u9577\u3055\u306F\u5217\u6570\u3068\u4E00\u81F4\u3059\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\"\n            for j, x in a[i]:\n      \
    \          if (x and 1) != 0:\n                    word(result, i, j shr 6) =\
    \ word(result, i, j shr 6) or (1'u64 shl (j and 63))\n\n    proc initMatrixMod2*(a:\
    \ openArray[seq[bool]]): MatrixMod2 =\n        let w = if a.len == 0: 0 else:\
    \ a[0].len\n        result = initMatrixMod2(a.len, w)\n        for i in 0..<a.len:\n\
    \            assert a[i].len == w, \"\u884C\u5217\u306E\u5404\u884C\u306E\u9577\
    \u3055\u306F\u5217\u6570\u3068\u4E00\u81F4\u3059\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n            for j, x in a[i]:\n                if x: word(result,\
    \ i, j shr 6) = word(result, i, j shr 6) or (1'u64 shl (j and 63))\n\n    proc\
    \ toMatrixMod2*[T](a: openArray[seq[T]]): MatrixMod2 = initMatrixMod2(a)\n   \
    \ proc h*(a: MatrixMod2): int {.inline.} = a.height\n    proc w*(a: MatrixMod2):\
    \ int {.inline.} = a.width\n\n    proc `[]`*(a: MatrixMod2, i, j: int): bool {.inline.}\
    \ =\n        assert i in 0..<a.height and j in 0..<a.width, \"\u6307\u5B9A\u3057\
    \u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059: i in 0 ..< a.height and j in 0 ..< a.width\"\
    \n        (word(a, i, j shr 6) and (1'u64 shl (j and 63))) != 0\n\n    proc `[]=`*(a:\
    \ var MatrixMod2, i, j: int, x: bool) {.inline.} =\n        assert i in 0..<a.height\
    \ and j in 0..<a.width, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\
    \u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    : i in 0 ..< a.height and j in 0 ..< a.width\"\n        let mask = 1'u64 shl (j\
    \ and 63)\n        if x: word(a, i, j shr 6) = word(a, i, j shr 6) or mask\n \
    \       else: word(a, i, j shr 6) = word(a, i, j shr 6) and not mask\n\n    proc\
    \ `[]=`*[T: SomeInteger](a: var MatrixMod2, i, j: int, x: T) {.inline.} =\n  \
    \      a[i, j] = (x and 1) != 0\n\n    proc `==`*(a, b: MatrixMod2): bool =\n\
    \        a.height == b.height and a.width == b.width and a.words == b.words\n\n\
    \    proc `$`*(a: MatrixMod2): string =\n        for i in 0..<a.height:\n    \
    \        if i > 0: result.add '\\n'\n            for j in 0..<a.width:\n     \
    \           if j > 0: result.add ' '\n                result.add(if a[i, j]: '1'\
    \ else: '0')\n\n    {.push checks: off.}\n    proc setRowBitsUnchecked(a: var\
    \ MatrixMod2, i: int, values: string) =\n        ## \u6587\u5B57\u5217\u309264bit\u305A\
    \u3064\u307E\u3068\u3081\u3066\u683C\u7D0D\u3057\u3001\u6B8B\u308A\u306E\u5217\
    \u3092\u96F6\u306B\u3059\u308B\u3002\n        var j = 0\n        for k in 0..<a.stride:\n\
    \            var value = 0'u64\n            let limit = min(64, values.len - j)\n\
    \            for bit in 0..<limit:\n                value = value or (uint64(values[j\
    \ + bit] == '1') shl bit)\n            word(a, i, k) = value\n            j +=\
    \ limit\n\n    proc rowBitsUnchecked(a: MatrixMod2, i, width: int): string =\n\
    \        result = newString(width)\n        for j in 0..<width:\n            result[j]\
    \ = char(ord('0') + int((word(a, i, j shr 6) shr (j and 63)) and 1))\n    {.pop.}\n\
    \n    proc setRowBits*(a: var MatrixMod2, i: int, values: string) =\n        assert\
    \ i in 0..<a.height and values.len <= a.width, \"\u884C\u756A\u53F7\u304C\u7BC4\
    \u56F2\u5185\u3067\u3001\u6307\u5B9A\u3057\u305F\u884C\u306E\u9577\u3055\u304C\
    \u5217\u6570\u4EE5\u4E0B\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\"\n        a.setRowBitsUnchecked(i, values)\n\n    proc rowBits*(a: MatrixMod2,\
    \ i, width: int): string =\n        assert i in 0..<a.height and width in 0..a.width,\
    \ \"\u884C\u756A\u53F7\u304C\u7BC4\u56F2\u5185\u3067\u3001\u6307\u5B9A\u3057\u305F\
    \u884C\u306E\u9577\u3055\u304C\u5217\u6570\u4EE5\u4E0B\u3067\u3042\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\"\n        a.rowBitsUnchecked(i, width)\n\
    \n    proc rowBits*(a: MatrixMod2, i: int): string =\n        a.rowBits(i, a.width)\n\
    \n    proc identityMatrixMod2*(n: int): MatrixMod2 =\n        result = initMatrixMod2(n,\
    \ n)\n        for i in 0..<n: result[i, i] = true\n\n    proc transposed*(a: MatrixMod2):\
    \ MatrixMod2 =\n        result = initMatrixMod2(a.width, a.height)\n        for\
    \ i in 0..<a.height:\n            for j in 0..<a.width:\n                if a[i,\
    \ j]: result[j, i] = true\n\n    {.push checks: off.}\n    proc multiplyUnchecked(a,\
    \ b: MatrixMod2): MatrixMod2 =\n        result = initMatrixMod2(a.height, b.width)\n\
    \        if a.height < 40 or a.width < 64:\n            let bt = b.transposed()\n\
    \            for i in 0..<a.height:\n                for j in 0..<b.width:\n \
    \                   var parity = 0\n                    for k in 0..<a.stride:\n\
    \                        parity = parity xor ((word(a, i, k) and word(bt, j, k)).countSetBits\
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
    \                        unsafeAddr word(b, blockStart + bit, 0))\n          \
    \          for k in 0..<wordCount:\n                        tableData[offset +\
    \ k] = tableData[previousOffset + k] xor bRow[k]\n                let shift =\
    \ blockStart and 63\n                let mask = uint64((1 shl bits) - 1)\n   \
    \             for i in 0..<a.height:\n                    let aRow = cast[ptr\
    \ UncheckedArray[uint64]](unsafeAddr word(a, i, 0))\n                    let resultRow\
    \ = cast[ptr UncheckedArray[uint64]](word(result, i, 0).addr)\n              \
    \      let index = int((aRow[blockStart shr 6] shr shift) and mask)\n        \
    \            let offset = index * wordCount\n                    for k in 0..<wordCount:\n\
    \                        resultRow[k] = resultRow[k] xor tableData[offset + k]\n\
    \                blockStart += BlockBits\n    {.pop.}\n\n    proc `*`*(a, b: MatrixMod2):\
    \ MatrixMod2 =\n        assert a.width == b.height, \"\u5DE6\u306E\u884C\u5217\
    \u306E\u5217\u6570\u3068\u53F3\u306E\u884C\u5217\u306E\u884C\u6570\u306F\u7B49\
    \u3057\u3044\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        multiplyUnchecked(a,\
    \ b)\n\n    proc `*=`*(a: var MatrixMod2, b: MatrixMod2) = a = a * b\n\n    proc\
    \ pow*(a: MatrixMod2, exponent: int): MatrixMod2 =\n        assert a.height ==\
    \ a.width and exponent >= 0, \"\u884C\u5217\u306F\u6B63\u65B9\u884C\u5217\u3067\
    \u3001\u6307\u6570\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n        result = identityMatrixMod2(a.height)\n        var\
    \ base = a\n        var e = exponent\n        while e > 0:\n            if (e\
    \ and 1) != 0: result *= base\n            e = e shr 1\n            if e > 0:\
    \ base *= base\n\n    proc `**`*(a: MatrixMod2, exponent: int): MatrixMod2 = a.pow(exponent)\n\
    \n    proc rankSimple(a: MatrixMod2): int =\n        ## \u968E\u6570\u3092O(h*w+h*min(h,w)*ceil(w/64))\u3067\
    \u6C42\u3081\u308B\u3002\u5143\u306E\u884C\u5217\u306F\u5909\u66F4\u305B\u305A\
    \u3001\u7A7A\u884C\u5217\u306FO(1)\u3067\u8FD4\u3059\u3002\n        if a.height\
    \ == 0 or a.width == 0: return 0\n        var b = a\n        let data = cast[ptr\
    \ UncheckedArray[uint64]](addr b.words[0])\n        for col in 0..<b.width:\n\
    \            let firstWord = col shr 6\n            let mask = 1'u64 shl (col\
    \ and 63)\n            var pivot = result\n            while pivot < b.height\
    \ and (data[pivot * b.stride + firstWord] and mask) == 0: inc pivot\n        \
    \    if pivot == b.height: continue\n            if result + 1 == min(b.height,\
    \ b.width): return result + 1\n            let pivotRow = cast[ptr UncheckedArray[uint64]](addr\
    \ data[result * b.stride])\n            # \u672A\u51E6\u7406\u306E\u884C\u306F\
    \u73FE\u5728\u306E\u5217\u3088\u308A\u524D\u304C\u3059\u3079\u3066\u96F6\u306A\
    \u306E\u3067\u3001\u73FE\u5728\u306E\u30EF\u30FC\u30C9\u4EE5\u964D\u3060\u3051\
    \u64CD\u4F5C\u3059\u308B\u3002\n            if pivot != result:\n            \
    \    for k in firstWord..<b.stride: swap(pivotRow[k], data[pivot * b.stride +\
    \ k])\n            for i in result + 1..<b.height:\n                let row =\
    \ cast[ptr UncheckedArray[uint64]](addr data[i * b.stride])\n                if\
    \ (row[firstWord] and mask) != 0:\n                    for k in firstWord..<b.stride:\
    \ row[k] = row[k] xor pivotRow[k]\n            inc result\n            if result\
    \ == b.height: break\n\n    proc rankBlocked(a: MatrixMod2): int =\n        ##\
    \ 256\u884C\u4EE5\u4E0A\u306E\u884C\u5217\u30928\u5217\u305A\u3064\u6D88\u53BB\
    \u3059\u308B\u3002\u7D44\u5408\u305B\u8868\u306E\u9818\u57DF\u306F\u884C\u5217\
    \u306E\u30B3\u30D4\u30FC\u4EE5\u4E0B\u3002\n        if a.height == 0 or a.width\
    \ == 0: return 0\n        var b = a\n        let stride = b.stride\n        let\
    \ data = cast[ptr UncheckedArray[uint64]](addr b.words[0])\n        var table\
    \ = newSeq[uint64](256 * stride)\n        let tableData = cast[ptr UncheckedArray[uint64]](addr\
    \ table[0])\n        var col = 0\n        while col < b.width and result < b.height:\n\
    \            let firstWord = col shr 6\n            let shift = col and 63\n \
    \           let bits = min(8, b.width - col)\n            let mask = (1'u64 shl\
    \ bits) - 1\n            let base = result\n            var count = 0\n      \
    \      var patterns, pivotMasks: array[8, int]\n            # \u3053\u306E8\u5217\
    \u3067\u72EC\u7ACB\u306A\u884C\u3092\u9078\u3073\u3001\u65E2\u306B\u9078\u3093\
    \u3060\u884C\u3060\u3051\u3067\u30D4\u30DC\u30C3\u30C8\u884C\u3092\u6D88\u53BB\
    \u3059\u308B\u3002\n            for i in base..<b.height:\n                var\
    \ pattern = int((data[i * stride + firstWord] shr shift) and mask)\n         \
    \       var combination = 0\n                for j in 0..<count:\n           \
    \         if (pattern and pivotMasks[j]) != 0:\n                        pattern\
    \ = pattern xor patterns[j]\n                        combination = combination\
    \ or (1 shl j)\n                if pattern == 0: continue\n                let\
    \ row = cast[ptr UncheckedArray[uint64]](addr data[(base + count) * stride])\n\
    \                if i != base + count:\n                    for k in firstWord..<stride:\
    \ swap(row[k], data[i * stride + k])\n                for j in 0..<count:\n  \
    \                  if (combination and (1 shl j)) != 0:\n                    \
    \    let pivot = cast[ptr UncheckedArray[uint64]](addr data[(base + j) * stride])\n\
    \                        for k in firstWord..<stride: row[k] = row[k] xor pivot[k]\n\
    \                patterns[count] = pattern\n                pivotMasks[count]\
    \ = pattern and -pattern\n                inc count\n                if count\
    \ == bits: break\n            result += count\n            if result == b.width:\
    \ return\n            if count > 0 and result < b.height:\n                # \u5217\
    \u306E\u30D3\u30C3\u30C8\u30D1\u30BF\u30FC\u30F3\u304B\u3089\u3001\u5BFE\u5FDC\
    \u3059\u308B\u30D4\u30DC\u30C3\u30C8\u884C\u306EXOR\u3092\u5F15\u3051\u308B\u3088\
    \u3046\u306B\u3059\u308B\u3002\n                var offsets, combined: array[256,\
    \ int]\n                for index in 1..<(1 shl count):\n                    let\
    \ previous = index and (index - 1)\n                    let bit = countTrailingZeroBits(index)\n\
    \                    combined[index] = combined[previous] xor patterns[bit]\n\
    \                    let offset = index * stride\n                    offsets[combined[index]]\
    \ = offset\n                    let pivot = cast[ptr UncheckedArray[uint64]](addr\
    \ data[(base + bit) * stride])\n                    for k in firstWord..<stride:\n\
    \                        tableData[offset + k] = tableData[previous * stride +\
    \ k] xor pivot[k]\n                for i in result..<b.height:\n             \
    \       let row = cast[ptr UncheckedArray[uint64]](addr data[i * stride])\n  \
    \                  let pattern = int((row[firstWord] shr shift) and mask)\n  \
    \                  if pattern == 0: continue\n                    let offset =\
    \ offsets[pattern]\n                    for k in firstWord..<stride: row[k] =\
    \ row[k] xor tableData[offset + k]\n            col += bits\n\n    {.push checks:\
    \ off.}\n    proc rankTall(a: MatrixMod2, limit: int): int =\n        ## \u5148\
    \u982Dlimit\u884C\u306E\u57FA\u5E95\u3067\u968E\u6570\u3092\u8ABF\u3079\u3001\u672A\
    \u78BA\u5B9A\u306A\u3089-1\u3092\u8FD4\u3059\u3002O(limit*w*ceil(w/64))\u6642\u9593\
    \u3001O(w*ceil(w/64))\u8FFD\u52A0\u7A7A\u9593\u3002\n        if a.width >= 256:\n\
    \            var sample = initMatrixMod2(limit, a.width)\n            copyMem(addr\
    \ sample.words[0], unsafeAddr a.words[0], limit * a.stride * sizeof(uint64))\n\
    \            result = rankBlocked(sample)\n            if result < a.width and\
    \ limit < a.height: result = -1\n            return\n        let stride = a.stride\n\
    \        let source = cast[ptr UncheckedArray[uint64]](unsafeAddr a.words[0])\n\
    \        var basis = newSeq[uint64](a.width * stride)\n        var pivots = newSeq[int](a.width)\n\
    \        var buffer = newSeq[uint64](stride)\n        let basisData = cast[ptr\
    \ UncheckedArray[uint64]](addr basis[0])\n        let row = cast[ptr UncheckedArray[uint64]](addr\
    \ buffer[0])\n        for i in 0..<limit:\n            let input = cast[ptr UncheckedArray[uint64]](unsafeAddr\
    \ source[i * stride])\n            var firstWord = 0\n            while firstWord\
    \ < stride and input[firstWord] == 0: inc firstWord\n            if firstWord\
    \ == stride: continue\n            copyMem(addr row[firstWord], unsafeAddr input[firstWord],\
    \ (stride - firstWord) * sizeof(uint64))\n            block insertRow:\n     \
    \           for k in firstWord..<stride:\n                    while row[k] !=\
    \ 0:\n                        let col = (k shl 6) + countTrailingZeroBits(row[k])\n\
    \                        let index = pivots[col]\n                        if index\
    \ == 0:\n                            copyMem(addr basisData[result * stride +\
    \ k], addr row[k], (stride - k) * sizeof(uint64))\n                          \
    \  inc result\n                            pivots[col] = result\n            \
    \                if result == a.width: return\n                            break\
    \ insertRow\n                        let pivot = cast[ptr UncheckedArray[uint64]](addr\
    \ basisData[(index - 1) * stride])\n                        for j in k..<stride:\
    \ row[j] = row[j] xor pivot[j]\n        if limit < a.height: result = -1\n   \
    \ {.pop.}\n\n    proc rank*(a: MatrixMod2): int =\n        ## \u968E\u6570\u3092\
    O(h*w+h*min(h,w)*ceil(w/64))\u3067\u6C42\u3081\u308B\u3002\u5143\u306E\u884C\u5217\
    \u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        ## \u7E26\u9577\u884C\u5217\
    \u306F\u5148\u982D\u306E\u884C\u3067\u6700\u5927\u968E\u6570\u3092\u78BA\u8A8D\
    \u3067\u304D\u308C\u3070\u7D42\u4E86\u3057\u3001\u672A\u78BA\u5B9A\u306A\u3089\
    \u901A\u5E38\u306E\u6D88\u53BB\u6CD5\u3092\u4F7F\u3046\u3002\u7A7A\u884C\u5217\
    \u306FO(1)\u3002\n        if a.height == 0 or a.width == 0: return 0\n       \
    \ if a.height div 2 >= a.width:\n            let limit = if a.width < 8: a.height\
    \ else: a.width + min(32, a.height - a.width)\n            let candidate = rankTall(a,\
    \ limit)\n            if candidate >= 0: return candidate\n        if a.height\
    \ < 256 or a.width < 8: rankSimple(a)\n        else: rankBlocked(a)\n\n    proc\
    \ determinant*(a: MatrixMod2): bool =\n        assert a.height == a.width, \"\u884C\
    \u5217\u306F\u6B63\u65B9\u884C\u5217\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n        a.rank == a.height\n\n    proc inverse*(a: MatrixMod2):\
    \ Option[MatrixMod2] =\n        ## 64bit\u5358\u4F4D\u306E\u6383\u304D\u51FA\u3057\
    \u6CD5\u3067\u9006\u884C\u5217\u3092\u6C42\u3081\u308B\u3002O(n^2*ceil(n/64))\u3002\
    \u7279\u7570\u884C\u5217\u306Fnone\u3002\n        ## \u5143\u306E\u884C\u5217\u306F\
    \u5909\u66F4\u3057\u306A\u3044\u3002\u4F5C\u696D\u9818\u57DF\u306FO(n*ceil(n/64))\u3002\
    \n        assert a.height == a.width, \"\u884C\u5217\u306F\u6B63\u65B9\u884C\u5217\
    \u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        let n\
    \ = a.height\n        if n == 0: return some(initMatrixMod2(0, 0))\n        #\
    \ \u53F3\u5074\u306E\u5358\u4F4D\u884C\u5217\u309264bit\u5883\u754C\u306B\u7F6E\
    \u304D\u3001\u5165\u51FA\u529B\u3092\u30EF\u30FC\u30C9\u5358\u4F4D\u3067\u30B3\
    \u30D4\u30FC\u3059\u308B\u3002\n        let rightStart = a.stride\n        let\
    \ stride = 2 * rightStart\n        assert n <= high(int) div sizeof(uint64) div\
    \ stride, \"\u884C\u5217\u306E\u8A18\u61B6\u9818\u57DF\u306E\u30B5\u30A4\u30BA\
    \u304Cint\u306E\u7BC4\u56F2\u3092\u8D85\u3048\u3066\u3044\u307E\u3059\"\n    \
    \    var storage = newSeq[uint64](n * stride)\n        let data = cast[ptr UncheckedArray[uint64]](addr\
    \ storage[0])\n        for i in 0..<n:\n            copyMem(addr data[i * stride],\
    \ unsafeAddr a.words[i * rightStart], rightStart * sizeof(uint64))\n         \
    \   data[i * stride + rightStart + (i shr 6)] = 1'u64 shl (i and 63)\n       \
    \ for col in 0..<n:\n            let firstWord = col shr 6\n            let mask\
    \ = 1'u64 shl (col and 63)\n            var pivot = col\n            while pivot\
    \ < n and (data[pivot * stride + firstWord] and mask) == 0: inc pivot\n      \
    \      if pivot == n: return none(MatrixMod2)\n            let pivotRow = cast[ptr\
    \ UncheckedArray[uint64]](addr data[col * stride])\n            if pivot != col:\n\
    \                for k in firstWord..<stride: swap(pivotRow[k], data[pivot * stride\
    \ + k])\n            for i in 0..<n:\n                if i == col: continue\n\
    \                let row = cast[ptr UncheckedArray[uint64]](addr data[i * stride])\n\
    \                if (row[firstWord] and mask) != 0:\n                    for k\
    \ in firstWord..<stride: row[k] = row[k] xor pivotRow[k]\n        var inv = initMatrixMod2(n,\
    \ n)\n        for i in 0..<n:\n            copyMem(addr inv.words[i * rightStart],\
    \ addr data[i * stride + rightStart], rightStart * sizeof(uint64))\n        some(inv)\n\
    \n    import cplib/matrix/field_matrix_ops\n    import cplib/matrix/bit_matrix_ops\n\
    \    export LinearSystemSolution\n\n    proc solveLinearSystem*(a: MatrixMod2,\
    \ b: openArray[bool]): Option[LinearSystemSolution[bool]] =\n        ## \u30D3\
    \u30C3\u30C8\u6F14\u7B97\u3067Ax=b\u306E\u7279\u6B8A\u89E3\u3068\u6838\u306E\u57FA\
    \u5E95\u3092\u8FD4\u3059\u3002O(h*min(h,w)*(w div 64+1)+w^2)\u3002\n        ##\
    \ \u5143\u306E\u884C\u5217\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\u89E3\u306A\
    \u3057\u306Fnone\u3001\u57FA\u5E95\u306E\u500B\u6570\u306Fw-rank\u3002\n     \
    \   assert b.len == a.height, \"\u53F3\u8FBA\u306E\u8981\u7D20\u6570\u306F\u884C\
    \u5217\u306E\u884C\u6570\u3068\u4E00\u81F4\u3059\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n        var rows = initBitLinearSystem(a.height, a.width)\n\
    \        let stride = (a.width shr 6) + 1\n        for i in 0..<a.height:\n  \
    \          for k in 0..<a.stride: rows[i * stride + k] = word(a, i, k)\n     \
    \       if b[i]: rows[i * stride + (a.width shr 6)] = rows[i * stride + (a.width\
    \ shr 6)] or (1'u64 shl (a.width and 63))\n        solveBitLinearSystem(rows,\
    \ a.height, a.width)\n\n    proc hafnian*(a: MatrixMod2): bool =\n        ## GF(2)\u4E0A\
    \u306E\u5BFE\u79F0\u306A\u5076\u6570\u6B21\u884C\u5217\u306Ehafnian\u3092\u6C42\
    \u3081\u308B\u3002O(n^3)\u3002\n        assert a.h == a.w, \"\u884C\u5217\u306F\
    \u6B63\u65B9\u884C\u5217\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\"\n        fieldHafnian(matrixRows(a, a.h, a.w))\n\n    proc adjugate*(a:\
    \ MatrixMod2): MatrixMod2 =\n        ## GF(2)\u4E0A\u3067\u7279\u7570\u884C\u5217\
    \u3082\u542B\u3081\u305F\u4F59\u56E0\u5B50\u884C\u5217\u3092\u6C42\u3081\u308B\
    \u3002O(n^3)\u3002\n        assert a.h == a.w, \"\u884C\u5217\u306F\u6B63\u65B9\
    \u884C\u5217\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       let rows = fieldAdjugateInverse(matrixRows(a, a.h, a.w), true).get\n \
    \       result = initMatrixMod2(a.h, a.w)\n        for i in 0..<a.h:\n       \
    \     for j in 0..<a.w: result[i, j] = rows[i][j]\n"
  dependsOn:
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  isVerificationFile: false
  path: cplib/matrix/matrix_mod2.nim
  requiredBy:
  - verify/matrix/linear_algebra/system_mod2_driver.nim
  - verify/matrix/linear_algebra/system_mod2_driver.nim
  timestamp: '2026-09-30 06:48:27+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/matrix/inverse_matrix_mod_2_test.nim
  - verify/matrix/inverse_matrix_mod_2_test.nim
  - verify/matrix/matrix_mod2_rank_unit_test.nim
  - verify/matrix/matrix_mod2_rank_unit_test.nim
  - verify/matrix/matrix_rank_mod_2_test.nim
  - verify/matrix/matrix_rank_mod_2_test.nim
  - verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
  - verify/matrix/matrix_mod2_field_algorithms_unit_test.nim
  - verify/matrix/matrix_product_mod_2_test.nim
  - verify/matrix/matrix_product_mod_2_test.nim
  - verify/matrix/matrix_det_mod_2_test.nim
  - verify/matrix/matrix_det_mod_2_test.nim
documentation_of: cplib/matrix/matrix_mod2.nim
layout: document
redirect_from:
- /library/cplib/matrix/matrix_mod2.nim
- /library/cplib/matrix/matrix_mod2.nim.html
title: cplib/matrix/matrix_mod2.nim
---
