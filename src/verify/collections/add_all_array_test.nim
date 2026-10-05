# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/add_all_array

proc check(self: AddAllArray[int64], expected: openArray[int64]) =
    doAssert self.len == expected.len
    var total = 0'i64
    for i, value in expected:
        doAssert self[i] == value
        doAssert self.get(i) == value
        total += value
    doAssert self.sum == total

block:
    var input = @[3'i64, -8, 4]
    let a = initAddAllArray(input)
    input[0] = 99
    a.check([3'i64, -8, 4])
    a.addAll(7)
    a.check([10'i64, -1, 11])
    a.set(0, -3)
    a[2] = 0
    a[1] = a[1] + 5
    a.check([-3'i64, 4, 0])
    input.add(100)
    a.check([-3'i64, 4, 0])
    var detached = a[1]
    detached += 999
    a.check([-3'i64, 4, 0])
    let alias = a
    alias.addAll(-4)
    alias[0] = 9
    a.check([9'i64, 0, -4])
    let independent = initAddAllArray([9'i64, 0, -4])
    a.addAll(10)
    independent.check([9'i64, 0, -4])

block:
    let empty = initAddAllArray(newSeq[int64]())
    empty.addAll(high(int64))
    empty.addAll(high(int64))
    empty.addAll(low(int64))
    empty.check(newSeq[int64]())
    for a in [empty, initAddAllArray([2'i64])]:
        for index in [-1, a.len, high(int)]:
            var caught = false
            try:
                discard a[index]
            except IndexDefect:
                caught = true
            doAssert caught
            caught = false
            try:
                a.set(index, 10)
            except IndexDefect:
                caught = true
            doAssert caught
        doAssert a.sum == (if a.len == 0: 0'i64 else: 2'i64)

block:
    let a = initAddAllArray([high(int64) - 10])
    a.addAll(10)
    a.check([high(int64)])
    a.set(0, high(int64))
    a.addAll(-10)
    a.check([high(int64) - 10])
    let b = initAddAllArray([low(int64) + 10])
    b.addAll(-10)
    b.check([low(int64)])
    b[0] = low(int64)
    b.addAll(10)
    b.check([low(int64) + 10])
    let c = initAddAllArray([high(int64) div 4, -(high(int64) div 4)])
    c.addAll(123)
    c.check([high(int64) div 4 + 123, -(high(int64) div 4) + 123])

proc checkType(T: typedesc) =
    let a = initAddAllArray([T(3), T(-2), T(8)])
    a.addAll(T(-4))
    a[0] = T(9)
    doAssert a.get(1) == T(-6)
    doAssert a[2] == T(4)
    doAssert a.sum == T(7)
    doAssert a.len == 3

checkType(int)
checkType(int8)
checkType(int16)
checkType(int32)
checkType(int64)
checkType(float32)
checkType(float64)

block:
    var rng = initRand(338)
    for size in [0, 1, 2, 3, 17, 64, 127]:
        var expected = newSeq[int64](size)
        for i in 0..<size:
            expected[i] = int64(rng.rand(-1000..1000))
        let a = initAddAllArray(expected)
        for step in 0..<10000:
            case rng.rand(3)
            of 0:
                let delta = int64(rng.rand(-1000..1000))
                a.addAll(delta)
                for value in expected.mitems: value += delta
            of 1, 2:
                if size != 0:
                    let index = rng.rand(size - 1)
                    let value = int64(rng.rand(-100000..100000))
                    if step mod 2 == 0: a.set(index, value)
                    else: a[index] = value
                    expected[index] = value
            else: discard
            a.check(expected)

type Counted = distinct int64
var additions, subtractions, multiplications: int
proc `+`(a, b: Counted): Counted =
    inc additions
    Counted(int64(a) + int64(b))
proc `-`(a, b: Counted): Counted =
    inc subtractions
    Counted(int64(a) - int64(b))
proc `*`(a, b: Counted): Counted =
    inc multiplications
    Counted(int64(a) * int64(b))

block:
    for size in [1, 200000]:
        additions = 0
        let a = initAddAllArray(newSeq[Counted](size), Counted(0))
        doAssert additions == size
        additions = 0
        subtractions = 0
        multiplications = 0
        a.addAll(Counted(3))
        doAssert additions == 2 and multiplications == 1 and subtractions == 0
        doAssert int64(a[size - 1]) == 3
        doAssert additions == 3
        a[size - 1] = Counted(8)
        doAssert additions == 5 and subtractions == 2 and multiplications == 1
        doAssert int64(a.sum) == int64(size) * 3 + 5
        doAssert a.len == size
        doAssert additions == 5 and subtractions == 2 and multiplications == 1

static:
    doAssert not compiles(block:
        let a = initAddAllArray([1, 2])
        let p = addr a[0]
        p[] = 9)
    doAssert not compiles(block:
        proc change(value: var int) = value = 9
        let a = initAddAllArray([1, 2])
        change(a.get(0)))

echo "Hello World"
