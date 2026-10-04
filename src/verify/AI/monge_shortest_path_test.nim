# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/monge_shortest_path
import random, algorithm

const inf = high(int64)
var rng = initRand(732417)

proc naive(matrix: seq[seq[int64]], start: int): tuple[costs: seq[int64],
        prev: seq[int]] =
    let n = matrix.len
    result.costs = newSeq[int64](n)
    result.prev = newSeq[int](n)
    result.costs.fill(inf)
    result.prev.fill(-1)
    if n == 0: return
    result.costs[start] = 0
    for j in start + 1..<n:
        for i in start..<j:
            let candidate = result.costs[i] + matrix[i][j]
            if candidate < result.costs[j]:
                result.costs[j] = candidate
                result.prev[j] = i

proc naiveExact(matrix: seq[seq[int64]], start, k: int):
        tuple[costs: seq[int64], prev: seq[seq[int]]] =
    let n = matrix.len
    result.costs = newSeq[int64](n)
    result.costs.fill(inf)
    if n == 0 or k >= n - start: return
    result.costs[start] = 0
    result.prev = newSeq[seq[int]](k + 1)
    for layer in 0..k:
        result.prev[layer] = newSeq[int](n)
        result.prev[layer].fill(-1)
    for layer in 1..k:
        var nextCosts = newSeq[int64](n)
        nextCosts.fill(inf)
        for j in 0..<n:
            for i in 0..<j:
                if result.costs[i] == inf: continue
                let candidate = result.costs[i] + matrix[i][j]
                if candidate < nextCosts[j]:
                    nextCosts[j] = candidate
                    result.prev[layer][j] = i
        result.costs = nextCosts

proc check(matrix: seq[seq[int64]], start: int) =
    let n = matrix.len
    proc cost(i, j: int): int64 =
        doAssert start <= i and i < j and j < n
        matrix[i][j]
    let expected = naive(matrix, start)
    let actual = mongeShortestPaths(n, cost, 0'i64, inf, start)
    doAssert actual.costs == expected.costs
    doAssert actual.prev == expected.prev
    for goal in 0..<n:
        let path = actual.pathTo(goal)
        if goal < start: doAssert path.len == 0
        else:
            doAssert path[0] == start and path[^1] == goal
            var weight = 0'i64
            for p in 1..<path.len:
                doAssert path[p - 1] < path[p]
                weight += matrix[path[p - 1]][path[p]]
            doAssert weight == actual.costs[goal]
    for k in 0..n + 1:
        let oracle = naiveExact(matrix, start, k)
        let exact = restoreMongeShortestPathsExactEdges(n, k, cost, 0'i64, inf, start)
        doAssert exact.costs == oracle.costs
        doAssert exact.prev == oracle.prev
        doAssert mongeShortestPathsExactEdges(n, k, cost, 0'i64, inf, start) == oracle.costs
        for goal in 0..<n:
            let path = exact.pathTo(goal)
            if oracle.costs[goal] == inf: doAssert path.len == 0
            else:
                doAssert path.len == k + 1
                doAssert path[0] == start and path[^1] == goal
                var weight = 0'i64
                for p in 1..<path.len:
                    doAssert path[p - 1] < path[p]
                    weight += matrix[path[p - 1]][path[p]]
                doAssert weight == oracle.costs[goal]

for n in 0..35:
    for rep in 0..<8:
        var matrix = newSeq[seq[int64]](n)
        for i in 0..<n:
            matrix[i] = newSeq[int64](n)
            for j in 0..<n:
                if i == 0 or j == 0: matrix[i][j] = rng.rand(-20..20)
                else:
                    matrix[i][j] = matrix[i - 1][j] + matrix[i][j - 1] -
                        matrix[i - 1][j - 1] - int64(rng.rand(0..10))
        if n == 0: check(matrix, 0)
        else:
            for start in [0, n div 2, n - 1]: check(matrix, start)

# 三角領域の条件だけで十分な小グラフを全列挙する (下三角は未定義)。
for n in 1..4:
    let edges = n * (n - 1) div 2
    var possibilities = 1
    for i in 0..<edges: possibilities *= 3
    for mask in 0..<possibilities:
        var matrix = newSeq[seq[int64]](n)
        var code = mask
        for i in 0..<n:
            matrix[i] = newSeq[int64](n)
            for j in i + 1..<n:
                matrix[i][j] = int64(code mod 3 - 1)
                code = code div 3
        if n == 4 and matrix[0][2] + matrix[1][3] > matrix[0][3] + matrix[1][2]: continue
        for start in 0..<n: check(matrix, start)

for n in 0..20:
    for mode in 0..3:
        var matrix = newSeq[seq[int64]](n)
        for i in 0..<n:
            matrix[i] = newSeq[int64](n)
            for j in i + 1..<n:
                case mode
                of 0: matrix[i][j] = 0
                of 1: matrix[i][j] = -7
                of 2: matrix[i][j] = 7
                else: matrix[i][j] = int64(j - i)
        if n == 0: check(matrix, 0)
        else:
            for start in 0..<n: check(matrix, start)

block:
    proc cost(i, j: int): int64 = low(int64) div 3
    let paths = mongeShortestPaths(3, cost, 0'i64, inf)
    doAssert paths.costs == @[0'i64, low(int64) div 3, 2 * (low(int64) div 3)]
    let exact = restoreMongeShortestPathsExactEdges(3, 2, cost, 0'i64, inf)
    doAssert exact.costs == @[inf, inf, 2 * (low(int64) div 3)]
    doAssert exact.pathTo(2) == @[0, 1, 2]
    proc highCost(i, j: int): int64 = (high(int64) - 1) div 3
    doAssert mongeShortestPathsExactEdges(3, 2, highCost, 0'i64, inf)[2] ==
        2 * ((high(int64) - 1) div 3)

block:
    proc cost(i, j: int): float64 = float64((j - i) * (j - i)) - 0.5
    let paths = mongeShortestPaths(5, cost, 0.0, Inf)
    doAssert paths.costs[4] == 2.0
    doAssert paths.pathTo(4) == @[0, 1, 2, 3, 4]
    doAssert mongeShortestPathsExactEdges(5, 2, cost, 0.0, Inf)[4] == 7.0
    proc smallCost(i, j: int): int32 = int32((j - i) * (j - i))
    doAssert mongeShortestPaths(5, smallCost, 0'i32, high(int32)).costs[4] == 4'i32

block:
    let n = 100000
    var calls = 0
    proc cost(i, j: int): int64 =
        doAssert 0 <= i and i < j and j < n
        inc calls
        let gap = int64(j - i)
        gap * gap - 3
    let paths = mongeShortestPaths(n, cost, 0'i64, inf)
    for j in 0..<n:
        doAssert paths.costs[j] == -2 * int64(j)
        doAssert paths.prev[j] == j - 1
    doAssert paths.pathTo(n - 1).len == n
    doAssert calls < 30 * n
    calls = 0
    let k = 12
    let exact = mongeShortestPathsExactEdges(n, k, cost, 0'i64, inf)
    for j in 0..<n:
        if j < k: doAssert exact[j] == inf
        else:
            let q = int64(j div k)
            let r = int64(j mod k)
            doAssert exact[j] == (int64(k) - r) * q * q + r * (q + 1) * (q +
                    1) - 3 * int64(k)
    doAssert calls < 30 * k * n
    proc forbidden(i, j: int): int64 =
        doAssert false
    doAssert mongeShortestPathsExactEdges(n, high(int), forbidden, 0'i64, inf)[
            ^1] == inf
    doAssert mongeShortestPathsExactEdges(n, 0, forbidden, 0'i64, inf)[0] == 0

block:
    proc cost(i, j: int): int = 0
    var rejected = 0
    try: discard mongeShortestPaths(-1, cost, 0, high(int))
    except AssertionDefect: inc rejected
    try: discard mongeShortestPaths(0, cost, 0, high(int), 1)
    except AssertionDefect: inc rejected
    try: discard mongeShortestPaths(2, cost, 0, high(int), 2)
    except AssertionDefect: inc rejected
    try: discard mongeShortestPathsExactEdges(2, -1, cost, 0, high(int))
    except AssertionDefect: inc rejected
    let paths = mongeShortestPaths(1, cost, 0, high(int))
    try: discard paths.pathTo(-1)
    except AssertionDefect: inc rejected
    doAssert rejected == 5

echo "Hello World"
