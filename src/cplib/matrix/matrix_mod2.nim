when not declared CPLIB_MATRIX_MATRIX_MOD2:
    const CPLIB_MATRIX_MATRIX_MOD2* = 1

    import bitops,options

    type MatrixMod2* = object
        ## GF(2)上の可変サイズ行列。各行を64bit境界に揃えた連続配列で保持する。
        height, width, stride: int
        words: seq[uint64]

    proc initMatrixMod2*(h, w: int): MatrixMod2 =
        ## h行w列の零行列をO(h*ceil(w/64))時間・空間で作る。行ごとの確保は行わない。
        assert h >= 0 and w >= 0, "行列の行数と列数は非負である必要があります"
        let stride = (w shr 6) + int((w and 63) != 0)
        assert stride == 0 or h <= high(int) div sizeof(uint64) div stride, "行列の記憶領域のサイズがintの範囲を超えています"
        result.height = h
        result.width = w
        result.stride = stride
        result.words = newSeq[uint64](h * stride)

    template word(a: MatrixMod2, i, k: int): untyped =
        a.words[i * a.stride + k]

    proc initMatrixMod2*[T: SomeInteger](a: openArray[seq[T]]): MatrixMod2 =
        let w = if a.len == 0: 0 else: a[0].len
        result = initMatrixMod2(a.len, w)
        for i in 0..<a.len:
            assert a[i].len == w, "行列の各行の長さは列数と一致する必要があります"
            for j, x in a[i]:
                if (x and 1) != 0:
                    word(result, i, j shr 6) = word(result, i, j shr 6) or (1'u64 shl (j and 63))

    proc initMatrixMod2*(a: openArray[seq[bool]]): MatrixMod2 =
        let w = if a.len == 0: 0 else: a[0].len
        result = initMatrixMod2(a.len, w)
        for i in 0..<a.len:
            assert a[i].len == w, "行列の各行の長さは列数と一致する必要があります"
            for j, x in a[i]:
                if x: word(result, i, j shr 6) = word(result, i, j shr 6) or (1'u64 shl (j and 63))

    proc toMatrixMod2*[T](a: openArray[seq[T]]): MatrixMod2 = initMatrixMod2(a)
    proc h*(a: MatrixMod2): int {.inline.} = a.height
    proc w*(a: MatrixMod2): int {.inline.} = a.width

    proc `[]`*(a: MatrixMod2, i, j: int): bool {.inline.} =
        assert i in 0..<a.height and j in 0..<a.width, "指定した値が有効な範囲内である必要があります: i in 0 ..< a.height and j in 0 ..< a.width"
        (word(a, i, j shr 6) and (1'u64 shl (j and 63))) != 0

    proc `[]=`*(a: var MatrixMod2, i, j: int, x: bool) {.inline.} =
        assert i in 0..<a.height and j in 0..<a.width, "指定した値が有効な範囲内である必要があります: i in 0 ..< a.height and j in 0 ..< a.width"
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
        ## 文字列を64bitずつまとめて格納し、残りの列を零にする。
        var j = 0
        for k in 0..<a.stride:
            var value = 0'u64
            let limit = min(64, values.len - j)
            for bit in 0..<limit:
                value = value or (uint64(values[j + bit] == '1') shl bit)
            word(a, i, k) = value
            j += limit

    proc rowBitsUnchecked(a: MatrixMod2, i, width: int): string =
        result = newString(width)
        for j in 0..<width:
            result[j] = char(ord('0') + int((word(a, i, j shr 6) shr (j and 63)) and 1))
    {.pop.}

    proc setRowBits*(a: var MatrixMod2, i: int, values: string) =
        assert i in 0..<a.height and values.len <= a.width, "行番号が範囲内で、指定した行の長さが列数以下である必要があります"
        a.setRowBitsUnchecked(i, values)

    proc rowBits*(a: MatrixMod2, i, width: int): string =
        assert i in 0..<a.height and width in 0..a.width, "行番号が範囲内で、指定した行の長さが列数以下である必要があります"
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
        assert a.width == b.height, "左の行列の列数と右の行列の行数は等しい必要があります"
        multiplyUnchecked(a, b)

    proc `*=`*(a: var MatrixMod2, b: MatrixMod2) = a = a * b

    proc pow*(a: MatrixMod2, exponent: int): MatrixMod2 =
        assert a.height == a.width and exponent >= 0, "行列は正方行列で、指数は非負である必要があります"
        result = identityMatrixMod2(a.height)
        var base = a
        var e = exponent
        while e > 0:
            if (e and 1) != 0: result *= base
            e = e shr 1
            if e > 0: base *= base

    proc `**`*(a: MatrixMod2, exponent: int): MatrixMod2 = a.pow(exponent)

    proc rankSimple(a: MatrixMod2): int =
        ## 階数をO(h*w+h*min(h,w)*ceil(w/64))で求める。元の行列は変更せず、空行列はO(1)で返す。
        if a.height == 0 or a.width == 0: return 0
        var b = a
        let data = cast[ptr UncheckedArray[uint64]](addr b.words[0])
        for col in 0..<b.width:
            let firstWord = col shr 6
            let mask = 1'u64 shl (col and 63)
            var pivot = result
            while pivot < b.height and (data[pivot * b.stride + firstWord] and mask) == 0: inc pivot
            if pivot == b.height: continue
            if result + 1 == min(b.height, b.width): return result + 1
            let pivotRow = cast[ptr UncheckedArray[uint64]](addr data[result * b.stride])
            # 未処理の行は現在の列より前がすべて零なので、現在のワード以降だけ操作する。
            if pivot != result:
                for k in firstWord..<b.stride: swap(pivotRow[k], data[pivot * b.stride + k])
            for i in result + 1..<b.height:
                let row = cast[ptr UncheckedArray[uint64]](addr data[i * b.stride])
                if (row[firstWord] and mask) != 0:
                    for k in firstWord..<b.stride: row[k] = row[k] xor pivotRow[k]
            inc result
            if result == b.height: break

    proc rankBlocked(a: MatrixMod2): int =
        ## 256行以上の行列を8列ずつ消去する。組合せ表の領域は行列のコピー以下。
        if a.height == 0 or a.width == 0: return 0
        var b = a
        let stride = b.stride
        let data = cast[ptr UncheckedArray[uint64]](addr b.words[0])
        var table = newSeq[uint64](256 * stride)
        let tableData = cast[ptr UncheckedArray[uint64]](addr table[0])
        var col = 0
        while col < b.width and result < b.height:
            let firstWord = col shr 6
            let shift = col and 63
            let bits = min(8, b.width - col)
            let mask = (1'u64 shl bits) - 1
            let base = result
            var count = 0
            var patterns, pivotMasks: array[8, int]
            # この8列で独立な行を選び、既に選んだ行だけでピボット行を消去する。
            for i in base..<b.height:
                var pattern = int((data[i * stride + firstWord] shr shift) and mask)
                var combination = 0
                for j in 0..<count:
                    if (pattern and pivotMasks[j]) != 0:
                        pattern = pattern xor patterns[j]
                        combination = combination or (1 shl j)
                if pattern == 0: continue
                let row = cast[ptr UncheckedArray[uint64]](addr data[(base + count) * stride])
                if i != base + count:
                    for k in firstWord..<stride: swap(row[k], data[i * stride + k])
                for j in 0..<count:
                    if (combination and (1 shl j)) != 0:
                        let pivot = cast[ptr UncheckedArray[uint64]](addr data[(base + j) * stride])
                        for k in firstWord..<stride: row[k] = row[k] xor pivot[k]
                patterns[count] = pattern
                pivotMasks[count] = pattern and -pattern
                inc count
                if count == bits: break
            result += count
            if result == b.width: return
            if count > 0 and result < b.height:
                # 列のビットパターンから、対応するピボット行のXORを引けるようにする。
                var offsets, combined: array[256, int]
                for index in 1..<(1 shl count):
                    let previous = index and (index - 1)
                    let bit = countTrailingZeroBits(index)
                    combined[index] = combined[previous] xor patterns[bit]
                    let offset = index * stride
                    offsets[combined[index]] = offset
                    let pivot = cast[ptr UncheckedArray[uint64]](addr data[(base + bit) * stride])
                    for k in firstWord..<stride:
                        tableData[offset + k] = tableData[previous * stride + k] xor pivot[k]
                for i in result..<b.height:
                    let row = cast[ptr UncheckedArray[uint64]](addr data[i * stride])
                    let pattern = int((row[firstWord] shr shift) and mask)
                    if pattern == 0: continue
                    let offset = offsets[pattern]
                    for k in firstWord..<stride: row[k] = row[k] xor tableData[offset + k]
            col += bits

    {.push checks: off.}
    proc rankTall(a: MatrixMod2, limit: int): int =
        ## 先頭limit行の基底で階数を調べ、未確定なら-1を返す。O(limit*w*ceil(w/64))時間、O(w*ceil(w/64))追加空間。
        if a.width >= 256:
            var sample = initMatrixMod2(limit, a.width)
            copyMem(addr sample.words[0], unsafeAddr a.words[0], limit * a.stride * sizeof(uint64))
            result = rankBlocked(sample)
            if result < a.width and limit < a.height: result = -1
            return
        let stride = a.stride
        let source = cast[ptr UncheckedArray[uint64]](unsafeAddr a.words[0])
        var basis = newSeq[uint64](a.width * stride)
        var pivots = newSeq[int](a.width)
        var buffer = newSeq[uint64](stride)
        let basisData = cast[ptr UncheckedArray[uint64]](addr basis[0])
        let row = cast[ptr UncheckedArray[uint64]](addr buffer[0])
        for i in 0..<limit:
            let input = cast[ptr UncheckedArray[uint64]](unsafeAddr source[i * stride])
            var firstWord = 0
            while firstWord < stride and input[firstWord] == 0: inc firstWord
            if firstWord == stride: continue
            copyMem(addr row[firstWord], unsafeAddr input[firstWord], (stride - firstWord) * sizeof(uint64))
            block insertRow:
                for k in firstWord..<stride:
                    while row[k] != 0:
                        let col = (k shl 6) + countTrailingZeroBits(row[k])
                        let index = pivots[col]
                        if index == 0:
                            copyMem(addr basisData[result * stride + k], addr row[k], (stride - k) * sizeof(uint64))
                            inc result
                            pivots[col] = result
                            if result == a.width: return
                            break insertRow
                        let pivot = cast[ptr UncheckedArray[uint64]](addr basisData[(index - 1) * stride])
                        for j in k..<stride: row[j] = row[j] xor pivot[j]
        if limit < a.height: result = -1
    {.pop.}

    proc rank*(a: MatrixMod2): int =
        ## 階数をO(h*w+h*min(h,w)*ceil(w/64))で求める。元の行列は変更しない。
        ## 縦長行列は先頭の行で最大階数を確認できれば終了し、未確定なら通常の消去法を使う。空行列はO(1)。
        if a.height == 0 or a.width == 0: return 0
        if a.height div 2 >= a.width:
            let limit = if a.width < 8: a.height else: a.width + min(32, a.height - a.width)
            let candidate = rankTall(a, limit)
            if candidate >= 0: return candidate
        if a.height < 256 or a.width < 8: rankSimple(a)
        else: rankBlocked(a)

    proc determinant*(a: MatrixMod2): bool =
        assert a.height == a.width, "行列は正方行列である必要があります"
        a.rank == a.height

    proc inverse*(a: MatrixMod2): Option[MatrixMod2] =
        ## 64bit単位の掃き出し法で逆行列を求める。O(n^2*ceil(n/64))。特異行列はnone。
        ## 元の行列は変更しない。作業領域はO(n*ceil(n/64))。
        assert a.height == a.width, "行列は正方行列である必要があります"
        let n = a.height
        if n == 0: return some(initMatrixMod2(0, 0))
        # 右側の単位行列を64bit境界に置き、入出力をワード単位でコピーする。
        let rightStart = a.stride
        let stride = 2 * rightStart
        assert n <= high(int) div sizeof(uint64) div stride, "行列の記憶領域のサイズがintの範囲を超えています"
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
        assert b.len == a.height, "右辺の要素数は行列の行数と一致する必要があります"
        var rows = initBitLinearSystem(a.height, a.width)
        let stride = (a.width shr 6) + 1
        for i in 0..<a.height:
            for k in 0..<a.stride: rows[i * stride + k] = word(a, i, k)
            if b[i]: rows[i * stride + (a.width shr 6)] = rows[i * stride + (a.width shr 6)] or (1'u64 shl (a.width and 63))
        solveBitLinearSystem(rows, a.height, a.width)

    proc hafnian*(a: MatrixMod2): bool =
        ## GF(2)上の対称な偶数次行列のhafnianを求める。O(n^3)。
        assert a.h == a.w, "行列は正方行列である必要があります"
        fieldHafnian(matrixRows(a, a.h, a.w))

    proc adjugate*(a: MatrixMod2): MatrixMod2 =
        ## GF(2)上で特異行列も含めた余因子行列を求める。O(n^3)。
        assert a.h == a.w, "行列は正方行列である必要があります"
        let rows = fieldAdjugateInverse(matrixRows(a, a.h, a.w), true).get
        result = initMatrixMod2(a.h, a.w)
        for i in 0..<a.h:
            for j in 0..<a.w: result[i, j] = rows[i][j]
