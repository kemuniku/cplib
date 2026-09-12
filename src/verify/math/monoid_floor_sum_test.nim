# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import cplib/math/monoid_floor_sum
import random, strutils

proc concat(l, r: string): string = l & r

for n in 0..12:
    for m in 1..12:
        for a in 0..12:
            for b in 0..12:
                var expected = repeat("y", b div m)
                for i in 1..n:
                    expected.add("x")
                    expected.add(repeat("y", (a * i + b) div m - (a * (i - 1) + b) div m))
                doAssert monoidFloorSum(n, m, a, b, "x", "y", concat, "") == expected

type FloorSum = tuple[width, height, sum: int]

proc combine(l, r: FloorSum): FloorSum =
    (l.width + r.width, l.height + r.height, l.sum + r.sum + l.height * r.width)

let
    x: FloorSum = (1, 0, 0)
    y: FloorSum = (0, 1, 0)
    e: FloorSum = (0, 0, 0)
var rng = initRand(20260912)
for test in 0..<2000:
    let
        n = rng.rand(100)
        m = rng.rand(1..1000)
        a = rng.rand(1000)
        b = rng.rand(1000)
    var expected = 0
    for i in 0..<n:
        expected += (a * i + b) div m
    let actual = monoidFloorSum(n, m, a, b, x, y, combine, e)
    doAssert actual == (n, (a * n + b) div m, expected)

let large = 1_000_000_000
doAssert monoidFloorSum(large, 1, 1, 0, x, y, combine, e) ==
    (large, large, large * (large - 1) div 2)
doAssert monoidFloorSum(large, large, large - 1, 0, x, y, combine, e) ==
    (large, large - 1, (large - 1) * (large - 2) div 2)
doAssert monoidFloorSum(0, 1, high(int), high(int), x, y, combine, e) ==
    (0, high(int), 0)
doAssert monoidFloorSum(1, high(int), high(int), 0, x, y, combine, e) == (1, 1, 0)
doAssert monoidFloorSum(2, high(int) - 1, high(int) div 2, 1, x, y, combine, e) == (2, 1, 0)

echo "Hello World"
