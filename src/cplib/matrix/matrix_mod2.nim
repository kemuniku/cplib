when not declared CPLIB_MATRIX_MATRIX_MOD2:
    const CPLIB_MATRIX_MATRIX_MOD2* = 1

    import bitops,options

    type MatrixMod2* = object
        ## A dynamically-sized matrix over GF(2).
        height, width: int
        rows: seq[seq[uint64]]

    proc initMatrixMod2*(h, w: int): MatrixMod2 =
        assert h >= 0 and w >= 0
        result.height = h
        result.width = w
        result.rows = newSeq[seq[uint64]](h)
        for i in 0..<h:
            result.rows[i] = newSeq[uint64]((w + 63) div 64)

    proc initMatrixMod2*[T: SomeInteger](a: openArray[seq[T]]): MatrixMod2 =
        let w = if a.len == 0: 0 else: a[0].len
        result = initMatrixMod2(a.len, w)
        for i in 0..<a.len:
            assert a[i].len == w
            for j, x in a[i]:
                if (x and 1) != 0:
                    result.rows[i][j shr 6] = result.rows[i][j shr 6] or (1'u64 shl (j and 63))

    proc initMatrixMod2*(a: openArray[seq[bool]]): MatrixMod2 =
        let w = if a.len == 0: 0 else: a[0].len
        result = initMatrixMod2(a.len, w)
        for i in 0..<a.len:
            assert a[i].len == w
            for j, x in a[i]:
                if x: result.rows[i][j shr 6] = result.rows[i][j shr 6] or (1'u64 shl (j and 63))

    proc toMatrixMod2*[T](a: openArray[seq[T]]): MatrixMod2 = initMatrixMod2(a)
    proc h*(a: MatrixMod2): int {.inline.} = a.height
    proc w*(a: MatrixMod2): int {.inline.} = a.width

    proc `[]`*(a: MatrixMod2, i, j: int): bool {.inline.} =
        assert i in 0..<a.height and j in 0..<a.width
        (a.rows[i][j shr 6] and (1'u64 shl (j and 63))) != 0

    proc `[]=`*(a: var MatrixMod2, i, j: int, x: bool) {.inline.} =
        assert i in 0..<a.height and j in 0..<a.width
        let mask = 1'u64 shl (j and 63)
        if x: a.rows[i][j shr 6] = a.rows[i][j shr 6] or mask
        else: a.rows[i][j shr 6] = a.rows[i][j shr 6] and not mask

    proc `[]=`*[T: SomeInteger](a: var MatrixMod2, i, j: int, x: T) {.inline.} =
        a[i, j] = (x and 1) != 0

    proc `==`*(a, b: MatrixMod2): bool =
        a.height == b.height and a.width == b.width and a.rows == b.rows

    proc `$`*(a: MatrixMod2): string =
        for i in 0..<a.height:
            if i > 0: result.add '\n'
            for j in 0..<a.width:
                if j > 0: result.add ' '
                result.add(if a[i, j]: '1' else: '0')

    proc identityMatrixMod2*(n: int): MatrixMod2 =
        result = initMatrixMod2(n, n)
        for i in 0..<n: result[i, i] = true

    proc transposed*(a: MatrixMod2): MatrixMod2 =
        result = initMatrixMod2(a.width, a.height)
        for i in 0..<a.height:
            for j in 0..<a.width:
                if a[i, j]: result[j, i] = true

    proc `*`*(a, b: MatrixMod2): MatrixMod2 =
        assert a.width == b.height
        result = initMatrixMod2(a.height, b.width)
        let bt = b.transposed()
        for i in 0..<a.height:
            for j in 0..<b.width:
                var parity = 0
                for k in 0..<a.rows[i].len:
                    parity = parity xor ((a.rows[i][k] and bt.rows[j][k]).countSetBits and 1)
                if parity != 0: result[i, j] = true

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
        var b = a
        for col in 0..<b.width:
            var pivot = result
            while pivot < b.height and not b[pivot, col]: inc pivot
            if pivot == b.height: continue
            swap(b.rows[result], b.rows[pivot])
            for i in result + 1..<b.height:
                if b[i, col]:
                    for k in 0..<b.rows[i].len: b.rows[i][k] = b.rows[i][k] xor b.rows[result][k]
            inc result
            if result == b.height: break

    proc determinant*(a: MatrixMod2): bool =
        assert a.height == a.width
        a.rank == a.height

    proc inverse*(a: MatrixMod2): Option[MatrixMod2] =
        assert a.height == a.width
        let n = a.height
        var aug = initMatrixMod2(n, 2 * n)
        for i in 0..<n:
            for j in 0..<n:
                if a[i, j]: aug[i, j] = true
            aug[i, n + i] = true
        for col in 0..<n:
            var pivot = col
            while pivot < n and not aug[pivot, col]: inc pivot
            if pivot == n: return none(MatrixMod2)
            swap(aug.rows[col], aug.rows[pivot])
            for i in 0..<n:
                if i != col and aug[i, col]:
                    for k in 0..<aug.rows[i].len: aug.rows[i][k] = aug.rows[i][k] xor aug.rows[col][k]
        var inv = initMatrixMod2(n, n)
        for i in 0..<n:
            for j in 0..<n:
                if aug[i, n + j]: inv[i, j] = true
        some(inv)
