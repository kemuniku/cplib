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

var words = newBitVector(130)
words.setWord(0, 1'u64 or (1'u64 shl 63))
words.setWord(1, 1'u64 or (1'u64 shl 63))
words.setWord(2, 2'u64)
words.build()
var expected = 0
for i in 0..130:
    assert words.rank(i) == expected
    if i < 130:
        let present = i in [0, 63, 64, 127, 129]
        assert words[i] == present
        if present: inc expected
words.setWord(0, 0)
words.build()
assert words.rank(64) == 0
assert words.rank(130) == 3
