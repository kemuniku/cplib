# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/nearest_equiv

assert nearest_equiv(2, 10, 3) == 11
assert nearest_equiv(20, 10, 3) == 11
assert nearest_equiv(-1, 5, 4) == 7
assert nearest_equiv(10, 10, -6) == 10
