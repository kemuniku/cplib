when not declared CPLIB_CONVOLUTION_RELAXED_CONVOLUTION:
    const CPLIB_CONVOLUTION_RELAXED_CONVOLUTION* = 1

    import options
    import cplib/convolution/convolution
    import cplib/convolution/ntt
    import cplib/modint/modint

    type RelaxedConvolution*[T] = object
        coefficientCount: int
        currentIndex: int
        left, right, product: seq[T]
        leftPrefixTransforms, rightPrefixTransforms: seq[seq[T]]

    proc initRelaxedConvolution*[T: BarrettModint or MontgomeryModint](
            coefficientCount: int): RelaxedConvolution[T] =
        ## 先頭からcoefficientCount項を逐次計算する畳み込みを初期化する。
        ## NTTが利用できる場合、全項の計算量はO(N log^2 N)となる。
        doAssert coefficientCount >= 0
        result.coefficientCount = coefficientCount
        result.left = newSeq[T](coefficientCount)
        result.right = newSeq[T](coefficientCount)
        result.product = newSeq[T](coefficientCount)

    proc len*[T](self: RelaxedConvolution[T]): int = self.currentIndex

    proc pendingCoefficient*[T](self: RelaxedConvolution[T]): T =
        ## 次に確定する係数に既に加算済みの寄与を返す。
        doAssert self.currentIndex < self.coefficientCount
        self.product[self.currentIndex]

    proc coefficients*[T](self: RelaxedConvolution[T]): seq[T] =
        ## 現在までに確定した積の係数を返す。
        self.product[0..<self.currentIndex]

    proc addProduct[T](self: var RelaxedConvolution[T], first: int,
            values: seq[T], offset, count: int) =
        if offset >= values.len: return
        for i in 0..<min(count, values.len - offset):
            self.product[first + i] += values[offset + i]

    proc ensurePrefixTransforms[T](
            self: var RelaxedConvolution[T], level, blockSize: int) =
        if self.leftPrefixTransforms.len <= level:
            self.leftPrefixTransforms.setLen(level + 1)
            self.rightPrefixTransforms.setLen(level + 1)
        if self.leftPrefixTransforms[level].len > 0: return
        let transformSize = blockSize * 2
        self.leftPrefixTransforms[level] = newSeq[T](transformSize)
        self.rightPrefixTransforms[level] = newSeq[T](transformSize)
        for i in 0..<transformSize:
            self.leftPrefixTransforms[level][i] = self.left[i]
            self.rightPrefixTransforms[level][i] = self.right[i]
        self.leftPrefixTransforms[level].ntt
        self.rightPrefixTransforms[level].ntt

    proc add*[T](
            self: var RelaxedConvolution[T], leftValue, rightValue: T): T =
        ## 次の2係数を追加し、その次数の積の係数を返す。
        doAssert self.currentIndex < self.coefficientCount
        let index = self.currentIndex
        self.left[index] = leftValue
        self.right[index] = rightValue
        self.product[index] += leftValue * self.right[0]
        if index > 0: self.product[index] += rightValue * self.left[0]

        inc self.currentIndex
        if self.currentIndex >= self.coefficientCount:
            return self.product[index]

        var blockSize = 1
        var level = 0
        while blockSize <= self.currentIndex:
            if self.currentIndex mod (blockSize * 2) == blockSize:
                let updateCount = min(blockSize,
                    self.coefficientCount - self.currentIndex)
                let transformSize = blockSize * 2
                let nttAvailable = transformSize >= 64 and
                    (T.umod - 1u32) mod transformSize.uint32 == 0u32
                if blockSize <= 16:
                    for offset in 0..<updateCount:
                        let localDegree = blockSize + offset
                        if self.currentIndex == blockSize:
                            for i in 0..<blockSize:
                                let j = localDegree - i
                                if j >= 0 and j < blockSize:
                                    self.product[self.currentIndex + offset] +=
                                        self.left[i] * self.right[j]
                        else:
                            for i in 0..<blockSize:
                                let j = localDegree - i
                                self.product[self.currentIndex + offset] +=
                                    self.left[self.currentIndex - blockSize + i] *
                                        self.right[j] +
                                    self.right[self.currentIndex - blockSize + i] *
                                        self.left[j]
                elif nttAvailable:
                    var transformedLeft = newSeq[T](transformSize)
                    var transformedRight = newSeq[T](transformSize)
                    if self.currentIndex == blockSize:
                        for i in 0..<blockSize:
                            transformedLeft[i] = self.left[i]
                            transformedRight[i] = self.right[i]
                        transformedLeft.ntt
                        transformedRight.ntt
                        for i in 0..<transformSize:
                            transformedLeft[i] *= transformedRight[i]
                    else:
                        ensurePrefixTransforms[T](self, level, blockSize)
                        for i in 0..<blockSize:
                            transformedLeft[i] = self.left[
                                self.currentIndex - blockSize + i]
                            transformedRight[i] = self.right[
                                self.currentIndex - blockSize + i]
                        transformedLeft.ntt
                        transformedRight.ntt
                        for i in 0..<transformSize:
                            transformedLeft[i] = transformedLeft[i] *
                                self.rightPrefixTransforms[level][i] +
                                transformedRight[i] *
                                self.leftPrefixTransforms[level][i]
                    transformedLeft.intt
                    addProduct[T](self, self.currentIndex, transformedLeft,
                        blockSize, updateCount)
                elif self.currentIndex == blockSize:
                    let values = convolution(self.left[0..<blockSize],
                        self.right[0..<blockSize])
                    addProduct[T](self, self.currentIndex, values,
                        blockSize, updateCount)
                else:
                    let leftBlock = self.left[
                        self.currentIndex - blockSize..<self.currentIndex]
                    let rightBlock = self.right[
                        self.currentIndex - blockSize..<self.currentIndex]
                    let leftValues = convolutionCyclicPowerOfTwo(leftBlock,
                        self.right[0..<transformSize], transformSize)
                    let rightValues = convolutionCyclicPowerOfTwo(rightBlock,
                        self.left[0..<transformSize], transformSize)
                    for i in 0..<updateCount:
                        self.product[self.currentIndex + i] +=
                            leftValues[blockSize + i] +
                            rightValues[blockSize + i]
                break
            blockSize *= 2
            inc level
        self.product[index]

    proc append*[T](
            self: var RelaxedConvolution[T], leftValue, rightValue: T): T =
        self.add(leftValue, rightValue)

    proc get*[T](
            self: var RelaxedConvolution[T], leftValue, rightValue: T): T =
        self.add(leftValue, rightValue)

    proc relaxedModSqrt[T: BarrettModint or MontgomeryModint](a: T): Option[T] =
        ## Tonelli--Shanks法。法が素数であることを仮定する。
        let p = T.umod.int
        if a.val == 0: return some(init(T, 0))
        if p == 2: return some(a)
        if a.pow((p - 1) div 2).val != 1: return none(T)
        if p mod 4 == 3: return some(a.pow((p + 1) div 4))
        var q = p - 1
        var s = 0
        while (q and 1) == 0:
            q = q shr 1
            inc s
        var z = init(T, 2)
        while z.pow((p - 1) div 2).val != p - 1: z += 1
        var c = z.pow(q)
        var x = a.pow((q + 1) div 2)
        var t = a.pow(q)
        var m = s
        while t.val != 1:
            var i = 1
            var squared = t * t
            while i < m and squared.val != 1:
                squared *= squared
                inc i
            if i == m: return none(T)
            let b = c.pow(1 shl (m - i - 1))
            x *= b
            c = b * b
            t *= c
            m = i
        some(x)

    type
        RelaxedInv*[T] = object
            coefficientCount, currentIndex: int
            convolution: RelaxedConvolution[T]
            values: seq[T]
            constantInverse: T

        RelaxedExp*[T] = object
            coefficientCount, currentIndex: int
            convolution: RelaxedConvolution[T]
            values: seq[T]

        RelaxedLog*[T] = object
            coefficientCount, currentIndex: int
            inverse: RelaxedInv[T]
            convolution: RelaxedConvolution[T]
            values: seq[T]

        RelaxedSqrt*[T] = object
            coefficientCount, currentIndex: int
            convolution: RelaxedConvolution[T]
            values: seq[T]
            inverseDoubleConstant: T
            failed: bool

        RelaxedPow*[T] = object
            coefficientCount, currentIndex, exponent: int
            order, shift, bodyCount: int
            constantInverse, constantPower: T
            logarithm: RelaxedLog[T]
            exponential: RelaxedExp[T]
            body, values: seq[T]

    proc initRelaxedInv*[T: BarrettModint or MontgomeryModint](
            coefficientCount: int): RelaxedInv[T] =
        ## 乗法逆元の係数を逐次計算する状態を初期化する。
        doAssert coefficientCount >= 0
        result.coefficientCount = coefficientCount
        result.convolution = initRelaxedConvolution[T](coefficientCount)
        result.values = newSeqOfCap[T](coefficientCount)

    proc len*[T](self: RelaxedInv[T]): int = self.currentIndex

    proc coefficients*[T](self: RelaxedInv[T]): seq[T] =
        self.values[0..<self.values.len]

    proc add*[T](
            self: var RelaxedInv[T], coefficient: T): T =
        ## fの次の係数を追加し、f^(-1)の同じ次数の係数を返す。
        doAssert self.currentIndex < self.coefficientCount
        let degree = self.currentIndex
        if degree == 0:
            doAssert coefficient.val != 0,
                "FPSの乗法逆元を求めるには定数項が非零である必要がある"
            self.constantInverse = coefficient.inv
            result = self.constantInverse
        else:
            let known = self.convolution.pendingCoefficient +
                coefficient * self.values[0]
            result = -known * self.constantInverse
        discard self.convolution.add(coefficient, result)
        self.values.add(result)
        inc self.currentIndex

    proc append*[T](
            self: var RelaxedInv[T], coefficient: T): T =
        self.add(coefficient)

    proc get*[T](
            self: var RelaxedInv[T], coefficient: T): T =
        self.add(coefficient)

    proc initRelaxedExp*[T: BarrettModint or MontgomeryModint](
            coefficientCount: int): RelaxedExp[T] =
        ## 形式的指数関数の係数を逐次計算する状態を初期化する。
        doAssert coefficientCount >= 0
        doAssert coefficientCount <= T.umod.int,
            "FPSの形式的指数関数では項数が法以下である必要がある"
        result.coefficientCount = coefficientCount
        result.convolution = initRelaxedConvolution[T](
            max(coefficientCount - 1, 0))
        result.values = newSeqOfCap[T](coefficientCount)

    proc len*[T](self: RelaxedExp[T]): int = self.currentIndex

    proc coefficients*[T](self: RelaxedExp[T]): seq[T] =
        self.values[0..<self.values.len]

    proc add*[T](
            self: var RelaxedExp[T], coefficient: T): T =
        ## fの次の係数を追加し、exp(f)の同じ次数の係数を返す。
        doAssert self.currentIndex < self.coefficientCount
        let degree = self.currentIndex
        if degree == 0:
            doAssert coefficient.val == 0,
                "FPSの形式的指数関数を求めるには定数項が0である必要がある"
            result = init(T, 1)
        else:
            result = self.convolution.add(self.values[degree - 1],
                coefficient * degree) / degree
        self.values.add(result)
        inc self.currentIndex

    proc append*[T](
            self: var RelaxedExp[T], coefficient: T): T =
        self.add(coefficient)

    proc get*[T](
            self: var RelaxedExp[T], coefficient: T): T =
        self.add(coefficient)

    proc initRelaxedLog*[T: BarrettModint or MontgomeryModint](
            coefficientCount: int): RelaxedLog[T] =
        ## 形式的対数の係数を逐次計算する状態を初期化する。
        doAssert coefficientCount >= 0
        doAssert coefficientCount <= T.umod.int,
            "FPSの形式的対数では項数が法以下である必要がある"
        result.coefficientCount = coefficientCount
        result.inverse = initRelaxedInv[T](coefficientCount)
        result.convolution = initRelaxedConvolution[T](
            max(coefficientCount - 1, 0))
        result.values = newSeqOfCap[T](coefficientCount)

    proc len*[T](self: RelaxedLog[T]): int = self.currentIndex

    proc coefficients*[T](self: RelaxedLog[T]): seq[T] =
        self.values[0..<self.values.len]

    proc add*[T](
            self: var RelaxedLog[T], coefficient: T): T =
        ## fの次の係数を追加し、log(f)の同じ次数の係数を返す。
        doAssert self.currentIndex < self.coefficientCount
        let degree = self.currentIndex
        if degree == 0:
            doAssert coefficient.val == 1,
                "FPSの形式的対数を求めるには定数項が1である必要がある"
            discard self.inverse.add(coefficient)
            result = init(T, 0)
        else:
            discard self.inverse.add(coefficient)
            result = self.convolution.add(coefficient * degree,
                self.inverse.values[degree - 1]) / degree
        self.values.add(result)
        inc self.currentIndex

    proc append*[T](
            self: var RelaxedLog[T], coefficient: T): T =
        self.add(coefficient)

    proc get*[T](
            self: var RelaxedLog[T], coefficient: T): T =
        self.add(coefficient)

    proc initRelaxedSqrt*[T: BarrettModint or MontgomeryModint](
            coefficientCount: int): RelaxedSqrt[T] =
        ## 非零の定数項を持つFPSの平方根を逐次計算する状態を初期化する。
        doAssert coefficientCount >= 0
        result.coefficientCount = coefficientCount
        result.convolution = initRelaxedConvolution[T](coefficientCount)
        result.values = newSeqOfCap[T](coefficientCount)

    proc len*[T](self: RelaxedSqrt[T]): int = self.currentIndex

    proc coefficients*[T](self: RelaxedSqrt[T]): Option[seq[T]] =
        if self.failed: none(seq[T])
        else: some(self.values[0..<self.values.len])

    proc add*[T](
            self: var RelaxedSqrt[T], coefficient: T): Option[T] =
        ## fの次の係数を追加し、sqrt(f)の同じ次数の係数を返す。
        ## 定数項が0の場合は出力係数が逐次に定まらないため扱わない。
        doAssert self.currentIndex < self.coefficientCount
        let degree = self.currentIndex
        if self.failed:
            inc self.currentIndex
            return none(T)
        var value: T
        if degree == 0:
            doAssert coefficient.val != 0,
                "FPSの平方根を逐次計算するには定数項が非零である必要がある"
            let constantRoot = relaxedModSqrt(coefficient)
            if constantRoot.isNone:
                self.failed = true
                inc self.currentIndex
                return none(T)
            value = constantRoot.get
            self.inverseDoubleConstant = (value * 2).inv
        else:
            value = (coefficient - self.convolution.pendingCoefficient) *
                self.inverseDoubleConstant
        discard self.convolution.add(value, value)
        self.values.add(value)
        inc self.currentIndex
        some(value)

    proc append*[T](
            self: var RelaxedSqrt[T], coefficient: T): Option[T] =
        self.add(coefficient)

    proc get*[T](
            self: var RelaxedSqrt[T], coefficient: T): Option[T] =
        self.add(coefficient)

    proc initRelaxedPow*[T: BarrettModint or MontgomeryModint](
            coefficientCount, exponent: int): RelaxedPow[T] =
        ## 非負整数冪の係数を逐次計算する状態を初期化する。
        doAssert coefficientCount >= 0
        doAssert coefficientCount <= T.umod.int,
            "FPSの整数冪では項数が法以下である必要がある"
        doAssert exponent >= 0, "FPSの整数冪では指数が非負である必要がある"
        result.coefficientCount = coefficientCount
        result.exponent = exponent
        result.order = -1
        result.shift = coefficientCount
        result.values = newSeqOfCap[T](coefficientCount)

    proc len*[T](self: RelaxedPow[T]): int = self.currentIndex

    proc coefficients*[T](self: RelaxedPow[T]): seq[T] =
        self.values[0..<self.values.len]

    proc add*[T](
            self: var RelaxedPow[T], coefficient: T): T =
        ## fの次の係数を追加し、f^kの同じ次数の係数を返す。
        doAssert self.currentIndex < self.coefficientCount
        let degree = self.currentIndex
        if self.exponent == 0:
            result = if degree == 0: init(T, 1) else: init(T, 0)
        else:
            if self.order < 0 and coefficient.val != 0:
                self.order = degree
                if degree <= (self.coefficientCount - 1) div self.exponent:
                    self.shift = degree * self.exponent
                    self.bodyCount = self.coefficientCount - self.shift
                    self.constantInverse = coefficient.inv
                    self.constantPower = coefficient.pow(self.exponent)
                    self.logarithm = initRelaxedLog[T](self.bodyCount)
                    self.exponential = initRelaxedExp[T](self.bodyCount)
                    let logarithmCoefficient = self.logarithm.add(init(T, 1))
                    let exponentialCoefficient = self.exponential.add(
                        logarithmCoefficient * init(T, self.exponent))
                    self.body.add(exponentialCoefficient * self.constantPower)
            elif self.order >= 0 and self.body.len < self.bodyCount:
                let logarithmCoefficient = self.logarithm.add(
                    coefficient * self.constantInverse)
                let exponentialCoefficient = self.exponential.add(
                    logarithmCoefficient * init(T, self.exponent))
                self.body.add(exponentialCoefficient * self.constantPower)
            if degree >= self.shift:
                result = self.body[degree - self.shift]
        self.values.add(result)
        inc self.currentIndex

    proc append*[T](
            self: var RelaxedPow[T], coefficient: T): T =
        self.add(coefficient)

    proc get*[T](
            self: var RelaxedPow[T], coefficient: T): T =
        self.add(coefficient)

    proc invRelaxed*[T: BarrettModint or MontgomeryModint](
            f: seq[T], n: int): seq[T] =
        ## Relaxed convolutionにより逆元を低次から逐次計算する。
        if n <= 0: return @[]
        var state = initRelaxedInv[T](n)
        result = newSeq[T](n)
        for i in 0..<n:
            let coefficient = if i < f.len: f[i] else: init(T, 0)
            result[i] = state.add(coefficient)

    proc invRelaxed*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] =
        f.invRelaxed(f.len)

    proc expRelaxed*[T: BarrettModint or MontgomeryModint](
            f: seq[T], n: int): seq[T] =
        ## Relaxed convolutionにより形式的指数関数を低次から逐次計算する。
        if n <= 0: return @[]
        var state = initRelaxedExp[T](n)
        result = newSeq[T](n)
        for i in 0..<n:
            let coefficient = if i < f.len: f[i] else: init(T, 0)
            result[i] = state.add(coefficient)

    proc expRelaxed*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] =
        f.expRelaxed(f.len)

    proc logRelaxed*[T: BarrettModint or MontgomeryModint](
            f: seq[T], n: int): seq[T] =
        ## Relaxed convolutionにより形式的対数を低次から逐次計算する。
        if n <= 0: return @[]
        var state = initRelaxedLog[T](n)
        result = newSeq[T](n)
        for i in 0..<n:
            let coefficient = if i < f.len: f[i] else: init(T, 0)
            result[i] = state.add(coefficient)

    proc logRelaxed*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] =
        f.logRelaxed(f.len)

    proc sqrtRelaxed*[T: BarrettModint or MontgomeryModint](
            f: seq[T], n: int): Option[seq[T]] =
        ## Relaxed convolutionにより平方根を低次から逐次計算する。
        if n <= 0: return some(newSeq[T]())
        var order = 0
        while order < min(f.len, n) and f[order].val == 0: inc order
        if order == min(f.len, n): return some(newSeq[T](n))
        if (order and 1) != 0: return none(seq[T])
        let shift = order div 2
        let size = n - shift
        var state = initRelaxedSqrt[T](size)
        var answer = newSeq[T](n)
        for i in 0..<size:
            let coefficient = if order + i < f.len:
                f[order + i]
            else:
                init(T, 0)
            let rootCoefficient = state.add(coefficient)
            if rootCoefficient.isNone: return none(seq[T])
            answer[shift + i] = rootCoefficient.get
        some(answer)

    proc sqrtRelaxed*[T: BarrettModint or MontgomeryModint](
            f: seq[T]): Option[seq[T]] =
        f.sqrtRelaxed(f.len)

    proc powRelaxed*[T: BarrettModint or MontgomeryModint](
            f: seq[T], k, n: int): seq[T] =
        ## Relaxed convolutionにより非負整数冪を低次から逐次計算する。
        doAssert k >= 0, "FPSの整数冪では指数が非負である必要がある"
        if n <= 0: return @[]
        var state = initRelaxedPow[T](n, k)
        result = newSeq[T](n)
        for i in 0..<n:
            let coefficient = if i < f.len: f[i] else: init(T, 0)
            result[i] = state.add(coefficient)

    proc powRelaxed*[T: BarrettModint or MontgomeryModint](
            f: seq[T], k: int): seq[T] =
        f.powRelaxed(k, f.len)
