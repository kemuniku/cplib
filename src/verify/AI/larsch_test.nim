# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/larsch
import random

var rng = initRand(419231)
for n in 0..120:
    for rep in 0..<10:
        var matrix = newSeq[seq[int]](n)
        for r in 0..<n:
            matrix[r] = newSeq[int](n)
            for c in 0..<n:
                if r == 0: matrix[r][c] = rng.rand(-100..100)
                elif c == 0: matrix[r][c] = rng.rand(-100..100)
                else:
                    matrix[r][c] = matrix[r - 1][c] + matrix[r][c - 1] -
                        matrix[r - 1][c - 1] - rng.rand(0..8)
        var available = 0
        proc better(row, oldCol, newCol: int): bool =
            doAssert oldCol <= row and newCol <= row
            doAssert oldCol <= available and newCol <= available
            matrix[row][newCol] < matrix[row][oldCol]
        var search = initLarsch(n, better)
        for row in 0..<n:
            var expected = 0
            for col in 1..row:
                if matrix[row][col] < matrix[row][expected]: expected = col
            doAssert search.next() == expected
            inc available

# 単調に増える permutation の inversion 集合で全単調だが非 Monge な行列も生成する。
for n in 1..70:
    for rep in 0..<8:
        var matrix = newSeq[seq[int]](n)
        var order = newSeq[int](n)
        for c in 0..<n: order[c] = c
        for row in 0..<n:
            for turn in 0..<n:
                if n < 2: break
                let p = rng.rand(0..n - 2)
                if order[p] < order[p + 1]: swap(order[p], order[p + 1])
            matrix[row] = newSeq[int](n)
            var value = rng.rand(-50..50)
            for p in 0..<n:
                if p > 0:
                    # 同値 group の列順は昇順にして、左端 tie の inversion を増やさない。
                    value += rng.rand(0..5) + int(order[p - 1] > order[p])
                matrix[row][order[p]] = value
        for r in 0..<n:
            for s in r + 1..<n:
                for a in 0..r:
                    for b in a + 1..r:
                        doAssert not (matrix[r][b] < matrix[r][a]) or
                            matrix[s][b] < matrix[s][a]
        var available = 0
        proc better(row, oldCol, newCol: int): bool =
            doAssert 0 <= row and row < n
            doAssert 0 <= oldCol and oldCol <= min(row, available)
            doAssert 0 <= newCol and newCol <= min(row, available)
            matrix[row][newCol] < matrix[row][oldCol]
        var search = initLarsch(n, better)
        var expected = newSeq[int](n + 1)
        var parents = newSeq[int](n + 1)
        parents[0] = -1
        for row in 0..<n:
            var best = 0
            for col in 1..row:
                if matrix[row][col] < matrix[row][best]: best = col
            doAssert search.next() == best
            expected[row + 1] = matrix[row][best]
            parents[row + 1] = best
            inc available
        proc checkedTransition(to, source, finalized: int): int =
            doAssert source < to
            doAssert finalized == expected[source]
            matrix[to - 1][source]
        let dp = onlineTotallyMonotoneDP(n + 1, 0, checkedTransition)
        doAssert dp.costs == expected and dp.prev == parents

for n in [0, 1, 2, 3, 7, 8, 9, 63, 64, 65, 1023, 1024, 1025, 100000]:
    for mode in 0..2:
        var calls = 0
        var available = 0
        proc value(row, col: int): int64 =
            case mode
            of 0: 0'i64
            of 1: -int64(col)
            else: int64(row - col) * int64(row - col)
        proc better(row, oldCol, newCol: int): bool =
            inc calls
            doAssert oldCol <= available and newCol <= available
            doAssert oldCol <= row and newCol <= row
            value(row, newCol) < value(row, oldCol)
        var search = initLarsch(n, better)
        for row in 0..<n:
            let answer = if mode == 0: 0 else: row
            doAssert search.next() == answer
            inc available
        doAssert calls < 20 * max(n, 1)
        var exhausted = false
        try: discard search.next()
        except AssertionDefect: exhausted = true
        doAssert exhausted

block:
    var rejected = 0
    proc compare(row, oldCol, newCol: int): bool = false
    try: discard initLarsch(-1, compare)
    except AssertionDefect: inc rejected
    var uninitialized: Larsch
    try: discard uninitialized.next()
    except AssertionDefect: inc rejected
    proc noTransition(to, source, finalized: int): int =
        doAssert false
    doAssert onlineTotallyMonotoneDP(0, 42, noTransition).costs.len == 0
    doAssert onlineTotallyMonotoneDP(1, 42, noTransition).costs == @[42]
    try: discard onlineTotallyMonotoneDP(-1, 42, noTransition)
    except AssertionDefect: inc rejected
    doAssert rejected == 3

echo "Hello World"
