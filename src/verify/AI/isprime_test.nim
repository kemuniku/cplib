# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/isprime

assert not isprime(1)
assert isprime(2)
assert isprime(97)
assert not isprime(91)
assert isprime(1_000_000_007)
