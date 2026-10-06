# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import options, random, algorithm, strutils
import cplib/geometry/base
import cplib/geometry/exact_circle
import cplib/geometry/minimum_enclosing_circle_exact
import cplib/math/bigint
import cplib/math/int128
import cplib/math/fractions

proc bi(x: int): BigInt = initBigInt(x)
proc rat(n, d: int): ExactCircleFraction = initFraction(bi(n), bi(d))
proc check[T](input: seq[Point[T]], expected: ExactCircleFraction) =
    var original: seq[Point[ExactCircleFraction]]
    for p in input: original.add(toExactPoint(p))
    var reversed = input
    reversed.reverse()
    var first = none(MinimumExactCircle)
    for seed in [0'i64, 1, -1, 63355030]:
        for points in [input, reversed]:
            let circle = minimum_enclosing_circle_exact(points, seed)
            doAssert circle.radius_squared_exact == expected
            for p in input: doAssert circle.contains(p)
            if first.isSome: doAssert first.get == circle
            else: first = some(circle)
    for i, p in input: doAssert toExactPoint(p) == original[i]
    doAssert minimum_enclosing_circle_exact(input, 42).points == minimum_enclosing_circle_exact(input, 42).points

proc checkType[T](zero, one, two, four: T) =
    var rejected = false
    try: discard minimum_enclosing_circle_exact(newSeq[Point[T]]())
    except ValueError: rejected = true
    doAssert rejected
    check(@[initPoint(zero, zero)], rat(0, 1))
    check(@[initPoint(zero, zero), initPoint(one, zero)], rat(1, 4))
    check(@[initPoint(zero, zero), initPoint(four, zero), initPoint(one, zero), initPoint(two, zero)], rat(4, 1))
    check(@[initPoint(zero, zero), initPoint(two, zero), initPoint(zero, two)], rat(2, 1))
    check(@[initPoint(zero, zero), initPoint(four, zero), initPoint(two, four)], rat(25, 4))
    check(@[initPoint(zero, zero), initPoint(four, zero), initPoint(one, one)], rat(4, 1))
    var duplicates: seq[Point[T]]
    for _ in 0..<100: duplicates.add(initPoint(one, one))
    check(duplicates, rat(0, 1))

checkType(0, 1, 2, 4)
checkType(0'u64, 1'u64, 2'u64, 4'u64)
checkType(bi(0), bi(1), bi(2), bi(4))
checkType(parseInt128("0"), parseInt128("1"), parseInt128("2"), parseInt128("4"))
checkType(initFraction(0), initFraction(1), initFraction(2), initFraction(4))
checkType(initFraction(parseInt128("0")), initFraction(parseInt128("1")), initFraction(parseInt128("2")), initFraction(parseInt128("4")))
checkType(rat(0, 1), rat(1, 1), rat(2, 1), rat(4, 1))

let half = minimum_enclosing_circle_exact(@[initPoint(0, 0), initPoint(1, 0)])
static: doAssert typeof(half) is ExactCircle[Fraction[BigInt]]
doAssert half.center_exact == initPoint(rat(1, 2), rat(0, 1))
for p in half.points: doAssert half.on_circle(p)
let span = initBigInt(high(int64)) - initBigInt(low(int64))
check(@[initPoint(low(int64), 0'i64), initPoint(high(int64), 0'i64)], initFraction(span * span, bi(4)))
let min128 = parseInt128("-170141183460469231731687303715884105728")
let max128 = parseInt128("170141183460469231731687303715884105727")
let span128 = parseBigInt($max128) - parseBigInt($min128)
check(@[initPoint(min128, min128), initPoint(max128, min128)], initFraction(span128 * span128, bi(4)))
let giant = parseBigInt("1" & repeat('0', 1000))
check(@[initPoint(giant, giant), initPoint(giant + bi(1), giant)], rat(1, 4))
let tiny = initFraction(bi(1), giant)
check(@[initPoint(rat(0, 1), rat(0, 1)), initPoint(tiny, rat(0, 1))], tiny * tiny / bi(4))
let denominator = parseInt128("170141183460469231731687303715884105727")
let zero128 = Fraction[Int128](num: parseInt128("0"), den: denominator)
let tiny128 = Fraction[Int128](num: parseInt128("1"), den: denominator)
let width = initFraction(bi(1), parseBigInt($denominator))
check(@[initPoint(zero128, zero128), initPoint(tiny128, zero128)], width * width / bi(4))
let raw = Fraction[int](num: low(int), den: low(int))
check(@[initPoint(raw, raw), initPoint(initFraction(2), raw)], rat(1, 4))
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
for i in 0..<10000: large.add(initPoint(i mod 101, (i * 17) mod 101))
let circle = minimum_enclosing_circle_exact(large)
for p in large: doAssert circle.contains(p)
echo "Hello World"
