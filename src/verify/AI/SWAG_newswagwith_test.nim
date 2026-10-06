# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/SWAG
import cplib/collections/segtree

type Affine = tuple[a, b: int]
const modulus = 998244353

func compose(l, r: Affine): Affine =
    ((l.a * r.a) mod modulus, (l.b * r.a + r.b) mod modulus)

proc check[T](swag: SWAG[T], values: seq[T],
              merge: proc(l, r: T): T, unit: T) =
    var expected = unit
    for value in values:
        expected = merge(expected, value)
    doAssert swag.len == values.len
    doAssert swag.fold() == expected
    doAssert $swag == "swag" & $values
    for i, value in values:
        doAssert swag[i] == value
        doAssert swag[^(values.len - i)] == value

proc exercise[T](swag: SWAG[T], merge: proc(l, r: T): T,
                 unit: T, samples: seq[T]) =
    var values: seq[T] = @[]
    swag.check(values, merge, unit)
    for fromFront in [false, true]:
        for value in samples:
            if fromFront:
                swag.addFirst(value)
                values.insert(value, 0)
            else:
                swag.addLast(value)
                values.add(value)
            swag.check(values, merge, unit)
        while values.len > 0:
            if fromFront:
                doAssert swag.popLast() == values.pop()
            else:
                doAssert swag.popFirst() == values[0]
                values.delete(0)
            swag.check(values, merge, unit)
    var rng = initRand(20261005)
    for _ in 0..<2000:
        let action = rng.rand(3)
        let value = samples[rng.rand(samples.high)]
        if values.len == 0 or action == 0:
            swag.addFirst(value)
            values.insert(value, 0)
        elif action == 1:
            swag.addLast(value)
            values.add(value)
        elif action == 2:
            doAssert swag.popFirst() == values[0]
            values.delete(0)
        else:
            doAssert swag.popLast() == values.pop()
        swag.check(values, merge, unit)
    while values.len > 0:
        doAssert swag.popLast() == values.pop()
        swag.check(values, merge, unit)
    for fromFront in [false, true]:
        var raised = false
        try:
            if fromFront: discard swag.popFirst()
            else: discard swag.popLast()
        except IndexDefect:
            raised = true
        doAssert raised
        swag.check(values, merge, unit)
    swag.addLast(samples[0])
    doAssert swag.popFirst() == samples[0]
    swag.check(@[], merge, unit)

let sum = proc(l, r: int): int = l + r
let minimum = proc(l, r: int): int = min(l, r)
let affine = proc(l, r: Affine): Affine = compose(l, r)
let numbers = @[3, 1, 4, 1, 5, 9, 2, 6]
let functions: seq[Affine] = @[(2, 3), (5, 7), (0, 9), (11, 13), (17, 19)]
let identity: Affine = (1, 0)

let sumSwag: SWAG[int] = newSwagWith(l + r, 0)
let minSwag = newswagwith(min(l, r), int.high)
let affineSwag = newSwagWith(compose(l, r), identity)
sumSwag.exercise(sum, 0, numbers)
minSwag.exercise(minimum, int.high, numbers)
affineSwag.exercise(affine, identity, functions)
initSWAG(sum, 0).exercise(sum, 0, numbers)
initSWAG(minimum, int.high).exercise(minimum, int.high, numbers)
initSWAG(affine, identity).exercise(affine, identity, functions)

block:
    let l = 100
    let r = 200
    let merge = 300
    let default = 400
    let first = newSwagWith(l + r, 0'i64)
    let second = newSwagWith(min(l, r), high(int64))
    let tree = newsegwith(@[2'i64, 3'i64], l + r, 0'i64)
    first.addLast(2'i64)
    first.addLast(3'i64)
    second.addLast(7'i64)
    second.addLast(4'i64)
    doAssert first.fold() == tree.get_all()
    doAssert second.fold() == 4'i64
    doAssert (l, r, merge, default) == (100, 200, 300, 400)

block:
    var unitCalls = 0
    proc unit(): int =
        inc unitCalls
        0
    let swag = newSwagWith(l + r, unit())
    doAssert unitCalls == 1
    doAssert swag.fold() == 0
    swag.addLast(10)
    doAssert swag.fold() == 10
    doAssert unitCalls == 1

proc genericSum[T](unit: T): SWAG[T] =
    newSwagWith(l + r, unit)

block:
    let integers = genericSum(0'i32)
    let reals = genericSum(0.0)
    let strings = newSwagWith(l & r, "")
    integers.addLast(12'i32)
    integers.addFirst(30'i32)
    doAssert integers.fold() == 42'i32
    reals.addLast(1.5)
    reals.addFirst(2.5)
    doAssert reals.fold() == 4.0
    strings.addLast("b")
    strings.addFirst("a")
    doAssert strings.fold() == "ab"
    let concat = proc(l, r: string): string = l & r
    newSwagWith(l & r, "").exercise(concat, "", @["a", "bc", "d", "ef"])

proc capturedSwag[T](ceiling: T): SWAG[T] =
    newSwagWith(min(min(l, r), ceiling), ceiling)

proc capturedOldSwag[T](ceiling: T): SWAG[T] =
    initSWAG(proc(l, r: T): T = min(min(l, r), ceiling), ceiling)

block:
    let first = capturedSwag(10)
    let second = capturedSwag(20)
    let old = capturedOldSwag(10)
    first.addLast(5)
    second.addLast(15)
    old.addLast(5)
    doAssert first.fold() == old.fold()
    doAssert second.fold() == 15
    doAssert first.popFirst() == 5
    let captured = proc(l, r: int): int = min(min(l, r), 10)
    first.exercise(captured, 10, @[3, 1, 4, 5, 9])

static:
    let swag = newSwagWith(l + r, 0)
    doAssert swag.fold() == 0
    swag.addLast(2)
    swag.addFirst(3)
    doAssert swag.fold() == 5
    doAssert swag.popLast() == 2
    doAssert swag.popFirst() == 3
    doAssert swag.fold() == 0
    let noncommutative = newSwagWith(compose(l, r), (1, 0))
    noncommutative.addLast((2, 3))
    noncommutative.addLast((5, 7))
    doAssert noncommutative.fold() == (10, 22)
    doAssert noncommutative.popFirst() == (2, 3)
    doAssert noncommutative.fold() == (5, 7)

doAssert get_maxrights(@[1, 2, 3], sum, 0,
    proc(x: int): bool = x <= 3) == @[2, 2, 3]
echo "Hello World"
