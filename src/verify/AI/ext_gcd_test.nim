# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/math
import cplib/math/ext_gcd

let (x1, y1) = ext_gcd(30, 18)
doAssert 30 * x1 + 18 * y1 == gcd(30, 18)
let (x2, y2) = ext_gcd(-30, 18)
doAssert -30 * x2 + 18 * y2 == gcd(30, 18)
let (x3, y3) = ext_gcd(17, 5)
doAssert 17 * x3 + 5 * y3 == 1

doAssert ext_gcd(low(int), 1) == (0, 1)
doAssert ext_gcd(1, low(int)) == (1, 0)
doAssert ext_gcd(low(int), -1) == (0, -1)
doAssert ext_gcd(-1, low(int)) == (-1, 0)
doAssert ext_gcd(low(int), 0) == (-1, 0)
doAssert ext_gcd(0, low(int)) == (0, -1)
doAssert ext_gcd(low(int), low(int)) in [(-1, 0), (0, -1)]
doAssert ext_gcd(low(int), high(int)) == (-1, -1)
doAssert ext_gcd(high(int), low(int)) == (-1, -1)
doAssert ext_gcd(low(int), 2) == (0, 1)
doAssert ext_gcd(low(int), 3) == (1, high(int) div 3 + 1)
for a in -20..20:
    for b in -20..20:
        let (x, y) = ext_gcd(a, b)
        doAssert a * x + b * y == gcd(a, b)
        if a == 0 and b == 0: continue
        for xx in -20..20:
            for yy in -20..20:
                if a * xx + b * yy == gcd(a, b):
                    doAssert abs(x) + abs(y) <= abs(xx) + abs(yy)
