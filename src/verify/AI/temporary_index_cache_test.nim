# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/auto_rollback
import cplib/utils/private/temporary_rollback_log

block:
    var cache: TemporaryIndexCache
    var values = newSeq[int](1000000)
    for iteration in 0..<2000:
        var history: TemporaryRollbackLog
        let index = (iteration * 719) mod values.len
        for repeat in 0..<10:
            history.rememberIndexed(addr values[index], addr values[0], values.len, cache)
            inc values[index]
        doAssert history.len == 1
        doAssert cache.indexCapacity == values.len
        history.restore(0)
        doAssert values[index] == 0

block:
    var values = newSeq[int](1000000)
    for iteration in 0..<2000:
        let value = Temporary:
            values[iteration] = iteration + 1
            values[iteration]
        doAssert value == iteration + 1 and values[iteration] == 0

block:
    var cache: TemporaryIndexCache
    var history: TemporaryRollbackLog
    var values = [1, 2]
    var other = [3, 4]
    history.rememberIndexed(addr values[0], addr values[0], values.len, cache)
    values[0] = 10
    let inner = history.beginTemporary()
    history.rememberIndexed(addr values[0], addr values[0], values.len, cache)
    values[0] = 20
    history.rememberIndexed(addr values[0], addr values[0], values.len, cache)
    values[0] = 30
    history.rememberIndexed(addr other[0], addr other[0], other.len, cache)
    other[0] = 40
    history.rememberIndexed(addr other[0], addr other[0], other.len, cache)
    other[0] = 50
    doAssert history.len == 3
    var separate: TemporaryRollbackLog
    separate.rememberIndexed(addr values[0], addr values[0], values.len, cache)
    values[0] = 100
    separate.restore(0)
    doAssert values[0] == 30
    history.endTemporary(inner)
    doAssert values == [10, 2] and other == [3, 4]
    history.rememberIndexed(addr values[0], addr values[0], values.len, cache)
    values[0] = 11
    doAssert history.len == 1
    history.restore(0)
    doAssert values == [1, 2]
    history.rememberIndexed(addr other[1], addr other[0], other.len, cache)
    other[1] = 100
    history.restore(0)
    doAssert other == [3, 4]

block:
    var cache: TemporaryIndexCache
    for size in [1, 100, 3, 1000, 0, 7]:
        var values = newSeq[int](size)
        var history: TemporaryRollbackLog
        for i in 0..<size:
            history.rememberIndexed(addr values[i], addr values[0], size, cache)
            values[i] = i + 1
        history.restore(0)
        for value in values: doAssert value == 0
    doAssert cache.indexCapacity == 1000

block:
    var values = @[1, 2, 3]
    proc updateItems() =
        Temporary:
            for i in 0..<values.len:
                values[i] += 10
                values[i] *= 2
                Temporary:
                    values[i] = -1
                doAssert values[i] >= 20
    for iteration in 0..<100:
        updateItems()
        doAssert values == @[1, 2, 3]
    values = @[7, 8, 9, 10, 11]
    updateItems()
    doAssert values == @[7, 8, 9, 10, 11]
    values = @[]
    updateItems()
    doAssert values.len == 0

block:
    var lower: array[5..7, int]
    var calls = 0
    proc index(): int =
        inc calls
        6
    let answer = Temporary:
        lower[index()] = 4
        inc lower[index()]
        (lower[6], calls)
    doAssert answer == (5, 2)
    doAssert calls == 0 and lower[6] == 0

block:
    var values = [[1, 2], [3, 4]]
    Temporary:
        values[0] = [5, 6]
        values[0][0] = 7
        values = [[8, 9], [10, 11]]
        values[0] = [12, 13]
        Temporary:
            values = [[14, 15], [16, 17]]
            values[0] = [18, 19]
        doAssert values[0][0] == 12 and values[1][0] == 10
    doAssert values == [[1, 2], [3, 4]]

block:
    var values = @[1, 2]
    proc change(value: var int) = inc value
    let failure = newException(ValueError, "test")
    for iteration in 0..<10:
        try:
            Temporary:
                values[0] = 10
                change(values[0])
                values[0] = 20
                raise failure
        except ValueError:
            doAssert values == @[1, 2]
        let answer = Temporary:
            change(values[0])
            values[0] = 30
            change(values[0])
            values[0]
        doAssert answer == 31 and values == @[1, 2]

echo "Hello World"
