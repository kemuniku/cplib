# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import sequtils, math, sets, algorithm
import cplib/matrix/matrix
import cplib/matrix/matops
import random

var rng = initRand(0)

var l, r = newSeq[Matrix[int]]()
var a = newSeqWith(2, newSeqWith(3, rng.rand(-5..5)))
r.add(initMatrix(a))
l.add(initMatrix(a.transposed))
a = newSeqWith(2, newSeqWith(3, rng.rand(-5..5)))
r.add(a.toMatrix)
r.add(a.transposed.toMatrix)
for i in -1..1:
    l.add(initMatrix(2, 3, i))
    r.add(initMatrix(3, 2, i))
var r2 = initMatrix((1..2).toSeq)
var r3 = initMatrix((1..3).toSeq)
var c2 = initMatrix((1..2).toSeq, true)
var c3 = initMatrix((1..3).toSeq, true)

for item in r:
    echo item
    echo "---"


# template assert_op(op1, op2: untyped) =
#     var x = initFraction(1, 0)
#     for i in r:
#         for j in r:
#             if isNaN(x): x = initFraction(1, 0)
#             var xi = x
#             op2(x, i)
#             assert op1(xi, i) == x or isNaN(x)
#             assert (abs(op1(i, j).tofloat - op1(i.tofloat, j.tofloat)) <= 1e-10) or (op1(i.toFloat, j.toFloat).abs.classify == fcInf) or (op1(i.toFloat, j.toFloat).abs.classify == fcNan)
#     x = initFraction(1, 0)
#     for i in r:
#         for j in t:
#             if isNaN(x): x = initFraction(1, 0)
#             var xi = x
#             op2(x, i)
#             assert op1(xi, i) == x or isNaN(x)
#             assert (abs(op1(i, j).tofloat - op1(i.tofloat, j.tofloat)) <= 1e-10) or (op1(i.toFloat, j.toFloat).abs.classify == fcInf) or (op1(i.toFloat, j.toFloat).abs.classify == fcNan)
#     for i in t:
#         for j in r:
#             assert (abs(op1(i, j).tofloat - op1(i.tofloat, j.tofloat)) <= 1e-10) or (op1(i.toFloat, j.toFloat).abs.classify == fcInf) or (op1(i.toFloat, j.toFloat).abs.classify == fcNan)
# assert_op(`+`, `+=`)
# assert_op(`-`, `-=`)
# assert_op(`*`, `*=`)
# assert_op(`/`, `/=`)

# proc assert_cmp() =
#     proc eq(x, y: float): bool = (x == y) or (abs(x - y) < 1e-10)
#     proc lt(x, y: float): bool = (not eq(x, y)) and (x < y)
#     proc gt(x, y: float): bool = (not eq(x, y)) and (x > y)
#     proc cmp(x, y: float): int = (if lt(x, y): -1 elif eq(x, y): 0 else: 1)
#     for i in r:
#         for j in r:
#             assert lt(i.toFloat, j.toFloat) == (i < j)
#             assert gt(i.toFloat, j.toFloat) == (i > j)
#             assert eq(i.toFloat, j.toFloat) == (i == j)
#             assert (not lt(i.toFloat, j.toFloat)) == (i >= j)
#             assert (not gt(i.toFloat, j.toFloat)) == (i <= j)
#             assert (not eq(i.toFloat, j.toFloat)) == (i != j)
#             assert cmp(i.toFloat, j.toFloat) == cmp(i, j)
#     for i in r:
#         for j in t:
#             assert lt(i.toFloat, j.toFloat) == (i < j)
#             assert gt(i.toFloat, j.toFloat) == (i > j)
#             assert eq(i.toFloat, j.toFloat) == (i == j)
#             assert (not lt(i.toFloat, j.toFloat)) == (i >= j)
#             assert (not gt(i.toFloat, j.toFloat)) == (i <= j)
#             assert (not eq(i.toFloat, j.toFloat)) == (i != j)
#             assert cmp(i.toFloat, j.toFloat) == cmp(i, j)
#     for i in t:
#         for j in r:
#             assert lt(i.toFloat, j.toFloat) == (i < j)
#             assert gt(i.toFloat, j.toFloat) == (i > j)
#             assert eq(i.toFloat, j.toFloat) == (i == j)
#             assert (not lt(i.toFloat, j.toFloat)) == (i >= j)
#             assert (not gt(i.toFloat, j.toFloat)) == (i <= j)
#             assert (not eq(i.toFloat, j.toFloat)) == (i != j)
#             assert cmp(i.toFloat, j.toFloat) == cmp(i, j)
# assert_cmp()

# var st = initHashSet[Fraction[int]](0)
# for _ in 0..1:
#     for ri in r:
#         st.incl(ri)
# for ri in r:
#     assert ri.inv == (1 / ri)
#     assert ri.abs == (if ri < 0: -ri else: ri)
# assert st.len == r.sorted.deduplicate(true).len

# var c: Fraction[int] = 2
# assert c == initFraction(2, 1)
