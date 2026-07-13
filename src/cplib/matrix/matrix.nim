when not declared CPLIB_MATRIX_MATRIX:
    const CPLIB_MATRIX_MATRIX* = 1
    import sequtils, strutils, hashes, std/math
    type Matrix*[T] = object
        height, width: int
        arr: seq[T]
    proc initMatrix*[T](arr: openArray[seq[T]]): Matrix[T] =
        assert arr.len == 0 or arr.mapIt(it.len).allIt(it == arr[0].len), "all elements in arr must be the same size."
        result.height = arr.len
        result.width = if arr.len == 0: 0 else: arr[0].len
        result.arr = newSeq[T](result.height * result.width)
        for i in 0..<result.height:
            for j in 0..<result.width:
                result.arr[i * result.width + j] = arr[i][j]
    proc toMatrix*[T](arr: openArray[seq[T]]): Matrix[T] = initMatrix(arr)
    proc initMatrix*[T](arr: openArray[T], vertical: bool = false): Matrix[T] =
        result.height = if vertical: arr.len else: 1
        result.width = if vertical:
            (if arr.len == 0: 0 else: 1)
        else:
            arr.len
        result.arr = @arr
    proc initMatrix*[T](h, w: int, val: T): Matrix[T] =
        assert h >= 0 and w >= 0
        Matrix[T](height: h, width: w, arr: newSeqWith(h * w, val))

    proc h*[T](m: Matrix[T]): int {.inline.} = m.height
    proc w*[T](m: Matrix[T]): int {.inline.} = m.width
    proc `$`*[T](m: Matrix[T]): string =
        for i in 0..<m.height:
            if i > 0: result.add '\n'
            for j in 0..<m.width:
                if j > 0: result.add ' '
                result.add $m.arr[i * m.width + j]
    proc `==`*[T](a, b: Matrix[T]): bool =
        a.height == b.height and a.width == b.width and a.arr == b.arr
    proc `[]`*[T](m: Matrix[T], r: int): seq[T] =
        assert r in 0..<m.height
        result = newSeq[T](m.width)
        for j in 0..<m.width: result[j] = m.arr[r * m.width + j]
    proc `[]=`*[T](m: var Matrix[T], r: int, row: openArray[T]) =
        assert r in 0..<m.height and row.len == m.width
        for j in 0..<m.width: m.arr[r * m.width + j] = row[j]

    proc `[]`*[T](m: Matrix[T], r: int, c: int): T {.inline.} =
        m.arr[r * m.width + c]
    proc `[]`*[T](m: var Matrix[T], r: int, c: int): var T {.inline.} =
        m.arr[r * m.width + c]
    proc `[]=`*[T](m: var Matrix[T], r: int, c: int, val: T) {.inline.} =
        m.arr[r * m.width + c] = val

    proc `-`*[T](m: Matrix[T]): Matrix[T] =
        result.height = m.height
        result.width = m.width
        result.arr = newSeq[T](m.arr.len)
        for i in 0..<m.arr.len: result.arr[i] = -m.arr[i]

    {.push checks: off.}
    proc multiplySquareStrassen[T](a, b: seq[T], n: int, zero: T): seq[T] =
        const LeafSize = 32
        result = newSeqWith(n * n, zero)
        if n <= LeafSize:
            var bt = newSeqWith(n * n, zero)
            for i in 0..<n:
                for j in 0..<n:
                    bt[j * n + i] = b[i * n + j]
            for i in 0..<n:
                for j in 0..<n:
                    var
                        value0 = zero
                        value1 = zero
                        value2 = zero
                        value3 = zero
                        k = 0
                    while k + 3 < n:
                        value0 += a[i * n + k] * bt[j * n + k]
                        value1 += a[i * n + k + 1] * bt[j * n + k + 1]
                        value2 += a[i * n + k + 2] * bt[j * n + k + 2]
                        value3 += a[i * n + k + 3] * bt[j * n + k + 3]
                        k += 4
                    while k < n:
                        value0 += a[i * n + k] * bt[j * n + k]
                        inc k
                    value0 += value1
                    value2 += value3
                    value0 += value2
                    result[i * n + j] = value0
            return

        let
            half = n div 2
            quadrantSize = half * half
        var x = newSeqWith(quadrantSize, zero)
        var y = newSeqWith(quadrantSize, zero)
        template fillOperands(which: static int) =
            for i in 0..<half:
                for j in 0..<half:
                    let
                        p = i * half + j
                        top = i * n + j
                        bottom = (i + half) * n + j
                    when which == 1:
                        x[p] = a[top] + a[bottom + half]
                        y[p] = b[top] + b[bottom + half]
                    elif which == 2:
                        x[p] = a[bottom] + a[bottom + half]
                        y[p] = b[top]
                    elif which == 3:
                        x[p] = a[top]
                        y[p] = b[top + half] - b[bottom + half]
                    elif which == 4:
                        x[p] = a[bottom + half]
                        y[p] = b[bottom] - b[top]
                    elif which == 5:
                        x[p] = a[top] + a[top + half]
                        y[p] = b[bottom + half]
                    elif which == 6:
                        x[p] = a[bottom] - a[top]
                        y[p] = b[top] + b[top + half]
                    else:
                        x[p] = a[top + half] - a[bottom + half]
                        y[p] = b[bottom] + b[bottom + half]
        fillOperands(1)
        let m1 = multiplySquareStrassen(x, y, half, zero)
        fillOperands(2)
        let m2 = multiplySquareStrassen(x, y, half, zero)
        fillOperands(3)
        let m3 = multiplySquareStrassen(x, y, half, zero)
        fillOperands(4)
        let m4 = multiplySquareStrassen(x, y, half, zero)
        fillOperands(5)
        let m5 = multiplySquareStrassen(x, y, half, zero)
        fillOperands(6)
        let m6 = multiplySquareStrassen(x, y, half, zero)
        fillOperands(7)
        let m7 = multiplySquareStrassen(x, y, half, zero)
        for i in 0..<half:
            for j in 0..<half:
                let
                    p = i * half + j
                    p11 = i * n + j
                    p12 = p11 + half
                    p21 = (i + half) * n + j
                    p22 = p21 + half
                result[p11] = m1[p] + m4[p] - m5[p] + m7[p]
                result[p12] = m3[p] + m5[p]
                result[p21] = m2[p] + m4[p]
                result[p22] = m1[p] - m2[p] + m3[p] + m6[p]

    proc `*`*[T](a, b: Matrix[T]): Matrix[T] =
        let
            ah = a.height
            aw = a.width
            bh = b.height
            bw = b.width
        assert aw == bh
        result = initMatrix[T](ah, bw, 0)
        when compiles(T.mod) and compiles(default(T).val) and compiles(T.init(0)):
            # Convert canonical modint values once, then delay reductions for
            # as many scalar products as fit safely in a uint64 accumulator.
            # The public matrix and result types remain Matrix[T].
            let modulus = uint64(T.mod)
            assert modulus > 0 and modulus <= (1'u64 shl 32)
            var aValues = newSeq[uint64](ah * aw)
            var btValues = newSeq[uint64](bw * bh)
            for i in 0..<ah:
                for k in 0..<aw:
                    aValues[i * aw + k] = uint64(a.arr[i * aw + k].val)
            for k in 0..<bh:
                for j in 0..<bw:
                    btValues[j * bh + k] = uint64(b.arr[k * bw + j].val)
            let
                maxTerm = (modulus - 1) * (modulus - 1)
                batchSize = if maxTerm == 0: max(1, aw) else:
                    max(1, int(min(uint64(aw), uint64.high div maxTerm)))
            for i in 0..<ah:
                for j in 0..<bw:
                    var
                        value = 0'u64
                        k = 0
                    while k < aw:
                        let limit = min(aw, k + batchSize)
                        var partial = 0'u64
                        while k < limit:
                            partial += aValues[i * aw + k] * btValues[j * bh + k]
                            inc k
                        value += partial mod modulus
                        if value >= modulus: value -= modulus
                    result.arr[i * bw + j] = T.init(int(value))
        else:
            # Strassen changes the evaluation order, so keep it to exact
            # modular types whose representation is not exposed above.
            when compiles(T.mod) and compiles(default(T) - default(T)):
                if ah >= 256 and ah == aw and aw == bw and (ah and (ah - 1)) == 0:
                    result.arr = multiplySquareStrassen(a.arr, b.arr, ah, result.arr[0])
                    return
            var bt = newSeq[T](bw * bh)
            for k in 0..<bh:
                for j in 0..<bw:
                    bt[j * bh + k] = b.arr[k * bw + j]
            # Transposing b makes both operands of every dot product contiguous,
            # and accumulating locally avoids writing the result aw times.
            for i in 0..<ah:
                for j in 0..<bw:
                    var
                        value0 = result.arr[i * bw + j]
                        value1 = value0
                        value2 = value0
                        value3 = value0
                        k = 0
                    while k + 3 < aw:
                        value0 += a.arr[i * aw + k] * bt[j * bh + k]
                        value1 += a.arr[i * aw + k + 1] * bt[j * bh + k + 1]
                        value2 += a.arr[i * aw + k + 2] * bt[j * bh + k + 2]
                        value3 += a.arr[i * aw + k + 3] * bt[j * bh + k + 3]
                        k += 4
                    while k < aw:
                        value0 += a.arr[i * aw + k] * bt[j * bh + k]
                        inc k
                    value0 += value1
                    value2 += value3
                    value0 += value2
                    result.arr[i * bw + j] = value0
    {.pop.}
    proc `*=`*[T](a: var Matrix[T], b: Matrix[T]) =
        a = a * b
    proc `*=`*[T](a: var Matrix[T], x: T) =
        for i in 0..<a.h:
            for j in 0..<a.w:
                a[i, j] *= x
    proc `*`*[T](a: Matrix[T], x: T): Matrix[T] = (result = a; result *= x)
    proc `*`*[T](x: T, a: Matrix[T]): Matrix[T] = a * x
    template defineMatrixAssignmentOp(assign, op: untyped) =
        proc assign*[T](a: var Matrix[T], b: Matrix[T]) =
            assert a.h == b.h and a.w == b.w
            for i in 0..<a.h:
                for j in 0..<a.w:
                    assign(a[i, j], b[i, j])
        proc assign*[T](a: var Matrix[T], x: T) =
            for i in 0..<a.h:
                for j in 0..<a.w:
                    assign(a[i, j], x)
        proc op*[T](a, b: Matrix[T]): Matrix[T] = (result = a; assign(result, b))
        proc op*[T](a: Matrix[T], x: T): Matrix[T] = (result = a; assign(result, x))
        proc op*[T](x: T, a: Matrix[T]): Matrix[T] = op(a, x)
    defineMatrixAssignmentOp(`+=`, `+`)
    defineMatrixAssignmentOp(`-=`, `-`)

    template defineMatrixIntOps(assign, op: untyped) =
        proc assign*(a: var Matrix[int], b: Matrix[int]) =
            assert a.h == b.h and a.w == b.w
            for i in 0..<a.h:
                for j in 0..<a.w:
                    a[i, j] = op(a[i, j], b[i, j])
        proc assign*(a: var Matrix[int], x: int) =
            for i in 0..<a.h:
                for j in 0..<a.w:
                    a[i, j] = op(a[i, j], x)
        proc op*(a, b: Matrix[int]): Matrix[int] = (result = a; assign(result, b))
        proc op*(a: Matrix[int], x: int): Matrix[int] = (result = a; assign(result, x))
        proc op*(x: int, a: Matrix[int]): Matrix[int] = op(a, x)
    defineMatrixIntOps(`and=`, `and`)
    defineMatrixIntOps(`or=`, `or`)
    defineMatrixIntOps(`xor=`, `xor`)
    defineMatrixIntOps(`shl=`, `shl`)
    defineMatrixIntOps(`shr=`, `shr`)
    defineMatrixIntOps(`div=`, `div`)
    defineMatrixIntOps(`mod=`, `mod`)

    proc hash*[T](m: Matrix[T]): Hash = hash((m.height, m.width, m.arr))
    proc identity_matrix*[T](n: int, one, zero: T): Matrix[T] =
        result = initMatrix[T](n, n, zero)
        for i in 0..<n: result[i, i] = one
    proc identity_matrix*[T](n: int): Matrix[T] = identity_matrix[T](n, 1, 0)
    proc pow*[T](m: Matrix[T], n: int): Matrix[T] =
        result = identity_matrix[T](m.h)
        var m = m
        var n = n
        while n > 0:
            if (n and 1) == 1: result *= m
            m *= m
            n = n shr 1
    proc `**`*[T](m: Matrix[T], n: int): Matrix[T] = m.pow(n)
    proc sum*[T](m: Matrix[T]): T = m.arr.sum
