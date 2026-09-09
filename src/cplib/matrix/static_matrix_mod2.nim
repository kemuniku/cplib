when not declared CPLIB_MATRIX_STATIC_MATRIX_MOD2:
    const CPLIB_MATRIX_STATIC_MATRIX_MOD2* = 1

    import bitops,options

    type StaticMatrixMod2*[H: static int, W: static int] = object
        ## A compile-time-sized matrix over GF(2).
        rows: array[H, array[(W + 63) div 64, uint64]]

    proc initStaticMatrixMod2*[H: static int, W: static int](): StaticMatrixMod2[H, W] = discard

    proc initStaticMatrixMod2*[H: static int, W: static int, T: SomeInteger](
            a: array[H, array[W, T]]): StaticMatrixMod2[H, W] =
        for i in 0..<H:
            for j in 0..<W:
                if (a[i][j] and 1) != 0:
                    result.rows[i][j shr 6] = result.rows[i][j shr 6] or (1'u64 shl (j and 63))

    proc initStaticMatrixMod2*[H: static int, W: static int](
            a: array[H, array[W, bool]]): StaticMatrixMod2[H, W] =
        for i in 0..<H:
            for j in 0..<W:
                if a[i][j]: result.rows[i][j shr 6] = result.rows[i][j shr 6] or (1'u64 shl (j and 63))

    proc toStaticMatrixMod2*[H: static int, W: static int, T](
            a: array[H, array[W, T]]): StaticMatrixMod2[H, W] = initStaticMatrixMod2(a)
    proc h*[H: static int, W: static int](a: StaticMatrixMod2[H, W]): int {.inline.} = H
    proc w*[H: static int, W: static int](a: StaticMatrixMod2[H, W]): int {.inline.} = W

    proc `[]`*[H: static int, W: static int](a: StaticMatrixMod2[H, W], i, j: int): bool {.inline.} =
        assert i in 0..<H and j in 0..<W
        (a.rows[i][j shr 6] and (1'u64 shl (j and 63))) != 0

    proc `[]=`*[H: static int, W: static int](a: var StaticMatrixMod2[H, W], i, j: int, x: bool) {.inline.} =
        assert i in 0..<H and j in 0..<W
        let mask = 1'u64 shl (j and 63)
        if x: a.rows[i][j shr 6] = a.rows[i][j shr 6] or mask
        else: a.rows[i][j shr 6] = a.rows[i][j shr 6] and not mask

    proc `[]=`*[H: static int, W: static int, T: SomeInteger](a: var StaticMatrixMod2[H, W], i, j: int, x: T) =
        a[i, j] = (x and 1) != 0

    proc `==`*[H: static int, W: static int](a, b: StaticMatrixMod2[H, W]): bool = a.rows == b.rows

    proc `$`*[H: static int, W: static int](a: StaticMatrixMod2[H, W]): string =
        for i in 0..<H:
            if i > 0: result.add '\n'
            for j in 0..<W:
                if j > 0: result.add ' '
                result.add(if a[i, j]: '1' else: '0')

    {.push checks: off.}
    proc setRowBitsUnchecked[H: static int, W: static int](
            a: var StaticMatrixMod2[H, W], i: int, values: string) =
        for k in 0..<a.rows[i].len:
            a.rows[i][k] = 0
        for j in 0..<values.len:
            if values[j] == '1':
                a.rows[i][j shr 6] = a.rows[i][j shr 6] or (1'u64 shl (j and 63))

    proc rowBitsUnchecked[H: static int, W: static int](
            a: StaticMatrixMod2[H, W], i, width: int): string =
        result = newString(width)
        for j in 0..<width:
            result[j] = char(ord('0') + int((a.rows[i][j shr 6] shr (j and 63)) and 1))
    {.pop.}

    proc setRowBits*[H: static int, W: static int](
            a: var StaticMatrixMod2[H, W], i: int, values: string) =
        assert i in 0..<H and values.len <= W
        a.setRowBitsUnchecked(i, values)

    proc rowBits*[H: static int, W: static int](
            a: StaticMatrixMod2[H, W], i, width: int): string =
        assert i in 0..<H and width in 0..W
        a.rowBitsUnchecked(i, width)

    proc rowBits*[H: static int, W: static int](
            a: StaticMatrixMod2[H, W], i: int): string =
        a.rowBits(i, W)

    proc identityStaticMatrixMod2*[N: static int](): StaticMatrixMod2[N, N] =
        for i in 0..<N: result[i, i] = true

    proc transposed*[H: static int, W: static int](a: StaticMatrixMod2[H, W]): StaticMatrixMod2[W, H] =
        for i in 0..<H:
            for j in 0..<W:
                if a[i, j]: result[j, i] = true

    {.push checks: off.}
    proc `*`*[H: static int, M: static int, W: static int](a: StaticMatrixMod2[H, M], b: StaticMatrixMod2[M, W]): StaticMatrixMod2[H, W] =
        when H < 40 or M < 64:
            let bt = b.transposed()
            for i in 0..<H:
                for j in 0..<W:
                    var parity = 0
                    for k in 0..<a.rows[i].len:
                        parity = parity xor ((a.rows[i][k] and bt.rows[j][k]).countSetBits and 1)
                    if parity != 0: result[i, j] = true
        else:
            # Method of Four Russians: process eight columns of a at once and
            # look up the corresponding xor of rows of b.
            const
                BlockBits = 8
                WordCount = (W + 63) div 64
            var table: array[1 shl BlockBits, array[WordCount, uint64]]
            var blockStart = 0
            while blockStart < M:
                let bits = min(BlockBits, M - blockStart)
                for mask in 1..<(1 shl bits):
                    let previous = mask and (mask - 1)
                    let bit = mask.countTrailingZeroBits
                    for k in 0..<WordCount:
                        table[mask][k] = table[previous][k] xor b.rows[blockStart + bit][k]
                let shift = blockStart and 63
                let mask = uint64((1 shl bits) - 1)
                for i in 0..<H:
                    let index = int((a.rows[i][blockStart shr 6] shr shift) and mask)
                    for k in 0..<WordCount:
                        result.rows[i][k] = result.rows[i][k] xor table[index][k]
                blockStart += BlockBits
    {.pop.}

    proc `*=`*[N: static int](a: var StaticMatrixMod2[N, N], b: StaticMatrixMod2[N, N]) = a = a * b

    proc pow*[N: static int](a: StaticMatrixMod2[N, N], exponent: int): StaticMatrixMod2[N, N] =
        assert exponent >= 0
        result = identityStaticMatrixMod2[N]()
        var base = a
        var e = exponent
        while e > 0:
            if (e and 1) != 0: result *= base
            e = e shr 1
            if e > 0: base *= base

    proc `**`*[N: static int](a: StaticMatrixMod2[N, N], exponent: int): StaticMatrixMod2[N, N] = a.pow(exponent)

    proc rank*[H: static int, W: static int](a: StaticMatrixMod2[H, W]): int =
        ## 階数を求める。空行列は作業領域を確保せずO(1)で返す。
        when H == 0 or W == 0: return 0
        var storage: ref StaticMatrixMod2[H, W]
        new storage
        storage[] = a
        template b: untyped = storage[]
        for col in 0..<W:
            var pivot = result
            while pivot < H and not b[pivot, col]: inc pivot
            if pivot == H: continue
            swap(b.rows[result], b.rows[pivot])
            for i in result + 1..<H:
                if b[i, col]:
                    for k in 0..<b.rows[i].len: b.rows[i][k] = b.rows[i][k] xor b.rows[result][k]
            inc result
            if result == H: break

    proc determinant*[N: static int](a: StaticMatrixMod2[N, N]): bool = a.rank == N

    proc inverse*[N: static int](a: StaticMatrixMod2[N, N]): Option[StaticMatrixMod2[N, N]] =
        var left = a
        var right = identityStaticMatrixMod2[N]()
        for col in 0..<N:
            var pivot = col
            while pivot < N and not left[pivot, col]: inc pivot
            if pivot == N: return none(StaticMatrixMod2[N, N])
            swap(left.rows[col], left.rows[pivot])
            swap(right.rows[col], right.rows[pivot])
            for i in 0..<N:
                if i != col and left[i, col]:
                    for k in 0..<left.rows[i].len: left.rows[i][k] = left.rows[i][k] xor left.rows[col][k]
                    for k in 0..<right.rows[i].len: right.rows[i][k] = right.rows[i][k] xor right.rows[col][k]
        some(right)

    import cplib/matrix/field_matrix_ops
    import cplib/matrix/bit_matrix_ops
    export LinearSystemSolution

    proc solveLinearSystem*[H: static int, W: static int](a: StaticMatrixMod2[H,W], b: openArray[bool], height: int = H, width: int = W): Option[LinearSystemSolution[bool]] =
        ## 左上h行w列でAx=bをビット演算で解く。O(h*min(h,w)*(w div 64+1)+w^2)。
        ## height/widthの省略時はH/W。元の行列は変更せず、解なしはnoneを返す。
        assert height in 0..H and width in 0..W and b.len == height
        var rows = initBitLinearSystem(height, width)
        let stride = (width shr 6) + 1
        let fullWords = width shr 6
        let tailBits = width and 63
        for i in 0..<height:
            for k in 0..<fullWords: rows[i * stride + k] = a.rows[i][k]
            if tailBits > 0:
                rows[i * stride + fullWords] = a.rows[i][fullWords] and ((1'u64 shl tailBits) - 1)
            if b[i]: rows[i * stride + fullWords] = rows[i * stride + fullWords] or (1'u64 shl tailBits)
        solveBitLinearSystem(rows, height, width)

    proc hafnian*[H: static int, W: static int](a: StaticMatrixMod2[H,W]): bool =
        ## GF(2)上の対称な偶数次行列のhafnianを求める。O(n^3)。
        assert a.h == a.w
        fieldHafnian(matrixRows(a, a.h, a.w))

    proc adjugate*[H: static int, W: static int](a: StaticMatrixMod2[H,W]): StaticMatrixMod2[H,W] =
        ## GF(2)上で特異行列も含めた余因子行列を求める。O(n^3)。
        assert a.h == a.w
        let rows = fieldAdjugateInverse(matrixRows(a, a.h, a.w), true).get
        for i in 0..<a.h:
            for j in 0..<a.w: result[i, j] = rows[i][j]
