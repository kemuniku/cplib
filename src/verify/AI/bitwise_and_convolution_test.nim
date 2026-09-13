# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, sequtils
import cplib/convolution/bitwise_and_convolution
import cplib/modint/modint

proc naive[T](a, b: seq[T]): seq[T] =
    result = newSeqWith(a.len, T(0))
    for i in 0..<a.len:
        for j in 0..<b.len:
            result[i and j] += a[i] * b[j]

proc check[T](a, b: seq[T]) =
    let originalA = a
    let originalB = b
    let actual = bitwise_and_convolution(a, b)
    let expected = naive(a, b)
    when T is int:
        assert actual == expected
    else:
        assert actual.mapIt(it.val) == expected.mapIt(it.val)
    assert a == originalA
    assert b == originalB

assert bitwiseAndConvolution(newSeq[int](), newSeq[int]()) == newSeq[int]()
assert bitwiseAndConvolution(@[2], @[3]) == @[6]
assert bitwiseAndConvolution(@[1, 2], @[3, 4]) == @[13, 8]

var rng = initRand(42)
for exponent in 0..7:
    let n = 1 shl exponent
    for trial in 0..<10:
        let a = newSeqWith(n, rng.rand(-100..100))
        let b = newSeqWith(n, rng.rand(-100..100))
        check(a, b)
        check(a, a)
        check(a.mapIt(modint998244353_barrett(it)),
            b.mapIt(modint998244353_barrett(it)))
        check(a.mapIt(modint998244353_montgomery(it)),
            b.mapIt(modint998244353_montgomery(it)))

for invalid in [(@[1], @[1, 2]), (@[1, 2, 3], @[4, 5, 6])]:
    var rejected = false
    try:
        discard bitwiseAndConvolution(invalid[0], invalid[1])
    except AssertionDefect:
        rejected = true
    assert rejected

echo "Hello World"
