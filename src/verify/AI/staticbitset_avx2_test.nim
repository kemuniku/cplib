# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
# AVX2対応のCPUが必要です。
echo "Hello World"

import random
import cplib/collections/staticbitset_avx2

proc checkBits[size](actual: BitSet[size], expected: openArray[bool]) =
    ## 全ビット、個数、列挙、最下位ビット、文字列表現をbool配列と照合します。
    assert actual.len == expected.len
    var indexes, actualIndexes: seq[int]
    var representation = newString(size)
    for i in 0..<size:
        assert actual[i] == expected[i]
        representation[size - i - 1] = if expected[i]: '1' else: '0'
        if expected[i]:
            indexes.add(i)
    for i in actual:
        actualIndexes.add(i)
    assert actualIndexes == indexes
    assert actual.popcount == indexes.len
    assert actual.lowestBit == (if indexes.len == 0: -1 else: indexes[0])
    assert $actual == representation

template expectError(errorType: typedesc, body: untyped) =
    ## 指定した種類の例外が発生することを検証します。
    block:
        var caught = false
        try:
            body
        except errorType:
            caught = true
        assert caught

proc checkSize[size: static int]() =
    ## 境界サイズで論理演算、シフト、コピー、範囲検査を検証します。
    var rng = initRand(20260908 + size)
    for pattern in 0..<4:
        var a, b = newSeq[bool](size)
        var indexes: seq[int]
        for i in 0..<size:
            a[i] = if pattern < 2: pattern == 1 else: rng.rand(1) == 1
            b[i] = if pattern < 2: true else: rng.rand(1) == 1
            if a[i]:
                indexes.add(i)
        let x = initBitSet(a, size)
        let y = initBitSet(b, size)
        checkBits(x, a)
        checkBits(y, b)

        checkBits(initBitSetFromIndexes(indexes, size), a)
        checkBits(initBitSet(size), newSeq[bool](size))
        var expectedAnd, expectedOr, expectedXor, inverted = newSeq[bool](size)
        var andCount, orCount, xorCount: int
        for i in 0..<size:
            expectedAnd[i] = a[i] and b[i]
            expectedOr[i] = a[i] or b[i]
            expectedXor[i] = a[i] xor b[i]
            inverted[i] = not a[i]
            andCount += ord(expectedAnd[i])
            orCount += ord(expectedOr[i])
            xorCount += ord(expectedXor[i])
        checkBits(x & y, expectedAnd)
        checkBits(x | y, expectedOr)
        checkBits(x ^ y, expectedXor)
        checkBits(~x, inverted)
        assert andpopcount(x, y) == andCount
        assert orpopcount(x, y) == orCount
        assert xorpopcount(x, y) == xorCount
        var assigned = x
        assigned &= y
        checkBits(assigned, expectedAnd)
        assigned = x
        assigned |= y
        checkBits(assigned, expectedOr)
        assigned = x
        assigned ^= y
        checkBits(assigned, expectedXor)
        assigned = x
        assigned &= assigned
        checkBits(assigned, a)
        assigned |= assigned
        checkBits(assigned, a)
        assigned ^= assigned
        checkBits(assigned, newSeq[bool](size))
        assigned = x
        for i in 0..<size:
            assigned[i] = not a[i]
        checkBits(assigned, inverted)
        for i in 0..<size:
            assigned[i] = ord(a[i])
            assigned[i] = 2
        checkBits(assigned, a)

        var shifts = @[0, 1, 13, 31, 32, 33, 63, 64, 65, 127, 128, 129,
                       191, 192, 193, 255, 256, 257, 511, 512, 513, size, size + 1, int.high]
        when size > 0:
            shifts.add(size - 1)
        when size <= 257:
            for shift in 0..size:
                if shift notin shifts:
                    shifts.add(shift)
        for shift in shifts:
            var left, right = newSeq[bool](size)
            for i in 0..<size:
                left[i] = i >= shift and a[i - shift]
                right[i] = shift < size and i < size - shift and a[i + shift]
            checkBits(x << shift, left)
            checkBits(x >> shift, right)
        checkBits(x, a)
        checkBits(y, b)

    for length in [0, 1, 7, 8, 9, 31, 32, 33, 63, 64, 65, 127, 128, 129, size]:
        if length > size:
            continue
        var source = newSeq[bool](length)
        var expected = newSeq[bool](size)
        for i in 0..<length:
            source[i] = i mod 3 != 0
            expected[i] = source[i]
        checkBits(initBitSet(source, size), expected)
        var padded = newSeq[bool](length + 2)
        for i in 0..<padded.len:
            padded[i] = true
        for i in 0..<length:
            padded[i + 1] = source[i]
        if length > 0:
            checkBits(initBitSet(padded.toOpenArray(1, length), size), expected)

    var empty: BitSet[size]
    checkBits(empty, newSeq[bool](size))
    expectError(ValueError):
        discard initBitSet(newSeq[bool](size + 1), size)
    expectError(ValueError):
        discard empty << -1
    expectError(ValueError):
        discard empty >> -1
    expectError(IndexDefect):
        discard empty[size]
    expectError(IndexDefect):
        empty[size] = true
    expectError(IndexDefect):
        empty[size] = 0
    expectError(IndexDefect):
        discard initBitSetFromIndexes([-1], size)
    expectError(IndexDefect):
        discard initBitSetFromIndexes([size], size)

checkSize[0]()
checkSize[1]()
checkSize[7]()
checkSize[8]()
checkSize[9]()
checkSize[31]()
checkSize[32]()
checkSize[33]()
checkSize[63]()
checkSize[64]()
checkSize[65]()
checkSize[127]()
checkSize[128]()
checkSize[129]()
checkSize[255]()
checkSize[256]()
checkSize[257]()
checkSize[511]()
checkSize[512]()
checkSize[513]()
checkSize[8192]()
checkSize[8193]()
checkSize[16385]()

checkBits(initBitSet([true, false, true], 5), @[true, false, true, false, false])
assert initBitSetFromIndexes([0, 0, 64, 64], 65).popcount == 2
for value in 0..<256:
    var bits: BitSet[8]
    var expected = newString(8)
    for i in 0..<8:
        bits[i] = (value shr i) and 1
        expected[7 - i] = if ((value shr i) and 1) != 0: '1' else: '0'
    assert $bits == expected
static:
    doAssert not compiles(initBitSet(-1))
    doAssert not compiles(initBitSet(64) & initBitSet(65))
