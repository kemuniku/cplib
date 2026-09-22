# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/auto_rollback
import cplib/collections/unionfind

block:
    var values = @[2, 4, 6]
    proc update(idx: int, value: int = 1): int {.discardable.} =
        values[idx] += value
        values[idx]
    withAutoRollback(update):
        let initial = snapshot()
        doAssert update(idx = 0) == 3
        let saved = snapshot()
        update(1, 10)
        rollback(saved)
        doAssert values == @[3, 4, 6]
        rollback(saved)
        withAutoRollback(update):
            update(0, 5)
            doAssert values[0] == 8
        doAssert values[0] == 3
        Temporary:
            update(0, 7)
            doAssert values[0] == 10
        doAssert values[0] == 3
        rollback(initial)
        doAssert values == @[2, 4, 6]
        update(2, 3)
    doAssert values == @[2, 4, 6]
    update(0, 5)
    doAssert values == @[7, 4, 6]

block:
    var rng = initRand(47328)
    var values: array[8, int]
    proc update(idx, amount: int) = values[idx] += amount
    for repeat in 0..<30:
        withAutoRollback(update):
            var expected: array[8, int]
            var states: seq[(int, array[8, int])]
            for step in 0..<100:
                case rng.rand(3)
                of 0:
                    states.add((snapshot(), expected))
                of 1:
                    if states.len > 0:
                        let position = rng.rand(states.high)
                        rollback(states[position][0])
                        expected = states[position][1]
                        states.setLen(position + 1)
                else:
                    let idx = rng.rand(values.high)
                    let amount = rng.rand(-5..5)
                    update(idx, amount)
                    expected[idx] += amount
                doAssert values == expected
        for value in values: doAssert value == 0

block:
    var values = @[0, 0]
    proc helper(idx: int) = values[idx] += 2
    Temporary:
        values[0] = 3
        helper(1)
        var local = 7
        Temporary:
            local = 9
            values[0] += 5
            helper(1)
            doAssert local == 9 and values[0] == 8 and values[1] == 4
        doAssert local == 7 and values[0] == 3 and values[1] == 2
        for i in 0..<2:
            Temporary:
                helper(i)
            doAssert values[0] == 3 and values[1] == 2
    doAssert values == @[0, 0]

block:
    var uf = initUnionFind(5)
    withAutoRollback(unite):
        let initial = snapshot()
        uf.unite(0, 1)
        doAssert uf.count == 4
        let saved = snapshot()
        uf.unite(1, 2)
        uf.unite(0, 2)
        doAssert uf.count == 3
        rollback(saved)
        doAssert uf.count == 4
        rollback(initial)
        doAssert uf.count == 5
    Temporary:
        uf.unite(0, 1)
        uf.unite(2, 3)
        uf.unite(1, 3)
        doAssert uf.issame(0, 2)
        doAssert uf.count == 2
    doAssert uf.count == 5
    for i in 0..<5: doAssert uf.siz(i) == 1

block:
    var state = 7
    proc update() = inc state
    let failure = newException(ValueError, "test")
    try:
        withAutoRollback(update):
            update()
            raise failure
    except ValueError:
        doAssert state == 7
    try:
        Temporary:
            update()
            raise failure
    except ValueError:
        doAssert state == 7
    try:
        Temporary:
            state = 100
            doAssert state == 0
    except AssertionDefect:
        doAssert state == 7
    for position in [-1, 100]:
        try:
            withAutoRollback(update):
                update()
                rollback(position)
            doAssert false
        except ValueError:
            doAssert state == 7

block:
    var state = 0
    proc returning(): int =
        Temporary:
            state = 5
            return state
    proc returningResult(): int =
        result = 2
        Temporary:
            result = 9
            state = 10
            return result
    doAssert returning() == 5 and state == 0
    doAssert returningResult() == 9 and state == 0
    proc update() = state += 5
    proc returningScope(): int =
        withAutoRollback(update):
            update()
            return state
    doAssert returningScope() == 5 and state == 0
    var iterations = 0
    for i in 0..<5:
        inc iterations
        Temporary:
            state = 7
            if i == 0: continue
            break
    doAssert iterations == 2 and state == 0
    iterations = 0
    for i in 0..<5:
        inc iterations
        withAutoRollback(update):
            update()
            if i == 0: continue
            break
    doAssert iterations == 2 and state == 0

static:
    doAssert not compiles(block:
        var values: seq[int]
        Temporary:
            values.add(1)
    )
    doAssert not compiles(block:
        var values: seq[int]
        proc update() = values.add(1)
        withAutoRollback(update):
            update()
    )
    doAssert not compiles(block:
        var value = 0
        proc update() = inc value
        withAutoRollback(update):
            update()
        discard snapshot()
    )

echo "Hello World"
