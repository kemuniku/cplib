when not declared CPLIB_MATH_FACTORIZED_INT:
    const CPLIB_MATH_FACTORIZED_INT* = 1
    import algorithm
    import cplib/math/primefactor
    import cplib/math/isprime
    import cplib/math/bigint

    type FactorizedInt* = object
        sign: int
        factors: seq[(int, int)]

    proc checkedExponentSum(a, b: int): int =
        ## 非負指数の和を検査し、int 上限超過には OverflowDefect を送出する。
        if a > high(int) - b:
            raise newException(OverflowDefect, "素因数指数の和が int の範囲を超えます")
        a + b

    proc initFactorizedInt*(factors: openArray[(int, int)], sign: int = 1): FactorizedInt =
        ## 素数と非負指数から整数を構築する。並べ替え O(k log k)、素数判定を別途要する。
        if sign < -1 or sign > 1:
            raise newException(ValueError, "符号は -1, 0, 1 のいずれかです")
        var ordered: seq[(int, int)]
        for (p, e) in factors:
            if p < 2 or not isprime(p) or e < 0:
                raise newException(ValueError, "素数と非負指数が必要です")
            if e > 0:
                if sign == 0:
                    raise newException(ValueError, "0 は正の素因数指数を持てません")
                ordered.add((p, e))
        ordered.sort()
        result.sign = sign
        for (p, e) in ordered:
            if result.factors.len > 0 and result.factors[^1][0] == p:
                result.factors[^1][1] = checkedExponentSum(result.factors[^1][1], e)
            else:
                result.factors.add((p, e))

    proc initFactorizedInt*(x: int): FactorizedInt =
        ## int を素因数分解する。時間は既存 primefactor に依存し、low(int) も扱う。
        if x == 0: return
        result.sign = if x < 0: -1 else: 1
        if x == low(int):
            result.factors = @[(2, sizeof(int) * 8 - 1)]
        else:
            result.factors = primefactor_tuple(if x < 0: -x else: x)

    proc sgn*(x: FactorizedInt): int =
        ## 符号 -1, 0, 1 を返す。O(1)。
        x.sign

    proc isZero*(x: FactorizedInt): bool =
        ## 0 かどうかを返す。O(1)。
        x.sign == 0

    proc primeFactors*(x: FactorizedInt): seq[(int, int)] =
        ## 昇順の素数と正指数の独立したコピーを返す。時間・領域 O(k)。
        result = newSeq[(int, int)](x.factors.len)
        for i, value in x.factors: result[i] = value

    proc `-`*(x: FactorizedInt): FactorizedInt =
        ## 符号を反転する。指数配列のコピーを含め O(k)。
        result = x
        result.sign = -x.sign

    proc abs*(x: FactorizedInt): FactorizedInt =
        ## 絶対値を返す。指数配列のコピーを含め O(k)。
        result = x
        if result.sign < 0: result.sign = 1

    proc `==`*(x, y: FactorizedInt): bool =
        ## 正規化済みの符号と指数を比較する。O(k+l)、実整数化は不要。
        x.sign == y.sign and x.factors == y.factors

    proc mergeFactors(x, y: FactorizedInt, operation: int): FactorizedInt =
        ## 昇順の指数配列を併合する。時間・出力領域 O(k+l)。
        var i, j = 0
        while i < x.factors.len or j < y.factors.len:
            var p, a, b: int
            if j == y.factors.len or (i < x.factors.len and x.factors[i][0] < y.factors[j][0]):
                (p, a) = x.factors[i]
                inc i
            elif i == x.factors.len or y.factors[j][0] < x.factors[i][0]:
                (p, b) = y.factors[j]
                inc j
            else:
                (p, a) = x.factors[i]
                b = y.factors[j][1]
                inc i
                inc j
            var e: int
            case operation
            of 0: e = checkedExponentSum(a, b)
            of 1:
                if a < b:
                    raise newException(ValueError, "整数として割り切れません")
                e = a - b
            of 2: e = min(a, b)
            else: e = max(a, b)
            if e > 0: result.factors.add((p, e))
        result.sign = 1

    proc `*`*(x, y: FactorizedInt): FactorizedInt =
        ## 積を返す。時間・領域 O(k+l)、指数上限超過は OverflowDefect。
        if x.isZero or y.isZero: return
        result = mergeFactors(x, y, 0)
        result.sign = x.sign * y.sign

    proc `div`*(x, y: FactorizedInt): FactorizedInt =
        ## 完全除算する。O(k+l)、0 除算・割り切れない場合は ValueError。
        if y.isZero:
            raise newException(ValueError, "0 では除算できません")
        if x.isZero: return
        result = mergeFactors(x, y, 1)
        result.sign = x.sign * y.sign

    proc gcd*(x, y: FactorizedInt): FactorizedInt =
        ## 非負の最大公約数を返す。gcd(0,0)=0、時間・領域 O(k+l)。
        if x.isZero: return abs(y)
        if y.isZero: return abs(x)
        mergeFactors(x, y, 2)

    proc lcm*(x, y: FactorizedInt): FactorizedInt =
        ## 非負の最小公倍数を返す。0 を含む場合は 0、時間・領域 O(k+l)。
        if x.isZero or y.isZero: return
        mergeFactors(x, y, 3)

    proc pow*(x: FactorizedInt, exponent: int): FactorizedInt =
        ## 非負整数乗を O(k) で返す。0^0=1、負指数は ValueError、指数超過は OverflowDefect。
        if exponent < 0:
            raise newException(ValueError, "非負の指数が必要です")
        if exponent == 0: return initFactorizedInt(1)
        if x.isZero: return
        result.sign = if x.sign < 0 and (exponent and 1) != 0: -1 else: 1
        for (p, e) in x.factors:
            if e > high(int) div exponent:
                raise newException(OverflowDefect, "素因数指数の積が int の範囲を超えます")
            result.factors.add((p, e * exponent))

    proc toBigInt*(x: FactorizedInt): BigInt =
        ## 実整数を構築する。時間 O(M(D) sum(log(e+1)))、領域 O(D) と乗算の作業領域。
        if x.isZero: return initBigInt(0)
        result = initBigInt(x.sign)
        for (p, e) in x.factors:
            result *= initBigInt(p).pow(e)

    proc toInt*(x: FactorizedInt): int =
        ## int に変換する。O(k+sum(log(e+1)))、補助領域 O(1)、範囲超過は OverflowDefect。
        if x.isZero: return 0
        let limit = uint(high(int)) + uint(ord(x.sign < 0))
        var magnitude = 1'u
        for (p, e) in x.factors:
            var base = uint(p)
            var exponent = e
            while exponent > 0:
                if (exponent and 1) != 0:
                    if magnitude > limit div base:
                        raise newException(OverflowDefect, "整数が int の範囲を超えます")
                    magnitude *= base
                exponent = exponent shr 1
                if exponent > 0:
                    if base > limit div base:
                        raise newException(OverflowDefect, "整数が int の範囲を超えます")
                    base *= base
        if x.sign > 0: return int(magnitude)
        if magnitude == uint(high(int)) + 1'u: return low(int)
        -int(magnitude)

    proc cmp*(x, y: FactorizedInt): int =
        ## 同符号の異なる値は実整数化して厳密比較する。計算量・領域は toBigInt に依存する。
        if x.sign != y.sign: return cmp(x.sign, y.sign)
        if x == y: return 0
        cmp(x.toBigInt, y.toBigInt)

    proc `<`*(x, y: FactorizedInt): bool =
        ## 厳密な大小比較。計算量・領域は cmp と同じ。
        cmp(x, y) < 0

    proc `<=`*(x, y: FactorizedInt): bool =
        ## 厳密な大小比較。計算量・領域は cmp と同じ。
        cmp(x, y) <= 0

    proc `>`*(x, y: FactorizedInt): bool =
        ## 厳密な大小比較。計算量・領域は cmp と同じ。
        cmp(x, y) > 0

    proc `>=`*(x, y: FactorizedInt): bool =
        ## 厳密な大小比較。計算量・領域は cmp と同じ。
        cmp(x, y) >= 0

    proc `$`*(x: FactorizedInt): string =
        ## 実整数化して 10 進表示する。toBigInt の費用に出力桁数 O(D) が加わる。
        $x.toBigInt
