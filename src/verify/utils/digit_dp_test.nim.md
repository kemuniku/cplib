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
    \nimport algorithm, hashes, options, strutils, tables\nimport cplib/utils/digit_dp\n\
    import cplib/modint/modint\n\nproc toDigits(value, base: int): seq[int] =\n  \
    \  var value = value\n    while value > 0:\n        result.add(value mod base)\n\
    \        value = value div base\n    if result.len == 0:\n        result.add(0)\n\
    \    result.reverse()\n\nproc checkRemainders(base, modulus, upper: int) =\n \
    \   let next = proc(pos, state, digit: int): Option[int] =\n        some((state\
    \ * base + digit) mod modulus)\n    let actual = digitDp(toDigits(upper, base),\
    \ 0, next, 0'i64, 1'i64, base)\n    var expected = initTable[int, int64]()\n \
    \   for value in 0..upper:\n        let remainder = value mod modulus\n      \
    \  expected[remainder] = expected.getOrDefault(remainder) + 1\n    doAssert actual\
    \ == expected\n    doAssert digitDp(upper, 0, next, 0'i64, 1'i64, base) == expected\n\
    \    if base == 10:\n        doAssert digitDp($upper, 0, next, 0'i64, 1'i64) ==\
    \ expected\n        doAssert digitDp(\"00\" & $upper, 0, next, 0'i64, 1'i64) ==\
    \ expected\n\nfor base in [2, 3, 10, 16]:\n    for modulus in [1, 2, 7, 13]:\n\
    \        for upper in 0..120:\n            checkRemainders(base, modulus, upper)\n\
    \ntype State = tuple[last: int, started: bool]\n\nproc nextDistinct(pos: int,\
    \ state: State, digit: int): Option[State] =\n    if not state.started and digit\
    \ == 0:\n        return some(state)\n    if state.started and state.last == digit:\n\
    \        return none(State)\n    some((last: digit, started: true))\n\nfor upper\
    \ in [0, 1, 9, 10, 11, 99, 100, 101, 999, 1024]:\n    let initial: State = (last:\
    \ 0, started: false)\n    var expected = initTable[State, int64]()\n    expected[initial]\
    \ = 1\n    for value in 1..upper:\n        let digits = $value\n        var valid\
    \ = true\n        for pos in 1..<digits.len:\n            if digits[pos] == digits[pos\
    \ - 1]:\n                valid = false\n        if valid:\n            let state:\
    \ State = (last: value mod 10, started: true)\n            expected[state] = expected.getOrDefault(state)\
    \ + 1\n    doAssert digitDp($upper, initial, nextDistinct, 0'i64, 1'i64) == expected\n\
    \    doAssert digitDp(upper, initial, nextDistinct, 0'i64, 1'i64) == expected\n\
    \    doAssert digitDp(\"00\" & $upper, initial, nextDistinct, 0'i64, 1'i64) ==\
    \ expected\n\ntype PositionState = object\n    value: int\n\nproc hash(state:\
    \ PositionState): Hash = hash(state.value)\n\nproc nextPosition(pos: int, state:\
    \ PositionState, digit: int): Option[PositionState] =\n    if pos == 1 and digit\
    \ == 5:\n        return none(PositionState)\n    some(PositionState(value: state.value\
    \ + (pos + 1) * digit))\n\nblock:\n    var expected = initTable[PositionState,\
    \ int]()\n    for value in 0..357:\n        let\n            a = value div 100\n\
    \            b = value div 10 mod 10\n            c = value mod 10\n        if\
    \ b != 5:\n            let state = PositionState(value: 7 + a + 2 * b + 3 * c)\n\
    \            expected[state] = expected.getOrDefault(state) + 1\n    doAssert\
    \ digitDp(\"357\", PositionState(value: 7), nextPosition, 0, 1) == expected\n\
    \    doAssert digitDp(357, PositionState(value: 7), nextPosition, 0, 1) == expected\n\
    \nproc rejectAll(pos, state, digit: int): Option[int] = none(int)\ndoAssert digitDp(\"\
    123\", 0, rejectAll, 0, 1).len == 0\n\nproc keepState(pos, state, digit: int):\
    \ Option[int] = some(state)\ndoAssert digitDp(\"0\", 42, keepState, 0'i64, 1'i64)[42]\
    \ == 1\ndoAssert digitDp(\"999999999999999999\", 42, keepState, 0'i64, 1'i64)[42]\
    \ ==\n    1_000_000_000_000_000_000'i64\ndoAssert digitDp(digits = 123, initialState\
    \ = 42, next = keepState,\n    zero = 0'i64, one = 1'i64)[42] == 124\ndoAssert\
    \ digitDp(7'i8, 0, keepState, 0, 1, base = 256)[0] == 8\ndoAssert digitDp(7'u8,\
    \ 0, keepState, 0, 1, base = 256)[0] == 8\ndoAssert digitDp(high(int64), 0, keepState,\
    \ 0'u64, 1'u64)[0] == (1'u64 shl 63)\n\nproc countDigits(pos, state, digit: int):\
    \ Option[int] = some(state + 1)\ndoAssert digitDp(0, 0, countDigits, 0, 1)[1]\
    \ == 1\ndoAssert digitDp(10, 0, countDigits, 0, 1)[2] == 11\ndoAssert digitDp(8,\
    \ 0, countDigits, 0, 1, base = 2)[4] == 9\n\ntype Mint = modint998244353_montgomery\n\
    block:\n    let upper = repeat(\"9\", 200)\n    let counts = digitDp(upper, 0,\
    \ keepState, Mint.init(0), Mint.init(1))\n    doAssert counts[0] == Mint.init(10).pow(upper.len)\n\
    \    doAssert digitDp(high(uint64), 0, keepState, Mint.init(0), Mint.init(1))[0]\
    \ ==\n        Mint.init(2).pow(64)\n\ntype ShiftedCount = object\n    encoded:\
    \ int\n\nproc `+`(a, b: ShiftedCount): ShiftedCount =\n    ShiftedCount(encoded:\
    \ a.encoded + b.encoded - 100)\n\nblock:\n    let counts = digitDp(\"99\", 0,\
    \ keepState,\n        ShiftedCount(encoded: 100), ShiftedCount(encoded: 101))\n\
    \    doAssert counts[0].encoded == 200\n\ntype ParityCount = distinct int\n\n\
    proc `+`(a, b: ParityCount): ParityCount = ParityCount((int(a) + int(b)) mod 2)\n\
    \nblock:\n    let counts = digitDp(\"19\", 0, keepState, ParityCount(0), ParityCount(1))\n\
    \    doAssert counts.hasKey(0)\n    doAssert int(counts[0]) == 0\n\ntemplate expectAssertion(body:\
    \ untyped) =\n    block:\n        var raised = false\n        try:\n         \
    \   body\n        except AssertionDefect:\n            raised = true\n       \
    \ doAssert raised\n\nexpectAssertion:\n    discard digitDp(newSeq[int](), 0, keepState,\
    \ 0, 1)\nexpectAssertion:\n    discard digitDp(@[0], 0, keepState, 0, 1, 1)\n\
    expectAssertion:\n    discard digitDp(@[-1], 0, keepState, 0, 1)\nexpectAssertion:\n\
    \    discard digitDp(@[10], 0, keepState, 0, 1)\nexpectAssertion:\n    discard\
    \ digitDp(-1, 0, keepState, 0, 1)\nexpectAssertion:\n    discard digitDp(low(int64),\
    \ 0, keepState, 0, 1)\nexpectAssertion:\n    discard digitDp(0, 0, keepState,\
    \ 0, 1, base = 1)\nexpectAssertion:\n    discard digitDp(\"\", 0, keepState, 0,\
    \ 1)\nexpectAssertion:\n    discard digitDp(\"-1\", 0, keepState, 0, 1)\nexpectAssertion:\n\
    \    discard digitDp(\"1a\", 0, keepState, 0, 1)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/digit_dp.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/utils/digit_dp.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/utils/digit_dp_test.nim
  requiredBy: []
  timestamp: '2026-10-08 11:39:33+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/digit_dp_test.nim
layout: document
redirect_from:
- /verify/verify/utils/digit_dp_test.nim
- /verify/verify/utils/digit_dp_test.nim.html
title: verify/utils/digit_dp_test.nim
---
