# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/private/temporary_rollback_log
import cplib/utils/auto_rollback

block:
    var history: TemporaryRollbackLog
    var value = 7
    for i in 0..<100000:
        history.remember(addr value)
        value = i
    doAssert history.len == 1
    history.restore(0)
    doAssert value == 7 and history.len == 0
    history.remember(addr value)
    value = 15
    history.restore(0)
    doAssert value == 7

block:
    var history: TemporaryRollbackLog
    var values = [1, 2]
    history.remember(addr values[0])
    values[0] = 10
    let inner = history.beginTemporary()
    for i in 0..<1000:
        history.remember(addr values[0])
        history.remember(addr values[1])
        values[0] = i
        values[1] = -i
    doAssert history.len == 3
    let deepest = history.beginTemporary()
    history.remember(addr values[0])
    values[0] = -100
    doAssert history.len == 4
    history.endTemporary(deepest)
    doAssert values == [999, -999] and history.len == 3
    history.endTemporary(inner)
    doAssert values == [10, 2] and history.len == 1
    history.remember(addr values[0])
    values[0] = 20
    doAssert history.len == 1
    history.remember(addr values[1])
    values[1] = 30
    doAssert history.len == 2
    history.restore(0)
    doAssert values == [1, 2]

block:
    var history: TemporaryRollbackLog
    var value = 0
    for i in 1..1000:
        let inner = history.beginTemporary()
        history.remember(addr value)
        value = i
        doAssert history.len == 1
        history.endTemporary(inner)
        doAssert value == 0 and history.len == 0

block:
    var rng = initRand(639182)
    for repeat in 0..<100:
        var history: TemporaryRollbackLog
        var values = [[1, 2], [3, 4]]
        for i in 0..<100:
            let row = rng.rand(1)
            let col = rng.rand(1)
            case rng.rand(2)
            of 0:
                history.remember(addr values)
                values = [[i, i + 1], [i + 2, i + 3]]
            of 1:
                history.remember(addr values[row])
                values[row] = [i, -i]
            else:
                history.remember(addr values[row][col])
                values[row][col] = i
            doAssert history.len <= 7
        history.restore(0)
        doAssert values == [[1, 2], [3, 4]]

block:
    var values = [1, 2]
    proc setFirst(value: int) = values[0] = value
    let answer = Temporary:
        for i in 0..<1000:
            setFirst(i)
            values = [i + 1, -i]
            values[0] = i + 2
        let inner = Temporary:
            values[0] = 77
            values = [88, 99]
            values[0] = 66
            values
        doAssert inner[0] == 66 and inner[1] == 99
        doAssert values[0] == 1001 and values[1] == -999
        values
    doAssert answer == [1001, -999] and values == [1, 2]
    proc leave(): int =
        Temporary:
            values[0] = 10
            Temporary:
                values[0] = 20
                return values[0]
    doAssert leave() == 20 and values == [1, 2]

block:
    var history: TemporaryRollbackLog
    var small = 7'u8
    var wide = 0x123456789ABCDEF0'u64
    var fraction = -0.0
    var empty: array[0, int]
    var large: array[4096, int32]
    for i in 0..<large.len: large[i] = i.int32
    history.remember(addr small)
    small = 9
    history.remember(addr wide)
    wide = 0
    history.remember(addr fraction)
    fraction = 5.0
    history.remember(addr empty)
    let inner = history.beginTemporary()
    history.remember(addr large)
    for i in 0..<large.len: large[i] = -1
    history.remember(addr wide)
    wide = 123
    history.endTemporary(inner)
    for i in 0..<large.len: doAssert large[i] == i.int32
    doAssert wide == 0 and small == 9 and fraction == 5.0
    for repeat in 0..<20:
        let inner = history.beginTemporary()
        history.remember(addr large)
        large[0] = -1
        history.endTemporary(inner)
        doAssert large[0] == 0
    history.restore(0)
    doAssert small == 7 and wide == 0x123456789ABCDEF0'u64
    doAssert cast[uint64](fraction) == cast[uint64](-0.0)
    doAssert history.len == 0

static:
    doAssert not compiles(block:
        var history: TemporaryRollbackLog
        var value = @[1, 2]
        history.remember(addr value)
    )
    doAssert not compiles(block:
        var history: TemporaryRollbackLog
        var value = (1, "text")
        history.remember(addr value)
    )

echo "Hello World"
