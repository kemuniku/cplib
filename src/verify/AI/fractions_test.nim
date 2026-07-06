# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/fractions

let a = initFraction(2, 4)
let b = initFraction(1, 3)
assert $a == "1/2"
assert (a + b) == initFraction(5, 6)
assert (a - b) == initFraction(1, 6)
assert (a * b) == initFraction(1, 6)
assert (a / b) == initFraction(3, 2)
assert (a + 1) == initFraction(3, 2)
assert (1 + a) == initFraction(3, 2)
assert (1 - a) == initFraction(1, 2)
assert (2 * b) == initFraction(2, 3)
assert (1 / b) == initFraction(3, 1)
assert -a == initFraction(-1, 2)
assert abs(initFraction(-3, 4)) == initFraction(3, 4)
assert inv(a) == initFraction(2, 1)
assert a > b
assert b < a
assert a >= initFraction(1, 2)
assert b <= initFraction(1, 3)
assert a == initFraction(1, 2)
assert cmp(a, b) > 0
assert cmp(a, 1) < 0
assert cmp(1, a) > 0
assert abs(a.toFloat - 0.5) < 1e-12
assert pow(initFraction(2, 3), 3) == initFraction(8, 27)
assert initFraction(0, 0, false).isNaN
