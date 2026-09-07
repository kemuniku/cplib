# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/matrix/matrix_product_avx2
import cplib/matrix/matrix
import cplib/modint/modint

const moduli = [1u32, 3u32, 998244353u32, 1000000007u32, 1073741823u32]
var rng = initRand(20260908)

proc naiveProduct(a, b: openArray[uint32], n, m, k: int,
        modulus: uint32): seq[uint32] =
    ## 各乗算の直後に剰余を取り、独立した単純実装で正解を求める。
    result = newSeq[uint32](n * k)
    for i in 0 ..< n:
        for j in 0 ..< k:
            var value = 0u64
            for l in 0 ..< m:
                value = (value + a[i * m + l].uint64 * b[l * k + j].uint64) mod
                    modulus.uint64
            result[i * k + j] = value.uint32

proc randomMatrix(rng: var Rand, n, m: int, modulus: uint32): seq[uint32] =
    ## 固定シードの乱数で、指定した法の範囲内の行列を生成する。
    result = newSeq[uint32](n * m)
    for value in result.mitems:
        value = rng.rand(0 .. (modulus - 1).int).uint32

proc checkProduct(a, b: openArray[uint32], n, m, k: int,
        modulus: uint32, expected: openArray[uint32]) =
    ## 積の値と正規化、入力配列が変更されないことを確認する。
    let beforeA = @a
    let beforeB = @b
    let actual = matrixProduct(a, b, n, m, k, modulus)
    doAssert actual.len == n * k
    doAssert actual == @expected,
        "matrix product mismatch: " & $n & " x " & $m & " x " & $k &
        ", modulus = " & $modulus.int
    for value in actual:
        doAssert value < modulus
    doAssert @a == beforeA
    doAssert @b == beforeB

proc checkNaive(a, b: openArray[uint32], n, m, k: int, modulus: uint32) =
    ## 単純実装と比較して、一般の長方形行列の積を確認する。
    checkProduct(a, b, n, m, k, modulus, naiveProduct(a, b, n, m, k, modulus))

proc checkBoundary(size: int, modulus: uint32, rng: var Rand) =
    ## 境界サイズの密行列を、全要素一定・置換・階数1の積で検証する。
    var constant = newSeq[uint32](size * size)
    for value in constant.mitems:
        value = modulus - 1
    var expected = newSeq[uint32](size * size)
    for value in expected.mitems:
        value = (size.uint64 mod modulus.uint64).uint32
    checkProduct(constant, constant, size, size, size, modulus, expected)

    let dense = randomMatrix(rng, size, size, modulus)
    var permutation = newSeq[uint32](size * size)
    for i in 0 ..< size:
        permutation[i * size + (i + 1) mod size] = 1u32 mod modulus
    for i in 0 ..< size:
        for j in 0 ..< size:
            expected[i * size + j] = dense[i * size + (j + size - 1) mod size]
    checkProduct(dense, permutation, size, size, size, modulus, expected)
    for i in 0 ..< size:
        for j in 0 ..< size:
            expected[i * size + j] = dense[((i + 1) mod size) * size + j]
    checkProduct(permutation, dense, size, size, size, modulus, expected)

    let x = randomMatrix(rng, size, 1, modulus)
    let y = randomMatrix(rng, size, 1, modulus)
    let z = randomMatrix(rng, size, 1, modulus)
    let w = randomMatrix(rng, size, 1, modulus)
    var a = newSeq[uint32](size * size)
    var b = newSeq[uint32](size * size)
    var dot = 0u64
    for l in 0 ..< size:
        dot = (dot + y[l].uint64 * z[l].uint64) mod modulus.uint64
    for i in 0 ..< size:
        for j in 0 ..< size:
            a[i * size + j] = (x[i].uint64 * y[j].uint64 mod modulus.uint64).uint32
            b[i * size + j] = (z[i].uint64 * w[j].uint64 mod modulus.uint64).uint32
            expected[i * size + j] =
                (x[i].uint64 * dot mod modulus.uint64 * w[j].uint64 mod modulus.uint64).uint32
    checkProduct(a, b, size, size, size, modulus, expected)

proc checkModintValues[T](actual, expected: Matrix[T]) =
    ## Montgomeryの冗長な内部表現を許し、各要素の公開値で等価性を確認する。
    doAssert actual.h == expected.h and actual.w == expected.w
    for i in 0 ..< actual.h:
        for j in 0 ..< actual.w:
            doAssert actual[i, j].val == expected[i, j].val

proc checkModint[T]() =
    ## modintの内部表現と負数の正規化を、既存の行列積と比較して検証する。
    var a = initMatrix(3, 5, T.init(0))
    var b = initMatrix(5, 2, T.init(0))
    for i in 0 ..< a.h:
        for j in 0 ..< a.w:
            a[i, j] = T.init((i + 1) * (j - 3))
            a[i, j] += T.init(T.umod.int - 1)
    for i in 0 ..< b.h:
        for j in 0 ..< b.w:
            b[i, j] = T.init(i * 29 - j * 17)
            b[i, j] -= T.init(T.umod.int - 1)
    let beforeA = $a
    let beforeB = $b
    checkModintValues(matrixProduct(a, b), a * b)
    doAssert $a == beforeA
    doAssert $b == beforeB
    var square = initMatrix(5, 5, T.init(0))
    for i in 0 ..< 5:
        for j in 0 ..< 5:
            square[i, j] = T.init(i * 7 - j * 13)
    checkModintValues(matrixProduct(square, square), square * square)
    let empty = initMatrix(0, 0, T.init(0))
    doAssert matrixProduct(empty, empty) == empty
    let noColumns = initMatrix(3, 0, T.init(0))
    doAssert matrixProduct(noColumns, empty) == noColumns

template expectAssertion(body: untyped) =
    ## 不正な引数が AssertionDefect で拒否されることを確認する。
    block:
        var caught = false
        try:
            body
        except AssertionDefect:
            caught = true
        doAssert caught, "invalid argument was accepted"

for modulus in moduli:
    for dimensions in [(0, 0, 0), (0, 3, 5), (4, 0, 5), (3, 4, 0),
            (1, 1, 1), (1, 4097, 3), (3, 4097, 1), (3, 1, 4097),
            (4097, 1, 3), (1, 257, 129), (129, 257, 1), (7, 65, 131),
            (65, 7, 131), (65, 131, 7)]:
        let (n, m, k) = dimensions
        let a = randomMatrix(rng, n, m, modulus)
        let b = randomMatrix(rng, m, k, modulus)
        checkNaive(a, b, n, m, k, modulus)

    for iteration in 0 ..< 60:
        let n = rng.rand(0 .. 18)
        let m = rng.rand(0 .. 18)
        let k = rng.rand(0 .. 18)
        let a = randomMatrix(rng, n, m, modulus)
        let b = randomMatrix(rng, m, k, modulus)
        checkNaive(a, b, n, m, k, modulus)

    for size in [1, 7, 17, 65, 129]:
        let a = randomMatrix(rng, size, size, modulus)
        checkNaive(a, a, size, size, size, modulus)

    for size in [63, 64, 65, 127, 128, 129, 255, 256, 257]:
        checkBoundary(size, modulus, rng)

    let a = @[0u32, 1u32 mod modulus, modulus - 1,
        modulus - 1, 0u32, 1u32 mod modulus]
    let b = @[modulus - 1, 1u32 mod modulus, 0u32,
        modulus - 1, 1u32 mod modulus, 0u32]
    checkNaive(a, b, 2, 3, 2, modulus)
    let rowsA = @[a[0 .. 2], a[3 .. 5]]
    let rowsB = @[b[0 .. 1], b[2 .. 3], b[4 .. 5]]
    let actual = matrixProduct(rowsA, rowsB, modulus)
    let expected = naiveProduct(a, b, 2, 3, 2, modulus)
    doAssert actual == @[expected[0 .. 1], expected[2 .. 3]]
    doAssert rowsA == @[a[0 .. 2], a[3 .. 5]]
    doAssert rowsB == @[b[0 .. 1], b[2 .. 3], b[4 .. 5]]

let empty = newSeq[uint32]()
let emptyRows = newSeq[seq[uint32]]()
doAssert matrixProduct(emptyRows, emptyRows) == emptyRows
doAssert matrixProduct(@[empty, empty], emptyRows) == @[empty, empty]
doAssert matrixProduct(@[@[1u32, 2u32]], @[empty, empty]) == @[empty]
doAssert matrixProduct(@[2u32], @[3u32], 1, 1, 1) == @[6u32]
doAssert matrixProduct(@[@[2u32]], @[@[3u32]]) == @[@[6u32]]

for modulus in [0u32, 2u32, 4u32, 1u32 shl 30, (1u32 shl 30) + 1, high(uint32)]:
    expectAssertion:
        discard matrixProduct(empty, empty, 0, 0, 0, modulus)
    expectAssertion:
        discard matrixProduct(emptyRows, emptyRows, modulus)

for dimensions in [(-1, 0, 0), (0, -1, 0), (0, 0, -1), (1, 1, 0), (0, 1, 1)]:
    let (n, m, k) = dimensions
    expectAssertion:
        discard matrixProduct(empty, empty, n, m, k)
expectAssertion:
    discard matrixProduct(@[1u32], @[1u32], 2, 1, 1)
expectAssertion:
    discard matrixProduct(@[1u32], @[1u32, 2u32], 1, 1, 1)
expectAssertion:
    discard matrixProduct(empty, empty, high(int), 2, 2)
expectAssertion:
    discard matrixProduct(@[@[1u32], @[2u32, 3u32]], @[@[1u32]])
expectAssertion:
    discard matrixProduct(@[@[1u32, 2u32]], @[@[1u32], @[2u32, 3u32]])
expectAssertion:
    discard matrixProduct(@[@[1u32]], emptyRows)
expectAssertion:
    discard matrixProduct(emptyRows, @[@[1u32]])

when compileOption("assertions"):
    expectAssertion:
        discard matrixProduct(@[3u32], @[0u32], 1, 1, 1, 3u32)
    expectAssertion:
        discard matrixProduct(@[0u32], @[3u32], 1, 1, 1, 3u32)

checkModint[modint998244353_montgomery]()
checkModint[modint1000000007_montgomery]()
checkModint[modint998244353_barrett]()
checkModint[modint1000000007_barrett]()
for modulus in moduli:
    modint_montgomery.setMod(modulus.int)
    modint_barrett.setMod(modulus.int)
    checkModint[modint_montgomery]()
    checkModint[modint_barrett]()

echo "Hello World"
