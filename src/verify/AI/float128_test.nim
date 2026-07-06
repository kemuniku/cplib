# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/float128

let a: float128 = 1.5
let b: float128 = 2
assert ((a + b).to_float - 3.5).abs < 1e-12
assert ((b - a).to_float - 0.5).abs < 1e-12
assert ((a * b).to_float - 3.0).abs < 1e-12
assert ((b / a).to_float - (4.0 / 3.0)).abs < 1e-12
assert (-a).to_float < 0
assert abs(-a) == a
assert cmp(a, b) < 0
assert b > a
assert a < b
assert a == a

doAssert not compiles(a mod b)
doAssert not compiles(a & b)
doAssert not compiles(a | b)
doAssert not compiles(a ^ b)
doAssert not compiles(a << b)
doAssert not compiles(a >> b)
