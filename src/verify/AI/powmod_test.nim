# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/powmod

assert powmod(2, 10, 1000) == 24
assert powmod(3, 0, 7) == 1
assert powmod(10, 2, 6) == 4
