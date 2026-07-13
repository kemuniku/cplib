when not declared CPLIB_MATRIX_TRANSFORMABLE_MATRIX:
    const CPLIB_MATRIX_TRANSFORMABLE_MATRIX* = 1

    type
        AxisView = object
            baseAxis: int
            reversed: bool

        TransformableMatrix*[T] = object
            data: seq[seq[T]]
            size: array[2, int]
            order: array[2, seq[int]]
            view: array[2, AxisView]

    proc initTransformableMatrix*[T](a: openArray[seq[T]]): TransformableMatrix[T] =
        ## `a` から行列を構築します。計算量は O(HW) です。
        let h = a.len
        let w = if h == 0: 0 else: a[0].len
        for row in a:
            assert row.len == w, "all rows must have the same length"

        result.data = @a
        result.size = [h, w]
        for axis in 0..1:
            result.order[axis].setLen(result.size[axis])
            for i in 0..<result.size[axis]:
                result.order[axis][i] = i
        result.view = [AxisView(baseAxis: 0), AxisView(baseAxis: 1)]

    proc toTransformableMatrix*[T](a: openArray[seq[T]]): TransformableMatrix[T] =
        initTransformableMatrix(a)

    proc axisLen[T](m: TransformableMatrix[T], axis: int): int {.inline.} =
        m.size[m.view[axis].baseAxis]

    proc h*[T](m: TransformableMatrix[T]): int {.inline.} = m.axisLen(0)
    proc w*[T](m: TransformableMatrix[T]): int {.inline.} = m.axisLen(1)

    proc baseIndex[T](m: TransformableMatrix[T], axis, index: int): int {.inline.} =
        let v = m.view[axis]
        let position = if v.reversed: m.size[v.baseAxis] - 1 - index else: index
        m.order[v.baseAxis][position]

    proc basePosition[T](m: TransformableMatrix[T], axis, index: int): int {.inline.} =
        let v = m.view[axis]
        if v.reversed: m.size[v.baseAxis] - 1 - index else: index

    proc `[]`*[T](m: TransformableMatrix[T], i, j: int): T {.inline.} =
        ## 現在の見た目における (i, j) の要素を O(1) で返します。
        assert 0 <= i and i < m.h and 0 <= j and j < m.w
        var p: array[2, int]
        p[m.view[0].baseAxis] = m.baseIndex(0, i)
        p[m.view[1].baseAxis] = m.baseIndex(1, j)
        m.data[p[0]][p[1]]

    proc `[]`*[T](m: var TransformableMatrix[T], i, j: int): var T {.inline.} =
        ## 現在の見た目における (i, j) の要素への参照を O(1) で返します。
        assert 0 <= i and i < m.h and 0 <= j and j < m.w
        var p: array[2, int]
        p[m.view[0].baseAxis] = m.baseIndex(0, i)
        p[m.view[1].baseAxis] = m.baseIndex(1, j)
        m.data[p[0]][p[1]]

    proc `[]=`*[T](m: var TransformableMatrix[T], i, j: int, value: T) {.inline.} =
        assert 0 <= i and i < m.h and 0 <= j and j < m.w
        var p: array[2, int]
        p[m.view[0].baseAxis] = m.baseIndex(0, i)
        p[m.view[1].baseAxis] = m.baseIndex(1, j)
        m.data[p[0]][p[1]] = value

    proc swapRows*[T](m: var TransformableMatrix[T], i, j: int) {.inline.} =
        ## 現在の i 行目と j 行目を O(1) で交換します。
        assert 0 <= i and i < m.h and 0 <= j and j < m.h
        let axis = m.view[0].baseAxis
        swap(m.order[axis][m.basePosition(0, i)], m.order[axis][m.basePosition(0, j)])

    proc swapColumns*[T](m: var TransformableMatrix[T], i, j: int) {.inline.} =
        ## 現在の i 列目と j 列目を O(1) で交換します。
        assert 0 <= i and i < m.w and 0 <= j and j < m.w
        let axis = m.view[1].baseAxis
        swap(m.order[axis][m.basePosition(1, i)], m.order[axis][m.basePosition(1, j)])

    proc transpose*[T](m: var TransformableMatrix[T]) {.inline.} =
        ## 転置します。計算量は O(1) です。
        swap(m.view[0], m.view[1])

    proc rotate*[T](m: var TransformableMatrix[T], num: int = 1) =
        ## 時計回りに 90 度ずつ `num` 回転します。計算量は O(1) です。
        var num = num mod 4
        if num < 0: num += 4
        for _ in 0..<num:
            let oldRow = m.view[0]
            m.view[0] = m.view[1]
            m.view[1] = oldRow
            m.view[1].reversed = not m.view[1].reversed

    proc toSeq*[T](m: TransformableMatrix[T]): seq[seq[T]] =
        ## 現在の見た目を二次元 seq として返します。計算量は O(HW) です。
        result.setLen(m.h)
        for i in 0..<m.h:
            result[i].setLen(m.w)
            for j in 0..<m.w:
                result[i][j] = m[i, j]
