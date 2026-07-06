# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/sequtils2D

let mat = @[@[3, 1], @[4, 2]]
assert mat.maxIndex == (1, 0)
assert mat.minIndex == (0, 1)
