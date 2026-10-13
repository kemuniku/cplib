# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/nearest_equiv

doAssert nearest_equiv(2, 10, 3) == 11
doAssert nearest_equiv(20, 10, 3) == 11
doAssert nearest_equiv(-1, 5, 4) == 7
doAssert nearest_equiv(10, 10, -6) == 10

doAssert nearest_equiv(high(int), low(int), 1) == low(int)
doAssert nearest_equiv(low(int), 0, 1) == 0
doAssert nearest_equiv(0, high(int), 1) == high(int)
doAssert nearest_equiv(low(int), high(int), -1) == high(int)
doAssert nearest_equiv(high(int), low(int), 3) == low(int)
doAssert nearest_equiv(high(int), low(int), 2) == low(int) + 1
doAssert nearest_equiv(low(int), low(int), low(int)) == low(int)
doAssert nearest_equiv(low(int), 0, low(int)) == 0
doAssert nearest_equiv(high(int), low(int), low(int)) == -1
doAssert nearest_equiv(-1, 0, low(int)) == high(int)
doAssert nearest_equiv(low(int), 0, high(int)) == high(int) - 1
for x in -20..20:
    for l in -20..20:
        for m in -10..10:
            if m == 0: continue
            var expected = l
            while (expected - x) mod m != 0: inc expected
            doAssert nearest_equiv(x, l, m) == expected
