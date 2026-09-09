---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
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
    path: verify/matrix/matrix_det_mod_2_static_test.nim
    title: verify/matrix/matrix_det_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_det_mod_2_static_test.nim
    title: verify/matrix/matrix_det_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_mod_2_static_test.nim
    title: verify/matrix/matrix_product_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_mod_2_static_test.nim
    title: verify/matrix/matrix_product_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_rank_mod_2_static_test.nim
    title: verify/matrix/matrix_rank_mod_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_rank_mod_2_static_test.nim
    title: verify/matrix/matrix_rank_mod_2_static_test.nim
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
  code: "when not declared CPLIB_MATRIX_STATIC_MATRIX_MOD2:\n    const CPLIB_MATRIX_STATIC_MATRIX_MOD2*\
    \ = 1\n\n    import bitops,options\n\n    type StaticMatrixMod2*[H: static int,\
    \ W: static int] = object\n        ## A compile-time-sized matrix over GF(2).\n\
    \        rows: array[H, array[(W + 63) div 64, uint64]]\n\n    proc initStaticMatrixMod2*[H:\
    \ static int, W: static int](): StaticMatrixMod2[H, W] = discard\n\n    proc initStaticMatrixMod2*[H:\
    \ static int, W: static int, T: SomeInteger](\n            a: array[H, array[W,\
    \ T]]): StaticMatrixMod2[H, W] =\n        for i in 0..<H:\n            for j in\
    \ 0..<W:\n                if (a[i][j] and 1) != 0:\n                    result.rows[i][j\
    \ shr 6] = result.rows[i][j shr 6] or (1'u64 shl (j and 63))\n\n    proc initStaticMatrixMod2*[H:\
    \ static int, W: static int](\n            a: array[H, array[W, bool]]): StaticMatrixMod2[H,\
    \ W] =\n        for i in 0..<H:\n            for j in 0..<W:\n               \
    \ if a[i][j]: result.rows[i][j shr 6] = result.rows[i][j shr 6] or (1'u64 shl\
    \ (j and 63))\n\n    proc toStaticMatrixMod2*[H: static int, W: static int, T](\n\
    \            a: array[H, array[W, T]]): StaticMatrixMod2[H, W] = initStaticMatrixMod2(a)\n\
    \    proc h*[H: static int, W: static int](a: StaticMatrixMod2[H, W]): int {.inline.}\
    \ = H\n    proc w*[H: static int, W: static int](a: StaticMatrixMod2[H, W]): int\
    \ {.inline.} = W\n\n    proc `[]`*[H: static int, W: static int](a: StaticMatrixMod2[H,\
    \ W], i, j: int): bool {.inline.} =\n        assert i in 0..<H and j in 0..<W\n\
    \        (a.rows[i][j shr 6] and (1'u64 shl (j and 63))) != 0\n\n    proc `[]=`*[H:\
    \ static int, W: static int](a: var StaticMatrixMod2[H, W], i, j: int, x: bool)\
    \ {.inline.} =\n        assert i in 0..<H and j in 0..<W\n        let mask = 1'u64\
    \ shl (j and 63)\n        if x: a.rows[i][j shr 6] = a.rows[i][j shr 6] or mask\n\
    \        else: a.rows[i][j shr 6] = a.rows[i][j shr 6] and not mask\n\n    proc\
    \ `[]=`*[H: static int, W: static int, T: SomeInteger](a: var StaticMatrixMod2[H,\
    \ W], i, j: int, x: T) =\n        a[i, j] = (x and 1) != 0\n\n    proc `==`*[H:\
    \ static int, W: static int](a, b: StaticMatrixMod2[H, W]): bool = a.rows == b.rows\n\
    \n    proc `$`*[H: static int, W: static int](a: StaticMatrixMod2[H, W]): string\
    \ =\n        for i in 0..<H:\n            if i > 0: result.add '\\n'\n       \
    \     for j in 0..<W:\n                if j > 0: result.add ' '\n            \
    \    result.add(if a[i, j]: '1' else: '0')\n\n    {.push checks: off.}\n    proc\
    \ setRowBitsUnchecked[H: static int, W: static int](\n            a: var StaticMatrixMod2[H,\
    \ W], i: int, values: string) =\n        for k in 0..<a.rows[i].len:\n       \
    \     a.rows[i][k] = 0\n        for j in 0..<values.len:\n            if values[j]\
    \ == '1':\n                a.rows[i][j shr 6] = a.rows[i][j shr 6] or (1'u64 shl\
    \ (j and 63))\n\n    proc rowBitsUnchecked[H: static int, W: static int](\n  \
    \          a: StaticMatrixMod2[H, W], i, width: int): string =\n        result\
    \ = newString(width)\n        for j in 0..<width:\n            result[j] = char(ord('0')\
    \ + int((a.rows[i][j shr 6] shr (j and 63)) and 1))\n    {.pop.}\n\n    proc setRowBits*[H:\
    \ static int, W: static int](\n            a: var StaticMatrixMod2[H, W], i: int,\
    \ values: string) =\n        assert i in 0..<H and values.len <= W\n        a.setRowBitsUnchecked(i,\
    \ values)\n\n    proc rowBits*[H: static int, W: static int](\n            a:\
    \ StaticMatrixMod2[H, W], i, width: int): string =\n        assert i in 0..<H\
    \ and width in 0..W\n        a.rowBitsUnchecked(i, width)\n\n    proc rowBits*[H:\
    \ static int, W: static int](\n            a: StaticMatrixMod2[H, W], i: int):\
    \ string =\n        a.rowBits(i, W)\n\n    proc identityStaticMatrixMod2*[N: static\
    \ int](): StaticMatrixMod2[N, N] =\n        for i in 0..<N: result[i, i] = true\n\
    \n    proc transposed*[H: static int, W: static int](a: StaticMatrixMod2[H, W]):\
    \ StaticMatrixMod2[W, H] =\n        for i in 0..<H:\n            for j in 0..<W:\n\
    \                if a[i, j]: result[j, i] = true\n\n    {.push checks: off.}\n\
    \    proc `*`*[H: static int, M: static int, W: static int](a: StaticMatrixMod2[H,\
    \ M], b: StaticMatrixMod2[M, W]): StaticMatrixMod2[H, W] =\n        when H < 40\
    \ or M < 64:\n            let bt = b.transposed()\n            for i in 0..<H:\n\
    \                for j in 0..<W:\n                    var parity = 0\n       \
    \             for k in 0..<a.rows[i].len:\n                        parity = parity\
    \ xor ((a.rows[i][k] and bt.rows[j][k]).countSetBits and 1)\n                \
    \    if parity != 0: result[i, j] = true\n        else:\n            # Method\
    \ of Four Russians: process eight columns of a at once and\n            # look\
    \ up the corresponding xor of rows of b.\n            const\n                BlockBits\
    \ = 8\n                WordCount = (W + 63) div 64\n            var table: array[1\
    \ shl BlockBits, array[WordCount, uint64]]\n            var blockStart = 0\n \
    \           while blockStart < M:\n                let bits = min(BlockBits, M\
    \ - blockStart)\n                for mask in 1..<(1 shl bits):\n             \
    \       let previous = mask and (mask - 1)\n                    let bit = mask.countTrailingZeroBits\n\
    \                    for k in 0..<WordCount:\n                        table[mask][k]\
    \ = table[previous][k] xor b.rows[blockStart + bit][k]\n                let shift\
    \ = blockStart and 63\n                let mask = uint64((1 shl bits) - 1)\n \
    \               for i in 0..<H:\n                    let index = int((a.rows[i][blockStart\
    \ shr 6] shr shift) and mask)\n                    for k in 0..<WordCount:\n \
    \                       result.rows[i][k] = result.rows[i][k] xor table[index][k]\n\
    \                blockStart += BlockBits\n    {.pop.}\n\n    proc `*=`*[N: static\
    \ int](a: var StaticMatrixMod2[N, N], b: StaticMatrixMod2[N, N]) = a = a * b\n\
    \n    proc pow*[N: static int](a: StaticMatrixMod2[N, N], exponent: int): StaticMatrixMod2[N,\
    \ N] =\n        assert exponent >= 0\n        result = identityStaticMatrixMod2[N]()\n\
    \        var base = a\n        var e = exponent\n        while e > 0:\n      \
    \      if (e and 1) != 0: result *= base\n            e = e shr 1\n          \
    \  if e > 0: base *= base\n\n    proc `**`*[N: static int](a: StaticMatrixMod2[N,\
    \ N], exponent: int): StaticMatrixMod2[N, N] = a.pow(exponent)\n\n    proc rank*[H:\
    \ static int, W: static int](a: StaticMatrixMod2[H, W]): int =\n        var storage:\
    \ ref StaticMatrixMod2[H, W]\n        new storage\n        storage[] = a\n   \
    \     template b: untyped = storage[]\n        for col in 0..<W:\n           \
    \ var pivot = result\n            while pivot < H and not b[pivot, col]: inc pivot\n\
    \            if pivot == H: continue\n            swap(b.rows[result], b.rows[pivot])\n\
    \            for i in result + 1..<H:\n                if b[i, col]:\n       \
    \             for k in 0..<b.rows[i].len: b.rows[i][k] = b.rows[i][k] xor b.rows[result][k]\n\
    \            inc result\n            if result == H: break\n\n    proc determinant*[N:\
    \ static int](a: StaticMatrixMod2[N, N]): bool = a.rank == N\n\n    proc inverse*[N:\
    \ static int](a: StaticMatrixMod2[N, N]): Option[StaticMatrixMod2[N, N]] =\n \
    \       var left = a\n        var right = identityStaticMatrixMod2[N]()\n    \
    \    for col in 0..<N:\n            var pivot = col\n            while pivot <\
    \ N and not left[pivot, col]: inc pivot\n            if pivot == N: return none(StaticMatrixMod2[N,\
    \ N])\n            swap(left.rows[col], left.rows[pivot])\n            swap(right.rows[col],\
    \ right.rows[pivot])\n            for i in 0..<N:\n                if i != col\
    \ and left[i, col]:\n                    for k in 0..<left.rows[i].len: left.rows[i][k]\
    \ = left.rows[i][k] xor left.rows[col][k]\n                    for k in 0..<right.rows[i].len:\
    \ right.rows[i][k] = right.rows[i][k] xor right.rows[col][k]\n        some(right)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/matrix/static_matrix_mod2.nim
  requiredBy: []
  timestamp: '2026-07-16 14:14:09+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/static_matrix_mod2_test.nim
  - verify/AI/static_matrix_mod2_test.nim
  - verify/matrix/matrix_rank_mod_2_static_test.nim
  - verify/matrix/matrix_rank_mod_2_static_test.nim
  - verify/matrix/inverse_matrix_mod_2_static_test.nim
  - verify/matrix/inverse_matrix_mod_2_static_test.nim
  - verify/matrix/matrix_det_mod_2_static_test.nim
  - verify/matrix/matrix_det_mod_2_static_test.nim
  - verify/matrix/matrix_product_mod_2_static_test.nim
  - verify/matrix/matrix_product_mod_2_static_test.nim
documentation_of: cplib/matrix/static_matrix_mod2.nim
layout: document
redirect_from:
- /library/cplib/matrix/static_matrix_mod2.nim
- /library/cplib/matrix/static_matrix_mod2.nim.html
title: cplib/matrix/static_matrix_mod2.nim
---
