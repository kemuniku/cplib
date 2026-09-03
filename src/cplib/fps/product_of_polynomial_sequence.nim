when not declared CPLIB_FPS_PRODUCT_OF_POLYNOMIAL_SEQUENCE:
    const CPLIB_FPS_PRODUCT_OF_POLYNOMIAL_SEQUENCE* = 1

    import cplib/convolution/convolution
    import cplib/modint/modint

    proc productPolynomialSequence998Avx2(
        output: ptr uint32,
        factors: ptr ptr uint32,
        sizes: ptr csize_t,
        factorCount: csize_t
    ) {.importc: "cplib_product_polynomial_sequence_998".}

    proc productOfPolynomialSequence*[T: BarrettModint or MontgomeryModint](
            polynomials: seq[seq[T]]): seq[T] =
        ## 多項式列の積を、部分積の次数が均衡するように計算する。
        if polynomials.len == 0: return @[init(T, 1)]

        when T is BarrettModint:
            if T.umod == 998244353u32:
                doAssert sizeof(T) == sizeof(uint32)
                var totalLength = 1
                var scalar = init(T, 1)
                var factorPointers = newSeqOfCap[ptr uint32](polynomials.len)
                var factorSizes = newSeqOfCap[csize_t](polynomials.len)
                for polynomial in polynomials:
                    if polynomial.len == 0: return @[]
                    totalLength += polynomial.len - 1
                    if polynomial.len == 1:
                        scalar *= polynomial[0]
                    else:
                        factorPointers.add(cast[ptr uint32](
                            unsafeAddr polynomial[0]))
                        factorSizes.add(polynomial.len.csize_t)

                if scalar.val == 0: return newSeq[T](totalLength)
                if factorPointers.len == 0: return @[scalar]
                result = newSeq[T](totalLength)
                productPolynomialSequence998Avx2(
                    cast[ptr uint32](addr result[0]),
                    cast[ptr ptr uint32](addr factorPointers[0]),
                    addr factorSizes[0], factorPointers.len.csize_t)
                if scalar.val != 1:
                    for coefficient in result.mitems: coefficient *= scalar
                return

        var totalLength = 1
        var scalar = init(T, 1)
        var factors = newSeqOfCap[seq[T]](polynomials.len)
        for polynomial in polynomials:
            if polynomial.len == 0: return @[]
            totalLength += polynomial.len - 1
            if polynomial.len == 1:
                scalar *= polynomial[0]
            else:
                factors.add(polynomial)

        if scalar.val == 0: return newSeq[T](totalLength)
        if factors.len == 0: return @[scalar]

        if factors.len == 1:
            result = newSeq[T](factors[0].len)
            for i in 0..<result.len: result[i] = factors[0][i]
            if scalar.val != 1:
                for coefficient in result.mitems: coefficient *= scalar
            return

        var degreePrefix = newSeq[int](factors.len + 1)
        for i, factor in factors:
            degreePrefix[i + 1] = degreePrefix[i] + factor.len - 1

        proc balancedMiddle(left, right: int): int =
            if right - left == 2: return left + 1
            let target = degreePrefix[left] +
                (degreePrefix[right] - degreePrefix[left]) div 2
            var low = left + 1
            var high = right
            while low < high:
                let middle = (low + high) div 2
                if degreePrefix[middle] < target: low = middle + 1
                else: high = middle
            result = low
            if result > left + 1:
                let currentDifference = abs(
                    (degreePrefix[result] - degreePrefix[left]) -
                    (degreePrefix[right] - degreePrefix[result]))
                let previousDifference = abs(
                    (degreePrefix[result - 1] - degreePrefix[left]) -
                    (degreePrefix[right] - degreePrefix[result - 1]))
                if previousDifference < currentDifference: result -= 1

        proc solve(left, right: int): seq[T] =
            if left + 1 == right: return factors[left]
            let middle = balancedMiddle(left, right)
            result = convolution(solve(left, middle), solve(middle, right))

        result = solve(0, factors.len)
        if scalar.val != 1:
            for coefficient in result.mitems: coefficient *= scalar
