# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/fractions

proc check[T](x: Fraction[T], n: int, num, den: T) =
    let value = pow(x, n)
    doAssert value.num == num
    doAssert value.den == den

check(initFraction(4_000_000_000'i64), 1, 4_000_000_000'i64, 1'i64)
check(initFraction(1'i64, 4_000_000_000'i64), 1, 1'i64, 4_000_000_000'i64)
check(initFraction(-4_000_000_000'i64), 1, -4_000_000_000'i64, 1'i64)
check(initFraction(50_000'i32), 1, 50_000'i32, 1'i32)
check(initFraction(1'i32, 50_000'i32), 1, 1'i32, 50_000'i32)
check(initFraction(50_000'i64), 2, 2_500_000_000'i64, 1'i64)
check(initFraction(1'i64, 50_000'i64), 2, 1'i64, 2_500_000_000'i64)
check(initFraction(4_000_000_000'i64), 0, 1'i64, 1'i64)
check(initFraction(0'i64), 0, 1'i64, 1'i64)
check(initFraction(0'i64), 5, 0'i64, 1'i64)
check(initFraction(-2'i64, 3'i64), 3, -8'i64, 27'i64)
check(initFraction(-2'i64, 3'i64), 4, 16'i64, 81'i64)

for num in -3..3:
    for den in 1..3:
        let x = initFraction(num, den)
        var expected = initFraction(1)
        for exponent in 0..5:
            doAssert pow(x, exponent) == expected
            expected *= x
echo "Hello World"
