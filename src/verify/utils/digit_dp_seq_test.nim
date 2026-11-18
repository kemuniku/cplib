# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import algorithm, options, random, strutils, tables
import cplib/utils/digit_dp
import cplib/utils/digit_dp_seq
import cplib/modint/modint

proc toDigits(value, base: int): seq[int] =
    var value = value
    while true:
        result.add(value mod base)
        value = value div base
        if value == 0: break
    result.reverse()

proc check[S, T](actual: DigitDpSeqResult[S, T], expected: Table[S, T], zero: T) =
    doAssert actual.len == expected.len
    let flat = actual.toSeq
    for index, value in flat:
        let state = actual.stateAt(index)
        doAssert actual.stateIndex(state) == index
        doAssert actual.hasKey(state) == expected.hasKey(state)
        doAssert actual[state] == expected.getOrDefault(state, zero)
        doAssert value == actual[state]
    var n = 0
    for state, count in actual:
        doAssert expected.hasKey(state)
        doAssert count == expected[state]
        inc n
    doAssert n == expected.len

for base in [2, 3, 10, 16]:
    for modulus in [1, 2, 7, 13]:
        for upper in 0..120:
            let transition = proc(pos, state, digit: int): int =
                ((state + 3) * base + digit) mod modulus - 3
            let optional = proc(pos, state, digit: int): Option[int] = some(transition(pos, state, digit))
            let bounds = -3..modulus - 4
            var expected = initTable[int, int64]()
            for value in 0..upper:
                let state = value mod modulus - 3
                expected[state] = expected.getOrDefault(state) + 1
            let digits = toDigits(upper, base)
            template inputs(step: untyped) =
                check(digitDpSeq(upper, bounds, -3, step, 0'i64, 1'i64, base), expected, 0'i64)
                check(digitDpSeq(digits, bounds, -3, step, 0'i64, 1'i64, base), expected, 0'i64)
                if base == 10:
                    check(digitDpSeq("00" & $upper, bounds, -3, step, 0'i64, 1'i64), expected, 0'i64)
            inputs(transition)
            inputs(optional)
            doAssert digitDp(upper, -3, optional, 0'i64, 1'i64, base) == expected

type State = tuple[remainder, length: int]
for base in [2, 3, 10, 16]:
    for upper in 0..160:
        let initial = proc(firstDigit, digitCount: int): State =
            (firstDigit mod 7 - 3, digitCount)
        let optionalInitial = proc(firstDigit, digitCount: int): Option[State] =
            if firstDigit mod 2 == 0: none(State) else: some(initial(firstDigit, digitCount))
        let next = proc(pos: int, state: State, digit: int): State =
            (((state.remainder + 3) * base + digit) mod 7 - 3, state.length)
        let optionalNext = proc(pos: int, state: State, digit: int): Option[State] =
            if digit == 0: none(State) else: some(next(pos, state, digit))
        let digits = toDigits(upper, base)
        let bounds = (remainder: -3, length: 1)..(remainder: 3, length: digits.len)
        var expected: array[4, Table[State, int]]
        for value in 0..upper:
            let ds = toDigits(value, base)
            let state: State = (value mod 7 - 3, ds.len)
            var noZero = true
            for i in 1..<ds.len:
                if ds[i] == 0: noZero = false
            for mode in 0..3:
                if (mode mod 2 == 0 or ds[0] mod 2 == 1) and (mode < 2 or noZero):
                    expected[mode][state] = expected[mode].getOrDefault(state) + 1
        template inputs(init, step, mode: untyped) =
            check(digitDpSeq(upper, bounds, init, step, 0, 1, base), expected[mode], 0)
            check(digitDpSeq(@[0, 0] & digits, bounds, init, step, 0, 1, base), expected[mode], 0)
            if base == 10:
                check(digitDpSeq("00" & $upper, bounds, init, step, 0, 1), expected[mode], 0)
            doAssert digitDp(upper, init, step, 0, 1, base) == expected[mode]
        inputs(initial, next, 0)
        inputs(optionalInitial, next, 1)
        inputs(initial, optionalNext, 2)
        inputs(optionalInitial, optionalNext, 3)

proc nxt(value: string): string = value
proc nxt(pos: int, state: (int, int), digit: int): (int, int) =
    ((state[0] + digit) mod 3, state[1] + 1)
block:
    let actual = digitDpSeq(99, (0, -2)..(2, 2), (0, -2), nxt, 0, 1)
    check(actual, digitDp(99, (0, -2), nxt, 0, 1), 0)
    doAssert actual[(0, 0)] == 34
    doAssert actual.stateIndex((1, -1)) == 4
    doAssert actual.stateAt(4) == (1, -1)
    let named = digitDpSeq(9, (remainder: 0, length: 0)..(remainder: 2, length: 1),
        (remainder: 0, length: 0), nxt, 0, 1)
    doAssert named[(remainder: 0, length: 1)] == 4

var rng = initRand(52874)
for trial in 0..<300:
    let upper = rng.rand(400)
    let base = rng.rand(2..10)
    var transitions: array[5, array[10, int]]
    for row in transitions.mitems:
        for dest in row.mitems: dest = rng.rand(-3..2)
    let step = proc(pos, state, digit: int): Option[int] =
        let dest = transitions[state + 2][digit]
        if dest == -3: none(int) else: some(dest)
    let digits = toDigits(upper, base)
    var expected = initTable[int, int]()
    for value in 0..upper:
        var ds = toDigits(value, base)
        ds = newSeq[int](digits.len - ds.len) & ds
        var state = 0
        var valid = true
        for digit in ds:
            state = transitions[state + 2][digit]
            if state == -3:
                valid = false
                break
        if valid: expected[state] = expected.getOrDefault(state) + 1
    check(digitDpSeq(digits, -2..2, 0, step, 0, 1, base), expected, 0)
    doAssert digitDp(digits, 0, step, 0, 1, base) == expected

proc keep(pos, state, digit: int): int = state
proc reject(pos, state, digit: int): Option[int] = none(int)
proc rejectInitial(firstDigit, digitCount: int): Option[int] = none(int)
proc unexpected(pos, state, digit: int): int =
    doAssert false
    state
proc first(firstDigit, digitCount: int): int = firstDigit
block:
    doAssert digitDpSeq(999, -1..1, 0, reject, 0, 1).len == 0
    doAssert digitDpSeq(999, -1..1, rejectInitial, unexpected, 0, 1).len == 0
    var calls: seq[(int, int)]
    let initializer = proc(firstDigit, digitCount: int): int =
        calls.add((firstDigit, digitCount))
        firstDigit
    doAssert digitDpSeq("000", 0..9, initializer, unexpected, 0, 1)[0] == 1
    doAssert calls == @[(0, 1)]
    doAssert digitDpSeq("009", 0..9, first, unexpected, 0, 1).len == 10
    let position = proc(pos, state, digit: int): int = state or (1 shl pos)
    let start = proc(firstDigit, digitCount: int): int = 0
    check(digitDpSeq("001234", 0..63, start, position, 0, 1),
        digitDp("001234", start, position, 0, 1), 0)
    doAssert digitDpSeq(high(int64), 0..0, 0, keep, 0'u64, 1'u64)[0] == (1'u64 shl 63)
    doAssert digitDpSeq(7'i8, 0..0, 0, keep, 0, 1, 256)[0] == 8
    doAssert digitDpSeq(7'u8, 0..0, 0, keep, 0, 1, 256)[0] == 8

for initial in [low(int), low(int) + 1, -1, 0, high(int) - 1, high(int)]:
    let lowBound = if initial == low(int): initial else: initial - 1
    let highBound = if initial == high(int): initial else: initial + 1
    check(digitDpSeq(19, lowBound..highBound, initial, keep, 0, 1),
        digitDp(19, initial, keep, 0, 1), 0)
block:
    proc keepUnsigned(pos: int, state: uint64, digit: int): uint64 = state
    let actual = digitDpSeq(19, (high(uint64) - 2)..high(uint64), high(uint64), keepUnsigned, 0, 1)
    doAssert actual[high(uint64)] == 20
    doAssert actual.stateAt(0) == high(uint64) - 2
    doAssert actual.stateIndex(high(uint64)) == 2
    proc keepSmall(pos: int, state: (int8, uint8, int16), digit: int): (int8, uint8, int16) = state
    let a = (low(int8), 254'u8, -2'i16)
    let b = (low(int8) + 1, high(uint8), 0'i16)
    let small = digitDpSeq(99, a..b, a, keepSmall, 0, 1)
    for i in 0..<small.toSeq.len: doAssert small.stateIndex(small.stateAt(i)) == i
    doAssert small[a] == 100
    proc keepNested(pos: int, state: ((int, int), int), digit: int): ((int, int), int) = state
    let nested = digitDpSeq(99, ((-1, -2), 4)..((1, 0), 5), ((0, -1), 5), keepNested, 0, 1)
    for i in 0..<nested.toSeq.len: doAssert nested.stateIndex(nested.stateAt(i)) == i

type ShiftedCount = object
    encoded: int
proc `+`(a, b: ShiftedCount): ShiftedCount =
    ShiftedCount(encoded: a.encoded + b.encoded - 100)
proc `==`(a, b: ShiftedCount): bool {.error: "加算以外を要求しない".}
block:
    let zero = ShiftedCount(encoded: 100)
    let one = ShiftedCount(encoded: 101)
    let a = digitDpSeq("99", -1..1, 0, keep, zero, one)
    let b = digitDp("99", 0, keep, zero, one)
    doAssert a[0].encoded == b[0].encoded
    doAssert a[-1].encoded == 100
    doAssert not a.hasKey(-1)

type ParityCount = distinct int
proc `+`(a, b: ParityCount): ParityCount = ParityCount((int(a) + int(b)) mod 2)
block:
    let step = proc(pos, state, digit: int): int = state + 1
    let a = digitDpSeq("9999", 0..5, 0, step, ParityCount(0), ParityCount(1))
    let b = digitDp("9999", 0, step, ParityCount(0), ParityCount(1))
    doAssert a.hasKey(4) and b.hasKey(4)
    doAssert int(a[4]) == 0 and int(b[4]) == 0
    doAssert not a.hasKey(5)
    doAssert int(digitDpSeq("9999", 0..0, 0, keep, ParityCount(0), ParityCount(0))[0]) == 0
    doAssert digitDpSeq("9999", 0..0, 0, keep, ParityCount(0), ParityCount(0)).hasKey(0)

when defined(cpp):
    type Mint = modint998244353_montgomery
    block:
        let initial = proc(firstDigit, digitCount: int): int = 0
        let a = digitDpSeq(repeat("9", 200), -1..1, initial, keep, Mint.init(0), Mint.init(1))
        doAssert a[0] == Mint.init(10).pow(200)
        doAssert digitDpSeq(high(uint64), 0..0, 0, keep, Mint.init(0), Mint.init(1))[0] == Mint.init(2).pow(64)

template expectError(kind: typedesc, body: untyped) =
    block:
        var raised = false
        try:
            body
        except kind:
            raised = true
        doAssert raised

expectError(ValueError): discard digitDpSeq(9, 1..0, 0, keep, 0, 1)
expectError(ValueError): discard digitDpSeq(9, low(int)..high(int), 0, keep, 0, 1)
expectError(ValueError): discard digitDpSeq(9, 0..high(int) - 1, 0, keep, 0, 1)
expectError(ValueError): discard digitDpSeq(9, 0..(high(int) div 2), 0, keep, 0, 1)
expectError(ValueError): discard digitDpSeq(9, (0, 0)..(high(int) div 2, 3), (0, 0), nxt, 0, 1)
expectError(ValueError): discard digitDpSeq(9, (0, 2)..(1, 1), (0, 0), nxt, 0, 1)
expectError(ValueError): discard digitDpSeq(9, -1..1, 2, keep, 0, 1)
expectError(ValueError): discard digitDpSeq(9, -1..1, first, keep, 0, 1)
block:
    let init = proc(d, n: int): Option[int] = some(2)
    expectError(ValueError): discard digitDpSeq(9, -1..1, init, keep, 0, 1)
    let step = proc(p, s, d: int): int = 2
    let optional = proc(p, s, d: int): Option[int] = some(-2)
    expectError(ValueError): discard digitDpSeq(9, -1..1, 0, step, 0, 1)
    expectError(ValueError): discard digitDpSeq(9, -1..1, 0, optional, 0, 1)
    let alias = proc(p: int, s: (int, int), d: int): (int, int) = (3, 0)
    expectError(ValueError): discard digitDpSeq(0, (0, 0)..(2, 1), (0, 0), alias, 0, 1)
    let a = digitDpSeq(0, -1..1, 0, keep, 0, 1)
    doAssert not a.hasKey(low(int)) and not a.hasKey(high(int))
    expectError(IndexDefect): discard a[2]
    expectError(IndexDefect): discard a.stateAt(-1)
    expectError(IndexDefect): discard a.stateAt(3)
expectError(ValueError): discard digitDpSeq(newSeq[int](), 0..0, 0, keep, 0, 1)
expectError(ValueError): discard digitDpSeq(@[0], 0..0, 0, keep, 0, 1, 1)
expectError(ValueError): discard digitDpSeq(@[-1], 0..0, 0, keep, 0, 1)
expectError(ValueError): discard digitDpSeq(@[10], 0..0, 0, keep, 0, 1)
expectError(ValueError): discard digitDpSeq(-1, 0..0, 0, keep, 0, 1)
expectError(ValueError): discard digitDpSeq(low(int64), 0..0, 0, keep, 0, 1)
expectError(ValueError): discard digitDpSeq(0, 0..0, 0, keep, 0, 1, 1)
expectError(ValueError): discard digitDpSeq("", 0..0, 0, keep, 0, 1)
expectError(ValueError): discard digitDpSeq("-1", 0..0, 0, keep, 0, 1)
expectError(ValueError): discard digitDpSeq("1a", 0..0, 0, keep, 0, 1)

block:
    proc start(value: string): string = value
    proc start(digit, length: int): (int, int) = (digit mod 3, length)
    let step = proc(pos: int, state: (int, int), digit: int): (int, int) =
        ((state[0] * 10 + digit) mod 3, state[1])
    check(digitDpSeq(99, (0, 1)..(2, 2), start, step, 0, 1), digitDp(99, start, step, 0, 1), 0)
    proc keep64(pos: int, state: int64, digit: int): int64 = state
    doAssert digitDpSeq(9, 0'i64..1'i64, 0, keep64, 0, 1)[0] == 10
    proc keepUnsigned(pos: int, state: uint64, digit: int): uint64 = state
    expectError(ValueError): discard digitDpSeq(9, 0'u64..high(uint64), 0, keepUnsigned, 0, 1)
    let cross = digitDpSeq(9, (uint64(high(int64)) - 1)..(uint64(high(int64)) + 1),
        uint64(high(int64)), keepUnsigned, 0, 1)
    for i in 0..<3: doAssert cross.stateIndex(cross.stateAt(i)) == i

block:
    proc step(pos: int, state: (int, int), digit: int): (int, int) =
        ((state[0] * 10 + digit) mod 7, state[1])
    proc step(value: string): string = value
    proc optionalStep(pos: int, state: (int, int), digit: int): Option[(int, int)] =
        if digit == 5: none((int, int)) else: some(step(pos, state, digit))
    proc start(digit, length: int): (int, int) = (digit mod 7, length)
    proc start(value: string): string = value
    proc optionalStart(digit, length: int): Option[(int, int)] =
        if digit == 0: none((int, int)) else: some(start(digit, length))
    let bounds = (0, 1)..(6, 3)
    template checkTypes(initializer, transition: untyped) =
        let expected = digitDp(123, initializer, transition, 0'i64, 1'i64)
        check(digitDpSeq(123, bounds, initializer, transition, int64), expected, 0'i64)
        check(digitDpSeq("123", bounds, initializer, transition, int64), expected, 0'i64)
        check(digitDpSeq(@[1, 2, 3], bounds, initializer, transition, int64), expected, 0'i64)
        when defined(cpp):
            let expectedMod = digitDp(123, initializer, transition, Mint.init(0), Mint.init(1))
            check(digitDpSeq(123, bounds, initializer, transition, Mint), expectedMod, Mint.init(0))
            check(digitDpSeq("123", bounds, initializer, transition, Mint), expectedMod, Mint.init(0))
            check(digitDpSeq(@[1, 2, 3], bounds, initializer, transition, Mint), expectedMod, Mint.init(0))
    checkTypes((0, 3), step)
    checkTypes((0, 3), optionalStep)
    checkTypes(start, step)
    checkTypes(start, optionalStep)
    checkTypes(optionalStart, step)
    checkTypes(optionalStart, optionalStep)
    doAssert digitDpSeq(9, 0..0, 0, keep, int64, base = 2)[0] == 10
    doAssert digitDpSeq(@[1, 0, 0, 1], 0..0, 0, keep, int64, base = 2)[0] == 10
    let modulus = 7
    let closure = proc(pos, state, digit: int): int = (state * 10 + digit) mod modulus
    doAssert digitDpSeq(999, 0..6, 0, closure, countType = int64)[0] == 143
    when defined(cpp):
        doAssert digitDpSeq(999, 0..6, 0, closure, Mint)[0] == Mint.init(143)

echo "Hello World"
