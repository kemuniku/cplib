when not declared CPLIB_MATH_SURREAL:
    const CPLIB_MATH_SURREAL* = 1
    import cplib/math/bigint

    type Surreal* = object
        num: BigInt
        exp: int

    proc initSurreal*(numerator: BigInt, denominatorExponent: int = 0): Surreal =
        ## numerator / 2^denominatorExponent を正規化する。O(B^2 log(E+2))。
        if denominatorExponent < 0:
            raise newException(ValueError, "分母の指数は非負整数で指定してください")
        if numerator.isZero:
            return
        result.num = numerator
        result.exp = denominatorExponent
        if denominatorExponent == 0 or numerator mod initBigInt(2) != initBigInt(0):
            return
        let magnitude = numerator.abs
        var lo = 0
        var hi = denominatorExponent
        while lo < hi:
            let mid = lo + (hi - lo) div 2 + 1
            if ((magnitude shr mid) shl mid) == magnitude:
                lo = mid
            else:
                hi = mid - 1
        result.num = numerator shr lo
        result.exp -= lo

    proc initSurreal*[T: SomeInteger](numerator: T, denominatorExponent: int = 0): Surreal =
        ## 組み込み整数を分子として有限超現実数を作る。
        initSurreal(initBigInt(numerator), denominatorExponent)

    proc numerator*(x: Surreal): BigInt =
        ## 正規化後の分子を返す。値のコピーで、内部表現は変更できない。
        x.num

    proc denominatorExponent*(x: Surreal): int =
        ## 正規化後の分母 2^E の指数 E を返す。O(1)。
        x.exp

    proc sgn*(x: Surreal): int =
        ## 符号を -1 / 0 / 1 で返す。O(1)。
        x.num.sgn

    proc isZero*(x: Surreal): bool =
        ## 0 かどうかを返す。O(1)。
        x.num.isZero

    proc `-`*(x: Surreal): Surreal =
        ## 符号を反転する。
        Surreal(num: -x.num, exp: x.exp)

    proc `+`*(x: Surreal): Surreal =
        ## 値をそのまま返す。
        x

    proc abs*(x: Surreal): Surreal =
        ## 絶対値を返す。
        Surreal(num: x.num.abs, exp: x.exp)

    proc cmp*(x, y: Surreal): int =
        ## 厳密な大小比較を -1 / 0 / 1 で返す。O(B^2)、分母を実体化しない。
        if x.sgn != y.sgn:
            return system.cmp(x.sgn, y.sgn)
        if x.exp == y.exp:
            return cmp(x.num, y.num)
        if x.exp < y.exp:
            result = cmp(x.num, y.num shr (y.exp - x.exp))
            if result == 0: result = -1
        else:
            result = cmp(x.num shr (x.exp - y.exp), y.num)
            if result == 0: result = 1

    proc `==`*(x, y: Surreal): bool =
        ## 正規化表現の一致を判定する。O(B)。
        x.exp == y.exp and x.num == y.num

    proc `<`*(x, y: Surreal): bool =
        ## x < y を厳密に判定する。O(B^2)。
        cmp(x, y) < 0

    proc `<=`*(x, y: Surreal): bool =
        ## x <= y を厳密に判定する。O(B^2)。
        cmp(x, y) <= 0

    proc `>`*(x, y: Surreal): bool =
        ## x > y を厳密に判定する。O(B^2)。
        cmp(x, y) > 0

    proc `>=`*(x, y: Surreal): bool =
        ## x >= y を厳密に判定する。O(B^2)。
        cmp(x, y) >= 0

    proc `+`*(x, y: Surreal): Surreal =
        ## 分母を揃えて加算し、正規化する。O(B^2 log(E+2))。
        if x.isZero: return y
        if y.isZero: return x
        let exponent = max(x.exp, y.exp)
        initSurreal((x.num shl (exponent - x.exp)) +
            (y.num shl (exponent - y.exp)), exponent)

    proc `-`*(x, y: Surreal): Surreal =
        ## 厳密な差を返す。O(B^2 log(E+2))。
        x + (-y)

    proc `+=`*(x: var Surreal, y: Surreal) =
        ## x に y を加算する。
        x = x + y

    proc `-=`*(x: var Surreal, y: Surreal) =
        ## x から y を減算する。
        x = x - y

    proc `$`*(x: Surreal): string =
        ## 正確な分子/2^指数の文字列を返す。整数なら分子のみ。
        result = $x.num
        if x.exp != 0:
            result.add("/2^" & $x.exp)

    proc aboveAtExponent(x: Surreal, exponent: int): Surreal =
        ## 指定した分母の格子で x より大きい最小の値を返す。
        let scaled = if exponent <= x.exp: x.num shr (x.exp - exponent)
            else: x.num shl (exponent - x.exp)
        initSurreal(scaled + initBigInt(1), exponent)

    proc surrealCut*(left, right: openArray[Surreal]): Surreal =
        ## 有限 cut {left | right} の最も単純な数を返す。不整合は ValueError。
        var lower, upper: Surreal
        let hasLower = left.len != 0
        let hasUpper = right.len != 0
        if hasLower:
            lower = left[0]
            for x in left:
                if lower < x: lower = x
        if hasUpper:
            upper = right[0]
            for x in right:
                if x < upper: upper = x
        if hasLower and hasUpper and lower >= upper:
            raise newException(ValueError, "cut の全左要素は全右要素より小さい必要があります")
        if (not hasLower or lower.sgn < 0) and
                (not hasUpper or upper.sgn > 0):
            return
        var negate = false
        if hasUpper and upper.sgn <= 0:
            (lower, upper) = (-upper, -lower)
            negate = true
        let bounded = if negate: hasLower else: hasUpper
        result = aboveAtExponent(lower, 0)
        if bounded and result >= upper:
            var lo = 1
            var hi = max(lower.exp, upper.exp)
            if aboveAtExponent(lower, hi) >= upper:
                if hi == high(int):
                    raise newException(OverflowDefect, "cut の結果の分母指数が int に収まりません")
                inc hi
            while lo < hi:
                let mid = lo + (hi - lo) div 2
                if aboveAtExponent(lower, mid) < upper:
                    hi = mid
                else:
                    lo = mid + 1
            result = aboveAtExponent(lower, lo)
        if negate: result = -result
