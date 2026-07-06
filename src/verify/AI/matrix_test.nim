# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/matrix/matrix

var a = initMatrix(@[@[1, 2], @[3, 4]])
let b = toMatrix(@[@[5, 6], @[7, 8]])
assert a.h == 2
assert a.w == 2
assert a[0] == @[1, 2]
assert a[1, 0] == 3
a[0, 1] = 9
assert a[0, 1] == 9
a[0] = @[1, 2]
assert a == initMatrix(@[@[1, 2], @[3, 4]])
assert $a == "1 2\n3 4"
assert -a == initMatrix(@[@[-1, -2], @[-3, -4]])
assert a + b == initMatrix(@[@[6, 8], @[10, 12]])
assert b - a == initMatrix(@[@[4, 4], @[4, 4]])
assert a * b == initMatrix(@[@[19, 22], @[43, 50]])
assert a * 2 == initMatrix(@[@[2, 4], @[6, 8]])
assert 2 * a == initMatrix(@[@[2, 4], @[6, 8]])
assert (a + 1) == initMatrix(@[@[2, 3], @[4, 5]])
assert (a and initMatrix(@[@[1, 0], @[1, 0]])) == initMatrix(@[@[1, 0], @[1, 0]])
assert identity_matrix[int](2) == initMatrix(@[@[1, 0], @[0, 1]])
assert a.pow(2) == initMatrix(@[@[7, 10], @[15, 22]])
assert (a ** 2) == a.pow(2)
assert a.sum == 10
assert initMatrix(@[1, 2, 3]).h == 1
assert initMatrix(@[1, 2, 3], true).w == 1
assert initMatrix(2, 3, 7).sum == 42
