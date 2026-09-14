# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/bitset_avx512

proc check(bits: seq[bool]) =
    let x = initBitSet(bits)
    doAssert x.prevSetBit(-1) == -1
    var expected = -1
    for start in 0..<bits.len:
        if bits[start]: expected = start
        doAssert x.prevSetBit(start) == expected
    var pos = x.prevSetBit(x.len - 1)
    var actual: seq[int]
    while pos >= 0:
        actual.add(pos)
        pos = x.prevSetBit(pos - 1)
    var indexes: seq[int]
    for i in countdown(bits.len - 1, 0):
        if bits[i]: indexes.add(i)
    doAssert actual == indexes
    when compileOption("boundChecks"):
        for invalid in [-2, bits.len]:
            var rejected = false
            try:
                discard x.prevSetBit(invalid)
            except IndexDefect:
                rejected = true
            doAssert rejected

randomize(156)
for n in [0, 1, 2, 63, 64, 65, 127, 128, 129, 511, 512, 513, 4097]:
    var bits = newSeq[bool](n)
    check(bits)
    for i in 0..<n: bits[i] = true
    check(bits)
    for pos in [0, 63, 64, 127, 128, 511, 512, n-1]:
        if pos >= 0 and pos < n:
            bits = newSeq[bool](n)
            bits[pos] = true
            check(bits)
    for trial in 0..<20:
        for i in 0..<n: bits[i] = rand(99) < (if trial mod 2 == 0: 1 else: 50)
        check(bits)

echo "Hello World"
