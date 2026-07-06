# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/rolling_hash

let rh = initRollingHash(@[1, 2, 3, 1, 2, 3])
assert rh.query(0..2) == rh.query(3..5)
assert rh.query(0..1) != rh.query(1..2)

var rh2 = initRollingHash("abcabc")
rh2.build(seed = 1)
assert rh2.query(0..2) == rh2.query(3..5)
