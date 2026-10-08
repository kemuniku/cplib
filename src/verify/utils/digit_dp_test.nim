# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import algorithm, hashes, options, strutils, tables
import cplib/utils/digit_dp
import cplib/modint/modint

proc toDigits(value, base: int): seq[int] =
    var value = value
    while value > 0:
        result.add(value mod base)
        value = value div base
    if result.len == 0:
        result.add(0)
    result.reverse()

proc checkRemainders(base, modulus, upper: int) =
    let next = proc(pos, state, digit: int): Option[int] =
        some((state * base + digit) mod modulus)
    let actual = digitDp(toDigits(upper, base), 0, next, 0'i64, 1'i64, base)
    var expected = initTable[int, int64]()
    for value in 0..upper:
        let remainder = value mod modulus
        expected[remainder] = expected.getOrDefault(remainder) + 1
    doAssert actual == expected
    doAssert digitDp(upper, 0, next, 0'i64, 1'i64, base) == expected
    if base == 10:
        doAssert digitDp($upper, 0, next, 0'i64, 1'i64) == expected
        doAssert digitDp("00" & $upper, 0, next, 0'i64, 1'i64) == expected

for base in [2, 3, 10, 16]:
    for modulus in [1, 2, 7, 13]:
        for upper in 0..120:
            checkRemainders(base, modulus, upper)

type State = tuple[last: int, started: bool]

proc nextDistinct(pos: int, state: State, digit: int): Option[State] =
    if not state.started and digit == 0:
        return some(state)
    if state.started and state.last == digit:
        return none(State)
    some((last: digit, started: true))

for upper in [0, 1, 9, 10, 11, 99, 100, 101, 999, 1024]:
    let initial: State = (last: 0, started: false)
    var expected = initTable[State, int64]()
    expected[initial] = 1
    for value in 1..upper:
        let digits = $value
        var valid = true
        for pos in 1..<digits.len:
            if digits[pos] == digits[pos - 1]:
                valid = false
        if valid:
            let state: State = (last: value mod 10, started: true)
            expected[state] = expected.getOrDefault(state) + 1
    doAssert digitDp($upper, initial, nextDistinct, 0'i64, 1'i64) == expected
    doAssert digitDp(upper, initial, nextDistinct, 0'i64, 1'i64) == expected
    doAssert digitDp("00" & $upper, initial, nextDistinct, 0'i64, 1'i64) == expected

type PositionState = object
    value: int

proc hash(state: PositionState): Hash = hash(state.value)

proc nextPosition(pos: int, state: PositionState, digit: int): Option[PositionState] =
    if pos == 1 and digit == 5:
        return none(PositionState)
    some(PositionState(value: state.value + (pos + 1) * digit))

block:
    var expected = initTable[PositionState, int]()
    for value in 0..357:
        let
            a = value div 100
            b = value div 10 mod 10
            c = value mod 10
        if b != 5:
            let state = PositionState(value: 7 + a + 2 * b + 3 * c)
            expected[state] = expected.getOrDefault(state) + 1
    doAssert digitDp("357", PositionState(value: 7), nextPosition, 0, 1) == expected
    doAssert digitDp(357, PositionState(value: 7), nextPosition, 0, 1) == expected

proc rejectAll(pos, state, digit: int): Option[int] = none(int)
doAssert digitDp("123", 0, rejectAll, 0, 1).len == 0

proc keepState(pos, state, digit: int): Option[int] = some(state)
doAssert digitDp("0", 42, keepState, 0'i64, 1'i64)[42] == 1
doAssert digitDp("999999999999999999", 42, keepState, 0'i64, 1'i64)[42] ==
    1_000_000_000_000_000_000'i64
doAssert digitDp(digits = 123, initialState = 42, next = keepState,
    zero = 0'i64, one = 1'i64)[42] == 124
doAssert digitDp(7'i8, 0, keepState, 0, 1, base = 256)[0] == 8
doAssert digitDp(7'u8, 0, keepState, 0, 1, base = 256)[0] == 8
doAssert digitDp(high(int64), 0, keepState, 0'u64, 1'u64)[0] == (1'u64 shl 63)

proc countDigits(pos, state, digit: int): Option[int] = some(state + 1)
doAssert digitDp(0, 0, countDigits, 0, 1)[1] == 1
doAssert digitDp(10, 0, countDigits, 0, 1)[2] == 11
doAssert digitDp(8, 0, countDigits, 0, 1, base = 2)[4] == 9

type Mint = modint998244353_montgomery
block:
    let upper = repeat("9", 200)
    let counts = digitDp(upper, 0, keepState, Mint.init(0), Mint.init(1))
    doAssert counts[0] == Mint.init(10).pow(upper.len)
    doAssert digitDp(high(uint64), 0, keepState, Mint.init(0), Mint.init(1))[0] ==
        Mint.init(2).pow(64)

type ShiftedCount = object
    encoded: int

proc `+`(a, b: ShiftedCount): ShiftedCount =
    ShiftedCount(encoded: a.encoded + b.encoded - 100)

block:
    let counts = digitDp("99", 0, keepState,
        ShiftedCount(encoded: 100), ShiftedCount(encoded: 101))
    doAssert counts[0].encoded == 200

type ParityCount = distinct int

proc `+`(a, b: ParityCount): ParityCount = ParityCount((int(a) + int(b)) mod 2)

block:
    let counts = digitDp("19", 0, keepState, ParityCount(0), ParityCount(1))
    doAssert counts.hasKey(0)
    doAssert int(counts[0]) == 0

template expectAssertion(body: untyped) =
    block:
        var raised = false
        try:
            body
        except AssertionDefect:
            raised = true
        doAssert raised

expectAssertion:
    discard digitDp(newSeq[int](), 0, keepState, 0, 1)
expectAssertion:
    discard digitDp(@[0], 0, keepState, 0, 1, 1)
expectAssertion:
    discard digitDp(@[-1], 0, keepState, 0, 1)
expectAssertion:
    discard digitDp(@[10], 0, keepState, 0, 1)
expectAssertion:
    discard digitDp(-1, 0, keepState, 0, 1)
expectAssertion:
    discard digitDp(low(int64), 0, keepState, 0, 1)
expectAssertion:
    discard digitDp(0, 0, keepState, 0, 1, base = 1)
expectAssertion:
    discard digitDp("", 0, keepState, 0, 1)
expectAssertion:
    discard digitDp("-1", 0, keepState, 0, 1)
expectAssertion:
    discard digitDp("1a", 0, keepState, 0, 1)

echo "Hello World"
