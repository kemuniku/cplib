# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import sets
import cplib/matrix/static_matrix

var l = @[
    [[-4, 0, 5], [1, -2, 3]].initMatrix(),
    [[3, -5, 2], [4, 0, -1]].toMatrix(),
    initMatrix[2,3,int](-1),
    initMatrix[2,3,int](0),
    initMatrix[2,3,int](1),
]
var r = @[
    [[-4, 1], [0, -2], [5, 3]].initMatrix(),
    [[3, 4], [-5, 0], [2, -1]].toMatrix(),
    initMatrix[3,2,int](-1),
    initMatrix[3,2,int](0),
    initMatrix[3,2,int](1),
]
var r2 = [[1, 2]].initMatrix()
var r3 = [[1, 2, 3]].initMatrix()
var c2 = [[1], [2]].initMatrix()
var c3 = [[1], [2], [3]].initMatrix()
var sq3 = [[1, 2, 3], [0, 1, 4], [5, 6, 0]].initMatrix()

assert l[0].h == 2 and l[0].w == 3
assert r[0].h == 3 and r[0].w == 2
assert r2.h == 1 and r2.w == 2
assert r3.h == 1 and r3.w == 3
assert c2.h == 2 and c2.w == 1
assert c3.h == 3 and c3.w == 1

template check(op1, op2, a, b: untyped) =
    var m1 = op1(a, b)
    var m2 = a
    op2(m2, b)
    for i in 0..<a.h:
        for j in 0..<a.w:
            assert m1[i][j] == m2[i, j]

template assert_op(op1, op2: untyped) =
    for a in l:
        for b in l:
            check(op1, op2, a, b)
    for a in r:
        for b in r:
            check(op1, op2, a, b)

assert_op(`+`, `+=`)
assert_op(`-`, `-=`)
assert_op(`and`, `and=`)
assert_op(`or`, `or=`)
assert_op(`xor`, `xor=`)
check(`shl`, `shl=`, l[^1], l[^1])
check(`shr`, `shr=`, l[^1], l[^1])
check(`div`, `div=`, l[^1], l[^1])
check(`mod`, `mod=`, l[^1], l[^1])

for item in l:
    assert item == item
    assert $item == $item
    assert hash(item) == hash(item)
    assert -item + 10 != item
for item in r:
    assert item == item
    assert $item == $item
    assert -item + 10 != item

var st = initHashSet[StaticMatrix[2,3,int]]()
for item in l: st.incl(item)
assert st.len == 5

var iden = identity_matrix[3,3,int](3)
for i in 0..<3:
    for j in 0..<3:
        if i == j: assert iden[i, j] == 1
        else: assert iden[i, j] == 0
for i in [0, 1, 2, 10, 100, 1000]:
    assert iden.pow(i) == iden
    assert iden ** i == iden
assert iden.sum == 3

for a in l:
    for b in r:
        var m1 = a * b
        assert m1.h == 2 and m1.w == 2
    var m2 = a
    m2 *= sq3
    assert m2 == a * sq3
    var m3 = r2 * a
    var m4 = a * c3
    assert m3.h == 1 and m3.w == 3
    assert m4.h == 2 and m4.w == 1
