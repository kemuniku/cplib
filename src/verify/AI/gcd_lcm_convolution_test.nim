# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import math, random, sequtils
import cplib/convolution/gcd_convolution
import cplib/convolution/lcm_convolution
import cplib/modint/modint

proc check[T](a, b: seq[T]) =
    let originalA = a
    let originalB = b
    var expectedGcd = newSeqWith(a.len, T(0))
    var expectedLcm = newSeqWith(a.len, T(0))
    for i in 0..<a.len:
        for j in 0..<b.len:
            let g = gcd(i, j)
            let l = if i == 0 or j == 0: 0 else: i div g * j
            expectedGcd[g] += a[i] * b[j]
            if l < a.len:
                expectedLcm[l] += a[i] * b[j]
    let actualGcd = gcd_convolution(a, b)
    let actualLcm = lcm_convolution(a, b)
    when T is int:
        assert actualGcd == expectedGcd
        assert actualLcm == expectedLcm
    else:
        assert actualGcd.mapIt(it.val) == expectedGcd.mapIt(it.val)
        assert actualLcm.mapIt(it.val) == expectedLcm.mapIt(it.val)
    assert a == originalA
    assert b == originalB

check(newSeq[int](), newSeq[int]())
check(@[2], @[3])
assert gcdConvolution(@[0, 1, 2], @[0, 3, 4]) == @[0, 13, 8]
assert lcmConvolution(@[0, 1, 2], @[0, 3, 4]) == @[0, 3, 18]
assert gcdConvolution(@[2, 1, 2], @[3, 3, 4]) == @[6, 22, 22]
assert lcmConvolution(@[2, 1, 2], @[3, 3, 4]) == @[29, 3, 18]

for i in 0..<17:
    for j in 0..<17:
        var a = newSeq[int](17)
        var b = newSeq[int](17)
        a[i] = 1
        b[j] = 1
        check(a, b)

var rng = initRand(42)
for n in [0, 1, 2, 3, 4, 7, 16, 31, 64, 100, 127]:
    for trial in 0..<10:
        let a = newSeqWith(n, rng.rand(-100..100))
        let b = newSeqWith(n, rng.rand(-100..100))
        check(a, b)
        check(a, a)
        check(a, newSeq[int](n))
        check(a.mapIt(modint998244353_barrett(it)),
            b.mapIt(modint998244353_barrett(it)))
        check(a.mapIt(modint998244353_montgomery(it)),
            b.mapIt(modint998244353_montgomery(it)))

for invalid in [(newSeq[int](), @[1]), (@[1], @[1, 2])]:
    var rejectedGcd = false
    var rejectedLcm = false
    try:
        discard gcdConvolution(invalid[0], invalid[1])
    except AssertionDefect:
        rejectedGcd = true
    try:
        discard lcmConvolution(invalid[0], invalid[1])
    except AssertionDefect:
        rejectedLcm = true
    assert rejectedGcd and rejectedLcm

echo "Hello World"
