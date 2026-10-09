# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, sets, strutils
import atcoder/modint
import cplib/math/twelvefold_way

type
    OracleCounts = TwelvefoldCounts[int]

proc enumerateCounts(n, m: int): OracleCounts =
    var configurations: array[BallKind, array[BoxKind,
        array[MappingConstraint, HashSet[string]]]]
    var assignment = newSeq[int](n)
    proc visit(i: int) =
        if i < n:
            for box in 0..<m:
                assignment[i] = box
                visit(i + 1)
            return
        var occupancy = newSeq[int](m)
        var labels = newSeq[int](m)
        var normalized: seq[int]
        var nextLabel = 0
        for box in assignment:
            inc occupancy[box]
            if labels[box] == 0:
                inc nextLabel
                labels[box] = nextLabel
            normalized.add(labels[box])
        var sortedOccupancy = occupancy
        sortedOccupancy.sort()
        var onePerBox = true
        var allUsed = true
        for size in occupancy:
            if size > 1: onePerBox = false
            if size == 0: allUsed = false
        for balls in BallKind:
            for boxes in BoxKind:
                let key = if balls == distinctBalls:
                    (if boxes == distinctBoxes: assignment.join(",") else: normalized.join(","))
                else:
                    (if boxes == distinctBoxes: occupancy.join(",") else: sortedOccupancy.join(","))
                configurations[balls][boxes][unrestricted].incl(key)
                if onePerBox: configurations[balls][boxes][injective].incl(key)
                if allUsed: configurations[balls][boxes][surjective].incl(key)
    visit(0)
    for balls in BallKind:
        for boxes in BoxKind:
            for restriction in MappingConstraint:
                result[balls][boxes][restriction] = configurations[balls][boxes][restriction].len

var smallOracle: array[7, array[7, OracleCounts]]
for n in 0..6:
    for m in 0..6:
        smallOracle[n][m] = enumerateCounts(n, m)

template rejects(body: untyped) =
    block:
        var rejected = false
        try:
            body
        except ValueError:
            rejected = true
        doAssert rejected

proc checkSmall[Mint](maxN, maxM: int) =
    let c = initTwelvefoldWay[Mint](maxN, maxM)
    for n in 0..min(6, maxN):
        for m in 0..min(6, maxM):
            let all = c.countAll(n, m)
            for balls in BallKind:
                for boxes in BoxKind:
                    for restriction in MappingConstraint:
                        let expected: Mint = smallOracle[n][m][balls][boxes][restriction]
                        doAssert all[balls][boxes][restriction] == expected
                        doAssert c.count(n, m, balls, boxes, restriction) == expected
                    doAssert c.count(n, m, balls, boxes) == all[balls][boxes][unrestricted]
            let expectedS: Mint = smallOracle[n][m][distinctBalls][identicalBoxes][surjective]
            let expectedP: Mint = smallOracle[n][m][identicalBalls][identicalBoxes][surjective]
            doAssert c.stirlingSecond(n, m) == expectedS
            doAssert c.partitionCount(n, m) == expectedP
    rejects: discard c.countAll(-1, 0)
    rejects: discard c.countAll(0, -1)
    rejects: discard c.countAll(maxN + 1, 0)
    rejects: discard c.stirlingSecond(0, maxM + 1)
    rejects: discard c.partitionCount(-1, 0)
    rejects: discard initTwelvefoldWay[Mint](-1, 0)
    rejects: discard initTwelvefoldWay[Mint](0, -1)
    rejects: discard initTwelvefoldWay[Mint](high(int), 1)
    rejects: discard initTwelvefoldWay[Mint](int(Mint.umod()), 0)
    var uninitialized: TwelvefoldWay[Mint]
    rejects: discard uninitialized.countAll(0, 0)

proc checkLarger[Mint]() =
    let c = initTwelvefoldWay[Mint](40, 40)
    var pascal: array[81, array[81, Mint]]
    pascal[0][0] = 1
    for i in 1..80:
        pascal[i][0] = 1
        for j in 1..i:
            pascal[i][j] = pascal[i - 1][j - 1] + pascal[i - 1][j]
    for n in 0..40:
        for m in 0..40:
            var onto: Mint = 0
            for used in 0..m:
                var power: Mint = 1
                for _ in 0..<n: power *= used
                let term = pascal[m][used] * power
                if (m - used) mod 2 == 0: onto += term
                else: onto -= term
            doAssert c.count(n, m, distinctBalls, distinctBoxes, surjective) == onto
            var factorial: Mint = 1
            for i in 1..m: factorial *= i
            doAssert c.stirlingSecond(n, m) * factorial == onto
            if m > 0:
                doAssert c.count(n, m, identicalBalls, distinctBoxes) == pascal[n + m - 1][n]
    for n in 0..20:
        var byParts: array[21, int]
        proc partitions(remaining, minimum, parts: int) =
            if remaining == 0:
                inc byParts[parts]
            else:
                for next in minimum..remaining:
                    partitions(remaining - next, next, parts + 1)
        partitions(n, 1, 0)
        var prefix = 0
        for m in 0..40:
            if m <= 20: prefix += byParts[m]
            let expected: Mint = if m <= 20: byParts[m] else: 0
            let expectedSum: Mint = prefix
            doAssert c.partitionCount(n, m) == expected
            doAssert c.count(n, m, identicalBalls, identicalBoxes) == expectedSum
    let size = min(400, (int(Mint.umod()) - 1) div 2)
    let medium = initTwelvefoldWay[Mint](size, size)
    let zero: Mint = 0
    let one: Mint = 1
    doAssert medium.stirlingSecond(size, size) == one
    doAssert medium.partitionCount(size, size) == one
    doAssert medium.count(size, 1, identicalBalls, identicalBoxes) == one
    doAssert medium.count(size - 1, size, distinctBalls, distinctBoxes, surjective) == zero

type AclMint = DynamicModInt[-1]
checkSmall[modint998244353](6, 6)
checkLarger[modint998244353]()
AclMint.setMod(101)
checkSmall[AclMint](6, 6)
checkLarger[AclMint]()
for p in [2, 3, 5, 7, 13]:
    AclMint.setMod(p)
    for maxN in 0..<p:
        for maxM in 0..<(p - maxN):
            checkSmall[AclMint](maxN, maxM)
    rejects: discard initTwelvefoldWay[AclMint](p - 1, 1)
for p in [1, 8, 25]:
    AclMint.setMod(p)
    rejects: discard initTwelvefoldWay[AclMint](0, 0)
AclMint.setMod(101)
let changed = initTwelvefoldWay[AclMint](6, 6)
AclMint.setMod(103)
rejects: discard changed.countAll(0, 0)
rejects: discard changed.stirlingSecond(1, 1)
rejects: discard changed.partitionCount(1, 1)
AclMint.setMod(101)
doAssert changed.count(3, 2, distinctBalls, distinctBoxes).val == 8

echo "Hello World"
