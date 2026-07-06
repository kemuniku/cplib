# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/bitset

var a = initBitSet(@[true, false, true, false, true])
var b = initBitSet(0)
b[1] = true
b[2] = true
b[64] = true
assert a[0]
assert not a[1]
assert a.popcount() == 3
assert b.popcount() == 3
assert (a & b).popcount() == 1
assert (a | b).popcount() == 5
assert a.andpopcount(b) == 1
a &= b
assert a.popcount() == 1
a |= b
assert a.popcount() == 3
a ^= b
assert a.popcount() == 0
a[70] = true
assert a[70]
a[70] = false
assert not a[70]
