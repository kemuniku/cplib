# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
proc hasNegativeCycle[T](a: seq[seq[T]]): bool =
    for i in 0..<a.len:
        if a[i][i] < T(0): return true

import cplib/graph/warshall_floyd_avx512
import cplib/utils/constants
import random, sequtils

proc check[T](n: int, inf: T, unit: int) =
    for mode in 0..2:
        var a = newSeqWith(n, newSeqWith(n, inf))
        for i in 0..<n:
            a[i][i] = 0
            for j in 0..<n:
                if i != j and (mode == 0 or (mode == 1 and rand(4) == 0) or
                        (mode == 2 and i div 19 == j div 19)):
                    a[i][j] = T(rand(0..1000) + (j mod 17 - i mod 17) * unit)
        var expected = a
        for k in 0..<n:
            for i in 0..<n:
                for j in 0..<n:
                    if expected[i][k] != inf and expected[k][j] != inf:
                        expected[i][j] = min(expected[i][j], expected[i][k] + expected[k][j])
        let checked = a.warshall_floyd()
        doAssert not checked.hasNegativeCycle()
        doAssert checked == expected
        doAssert a.warshall_floyd_nonnegative() == expected
        var inplace = a
        inplace.warshall_floyd_nonnegative_inplace()
        doAssert inplace == expected
        a[0][n - 1] = -2
        a[n - 1][0] = 1
        doAssert a.warshall_floyd().hasNegativeCycle()

randomize(512216)
for n in [217, 223, 224, 225, 255, 256, 257, 433, 447, 448, 449,
        511, 512, 513, 575, 576, 577]:
    check[int](n, INF64, int(10_000_000_001))
for n in [257, 271, 272, 287, 288, 289, 513]:
    check[int32](n, INF32, 10_000)

echo "Hello World"


