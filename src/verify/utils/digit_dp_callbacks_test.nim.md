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
    \nimport algorithm, options, sets, tables\nimport cplib/utils/digit_dp\nimport\
    \ cplib/modint/modint\n\ntype State = tuple[remainder, length: int]\n\nproc toDigits(value,\
    \ base: int): seq[int] =\n    var value = value\n    while value > 0:\n      \
    \  result.add(value mod base)\n        value = value div base\n    if result.len\
    \ == 0:\n        result.add(0)\n    result.reverse()\n\nproc checkCallbacks(upper,\
    \ base: int) =\n    let modulus = 7\n    let initial = proc(firstDigit, digitCount:\
    \ int): State =\n        (remainder: firstDigit mod modulus, length: digitCount)\n\
    \    let optionalInitial = proc(firstDigit, digitCount: int): Option[State] =\n\
    \        if firstDigit mod 2 == 0 or digitCount mod 2 == 0:\n            return\
    \ none(State)\n        some(initial(firstDigit, digitCount))\n    let next = proc(pos:\
    \ int, state: State, digit: int): State =\n        (remainder: (state.remainder\
    \ * base + digit) mod modulus, length: state.length)\n    let optionalNext = proc(pos:\
    \ int, state: State, digit: int): Option[State] =\n        if digit == 0:\n  \
    \          return none(State)\n        some(next(pos, state, digit))\n    var\
    \ expected: array[4, Table[State, int64]]\n    for i in 0..3:\n        expected[i]\
    \ = initTable[State, int64]()\n    for value in 0..upper:\n        let digits\
    \ = toDigits(value, base)\n        let state: State = (remainder: value mod modulus,\
    \ length: digits.len)\n        let initialAllowed = digits[0] mod 2 == 1 and digits.len\
    \ mod 2 == 1\n        var nextAllowed = true\n        for pos in 1..<digits.len:\n\
    \            if digits[pos] == 0:\n                nextAllowed = false\n     \
    \   for i in 0..3:\n            if (i mod 2 == 0 or initialAllowed) and (i < 2\
    \ or nextAllowed):\n                expected[i][state] = expected[i].getOrDefault(state)\
    \ + 1\n    let digits = toDigits(upper, base)\n    template checkInputs(initializer,\
    \ transition, target: untyped) =\n        doAssert digitDp(upper, initializer,\
    \ transition, 0'i64, 1'i64, base) == target\n        doAssert digitDp(digits,\
    \ initializer, transition, 0'i64, 1'i64, base) == target\n        doAssert digitDp(@[0,\
    \ 0] & digits, initializer, transition,\n            0'i64, 1'i64, base) == target\n\
    \        if base == 10:\n            doAssert digitDp($upper, initializer, transition,\
    \ 0'i64, 1'i64) == target\n            doAssert digitDp(\"00\" & $upper, initializer,\
    \ transition, 0'i64, 1'i64) == target\n    checkInputs(initial, next, expected[0])\n\
    \    checkInputs(optionalInitial, next, expected[1])\n    checkInputs(initial,\
    \ optionalNext, expected[2])\n    checkInputs(optionalInitial, optionalNext, expected[3])\n\
    \n    var padded = initTable[State, int64]()\n    for value in 0..upper:\n   \
    \     let state: State = (remainder: value mod modulus, length: digits.len)\n\
    \        padded[state] = padded.getOrDefault(state) + 1\n    checkInputs((remainder:\
    \ 0, length: digits.len), next, padded)\n\n    if base == 10 and upper == 1234:\n\
    \        type Mint = modint998244353_montgomery\n        let actual = digitDp(upper,\
    \ optionalInitial, next, Mint.init(0), Mint.init(1))\n        doAssert actual.len\
    \ == expected[1].len\n        for state, count in expected[1]:\n            doAssert\
    \ actual[state] == Mint.init(count)\n\nfor base in [2, 3, 10, 16]:\n    for upper\
    \ in 0..80:\n        checkCallbacks(upper, base)\n    for upper in [99, 100, 101,\
    \ 999, 1000, 1234]:\n        checkCallbacks(upper, base)\n\nproc rejectInitial(firstDigit,\
    \ digitCount: int): Option[int] = none(int)\n\nproc unexpectedNext(pos, state,\
    \ digit: int): int =\n    doAssert false\n    state\n\nproc unexpectedOptionalNext(pos,\
    \ state, digit: int): Option[int] =\n    doAssert false\n    some(state)\n\ndoAssert\
    \ digitDp(0, rejectInitial, unexpectedNext, 0, 1).len == 0\ndoAssert digitDp(1234,\
    \ rejectInitial, unexpectedNext, 0, 1).len == 0\ndoAssert digitDp(\"1234\", rejectInitial,\
    \ unexpectedOptionalNext, 0, 1).len == 0\n\nproc initialNested(firstDigit, digitCount:\
    \ int): Option[Option[int]] = some(none(int))\nproc initialNestedDirect(firstDigit,\
    \ digitCount: int): Option[int] = none(int)\nproc nextNested(pos: int, state:\
    \ Option[int], digit: int): Option[int] = state\n\nblock:\n    let expected =\
    \ {none(int): 13}.toTable\n    doAssert digitDp(12, initialNested, nextNested,\
    \ 0, 1) == expected\n    doAssert digitDp(12, initialNestedDirect, nextNested,\
    \ 0, 1) == expected\n    doAssert digitDp(12, none(int), nextNested, 0, 1) ==\
    \ expected\n\nproc init(firstDigit, digitCount: int): Option[State] =\n    if\
    \ firstDigit != 1:\n        return none(State)\n    some((remainder: 1, length:\
    \ digitCount))\n\nproc nxt(value: string): string = value\nproc nxt(pos: int,\
    \ state: State, digit: int): State =\n    (remainder: (state.remainder * 10 +\
    \ digit) mod 7, length: state.length)\n\nproc optionalNxt(pos: int, state: State,\
    \ digit: int): Option[State] = some(nxt(pos, state, digit))\n\nblock:\n    let\
    \ expected = {\n        (remainder: 1, length: 1): 1,\n        (remainder: 3,\
    \ length: 2): 1,\n        (remainder: 4, length: 2): 1,\n        (remainder: 5,\
    \ length: 2): 1\n    }.toTable\n    doAssert digitDp(12, init, nxt, 0, 1) == expected\n\
    \    doAssert digitDp(\"12\", init, nxt, 0, 1) == expected\n    doAssert digitDp(@[1,\
    \ 2], init, nxt, 0, 1) == expected\n    doAssert digitDp(12, init, optionalNxt,\
    \ 0, 1) == expected\n    doAssert digitDp(\"12\", init, optionalNxt, 0, 1) ==\
    \ expected\n    doAssert digitDp(@[1, 2], init, optionalNxt, 0, 1) == expected\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/utils/digit_dp.nim
  - cplib/utils/digit_dp.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/utils/digit_dp_callbacks_test.nim
  requiredBy: []
  timestamp: '2026-10-08 11:39:33+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/digit_dp_callbacks_test.nim
layout: document
redirect_from:
- /verify/verify/utils/digit_dp_callbacks_test.nim
- /verify/verify/utils/digit_dp_callbacks_test.nim.html
title: verify/utils/digit_dp_callbacks_test.nim
---
