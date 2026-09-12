# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
when defined(cpp):
    import cplib/collections/bitset as scalar
    import cplib/collections/staticbitset as fixed
import cplib/collections/bitset_avx2 as avx2
import cplib/collections/bitset_avx512 as avx512
import cplib/collections/staticbitset_avx2 as fixed2
import cplib/collections/staticbitset_avx512 as fixed512

proc check[T](x: T, expectedAll, expectedAny: bool) =
    doAssert x.all == expectedAll
    doAssert x.any == expectedAny
    doAssert (~x).all == not expectedAny
    doAssert (~x).any == not expectedAll
    doAssert x.all == expectedAll
    doAssert x.any == expectedAny

template checkSize(n: static int) =
    block:
        proc checkBits(bits: seq[bool]) =
            var expectedAll = true
            var expectedAny = false
            for bit in bits:
                expectedAll = expectedAll and bit
                expectedAny = expectedAny or bit
            when defined(cpp):
                check(scalar.initBitSet(bits), expectedAll, expectedAny)
                check(fixed.initBitSet(bits, n), expectedAll, expectedAny)
            check(avx2.initBitSet(bits), expectedAll, expectedAny)
            check(avx512.initBitSet(bits), expectedAll, expectedAny)
            check(fixed2.initBitSet(bits, n), expectedAll, expectedAny)
            check(fixed512.initBitSet(bits, n), expectedAll, expectedAny)
        var bits = newSeq[bool](n)
        checkBits(bits)
        for i in 0..<n:
            bits[i] = true
            checkBits(bits)
            bits[i] = false
        for i in 0..<n:
            bits[i] = true
        checkBits(bits)
        for i in 0..<n:
            bits[i] = false
            checkBits(bits)
            bits[i] = true
        for trial in 0..<100:
            for i in 0..<n:
                bits[i] = rand(1) == 1
            checkBits(bits)

randomize(8341)
checkSize(0)
checkSize(1)
checkSize(63)
checkSize(64)
checkSize(65)
checkSize(127)
checkSize(128)
checkSize(255)
checkSize(256)
checkSize(257)
checkSize(511)
checkSize(512)
checkSize(513)
checkSize(1023)
checkSize(1024)
checkSize(1025)
echo "Hello World"
