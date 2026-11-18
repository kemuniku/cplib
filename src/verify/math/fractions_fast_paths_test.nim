# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/fractions

proc normalized(num, den: int64): (int64, int64) =
    if den == 0:
        let sign = if num > 0: 1'i64 elif num < 0: -1'i64 else: 0'i64
        return (sign, 0'i64)
    var n = num
    var d = den
    if d < 0:
        n = -n
        d = -d
    var a = if n < 0: -n else: n
    var b = d
    while b != 0:
        let r = a mod b
        a = b
        b = r
    (n div a, d div a)

proc expectFinite[T](actual: Fraction[T], num, den: int64) =
    doAssert actual.den > T(0)
    doAssert normalized(int64(actual.num), int64(actual.den)) == normalized(num, den)

proc expectInfinity[T](actual: Fraction[T], positive: bool) =
    doAssert actual.den == T(0)
    doAssert actual.num != T(0)
    doAssert (actual.num > T(0)) == positive

proc checkReduce[T]() =
    for num in -8..8:
        for den in -8..8:
            var value = initFraction(T(num), T(den), false)
            value.reduce()
            let expected = normalized(int64(num), int64(den))
            doAssert (int64(value.num), int64(value.den)) == expected
    var integer = initFraction(low(T), T(1), false)
    integer.reduce()
    doAssert integer.num == low(T)
    doAssert integer.den == T(1)
    var zero = initFraction(T(0), low(T), false)
    zero.reduce()
    doAssert zero.num == T(0)
    doAssert zero.den == T(1)
    var negativeInfinity = initFraction(low(T), T(0), false)
    negativeInfinity.reduce()
    doAssert negativeInfinity.num == T(-1)
    doAssert negativeInfinity.den == T(0)

proc checkFiniteArithmetic[T]() =
    for a in -4..4:
        for b in -4..4:
            if b == 0:
                continue
            let x = initFraction(T(a), T(b), false)
            for c in -4..4:
                for d in -4..4:
                    if d == 0:
                        continue
                    let y = initFraction(T(c), T(d), false)
                    expectFinite(x + y, int64(a*d+c*b), int64(b*d))
                    expectFinite(x - y, int64(a*d-c*b), int64(b*d))
                    expectFinite(x * y, int64(a*c), int64(b*d))
                    if c != 0:
                        expectFinite(x / y, int64(a*d), int64(b*c))
                expectFinite(x + T(c), int64(a+c*b), int64(b))
                expectFinite(x - T(c), int64(a-c*b), int64(b))
                expectFinite(x * T(c), int64(a*c), int64(b))
                if c != 0:
                    expectFinite(x / T(c), int64(a), int64(b*c))

proc checkSameDenominator[T]() =
    when sizeof(T) == 4:
        let scale = T(100000)
    else:
        let scale = T(4000000000'i64)
    let x = initFraction(scale, scale, false)
    let y = initFraction(scale, scale, false)
    expectFinite(x + y, 2, 1)
    expectFinite(x - y, 0, 1)
    expectFinite(x + initFraction(-scale, scale, false), 0, 1)
    let negativeDenominator = initFraction(scale, -scale, false)
    expectFinite(negativeDenominator + negativeDenominator, -2, 1)

proc checkChainedArithmetic[T]() =
    var value = initFraction(T(0))
    var numerator = 0'i64
    for i in 0..<180:
        let delta = int64(i mod 11 - 5)
        let term = initFraction(T(delta), T(6), false)
        if (i and 1) == 0:
            value += term
            numerator += delta
        else:
            value -= term
            numerator -= delta
        expectFinite(value, numerator, 6)
    var integer = initFraction(low(T), T(1), false)
    integer += T(0)
    doAssert integer.num == low(T)
    doAssert integer.den == T(1)
    var minimum = initFraction(low(T), T(2), false)
    minimum *= T(1)
    doAssert minimum.num == low(T)
    doAssert minimum.den == T(2)
    var quotient = initFraction(T(1), T(50000))
    let divisor = initFraction(T(-1), T(50000))
    quotient /= divisor
    quotient /= divisor
    expectFinite(quotient, 50000, 1)

proc checkSpecialValues[T]() =
    let nan = initFraction(T(0), T(0), false)
    let positiveInfinity = initFraction(T(2), T(0), false)
    let negativeInfinity = initFraction(T(-3), T(0), false)
    let zero = initFraction(T(0), T(5), false)
    let positive = initFraction(T(3), T(2), false)
    let negative = initFraction(T(-3), T(2), false)
    for x in [nan, positiveInfinity, negativeInfinity, zero, positive, negative]:
        doAssert (nan + x).isNaN
        doAssert (x + nan).isNaN
        doAssert (nan - x).isNaN
        doAssert (x - nan).isNaN
        doAssert (nan * x).isNaN
        doAssert (x * nan).isNaN
        doAssert (nan / x).isNaN
        doAssert (x / nan).isNaN
    expectInfinity(positiveInfinity + positiveInfinity, true)
    expectInfinity(negativeInfinity + negativeInfinity, false)
    doAssert (positiveInfinity + negativeInfinity).isNaN
    doAssert (negativeInfinity + positiveInfinity).isNaN
    doAssert (positiveInfinity - positiveInfinity).isNaN
    doAssert (negativeInfinity - negativeInfinity).isNaN
    for x in [zero, positive, negative]:
        expectInfinity(x + positiveInfinity, true)
        expectInfinity(positiveInfinity + x, true)
        expectInfinity(x + negativeInfinity, false)
        expectInfinity(negativeInfinity + x, false)
        expectFinite(x / positiveInfinity, 0, 1)
        expectFinite(x / negativeInfinity, 0, 1)
    doAssert (zero * positiveInfinity).isNaN
    doAssert (negativeInfinity * zero).isNaN
    doAssert (positiveInfinity * T(0)).isNaN
    doAssert (zero / zero).isNaN
    doAssert (positiveInfinity / negativeInfinity).isNaN
    expectInfinity(positive / zero, true)
    expectInfinity(negative / zero, false)
    expectInfinity(positiveInfinity * negative, false)
    expectInfinity(negativeInfinity / positive, false)

proc checkAll[T]() =
    checkReduce[T]()
    checkFiniteArithmetic[T]()
    checkSameDenominator[T]()
    checkChainedArithmetic[T]()
    checkSpecialValues[T]()

checkAll[int]()
checkAll[int32]()
checkAll[int64]()
echo "Hello World"
