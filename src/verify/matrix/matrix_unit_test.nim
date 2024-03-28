# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import sequtils, strutils, sets
import cplib/matrix/matrix
import cplib/matrix/matops
import random

var rng = initRand(0)

var l, r = newSeq[Matrix[int]]()
for i in 0..<2:
    var a = newSeqWith(2, newSeqWith(3, rng.rand(-5..5)))
    l.add(initMatrix(a))
    r.add(initMatrix(a.transposed))
for i in 0..<2:
    var a = newSeqWith(2, newSeqWith(3, rng.rand(-5..5)))
    l.add(a.toMatrix)
    r.add(a.transposed.toMatrix)
for i in -1..1:
    l.add(initMatrix(2, 3, i))
    r.add(initMatrix(3, 2, i))
var r2 = initMatrix((1..2).toSeq)
var r3 = initMatrix((1..3).toSeq)
var c2 = initMatrix((1..2).toSeq, true)
var c3 = initMatrix((1..3).toSeq, true)

assert l.mapIt(it.h).allIt(it == 2) and l.mapIt(it.w).allIt(it == 3)
assert r.mapIt(it.h).allIt(it == 3) and r.mapIt(it.w).allIt(it == 2)
assert r2.h == 1 and r2.w == 2
assert r3.h == 1 and r3.w == 3
assert c2.h == 2 and c2.w == 1
assert c3.h == 3 and c3.w == 1


template assert_op(op1, op2: untyped) =
    for lr in [l, r]:
        for a in lr:
            for b in lr:
                check(op1, op2, a, b)
template check(op1, op2, a, b: untyped) =
    var m1 = op1(a, b)
    var m2 = a
    op2(m2, b)
    for i in 0..<a.h:
        for j in 0..<a.w:
            assert m1[i][j] == m2[i, j]
assert_op(`+`, `+=`)
assert_op(`-`, `-=`)
assert_op(`*`, `*=`)
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

var st = initHashSet[Matrix[int]]()
for item in l: st.incl(item)
for item in r: st.incl(item)
assert st.len == 14

var iden = identity_matrix[int](3)
for i in 0..<3:
    for j in 0..<3:
        if i == j: assert iden[i, j] == 1
        else: assert iden[i, j] == 0
for i in [0, 1, 2, 10, 100, 1000]:
    assert iden.pow(i) == iden
assert iden.sum == 3

for a in l:
    for b in r:
        var m1 = a @ b
        var m2 = a
        m2 @= b
        assert m1 == m2
    var m3 = r2 @ a
    var m4 = a @ c3
    assert m3.h == 1 and m3.w == 3
    assert m4.h == 2 and m4.w == 1
