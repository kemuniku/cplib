# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, math
import cplib/utils/auto_rollback
import cplib/collections/lazysegtree_static_op

block:
    var state = 1
    let answer = Temporary:
        state = 10
        let inner = Temporary:
            state = 30
            state + 2
        doAssert state == 10 and inner == 32
        var local = 4
        let captured = Temporary:
            local = 12
            (local, [state, inner])
        doAssert local == 4 and captured[0] == 12
        (state, captured[1])
    doAssert state == 1 and answer == (10, [10, 32])
    let saved = Temporary:
        state = 8
        state
    doAssert saved == 8 and state == 1
    let calculated = Temporary:
        var (x, y) = (3, 5)
        x *= y
        x ^ 4
    doAssert calculated == 50625

block:
    var state: tuple[first: array[3, int], second: int]
    state = ([1, 2, 3], 4)
    proc change(value: var int) =
        value *= 3
        inc state.second
    proc indirect(value: var int) = change(value)
    proc applyValues(): (array[3, int], int) =
        var local = 5
        indirect(local)
        indirect(state.first[0])
        result = (state.first, local)
        result[0][1] = 100
    let value = Temporary:
        let before = state
        let changed = applyValues()
        doAssert changed[0][0] == 3 and changed[1] == 15
        doAssert state.second == 6
        state = ([7, 8, 9], 10)
        swap(state.first, state.first)
        before
    doAssert value == ([1, 2, 3], 4) and state == value
    withAutoRollback(applyValues):
        let saved = snapshot()
        discard applyValues()
        doAssert state.first[0] == 3 and state.second == 6
        rollback(saved)
        doAssert state == value

type S = (array[32, int32], int32)
type F = (int, int)
proc op(a, b: S): S =
    for i in 0..<32: result[0][i] = a[0][i] + b[0][i]
    result[1] = a[1] + b[1]
proc mapping(f: F, value: S): S =
    result = value
    for i in 0..<32:
        if (f[0] and (1 shl i)) == 0: result[0][i] = 0
        if (f[1] and (1 shl i)) != 0: result[0][i] = value[1]
proc composition(f, g: F): F =
    (f[0] and g[0], (g[1] and f[0]) or f[1])
proc fromInt(value: int): S =
    result[1] = 1
    for i in 0..<32:
        result[0][i] = int32((value shr i) and 1)
proc toInt(value: S): int =
    for i in 0..<32: result += int(value[0][i]) * (1 shl i)

block:
    var rng = initRand(91453)
    var initial: array[17, int]
    var nodes: seq[S]
    for i in 0..<initial.len:
        initial[i] = rng.rand(255)
        nodes.add(fromInt(initial[i]))
    var st = initLazySegmentTree(nodes, op, default(S), mapping, composition, (255, 0))
    st.apply(0..<17, (255, 8))
    for i in 0..<initial.len: initial[i] = initial[i] or 8
    let originalArr = st.arr
    let originalLazy = st.lazy
    for repeat in 0..<40:
        var operations: array[30, (int, int, int, int, int, int)]
        for i in 0..<operations.len:
            let l = rng.rand(17)
            let r = rng.rand(l..17)
            let ql = rng.rand(17)
            let qr = rng.rand(ql..17)
            operations[i] = (l, r, rng.rand(255), rng.rand(255), ql, qr)
        let answer = Temporary:
            var expected = initial
            var total = 0
            for i in 0..<operations.len:
                let (l, r, mask, bits, ql, qr) = operations[i]
                st.apply(l..<r, (mask, bits))
                for j in l..<r: expected[j] = (expected[j] and mask) or bits
                var sum = 0
                for j in ql..<qr: sum += expected[j]
                let actual = toInt(st[ql..<qr])
                doAssert actual == sum
                total += actual
                let inner = Temporary:
                    st.apply(0..<17, (0, 3))
                    toInt(st[0..<17])
                doAssert inner == 51
                doAssert toInt(st[ql..<qr]) == sum
            total
        doAssert answer >= 0
        doAssert st.arr == originalArr and st.lazy == originalLazy
        Temporary:
            for i in 0..<17: doAssert toInt(st[i..<i + 1]) == initial[i]
        doAssert st.arr == originalArr and st.lazy == originalLazy

static:
    doAssert not compiles(block:
        var state = @[1]
        let answer = Temporary:
            state[0] = 3
            state
    )
    doAssert not compiles(block:
        var value = (1, @[2])
        Temporary:
            value = (2, @[3])
    )
    doAssert not compiles(block:
        type Box = ref object
            value: int
        proc update(box: Box) = inc box.value
        Temporary:
            update(Box(value: 1))
    )
    doAssert not compiles(block:
        var state = 0
        proc update() = inc state
        proc choose(): proc() = update
        Temporary:
            (update, choose())[0]()
    )

echo "Hello World"
