# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

include cplib/math/generalized_floor_sum
import cplib/modint/modint
import random

proc naive[T](n, m, a, b, p, q: int): seq[seq[T]] =
    result = newSeq[seq[T]](p + 1)
    for j in 0..p:
        result[j] = newSeq[T](q + 1)
    for i in 0..<n:
        let xi: T = i
        let yi: T = (a * i + b) div m
        var xp: T = 1
        for j in 0..p:
            var yp: T = 1
            for k in 0..q:
                result[j][k] = result[j][k] + xp * yp
                yp = yp * yi
            xp = xp * xi

for n in 0..6:
    for m in 1..6:
        for a in 0..6:
            for b in 0..6:
                doAssert generalizedFloorSumTable[int](n, m, a, b, 3, 3) ==
                    naive[int](n, m, a, b, 3, 3)

proc values[T](table: seq[seq[T]]): seq[seq[int]] =
    result = newSeq[seq[int]](table.len)
    for j in 0..<table.len:
        for value in table[j]:
            result[j].add(value.val)

proc check[T]() =
    var rng = initRand(20260912)
    for test in 0..<150:
        let
            n = rng.rand(30)
            m = rng.rand(1..100)
            a = rng.rand(100)
            b = rng.rand(100)
            p = rng.rand(5)
            q = rng.rand(5)
        let expected = naive[T](n, m, a, b, p, q)
        doAssert generalizedFloorSumTable[T](n, m, a, b, p, q).values == expected.values
        doAssert generalizedFloorSum[T](n, m, a, b, p, q).val == expected[p][q].val

    let n = 1_000_000_000
    let nn: T = n
    let triangle: T = n * (n - 1) div 2
    doAssert generalizedFloorSum[T](n, 1, 1, 0, 0, 0).val == nn.val
    doAssert generalizedFloorSum[T](n, 1, 1, 0, 1, 0).val == triangle.val
    doAssert generalizedFloorSum[T](n, 1, 1, 0, 0, 1).val == triangle.val
    doAssert generalizedFloorSum[T](n, 1, 1, 0, 1, 2).val == (triangle * triangle).val
    doAssert generalizedFloorSum[T](n, n, n - 1, 0, 0, 1).val == (triangle - (nn - 1)).val
    doAssert generalizedFloorSumTable[T](0, 1, high(int), high(int), 2, 3).values ==
        naive[T](0, 1, high(int), high(int), 2, 3).values
    doAssert generalizedFloorSumTable[T](2, high(int) - 1, high(int) div 2, 1, 2, 3).values ==
        naive[T](2, high(int) - 1, high(int) div 2, 1, 2, 3).values

check[modint998244353_montgomery]()
check[modint1000000007_barrett]()
modint_barrett.setMod(12)
check[modint_barrett]()
modint_barrett.setMod(2)
check[modint_barrett]()

doAssert generalizedFloorSum[int](4, 3, 2, 1, 1, 2) == 15
echo "Hello World"
