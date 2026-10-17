# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/cumsum_nd
import cplib/utils/cumsum2d
import cplib/modint/modint

var seed = 646'u64
var queries = 0
proc randomInt(n: int): int =
    seed = seed * 6364136223846793005'u64 + 1442695040888963407'u64
    int((seed shr 32) mod uint64(n))

proc check[D: static[int]](shape: array[D, int], exhaustive: bool) =
    var n = 1
    for width in shape: n *= width
    var values = newSeq[int64](n)
    for value in values.mitems: value = int64(randomInt(41) - 20)
    let original = values
    let cs = initCumSumND[int64, D](shape, values)
    doAssert cs.shape == shape
    proc compare(lower, upper: array[D, int]) =
        var expected = 0'i64
        for index, value in original:
            var remainder = index
            var inside = true
            for axis in countdown(D - 1, 0):
                let coordinate = remainder mod shape[axis]
                remainder = remainder div shape[axis]
                if coordinate < lower[axis] or coordinate >= upper[axis]: inside = false
            if inside: expected += value
        doAssert cs.query(lower, upper) == expected
        inc queries
    var lower, upper: array[D, int]
    if exhaustive:
        proc enumerate(axis: int) =
            if axis == D:
                compare(lower, upper)
                return
            for l in 0..shape[axis]:
                for r in l..shape[axis]:
                    lower[axis] = l
                    upper[axis] = r
                    enumerate(axis + 1)
        enumerate(0)
    else:
        compare(lower, shape)
        for repeat in 0..<400:
            for axis in 0..<D:
                lower[axis] = randomInt(shape[axis] + 1)
                upper[axis] = randomInt(shape[axis] + 1)
                if lower[axis] > upper[axis]: swap(lower[axis], upper[axis])
            compare(lower, upper)
    if n > 0:
        values[0] = 999999
        var total = 0'i64
        for value in original: total += value
        doAssert cs.query(default(array[D, int]), shape) == total
    var reported = cs.shape
    reported[0] = -1
    doAssert cs.shape == shape

for n in 0..12: check([n], true)
for n in 0..4:
    for m in 0..4: check([n, m], true)
for n in 0..3:
    for m in 0..3:
        for k in 0..3: check([n, m, k], true)
check([2, 3, 1, 2], true)
check([1, 2, 1, 2, 1], true)
check([2, 2, 2, 2, 2, 2], true)
check([0, 2, 1, 3, 2, 1], true)
check([2, 1, 3, 0, 1, 2], true)
check([1, 2, 3, 1, 2, 0], true)
check([2, 1, 2, 1, 2, 1, 2, 1], true)
for repeat in 0..<30:
    check([randomInt(5), randomInt(5), randomInt(5), randomInt(5)], false)
    check([randomInt(4), randomInt(4), randomInt(4), randomInt(4), randomInt(4), randomInt(4)], false)
check([100000], false)
check([5, 6, 3, 4, 2, 7], false)

block:
    let matrix = @[@[1, -2, 3], @[4, 5, -6]]
    let old = toCumSum2D(matrix)
    let cs = initCumSumND([2, 3], [1, -2, 3, 4, 5, -6])
    for il in 0..2:
        for ir in il..2:
            for jl in 0..3:
                for jr in jl..3:
                    doAssert cs.query([il, jl], [ir, jr]) == old.query(il, ir, jl, jr)

template rejects(body: untyped) =
    block:
        var rejected = false
        try: body
        except ValueError: rejected = true
        doAssert rejected

rejects: discard initCumSumND([-1, 2], newSeq[int](0))
rejects: discard initCumSumND([high(int)], newSeq[int](0))
rejects: discard initCumSumND([high(int) div 2, 2], newSeq[int](0))
rejects: discard initCumSumND([high(int) div 2], newSeq[int64](0))
rejects: discard initCumSumND([0, high(int)], newSeq[int](0))
rejects: discard initCumSumND([2, 3], [1, 2])
rejects: discard initCumSumND([0], [1])
rejects: discard default(CumSumND[int, 2]).query([0, 0], [0, 0])
let cs = initCumSumND([2, 2], [1, 2, 3, 4])
rejects: discard cs.query([-1, 0], [1, 1])
rejects: discard cs.query([2, 0], [1, 1])
rejects: discard cs.query([0, 0], [3, 1])
rejects: discard cs.query([0, 0], [0, 3])
rejects: discard cs.query([0, 0], [0, -1])
let empty = initCumSumND([0, 3], newSeq[int](0))
doAssert empty.query([0, 0], [0, 3]) == 0
rejects: discard empty.query([0, 0], [0, 4])

block:
    let nearMax = initCumSumND([2], [high(int64) - 10, 3'i64])
    doAssert nearMax.query([0], [2]) == high(int64) - 7
    doAssert nearMax.query([1], [2]) == 3
    let nearMin = initCumSumND([2], [low(int64) + 10, -3'i64])
    doAssert nearMin.query([0], [2]) == low(int64) + 7
    doAssert nearMin.query([1], [2]) == -3
    let floats = initCumSumND([2, 2], [0.25, -0.5, 1.0, 2.0])
    doAssert floats.query([0, 0], [2, 2]) == 2.75
    let bytes = initCumSumND([2, 2], [1'i8, -2, 3, 4])
    doAssert bytes.query([0, 0], [2, 2]) == 6
    doAssert bytes.query([0, 1], [2, 2]) == 2

proc checkModInt[Mint]() =
    var data: array[24, Mint]
    for i in 0..<24: data[i] = Mint.init(i * i - 30)
    let modular = initCumSumND([2, 3, 4], data)
    for a in 0..2:
        for b in a..2:
            for c in 0..3:
                for d in c..3:
                    for e in 0..4:
                        for f in e..4:
                            var sum = 0
                            for i in a..<b:
                                for j in c..<d:
                                    for k in e..<f:
                                        let index = (i * 3 + j) * 4 + k
                                        sum += index * index - 30
                            doAssert modular.query([a, c, e], [b, d, f]).val == Mint.init(sum).val
checkModInt[modint998244353_montgomery]()
checkModInt[modint1000000007_barrett]()
modint_montgomery.setMod(101)
checkModInt[modint_montgomery]()
modint_barrett.setMod(97)
checkModInt[modint_barrett]()

type Pair = object
    a, b: int
proc `+`(x, y: Pair): Pair = Pair(a: x.a + y.a, b: x.b + y.b)
proc `-`(x, y: Pair): Pair = Pair(a: x.a - y.a, b: x.b - y.b)
let pairs = initCumSumND([2], [Pair(a: 2, b: 3), Pair(a: -1, b: 4)])
doAssert pairs.query([0], [2]) == Pair(a: 1, b: 7)

type Shifted = object
    stored: int
proc `+`(x, y: Shifted): Shifted = Shifted(stored: x.stored + y.stored - 7)
proc `-`(x, y: Shifted): Shifted = Shifted(stored: x.stored - y.stored + 7)
let shifted = initCumSumND([2, 2], [Shifted(stored: 8), Shifted(stored: 9), Shifted(stored: 10), Shifted(stored: 11)], Shifted(stored: 7))
doAssert shifted.query([0, 0], [2, 2]).stored == 17
doAssert shifted.query([1, 0], [2, 2]).stored == 14
doAssert shifted.query([0, 0], [0, 2]).stored == 7

type Counted = object
    value: int
var operations = 0
proc `+`(x, y: Counted): Counted =
    inc operations
    Counted(value: x.value + y.value)
proc `-`(x, y: Counted): Counted =
    inc operations
    Counted(value: x.value - y.value)
proc countOperations[D: static[int]](shape: array[D, int]) =
    var n = 1
    var p = 1
    for width in shape:
        n *= width
        p *= width + 1
    var data = newSeq[Counted](n)
    for value in data.mitems: value.value = 1
    operations = 0
    let sums = initCumSumND(shape, data)
    var expected = 0
    for width in shape: expected += p div (width + 1) * width
    doAssert operations == expected
    operations = 0
    doAssert sums.query(default(array[D, int]), shape).value == n
    doAssert operations == 1 shl D
    operations = 0
    doAssert sums.query(shape, shape).value == 0
    doAssert operations == 0
countOperations([100000])
countOperations([100, 100])
countOperations([2, 2, 2, 2, 2, 2])
countOperations([10, 10, 10, 10, 10, 10])
doAssert queries > 150000
echo "Hello World"
