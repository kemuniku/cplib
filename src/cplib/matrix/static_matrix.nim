when not declared CPLIB_MATRIX_STATIC_MATRIX:
    const CPLIB_MATRIX_STATIC_MATRIX* = 1
    import sequtils, hashes, options
    type StaticMatrix*[H: static int, W: static int, T] = object
        arr: array[H*W,T]
    type SubArray*[H:static int,W:static int,T] = object
        mat: ref StaticMatrix[H,W,T]
        idx : int
    
    proc initMatrix*[H:static int,W:static int,T](arr: array[H,array[W,T]]): StaticMatrix[H,W,T] =
        assert arr.len == 0 or arr.mapIt(it.len).allIt(it == arr[0].len), "all elements in arr must be the same size."
        assert arr[0].len == W
        assert arr.len == H
        var idx = 0
        for i in 0..<H:
            for j in 0..<W:
                result.arr[idx] = arr[i][j]
                idx += 1

    proc toMatrix*[H:static int,W:static int,T](arr: array[H,array[W,T]]): StaticMatrix[H,W,T] = initMatrix(arr)

    proc initMatrix*[H: static int, W: static int, T](val: T): StaticMatrix[H,W,T] =
        for i in 0..<H*W:
            result.arr[i] = val

    proc h*[H: static int, W: static int, T](m: StaticMatrix[H,W,T]): int = H
    proc w*[H: static int, W: static int, T](m: StaticMatrix[H,W,T]): int = W
    proc `$`*[H: static int, W: static int, T](m: StaticMatrix[H,W,T]): string =
        for i in 0..<H:
            for j in 0..<W:
                if j != 0: result &= " "
                result &= $m[i, j]
            if i != H - 1: result &= "\n"
    proc `==`*[H: static int, W: static int, T](a, b: StaticMatrix[H,W,T]): bool = a.arr == b.arr
    proc `[]`*[H: static int, W: static int, T](m: StaticMatrix[H,W,T], r: int): array[W,T] =
        for j in 0..<W:
            result[j] = m[r, j]
    proc `[]=`*[H: static int, W: static int, T](m: var StaticMatrix[H,W,T], r: int, row: array[W,T]) =
        for j in 0..<W:
            m[r, j] = row[j]

    proc `[]`*[H: static int, W: static int, T](m: StaticMatrix[H,W,T], r: int, c: int): T = m.arr[r*W+c]
    proc `[]`*[H: static int, W: static int, T](m: var StaticMatrix[H,W,T], r: int, c: int): var T = m.arr[r*W+c]
    proc `[]=`*[H: static int, W: static int, T](m: var StaticMatrix[H,W,T], r: int, c: int, val: T) = m.arr[r*W+c] = val

    proc `-`*[H: static int, W: static int, T](m: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] =
        for i in 0..<H*W:
            result.arr[i] = -m.arr[i]
    proc `*=`*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], b: StaticMatrix[W,W,T]) =
        assert a.w == b.h
        var ans : StaticMatrix[H,W,T]
        for i in 0..<a.h:
            for j in 0..<b.w:
                for k in 0..<a.w:
                    ans[i, j] += a[i, k] * b[k, j]
        swap(ans, a)
    proc `*=`*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], x: T) =
        for i in 0..<a.h:
            for j in 0..<a.w:
                a[i, j] *= x
    proc `*`*[A: static int, B: static int, C: static int, T](a: StaticMatrix[A,B,T],b:StaticMatrix[B,C,T]): StaticMatrix[A,C,T] =
        for i in 0..<A:
            for j in 0..<C:
                for k in 0..<B:
                    result[i, j] += a[i, k] * b[k, j]

    proc `*`*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], x: T): StaticMatrix[H,W,T] = (result = a; result *= x)
    proc `*`*[H: static int, W: static int, T](x: T, a: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] = a * x
    template defineMatrixAssignmentOp(assign, op: untyped) =
        proc assign*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], b: StaticMatrix[H,W,T]) =
            assert a.h == b.h and a.w == b.w
            for i in 0..<a.h:
                for j in 0..<a.w:
                    assign(a[i, j], b[i, j])
        proc assign*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], x: T) =
            for i in 0..<a.h:
                for j in 0..<a.w:
                    assign(a[i, j], x)
        proc op*[H: static int, W: static int, T](a, b: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] = (result = a; assign(result, b))
        proc op*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], x: T): StaticMatrix[H,W,T] = (result = a; assign(result, x))
        proc op*[H: static int, W: static int, T](x: T, a: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] = op(a, x)
    defineMatrixAssignmentOp(`+=`, `+`)
    defineMatrixAssignmentOp(`-=`, `-`)

    template defineMatrixIntOps(assign, op: untyped) =
        proc assign*[H: static int, W: static int](a: var StaticMatrix[H,W,int], b: StaticMatrix[H,W,int]) =
            assert a.h == b.h and a.w == b.w
            for i in 0..<a.h:
                for j in 0..<a.w:
                    a[i, j] = op(a[i, j], b[i, j])
        proc assign*[H: static int, W: static int](a: var StaticMatrix[H,W,int], x: int) =
            for i in 0..<a.h:
                for j in 0..<a.w:
                    a[i, j] = op(a[i, j], x)
        proc op*[H: static int, W: static int](a, b: StaticMatrix[H,W,int]): StaticMatrix[H,W,int] = (result = a; assign(result, b))
        proc op*[H: static int, W: static int](a: StaticMatrix[H,W,int], x: int): StaticMatrix[H,W,int] = (result = a; assign(result, x))
        proc op*[H: static int, W: static int](x: int, a: StaticMatrix[H,W,int]): StaticMatrix[H,W,int] = op(a, x)
    defineMatrixIntOps(`and=`, `and`)
    defineMatrixIntOps(`or=`, `or`)
    defineMatrixIntOps(`xor=`, `xor`)
    defineMatrixIntOps(`shl=`, `shl`)
    defineMatrixIntOps(`shr=`, `shr`)
    defineMatrixIntOps(`div=`, `div`)
    defineMatrixIntOps(`mod=`, `mod`)

    proc hash*[H: static int, W: static int, T](m: StaticMatrix[H,W,T]): Hash = hash(m.arr)
    proc identity_matrix*[H: static int, W: static int, T](n: int, one, zero: T): StaticMatrix[H,W,T] =
        assert H == W and n == H
        for i in 0..<H*W:
            result.arr[i] = zero
        for i in 0..<H: result[i, i] = one
    proc identity_matrix*[H: static int, W: static int, T](n: int): StaticMatrix[H,W,T] =
        assert H == W and n == H
        for i in 0..<H: result[i, i] = T(1)
    proc pow*[H: static int, W: static int, T](m: StaticMatrix[H,W,T], n: int): StaticMatrix[H,W,T] =
        assert H == W
        for i in 0..<H: result[i, i] = T(1)
        var m = m
        var n = n
        while n > 0:
            if (n and 1) == 1: result *= m
            m *= m
            n = n shr 1
    proc `**`*[H: static int, W: static int, T](m: StaticMatrix[H,W,T], n: int): StaticMatrix[H,W,T] = m.pow(n)
    proc sum*[H: static int, W: static int, T](m: StaticMatrix[H,W,T]): T =
        for i in 0..<H*W:
            result += m.arr[i]

    proc gaussJordan*[H: static int, W: static int, T](m: StaticMatrix[H,W,T]):
            tuple[matrix: StaticMatrix[H,W,T], pivotColumns: seq[int]] =
        ## Returns the reduced row echelon form and its pivot columns.
        result.matrix = m
        var row = 0
        for col in 0..<W:
            var pivot = row
            while pivot < H and result.matrix[pivot, col] == default(T):
                pivot += 1
            if pivot == H:
                continue
            for j in 0..<W:
                swap(result.matrix[pivot, j], result.matrix[row, j])
            let x = result.matrix[row, col]
            for j in col..<W:
                result.matrix[row, j] /= x
            for i in 0..<H:
                if i == row or result.matrix[i, col] == default(T):
                    continue
                let y = result.matrix[i, col]
                for j in col..<W:
                    result.matrix[i, j] -= y * result.matrix[row, j]
            result.pivotColumns.add(col)
            row += 1
            if row == H:
                break

    proc rank*[H: static int, W: static int, T](m: StaticMatrix[H,W,T]): int =
        m.gaussJordan.pivotColumns.len

    proc solveLinearEquation*[H: static int, W: static int, T](
            a: StaticMatrix[H,W,T], b: array[H,T]): Option[array[W,T]] =
        ## Returns one solution of A*x=b (free variables are set to zero),
        ## or none when the system is inconsistent.
        var augmented: StaticMatrix[H,W + 1,T]
        for i in 0..<H:
            for j in 0..<W:
                augmented[i, j] = a[i, j]
            augmented[i, W] = b[i]
        let reduced = augmented.gaussJordan
        for i in 0..<H:
            var allZero = true
            for j in 0..<W:
                if reduced.matrix[i, j] != default(T):
                    allZero = false
                    break
            if allZero and reduced.matrix[i, W] != default(T):
                return none(array[W,T])
        var solution: array[W,T]
        for i, col in reduced.pivotColumns:
            if col < W:
                solution[col] = reduced.matrix[i, W]
        some(solution)

    proc inverse*[N: static int, T](m: StaticMatrix[N,N,T]): Option[StaticMatrix[N,N,T]] =
        var augmented: StaticMatrix[N,2 * N,T]
        let one: T = 1
        for i in 0..<N:
            for j in 0..<N:
                augmented[i, j] = m[i, j]
            augmented[i, N + i] = one
        let reduced = augmented.gaussJordan
        if reduced.pivotColumns.countIt(it < N) < N:
            return none(StaticMatrix[N,N,T])
        var inv: StaticMatrix[N,N,T]
        for i in 0..<N:
            for j in 0..<N:
                inv[i, j] = reduced.matrix[i, N + j]
        some(inv)

    proc kernel*[H: static int, W: static int, T](m: StaticMatrix[H,W,T]): seq[array[W,T]] =
        ## A basis of {x | m*x=0}.
        let reduced = m.gaussJordan
        let one: T = 1
        var pivotRow: array[W,int]
        for j in 0..<W:
            pivotRow[j] = -1
        for i, col in reduced.pivotColumns:
            pivotRow[col] = i
        for freeCol in 0..<W:
            if pivotRow[freeCol] >= 0:
                continue
            var v: array[W,T]
            v[freeCol] = one
            for pivotCol in 0..<W:
                if pivotRow[pivotCol] >= 0:
                    v[pivotCol] = -reduced.matrix[pivotRow[pivotCol], freeCol]
            result.add(v)

    proc image*[H: static int, W: static int, T](m: StaticMatrix[H,W,T]): seq[array[H,T]] =
        ## A basis of the column space, using columns of the original matrix.
        for col in m.gaussJordan.pivotColumns:
            var v: array[H,T]
            for i in 0..<H:
                v[i] = m[i, col]
            result.add(v)
