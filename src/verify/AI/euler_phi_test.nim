# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/euler_phi

assert euler_phi(1) == 1
assert euler_phi(9) == 6
assert euler_phi(36) == 12
assert euler_phi_list(10) == @[0, 1, 1, 2, 2, 4, 2, 6, 4, 6, 4]
