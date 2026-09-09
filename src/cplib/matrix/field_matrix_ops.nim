when not declared CPLIB_MATRIX_FIELD_MATRIX_OPS:
    const CPLIB_MATRIX_FIELD_MATRIX_OPS* = 1
    import options, sequtils

    type LinearSystemSolution*[T] = object
        particular*: seq[T]
        basis*: seq[seq[T]]

    template fieldZero(T: typedesc): untyped =
        when T is bool: false
        else: T(0)
    template fieldOne(T: typedesc): untyped =
        when T is bool: true
        else: T(1)
    template fieldSub(a, b: untyped): untyped =
        when a is bool: a xor b
        else: a - b
    template fieldMul(a, b: untyped): untyped =
        when a is bool: a and b
        else: a * b
    template fieldEqual(a, b: untyped): untyped =
        # Montgomery modintは同じ値に複数の内部表現を持つため公開値で比較する。
        when compiles(a.val) and compiles(a.umod): a.val == b.val
        else: a == b
    template fieldInv(a: untyped): untyped =
        when a is bool: true
        else: fieldOne(typeof(a)) / a

    proc matrixRows*[M](a: M, height, width: int): auto =
        ## 左上のheight行width列を独立した作業領域へコピーする。O(height*width)。
        mixin h, w, `[]`
        assert height in 0..a.h and width in 0..a.w
        type T = typeof(a[0, 0])
        var rows = newSeqWith(height, newSeq[T](width))
        for i in 0..<height:
            for j in 0..<width: rows[i][j] = a[i, j]
        rows

    proc fieldEchelon[T](a: var seq[seq[T]], columns: int): tuple[pivots: seq[int], determinant: T] =
        ## 先頭columns列を前進消去する。体の正確な零判定が必要。O(h*w*min(h,columns))。
        result.determinant = fieldOne(T)
        for col in 0..<columns:
            let r = result.pivots.len
            if r == a.len: break
            var pivot = r
            while pivot < a.len and fieldEqual(a[pivot][col], fieldZero(T)): inc pivot
            if pivot == a.len: continue
            if pivot != r:
                swap(a[pivot], a[r])
                result.determinant = fieldSub(fieldZero(T), result.determinant)
            let value = a[r][col]
            result.determinant = fieldMul(result.determinant, value)
            let inverse = fieldInv(value)
            for j in col..<a[r].len: a[r][j] = fieldMul(a[r][j], inverse)
            for i in r+1..<a.len:
                let factor = a[i][col]
                if fieldEqual(factor, fieldZero(T)): continue
                a[i][col] = fieldZero(T)
                for j in col+1..<a[i].len:
                    a[i][j] = fieldSub(a[i][j], fieldMul(factor, a[r][j]))
            result.pivots.add(col)

    proc fieldRank*[T](rows: seq[seq[T]], width: int): int =
        ## 行列の階数を求める。O(h*w*min(h,w))。
        var a = rows
        fieldEchelon(a, width).pivots.len

    proc fieldDeterminant*[T](rows: seq[seq[T]]): T =
        ## 正方行列の行列式を求める。空行列は1。O(n^3)。
        var a = rows
        let e = fieldEchelon(a, a.len)
        if e.pivots.len == a.len: e.determinant
        else: fieldZero(T)

    proc fieldSolve*[T](rows: seq[seq[T]], width: int, b: openArray[T]): Option[LinearSystemSolution[T]] =
        ## Ax=bの特殊解と核の基底を返す。解なしはnone。O(h*w*min(h,w)+w^2*min(h,w))。
        assert b.len == rows.len
        var a = rows
        for i in 0..<a.len: a[i].add(b[i])
        let pivots = fieldEchelon(a, width).pivots
        for i in pivots.len..<a.len:
            if not fieldEqual(a[i][width], fieldZero(T)): return none(LinearSystemSolution[T])
        var solution: LinearSystemSolution[T]
        solution.particular = newSeq[T](width)
        for r in countdown(pivots.len-1, 0):
            let col = pivots[r]
            var value = a[r][width]
            for j in col+1..<width:
                value = fieldSub(value, fieldMul(a[r][j], solution.particular[j]))
            solution.particular[col] = value
        var isPivot = newSeq[bool](width)
        for col in pivots: isPivot[col] = true
        for free in 0..<width:
            if isPivot[free]: continue
            var vector = newSeq[T](width)
            vector[free] = fieldOne(T)
            for r in countdown(pivots.len-1, 0):
                let col = pivots[r]
                for j in col+1..<width:
                    vector[col] = fieldSub(vector[col], fieldMul(a[r][j], vector[j]))
            solution.basis.add(vector)
        some(solution)

    proc fieldAdjugateInverse*[T](rows: seq[seq[T]], adjugate: bool): Option[seq[seq[T]]] =
        ## 消去の変換行列から逆行列または余因子行列を求める。特異行列もO(n^3)。
        let n = rows.len
        var a = rows
        for i in 0..<n:
            a[i].setLen(2*n)
            a[i][n+i] = fieldOne(T)
        let e = fieldEchelon(a, n)
        let rank = e.pivots.len
        if not adjugate and rank != n: return none(seq[seq[T]])
        var answer = newSeqWith(n, newSeq[T](n))
        if rank < n-1: return some(answer)
        for r in countdown(rank-1, 0):
            let col = e.pivots[r]
            for i in 0..<r:
                let factor = a[i][col]
                if fieldEqual(factor, fieldZero(T)): continue
                a[i][col] = fieldZero(T)
                for j in col+1..<2*n:
                    a[i][j] = fieldSub(a[i][j], fieldMul(factor, a[r][j]))
        if rank == n:
            let scale = if adjugate: e.determinant else: fieldOne(T)
            for i in 0..<n:
                for j in 0..<n: answer[i][j] = fieldMul(scale, a[i][n+j])
        else:
            var free = 0
            for col in e.pivots:
                if col == free: inc free
            var scale = e.determinant
            if ((n-1-free) and 1) != 0: scale = fieldSub(fieldZero(T), scale)
            for j in 0..<n:
                answer[free][j] = fieldMul(scale, a[n-1][n+j])
                for r, col in e.pivots:
                    answer[col][j] = fieldSub(fieldZero(T), fieldMul(a[r][free], answer[free][j]))
        some(answer)

    proc fieldHafnian*[T](rows: seq[seq[T]]): T =
        ## 対称な偶数次行列のhafnianを包除原理で求める。O(n^2*2^(n/2))時間、O(n^4)空間。
        let n = rows.len
        assert n mod 2 == 0
        for i in 0..<n:
            for j in 0..<i: assert fieldEqual(rows[i][j], rows[j][i])
        when T is bool:
            # 標数2では対角を零にした対称行列の行列式と一致する。
            var a = rows
            for i in 0..<n: a[i][i] = false
            return fieldDeterminant(a)
        else:
            let degree = n div 2
            let stride = degree+1
            proc addProduct(target: var seq[T], offset: int, a: seq[T], x, y: int) =
                ## x倍した多項式積をdegree次で打ち切って加算する。
                for i in 0..<degree:
                    if fieldEqual(a[x+i], T(0)): continue
                    for j in 0..<degree-i:
                        target[offset+i+j+1] += a[x+i] * a[y+j]
            proc solve(a: seq[T], size: int): seq[T] =
                ## 最後の2頂点を使う項を包除し、多項式の係数を返す。
                result = newSeq[T](stride)
                if size == 0:
                    result[0] = T(1)
                    return
                let m = size-2
                let endOffset = m*(m-1) div 2*stride
                var reduced = a[0..<endOffset]
                let without = solve(reduced, m)
                let u = m*(m-1) div 2*stride
                let v = m*(m+1) div 2*stride
                for i in 0..<m:
                    for j in 0..<i:
                        let offset = (i*(i-1) div 2+j)*stride
                        addProduct(reduced, offset, a, u+i*stride, v+j*stride)
                        addProduct(reduced, offset, a, v+i*stride, u+j*stride)
                let withPair = solve(reduced, m)
                for i in 0..degree: result[i] = withPair[i]-without[i]
                for i in 0..<degree:
                    for j in 0..<degree-i:
                        result[i+j+1] += withPair[i]*a[v+m*stride+j]
            var a = newSeq[T](n*(n-1) div 2*stride)
            for i in 0..<n:
                for j in 0..<i: a[(i*(i-1) div 2+j)*stride] = rows[i][j]
            solve(a, n)[degree]
