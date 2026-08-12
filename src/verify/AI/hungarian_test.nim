# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/[algorithm, random, sequtils]
import cplib/graph/hungarian

proc bruteForce(cost: seq[seq[int]]): int =
    let n = cost.len
    if n == 0:
        return 0
    var columns = toSeq(0..<cost[0].len)
    result = int.high
    while true:
        var current = 0
        for i in 0..<n:
            current += cost[i][columns[i]]
        result = min(result, current)
        if not columns.nextPermutation():
            break

block:
    let cost = @[
        @[4, 1, 3],
        @[2, 0, 5],
        @[3, 2, 2]
    ]
    let (minCost, assignment) = hungarian(cost)
    assert minCost == 5
    assert assignment == @[1, 0, 2]

block:
    let cost = @[
        @[-4, 2, 3, 0],
        @[1, -2, 5, 3]
    ]
    let (minCost, assignment) = hungarian(cost)
    assert minCost == -6
    assert assignment == @[0, 1]

block:
    let empty: seq[seq[int]] = @[]
    assert hungarian(empty) == (min_cost: 0, assignment: newSeq[int]())

randomize(1234567)
for n in 1..5:
    for m in n..6:
        for _ in 0..<100:
            let cost = newSeqWith(n, newSeqWith(m, rand(-20..20)))
            let (minCost, assignment) = hungarian(cost)
            assert minCost == bruteForce(cost)
            assert assignment.deduplicate().len == n
            assert minCost == toSeq(0..<n).mapIt(cost[it][assignment[it]]).foldl(a + b)

block:
    let cost = @[@[1.5, -2.0, 3.0], @[2.0, 0.5, -1.0]]
    let (minCost, assignment) = hungarian(cost)
    assert abs(minCost - (-3.0)) < 1e-9
    assert assignment == @[1, 2]
