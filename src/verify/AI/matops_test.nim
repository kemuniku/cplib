# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/matrix/matops

let a = @[@[1, 2, 3], @[4, 5, 6]]
assert a.rotated(1) == @[@[4, 1], @[5, 2], @[6, 3]]
assert a.rotated(2) == @[@[6, 5, 4], @[3, 2, 1]]
assert a.rotated(-1) == @[@[3, 6], @[2, 5], @[1, 4]]
assert a.transposed == @[@[1, 4], @[2, 5], @[3, 6]]
var b = a
b.rotate()
assert b == @[@[4, 1], @[5, 2], @[6, 3]]
b.transpose()
assert b == @[@[4, 5, 6], @[1, 2, 3]]
var c = @[@[0, 0, 0], @[0, 1, 0], @[0, 0, 0]]
c.trim(0)
assert c == @[@[1]]

let s = @["10", "01"]
assert s.rotated == @["01", "10"]
assert s.transposed == @["10", "01"]
var t = @["000", "010", "000"]
t.trim('0')
assert t == @["1"]
