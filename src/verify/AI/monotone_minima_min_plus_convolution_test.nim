# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/random
import cplib/utils/monotone_minima
import cplib/convolution/min_plus_convolution

block monotoneMinimaTests:
    let matrix = @[
        @[0, 1, 4, 9],
        @[1, 0, 1, 4],
        @[4, 1, 0, 1],
        @[9, 4, 1, 0]
    ]
    assert monotoneMinimaByValue(4, 4,
        proc(i, j: int): int = matrix[i][j]) == @[0, 1, 2, 3]
    assert monotoneMinima(3, 4,
        proc(i, j, k: int): bool = abs(i - j) <= abs(i - k)) == @[0, 1, 2]
    assert monotoneMinimaByValue(0, 0,
        proc(i, j: int): int = i + j) == newSeq[int]()
    assert monotoneMinimaByValue(2, 0,
        proc(i, j: int): int = i + j) == @[-1, -1]

proc naive[T](a, b: seq[T]): seq[T] =
    if a.len == 0 or b.len == 0: return @[]
    result = newSeq[T](a.len + b.len - 1)
    for k in 0..<result.len:
        var first = true
        for i in max(0, k - b.high)..min(a.high, k):
            let value = a[i] + b[k - i]
            if first or value < result[k]:
                result[k] = value
                first = false

block fixedTests:
    let convex = @[4, 1, 0, 1, 4]
    let arbitrary = @[3, -2, 7, 0]
    let expected = naive(convex, arbitrary)
    assert minPlusConvolutionConvexArbitrary(convex, arbitrary) == expected
    assert minPlusConvolutionArbitraryConvex(arbitrary, convex) == expected
    assert minPlusConvolutionConvexConvex(convex, @[-1, -1, 1, 5]) ==
        naive(convex, @[-1, -1, 1, 5])
    assert minPlusConvolutionConvexArbitrary(newSeq[int](), arbitrary).len == 0

block randomizedTests:
    var rng = initRand(20260713)
    for n in 1..20:
        for m in 1..20:
            for trial in 0..<20:
                var convex = newSeq[int](n)
                convex[0] = rng.rand(-20..20)
                var difference = rng.rand(-10..0)
                for i in 1..<n:
                    difference += rng.rand(0..4)
                    convex[i] = convex[i - 1] + difference
                var arbitrary = newSeq[int](m)
                for i in 0..<m: arbitrary[i] = rng.rand(-30..30)
                let expected = naive(convex, arbitrary)
                assert minPlusConvolutionConvexArbitrary(convex, arbitrary) == expected
                assert minPlusConvolutionArbitraryConvex(arbitrary, convex) == expected

                var convex2 = newSeq[int](m)
                convex2[0] = rng.rand(-20..20)
                difference = rng.rand(-10..0)
                for i in 1..<m:
                    difference += rng.rand(0..4)
                    convex2[i] = convex2[i - 1] + difference
                assert minPlusConvolutionConvexConvex(convex, convex2) ==
                    naive(convex, convex2)
