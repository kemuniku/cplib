when not declared CPLIB_MATRIX_MATRIX:
    const CPLIB_MATRIX_MATRIX* = 1
    import sequtils, strutils, hashes, std/math
    type Matrix*[T] = object
        arr: seq[seq[T]]
    proc initMatrix*[T](arr: seq[seq[T]]): Matrix[T] =
        assert arr.len == 0 or arr.mapIt(it.len).toHashSet.len == 1, "all elements in arr must be the same size."
        Matrix[T](arr: arr)
    proc toMatrix*[T](arr: seq[seq[T]]): Matrix[T] = initMatrix(arr)
    proc initMatrix*[T](arr: seq[T], vertical: bool = false): Matrix[T] =
        if vertical: Matrix[T](arr: arr.mapIt(@[it]))
        else: Matrix[T](arr: @[arr])
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
    proc `[]=`*[T](m: var Matrix[T], r: int, row: seq[T]) = m.arr[r] = row

    proc `[]`*[T](m: Matrix[T], r: int, c: int): T = m.arr[r][c]
    proc `[]`*[T](m: var Matrix[T], r: int, c: int): var T = m.arr[r][c]
    proc `[]=`*[T](m: var Matrix[T], r: int, c: int, val: T) = m.arr[r][c] = val

    proc `-`*[T](m: Matrix[T]): Matrix[T] = Matrix[T](arr: m.arr.mapIt(it.mapIt(-it)))
    proc `@=`*[T](a: var Matrix[T], b: Matrix[T]) =
        assert a.w == b.h
        var ans = initMatrix[T](a.h, b.w, 0)
        for i in 0..<a.h:
            for j in 0..<b.w:
                for k in 0..<a.w:
                    ans[i, j] += a[i, k] * b[k, j]
        swap(ans, a)
    proc `@`*[T](a, b: Matrix[T]): Matrix[T] = (result = a; result @= b)
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
    defineMatrixAssignmentOp(`*=`, `*`)
    defineMatrixAssignmentOp(`/=`, `/`)

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
            if (n and 1) == 1: result @= m
            m @= m
            n = n shr 1
    proc sum*[T](m: Matrix[T]): T = m.arr.mapit(it.sum).sum
