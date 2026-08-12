# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/matrix/static_matrix
import std/options

var a = initMatrix([[1, 2], [3, 4]])
let b = toMatrix([[5, 6], [7, 8]])
assert a.h == 2
assert a.w == 2
assert a[0] == [1, 2]
assert a[1, 0] == 3
a[0, 1] = 9
assert a[0, 1] == 9
a[0] = [1, 2]
assert a == initMatrix([[1, 2], [3, 4]])
assert $a == "1 2\n3 4"
assert -a == initMatrix([[-1, -2], [-3, -4]])
assert a + b == initMatrix([[6, 8], [10, 12]])
assert b - a == initMatrix([[4, 4], [4, 4]])
assert a * b == initMatrix([[19, 22], [43, 50]])
assert a * 2 == initMatrix([[2, 4], [6, 8]])
assert 2 * a == initMatrix([[2, 4], [6, 8]])
assert (a + 1) == initMatrix([[2, 3], [4, 5]])
assert (a and initMatrix([[1, 0], [1, 0]])) == initMatrix([[1, 0], [1, 0]])
assert identity_matrix[2, 2, int](2) == initMatrix([[1, 0], [0, 1]])
assert a.pow(2) == initMatrix([[7, 10], [15, 22]])
assert (a ** 2) == a.pow(2)
assert a.sum == 10
assert initMatrix[2, 3, int](7).sum == 42

let c = initMatrix([[1.0, 2.0, 3.0], [2.0, 4.0, 6.0]])
assert c.rank == 1
assert c.gaussJordan.matrix == initMatrix([[1.0, 2.0, 3.0], [0.0, 0.0, 0.0]])
assert c.kernel == @[[ -2.0, 1.0, 0.0], [-3.0, 0.0, 1.0]]
assert c.image == @[[1.0, 2.0]]
let solution = c.solveLinearEquation([4.0, 8.0])
assert solution.isSome
assert solution.get == [4.0, 0.0, 0.0]
assert c.solveLinearEquation([4.0, 9.0]).isNone
let invertible = initMatrix([[1.0, 2.0], [3.0, 5.0]])
assert invertible.inverse.get == initMatrix([[-5.0, 2.0], [3.0, -1.0]])
assert initMatrix([[1.0, 2.0], [2.0, 4.0]]).inverse.isNone
