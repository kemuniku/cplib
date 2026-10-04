# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/graph/hungarian

type OracleInteger = array[4, int64]
const decimalBase = 1000000000'i64

proc oracleAdd(a: OracleInteger, b: int64): OracleInteger =
    result = a
    var rest = b
    for i in 0..2:
        result[i] += rest mod decimalBase
        rest = rest div decimalBase
    for i in 0..2:
        var carry = result[i] div decimalBase
        result[i] = result[i] mod decimalBase
        if result[i] < 0:
            result[i] += decimalBase
            dec carry
        result[i + 1] += carry

proc oracleValue(x: int64): OracleInteger =
    oracleAdd(default(OracleInteger), x)

proc oracleLess(a, b: OracleInteger): bool =
    for i in countdown(3, 0):
        if a[i] != b[i]: return a[i] < b[i]

proc brute(cost: seq[seq[int64]], allowed: seq[seq[bool]]): tuple[feasible: bool, cost: OracleInteger] =
    let n = cost.len
    let m = if n == 0: 0 else: cost[0].len
    var used = newSeq[bool](m)
    var found = false
    var best: OracleInteger
    proc enumerate(row: int, total: OracleInteger) =
        if row == n:
            if not found or oracleLess(total, best): best = total
            found = true
            return
        for col in 0..<m:
            if not used[col] and (allowed.len == 0 or allowed[row][col]):
                used[col] = true
                enumerate(row + 1, oracleAdd(total, cost[row][col]))
                used[col] = false
    enumerate(0, default(OracleInteger))
    (found, best)

proc check(cost: seq[seq[int64]], allowed: seq[seq[bool]] = @[]) =
    let expected = brute(cost, allowed)
    let outside = expected.feasible and (oracleLess(expected.cost, oracleValue(low(int64))) or
        oracleLess(oracleValue(high(int64)), expected.cost))
    var answer: MinCostAssignmentResult
    var overflowed = false
    try:
        answer = min_cost_assignment(cost, allowed)
    except OverflowDefect:
        overflowed = true
    doAssert overflowed == outside
    if outside: return
    doAssert answer.feasible == expected.feasible
    if not expected.feasible:
        doAssert answer.cost == 0 and answer.columnOfRow.len == 0
        return
    doAssert oracleValue(answer.cost) == expected.cost
    doAssert answer.columnOfRow.len == cost.len
    let m = if cost.len == 0: 0 else: cost[0].len
    var used = newSeq[bool](m)
    var restored: OracleInteger
    for row, col in answer.columnOfRow:
        doAssert col in 0..<m and not used[col]
        doAssert allowed.len == 0 or allowed[row][col]
        used[col] = true
        restored = oracleAdd(restored, cost[row][col])
    doAssert restored == expected.cost
    let repeated = min_cost_assignment(cost, allowed)
    doAssert repeated.feasible == answer.feasible and repeated.cost == answer.cost
    doAssert repeated.columnOfRow == answer.columnOfRow

template rejectsValueError(body: untyped) =
    block:
        var rejected = false
        try: body
        except ValueError: rejected = true
        doAssert rejected

static:
    doAssert not compiles(min_cost_assignment(@[@[1.0]]))
    doAssert not compiles(min_cost_assignment(@[@[1'u64]]))

check(@[])
check(@[newSeq[int64]()])
check(@[newSeq[int64](), newSeq[int64]()])
check(@[@[4'i64, 1, 3], @[2'i64, 0, 5], @[3'i64, 2, 2]])
check(@[@[-4'i64, 2, 3, 0], @[1'i64, -2, 5, 3]])
check(@[@[0'i64, 0], @[0'i64, 0], @[0'i64, 0]])
check(@[@[1'i64, 2, 3], @[4'i64, 5, 6]], @[@[true, false, false], @[true, false, false]])
check(@[@[1'i64, 9, 8], @[0'i64, 2, 3]], @[@[true, true, false], @[true, false, true]])
rejectsValueError:
    discard min_cost_assignment(@[@[1], @[2, 3]])
rejectsValueError:
    discard min_cost_assignment(@[@[1, 2]], @[@[true]])
rejectsValueError:
    discard min_cost_assignment(@[@[1]], @[@[true], @[false]])
rejectsValueError:
    discard min_cost_assignment(newSeq[seq[int]](), @[@[true]])
doAssert min_cost_assignment(@[@[low(int8), high(int8)]]).cost == int64(low(int8))
doAssert min_cost_assignment(@[@[low(int16), high(int16)]]).cost == int64(low(int16))
doAssert min_cost_assignment(@[@[low(int32), high(int32)]]).cost == int64(low(int32))
doAssert min_cost_assignment(@[@[low(int), high(int)]]).cost == int64(low(int))

let extremes = @[low(int64), low(int64) + 1, -1'i64, 0'i64, 1'i64, high(int64) - 1, high(int64)]
for a in extremes:
    check(@[@[a]])
    for b in extremes:
        for c in extremes:
            for d in extremes:
                check(@[@[a, b], @[c, d]])
check(@[@[high(int64), low(int64)], @[high(int64), low(int64)]])
check(@[@[low(int64), 0'i64, 0'i64], @[0'i64, low(int64), 0'i64], @[0'i64, 0'i64, high(int64)]],
      @[@[true, false, false], @[false, true, false], @[false, false, true]])
check(@[@[high(int64), 0'i64, 0'i64], @[0'i64, high(int64), 0'i64], @[0'i64, 0'i64, low(int64)]],
      @[@[true, false, false], @[false, true, false], @[false, false, true]])
check(@[@[low(int64), 0'i64, 0'i64, 0'i64], @[0'i64, low(int64), 0'i64, 0'i64],
        @[0'i64, 0'i64, high(int64), 0'i64], @[0'i64, 0'i64, 0'i64, high(int64)]],
      @[@[true, false, false, false], @[false, true, false, false],
        @[false, false, true, false], @[false, false, false, true]])

block:
    let n = 128
    var cost = newSeq[seq[int64]](n)
    var allowed = newSeq[seq[bool]](n)
    for row in 0..<n:
        cost[row] = newSeq[int64](n)
        allowed[row] = newSeq[bool](n)
        if row < n - 1:
            cost[row][row] = low(int64)
            allowed[row][row] = true
        let next = (row + 1) mod n
        cost[row][next] = if row mod 2 == 0: high(int64) else: low(int64)
        allowed[row][next] = true
    check(cost, allowed)
    doAssert min_cost_assignment(cost, allowed).cost == -64

for code in 0..<4096:
    var cost = @[@[0'i64, 0, 0], @[0'i64, 0, 0]]
    var allowed = @[@[false, false, false], @[false, false, false]]
    var rest = code
    for row in 0..<2:
        for col in 0..<3:
            let digit = rest mod 4
            rest = rest div 4
            allowed[row][col] = digit != 0
            cost[row][col] = int64(digit - 2)
    check(cost, allowed)

var rng = initRand(538)
for trial in 0..<5000:
    let n = rng.rand(1..5)
    let m = rng.rand(0..7)
    var cost = newSeq[seq[int64]](n)
    var allowed = newSeq[seq[bool]](n)
    for row in 0..<n:
        cost[row] = newSeq[int64](m)
        allowed[row] = newSeq[bool](m)
        for col in 0..<m:
            cost[row][col] = if trial mod 3 == 0: extremes[rng.rand(extremes.high)] else: int64(rng.rand(-100..100))
            allowed[row][col] = rng.rand(3) != 0
    check(cost, if trial mod 2 == 0: allowed else: @[])

block:
    var cost = @[@[3, 1, 2], @[4, 5, -6]]
    var allowed = @[@[true, true, true], @[true, true, true]]
    let before = @[@[3, 1, 2], @[4, 5, -6]]
    let answer = min_cost_assignment(cost, allowed)
    doAssert cost == before and allowed == @[@[true, true, true], @[true, true, true]]
    cost[0][1] = 100
    allowed[1][2] = false
    doAssert answer.cost == -5 and answer.columnOfRow == @[1, 2]

block:
    let n = 180
    let m = 260
    var cost = newSeq[seq[int64]](n)
    var allowed = newSeq[seq[bool]](n)
    for row in 0..<n:
        cost[row] = newSeq[int64](m)
        allowed[row] = newSeq[bool](m)
        for col in 0..<m:
            cost[row][col] = int64(col * col - row)
            allowed[row][col] = true
    let answer = min_cost_assignment(cost)
    var expected = 0'i64
    for row in 0..<n: expected += int64(row * row - row)
    doAssert answer.feasible and answer.cost == expected
    doAssert min_cost_assignment(cost, allowed).cost == expected
    for row in 0..<n:
        for col in 0..<m: allowed[row][col] = col < n - 1
    doAssert not min_cost_assignment(cost, allowed).feasible

echo "Hello World"
