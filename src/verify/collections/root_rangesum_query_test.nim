# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/root_rangesum_query
import cplib/modint/modint

proc check(rs: RootRangeSumQuery[int64], values: seq[int64]) =
    doAssert rs.len == values.len
    var total = 0'i64
    for r in 0..values.len:
        doAssert rs.prefix(r) == total
        if r < values.len:
            doAssert rs[r] == values[r]
            doAssert rs[^(values.len - r)] == values[r]
            total += values[r]
    for l in 0..values.len:
        var expected = 0'i64
        for r in l..values.len:
            doAssert rs.get(l, r) == expected
            doAssert rs[l..<r] == expected
            doAssert rs.get(l..r-1) == expected
            if r < values.len: expected += values[r]

var rng = initRand(342)
for n in [0, 1, 2, 3, 4, 5, 8, 9, 10, 15, 16, 17, 24, 25, 26, 63, 64, 65]:
    for width in [0, 1, 2, 3, 7, 8, 16, n + 1, high(int)]:
        var values = newSeq[int64](n)
        for i in 0..<n: values[i] = int64(rng.rand(-100..100))
        let rs = initRootRangeSumQuery(values, width)
        check(rs, values)
        for step in 0..<(n + 16):
            if n == 0: break
            let index = if step < n: step else: rng.rand(n - 1)
            let value = int64(rng.rand(-100..100))
            case step mod 3
            of 0: rs.update(index, value)
            of 1: rs[index] = value
            else: rs[^(n - index)] = value
            values[index] = value
            check(rs, values)

block:
    let rs = initRootRangeSumQuery([4'i64, -7, 3], 2)
    rs.update(1, -7)
    check(rs, @[4'i64, -7, 3])
    rs[1] = rs[1] + 9
    check(rs, @[4'i64, 2, 3])
    rs[^1] = 0
    check(rs, @[4'i64, 2, 0])

block:
    var input = @[1'i64, -2, 3, 4, -5]
    let rs = initRootRangeSumQuery(input.toOpenArray(1, 3), 2)
    input[1] = 99
    check(rs, @[-2'i64, 3, 4])
    rs[0] = 10
    doAssert input == @[1'i64, 99, 3, 4, -5]
    let fromArray = initRootRangeSumQuery([3'i64, -3, 7], 1)
    check(fromArray, @[3'i64, -3, 7])

block:
    let rs = initRootRangeSumQuery([high(int64) - 2, 1'i64, 1], 2)
    doAssert rs.prefix(3) == high(int64)
    rs.update(0, high(int64) - 3)
    doAssert rs.get(0, 3) == high(int64) - 1
    let negative = initRootRangeSumQuery([low(int64) + 2, -1'i64, -1], 2)
    doAssert negative.prefix(3) == low(int64)
    negative[2] = 0
    doAssert negative.get(0, 3) == low(int64) + 1

type Pair = object
    x, y: int64
proc `+`(a, b: Pair): Pair = Pair(x: a.x + b.x, y: a.y + b.y)
proc `-`(a, b: Pair): Pair = Pair(x: a.x - b.x, y: a.y - b.y)
block:
    let rs = initRootRangeSumQuery([Pair(x: 1, y: 2), Pair(x: -3, y: 5)], 1,
            Pair())
    doAssert rs.prefix(2) == Pair(x: -2, y: 7)
    rs[1] = Pair(x: 4, y: -6)
    doAssert rs.get(0, 2) == Pair(x: 5, y: -4)
    doAssert rs.get(1, 1) == Pair()

block:
    type Mint = modint998244353_montgomery
    let rs = initRootRangeSumQuery([Mint.init(-1), Mint.init(2), Mint.init(
            998244352)], 2, Mint.init(0))
    doAssert rs.prefix(3).val == 0
    rs[1] = Mint.init(-3)
    doAssert rs.get(0, 3).val == 998244348
    doAssert rs.get(1, 1).val == 0

type Counted = distinct int64
var operations = 0
proc `+`(a, b: Counted): Counted =
    inc operations
    Counted(int64(a) + int64(b))
proc `-`(a, b: Counted): Counted =
    inc operations
    Counted(int64(a) - int64(b))

for n in [1, 17, 1024, 100000]:
    for width in [1, 7, 0, n, high(int)]:
        let rs = initRootRangeSumQuery(newSeq[Counted](n), width, Counted(0))
        for r in [0, 1, n div 2, n]:
            operations = 0
            doAssert int64(rs.prefix(r)) == 0
            doAssert operations <= 1
            operations = 0
            doAssert int64(rs.get(0, r)) == 0
            doAssert operations <= 3
        operations = 0
        doAssert int64(rs[n - 1]) == 0
        doAssert operations == 1
        operations = 0
        rs[0] = Counted(1)
        let b = if width == 0:
                    var root = 1
                    while (root + 1) * (root + 1) <= n: inc root
                    root
                else: min(width, n)
        doAssert operations <= 2 + b + (n - 1) div b + 1
        doAssert int64(rs.prefix(n)) == 1

when compileOption("assertions"):
    template invalid(body: untyped) =
        block:
            var rejected = false
            try: body
            except AssertionDefect: rejected = true
            doAssert rejected
    invalid:
        discard initRootRangeSumQuery([1], -1)
    let rs = initRootRangeSumQuery([1, 2])
    invalid:
        discard rs.prefix(3)
    invalid:
        discard rs.get(2, 1)
    invalid:
        discard rs.get(0, 3)
    invalid:
        discard rs[-1..1]
    invalid:
        discard rs[0..2]
    invalid:
        discard rs[2..0]
    invalid:
        discard rs[2]
    invalid:
        rs.update(2, 0)
    invalid:
        rs[2] = 0

echo "Hello World"
