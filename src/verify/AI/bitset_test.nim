# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/bitset

var a = initBitSet(@[true, false, true, false, true], 71)
var b = initBitSet(71)
b[1] = true
b[2] = true
b[64] = true
assert a.len == 71
assert a[0]
assert not a[1]
assert a.popcount() == 3
assert b.popcount() == 3
assert (a & b).popcount() == 1
assert (a | b).popcount() == 5
assert (a ^ b).popcount() == 4
assert a.andpopcount(b) == 1
assert a.orpopcount(b) == 5
assert a.xorpopcount(b) == 4
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

var c = initBitSetFromIndexes(@[0, 63, 64, 129], 130)
assert c.popcount == 4
assert (c << 1).popcount == 3
assert (c << 1)[1]
assert (c << 1)[64]
assert (c << 1)[65]
assert (c >> 1).popcount == 3
assert (c >> 1)[62]
assert (c >> 1)[63]
assert (c >> 1)[128]
assert (c << 64)[64]
assert (c << 64)[127]
assert (c << 64)[128]
assert (c >> 64)[0]
assert (c >> 64)[65]
assert (c << 130).popcount == 0
assert (c >> 130).popcount == 0
assert (~c).popcount == 126

var d = initBitSet(@[true, false, true])
assert d.len == 3
assert $d == "101"
d[0] = 0
d[1] = 1
assert $d == "110"
assert (~initBitSet(0)).popcount == 0

var caught = false
try:
    discard initBitSet(1)[1]
except IndexDefect:
    caught = true
assert caught

caught = false
try:
    discard initBitSet(1) | initBitSet(2)
except ValueError:
    caught = true
assert caught

caught = false
try:
    discard c << -1
except ValueError:
    caught = true
assert caught

for n in @[0, 1, 2, 63, 64, 65, 127, 128, 129, 191]:
    var x = initBitSet(n)
    var y = initBitSet(n)
    for i in 0..<n:
        x[i] = (i mod 3 == 0) or (i mod 11 == 4)
        y[i] = (i mod 5 == 1) or (i mod 7 == 2)
    assert (x & y).popcount == x.andpopcount(y)
    assert (x | y).popcount == x.orpopcount(y)
    assert (x ^ y).popcount == x.xorpopcount(y)
    assert x.popcount + (~x).popcount == n
    for shift in 0..(n + 1):
        let left = x << shift
        let right = x >> shift
        assert left.len == n
        assert right.len == n
        for i in 0..<n:
            assert left[i] == (i >= shift and x[i - shift])
            assert right[i] == (i + shift < n and x[i + shift])
