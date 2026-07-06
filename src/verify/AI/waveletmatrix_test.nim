# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/waveletmatrix

let wm = initWaveletMatrix(@[3, 1, 4, 1, 5, 9, 2, 6])
assert wm.kth_smallest(0, 8, 0) == 1
assert wm.kth_smallest(0, 8, 3) == 3
assert wm.kth_smallest(2, 6, 1) == 4
assert wm.range_lowerbound(0, 8, 4) == 4
assert wm.range_upperbound(0, 8, 4) == 5
assert wm.range_lowerbound(1, 5, 2) == 2
assert wm.range_upperbound(1, 5, 1) == 2
let child = wm.get_child(3, 0, 8)
assert child == (l0: 0, r0: 7, l1: 7, r1: 8)

let empty = initWaveletMatrix(@[])
assert empty.range_lowerbound(0, 0, 10) == 0
