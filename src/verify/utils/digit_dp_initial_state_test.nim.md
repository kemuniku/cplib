---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/digit_dp.nim
    title: cplib/utils/digit_dp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/digit_dp.nim
    title: cplib/utils/digit_dp.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    \nimport algorithm, hashes, options, sets, strutils, tables\nimport cplib/utils/digit_dp\n\
    import cplib/modint/modint\n\nproc toDigits(value, base: int): seq[int] =\n  \
    \  var value = value\n    while value > 0:\n        result.add(value mod base)\n\
    \        value = value div base\n    if result.len == 0:\n        result.add(0)\n\
    \    result.reverse()\n\ntype LeadingState = object\n    firstDigit, digitCount,\
    \ remainder: int\n\nproc hash(state: LeadingState): Hash =\n    hash((state.firstDigit,\
    \ state.digitCount, state.remainder))\n\nproc checkLeadingStates(upper, base:\
    \ int) =\n    let modulus = 7\n    let initial = proc(firstDigit, digitCount:\
    \ int): LeadingState =\n        LeadingState(firstDigit: firstDigit, digitCount:\
    \ digitCount,\n            remainder: firstDigit mod modulus)\n    let next =\
    \ proc(pos: int, state: LeadingState, digit: int): Option[LeadingState] =\n  \
    \      some(LeadingState(firstDigit: state.firstDigit, digitCount: state.digitCount,\n\
    \            remainder: (state.remainder * base + digit) mod modulus))\n    var\
    \ expected = initTable[LeadingState, int64]()\n    for value in 0..upper:\n  \
    \      let digits = toDigits(value, base)\n        let state = LeadingState(firstDigit:\
    \ digits[0], digitCount: digits.len,\n            remainder: value mod modulus)\n\
    \        expected[state] = expected.getOrDefault(state) + 1\n    doAssert digitDp(upper,\
    \ initial, next, 0'i64, 1'i64, base) == expected\n    doAssert digitDp(toDigits(upper,\
    \ base), initial, next, 0'i64, 1'i64, base) == expected\n    doAssert digitDp(@[0,\
    \ 0] & toDigits(upper, base), initial, next,\n        0'i64, 1'i64, base) == expected\n\
    \    if base == 10:\n        doAssert digitDp($upper, initial, next, 0'i64, 1'i64)\
    \ == expected\n        doAssert digitDp(\"00\" & $upper, initial, next, 0'i64,\
    \ 1'i64) == expected\n\nfor base in [2, 3, 10, 16]:\n    for upper in 0..120:\n\
    \        checkLeadingStates(upper, base)\n    for upper in [255, 256, 999, 1000,\
    \ 1024]:\n        checkLeadingStates(upper, base)\n\ntype DistinctState = tuple[last,\
    \ digitCount: int]\n\nproc initialDistinct(firstDigit, digitCount: int): DistinctState\
    \ =\n    (last: firstDigit, digitCount: digitCount)\n\nproc nextDistinct(pos:\
    \ int, state: DistinctState, digit: int): Option[DistinctState] =\n    if state.last\
    \ == digit:\n        return none(DistinctState)\n    some((last: digit, digitCount:\
    \ state.digitCount))\n\nfor upper in [0, 9, 10, 11, 99, 100, 101, 999, 1024]:\n\
    \    var expected = initTable[DistinctState, int]()\n    for value in 0..upper:\n\
    \        let digits = $value\n        var valid = true\n        for pos in 1..<digits.len:\n\
    \            if digits[pos] == digits[pos - 1]:\n                valid = false\n\
    \        if valid:\n            let state: DistinctState = (last: value mod 10,\
    \ digitCount: digits.len)\n            expected[state] = expected.getOrDefault(state)\
    \ + 1\n    doAssert digitDp(upper, initialDistinct, nextDistinct, 0, 1) == expected\n\
    \nproc leadingValue(firstDigit, digitCount: int): int =\n    result = firstDigit\n\
    \    for pos in 1..<digitCount:\n        result *= 10\n\nproc keepState(pos, state,\
    \ digit: int): Option[int] = some(state)\nproc rejectAll(pos, state, digit: int):\
    \ Option[int] = none(int)\n\nblock:\n    let counts = digitDp(digits = 3_000_005,\
    \ initialState = leadingValue,\n        next = keepState, zero = 0'i64, one =\
    \ 1'i64)\n    doAssert counts[3_000_000] == 6\n    doAssert counts[2_000_000]\
    \ == 1_000_000\n    doAssert counts[300_000] == 100_000\n    doAssert counts[30]\
    \ == 10\n    doAssert counts[3] == 1\n    doAssert counts[0] == 1\n    var total\
    \ = 0'i64\n    for count in counts.values:\n        total += count\n    doAssert\
    \ total == 3_000_006\n\nblock:\n    let counts = digitDp(999, leadingValue, rejectAll,\
    \ 0, 1)\n    doAssert counts.len == 10\n    for digit in 0..9:\n        doAssert\
    \ counts[digit] == 1\n\nblock:\n    var initialCalls: seq[(int, int)]\n    let\
    \ initial = proc(firstDigit, digitCount: int): int =\n        initialCalls.add((firstDigit,\
    \ digitCount))\n        firstDigit\n    let next = proc(pos, state, digit: int):\
    \ Option[int] =\n        doAssert false\n        none(int)\n    doAssert digitDp(\"\
    000\", initial, next, 0, 1)[0] == 1\n    doAssert initialCalls == @[(0, 1)]\n\
    \    doAssert digitDp(\"009\", initial, next, 0, 1).len == 10\n\ntype PositionState\
    \ = tuple[digitCount, positions: int]\n\nproc initialPosition(firstDigit, digitCount:\
    \ int): PositionState =\n    (digitCount: digitCount, positions: 0)\n\nproc nextPosition(pos:\
    \ int, state: PositionState, digit: int): Option[PositionState] =\n    some((digitCount:\
    \ state.digitCount, positions: state.positions or (1 shl pos)))\n\nblock:\n  \
    \  let counts = digitDp(1000, initialPosition, nextPosition, 0, 1)\n    doAssert\
    \ counts.len == 4\n    doAssert counts[(digitCount: 1, positions: 0)] == 10\n\
    \    doAssert counts[(digitCount: 2, positions: 0b1000)] == 90\n    doAssert counts[(digitCount:\
    \ 3, positions: 0b1100)] == 900\n    doAssert counts[(digitCount: 4, positions:\
    \ 0b1110)] == 1\n\nproc initialConstant(firstDigit, digitCount: int): int = 0\n\
    \ntype Mint = modint998244353_montgomery\nblock:\n    let upper = repeat(\"9\"\
    , 200)\n    let counts = digitDp(upper, initialConstant, keepState, Mint.init(0),\
    \ Mint.init(1))\n    doAssert counts.len == 1\n    doAssert counts[0] == Mint.init(10).pow(200)\n\
    \    doAssert digitDp(high(uint64), initialConstant, keepState,\n        Mint.init(0),\
    \ Mint.init(1))[0] == Mint.init(2).pow(64)\n\ntype PrefixState = (int, bool)\n\
    \nproc init(firstDigit, digitCount: int): PrefixState =\n    if firstDigit ==\
    \ 1: (1, true) else: (0, false)\n\nproc nextPrefix(pos: int, state: PrefixState,\
    \ digit: int): Option[PrefixState] =\n    if not state[1]:\n        return some(state)\n\
    \    if digit == 1:\n        return some((state[0] + 1, true))\n    some((state[0],\
    \ false))\n\nfor upper in [0, 1, 11, 111, 1234]:\n    var expected = initTable[PrefixState,\
    \ int]()\n    for value in 0..upper:\n        let digits = $value\n        var\
    \ length = 0\n        while length < digits.len and digits[length] == '1':\n \
    \           inc length\n        let state: PrefixState = (length, length == digits.len)\n\
    \        expected[state] = expected.getOrDefault(state) + 1\n    doAssert digitDp(upper,\
    \ init, nextPrefix, 0, 1) == expected\n    doAssert digitDp($upper, init, nextPrefix,\
    \ 0, 1) == expected\n    doAssert digitDp(toDigits(upper, 10), init, nextPrefix,\
    \ 0, 1) == expected\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/utils/digit_dp.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/utils/digit_dp.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/utils/digit_dp_initial_state_test.nim
  requiredBy: []
  timestamp: '2026-10-08 11:39:33+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/digit_dp_initial_state_test.nim
layout: document
redirect_from:
- /verify/verify/utils/digit_dp_initial_state_test.nim
- /verify/verify/utils/digit_dp_initial_state_test.nim.html
title: verify/utils/digit_dp_initial_state_test.nim
---
