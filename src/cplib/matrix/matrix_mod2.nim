when not declared CPLIB_MATRIX_MATRIX_MOD2:
    const CPLIB_MATRIX_MATRIX_MOD2* = 1

    import bitops,options

    type MatrixMod2* = object
        ## GF(2)上の可変サイズ行列。各行を64bit境界に揃えた連続配列で保持する。
        height, width, stride: int
        words: seq[uint64]

    proc initMatrixMod2*(h, w: int): MatrixMod2 =
        ## h行w列の零行列をO(h*ceil(w/64))時間・空間で作る。行ごとの確保は行わない。
        assert h >= 0 and w >= 0
        let stride = (w shr 6) + int((w and 63) != 0)
        assert stride == 0 or h <= high(int) div sizeof(uint64) div stride
        result.height = h
        result.width = w
        result.stride = stride
        result.words = newSeq[uint64](h * stride)

    template word(a: MatrixMod2, i, k: int): untyped =
        a.words[i * a.stride + k]

    proc swapRows(a: var MatrixMod2, i, j: int) =
        ## 指定した2行をO(ceil(w/64))で交換する。
        if i == j: return
        for k in 0..<a.stride: swap(word(a, i, k), word(a, j, k))

    proc initMatrixMod2*[T: SomeInteger](a: openArray[seq[T]]): MatrixMod2 =
        let w = if a.len == 0: 0 else: a[0].len
        result = initMatrixMod2(a.len, w)
        for i in 0..<a.len:
            assert a[i].len == w
            for j, x in a[i]:
                if (x and 1) != 0:
                    word(result, i, j shr 6) = word(result, i, j shr 6) or (1'u64 shl (j and 63))

    proc initMatrixMod2*(a: openArray[seq[bool]]): MatrixMod2 =
        let w = if a.len == 0: 0 else: a[0].len
        result = initMatrixMod2(a.len, w)
        for i in 0..<a.len:
            assert a[i].len == w
            for j, x in a[i]:
                if x: word(result, i, j shr 6) = word(result, i, j shr 6) or (1'u64 shl (j and 63))

    proc toMatrixMod2*[T](a: openArray[seq[T]]): MatrixMod2 = initMatrixMod2(a)
    proc h*(a: MatrixMod2): int {.inline.} = a.height
    proc w*(a: MatrixMod2): int {.inline.} = a.width

    proc `[]`*(a: MatrixMod2, i, j: int): bool {.inline.} =
        assert i in 0..<a.height and j in 0..<a.width
        (word(a, i, j shr 6) and (1'u64 shl (j and 63))) != 0

    proc `[]=`*(a: var MatrixMod2, i, j: int, x: bool) {.inline.} =
        assert i in 0..<a.height and j in 0..<a.width
        let mask = 1'u64 shl (j and 63)
        if x: word(a, i, j shr 6) = word(a, i, j shr 6) or mask
        else: word(a, i, j shr 6) = word(a, i, j shr 6) and not mask

    proc `[]=`*[T: SomeInteger](a: var MatrixMod2, i, j: int, x: T) {.inline.} =
        a[i, j] = (x and 1) != 0

    proc `==`*(a, b: MatrixMod2): bool =
        a.height == b.height and a.width == b.width and a.words == b.words

    proc `$`*(a: MatrixMod2): string =
        for i in 0..<a.height:
            if i > 0: result.add '\n'
            for j in 0..<a.width:
                if j > 0: result.add ' '
                result.add(if a[i, j]: '1' else: '0')

    {.push checks: off.}
    proc setRowBitsUnchecked(a: var MatrixMod2, i: int, values: string) =
        for k in 0..<a.stride:
            word(a, i, k) = 0
        for j in 0..<values.len:
            if values[j] == '1':
                word(a, i, j shr 6) = word(a, i, j shr 6) or (1'u64 shl (j and 63))

    proc rowBitsUnchecked(a: MatrixMod2, i, width: int): string =
        result = newString(width)
        for j in 0..<width:
            result[j] = char(ord('0') + int((word(a, i, j shr 6) shr (j and 63)) and 1))
    {.pop.}

    proc setRowBits*(a: var MatrixMod2, i: int, values: string) =
        assert i in 0..<a.height and values.len <= a.width
        a.setRowBitsUnchecked(i, values)

    proc rowBits*(a: MatrixMod2, i, width: int): string =
        assert i in 0..<a.height and width in 0..a.width
        a.rowBitsUnchecked(i, width)

    proc rowBits*(a: MatrixMod2, i: int): string =
        a.rowBits(i, a.width)

    proc identityMatrixMod2*(n: int): MatrixMod2 =
        result = initMatrixMod2(n, n)
        for i in 0..<n: result[i, i] = true

    proc transposed*(a: MatrixMod2): MatrixMod2 =
        result = initMatrixMod2(a.width, a.height)
        for i in 0..<a.height:
            for j in 0..<a.width:
                if a[i, j]: result[j, i] = true

    {.push checks: off.}
    proc multiplyUnchecked(a, b: MatrixMod2): MatrixMod2 =
        result = initMatrixMod2(a.height, b.width)
        if a.height < 40 or a.width < 64:
            let bt = b.transposed()
            for i in 0..<a.height:
                for j in 0..<b.width:
                    var parity = 0
                    for k in 0..<a.stride:
                        parity = parity xor ((word(a, i, k) and word(bt, j, k)).countSetBits and 1)
                    if parity != 0: result[i, j] = true
        else:
            # Method of Four Russians: process eight columns of a at once and
            # look up the corresponding xor of rows of b.
            const BlockBits = 8
            let wordCount = (b.width + 63) div 64
            if wordCount == 0: return
            var table = newSeq[uint64]((1 shl BlockBits) * wordCount)
            let tableData = cast[ptr UncheckedArray[uint64]](table[0].addr)
            var blockStart = 0
            while blockStart < a.width:
                let bits = min(BlockBits, a.width - blockStart)
                for mask in 1..<(1 shl bits):
                    let previous = mask and (mask - 1)
                    let bit = mask.countTrailingZeroBits
                    let offset = mask * wordCount
                    let previousOffset = previous * wordCount
                    let bRow = cast[ptr UncheckedArray[uint64]](
                        unsafeAddr word(b, blockStart + bit, 0))
                    for k in 0..<wordCount:
                        tableData[offset + k] = tableData[previousOffset + k] xor bRow[k]
                let shift = blockStart and 63
                let mask = uint64((1 shl bits) - 1)
                for i in 0..<a.height:
                    let aRow = cast[ptr UncheckedArray[uint64]](unsafeAddr word(a, i, 0))
                    let resultRow = cast[ptr UncheckedArray[uint64]](word(result, i, 0).addr)
                    let index = int((aRow[blockStart shr 6] shr shift) and mask)
                    let offset = index * wordCount
                    for k in 0..<wordCount:
                        resultRow[k] = resultRow[k] xor tableData[offset + k]
                blockStart += BlockBits
    {.pop.}

    proc `*`*(a, b: MatrixMod2): MatrixMod2 =
        assert a.width == b.height
        multiplyUnchecked(a, b)

    proc `*=`*(a: var MatrixMod2, b: MatrixMod2) = a = a * b

    proc pow*(a: MatrixMod2, exponent: int): MatrixMod2 =
        assert a.height == a.width and exponent >= 0
        result = identityMatrixMod2(a.height)
        var base = a
        var e = exponent
        while e > 0:
            if (e and 1) != 0: result *= base
            e = e shr 1
            if e > 0: base *= base

    proc `**`*(a: MatrixMod2, exponent: int): MatrixMod2 = a.pow(exponent)

    proc rank*(a: MatrixMod2): int =
        ## 階数を求める。空行列はコピーや列走査をせずO(1)で返す。
        if a.height == 0 or a.width == 0: return 0
        var b = a
        for col in 0..<b.width:
            var pivot = result
            while pivot < b.height and not b[pivot, col]: inc pivot
            if pivot == b.height: continue
            swapRows(b, result, pivot)
            for i in result + 1..<b.height:
                if b[i, col]:
                    for k in 0..<b.stride: word(b, i, k) = word(b, i, k) xor word(b, result, k)
            inc result
            if result == b.height: break

    proc determinant*(a: MatrixMod2): bool =
        assert a.height == a.width
        a.rank == a.height

    proc inverse*(a: MatrixMod2): Option[MatrixMod2] =
        ## 64bit単位の掃き出し法で逆行列を求める。O(n^2*ceil(n/64))。特異行列はnone。
        ## 元の行列は変更しない。作業領域はO(n*ceil(n/64))。
        assert a.height == a.width
        let n = a.height
        if n == 0: return some(initMatrixMod2(0, 0))
        # 右側の単位行列を64bit境界に置き、入出力をワード単位でコピーする。
        let rightStart = a.stride
        let stride = 2 * rightStart
        assert n <= high(int) div sizeof(uint64) div stride
        var storage = newSeq[uint64](n * stride)
        let data = cast[ptr UncheckedArray[uint64]](addr storage[0])
        for i in 0..<n:
            copyMem(addr data[i * stride], unsafeAddr a.words[i * rightStart], rightStart * sizeof(uint64))
            data[i * stride + rightStart + (i shr 6)] = 1'u64 shl (i and 63)
        for col in 0..<n:
            let firstWord = col shr 6
            let mask = 1'u64 shl (col and 63)
            var pivot = col
            while pivot < n and (data[pivot * stride + firstWord] and mask) == 0: inc pivot
            if pivot == n: return none(MatrixMod2)
            let pivotRow = cast[ptr UncheckedArray[uint64]](addr data[col * stride])
            if pivot != col:
                for k in firstWord..<stride: swap(pivotRow[k], data[pivot * stride + k])
            for i in 0..<n:
                if i == col: continue
                let row = cast[ptr UncheckedArray[uint64]](addr data[i * stride])
                if (row[firstWord] and mask) != 0:
                    for k in firstWord..<stride: row[k] = row[k] xor pivotRow[k]
        var inv = initMatrixMod2(n, n)
        for i in 0..<n:
            copyMem(addr inv.words[i * rightStart], addr data[i * stride + rightStart], rightStart * sizeof(uint64))
        some(inv)

    import cplib/matrix/field_matrix_ops
    import cplib/matrix/bit_matrix_ops
    export LinearSystemSolution

    proc solveLinearSystem*(a: MatrixMod2, b: openArray[bool]): Option[LinearSystemSolution[bool]] =
        ## ビット演算でAx=bの特殊解と核の基底を返す。O(h*min(h,w)*(w div 64+1)+w^2)。
        ## 元の行列は変更しない。解なしはnone、基底の個数はw-rank。
        assert b.len == a.height
        var rows = initBitLinearSystem(a.height, a.width)
        let stride = (a.width shr 6) + 1
        for i in 0..<a.height:
            for k in 0..<a.stride: rows[i * stride + k] = word(a, i, k)
            if b[i]: rows[i * stride + (a.width shr 6)] = rows[i * stride + (a.width shr 6)] or (1'u64 shl (a.width and 63))
        solveBitLinearSystem(rows, a.height, a.width)

    proc hafnian*(a: MatrixMod2): bool =
        ## GF(2)上の対称な偶数次行列のhafnianを求める。O(n^3)。
        assert a.h == a.w
        fieldHafnian(matrixRows(a, a.h, a.w))

    proc adjugate*(a: MatrixMod2): MatrixMod2 =
        ## GF(2)上で特異行列も含めた余因子行列を求める。O(n^3)。
        assert a.h == a.w
        let rows = fieldAdjugateInverse(matrixRows(a, a.h, a.w), true).get
        result = initMatrixMod2(a.h, a.w)
        for i in 0..<a.h:
            for j in 0..<a.w: result[i, j] = rows[i][j]
