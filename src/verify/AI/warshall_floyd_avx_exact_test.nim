# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
proc hasNegativeCycle[T](a: seq[seq[T]]): bool =
    for i in 0..<a.len:
        if a[i][i] < T(0): return true

import cplib/graph/warshall_floyd_avx
import cplib/utils/constants
import random, sequtils

proc reference(a: seq[seq[int]], inf: int): seq[seq[int]] =
    result = a
    for i in 0..<a.len:
        result[i][i] = min(result[i][i], 0)
    for k in 0..<a.len:
        for i in 0..<a.len:
            for j in 0..<a.len:
                if result[i][k] != inf and result[k][j] != inf:
                    result[i][j] = min(result[i][j], result[i][k] + result[k][j])

proc check(a: seq[seq[int]], inf: int) =
    let expected = reference(a, inf)
    let actual = a.warshall_floyd(inf = inf)
    doAssert not actual.hasNegativeCycle()
    doAssert actual == expected
    doAssert a.warshall_floyd_nonnegative(inf = inf) == expected
    var inplace = a
    inplace.warshall_floyd_inplace(inf = inf)
    doAssert not inplace.hasNegativeCycle()
    doAssert inplace == expected
    inplace = a
    inplace.warshall_floyd_nonnegative_inplace(inf = inf)
    doAssert inplace == expected

randomize(20260914)
for n in [127, 128, 129, 255, 256, 257]:
    for density in [0, 3, 100]:
        var a = newSeqWith(n, newSeqWith(n, INF64))
        for i in 0..<n:
            for j in 0..<n:
                if rand(99) < density:
                    a[i][j] = rand(0..1_000_000_000)
        check(a, INF64)

for n in [129, 257]:
    let limit = (1 shl 52) div n
    for weight in [limit - 1, limit, limit + 1]:
        var a = newSeqWith(n, newSeqWith(n, INF64))
        for i in 0..<n - 1:
            a[i][i + 1] = weight - (i mod 2)
        a[n - 1][0] = 0
        check(a, INF64)

block:
    const n = 129
    var a = newSeqWith(n, newSeqWith(n, 100))
    a[0][1] = 70
    a[1][2] = 70
    a[2][3] = 0
    for i in 3..<n:
        a[i][(i + 1) mod n] = 0
    check(a, 100)
    a[0][1] = 101
    check(a, 100)

    a = newSeqWith(n, newSeqWith(n, INF64))
    a[0][1] = (1 shl 53) + 1
    a[1][2] = 2
    a[0][2] = (1 shl 53) + 4
    check(a, INF64)
    a[0][1] = -1
    a[1][2] = 2
    check(a, INF64)
    a[1][0] = 0
    doAssert a.warshall_floyd().hasNegativeCycle()

for n in [128, 129, 255, 256, 257]:
    for dense in [false, true]:
        let potential = newSeqWith(n, rand(-1_000_000_000..1_000_000_000))
        var a = newSeqWith(n, newSeqWith(n, INF64))
        for i in 0..<n:
            for j in 0..<n:
                if i != j and (dense or (i div 64 == j div 64 and rand(9) < 3)):
                    a[i][j] = rand(0..1000) + potential[j] - potential[i]
        check(a, INF64)

for n in [129, 257]:
    let limit = (1 shl 52) div n
    for magnitude in [limit - 1, limit, limit + 1]:
        var a = newSeqWith(n, newSeqWith(n, INF64))
        for i in 0..<n - 1:
            a[i][i + 1] = -magnitude + (i mod 2)
            if i + 2 < n:
                a[i][i + 2] = 0
        check(a, INF64)

block:
    const n = 129
    var a = newSeqWith(n, newSeqWith(n, 100))
    a[0][1] = 70
    a[1][2] = 70
    a[2][3] = -80
    for i in 4..<n:
        for j in 4..<n:
            a[i][j] = 0
    check(a, 100)

echo "Hello World"


