# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random
import cplib/collections/bitset_avx512

var rng = initRand(20260917)
for n in [0, 1, 63, 64, 65, 127, 128, 129, 255, 256, 257,
          511, 512, 513, 1000, 1023, 1024, 1025]:
    for trial in 0..<8:
        var source = newSeq[bool](n)
        for value in source.mitems:
            value = rng.rand(1) == 1
        for shift in [0, 1, 2, 63, 64, 65, 127, 128, 255, 256,
                      511, 512, n, n + 1, high(int)]:
            var left = initBitSet(source)
            var right = initBitSet(source)
            left <<= shift
            right >>= shift
            doAssert left.len == n and right.len == n
            for i in 0..<n:
                doAssert left[i] == (i >= shift and source[i - shift])
                doAssert right[i] == (shift < n - i and source[i + shift])
            left >>= 1
            for i in 0..<n:
                doAssert left[i] == (i + 1 < n and i + 1 >= shift and source[i + 1 - shift])

when compileOption("boundChecks"):
    var bits = initBitSet(65)
    var caught = 0
    try:
        bits <<= -1
    except ValueError:
        inc caught
    try:
        bits >>= -1
    except ValueError:
        inc caught
    doAssert caught == 2

echo "Hello World"
