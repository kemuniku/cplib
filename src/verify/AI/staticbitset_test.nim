# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/staticbitset

var a = initBitSet(@[true, false, true, false, true], 70)
var b = initBitSet(@[2, 4, 65], 70)
assert a[0]
assert not a[1]
assert a.popcount() == 3
assert b.popcount() == 3
assert (a & b).popcount() == 2
assert (a | b).popcount() == 4
assert (a ^ b).popcount() == 2
assert a.andpopcount(b) == 2
assert a.orpopcount(b) == 4
assert a.xorpopcount(b) == 2
a &= b
assert a.popcount() == 2
a |= b
assert a.popcount() == 3
a ^= b
assert a.popcount() == 0
a[69] = 1
assert a[69]
assert (a << 1).popcount() == 0
a[69] = 0
a[1] = true
assert (a << 2)[3]
assert (a >> 1)[0]
assert (~initBitSet(5)).popcount() == 5
assert $initBitSet(@[true, false, true], 3) == "101"
