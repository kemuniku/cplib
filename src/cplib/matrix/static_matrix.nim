when not declared CPLIB_MATRIX_MATRIX:
    const CPLIB_MATRIX_MATRIX* = 1
    import sequtils, strutils, hashes, std/math
    type StaticMatrix*[H : static int,W: static int,T] = object
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

    proc h*[H,W,T](m: StaticMatrix[H,W,T]): int = m.arr.len
    proc w*[H,W,T](m: StaticMatrix[H,W,T]): int =
        if m.h == 0: return 0
        m.arr[0].len
    proc `$`*[H,W,T](m: StaticMatrix[H,W,T]): string =
        for i in 0..<m.arr.len:
            result &= m.arr[i].mapIt($it).join(" ")
            if i != m.arr.len - 1: result &= "\n"
    proc `==`*[H,W,T](a, b: StaticMatrix[H,W,T]): bool = a.arr == b.arr
    # proc `[]`*[H,W,T](m: StaticMatrix[H,W,T], r: int): seq[H,W,T] = m.arr[r]
    # proc `[]`*[H,W,T](m: var StaticMatrix[H,W,T], r: int): var seq[H,W,T] = m.arr[r]
    # proc `[]=`*[H,W,T](m: var StaticMatrix[H,W,T], r: int, row: seq[H,W,T]) = m.arr[r] = row

    proc `[]`*[H,W,T](m: StaticMatrix[H,W,T], r: int, c: int): T = m.arr[r*W+c]
    proc `[]`*[H,W,T](m: var StaticMatrix[H,W,T], r: int, c: int): var T = m.arr[r*W+c]
    # proc `[]=`*[H,W,T](m: var StaticMatrix[H,W,T], r: int, c: int, val: T) = m.arr[r][c] = val

    proc `-`*[H,W,T](m: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] = StaticMatrix[H,W,T](arr: m.arr.mapIt(it.mapIt(-it)))
    proc `*=`*[H,W,T](a: var StaticMatrix[H,W,T], b: StaticMatrix[W,W,T]) =
        assert a.w == b.h
        var ans : StaticMatrix[H,W,T]
        for i in 0..<a.h:
            for j in 0..<b.w:
                for k in 0..<a.w:
                    ans[i, j] += a[i, k] * b[k, j]
        swap(ans, a)
    proc `*=`*[H,W,T](a: var StaticMatrix[H,W,T], x: T) =
        for i in 0..<a.h:
            for j in 0..<a.w:
                a[i, j] *= x
    proc `*`*[A,B,C,T](a: StaticMatrix[A,B,T],b:StaticMatrix[B,C,T]): StaticMatrix[A,C,T] =
        for i in 0..<A:
            for j in 0..<C:
                for k in 0..<B:
                    result[i, j] += a[i, k] * b[k, j]

    proc `*`*[H,W,T](a: StaticMatrix[H,W,T], x: T): StaticMatrix[H,W,T] = (result = a; result *= x)
    proc `*`*[H,W,T](x: T, a: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] = a * x
    template defineMatrixAssignmentOp(assign, op: untyped) =
        proc assign*[H,W,T](a: var StaticMatrix[H,W,T], b: StaticMatrix[H,W,T]) =
            assert a.h == b.h and a.w == b.w
            for i in 0..<a.h:
                for j in 0..<a.w:
                    assign(a[i, j], b[i, j])
        proc assign*[H,W,T](a: var StaticMatrix[H,W,T], x: T) =
            for i in 0..<a.h:
                for j in 0..<a.w:
                    assign(a[i, j], x)
        proc op*[H,W,T](a, b: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] = (result = a; assign(result, b))
        proc op*[H,W,T](a: StaticMatrix[H,W,T], x: T): StaticMatrix[H,W,T] = (result = a; assign(result, x))
        proc op*[H,W,T](x: T, a: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] = op(a, x)
    defineMatrixAssignmentOp(`+=`, `+`)
    defineMatrixAssignmentOp(`-=`, `-`)

    # template defineMatrixIntOps(assign, op: untyped) =
    #     proc assign*(a: var Matrix[int], b: Matrix[int]) =
    #         assert a.h == b.h and a.w == b.w
    #         for i in 0..<a.h:
    #             for j in 0..<a.w:
    #                 a[i, j] = op(a[i, j], b[i, j])
    #     proc assign*(a: var Matrix[int], x: int) =
    #         for i in 0..<a.h:
    #             for j in 0..<a.w:
    #                 a[i, j] = op(a[i, j], x)
    #     proc op*(a, b: Matrix[int]): Matrix[int] = (result = a; assign(result, b))
    #     proc op*(a: Matrix[int], x: int): Matrix[int] = (result = a; assign(result, x))
    #     proc op*(x: int, a: Matrix[int]): Matrix[int] = op(a, x)
    # defineMatrixIntOps(`and=`, `and`)
    # defineMatrixIntOps(`or=`, `or`)
    # defineMatrixIntOps(`xor=`, `xor`)
    # defineMatrixIntOps(`shl=`, `shl`)
    # defineMatrixIntOps(`shr=`, `shr`)
    # defineMatrixIntOps(`div=`, `div`)
    # defineMatrixIntOps(`mod=`, `mod`)

    proc hash*[H,W,T](m: StaticMatrix[H,W,T]): Hash = hash(m.arr)
    # proc identity_matrix*[H,W,T](n: int, one, zero: T): StaticMatrix[H,W,T] =
    #     result = initStaticMatrix[H,W,T](n, n, zero)
    #     for i in 0..<n: result[i][i] = one
    proc identity_matrix*[H,W,T](n: int): StaticMatrix[H,W,T] = identity_matrix[H,W,T](n, 1, 0)
    proc pow*[H,W,T](m: StaticMatrix[H,W,T], n: int): StaticMatrix[H,W,T] =
        result = identity_matrix[H,W,T](m.h)
        var m = m
        var n = n
        while n > 0:
            if (n and 1) == 1: result *= m
            m *= m
            n = n shr 1
    proc `**`*[H,W,T](m: StaticMatrix[H,W,T], n: int): StaticMatrix[H,W,T] = m.pow(n)
    proc sum*[H,W,T](m: StaticMatrix[H,W,T]): T = m.arr.mapit(it.sum).sum

var tmp = [[1,2,3],[4,5,6]].initMatrix()