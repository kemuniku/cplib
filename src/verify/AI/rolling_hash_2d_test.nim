# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/matrix/rolling_hash_2d

let hm = initHashMatrix(@[@[1, 2, 1], @[3, 4, 3]])
assert hm[0, 1] == 2
assert hm[1][2] == 3
let leftCol = hm[0..1, 0..0]
let rightCol = hm.get(0..1, 2..2)
let middleCol = hm[0..1, 1..1]
assert leftCol == rightCol
assert leftCol.gethash == rightCol.gethash
assert leftCol != middleCol
