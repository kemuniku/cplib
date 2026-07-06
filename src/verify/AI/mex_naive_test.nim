# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/mex_naive

assert mex_naive(@[0, 1, 3, 1]) == 2
assert mex_naive(@[1, 2, 3]) == 0
