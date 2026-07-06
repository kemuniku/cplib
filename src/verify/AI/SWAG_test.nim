# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/SWAG

let op = proc(x, y: int): int = x + y
var swag = initSWAG(op, 0)
assert swag.len == 0
swag.addLast(1)
swag.addLast(2)
swag.addFirst(0)
assert swag.len == 3
assert swag.fold() == 3
assert swag[0] == 0
assert swag[1] == 1
assert swag[2] == 2
assert $swag == "swag@[0, 1, 2]"
assert swag.popFirst() == 0
assert swag.popLast() == 2
assert swag.fold() == 1
swag.addLast(3)
swag.addLast(4)
assert swag.popFirst() == 1
assert swag.fold() == 7
swag.addFirst(10)
assert swag.popLast() == 4
assert swag.fold() == 13
