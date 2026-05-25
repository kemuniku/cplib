when not declared CPLIB_MATRIX_STATIC_MATRIX:
    const CPLIB_MATRIX_STATIC_MATRIX* = 1
    import sequtils, hashes
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
