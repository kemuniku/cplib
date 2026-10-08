# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import algorithm, hashes, options, sets, strutils, tables
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

type LeadingState = object
    firstDigit, digitCount, remainder: int

proc hash(state: LeadingState): Hash =
    hash((state.firstDigit, state.digitCount, state.remainder))

proc checkLeadingStates(upper, base: int) =
    let modulus = 7
    let initial = proc(firstDigit, digitCount: int): LeadingState =
        LeadingState(firstDigit: firstDigit, digitCount: digitCount,
            remainder: firstDigit mod modulus)
    let next = proc(pos: int, state: LeadingState, digit: int): Option[LeadingState] =
        some(LeadingState(firstDigit: state.firstDigit, digitCount: state.digitCount,
            remainder: (state.remainder * base + digit) mod modulus))
    var expected = initTable[LeadingState, int64]()
    for value in 0..upper:
        let digits = toDigits(value, base)
        let state = LeadingState(firstDigit: digits[0], digitCount: digits.len,
            remainder: value mod modulus)
        expected[state] = expected.getOrDefault(state) + 1
    doAssert digitDp(upper, initial, next, 0'i64, 1'i64, base) == expected
    doAssert digitDp(toDigits(upper, base), initial, next, 0'i64, 1'i64, base) == expected
    doAssert digitDp(@[0, 0] & toDigits(upper, base), initial, next,
        0'i64, 1'i64, base) == expected
    if base == 10:
        doAssert digitDp($upper, initial, next, 0'i64, 1'i64) == expected
        doAssert digitDp("00" & $upper, initial, next, 0'i64, 1'i64) == expected

for base in [2, 3, 10, 16]:
    for upper in 0..120:
        checkLeadingStates(upper, base)
    for upper in [255, 256, 999, 1000, 1024]:
        checkLeadingStates(upper, base)

type DistinctState = tuple[last, digitCount: int]

proc initialDistinct(firstDigit, digitCount: int): DistinctState =
    (last: firstDigit, digitCount: digitCount)

proc nextDistinct(pos: int, state: DistinctState, digit: int): Option[DistinctState] =
    if state.last == digit:
        return none(DistinctState)
    some((last: digit, digitCount: state.digitCount))

for upper in [0, 9, 10, 11, 99, 100, 101, 999, 1024]:
    var expected = initTable[DistinctState, int]()
    for value in 0..upper:
        let digits = $value
        var valid = true
        for pos in 1..<digits.len:
            if digits[pos] == digits[pos - 1]:
                valid = false
        if valid:
            let state: DistinctState = (last: value mod 10, digitCount: digits.len)
            expected[state] = expected.getOrDefault(state) + 1
    doAssert digitDp(upper, initialDistinct, nextDistinct, 0, 1) == expected

proc leadingValue(firstDigit, digitCount: int): int =
    result = firstDigit
    for pos in 1..<digitCount:
        result *= 10

proc keepState(pos, state, digit: int): Option[int] = some(state)
proc rejectAll(pos, state, digit: int): Option[int] = none(int)

block:
    let counts = digitDp(digits = 3_000_005, initialState = leadingValue,
        next = keepState, zero = 0'i64, one = 1'i64)
    doAssert counts[3_000_000] == 6
    doAssert counts[2_000_000] == 1_000_000
    doAssert counts[300_000] == 100_000
    doAssert counts[30] == 10
    doAssert counts[3] == 1
    doAssert counts[0] == 1
    var total = 0'i64
    for count in counts.values:
        total += count
    doAssert total == 3_000_006

block:
    let counts = digitDp(999, leadingValue, rejectAll, 0, 1)
    doAssert counts.len == 10
    for digit in 0..9:
        doAssert counts[digit] == 1

block:
    var initialCalls: seq[(int, int)]
    let initial = proc(firstDigit, digitCount: int): int =
        initialCalls.add((firstDigit, digitCount))
        firstDigit
    let next = proc(pos, state, digit: int): Option[int] =
        doAssert false
        none(int)
    doAssert digitDp("000", initial, next, 0, 1)[0] == 1
    doAssert initialCalls == @[(0, 1)]
    doAssert digitDp("009", initial, next, 0, 1).len == 10

type PositionState = tuple[digitCount, positions: int]

proc initialPosition(firstDigit, digitCount: int): PositionState =
    (digitCount: digitCount, positions: 0)

proc nextPosition(pos: int, state: PositionState, digit: int): Option[PositionState] =
    some((digitCount: state.digitCount, positions: state.positions or (1 shl pos)))

block:
    let counts = digitDp(1000, initialPosition, nextPosition, 0, 1)
    doAssert counts.len == 4
    doAssert counts[(digitCount: 1, positions: 0)] == 10
    doAssert counts[(digitCount: 2, positions: 0b1000)] == 90
    doAssert counts[(digitCount: 3, positions: 0b1100)] == 900
    doAssert counts[(digitCount: 4, positions: 0b1110)] == 1

proc initialConstant(firstDigit, digitCount: int): int = 0

type Mint = modint998244353_montgomery
block:
    let upper = repeat("9", 200)
    let counts = digitDp(upper, initialConstant, keepState, Mint.init(0), Mint.init(1))
    doAssert counts.len == 1
    doAssert counts[0] == Mint.init(10).pow(200)
    doAssert digitDp(high(uint64), initialConstant, keepState,
        Mint.init(0), Mint.init(1))[0] == Mint.init(2).pow(64)

type PrefixState = (int, bool)

proc init(firstDigit, digitCount: int): PrefixState =
    if firstDigit == 1: (1, true) else: (0, false)

proc nextPrefix(pos: int, state: PrefixState, digit: int): Option[PrefixState] =
    if not state[1]:
        return some(state)
    if digit == 1:
        return some((state[0] + 1, true))
    some((state[0], false))

for upper in [0, 1, 11, 111, 1234]:
    var expected = initTable[PrefixState, int]()
    for value in 0..upper:
        let digits = $value
        var length = 0
        while length < digits.len and digits[length] == '1':
            inc length
        let state: PrefixState = (length, length == digits.len)
        expected[state] = expected.getOrDefault(state) + 1
    doAssert digitDp(upper, init, nextPrefix, 0, 1) == expected
    doAssert digitDp($upper, init, nextPrefix, 0, 1) == expected
    doAssert digitDp(toDigits(upper, 10), init, nextPrefix, 0, 1) == expected

echo "Hello World"
