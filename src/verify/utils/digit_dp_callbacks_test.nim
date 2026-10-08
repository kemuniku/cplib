# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import algorithm, options, sets, tables
import cplib/utils/digit_dp
import cplib/modint/modint

type State = tuple[remainder, length: int]

proc toDigits(value, base: int): seq[int] =
    var value = value
    while value > 0:
        result.add(value mod base)
        value = value div base
    if result.len == 0:
        result.add(0)
    result.reverse()

proc checkCallbacks(upper, base: int) =
    let modulus = 7
    let initial = proc(firstDigit, digitCount: int): State =
        (remainder: firstDigit mod modulus, length: digitCount)
    let optionalInitial = proc(firstDigit, digitCount: int): Option[State] =
        if firstDigit mod 2 == 0 or digitCount mod 2 == 0:
            return none(State)
        some(initial(firstDigit, digitCount))
    let next = proc(pos: int, state: State, digit: int): State =
        (remainder: (state.remainder * base + digit) mod modulus, length: state.length)
    let optionalNext = proc(pos: int, state: State, digit: int): Option[State] =
        if digit == 0:
            return none(State)
        some(next(pos, state, digit))
    var expected: array[4, Table[State, int64]]
    for i in 0..3:
        expected[i] = initTable[State, int64]()
    for value in 0..upper:
        let digits = toDigits(value, base)
        let state: State = (remainder: value mod modulus, length: digits.len)
        let initialAllowed = digits[0] mod 2 == 1 and digits.len mod 2 == 1
        var nextAllowed = true
        for pos in 1..<digits.len:
            if digits[pos] == 0:
                nextAllowed = false
        for i in 0..3:
            if (i mod 2 == 0 or initialAllowed) and (i < 2 or nextAllowed):
                expected[i][state] = expected[i].getOrDefault(state) + 1
    let digits = toDigits(upper, base)
    template checkInputs(initializer, transition, target: untyped) =
        doAssert digitDp(upper, initializer, transition, 0'i64, 1'i64, base) == target
        doAssert digitDp(digits, initializer, transition, 0'i64, 1'i64, base) == target
        doAssert digitDp(@[0, 0] & digits, initializer, transition,
            0'i64, 1'i64, base) == target
        if base == 10:
            doAssert digitDp($upper, initializer, transition, 0'i64, 1'i64) == target
            doAssert digitDp("00" & $upper, initializer, transition, 0'i64, 1'i64) == target
    checkInputs(initial, next, expected[0])
    checkInputs(optionalInitial, next, expected[1])
    checkInputs(initial, optionalNext, expected[2])
    checkInputs(optionalInitial, optionalNext, expected[3])

    var padded = initTable[State, int64]()
    for value in 0..upper:
        let state: State = (remainder: value mod modulus, length: digits.len)
        padded[state] = padded.getOrDefault(state) + 1
    checkInputs((remainder: 0, length: digits.len), next, padded)

    if base == 10 and upper == 1234:
        type Mint = modint998244353_montgomery
        let actual = digitDp(upper, optionalInitial, next, Mint.init(0), Mint.init(1))
        doAssert actual.len == expected[1].len
        for state, count in expected[1]:
            doAssert actual[state] == Mint.init(count)

for base in [2, 3, 10, 16]:
    for upper in 0..80:
        checkCallbacks(upper, base)
    for upper in [99, 100, 101, 999, 1000, 1234]:
        checkCallbacks(upper, base)

proc rejectInitial(firstDigit, digitCount: int): Option[int] = none(int)

proc unexpectedNext(pos, state, digit: int): int =
    doAssert false
    state

proc unexpectedOptionalNext(pos, state, digit: int): Option[int] =
    doAssert false
    some(state)

doAssert digitDp(0, rejectInitial, unexpectedNext, 0, 1).len == 0
doAssert digitDp(1234, rejectInitial, unexpectedNext, 0, 1).len == 0
doAssert digitDp("1234", rejectInitial, unexpectedOptionalNext, 0, 1).len == 0

proc initialNested(firstDigit, digitCount: int): Option[Option[int]] = some(none(int))
proc initialNestedDirect(firstDigit, digitCount: int): Option[int] = none(int)
proc nextNested(pos: int, state: Option[int], digit: int): Option[int] = state

block:
    let expected = {none(int): 13}.toTable
    doAssert digitDp(12, initialNested, nextNested, 0, 1) == expected
    doAssert digitDp(12, initialNestedDirect, nextNested, 0, 1) == expected
    doAssert digitDp(12, none(int), nextNested, 0, 1) == expected

proc init(firstDigit, digitCount: int): Option[State] =
    if firstDigit != 1:
        return none(State)
    some((remainder: 1, length: digitCount))

proc nxt(value: string): string = value
proc nxt(pos: int, state: State, digit: int): State =
    (remainder: (state.remainder * 10 + digit) mod 7, length: state.length)

proc optionalNxt(pos: int, state: State, digit: int): Option[State] = some(nxt(pos, state, digit))

block:
    let expected = {
        (remainder: 1, length: 1): 1,
        (remainder: 3, length: 2): 1,
        (remainder: 4, length: 2): 1,
        (remainder: 5, length: 2): 1
    }.toTable
    doAssert digitDp(12, init, nxt, 0, 1) == expected
    doAssert digitDp("12", init, nxt, 0, 1) == expected
    doAssert digitDp(@[1, 2], init, nxt, 0, 1) == expected
    doAssert digitDp(12, init, optionalNxt, 0, 1) == expected
    doAssert digitDp("12", init, optionalNxt, 0, 1) == expected
    doAssert digitDp(@[1, 2], init, optionalNxt, 0, 1) == expected

echo "Hello World"
