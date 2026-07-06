# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/bitvector

var bv = newBitVector(130)
bv.set(0)
bv.set(64)
bv.set(129)
bv.build()
assert bv.access(0)
assert bv[64]
assert not bv[65]
assert bv.rank(0) == 0
assert bv.rank(65) == 2
assert bv.rank(130) == 3
