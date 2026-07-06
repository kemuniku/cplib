# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/QSWAG

let op = proc(x, y: int): int = x + y
var q = initSWAG(op, 0)
assert q.len == 0
q.push(1)
q.push(2)
q.push(3)
assert q.len == 3
assert q.fold() == 6
assert q[0] == 1
assert q[2] == 3
assert q.pop() == 1
assert q.fold() == 5
q.push(4)
assert q.pop() == 2
assert q.fold() == 7
assert $q == "@[3]@[4]"
