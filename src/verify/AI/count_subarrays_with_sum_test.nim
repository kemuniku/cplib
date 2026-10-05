# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/count_subarrays_with_sum
import cplib/math/int128
import random

proc oracle[T: SomeInteger](a: openArray[T], x: T): int64 =
    let target = to_Int128(x)
    for l in 0..<a.len:
        var total = to_Int128(0)
        for r in l..<a.len:
            total += to_Int128(a[r])
            if total == target: inc result

proc check[T: SomeInteger](a: openArray[T], x: T) =
    doAssert count_subarrays_with_sum(a, x) == oracle(a, x)

proc checkType[T: SomeInteger]() =
    static: doAssert count_subarrays_with_sum(newSeq[T](), T(0)) is int64
    check(newSeq[T](), T(0))
    check(newSeq[T](), high(T))
    check([T(0)], T(0))
    check([T(0)], T(1))
    check([T(7)], T(7))
    check([T(7)], T(6))
    check([T(0), T(0), T(0), T(0)], T(0))
    check([T(0), T(1), T(0), T(1), T(0)], T(1))
    check([high(T), T(0)], high(T))
    when T is SomeSignedInt:
        check([low(T), T(0)], low(T))
        check([high(T), low(T), T(1), T(0)], T(0))
        check([T(1), T(-1), T(1), T(-1), T(0)], T(0))
        check([T(-3), T(2), T(-1), T(0), T(4)], T(-2))
    when sizeof(T) < 8:
        check([high(T), high(T), T(0)], high(T))
        when T is SomeSignedInt:
            check([low(T), low(T), high(T)], low(T))

checkType[int]()
checkType[int8]()
checkType[int16]()
checkType[int32]()
checkType[int64]()
checkType[uint]()
checkType[uint8]()
checkType[uint16]()
checkType[uint32]()
checkType[uint64]()

for n in 0..7:
    var combinations = 1
    for i in 0..<n: combinations *= 3
    for mask in 0..<combinations:
        var code = mask
        var a = newSeq[int](n)
        for i in 0..<n:
            a[i] = code mod 3 - 1
            code = code div 3
        for x in -n-1..n+1: check(a, x)

var rng = initRand(233023)
for trial in 0..<1000:
    var a = newSeq[int64](rng.rand(0..35))
    var b = newSeq[uint64](a.len)
    for i in 0..<a.len:
        a[i] = int64(rng.rand(-10..10))
        b[i] = uint64(rng.rand(0..10))
    check(a, int64(rng.rand(-30..30)))
    check(b, uint64(rng.rand(0..30)))

let lo = low(int64)
let hi = high(int64)
for a in [@[lo, 0'i64, hi, 1], @[hi, -hi, -1, 1], @[0'i64, -1, 1, lo],
        @[1'i64, -1, hi, -hi], @[lo, hi, lo + 1, hi]]:
    for x in [lo, lo + 1, -1'i64, 0, 1, hi - 1, hi]: check(a, x)
let uhi = high(uint64)
for a in [@[0'u64, uhi, 0], @[1'u64, uhi - 1, 0], @[uhi - 1, 0'u64, 1]]:
    for x in [0'u64, 1, uhi - 1, uhi]: check(a, x)

template expectOverflow(body: untyped) =
    block:
        var caught = false
        try: body
        except OverflowDefect: caught = true
        doAssert caught

proc checkContract[T: SomeInteger](a: openArray[T], x: T) =
    var prefix = to_Int128(0)
    var outside = false
    when T is SomeSignedInt:
        let minimum = to_Int128(low(int64))
        let maximum = to_Int128(high(int64))
    else:
        let minimum = to_Int128(0)
        let maximum = to_Int128(high(uint64))
    for value in a:
        prefix += to_Int128(value)
        if prefix < minimum or prefix > maximum: outside = true
    if outside:
        expectOverflow: discard count_subarrays_with_sum(a, x)
    else:
        check(a, x)

proc checkBoundaries[T: SomeInteger](values: openArray[T]) =
    for n in 0..4:
        var combinations = 1
        for i in 0..<n: combinations *= values.len
        for mask in 0..<combinations:
            var code = mask
            var a = newSeq[T](n)
            for i in 0..<n:
                a[i] = values[code mod values.len]
                code = code div values.len
            for x in values: checkContract(a, x)

checkBoundaries([lo, lo + 1, -1'i64, 0, 1, hi - 1, hi])
checkBoundaries([0'u64, 1, uhi - 1, uhi])

expectOverflow: discard count_subarrays_with_sum([hi, 1'i64], 0'i64)
expectOverflow: discard count_subarrays_with_sum([lo, -1'i64], 0'i64)
expectOverflow: discard count_subarrays_with_sum([hi, hi], hi)
expectOverflow: discard count_subarrays_with_sum([lo, lo], lo)
expectOverflow: discard count_subarrays_with_sum([uhi, 1'u64], 0'u64)
expectOverflow: discard count_subarrays_with_sum([uhi, uhi], uhi)

let zeros = newSeq[int8](100000)
doAssert count_subarrays_with_sum(zeros, 0'i8) == 5000050000'i64
doAssert count_subarrays_with_sum(zeros, 1'i8) == 0
echo "Hello World"
