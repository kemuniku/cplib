# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import sequtils, math, sets, algorithm
import cplib/math/fractions

var r = newSeq[Fraction[int]](0)
for i in -3..3:
    for j in -3..3:
        if i == 0 or j == 0: continue
        r.add(initFraction(i, j))
for i in 1..2:
    r.add(initFraction(0, i))
    r.add(initFraction(0, -i))
for i in 1..2:
    r.add(initFraction(i, 0))
    r.add(initFraction(-i, 0))
var t = (-3..3).toSeq

template assert_op(op1, op2: untyped) =
    var x = initFraction(1, 0)
    for i in r:
        for j in r:
            if isNaN(x): x = initFraction(1, 0)
            var xi = x
            op2(x, i)
            assert op1(xi, i) == x or isNaN(x)
            assert (abs(op1(i, j).tofloat - op1(i.tofloat, j.tofloat)) <= 1e-10) or (op1(i.toFloat, j.toFloat).abs.classify == fcInf) or (op1(i.toFloat, j.toFloat).abs.classify == fcNan)
    x = initFraction(1, 0)
    for i in r:
        for j in t:
            if isNaN(x): x = initFraction(1, 0)
            var xi = x
            op2(x, i)
            assert op1(xi, i) == x or isNaN(x)
            assert (abs(op1(i, j).tofloat - op1(i.tofloat, j.tofloat)) <= 1e-10) or (op1(i.toFloat, j.toFloat).abs.classify == fcInf) or (op1(i.toFloat, j.toFloat).abs.classify == fcNan)
    for i in t:
        for j in r:
            assert (abs(op1(i, j).tofloat - op1(i.tofloat, j.tofloat)) <= 1e-10) or (op1(i.toFloat, j.toFloat).abs.classify == fcInf) or (op1(i.toFloat, j.toFloat).abs.classify == fcNan)
assert_op(`+`, `+=`)
assert_op(`-`, `-=`)
assert_op(`*`, `*=`)
assert_op(`/`, `/=`)

proc assert_cmp() =
    proc eq(x, y: float): bool = (x == y) or (abs(x - y) < 1e-10)
    proc lt(x, y: float): bool = (not eq(x, y)) and (x < y)
    proc gt(x, y: float): bool = (not eq(x, y)) and (x > y)
    proc cmp(x, y: float): int = (if lt(x, y): -1 elif eq(x, y): 0 else: 1)
    for i in r:
        for j in r:
            assert lt(i.toFloat, j.toFloat) == (i < j)
            assert gt(i.toFloat, j.toFloat) == (i > j)
            assert eq(i.toFloat, j.toFloat) == (i == j)
            assert (not lt(i.toFloat, j.toFloat)) == (i >= j)
            assert (not gt(i.toFloat, j.toFloat)) == (i <= j)
            assert (not eq(i.toFloat, j.toFloat)) == (i != j)
            assert cmp(i.toFloat, j.toFloat) == cmp(i, j)
    for i in r:
        for j in t:
            assert lt(i.toFloat, j.toFloat) == (i < j)
            assert gt(i.toFloat, j.toFloat) == (i > j)
            assert eq(i.toFloat, j.toFloat) == (i == j)
            assert (not lt(i.toFloat, j.toFloat)) == (i >= j)
            assert (not gt(i.toFloat, j.toFloat)) == (i <= j)
            assert (not eq(i.toFloat, j.toFloat)) == (i != j)
            assert cmp(i.toFloat, j.toFloat) == cmp(i, j)
    for i in t:
        for j in r:
            assert lt(i.toFloat, j.toFloat) == (i < j)
            assert gt(i.toFloat, j.toFloat) == (i > j)
            assert eq(i.toFloat, j.toFloat) == (i == j)
            assert (not lt(i.toFloat, j.toFloat)) == (i >= j)
            assert (not gt(i.toFloat, j.toFloat)) == (i <= j)
            assert (not eq(i.toFloat, j.toFloat)) == (i != j)
            assert cmp(i.toFloat, j.toFloat) == cmp(i, j)
assert_cmp()

var st = initHashSet[Fraction[int]](0)
for _ in 0..1:
    for ri in r:
        st.incl(ri)
for ri in r:
    assert ri.inv == (1 / ri)
    assert ri.abs == (if ri < 0: -ri else: ri)
assert st.len == r.sorted.deduplicate(true).len
