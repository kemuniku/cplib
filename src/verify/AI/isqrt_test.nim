# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/isqrt

assert isqrt(0) == 0
assert isqrt(1) == 1
assert isqrt(15) == 3
assert isqrt(16) == 4
assert isqrt(1_000_000_000_000.int) == 1_000_000
