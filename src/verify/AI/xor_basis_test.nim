# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/xor_basis

var xb = initXorBasis(@[1, 2, 3])
assert xb.len_basis == 2
assert xb.can_make(3)
assert not xb.can_make(4)
xb.incl(4)
assert xb.len_basis == 3
assert xb.kth_smallest(0) == 0
assert xb.kth_smallest(5) == 5
assert xb.kth_smallest(8) == -1
assert xb.lt(4) == 3
assert xb.le(4) == 4
assert xb.index(6) == 6
assert xb.xor_min(5) == 5
assert xb.xor_kth(2, 0) == 2
assert xb.xor_kth(2, 3) == 1
assert xb.xor_kth(2, 8) == -1
