# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/lazysegtree_template
import cplib/collections/lazysegtree_static_op
import cplib/modint/modint

proc coefficient[T](value: int64): T =
    when T is SomeNumber: T(value)
    else: T.init(value)

template checkAll(seg, values: untyped) =
    block:
        type T = typeof(seg[0].sum)
        doAssert seg.len == values.len
        for l in 0..values.len:
            var sum = 0'i64
            var indexSum = 0
            for r in l..values.len:
                if r > l:
                    sum += values[r - 1]
                    indexSum += r - 1
                let expected = (coefficient[T](sum), r - l, indexSum)
                doAssert seg.get(l, r) == expected
                doAssert seg[l..<r] == expected
                doAssert seg.get(l..<r) == expected
                if l == 0 and r == values.len:
                    doAssert seg.get_all() == expected
        for i, value in values:
            doAssert seg[i] == (coefficient[T](value), 1, i)
            doAssert seg[^(values.len - i)] == seg[i]

template addOracle(values, l, r, first, difference: untyped) =
    for i in l..<r:
        values[i] += int64(first) + int64(difference) * int64(i - l)

proc checkType[T]() =
    var rng = initRand(20261002)
    for n in [0, 1, 2, 3, 5, 8, 17, 31]:
        var values = newSeq[int64](n)
        var initial = newSeq[T](n)
        for i in 0..<n:
            values[i] = int64(rng.rand(-20..20))
            initial[i] = coefficient[T](values[i])
        var seg = initRangeArithmeticAddRangeSum(initial)
        let saved = initial
        checkAll(seg, values)
        for step in 0..<120:
            let l = rng.rand(n)
            let r = rng.rand(l..n)
            let first = rng.rand(-10..10)
            let difference = rng.rand(-5..5)
            let tag = arithmeticTag(l, coefficient[T](first), coefficient[T](difference))
            if step mod 2 == 0: seg.apply(l, r, tag)
            else: seg.apply(l..<r, tag)
            addOracle(values, l, r, first, difference)
            if n > 0 and step mod 11 == 0:
                let p = rng.rand(n - 1)
                values[p] = int64(rng.rand(-30..30))
                seg[p] = (coefficient[T](values[p]), 1, p)
                seg.apply(0, n, arithmeticTag(0, coefficient[T](3), coefficient[T](-2)))
                addOracle(values, 0, n, 3, -2)
            if step mod 7 == 6: checkAll(seg, values)
        checkAll(seg, values)
        doAssert initial == saved

    for n in 0..6:
        var values = newSeq[int64](n)
        for i in 0..<n: values[i] = int64(i - 2)
        var initial = newSeq[T](n)
        for i in 0..<n: initial[i] = coefficient[T](values[i])
        var seg = initRangeArithmeticAddRangeSum(initial)
        for l in 0..n:
            for r in l..n:
                for first in -1..1:
                    for difference in -1..1:
                        seg.apply(l, r, arithmeticTag(l, coefficient[T](first), coefficient[T](difference)))
                        addOracle(values, l, r, first, difference)
                        seg.apply(l, r, default(RangeArithmetic[T]))
                        checkAll(seg, values)

    block:
        var split = initRangeArithmeticAddRangeSum(newSeq[T](9))
        var composed = initRangeArithmeticAddRangeSum(newSeq[T](9))
        var reversed = initRangeArithmeticAddRangeSum(newSeq[T](9))
        let f = arithmeticTag(2, coefficient[T](7), coefficient[T](-3))
        let g = arithmeticTag(2, coefficient[T](-2), coefficient[T](4))
        split.apply(2, 9, f)
        split.apply(2, 9, g)
        reversed.apply(2, 9, g)
        reversed.apply(2, 9, f)
        composed.apply(2, 9, arithmeticTag(2, coefficient[T](5), coefficient[T](1)))
        var values = newSeq[int64](9)
        addOracle(values, 2, 9, 5, 1)
        doAssert split.get_all() == composed.get_all()
        doAssert split.get_all() == reversed.get_all()
        checkAll(split, values)
        checkAll(composed, values)
        checkAll(reversed, values)
        type ST = typeof(split)
        let empty: RangeArithmeticSum[T] = (default(T), 0, 0)
        doAssert ST.p[1](f, empty) == empty
        let left: RangeArithmeticSum[T] = (coefficient[T](11), 2, 5)
        let right: RangeArithmeticSum[T] = (coefficient[T](13), 3, 15)
        doAssert ST.p[1](f, ST.p[0](left, right)) == ST.p[0](ST.p[1](f, left), ST.p[1](f, right))
        doAssert ST.p[1](default(RangeArithmetic[T]), left) == left
        doAssert ST.p[0](empty, left) == left
        doAssert ST.p[0](left, empty) == left
        doAssert ST.p[1](ST.p[2](f, g), left) == ST.p[1](f, ST.p[1](g, left))
        doAssert ST.p[2](f, default(RangeArithmetic[T])) == f

checkType[int]()
checkType[int32]()
checkType[int64]()
checkType[float]()
checkType[modint998244353_barrett]()
checkType[modint998244353_montgomery]()
for modulus in [2, 6, 1000000000]:
    modint_barrett.setMod(modulus)
    checkType[modint_barrett]()
for modulus in [3, 9, 998244353]:
    modint_montgomery.setMod(modulus)
    checkType[modint_montgomery]()

block:
    let large = int64.high div 1024
    var values = @[large, -large, large, -large, large]
    var seg = initRangeArithmeticAddRangeSum(values)
    seg.apply(2, 5, arithmeticTag(2, large, -large))
    addOracle(values, 2, 5, large, -large)
    checkAll(seg, values)

block:
    var seg = initRangeArithmeticAddRangeSum(@[1, 2, 3, 4])
    seg.apply(1..<4, arithmeticTag(1, 10, 2))
    doAssert seg.get_all().sum == 46
    doAssert seg[2].sum == 15
    seg[^1] = (100, 1, 3)
    seg.apply(2..3, arithmeticTag(2, -4, -2))
    doAssert seg.get_all().sum == 118
    var fractional = initRangeArithmeticAddRangeSum(@[1.5, 2.5, 3.5])
    fractional.apply(1, 3, arithmeticTag(1, 0.5, 0.25))
    doAssert fractional.get_all().sum == 8.75

block:
    var rng = initRand(20261003)
    for n in [0, 1, 5, 16, 23]:
        var values = newSeq[int64](n)
        var seg = initRangeArithmeticAddRangeSum(newSeq[int64](n))
        for step in 0..<30:
            let l = rng.rand(n)
            let r = rng.rand(l..n)
            seg.apply(l, r, arithmeticTag(l, 2'i64, 1'i64))
            addOracle(values, l, r, 2, 1)
            for bound in [0'i64, 1, 7, 50, 10000]:
                let predicate = proc(x: RangeArithmeticSum[int64]): bool = x.sum <= bound
                for start in 0..n:
                    var stop = start
                    var sum = 0'i64
                    while stop < n and sum + values[stop] <= bound:
                        sum += values[stop]
                        inc stop
                    doAssert seg.max_right(start, predicate) == stop
                for stop in 0..n:
                    var start = stop
                    var sum = 0'i64
                    while start > 0 and sum + values[start - 1] <= bound:
                        dec start
                        sum += values[start]
                    doAssert seg.min_left(stop, predicate) == start

template checkExtrema(lo, hi, values: untyped) =
    block:
        for l in 0..values.len:
            var minIndex, maxIndex = -1
            for r in l..values.len:
                if r > l:
                    let i = r - 1
                    if minIndex < 0 or values[i] < values[minIndex]: minIndex = i
                    if maxIndex < 0 or values[maxIndex] < values[i]: maxIndex = i
                let minimum = lo.get(l, r)
                let maximum = hi[l..<r]
                doAssert minimum.index == minIndex
                doAssert maximum.index == maxIndex
                if l < r:
                    type T = typeof(minimum.value)
                    doAssert minimum == (coefficient[T](values[minIndex]), minIndex, l, r)
                    doAssert maximum == (coefficient[T](values[maxIndex]), maxIndex, l, r)
                else:
                    doAssert minimum.left == -1 and minimum.right == -1
                    doAssert maximum.left == -1 and maximum.right == -1
                if l == 0 and r == values.len:
                    doAssert lo.get_all() == minimum
                    doAssert hi.get_all() == maximum
        for i, value in values:
            doAssert lo[i].value == coefficient[typeof(lo[i].value)](value)
            doAssert hi[i].value == coefficient[typeof(hi[i].value)](value)

proc checkAssignment[T]() =
    var rng = initRand(20261004)
    for n in [0, 1, 2, 3, 5, 8, 17, 31]:
        var values = newSeq[int64](n)
        var initial = newSeq[T](n)
        for i in 0..<n:
            values[i] = int64(rng.rand(-20..20))
            initial[i] = coefficient[T](values[i])
        let saved = initial
        var sums = initRangeArithmeticAssignRangeSum(initial)
        when T is SomeNumber:
            var lo = initRangeArithmeticAssignRangeMin(initial)
            var hi = initRangeArithmeticAssignRangeMax(initial)
        template check() =
            checkAll(sums, values)
            when T is SomeNumber: checkExtrema(lo, hi, values)
        template assign(l, r, first, difference: untyped) =
            block:
                let initialValue = int64(first)
                let stepValue = int64(difference)
                let tag = arithmeticTag(l, coefficient[T](initialValue), coefficient[T](stepValue))
                sums.apply(l, r, tag)
                when T is SomeNumber:
                    lo.apply(l..<r, tag)
                    hi.apply(l, r, tag)
                for i in l..<r:
                    values[i] = initialValue + stepValue * int64(i - l)
        check()
        for step in 0..<120:
            let l = rng.rand(n)
            let r = rng.rand(l..n)
            assign(l, r, rng.rand(-10..10), rng.rand(-5..5))
            if n > 0 and step mod 11 == 0:
                let p = rng.rand(n - 1)
                values[p] = int64(rng.rand(-30..30))
                sums[p] = (coefficient[T](values[p]), 1, p)
                when T is SomeNumber:
                    lo[p] = (coefficient[T](values[p]), p, p, p + 1)
                    hi[^(n - p)] = (coefficient[T](values[p]), p, p, p + 1)
                assign(0, n, 3, -2)
            if step mod 7 == 6: check()
        check()
        assign(0, n, 12, -3)
        if n > 0:
            discard sums[n div 2]
            when T is SomeNumber:
                discard lo[n div 2]
                discard hi[n div 2]
        assign(0, n, 0, 0)
        check()
        assign(0, n, -7, 4)
        check()
        if n <= 8:
            for l in 0..n:
                for r in l..n:
                    for first in -1..1:
                        for difference in -1..1:
                            assign(l, r, first, difference)
                            check()
        doAssert initial == saved
        type ST = typeof(sums)
        let empty: RangeArithmeticSum[T] = (default(T), 0, 0)
        let node: RangeArithmeticSum[T] = (coefficient[T](11), 2, 5)
        let f = arithmeticTag(2, coefficient[T](7), coefficient[T](-3))
        let g = arithmeticTag(2, coefficient[T](-2), coefficient[T](4))
        let zero = arithmeticTag(0, coefficient[T](0), coefficient[T](0))
        doAssert ST.p[1](f, empty) == empty
        doAssert ST.p[2](f, g) == f
        doAssert ST.p[2](zero, g) == zero
        doAssert ST.p[1](ST.p[2](f, g), node) == ST.p[1](f, ST.p[1](g, node))
        when T is SomeNumber:
            type ET = typeof(lo)
            let emptyExtremum: RangeArithmeticExtremum[T] = (default(T), -1, -1, -1)
            doAssert ET.p[1](f, emptyExtremum) == emptyExtremum
            doAssert ET.p[2](zero, g) == zero

checkAssignment[int]()
checkAssignment[int32]()
checkAssignment[int64]()
checkAssignment[float]()
checkAssignment[modint998244353_barrett]()
checkAssignment[modint998244353_montgomery]()
for modulus in [2, 6, 1000000000]:
    modint_barrett.setMod(modulus)
    checkAssignment[modint_barrett]()
for modulus in [3, 9, 998244353]:
    modint_montgomery.setMod(modulus)
    checkAssignment[modint_montgomery]()

block:
    var fractional = initRangeArithmeticAssignRangeMin(@[1.5, 2.5, 3.5])
    fractional.apply(1, 3, arithmeticTag(1, 0.5, -0.25))
    doAssert fractional.get(1, 3) == (0.25, 2, 1, 3)
    let large = int64.high div 1024
    var sums = initRangeArithmeticAssignRangeSum(newSeq[int64](5))
    var lo = initRangeArithmeticAssignRangeMin(newSeq[int64](5))
    var hi = initRangeArithmeticAssignRangeMax(newSeq[int64](5))
    let tag = arithmeticTag(2, large, -large)
    sums.apply(2, 5, tag)
    lo.apply(2, 5, tag)
    hi.apply(2, 5, tag)
    let values = @[0'i64, 0, large, 0, -large]
    checkAll(sums, values)
    checkExtrema(lo, hi, values)

block:
    var rng = initRand(20261005)
    for n in [0, 1, 5, 16, 23]:
        var values = newSeq[int64](n)
        var sums = initRangeArithmeticAssignRangeSum(newSeq[int64](n))
        var lo = initRangeArithmeticAssignRangeMin(newSeq[int64](n))
        var hi = initRangeArithmeticAssignRangeMax(newSeq[int64](n))
        for step in 0..<30:
            let l = rng.rand(n)
            let r = rng.rand(l..n)
            let tag = arithmeticTag(l, 2'i64, 1'i64)
            sums.apply(l, r, tag)
            lo.apply(l, r, tag)
            hi.apply(l, r, tag)
            for i in l..<r: values[i] = 2 + int64(i - l)
            for bound in [0'i64, 1, 7, 50, 10000]:
                let sumPredicate = proc(x: RangeArithmeticSum[int64]): bool = x.sum <= bound
                let minPredicate = proc(x: RangeArithmeticExtremum[int64]): bool = x.index < 0 or x.value >= bound
                let maxPredicate = proc(x: RangeArithmeticExtremum[int64]): bool = x.index < 0 or x.value <= bound
                for start in 0..n:
                    var stop = start
                    var sum = 0'i64
                    while stop < n and sum + values[stop] <= bound:
                        sum += values[stop]
                        inc stop
                    doAssert sums.max_right(start, sumPredicate) == stop
                    stop = start
                    while stop < n and values[stop] >= bound: inc stop
                    doAssert lo.max_right(start, minPredicate) == stop
                    stop = start
                    while stop < n and values[stop] <= bound: inc stop
                    doAssert hi.max_right(start, maxPredicate) == stop
                for stop in 0..n:
                    var start = stop
                    var sum = 0'i64
                    while start > 0 and sum + values[start - 1] <= bound:
                        dec start
                        sum += values[start]
                    doAssert sums.min_left(stop, sumPredicate) == start
                    start = stop
                    while start > 0 and values[start - 1] >= bound: dec start
                    doAssert lo.min_left(stop, minPredicate) == start
                    start = stop
                    while start > 0 and values[start - 1] <= bound: dec start
                    doAssert hi.min_left(stop, maxPredicate) == start

block:
    var seg = initRangeArithmeticAddRangeSum(@[1, 2, 3])
    var rejected = 0
    for bounds in [(-1, 2), (0, 4), (2, 1)]:
        try:
            seg.apply(bounds[0], bounds[1], arithmeticTag(0, 0, 0))
        except AssertionDefect:
            inc rejected
    doAssert rejected == 3
    doAssert seg.get_all().sum == 6

echo "Hello World"
