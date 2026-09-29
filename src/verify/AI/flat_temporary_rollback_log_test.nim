# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/private/temporary_rollback_log

block:
    var cache: TemporaryIndexCache
    for size in [1, 2, 63, 64, 65, 1000, 3]:
        var values = newSeq[int](size)
        for i in 0..<size: values[i] = if i mod 3 == 0: 7 else: i
        let original = values
        for repeat in 0..<3:
            var history: FlatTemporaryRollbackLog
            for iteration in 0..<5:
                for i in 0..<size:
                    history.rememberIndexed(addr values[i], addr values[0], size, cache)
                    values[i] = iteration
            history.restore(0)
            doAssert values == original and history.len == 0

block:
    var values: array[130, int]
    var first, second: TemporaryIndexCache
    var outer: FlatTemporaryRollbackLog
    outer.rememberIndexed(addr values[63], addr values[0], values.len, first)
    values[63] = 9
    var inner: FlatTemporaryRollbackLog
    inner.rememberIndexed(addr values[63], addr values[0], values.len, first)
    values[63] = 10
    inner.rememberIndexed(addr values[64], addr values[0], values.len, first)
    values[64] = 10
    inner.restore(0)
    doAssert values[63] == 9 and values[64] == 0
    outer.rememberIndexed(addr values[63], addr values[0], values.len, second)
    values[63] = 11
    outer.rememberIndexed(addr values[64], addr values[0], values.len, second)
    values[64] = 12
    outer.remember(addr values)
    values = default(array[130, int])
    outer.restore(0)
    doAssert values == default(array[130, int])

block:
    var cache: TemporaryIndexCache
    var first = [7, 7, 7]
    var second = [8, 8, 8]
    var history: FlatTemporaryRollbackLog
    history.rememberIndexed(addr first[0], addr first[0], first.len, cache)
    first[0] = 1
    history.rememberIndexed(addr second[1], addr second[0], second.len, cache)
    second[1] = 2
    history.rememberIndexed(addr first[2], addr first[0], first.len, cache)
    first[2] = 3
    history.restore(0)
    doAssert first == [7, 7, 7] and second == [8, 8, 8]
    var general: TemporaryRollbackLog
    general.rememberIndexed(addr first[1], addr first[0], first.len, cache)
    first[1] = 9
    general.restore(0)
    doAssert first == [7, 7, 7]
    history.rememberIndexed(addr second[2], addr second[0], second.len, cache)
    second[2] = 10
    history.restore(0)
    doAssert second == [8, 8, 8]

proc testValues[T](initial, changed: T) =
    var cache: TemporaryIndexCache
    var values = [initial, initial, initial]
    var history: FlatTemporaryRollbackLog
    for i in 0..<values.len:
        history.rememberIndexed(addr values[i], addr values[0], values.len, cache)
        values[i] = changed
    history.restore(0)
    for i in 0..<values.len:
        doAssert equalMem(addr values[i], unsafeAddr initial, sizeof(T))

testValues(0xFE'u8, 1'u8)
testValues(0xFFEE'u16, 2'u16)
testValues(0xFFEEDDCC'u32, 3'u32)
testValues(0xFFEEDDCCBBAA9988'u64, 4'u64)
testValues(-1, low(int))
testValues(-0.0, 1.0)
testValues(false, true)
testValues([1'u8, 2'u8, 3'u8], [4'u8, 5'u8, 6'u8])
testValues([1, 2, 3], [4, 5, 6])
testValues(default(array[0, int]), default(array[0, int]))

block:
    var first = [7, 8, 9]
    var second = [10, 11, 12]
    var firstCache, secondCache: TemporaryIndexCache
    var history: FlatTemporaryRollbackLog
    for iteration in 0..<1000:
        let index = iteration mod 3
        history.rememberIndexed(addr first[index], addr first[0], first.len, firstCache)
        first[index] = iteration
        history.rememberIndexed(addr second[index], addr second[0], second.len, secondCache)
        second[index] = -iteration
        history.clearFlat()
        doAssert first == [7, 8, 9] and second == [10, 11, 12]
        doAssert history.len == 0
    history.restore(0)
    var general: TemporaryRollbackLog
    general.rememberIndexed(addr first[0], addr first[0], first.len, firstCache)
    first[0] = 100
    general.restore(0)
    doAssert first == [7, 8, 9]

var rng = initRand(667812)
for trial in 0..<300:
    var values: array[4, array[4, int]]
    for row in 0..<4:
        for col in 0..<4: values[row][col] = rng.rand(3)
    let original = values
    var history: FlatTemporaryRollbackLog
    var cache, alias, rowCache: TemporaryIndexCache
    for operation in 0..<100:
        let row = rng.rand(3)
        let col = rng.rand(3)
        let value = rng.rand(3)
        case rng.rand(4)
        of 0:
            history.rememberIndexed(addr values[row][col], addr values[0][0], 16, cache)
            values[row][col] = value
        of 1:
            history.rememberIndexed(addr values[row][col], addr values[0][0], 16, alias)
            values[row][col] = value
        of 2:
            history.remember(addr values[row][col])
            values[row][col] = value
        of 3:
            history.rememberIndexed(addr values[row], addr values[0], 4, rowCache)
            values[row] = [value, value, value, value]
        else:
            history.remember(addr values)
            for r in 0..<4:
                for c in 0..<4: values[r][c] = value
    history.restore(0)
    doAssert values == original

echo "Hello World"
