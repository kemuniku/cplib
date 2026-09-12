# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, algorithm
import cplib/collections/bitset as scalar
import cplib/collections/bitset_avx2 as avx2
import cplib/collections/bitset_avx512 as avx512
import cplib/collections/staticbitset as fixed
import cplib/collections/staticbitset_avx2 as fixed2
import cplib/collections/staticbitset_avx512 as fixed512

proc reference(a, b: seq[bool]): int =
    for i in 0..<a.len:
        if a[i] != b[i]:
            return if a[i]: 1 else: -1

proc check[T](x, y: T, expected: int) =
    doAssert cmp(x, y) == expected
    doAssert cmp(y, x) == -expected
    doAssert cmp(x, x) == 0
    doAssert (x < y) == (expected < 0)
    doAssert (x <= y) == (expected <= 0)
    doAssert lexLess(x, y) == (expected < 0)
    doAssert (x > y) == (expected > 0)
    doAssert (x >= y) == (expected >= 0)
    var values = @[y, x]
    values.sort()
    doAssert values[0] <= values[1]

template checkSize(n: static int) =
    block:
        proc checkPair(a, b: seq[bool]) =
            let expected = reference(a, b)
            check(scalar.initBitSet(a), scalar.initBitSet(b), expected)
            check(avx2.initBitSet(a), avx2.initBitSet(b), expected)
            check(avx512.initBitSet(a), avx512.initBitSet(b), expected)
            check(fixed.initBitSet(a, n), fixed.initBitSet(b, n), expected)
            check(fixed2.initBitSet(a, n), fixed2.initBitSet(b, n), expected)
            check(fixed512.initBitSet(a, n), fixed512.initBitSet(b, n), expected)
        var a = newSeq[bool](n)
        var b = newSeq[bool](n)
        checkPair(a, b)
        for i in 0..<n:
            b[i] = true
            checkPair(a, b)
            b[i] = false
            a[i] = true
            for j in i+1..<n:
                b[j] = true
            checkPair(a, b)
            a[i] = false
            b = newSeq[bool](n)
        for trial in 0..<100:
            for i in 0..<n:
                a[i] = rand(1) == 1
                b[i] = a[i]
            checkPair(a, b)
            if n > 0:
                let start = rand(n - 1)
                for i in start..<n:
                    b[i] = rand(1) == 1
                checkPair(a, b)

randomize(7319)
checkSize(0)
checkSize(1)
checkSize(63)
checkSize(64)
checkSize(65)
checkSize(255)
checkSize(256)
checkSize(257)
checkSize(511)
checkSize(512)
checkSize(513)
checkSize(1025)

template checkMismatch(make: untyped) =
    block:
        var raised = false
        try:
            discard cmp(make(1), make(2))
        except ValueError:
            raised = true
        doAssert raised
checkMismatch(scalar.initBitSet)
checkMismatch(avx2.initBitSet)
checkMismatch(avx512.initBitSet)
echo "Hello World"
