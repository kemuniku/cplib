# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/fractions

proc checkInverse[T]() =
    for numerator in -5..5:
        for denominator in 1..5:
            let value = initFraction(T(numerator), T(denominator))
            let inverse = value.inv()
            assert inverse.den >= T(0)
            if numerator != 0:
                assert (inverse < initFraction(T(0))) == (numerator < 0)
                assert inverse.inv() == value
                assert abs(inverse) == initFraction(T(denominator), T(abs(numerator)))
                assert value * inverse == initFraction(T(1))
            else:
                assert inverse == initFraction(T(1), T(0))
    assert initFraction(T(-1), T(0)).inv().den > T(0)
    assert initFraction(T(-1), T(0)).inv() == initFraction(T(0))
    assert initFraction(T(1), T(0)).inv() == initFraction(T(0))
    assert initFraction(T(0), T(0)).inv().isNaN
    let inverse = initFraction(T(-2), T(4), false).inv()
    assert inverse.den > T(0)
    assert inverse == initFraction(T(-2))

checkInverse[int]()
checkInverse[int64]()
