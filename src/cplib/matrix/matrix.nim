when not declared CPLIB_MATRIX_MATRIX:
    const CPLIB_MATRIX_MATRIX* = 1
    import sequtils, strutils, hashes, std/math, options
    type Matrix*[T] = object
        arr: seq[seq[T]]
    proc initMatrix*[T](arr: openArray[seq[T]]): Matrix[T] =
        assert arr.len == 0 or arr.mapIt(it.len).allIt(it == arr[0].len), "all elements in arr must be the same size."
        Matrix[T](arr: @arr)
    proc toMatrix*[T](arr: openArray[seq[T]]): Matrix[T] = initMatrix(arr)
    proc initMatrix*[T](arr: openArray[T], vertical: bool = false): Matrix[T] =
        if vertical: Matrix[T](arr: arr.mapIt(@[it]))
        else: Matrix[T](arr: @[@arr])
    proc initMatrix*[T](h, w: int, val: T): Matrix[T] = Matrix[T](arr: newSeqWith(h, newSeqWith(w, val)))

    proc h*[T](m: Matrix[T]): int = m.arr.len
    proc w*[T](m: Matrix[T]): int =
        if m.h == 0: return 0
        m.arr[0].len
    proc `$`*[T](m: Matrix[T]): string =
        for i in 0..<m.arr.len:
            result &= m.arr[i].mapIt($it).join(" ")
            if i != m.arr.len - 1: result &= "\n"
    proc `==`*[T](a, b: Matrix[T]): bool = a.arr == b.arr
    proc `[]`*[T](m: Matrix[T], r: int): seq[T] = m.arr[r]
    proc `[]`*[T](m: var Matrix[T], r: int): var seq[T] = m.arr[r]
    proc `[]=`*[T](m: var Matrix[T], r: int, row: openArray[T]) = m.arr[r] = @row

    proc `[]`*[T](m: Matrix[T], r: int, c: int): T = m.arr[r][c]
    proc `[]`*[T](m: var Matrix[T], r: int, c: int): var T = m.arr[r][c]
    proc `[]=`*[T](m: var Matrix[T], r: int, c: int, val: T) = m.arr[r][c] = val

    proc `-`*[T](m: Matrix[T]): Matrix[T] = Matrix[T](arr: m.arr.mapIt(it.mapIt(-it)))
    proc `*=`*[T](a: var Matrix[T], b: Matrix[T]) =
        assert a.w == b.h
        var ans = initMatrix[T](a.h, b.w, 0)
        for i in 0..<a.h:
            for j in 0..<b.w:
                for k in 0..<a.w:
                    ans[i, j] += a[i, k] * b[k, j]
        swap(ans, a)
    proc `*=`*[T](a: var Matrix[T], x: T) =
        for i in 0..<a.h:
            for j in 0..<a.w:
                a[i, j] *= x
    proc `*`*[T](a, b: Matrix[T]): Matrix[T] = (result = a; result *= b)
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

    proc hash*[T](m: Matrix[T]): Hash = hash(m.arr)
    proc identity_matrix*[T](n: int, one, zero: T): Matrix[T] =
        result = initMatrix[T](n, n, zero)
        for i in 0..<n: result[i][i] = one
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
    proc sum*[T](m: Matrix[T]): T = m.arr.mapit(it.sum).sum

    proc gaussJordan*[T](m: Matrix[T]): tuple[matrix: Matrix[T], pivotColumns: seq[int]] =
        ## Returns the reduced row echelon form and its pivot columns.
        result.matrix = m
        var row = 0
        for col in 0..<m.w:
            var pivot = row
            while pivot < m.h and result.matrix[pivot, col] == default(T):
                pivot += 1
            if pivot == m.h:
                continue
            swap(result.matrix[pivot], result.matrix[row])
            let x = result.matrix[row, col]
            for j in col..<m.w:
                result.matrix[row, j] /= x
            for i in 0..<m.h:
                if i == row or result.matrix[i, col] == default(T):
                    continue
                let y = result.matrix[i, col]
                for j in col..<m.w:
                    result.matrix[i, j] -= y * result.matrix[row, j]
            result.pivotColumns.add(col)
            row += 1
            if row == m.h:
                break

    proc rank*[T](m: Matrix[T]): int = m.gaussJordan.pivotColumns.len

    proc solveLinearEquation*[T](a: Matrix[T], b: openArray[T]): Option[seq[T]] =
        ## Returns one solution of A*x=b (free variables are set to zero),
        ## or none when the system is inconsistent.
        assert a.h == b.len
        var augmented = initMatrix[T](a.h, a.w + 1, default(T))
        for i in 0..<a.h:
            for j in 0..<a.w:
                augmented[i, j] = a[i, j]
            augmented[i, a.w] = b[i]
        let reduced = augmented.gaussJordan
        for i in 0..<a.h:
            var allZero = true
            for j in 0..<a.w:
                if reduced.matrix[i, j] != default(T):
                    allZero = false
                    break
            if allZero and reduced.matrix[i, a.w] != default(T):
                return none(seq[T])
        var solution = newSeq[T](a.w)
        for i, col in reduced.pivotColumns:
            if col < a.w:
                solution[col] = reduced.matrix[i, a.w]
        some(solution)

    proc inverse*[T](m: Matrix[T]): Option[Matrix[T]] =
        assert m.h == m.w
        let n = m.h
        var augmented = initMatrix[T](n, 2 * n, default(T))
        let one: T = 1
        for i in 0..<n:
            for j in 0..<n:
                augmented[i, j] = m[i, j]
            augmented[i, n + i] = one
        let reduced = augmented.gaussJordan
        if reduced.pivotColumns.countIt(it < n) < n:
            return none(Matrix[T])
        var inv = initMatrix[T](n, n, default(T))
        for i in 0..<n:
            for j in 0..<n:
                inv[i, j] = reduced.matrix[i, n + j]
        some(inv)

    proc kernel*[T](m: Matrix[T]): seq[seq[T]] =
        ## A basis of {x | m*x=0}.
        let reduced = m.gaussJordan
        let one: T = 1
        var pivotRow = newSeqWith(m.w, -1)
        for i, col in reduced.pivotColumns:
            pivotRow[col] = i
        for freeCol in 0..<m.w:
            if pivotRow[freeCol] >= 0:
                continue
            var v = newSeq[T](m.w)
            v[freeCol] = one
            for pivotCol in 0..<m.w:
                if pivotRow[pivotCol] >= 0:
                    v[pivotCol] = -reduced.matrix[pivotRow[pivotCol], freeCol]
            result.add(v)

    proc image*[T](m: Matrix[T]): seq[seq[T]] =
        ## A basis of the column space, using columns of the original matrix.
        for col in m.gaussJordan.pivotColumns:
            var v = newSeq[T](m.h)
            for i in 0..<m.h:
                v[i] = m[i, col]
            result.add(v)
