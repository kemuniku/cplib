# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/k_project_selection
import random

block:
    var opt = initKProjectSelection([], int64)
    opt.add_gain_if_all_ge([], 7)
    opt.add_gain_if_all_le([], 3)
    let ans = opt.solve()
    doAssert ans.feasible and ans.min_cost == -10 and ans.assignment.len == 0

block:
    var opt = initKProjectSelection(2, 3)
    doAssert opt is KProjectSelection[int]
    opt.add_unary_cost(0, [0, 3, 8])
    opt.add_unary_cost(1, [0, 4, 9])
    opt.add_gain_if_all_ge([(0, 2), (1, 1)], 20)
    let ans = opt.solve()
    doAssert ans.feasible and ans.min_cost == -8 and ans.assignment == @[2, 1]
    doAssert opt.solve() == ans
    opt.set_max(0, 1)
    doAssert opt.solve().min_cost == 0
    opt.force(0, 2)
    doAssert not opt.solve().feasible

block:
    var opt = initKProjectSelection([1, 3], int32)
    doAssert opt is KProjectSelection[int32]
    opt.add_pair_cost(0, 1, @[@[4'i32, -3, 2]])
    opt.add_pair_cost(1, 1, @[@[1'i32, -999, 999], @[999'i32, -5, -999], @[-999'i32, 999, 1]])
    doAssert opt.solve().assignment == @[0, 1]
    doAssert opt.solve().min_cost == -8

var rng = initRand(967231)
for trial in 0..<600:
    let n = rng.rand(1..4)
    var sizes = newSeq[int](n)
    var count = 1
    for i in 0..<n:
        sizes[i] = rng.rand(1..4)
        count *= sizes[i]
    var assignments = newSeq[seq[int]](count)
    for mask in 0..<count:
        var x = mask
        assignments[mask] = newSeq[int](n)
        for i in 0..<n:
            assignments[mask][i] = x mod sizes[i]
            x = x div sizes[i]
    var scores = newSeq[int64](count)
    var allowed = newSeq[bool](count)
    for v in allowed.mitems: v = true
    var opt = initKProjectSelection(sizes, int64)
    for step in 0..<25:
        let kind = rng.rand(0..(if trial mod 2 == 0: 6 else: 10))
        let i = rng.rand(n - 1)
        let j = rng.rand(n - 1)
        let value = rng.rand(sizes[i] - 1)
        let lowerI = rng.rand(sizes[i])
        let lowerJ = rng.rand(sizes[j])
        let w = int64(rng.rand((if kind in {1, 2}: -15 else: 0)..15))
        var unary = newSeq[int64](sizes[i])
        var pair: seq[seq[int64]]
        var conditions: seq[tuple[variable, threshold: int]]
        case kind
        of 0:
            for c in unary.mitems: c = int64(rng.rand(-15..15))
            opt.add_unary_cost(i, unary)
        of 1: opt.add_cost(i, value, w)
        of 2: opt.add_gain(i, value, w)
        of 3:
            pair = newSeq[seq[int64]](sizes[i])
            for a in 0..<sizes[i]:
                pair[a] = newSeq[int64](sizes[j])
                pair[a][0] = int64(rng.rand(-15..15))
            for b in 1..<sizes[j]: pair[0][b] = int64(rng.rand(-15..15))
            for a in 1..<sizes[i]:
                for b in 1..<sizes[j]:
                    pair[a][b] = pair[a - 1][b] + pair[a][b - 1] - pair[a - 1][b - 1] - int64(rng.rand(0..8))
            opt.add_pair_cost(i, j, pair)
        of 4: opt.add_cost_if_ge_lt(i, lowerI, j, lowerJ, w)
        of 5, 6:
            for c in 0..<rng.rand(0..n + 2):
                let v = rng.rand(n - 1)
                let t = rng.rand(sizes[v]) - (if kind == 6: 1 else: 0)
                conditions.add((v, t))
            if kind == 5: opt.add_gain_if_all_ge(conditions, w)
            else: opt.add_gain_if_all_le(conditions, w)
        of 7: opt.set_min(i, lowerI)
        of 8: opt.set_max(i, lowerI - 1)
        of 9: opt.force(i, value)
        else: opt.imply(i, lowerI, j, lowerJ)
        for mask, x in assignments:
            case kind
            of 0: scores[mask] += unary[x[i]]
            of 1:
                if x[i] == value: scores[mask] += w
            of 2:
                if x[i] == value: scores[mask] -= w
            of 3: scores[mask] += pair[x[i]][x[j]]
            of 4:
                if x[i] >= lowerI and x[j] < lowerJ: scores[mask] += w
            of 5, 6:
                var matches = true
                for c in conditions:
                    if kind == 5 and x[c.variable] < c.threshold: matches = false
                    if kind == 6 and x[c.variable] > c.threshold: matches = false
                if matches: scores[mask] -= w
            of 7: allowed[mask] = allowed[mask] and x[i] >= lowerI
            of 8: allowed[mask] = allowed[mask] and x[i] < lowerI
            of 9: allowed[mask] = allowed[mask] and x[i] == value
            else: allowed[mask] = allowed[mask] and (x[i] < lowerI or x[j] >= lowerJ)
        if step mod 5 == 0 or step == 24:
            var best = high(int64)
            for mask in 0..<count:
                if allowed[mask]: best = min(best, scores[mask])
            let ans = opt.solve()
            doAssert ans.feasible == (best != high(int64))
            if ans.feasible:
                doAssert ans.min_cost == best
                doAssert ans.assignment.len == n
                var mask = 0
                var multiplier = 1
                for v in 0..<n:
                    doAssert ans.assignment[v] in 0..<sizes[v]
                    mask += ans.assignment[v] * multiplier
                    multiplier *= sizes[v]
                doAssert allowed[mask] and scores[mask] == best
            doAssert opt.solve() == ans

template expectError(errorType: typedesc, body: untyped) =
    block:
        var caught = false
        try: body
        except errorType: caught = true
        doAssert caught

block:
    expectError(ValueError): discard initKProjectSelection([0])
    expectError(ValueError): discard initKProjectSelection(-1, 2)
    expectError(ValueError): discard initKProjectSelection(0, 0)
    var opt = initKProjectSelection([2, 3], int64)
    expectError(ValueError): opt.add_unary_cost(0, [1'i64])
    expectError(ValueError): opt.add_cost(0, 2, 1)
    expectError(OverflowDefect): opt.add_gain(0, 1, low(int64))
    expectError(ValueError): opt.add_pair_cost(0, 1, @[@[0'i64, 0, 0]])
    expectError(ValueError): opt.add_pair_cost(0, 1, @[@[0'i64, 0, 0], @[0'i64, 0]])
    expectError(ValueError): opt.add_pair_cost(0, 1, @[@[0'i64, 0, 0], @[0'i64, 0, 1]])
    expectError(ValueError): opt.set_min(0, -1)
    expectError(ValueError): opt.set_min(0, 3)
    expectError(ValueError): opt.set_max(0, -2)
    expectError(ValueError): opt.set_max(0, 2)
    expectError(ValueError): opt.force(2, 0)
    expectError(ValueError): opt.add_gain_if_all_ge([(0, 1), (1, 4)], 7)
    expectError(ValueError): opt.add_gain_if_all_le([(0, 1)], -1)
    expectError(OverflowDefect): opt.add_unary_cost(0, [low(int64), high(int64)])
    expectError(OverflowDefect): opt.add_pair_cost(0, 1, @[@[low(int64), high(int64), 0], @[0'i64, 0, 0]])
    doAssert opt.solve().feasible and opt.solve().min_cost == 0

block:
    var opt = initKProjectSelection([1], int64)
    opt.add_unary_cost(0, [low(int64)])
    doAssert opt.solve().min_cost == low(int64)
    opt.add_gain(0, 0, 1)
    expectError(OverflowDefect): discard opt.solve()

block:
    var opt = initKProjectSelection([2], int64)
    opt.add_cost(0, 1, high(int64))
    expectError(OverflowDefect): discard opt.solve()

echo "Hello World"
