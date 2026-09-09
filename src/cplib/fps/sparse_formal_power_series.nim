when not declared CPLIB_FPS_SPARSE_FORMAL_POWER_SERIES:
    const CPLIB_FPS_SPARSE_FORMAL_POWER_SERIES* = 1

    import algorithm, macros, options
    import cplib/convolution/convolution
    import cplib/fps/bostan_mori
    import cplib/fps/formal_power_series
    import cplib/fps/product_tree
    import cplib/math/isqrt
    import cplib/modint/modint

    type
        SparseTerm*[T] = tuple[degree: int, coefficient: T]

        SparseFPS*[T] = seq[SparseTerm[T]]

        LinearPolynomial[T] = tuple[constant, linear: T]

    proc initSparseFPS*[T](terms: openArray[SparseTerm[T]]): SparseFPS[T] =
        ## 次数の重複をまとめ、零係数を除いた疎なFPSを構築する。
        result = @terms
        for term in result:
            doAssert term.degree >= 0, "疎なFPSの次数は非負である必要がある"
        result.sort(proc(a, b: SparseTerm[T]): int = cmp(a.degree, b.degree))
        var normalized: seq[SparseTerm[T]]
        for term in result:
            if term.coefficient.val == 0: continue
            if normalized.len > 0 and normalized[^1].degree == term.degree:
                normalized[^1].coefficient += term.coefficient
                if normalized[^1].coefficient.val == 0: normalized.setLen(normalized.len - 1)
            else:
                normalized.add(term)
        result = move(normalized)

    proc sparseMonomialDegree(node: NimNode): NimNode {.compileTime.} =
        if node.eqIdent("x"): return newLit(1)
        if node.kind == nnkInfix and node.len == 3 and
                node[0].eqIdent("^") and node[1].eqIdent("x"):
            return node[2]
        nil

    proc collectSparseTerms(node: NimNode, sign: int,
            terms: var seq[tuple[degree, coefficient: NimNode]]) {.compileTime.} =
        if node.kind == nnkInfix and node.len == 3 and node[0].eqIdent("+"):
            collectSparseTerms(node[1], sign, terms)
            collectSparseTerms(node[2], sign, terms)
            return
        if node.kind == nnkInfix and node.len == 3 and node[0].eqIdent("-"):
            collectSparseTerms(node[1], sign, terms)
            collectSparseTerms(node[2], -sign, terms)
            return
        if node.kind == nnkPrefix and node.len == 2 and node[0].eqIdent("-"):
            collectSparseTerms(node[1], -sign, terms)
            return

        var degree = sparseMonomialDegree(node)
        var coefficient = newLit(1)
        if degree == nil and node.kind == nnkInfix and node.len == 3 and
                node[0].eqIdent("*"):
            degree = sparseMonomialDegree(node[2])
            if degree != nil:
                coefficient = node[1]
            else:
                degree = sparseMonomialDegree(node[1])
                if degree != nil: coefficient = node[2]
        if degree == nil:
            if node.findChild(it.eqIdent("x")) != nil:
                error("SFPSの各項は coefficient * x^degree の形で指定してください", node)
            degree = newLit(0)
            coefficient = node
        if sign < 0: coefficient = newTree(nnkPrefix, ident("-"), coefficient)
        terms.add((degree, coefficient))

    proc buildSparseFPS(coefficientType, expression: NimNode): NimNode {.compileTime.} =
        var terms: seq[tuple[degree, coefficient: NimNode]]
        collectSparseTerms(expression, 1, terms)
        var termNodes = newNimNode(nnkBracket)
        for term in terms:
            let coefficient = newCall(bindSym("init"), coefficientType.copyNimTree,
                term.coefficient)
            termNodes.add(newTree(nnkTupleConstr,
                newTree(nnkExprColonExpr, ident("degree"), term.degree),
                newTree(nnkExprColonExpr, ident("coefficient"), coefficient)))
        let constructor = newTree(nnkBracketExpr, bindSym("initSparseFPS"),
            coefficientType.copyNimTree)
        newCall(constructor, termNodes)

    macro sparseFPSLiteral(coefficientType,
            expression: untyped): untyped =
        buildSparseFPS(coefficientType, expression)

    template sfps*[T](expression: untyped): untyped =
        ## 多項式風の式から疎なFPSを構築する。
        ## 指数には非負のint式を指定できる。
        ## 例: sfps[Mint](1 + 2*x - x^3 + x^k)
        sparseFPSLiteral(type(T), expression)

    template SFPS*[T](expression: untyped): untyped =
        ## sfpsの大文字始まりの別名。
        sparseFPSLiteral(type(T), expression)

    proc `+`*[T](f: SparseFPS[T], c: SomeInteger): SparseFPS[T] =
        result = f
        let constant = init(T, c)
        if constant.val == 0: return
        if result.len == 0 or result[0].degree > 0:
            result.insert((degree: 0, coefficient: constant), 0)
        else:
            result[0].coefficient += constant
            if result[0].coefficient.val == 0: result.delete(0)

    proc `+`*[T](c: SomeInteger, f: SparseFPS[T]): SparseFPS[T] = f + c

    proc `+=`*[T](f: var SparseFPS[T], c: SomeInteger) =
        f = f + c

    proc isZero*[T](f: SparseFPS[T]): bool = f.len == 0

    proc degree*[T](f: SparseFPS[T]): int =
        ## 零FPSに対しては -1 を返す。
        if f.len == 0: -1 else: f[^1].degree

    proc coefficient*[T](f: SparseFPS[T], degree: int): T =
        ## 指定した次数の係数を返す。項が存在しなければ零を返す。
        if degree < 0: return init(T, 0)
        var left = 0
        var right = f.len
        while left < right:
            let middle = (left + right) shr 1
            if f[middle].degree < degree: left = middle + 1
            else: right = middle
        if left < f.len and f[left].degree == degree:
            result = f[left].coefficient

    proc constantTerm*[T](f: SparseFPS[T]): T =
        f.coefficient(0)

    proc toDense*[T](f: SparseFPS[T], n: int): seq[T] =
        ## x^n で打ち切った密な係数列へ変換する。
        if n <= 0: return @[]
        result = newSeq[T](n)
        for (degree, coefficient) in f:
            if degree >= n: break
            result[degree] = coefficient

    proc truncated[T](f: SparseFPS[T], n: int): SparseFPS[T] =
        for term in f:
            if term.degree >= n: break
            result.add(term)

    proc mulPrefix*[T](f: seq[T], g: SparseFPS[T], n: int): seq[T] =
        ## 密なFPSと疎なFPSの積を x^n で打ち切って返す。
        if n <= 0: return @[]
        result = newSeq[T](n)
        for (degree, coefficient) in g:
            if degree >= n: break
            for i in 0..<min(f.len, n - degree):
                result[i + degree] += f[i] * coefficient

    proc `*`*[T](f: seq[T], g: SparseFPS[T]): seq[T] =
        if f.len == 0 or g.isZero: return @[]
        f.mulPrefix(g, f.len + g.degree)

    proc `*`*[T](f: SparseFPS[T], g: seq[T]): seq[T] = g * f

    proc `*=`*[T](f: var seq[T], g: SparseFPS[T]) =
        ## fの長さを保ち、疎なFPSを掛けた結果で置き換える。
        let n = f.len
        f = f.mulPrefix(g, n)

    proc divPrefix*[T](f: seq[T], g: SparseFPS[T], n: int): seq[T] =
        ## f / g を x^n で打ち切って返す。
        if n <= 0: return @[]
        let constant = g.constantTerm
        doAssert constant.val != 0, "疎なFPSによる除算では分母の定数項が非零である必要がある"
        let constantInverse = constant.inv
        result = newSeq[T](n)
        for i in 0..<n:
            if i < f.len: result[i] = f[i]
            for (degree, coefficient) in g:
                if degree == 0: continue
                if degree > i: break
                result[i] -= coefficient * result[i - degree]
            result[i] *= constantInverse

    proc `/`*[T](f: seq[T], g: SparseFPS[T]): seq[T] = f.divPrefix(g, f.len)

    proc `/=`*[T](f: var seq[T], g: SparseFPS[T]) =
        ## fの長さを保ち、疎なFPSで割った結果で置き換える。
        let n = f.len
        f = f.divPrefix(g, n)

    proc inv*[T](f: SparseFPS[T], n: int): seq[T] =
        ## 疎なFPSの乗法逆元を x^n で打ち切って返す。
        @[init(T, 1)].divPrefix(f, n)

    proc exp*[T](f: SparseFPS[T], n: int): seq[T] =
        ## 疎なFPSの形式的指数関数を x^n で打ち切って返す。
        if n <= 0: return @[]
        doAssert n <= T.umod.int, "疎なFPSの形式的指数関数では n が法以下である必要がある"
        doAssert f.constantTerm.val == 0,
            "疎なFPSの形式的指数関数では定数項が0である必要がある"
        result = newSeq[T](n)
        result[0] = 1
        for degree in 1..<n:
            for term in f:
                if term.degree == 0: continue
                if term.degree > degree: break
                result[degree] += init(T, term.degree) * term.coefficient *
                    result[degree - term.degree]
            result[degree] /= degree

    proc log*[T](f: SparseFPS[T], n: int): seq[T] =
        ## 疎なFPSの形式的対数を x^n で打ち切って返す。
        if n <= 0: return @[]
        doAssert n <= T.umod.int, "疎なFPSの形式的対数では n が法以下である必要がある"
        doAssert f.constantTerm.val == 1,
            "疎なFPSの形式的対数では定数項が1である必要がある"
        result = newSeq[T](n)
        for degree in 1..<n:
            result[degree] = init(T, degree) * f.coefficient(degree)
            for term in f:
                if term.degree == 0: continue
                if term.degree >= degree: break
                result[degree] -= term.coefficient * init(T, degree - term.degree) *
                    result[degree - term.degree]
            result[degree] /= degree

    proc powUnit[T: BarrettModint or MontgomeryModint](f: SparseFPS[T],
            exponent, constantRoot: T, n: int): seq[T] =
        ## 非零な定数項を持つFPSについて f^exponent を漸化式で求める。
        if n <= 0: return @[]
        let constant = f.constantTerm
        doAssert constant.val != 0, "単元の冪では定数項が非零である必要がある"
        doAssert n <= T.umod.int, "単元の冪では n が法以下である必要がある"
        result = newSeq[T](n)
        result[0] = constantRoot
        for degree in 1..<n:
            for term in f:
                if term.degree == 0: continue
                if term.degree > degree: break
                let weight = (exponent + 1) * term.degree - degree
                result[degree] += weight * term.coefficient *
                    result[degree - term.degree]
            result[degree] /= init(T, degree) * constant

    proc pow*[T](f: SparseFPS[T], k, n: int): seq[T] =
        ## 疎なFPSの非負整数冪を x^n で打ち切って返す。
        doAssert k >= 0, "疎なFPSの整数冪では指数が非負である必要がある"
        if n <= 0: return @[]
        doAssert n <= T.umod.int, "疎なFPSの整数冪では n が法以下である必要がある"
        if k == 0:
            result = newSeq[T](n)
            result[0] = 1
            return
        if f.isZero or f[0].degree > (n - 1) div k: return newSeq[T](n)
        let order = f[0].degree
        let shift = order * k
        let leading = f[0].coefficient
        var unitTerms: seq[SparseTerm[T]]
        for term in f:
            if term.degree - order >= n - shift: break
            unitTerms.add((term.degree - order, term.coefficient / leading))
        let unit = initSparseFPS[T](unitTerms)
        let exponent = init(T, k mod T.umod.int)
        let body = powUnit[T](unit, exponent, init(T, 1), n - shift)
        result = newSeq[T](n)
        let scale = leading.pow(k)
        for i in 0..<body.len: result[shift + i] = body[i] * scale

    proc sqrt*[T](f: SparseFPS[T], n: int): Option[seq[T]] =
        ## 疎なFPSの形式的平方根を x^n で打ち切って返す。
        if n <= 0: return some(newSeq[T]())
        doAssert n <= T.umod.int, "疎なFPSの形式的平方根では n が法以下である必要がある"
        if f.isZero or f[0].degree >= n: return some(newSeq[T](n))
        let order = f[0].degree
        if (order and 1) != 0: return none(seq[T])
        let shift = order div 2
        let leading = f[0].coefficient
        let leadingRoot = (@[leading]).sqrt(1)
        if leadingRoot.isNone: return none(seq[T])
        var unitTerms: seq[SparseTerm[T]]
        for term in f:
            if term.degree - order >= n - shift: break
            unitTerms.add((term.degree - order, term.coefficient / leading))
        let unit = initSparseFPS[T](unitTerms)
        let half = init(T, 1) / 2
        let body = powUnit[T](unit, half, init(T, 1), n - shift)
        var answer = newSeq[T](n)
        for i in 0..<body.len: answer[shift + i] = body[i] * leadingRoot.get[0]
        some(answer)

    proc multiplyPolynomials[T: BarrettModint or MontgomeryModint](a, b: seq[T]): seq[T] =
        if a.len == 0 or b.len == 0: return @[]
        convolution(a, b)

    proc addPolynomial[T: BarrettModint or MontgomeryModint](a: var seq[T], b: seq[T]) =
        if a.len < b.len: a.setLen(b.len)
        for i in 0..<b.len: a[i] += b[i]

    proc multiplyPolynomialMatrices[T: BarrettModint or MontgomeryModint](
            a, b: seq[seq[T]], dimension: int): seq[seq[T]] =
        ## 多項式行列の積 a * b を計算する。
        result = newSeq[seq[T]](dimension * dimension)
        for row in 0..<dimension:
            for middle in 0..<dimension:
                let left = a[row * dimension + middle]
                if left.len == 0: continue
                for column in 0..<dimension:
                    let right = b[middle * dimension + column]
                    if right.len == 0: continue
                    addPolynomial[T](result[row * dimension + column],
                        multiplyPolynomials[T](left, right))

    proc shiftedLinearPolynomial[T: BarrettModint or MontgomeryModint](
            polynomial: LinearPolynomial[T], shift: int): seq[T] =
        let constant = polynomial.constant + polynomial.linear * shift
        if polynomial.linear.val != 0: @[constant, polynomial.linear]
        elif constant.val != 0: @[constant]
        else: @[]

    proc blockMatrixProduct[T: BarrettModint or MontgomeryModint](
            transition: seq[LinearPolynomial[T]], dimension, left, right: int): seq[seq[T]] =
        ## A(x+right-1) ... A(x+left) を多項式行列として構築する。
        if right - left == 1:
            result = newSeq[seq[T]](dimension * dimension)
            for i in 0..<result.len:
                result[i] = shiftedLinearPolynomial[T](transition[i], left)
            return
        let middle = (left + right) shr 1
        let lower = blockMatrixProduct[T](transition, dimension, left, middle)
        let upper = blockMatrixProduct[T](transition, dimension, middle, right)
        multiplyPolynomialMatrices[T](upper, lower, dimension)

    proc blockScalarProduct[T: BarrettModint or MontgomeryModint](
            polynomial: LinearPolynomial[T], left, right: int): seq[T] =
        ## i=left..<right にわたる polynomial(x+i) の積を構築する。
        if right - left == 1: return shiftedLinearPolynomial[T](polynomial, left)
        let middle = (left + right) shr 1
        multiplyPolynomials[T](
            blockScalarProduct[T](polynomial, left, middle),
            blockScalarProduct[T](polynomial, middle, right))

    proc evaluateLinearPolynomial[T: BarrettModint or MontgomeryModint](
            polynomial: LinearPolynomial[T], x: int): T =
        polynomial.constant + polynomial.linear * x

    proc nthTermPolynomialRecurrence[T: BarrettModint or MontgomeryModint](
            initial: seq[T], transition: seq[LinearPolynomial[T]],
            denominator: LinearPolynomial[T], target: int): T =
        ## 一次式を成分に持つ有理行列漸化式の第target項を平方分割で求める。
        let dimension = initial.len
        doAssert dimension > 0 and transition.len == dimension * dimension
        if target < dimension: return initial[target]
        let transitionCount = target - dimension + 1
        var blockSize = isqrt(transitionCount)
        if blockSize * blockSize < transitionCount: inc blockSize
        let blockCount = transitionCount div blockSize
        var state = initial

        if blockCount > 0:
            let blockMatrix = blockMatrixProduct[T](transition, dimension, 0, blockSize)
            let blockDenominator = blockScalarProduct[T](denominator, 0, blockSize)
            var points = newSeq[T](blockCount)
            for i in 0..<blockCount: points[i] = init(T, i * blockSize)
            let tree = initPolynomialProductTree[T](points)
            var matrixValues = newSeq[seq[T]](dimension * dimension)
            for i in 0..<blockMatrix.len:
                if blockMatrix[i].len > 0:
                    matrixValues[i] = evaluate[T](tree, blockMatrix[i])
                else:
                    matrixValues[i] = newSeq[T](blockCount)
            let denominatorValues = evaluate[T](tree, blockDenominator)
            for blockIndex in 0..<blockCount:
                doAssert denominatorValues[blockIndex].val != 0,
                    "多項式係数漸化式の分母が計算区間内で零になった"
                var next = newSeq[T](dimension)
                for row in 0..<dimension:
                    for column in 0..<dimension:
                        next[row] += matrixValues[row * dimension + column][blockIndex] *
                            state[column]
                    next[row] /= denominatorValues[blockIndex]
                state = move(next)

        for step in blockCount * blockSize..<transitionCount:
            let denominatorValue = evaluateLinearPolynomial[T](denominator, step)
            doAssert denominatorValue.val != 0,
                "多項式係数漸化式の分母が計算区間内で零になった"
            var next = newSeq[T](dimension)
            for row in 0..<dimension:
                for column in 0..<dimension:
                    let entry = transition[row * dimension + column]
                    next[row] += evaluateLinearPolynomial[T](entry, step) * state[column]
                next[row] /= denominatorValue
            state = move(next)
        state[^1]

    proc expTransition[T: BarrettModint or MontgomeryModint](f: SparseFPS[T],
            dimension: int): tuple[matrix: seq[LinearPolynomial[T]],
            denominator: LinearPolynomial[T]] =
        result.matrix = newSeq[LinearPolynomial[T]](dimension * dimension)
        result.denominator = (init(T, dimension), init(T, 1))
        for row in 0..<dimension - 1:
            result.matrix[row * dimension + row + 1] = result.denominator
        for term in f:
            if term.degree == 0 or term.degree > dimension: continue
            let column = dimension - term.degree
            result.matrix[(dimension - 1) * dimension + column].constant =
                init(T, term.degree) * term.coefficient

    proc powTransition[T: BarrettModint or MontgomeryModint](f: SparseFPS[T],
            exponent: T, dimension: int): tuple[matrix: seq[LinearPolynomial[T]],
            denominator: LinearPolynomial[T]] =
        let constant = f.constantTerm
        result.matrix = newSeq[LinearPolynomial[T]](dimension * dimension)
        result.denominator = (init(T, dimension) * constant, constant)
        for row in 0..<dimension - 1:
            result.matrix[row * dimension + row + 1] = result.denominator
        for term in f:
            if term.degree == 0 or term.degree > dimension: continue
            let column = dimension - term.degree
            result.matrix[(dimension - 1) * dimension + column] = (
                ((exponent + 1) * term.degree - dimension) * term.coefficient,
                -term.coefficient)

    proc invCoefficient*[T](f: SparseFPS[T], degree: int): T =
        ## 乗法逆元の x^degree の係数だけを Bostan--Mori法で求める。
        ## fの次数をdとして計算量は O(M(d) log degree)。
        doAssert degree >= 0, "取得する係数の次数は非負である必要がある"
        doAssert f.constantTerm.val != 0,
            "疎なFPSの乗法逆元では定数項が非零である必要がある"
        let relevant = f.truncated(degree + 1)
        let denominator = relevant.toDense(relevant.degree + 1)
        bostanMori(@[init(T, 1)], denominator, degree)

    proc logCoefficient*[T](f: SparseFPS[T], degree: int): T =
        ## 形式的対数の x^degree の係数だけを Bostan--Mori法で求める。
        ## fの次数をdとして計算量は O(M(d) log degree)。
        doAssert degree >= 0, "取得する係数の次数は非負である必要がある"
        doAssert f.constantTerm.val == 1,
            "疎なFPSの形式的対数では定数項が1である必要がある"
        if degree == 0: return init(T, 0)
        doAssert degree < T.umod.int,
            "形式的対数の単項取得では次数が法未満である必要がある"
        let relevant = f.truncated(degree + 1)
        let denominator = relevant.toDense(relevant.degree + 1)
        var numerator = newSeq[T](max(denominator.len - 1, 0))
        for term in relevant:
            if term.degree > 0:
                numerator[term.degree - 1] = init(T, term.degree) * term.coefficient
        bostanMori(numerator, denominator, degree - 1) / degree

    proc expCoefficient*[T](f: SparseFPS[T], degree: int): T =
        ## 形式的指数関数の x^degree の係数だけを平方分割で求める。
        ## fの次数をdとして計算量は O(d^3 M(sqrt(degree)) log degree)。
        doAssert degree >= 0, "取得する係数の次数は非負である必要がある"
        doAssert degree < T.umod.int,
            "形式的指数関数の単項取得では次数が法未満である必要がある"
        doAssert f.constantTerm.val == 0,
            "疎なFPSの形式的指数関数では定数項が0である必要がある"
        if degree == 0: return init(T, 1)
        let relevant = f.truncated(degree + 1)
        let dimension = relevant.degree
        if dimension <= 0: return init(T, 0)
        let initial = relevant.exp(min(dimension, degree + 1))
        if degree < dimension: return initial[degree]
        let recurrence = expTransition[T](relevant, dimension)
        nthTermPolynomialRecurrence[T](initial, recurrence.matrix,
            recurrence.denominator, degree)

    proc powCoefficient*[T](f: SparseFPS[T], k, degree: int): T =
        ## 非負整数冪の x^degree の係数だけを平方分割で求める。
        ## fの次数をdとして計算量は O(d^3 M(sqrt(degree)) log degree)。
        doAssert k >= 0, "疎なFPSの整数冪では指数が非負である必要がある"
        doAssert degree >= 0, "取得する係数の次数は非負である必要がある"
        if k == 0: return init(T, ord(degree == 0))
        if f.isZero or f[0].degree > degree div k: return init(T, 0)
        let order = f[0].degree
        let shiftedDegree = degree - order * k
        let leading = f[0].coefficient
        let scale = leading.pow(k)
        if shiftedDegree == 0: return scale
        doAssert shiftedDegree < T.umod.int,
            "整数冪の単項取得ではシフト後の次数が法未満である必要がある"
        var unitTerms: seq[SparseTerm[T]]
        for term in f:
            let termDegree = term.degree - order
            if termDegree > shiftedDegree: break
            unitTerms.add((termDegree, term.coefficient / leading))
        let unit = initSparseFPS[T](unitTerms)
        let dimension = unit.degree
        if dimension <= 0: return init(T, 0)
        let exponent = init(T, k mod T.umod.int)
        let initial = powUnit[T](unit, exponent, init(T, 1),
            min(dimension, shiftedDegree + 1))
        if shiftedDegree < dimension: return initial[shiftedDegree] * scale
        let recurrence = powTransition[T](unit, exponent, dimension)
        nthTermPolynomialRecurrence[T](initial, recurrence.matrix,
            recurrence.denominator, shiftedDegree) * scale
