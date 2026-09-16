# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, algorithm
import cplib/collections/bitset_avx2 as dynamic2
import cplib/collections/bitset_avx512 as dynamic512
import cplib/collections/staticbitset_avx2 as fixed2
import cplib/collections/staticbitset_avx512 as fixed512

proc check[T](x: T, bits: seq[bool]) =
    var prev = -1
    doAssert x.prevSetBit(-1) == -1
    for start in 0..<bits.len:
        if bits[start]: prev = start
        doAssert x.prevSetBit(start) == prev
    var next = -1
    doAssert x.nextSetBit(bits.len) == -1
    for start in countdown(bits.len - 1, 0):
        if bits[start]: next = start
        doAssert x.nextSetBit(start) == next
    doAssert x.lowestBit == next
    var expected, actual, backward: seq[int]
    for i, bit in bits:
        if bit: expected.add(i)
    for i in x: actual.add(i)
    doAssert actual == expected
    var pos = x.prevSetBit(x.len - 1)
    while pos >= 0:
        backward.add(pos)
        pos = x.prevSetBit(pos - 1)
    backward.reverse()
    doAssert backward == expected
    when compileOption("boundChecks"):
        for invalid in [-2, bits.len]:
            var raised = false
            try: discard x.prevSetBit(invalid)
            except IndexDefect: raised = true
            doAssert raised
        for invalid in [-1, bits.len+1]:
            var raised = false
            try: discard x.nextSetBit(invalid)
            except IndexDefect: raised = true
            doAssert raised

template checkSize(n: static int) =
    block:
        proc checkAll(bits: seq[bool]) =
            check(dynamic2.initBitSet(bits), bits)
            check(dynamic512.initBitSet(bits), bits)
            check(fixed2.initBitSet(bits, n), bits)
            check(fixed512.initBitSet(bits, n), bits)
        var bits = newSeq[bool](n)
        checkAll(bits)
        for i in 0..<n: bits[i] = true
        checkAll(bits)
        for pos in [0, 1, 63, 64, 255, 256, 511, 512, 1023, 1024, n-1]:
            if pos >= 0 and pos < n:
                bits = newSeq[bool](n)
                bits[pos] = true
                checkAll(bits)
        for trial in 0..<8:
            for i in 0..<n: bits[i] = rand(99) < (if trial mod 2 == 0: 1 else: 50)
            checkAll(bits)

randomize(156)
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
checkSize(4097)
echo "Hello World"
