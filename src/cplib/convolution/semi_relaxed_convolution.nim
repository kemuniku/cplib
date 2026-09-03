when not declared CPLIB_CONVOLUTION_SEMI_RELAXED_CONVOLUTION:
    const CPLIB_CONVOLUTION_SEMI_RELAXED_CONVOLUTION* = 1

    import cplib/convolution/convolution
    import cplib/modint/modint

    type SemiRelaxedConvolution*[T] = object
        fixed: seq[T]
        online, product: seq[T]

    proc initSemiRelaxedConvolution*[T: BarrettModint or MontgomeryModint](
            fixed: seq[T]): SemiRelaxedConvolution[T] =
        ## 左側をfixedに固定した逐次畳み込みを初期化する。
        ## NTTが利用できる場合、N項追加する計算量はO(N log^2 N)となる。
        result.fixed = fixed

    proc len*[T](self: SemiRelaxedConvolution[T]): int = self.online.len

    proc coefficients*[T](self: SemiRelaxedConvolution[T]): seq[T] =
        ## 現在までに確定した積の係数を返す。
        result = newSeq[T](self.online.len)
        for i in 0..<min(result.len, self.product.len):
            result[i] = self.product[i]

    proc add*[T](
            self: var SemiRelaxedConvolution[T], value: T): T =
        ## オンライン側へ次の係数を追加し、その次数の積の係数を返す。
        self.online.add(value)
        let count = self.online.len
        var blockSize = 1
        while true:
            let fixedLeft = blockSize - 1
            let fixedRight = min(fixedLeft + blockSize, self.fixed.len)
            if fixedLeft < fixedRight:
                let onlineLeft = count - blockSize
                let first = fixedLeft + onlineLeft
                if blockSize <= 16:
                    let requiredLength = fixedRight + count - 1
                    if self.product.len < requiredLength:
                        self.product.setLen(requiredLength)
                    for i in fixedLeft..<fixedRight:
                        for j in onlineLeft..<count:
                            self.product[i + j] += self.fixed[i] * self.online[j]
                else:
                    let values = convolution(self.fixed[fixedLeft..<fixedRight],
                        self.online[onlineLeft..<count])
                    if self.product.len < first + values.len:
                        self.product.setLen(first + values.len)
                    for i in 0..<values.len:
                        self.product[first + i] += values[i]
            if blockSize == (count and -count): break
            blockSize *= 2
        if count - 1 < self.product.len:
            return self.product[count - 1]

    proc append*[T](
            self: var SemiRelaxedConvolution[T], value: T): T =
        self.add(value)

    proc get*[T](
            self: var SemiRelaxedConvolution[T], value: T): T =
        self.add(value)
