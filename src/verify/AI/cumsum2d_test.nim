# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/cumsum2d

let cs = toCumSum2D(@[@[1, 2, 3], @[4, 5, 6]])
assert cs.query(0, 2, 0, 3) == 21
assert cs.query(1, 2, 1, 3) == 11
