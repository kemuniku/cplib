# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import algorithm, random, sequtils, sets
import cplib/utils/subset_sum

proc enumerateSubsets(a: openArray[int]): seq[bool] =
    var total = 0
    for value in a:
        total += value
    result = newSeq[bool](total + 1)
    for mask in 0..<(1 shl a.len):
        var sum = 0
        for i, value in a:
            if (mask and (1 shl i)) != 0:
                sum += value
        result[sum] = true

proc ordinaryDP(a: openArray[int]): seq[bool] =
    var total = 0
    for value in a:
        total += value
    result = newSeq[bool](total + 1)
    result[0] = true
    for value in a:
        for sum in countdown(total, value):
            result[sum] = result[sum] or result[sum - value]

var queries = 0
proc check(a: seq[int], expected: seq[bool], allTargets = true) =
    let before = a.mapIt(it)
    if allTargets:
        for target in -1..expected.len:
            let reachable = target >= 0 and target < expected.len and expected[target]
            doAssert solve_subset_sum(a, target) == reachable, $a & " target=" & $target
            inc queries
    else:
        for target in [0, 1, expected.len div 2, expected.len - 1, expected.len]:
            let reachable = target < expected.len and expected[target]
            doAssert solve_subset_sum(a, target) == reachable, $a & " target=" & $target
            inc queries
    doAssert a == before

for n in 0..6:
    var count = 1
    for i in 0..<n:
        count *= 5
    for code in 0..<count:
        var a = newSeq[int](n)
        var digits = code
        for value in a.mitems:
            value = digits mod 5
            digits = digits div 5
        let expected = enumerateSubsets(a)
        doAssert ordinaryDP(a) == expected
        check(a, expected)

for a in [@[6, 4], @[4, 4, 5], @[9, 6, 4], @[8, 8, 3, 5],
          @[0, 12, 0, 6, 0, 12, 5, 0, 1], @[3, 3, 3, 3],
          @[2, 5, 2, 5, 2, 5], @[11, 1, 10, 2, 9, 3, 8, 4],
          @[1, 2, 4, 8, 16, 32, 64]]:
    check(a, enumerateSubsets(a))
    check(a.reversed(), enumerateSubsets(a))

var rng = initRand(4462026)
for trial in 0..<600:
    var a = newSeq[int](rng.rand(0..12))
    for value in a.mitems:
        value = rng.rand(0..35)
    let expected = enumerateSubsets(a)
    doAssert ordinaryDP(a) == expected
    check(a, expected)
    rng.shuffle(a)
    check(a, expected)
    var padded: seq[int]
    for value in a:
        padded.add(0)
        padded.add(value)
        padded.add(high(int))
    check(padded, expected)

for trial in 0..<120:
    var a = newSeq[int](rng.rand(20..100))
    for value in a.mitems:
        value = rng.rand(0..70)
    let expected = ordinaryDP(a)
    check(a, expected, allTargets = false)
    for i in 0..<40:
        let target = rng.rand(0..expected.len)
        doAssert solve_subset_sum(a, target) == (target < expected.len and expected[target])
        inc queries
    check(a.reversed(), expected, allTargets = false)

let backing = [999, 6, 4, 999]
doAssert solve_subset_sum(backing.toOpenArray(1, 2), 4)
doAssert not solve_subset_sum(backing.toOpenArray(1, 2), 5)
doAssert solve_subset_sum(newSeq[int](), 0)
doAssert not solve_subset_sum(newSeq[int](), high(int))
doAssert not solve_subset_sum([0, 0], low(int))
doAssert not solve_subset_sum([0, 0], 1)
doAssert not solve_subset_sum([2, 3], high(int))
doAssert solve_subset_sum([high(int), high(int)], high(int))
doAssert solve_subset_sum([0, high(int), 2, 3, high(int)], 5)
doAssert not solve_subset_sum([high(int), 2, 2], 3)
doAssert solve_subset_sum([high(int) - 1, 1], high(int))
doAssert solve_subset_sum([high(int) - 1, 2], high(int) - 1)
doAssert not solve_subset_sum([high(int) div 2 + 1, high(int) div 2 + 1], high(int))
doAssert solve_subset_sum([high(int) div 2, high(int) div 2, 1], high(int))

proc expectValueError(a: openArray[int], target: int) =
    var caught = false
    try:
        discard solve_subset_sum(a, target)
    except ValueError:
        caught = true
    doAssert caught

for target in [low(int), -1, 0, 1, high(int)]:
    expectValueError([1, -1], target)
    expectValueError([low(int), high(int)], target)
expectValueError([high(int) - 1, 2], high(int))
let tooWide = (high(int) div sizeof(int)) div 4 + 1
expectValueError([tooWide, tooWide - 1], tooWide + 1)

block:
    var even = newSeqWith(2000, 1800)
    even[^1] = 1798
    doAssert not solve_subset_sum(even, 1800001)
    doAssert solve_subset_sum(even, 1800000)
    doAssert solve_subset_sum(even, 1799998)
    even.reverse()
    doAssert not solve_subset_sum(even, 1800001)
    doAssert solve_subset_sum(even, 1800000)
    var large = newSeqWith(5000, 5000)
    large[^1] = 4998
    doAssert not solve_subset_sum(large, 12500001)
    doAssert solve_subset_sum(large, 12500000)
    var many = newSeqWith(100000, 2)
    many[^1] = 4
    doAssert not solve_subset_sum(many, 100001)
    doAssert solve_subset_sum(many, 100000)

proc canJump(d: openArray[int], x, y: int): bool =
    var total = 0
    for distance in d:
        total += distance
    for rotated in [x + y, x - y]:
        if rotated < -total or rotated > total or (total + rotated) mod 2 != 0:
            return false
        if not solve_subset_sum(d, (total + rotated) div 2):
            return false
    return true

doAssert canJump([1, 2, 3], 2, -2)
doAssert not canJump([1, 6], 1, 0)
doAssert canJump([1, 3, 5, 7, 9], 6, 7)
for trial in 0..<100:
    var d = newSeq[int](rng.rand(0..7))
    var total = 0
    for distance in d.mitems:
        distance = rng.rand(1..10)
        total += distance
    var endpoints = initHashSet[(int, int)]()
    endpoints.incl((0, 0))
    for distance in d:
        var after = initHashSet[(int, int)]()
        for (x, y) in endpoints:
            after.incl((x + distance, y))
            after.incl((x - distance, y))
            after.incl((x, y + distance))
            after.incl((x, y - distance))
        endpoints = after
    for i in 0..<50:
        let x = rng.rand(-total - 2..total + 2)
        let y = rng.rand(-total - 2..total + 2)
        doAssert canJump(d, x, y) == ((x, y) in endpoints)

stderr.writeLine("subset_sum oracle queries: ", queries)
echo "Hello World"
