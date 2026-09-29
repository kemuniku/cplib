---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/multiplicative_prefix_sum.nim
    title: cplib/math/multiplicative_prefix_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/multiplicative_prefix_sum.nim
    title: cplib/math/multiplicative_prefix_sum.nim
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
    import random, strutils\nimport cplib/modint/modint\nimport cplib/math/multiplicative_prefix_sum\n\
    \nproc naive[T](limit: int, coefficients: seq[T], primePower: proc(p, e: int):\
    \ T {.closure.}): seq[T] =\n    result = newSeq[T](limit + 1)\n    for n in 1..limit:\n\
    \        var rest = n\n        var value = init(T, 1)\n        var p = 2\n   \
    \     while p <= rest div p:\n            if rest mod p == 0:\n              \
    \  var exponent = 0\n                while rest mod p == 0:\n                \
    \    rest = rest div p\n                    inc exponent\n                if exponent\
    \ == 1:\n                    var primeValue = init(T, 0)\n                   \
    \ for i in countdown(coefficients.len - 1, 0):\n                        primeValue\
    \ = primeValue * p + coefficients[i]\n                    value *= primeValue\n\
    \                else:\n                    value *= primePower(p, exponent)\n\
    \            inc p\n        if rest > 1:\n            var primeValue = init(T,\
    \ 0)\n            for i in countdown(coefficients.len - 1, 0):\n             \
    \   primeValue = primeValue * rest + coefficients[i]\n            value *= primeValue\n\
    \        result[n] = result[n - 1] + value\n\nproc check[T](coefficients: seq[T],\
    \ primePower: proc(p, e: int): T {.closure.}, thorough: bool) =\n    const limit\
    \ = 20000\n    let expected = naive(limit, coefficients, primePower)\n    var\
    \ queries = @[0, 1, 2, 3, 4, 8, 27, 64, 121, 256, 1024, 4095, 4096,\n        \
    \            4097, 4098, 4099, 4224, 4225, 4226, 6560, 6561, 6562,\n         \
    \           8191, 8192, 8193, 9408, 9409, 9410, 16383, 16384, 16385, limit]\n\
    \    if thorough:\n        for n in 0..80:\n            queries.add(n)\n     \
    \   var rng = initRand(380719)\n        for _ in 0..<20:\n            queries.add(rng.rand(4097..limit))\n\
    \    for query in queries:\n        let n = query\n        let callback = proc(p,\
    \ e: int): T =\n            doAssert e >= 2\n            var power = 1\n     \
    \       for _ in 0..<e:\n                doAssert power <= n div p\n         \
    \       power *= p\n            primePower(p, e)\n        let actual = multiplicativePrefixSum(n,\
    \ coefficients, callback)\n        doAssert actual == expected[n], \"n=\" & $n\
    \ & \" actual=\" & $actual & \" expected=\" & $expected[n]\n\nproc standard[T](thorough:\
    \ bool) =\n    check(@[init(T, -1), init(T, 1)], proc(p, e: int): T =\n      \
    \  init(T, p).pow(e - 1) * (p - 1), thorough)\n    check(@[init(T, 2)], proc(p,\
    \ e: int): T = init(T, e + 1), thorough)\n    check(@[init(T, 1), init(T, 1)],\
    \ proc(p, e: int): T =\n        var value = init(T, 1)\n        for _ in 0..<e:\n\
    \            value = value * p + 1\n        value, thorough)\n    check(@[init(T,\
    \ -1)], proc(p, e: int): T = init(T, 0), thorough)\n    check(@[init(T, 1)], proc(p,\
    \ e: int): T = init(T, 0), thorough)\n    check(@[init(T, 0), init(T, 0), init(T,\
    \ 1)], proc(p, e: int): T =\n        init(T, p).pow(2 * e), thorough)\n    check(newSeq[T](),\
    \ proc(p, e: int): T = init(T, e * e + p), thorough)\n    check(@[init(T, 2),\
    \ init(T, -3), init(T, 4), init(T, 0), init(T, -2), init(T, 1)], proc(p, e: int):\
    \ T =\n        init(T, p).pow(e) + e * e - 7, thorough)\n\nstandard[modint998244353_montgomery](true)\n\
    standard[modint1000000007_barrett](false)\nstandard[StaticMontgomeryModint[469762049'u32]](false)\n\
    \ntype Dynamic = modint_barrett\nfor modulus in [998244353, 1_000_000_007, 469762049]:\n\
    \    Dynamic.setMod(modulus)\n    check(@[init(Dynamic, -1), init(Dynamic, 1),\
    \ init(Dynamic, 0)], proc(p, e: int): Dynamic =\n        init(Dynamic, p).pow(e\
    \ - 1) * (p - 1), false)\n\nfor modulus in [2, 3, 7, 17]:\n    Dynamic.setMod(modulus)\n\
    \    check(@[init(Dynamic, 2)], proc(p, e: int): Dynamic = init(Dynamic, e + 1),\
    \ false)\n\ntype Mint = modint998244353_montgomery\nwhen compileOption(\"assertions\"\
    ):\n    for invalid in [-1, (1 shl 40) + 1]:\n        var rejected = false\n \
    \       try:\n            discard multiplicativePrefixSum(invalid, @[init(Mint,\
    \ 1)],\n                proc(p, e: int): Mint = init(Mint, 1))\n        except\
    \ AssertionDefect as error:\n            doAssert (if invalid < 0: \"n \u306F\u975E\
    \u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n       \
    \               else: \"n \u306F 2^40 \u4EE5\u4E0B\u3067\u3042\u308B\u5FC5\u8981\
    \u304C\u3042\u308A\u307E\u3059\") in error.msg\n            rejected = true\n\
    \        doAssert rejected\n\nvar rng = initRand(923748)\nfor _ in 0..<12:\n \
    \   var coefficients = newSeq[Mint](rng.rand(0..6))\n    for x in coefficients.mitems:\n\
    \        x = init(Mint, rng.rand(-10..10))\n    let u = init(Mint, rng.rand(-10..10))\n\
    \    let v = init(Mint, rng.rand(-10..10))\n    check(coefficients, proc(p, e:\
    \ int): Mint = u * p + v * e * e, false)\n\nlet n = 1_000_000\nlet constant =\
    \ multiplicativePrefixSum(n, @[init(Mint, 1)], proc(p, e: int): Mint = init(Mint,\
    \ 1))\ndoAssert constant == init(Mint, n)\nlet identity = multiplicativePrefixSum(n,\
    \ @[init(Mint, 0), init(Mint, 1)],\n    proc(p, e: int): Mint = init(Mint, p).pow(e))\n\
    doAssert identity == init(Mint, n) * (n + 1) / 2\nlet totient = multiplicativePrefixSum(n,\
    \ @[init(Mint, -1), init(Mint, 1)],\n    proc(p, e: int): Mint = init(Mint, p).pow(e\
    \ - 1) * (p - 1))\nvar phi = newSeq[int](n + 1)\nfor i in 0..n:\n    phi[i] =\
    \ i\nfor p in 2..n:\n    if phi[p] == p:\n        for k in countup(p, n, p):\n\
    \            phi[k] -= phi[k] div p\nvar expected = init(Mint, 0)\nfor i in 1..n:\n\
    \    expected += phi[i]\ndoAssert totient == expected\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/math/multiplicative_prefix_sum.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/math/multiplicative_prefix_sum.nim
  isVerificationFile: true
  path: verify/AI/multiplicative_prefix_sum_test.nim
  requiredBy: []
  timestamp: '2026-09-29 03:52:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/multiplicative_prefix_sum_test.nim
layout: document
redirect_from:
- /verify/verify/AI/multiplicative_prefix_sum_test.nim
- /verify/verify/AI/multiplicative_prefix_sum_test.nim.html
title: verify/AI/multiplicative_prefix_sum_test.nim
---
