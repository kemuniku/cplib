# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import options, random, algorithm, strutils
import cplib/geometry/base
import cplib/geometry/exact_circle
import cplib/geometry/minimum_enclosing_circle_exact
import cplib/math/bigint
import cplib/math/int128
import cplib/math/fractions

proc bi(x: int): BigInt = initBigInt(x)
proc rat(n, d: int): Fraction[BigInt] = initFraction(bi(n), bi(d))
proc check[T](input: seq[Point[T]], expected: string) =
    var original: seq[Point[T]]
    for p in input: original.add(p)
    var reversed = input
    reversed.reverse()
    var first = none(ExactCircle[T])
    for seed in [0'i64, 1, -1, 63355030]:
        for points in [input, reversed]:
            let circle = minimum_enclosing_circle_exact(points, seed)
            doAssert $circle.radius_squared_exact == expected
            static: doAssert typeof(circle) is ExactCircle[T]
            for p in circle.points_exact: doAssert circle.on_circle(p)
            for p in input: doAssert circle.contains(p)
            if first.isSome: doAssert first.get == circle
            else: first = some(circle)
    for i, p in input: doAssert p == original[i]
    doAssert minimum_enclosing_circle_exact(input, 42).points == minimum_enclosing_circle_exact(input, 42).points

proc checkType[T](zero, one, two, four: T) =
    var rejected = false
    try: discard minimum_enclosing_circle_exact(newSeq[Point[T]]())
    except ValueError: rejected = true
    doAssert rejected
    check(@[initPoint(zero, zero)], "0/1")
    check(@[initPoint(zero, zero), initPoint(one, zero)], "1/4")
    check(@[initPoint(zero, zero), initPoint(four, zero), initPoint(one, zero), initPoint(two, zero)], "4/1")
    check(@[initPoint(zero, zero), initPoint(two, zero), initPoint(zero, two)], "2/1")
    check(@[initPoint(zero, zero), initPoint(four, zero), initPoint(two, four)], "25/4")
    check(@[initPoint(zero, zero), initPoint(four, zero), initPoint(one, one)], "4/1")
    var duplicates: seq[Point[T]]
    for _ in 0..<100: duplicates.add(initPoint(one, one))
    check(duplicates, "0/1")

checkType(0, 1, 2, 4)
checkType(bi(0), bi(1), bi(2), bi(4))
checkType(parseInt128("0"), parseInt128("1"), parseInt128("2"), parseInt128("4"))
checkType(initFraction(0), initFraction(1), initFraction(2), initFraction(4))
checkType(initFraction(parseInt128("0")), initFraction(parseInt128("1")), initFraction(parseInt128("2")), initFraction(parseInt128("4")))
checkType(rat(0, 1), rat(1, 1), rat(2, 1), rat(4, 1))

let half = minimum_enclosing_circle_exact(@[initPoint(0, 0), initPoint(1, 0)])
static:
    doAssert typeof(half) is ExactCircle[int]
    doAssert typeof(half.center_exact) is Point[Fraction[int]]
    doAssert typeof(half.radius_squared_exact) is Fraction[int]
doAssert half.center_exact == initPoint(initFraction(1, 2), initFraction(0))
doAssert half.point_scale == 2
for p in half.points_exact: doAssert half.on_circle(p)
check(@[initPoint(1000000, 1000000), initPoint(1000001, 1000000)], "1/4")
let wide = parseInt128("1000000000000000000000000000000")
check(@[initPoint(wide, wide), initPoint(wide + parseInt128("1"), wide)], "1/4")
let giant = parseBigInt("1" & repeat('0', 1000))
check(@[initPoint(giant, giant), initPoint(giant + bi(1), giant)], "1/4")
let tiny = initFraction(bi(1), giant)
check(@[initPoint(rat(0, 1), rat(0, 1)), initPoint(tiny, rat(0, 1))], $(tiny * tiny / bi(4)))
let zero128 = initFraction(parseInt128("0"))
let tiny128 = initFraction(parseInt128("1"), parseInt128("1000000"))
check(@[initPoint(zero128, zero128), initPoint(tiny128, zero128)], "1/4000000000000")
let raw = Fraction[int](num: -6, den: -6)
check(@[initPoint(raw, raw), initPoint(initFraction(2), raw)], "1/4")
var rejected = false
try: discard minimum_enclosing_circle_exact(@[initPoint(Fraction[int](num: 1, den: 0), initFraction(0))])
except ValueError: rejected = true
doAssert rejected
randomize(422)
let before = rand(high(int))
discard minimum_enclosing_circle_exact(@[initPoint(0, 0), initPoint(1, 0)], 7)
let after = rand(high(int))
randomize(422)
doAssert before == rand(high(int)) and after == rand(high(int))
var large: seq[Point[int]]
for i in 0..<10000: large.add(initPoint(i mod 3, (i * 17) mod 3))
let circle = minimum_enclosing_circle_exact(large)
for p in large: doAssert circle.contains(p)
echo "Hello World"
