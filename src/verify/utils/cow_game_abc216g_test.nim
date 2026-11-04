# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
# https://atcoder.jp/contests/abc216/tasks/abc216_g
import random, sequtils, strutils
import cplib/utils/cow_game

type Interval = tuple[left, right, count: int]

proc construct(n: int, intervals: seq[Interval], algorithm = cowDijkstra): seq[int] =
    let p = initCowGame(algorithm)
    let b = newSeqWith(n + 1, p.get_Variable())
    for i in 0..<n:
        p += b[i] <= b[i+1]
        p += b[i+1] <= b[i] + 1
    p += b[0] <= 0
    for c in intervals: p += b[c.right] - b[c.left] <= c.right - c.left - c.count
    doAssert p.maximizeVariables() == cowFinite
    for i in 0..<n: result.add((b[i+1].get_value() - b[i].get_value()) xor 1)

proc validate(a: seq[int], intervals: seq[Interval], expectedOnes: int) =
    for x in a: doAssert x == 0 or x == 1
    for c in intervals:
        var ones = 0
        for i in c.left..<c.right: ones += a[i]
        doAssert ones >= c.count
    doAssert a.foldl(a + b, 0) == expectedOnes

proc brute(n: int, intervals: seq[Interval]): int =
    result = n
    for mask in 0..<(1 shl n):
        var valid = true
        for c in intervals:
            var ones = 0
            for i in c.left..<c.right: ones += (mask shr i) and 1
            if ones < c.count: valid = false
        if valid:
            var ones = 0
            for i in 0..<n: ones += (mask shr i) and 1
            result = min(result, ones)

when defined(cowGameAbc216gStandalone):
    let nm = stdin.readLine().splitWhitespace().map(parseInt)
    var intervals: seq[Interval]
    for i in 0..<nm[1]:
        let lrx = stdin.readLine().splitWhitespace().map(parseInt)
        intervals.add((lrx[0] - 1, lrx[1], lrx[2]))
    echo construct(nm[0], intervals).join(" ")
else:
    for algorithm in [cowDijkstra, cowBellmanFord]:
        let first: seq[Interval] = @[(0, 4, 3), (1, 2, 1), (3, 6, 2)]
        validate(construct(6, first, algorithm), first, 4)
        let second: seq[Interval] = @[(1, 6, 1), (2, 5, 3)]
        validate(construct(8, second, algorithm), second, 3)
        var rng = initRand(216710)
        for trial in 0..<300:
            let n = rng.rand(1..10)
            var intervals: seq[Interval]
            for i in 0..<rng.rand(0..12):
                let left = rng.rand(n-1)
                let right = rng.rand(left+1..n)
                intervals.add((left, right, rng.rand(0..right-left)))
            validate(construct(n, intervals, algorithm), intervals, brute(n, intervals))
    block:
        let p = makeProblem()
        let n = 3
        let b = newSeqWith(n + 2, p.get_Variable())
        for i in 0..<n:
            p += b[i] <= b[i+1]
            p += b[i+1] <= b[i] + 1
        p += b[0] <= 0
        doAssert p.maximizeVariables() == cowUnbounded
        doAssert p.maximize(b[n]).value == n
        doAssert p.maximize(b[n+1]).status == cowUnbounded
    block:
        let n = 200_000
        let intervals: seq[Interval] = @[(0, n, 100_000)]
        validate(construct(n, intervals), intervals, 100_000)
    echo "Hello World"
