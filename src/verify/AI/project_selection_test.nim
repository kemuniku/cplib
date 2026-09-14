# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/project_selection
import random

block:
    var opt = initProjectSelection(0)
    doAssert opt is ProjectSelection[int]
    doAssert opt.solve().feasible
    opt.add_gain_if_all([], false, 7)
    let ans = opt.solve()
    doAssert ans.feasible and ans.min_cost == -7 and ans.assignment.len == 0

block:
    var opt = initProjectSelection(3, int64)
    doAssert opt is ProjectSelection[int64]
    opt.add_gain(0, true, 100)
    opt.add_cost(0, true, 30)
    opt.imply(0, 1)
    opt.add_cost_if_different(1, 2, 20)
    opt.add_gain_if_all(@[0, 1, 2], true, 50)
    let ans = opt.solve()
    doAssert ans.feasible and ans.min_cost == -120
    doAssert ans.assignment == @[true, true, true]
    doAssert opt.solve() == ans
    opt.force(2, false)
    doAssert opt.solve().min_cost == -50
    opt.force(0, true)
    opt.force(1, false)
    doAssert not opt.solve().feasible

block:
    var opt = initProjectSelection(1, int32)
    opt.add_pair_cost(0, 0, -4, low(int32), high(int32), -2)
    opt.imply(0, 0)
    opt.equal(0, 0)
    opt.add_cost_if_true_false(0, 0, 100)
    opt.add_cost_if_different(0, 0, 100)
    doAssert opt.solve().min_cost == -4

var rng = initRand(472193)
for trial in 0..<1000:
    let n = rng.rand(1..7)
    var opt = initProjectSelection(n, int64)
    var costs = newSeq[int64](1 shl n)
    var allowed = newSeq[bool](1 shl n)
    for mask in 0..<allowed.len: allowed[mask] = true
    for step in 0..<35:
        let kind = rng.rand(0..(if trial mod 2 == 0: 6 else: 9))
        let i = rng.rand(n - 1)
        let j = rng.rand(n - 1)
        let value = rng.rand(1) == 1
        let w = int64(rng.rand((if kind in {1, 2}: -30 else: 0)..30))
        var c: array[4, int64]
        var ids: seq[int]
        case kind
        of 0:
            c[0] = int64(rng.rand(-30..30))
            c[1] = int64(rng.rand(-30..30))
            opt.add_unary_cost(i, c[0], c[1])
        of 1: opt.add_cost(i, value, w)
        of 2: opt.add_gain(i, value, w)
        of 3: opt.add_cost_if_true_false(i, j, w)
        of 4: opt.add_cost_if_different(i, j, w)
        of 5:
            c[0] = int64(rng.rand(-30..30))
            c[1] = int64(rng.rand(-30..30))
            c[2] = int64(rng.rand(-30..30))
            c[3] = c[1] + c[2] - c[0] - w
            opt.add_pair_cost(i, j, c[0], c[1], c[2], c[3])
        of 6:
            for k in 0..<rng.rand(0..n + 2): ids.add(rng.rand(n - 1))
            opt.add_gain_if_all(ids, value, w)
        of 7: opt.force(i, value)
        of 8: opt.imply(i, j)
        else: opt.equal(i, j)
        for mask in 0..<costs.len:
            let xi = (mask and (1 shl i)) != 0
            let xj = (mask and (1 shl j)) != 0
            case kind
            of 0: costs[mask] += c[ord(xi)]
            of 1:
                if xi == value: costs[mask] += w
            of 2:
                if xi == value: costs[mask] -= w
            of 3:
                if xi and not xj: costs[mask] += w
            of 4:
                if xi != xj: costs[mask] += w
            of 5: costs[mask] += c[2 * ord(xi) + ord(xj)]
            of 6:
                var allMatch = true
                for k in ids:
                    if ((mask and (1 shl k)) != 0) != value: allMatch = false
                if allMatch: costs[mask] -= w
            of 7: allowed[mask] = allowed[mask] and xi == value
            of 8: allowed[mask] = allowed[mask] and (not xi or xj)
            else: allowed[mask] = allowed[mask] and xi == xj
        if step mod 7 == 0 or step == 34:
            var best = high(int64)
            for mask in 0..<costs.len:
                if allowed[mask]: best = min(best, costs[mask])
            let ans = opt.solve()
            doAssert ans.feasible == (best != high(int64))
            if ans.feasible:
                doAssert ans.min_cost == best
                doAssert ans.assignment.len == n
                var mask = 0
                for k, v in ans.assignment:
                    if v: mask = mask or (1 shl k)
                doAssert allowed[mask] and costs[mask] == best
            doAssert opt.solve() == ans

template expectError(errorType: typedesc, body: untyped) =
    block:
        var caught = false
        try: body
        except errorType: caught = true
        doAssert caught

block:
    expectError(ValueError): discard initProjectSelection(-1, int)
    var opt = initProjectSelection(2, int64)
    expectError(ValueError): opt.add_cost(-1, true, 1)
    expectError(ValueError): opt.force(2, false)
    expectError(OverflowDefect): opt.add_gain(0, true, low(int64))
    expectError(ValueError): opt.add_cost_if_different(0, 1, -1)
    expectError(ValueError): opt.add_gain_if_all([0, 2], true, 5)
    expectError(ValueError): opt.add_pair_cost(0, 1, 0, 0, 0, 1)
    doAssert opt.solve().min_cost == 0

block:
    var opt = initProjectSelection(1, int64)
    opt.add_unary_cost(0, low(int64), low(int64))
    doAssert opt.solve().min_cost == low(int64)
    opt.add_gain(0, false, 1)
    expectError(OverflowDefect): discard opt.solve()

block:
    var opt = initProjectSelection(1, int64)
    opt.add_unary_cost(0, low(int64), high(int64))
    expectError(OverflowDefect): discard opt.solve()

block:
    var opt = initProjectSelection(1, int64)
    opt.add_cost(0, true, high(int64))
    doAssert opt.solve().min_cost == 0
    opt.force(0, true)
    expectError(OverflowDefect): discard opt.solve()

block:
    var opt = initProjectSelection(2, int64)
    opt.add_cost(0, true, high(int64))
    opt.add_cost(1, true, 1)
    expectError(OverflowDefect): discard opt.solve()

block:
    var opt = initProjectSelection(1, int64)
    opt.add_unary_cost(0, high(int64), high(int64))
    opt.add_cost(0, true, 1)
    opt.force(0, true)
    expectError(OverflowDefect): discard opt.solve()

echo "Hello World"
