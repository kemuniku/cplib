# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/tmpl/citrus

assert (-3) % 5 == 2
assert 7 // 3 == 2
assert (-7) // 3 == -3
assert `^`(6, 3) == 5
assert `&`(6, 3) == 2
assert `|`(6, 3) == 7
assert `>>`(8, 1) == 4
assert `<<`(3, 2) == 12

var x = -3
x %= 5
assert x == 2
x //= 2
assert x == 1
x ^= 3
assert x == 2
x &= 6
assert x == 2
x |= 8
assert x == 10
x >>= 1
assert x == 5
x <<= 2
assert x == 20

var mask = 0
mask[2] = true
assert mask[2]
mask[2] = false
assert not mask[2]

assert pow(2, 10) == 1024
assert pow(2, 10, 1000) == 24
var hi = 3
assert hi.chmax(5)
assert not hi.chmax(4)
assert hi == 5
assert hi.chmin(2)
hi.max = 9
hi.min = 4
assert hi == 4
assert at('7') == 7
assert fmtprint(@[1, 2, 3]) == "1 2 3"
