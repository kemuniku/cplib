# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/math
import cplib/math/ext_gcd

let (x1, y1) = ext_gcd(30, 18)
assert 30 * x1 + 18 * y1 == gcd(30, 18)
let (x2, y2) = ext_gcd(-30, 18)
assert -30 * x2 + 18 * y2 == gcd(30, 18)
let (x3, y3) = ext_gcd(17, 5)
assert 17 * x3 + 5 * y3 == 1
