# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
# AVX2対応のCPUが必要です。
echo "Hello World"

import random
import cplib/collections/bitset_avx2

proc checkBits(actual: BitSetAvx2, expected: openArray[bool]) =
    ## ビット列、要素列挙、最下位ビット、個数、文字列表現を照合する。
    assert actual.len == expected.len
    var indexes: seq[int]
    var representation = newString(expected.len)
    for i in 0..<expected.len:
        assert actual[i] == expected[i]
        representation[expected.len - 1 - i] = if expected[i]: '1' else: '0'
        if expected[i]:
            indexes.add(i)
    var actualIndexes: seq[int]
    for i in actual:
        actualIndexes.add(i)
    assert actualIndexes == indexes
    assert actual.popcount == indexes.len
    assert actual.lowestBit == (if indexes.len == 0: -1 else: indexes[0])
    assert $actual == representation

proc combine(a, b: openArray[bool], operation: char): seq[bool] =
    ## bool 配列上で二項演算の期待値を作る。
    result = newSeq[bool](a.len)
    for i in 0..<a.len:
        case operation
        of '&': result[i] = a[i] and b[i]
        of '|': result[i] = a[i] or b[i]
        of '^': result[i] = a[i] xor b[i]
        else: assert false

proc countBits(bits: openArray[bool]): int =
    ## bool 配列に含まれる真の個数を数える。
    for bit in bits:
        if bit:
            inc result

proc checkPair(a, b: seq[bool]) =
    ## 二項演算と代入演算を照合し、元の値が変更されないことを検証する。
    let x = initBitSet(a)
    let y = initBitSet(b)
    checkBits(x, a)
    checkBits(y, b)
    let expectedAnd = combine(a, b, '&')
    let expectedOr = combine(a, b, '|')
    let expectedXor = combine(a, b, '^')
    checkBits(x & y, expectedAnd)
    checkBits(x | y, expectedOr)
    checkBits(x ^ y, expectedXor)
    assert x.andpopcount(y) == countBits(expectedAnd)
    assert x.orpopcount(y) == countBits(expectedOr)
    assert x.xorpopcount(y) == countBits(expectedXor)

    var assigned = x
    assigned &= y
    checkBits(assigned, expectedAnd)
    checkBits(x, a)
    assigned = x
    assigned |= y
    checkBits(assigned, expectedOr)
    checkBits(x, a)
    assigned = x
    assigned ^= y
    checkBits(assigned, expectedXor)
    checkBits(x, a)
    checkBits(y, b)

    assigned = x
    assigned &= assigned
    checkBits(assigned, a)
    assigned |= assigned
    checkBits(assigned, a)
    assigned ^= assigned
    checkBits(assigned, newSeq[bool](a.len))
    checkBits(x, a)

proc checkUnary(bits: seq[bool]) =
    ## 否定、シフト、各種初期化、ビット更新とコピーの独立性を検証する。
    let n = bits.len
    let x = initBitSet(bits)
    var inverted = newSeq[bool](n)
    var indexes: seq[int]
    for i in 0..<n:
        inverted[i] = not bits[i]
        if bits[i]:
            indexes.add(i)
    checkBits(~x, inverted)
    checkBits(~(~x), bits)
    checkBits(initBitSetFromIndexes(indexes, n), bits)
    checkBits(initBitSet(n), newSeq[bool](n))

    var shifts = @[0, 1, 7, 63, 64, 65, 127, 128, 129, 191, 192,
                   193, 255, 256, 257, 511, 512, 513, n, n + 1, int.high]
    if n > 0:
        shifts.add(n - 1)
    if n <= 257:
        for shift in 0..n:
            if shift notin shifts:
                shifts.add(shift)
    for shift in shifts:
        var left = newSeq[bool](n)
        var right = newSeq[bool](n)
        for i in 0..<n:
            left[i] = i >= shift and bits[i - shift]
            right[i] = shift < n and i < n - shift and bits[i + shift]
        checkBits(x << shift, left)
        checkBits(x >> shift, right)
    checkBits(x, bits)

    var assigned = x
    for i in 0..<n:
        assigned[i] = inverted[i]
    checkBits(assigned, inverted)
    checkBits(x, bits)
    for i in 0..<n:
        assigned[i] = ord(bits[i])
    checkBits(assigned, bits)

template expectError(errorType: typedesc, body: untyped) =
    ## 指定した種類の例外が発生することを検証する。
    block:
        var caught = false
        try:
            body
        except errorType:
            caught = true
        assert caught

var rng = initRand(20260908)
for n in [0, 1, 2, 63, 64, 65, 127, 128, 129, 255, 256, 257,
          511, 512, 513, 8192, 8193, 16385]:
    var a = newSeq[bool](n)
    var b = newSeq[bool](n)
    var ones = newSeq[bool](n)
    let zeros = newSeq[bool](n)
    for i in 0..<n:
        a[i] = rng.rand(1) == 1
        b[i] = rng.rand(1) == 1
        ones[i] = true
    checkPair(a, b)
    checkPair(ones, ones)
    checkPair(ones, zeros)
    checkUnary(a)
    checkBits(~initBitSet(n), ones)
    if n > 0:
        var singleton = initBitSet(n)
        singleton[n - 1] = true
        assert singleton.lowestBit == n - 1
        assert singleton.popcount == 1
        assert (singleton << 1).popcount == 0
        assert (singleton >> (n - 1))[0]

var empty: BitSetAvx2
checkBits(empty, newSeq[bool](0))
checkBits(initBitSet([true, false, true], 5), @[true, false, true, false, false])
checkBits(initBitSetFromIndexes([0, 0, 64, 64], 65),
          block:
              var expected = newSeq[bool](65)
              expected[0] = true
              expected[64] = true
              expected)

expectError(ValueError):
    discard initBitSet(-1)
expectError(ValueError):
    discard initBitSet([true], 0)
expectError(ValueError):
    discard initBitSet(newSeq[bool](0), -1)
expectError(ValueError):
    discard initBitSetFromIndexes(newSeq[int](0), -1)
expectError(IndexDefect):
    discard initBitSetFromIndexes([-1], 64)
expectError(IndexDefect):
    discard initBitSetFromIndexes([64], 64)
expectError(IndexDefect):
    discard initBitSetFromIndexes([0], 0)
for n in [0, 1, 64, 257]:
    expectError(IndexDefect):
        discard initBitSet(n)[n]
    expectError(IndexDefect):
        var x = initBitSet(n)
        x[n] = true
    expectError(IndexDefect):
        var x = initBitSet(n)
        x[n] = 0
    expectError(ValueError):
        discard initBitSet(n) << -1
    expectError(ValueError):
        discard initBitSet(n) >> -1

let small = initBitSet(64)
let large = initBitSet(65)
expectError(ValueError):
    discard small & large
expectError(ValueError):
    discard small | large
expectError(ValueError):
    discard small ^ large
expectError(ValueError):
    var x = small
    x &= large
expectError(ValueError):
    var x = small
    x |= large
expectError(ValueError):
    var x = small
    x ^= large
expectError(ValueError):
    discard small.andpopcount(large)
expectError(ValueError):
    discard small.orpopcount(large)
expectError(ValueError):
    discard small.xorpopcount(large)
