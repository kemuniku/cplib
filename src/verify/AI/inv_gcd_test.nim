# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/inv_gcd

assert inv_gcd(3, 11) == (1, 4)
assert inv_gcd(6, 15) == (3, 3)
