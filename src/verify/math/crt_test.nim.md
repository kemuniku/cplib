---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/crt.nim
    title: cplib/math/crt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/crt.nim
    title: cplib/math/crt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
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
    import math, random\nimport cplib/math/crt\nimport cplib/math/bigint\n\nproc normalized(a,\
    \ m: int): int =\n    result = a mod m\n    if result < 0: result += m\n\nproc\
    \ checkSmall(r, m: seq[int]) =\n    var period = 1\n    for modulus in m: period\
    \ = lcm(period, modulus)\n    var expected = (0, 0)\n    var solutions = 0\n \
    \   for x in 0..<period:\n        var valid = true\n        for i in 0..<r.len:\n\
    \            if x mod m[i] != normalized(r[i], m[i]): valid = false\n        if\
    \ valid:\n            expected = (x, period)\n            inc solutions\n    doAssert\
    \ solutions <= 1\n    doAssert crt(r, m) == expected\n    var rr, mm: seq[int]\n\
    \    for i in countdown(r.len - 1, 0):\n        rr.add(r[i] + 3 * m[i])\n    \
    \    mm.add(m[i])\n    doAssert crt(rr, mm) == expected\n    if m.len > 0:\n \
    \       rr.add(r[0])\n        mm.add(m[0])\n        doAssert crt(rr, mm) == expected\n\
    \ndoAssert crt([], []) == (0, 1)\ndoAssert crt([2, 3, 2], [3, 5, 7]) == (23, 105)\n\
    doAssert crt([4, 4], [6, 8]) == (4, 24)\ndoAssert crt([0, 1], [2, 4]) == (0, 0)\n\
    doAssert crt([-1, -1], [3, 5]) == (14, 15)\ndoAssert crt([100, -999], [1, 1])\
    \ == (0, 1)\ndoAssert crt([3, 3, 3], [4, 8, 8]) == (3, 8)\n\nfor m0 in 1..12:\n\
    \    for m1 in 1..12:\n        for r0 in 0..<m0:\n            for r1 in 0..<m1:\n\
    \                checkSmall(@[r0, r1], @[m0, m1])\nvar rng = initRand(193)\nfor\
    \ iteration in 0..<1000:\n    var r, m: seq[int]\n    for i in 0..<rng.rand(0..5):\n\
    \        m.add(rng.rand(1..10))\n        r.add(rng.rand(-100..100))\n    checkSmall(r,\
    \ m)\n\nproc expectInvalid(r, m: seq[int]) =\n    var caught = false\n    try:\
    \ discard crt(r, m)\n    except ValueError: caught = true\n    doAssert caught\n\
    \nexpectInvalid(@[0], @[])\nexpectInvalid(@[], @[1])\nexpectInvalid(@[0], @[0])\n\
    expectInvalid(@[0], @[-1])\nexpectInvalid(@[0], @[low(int)])\nexpectInvalid(@[0,\
    \ 1, 0], @[2, 2, 0])\n\ndoAssert crt([low(int)], [high(int)]) == (high(int) -\
    \ 1, high(int))\ndoAssert crt([low(int), high(int)], [1, high(int)]) == (0, high(int))\n\
    doAssert crt([high(int) - 1, -1], [high(int), high(int)]) == (high(int) - 1,\n\
    \        high(int))\ndoAssert crt([0, 1], [high(int) - 1, 2]) == (0, 0)\nlet shared\
    \ = high(int) div 3\nlet period = shared * 3\ndoAssert crt([period - 1, -1], [period,\
    \ shared]) == (period - 1, period)\ndoAssert crt([low(int), low(int)], [high(int)\
    \ - 1, 2]) == (high(int) - 3, high(\n        int) - 1)\ndoAssert crt([0, 0], [high(int)\
    \ div 2, 2]) == (0, high(int) - 1)\ndoAssert crt([high(int) - 1, 0], [high(int),\
    \ 1]) == (high(int) - 1, high(int))\ndoAssert crt([int(uint(high(int)))], [high(int)])\
    \ == (0, high(int))\n\nproc expectOverflow(r, m: seq[int]) =\n    var caught =\
    \ false\n    try: discard crt(r, m)\n    except OverflowDefect: caught = true\n\
    \    doAssert caught\n\nexpectOverflow(@[0, 0], @[high(int), 2])\nexpectOverflow(@[0,\
    \ 0], @[high(int), high(int) - 1])\nexpectOverflow(@[0, 0, 1], @[high(int), 2,\
    \ 2])\n\nproc checkLarge(r, m: seq[int]) =\n    let zero = initBigInt(0)\n   \
    \ let one = initBigInt(1)\n    let limit = initBigInt(high(int))\n    var period\
    \ = one\n    var inconsistent, overflow = false\n    for endIndex in 0..<m.len:\n\
    \        for i in 0..<endIndex:\n            let difference = initBigInt(r[i])\
    \ - initBigInt(r[endIndex])\n            if difference mod initBigInt(gcd(m[i],\
    \ m[endIndex])) != zero:\n                inconsistent = true\n        if inconsistent:\
    \ break\n        let modulus = initBigInt(m[endIndex])\n        period = period\
    \ div gcd(period, modulus) * modulus\n        if period > limit:\n           \
    \ overflow = true\n            break\n    if overflow:\n        expectOverflow(r,\
    \ m)\n    elif inconsistent:\n        doAssert crt(r, m) == (0, 0)\n    else:\n\
    \        var value = zero\n        var product = one\n        for i in 0..<m.len:\n\
    \            let modulus = initBigInt(m[i])\n            let divisor = gcd(product,\
    \ modulus)\n            let factor = modulus div divisor\n            var a =\
    \ product div divisor\n            var b = factor\n            var inverse = one\n\
    \            var nextInverse = zero\n            while b != zero:\n          \
    \      let quotient = a div b\n                (a, b) = (b, a - quotient * b)\n\
    \                (inverse, nextInverse) = (nextInverse, inverse - quotient * nextInverse)\n\
    \            let delta = (initBigInt(r[i]) - value) div divisor\n            var\
    \ shift = delta * inverse mod factor\n            if shift < zero: shift += factor\n\
    \            value += product * shift\n            product *= factor\n       \
    \ let actual = crt(r, m)\n        doAssert initBigInt(actual.r) == value\n   \
    \     doAssert initBigInt(actual.m) == period\n        doAssert actual.r >= 0\
    \ and actual.r < actual.m\n\nwhen sizeof(int) == 8:\n    let boundaries = [low(int),\
    \ low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]\n    let moduliForLarge =\
    \ [1, 2, 3, 4, 7, 97, int((1'i64 shl 31) - 1),\n                  int(1'i64 shl\
    \ 32), high(int) div 3, high(int) div 2,\n                  high(int) - 1, high(int)]\n\
    \    for a in moduliForLarge:\n        for b in moduliForLarge:\n            for\
    \ r in boundaries:\n                for s in boundaries:\n                   \
    \ checkLarge(@[r, s], @[a, b])\n    var largeRng = initRand(247)\n    for iteration\
    \ in 0..<3000:\n        var residues, moduli: seq[int]\n        for i in 0..<largeRng.rand(1..6):\n\
    \            let modulus = if largeRng.rand(1) == 0:\n                largeRng.rand(1..high(int))\n\
    \            else: moduliForLarge[largeRng.rand(moduliForLarge.high)]\n      \
    \      moduli.add(modulus)\n            let magnitude = largeRng.rand(0..high(int))\n\
    \            residues.add(if largeRng.rand(1) == 0: magnitude else: -magnitude\
    \ - 1)\n        checkLarge(residues, moduli)\n        let value = largeRng.rand(0..high(int))\n\
    \        for i in 0..<residues.len: residues[i] = value\n        checkLarge(residues,\
    \ moduli)\n        let divisor = largeRng.rand(1..high(int) div 120)\n       \
    \ for i in 0..<moduli.len: moduli[i] = divisor * largeRng.rand(1..10)\n      \
    \  checkLarge(residues, moduli)\n\nproc oversleeping(x, y, p, q: int): int =\n\
    \    result = high(int)\n    for a in x..<x+y:\n        for b in p..<p+q:\n  \
    \          let answer = crt([a, b], [2*(x+y), p+q])\n            if answer.m !=\
    \ 0: result = min(result, answer.r)\n\nfor x in 1..4:\n    for y in 1..4:\n  \
    \      for p in 1..4:\n            for q in 1..4:\n                var expected\
    \ = high(int)\n                for t in 0..<lcm(2*(x+y), p+q):\n             \
    \       if x <= t mod (2*(x+y)) and t mod (2*(x+y)) < x+y and\n              \
    \              p <= t mod (p+q) and t mod (p+q) < p+q:\n                     \
    \   expected = t\n                        break\n                doAssert oversleeping(x,\
    \ y, p, q) == expected\n\ndoAssert oversleeping(5, 2, 7, 6) == 20\ndoAssert oversleeping(1,\
    \ 1, 3, 1) == high(int)\nwhen sizeof(int) == 8:\n    doAssert oversleeping(999999999,\
    \ 1, 1000000000, 1) == 1000000000999999999'i64\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/math/crt.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/math/bigint.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/bigint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/crt.nim
  - cplib/math/isprime.nim
  isVerificationFile: true
  path: verify/math/crt_test.nim
  requiredBy: []
  timestamp: '2026-10-08 06:34:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/crt_test.nim
layout: document
redirect_from:
- /verify/verify/math/crt_test.nim
- /verify/verify/math/crt_test.nim.html
title: verify/math/crt_test.nim
---
