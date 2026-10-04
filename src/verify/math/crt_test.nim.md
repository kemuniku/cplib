---
data:
  _extendedDependsOn:
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
    import math, random\nimport cplib/math/crt\n\nproc normalized(a, m: int): int\
    \ =\n    result = a mod m\n    if result < 0: result += m\n\nproc checkSmall(r,\
    \ m: seq[int]) =\n    var period = 1\n    for modulus in m: period = lcm(period,\
    \ modulus)\n    var expected = (0, 0)\n    var solutions = 0\n    for x in 0..<period:\n\
    \        var valid = true\n        for i in 0..<r.len:\n            if x mod m[i]\
    \ != normalized(r[i], m[i]): valid = false\n        if valid:\n            expected\
    \ = (x, period)\n            inc solutions\n    doAssert solutions <= 1\n    doAssert\
    \ crt(r, m) == expected\n    var rr, mm: seq[int]\n    for i in countdown(r.len\
    \ - 1, 0):\n        rr.add(r[i] + 3 * m[i])\n        mm.add(m[i])\n    doAssert\
    \ crt(rr, mm) == expected\n    if m.len > 0:\n        rr.add(r[0])\n        mm.add(m[0])\n\
    \        doAssert crt(rr, mm) == expected\n\ndoAssert crt([], []) == (0, 1)\n\
    doAssert crt([2, 3, 2], [3, 5, 7]) == (23, 105)\ndoAssert crt([4, 4], [6, 8])\
    \ == (4, 24)\ndoAssert crt([0, 1], [2, 4]) == (0, 0)\ndoAssert crt([-1, -1], [3,\
    \ 5]) == (14, 15)\ndoAssert crt([100, -999], [1, 1]) == (0, 1)\ndoAssert crt([3,\
    \ 3, 3], [4, 8, 8]) == (3, 8)\n\nfor m0 in 1..12:\n    for m1 in 1..12:\n    \
    \    for r0 in 0..<m0:\n            for r1 in 0..<m1:\n                checkSmall(@[r0,\
    \ r1], @[m0, m1])\nvar rng = initRand(193)\nfor iteration in 0..<1000:\n    var\
    \ r, m: seq[int]\n    for i in 0..<rng.rand(0..5):\n        m.add(rng.rand(1..10))\n\
    \        r.add(rng.rand(-100..100))\n    checkSmall(r, m)\n\nproc expectInvalid(r,\
    \ m: seq[int]) =\n    var caught = false\n    try: discard crt(r, m)\n    except\
    \ ValueError: caught = true\n    doAssert caught\n\nexpectInvalid(@[0], @[])\n\
    expectInvalid(@[], @[1])\nexpectInvalid(@[0], @[0])\nexpectInvalid(@[0], @[-1])\n\
    expectInvalid(@[0], @[low(int)])\nexpectInvalid(@[0, 1, 0], @[2, 2, 0])\n\ndoAssert\
    \ crt([low(int)], [high(int)]) == (high(int) - 1, high(int))\ndoAssert crt([low(int),\
    \ high(int)], [1, high(int)]) == (0, high(int))\ndoAssert crt([high(int) - 1,\
    \ -1], [high(int), high(int)]) == (high(int) - 1, high(int))\ndoAssert crt([0,\
    \ 1], [high(int) - 1, 2]) == (0, 0)\nlet shared = high(int) div 3\nlet period\
    \ = shared * 3\ndoAssert crt([period - 1, -1], [period, shared]) == (period -\
    \ 1, period)\ndoAssert crt([low(int), low(int)], [high(int) - 1, 2]) == (high(int)\
    \ - 3, high(int) - 1)\ndoAssert crt([0, 0], [high(int) div 2, 2]) == (0, high(int)\
    \ - 1)\ndoAssert crt([high(int) - 1, 0], [high(int), 1]) == (high(int) - 1, high(int))\n\
    doAssert crt([int(uint(high(int)))], [high(int)]) == (0, high(int))\n\nproc expectOverflow(r,\
    \ m: seq[int]) =\n    var caught = false\n    try: discard crt(r, m)\n    except\
    \ OverflowDefect: caught = true\n    doAssert caught\n\nexpectOverflow(@[0, 0],\
    \ @[high(int), 2])\nexpectOverflow(@[0, 0], @[high(int), high(int) - 1])\nexpectOverflow(@[0,\
    \ 0, 1], @[high(int), 2, 2])\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/inv_gcd.nim
  - cplib/math/int128.nim
  - cplib/math/crt.nim
  - cplib/math/crt.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/int128.nim
  isVerificationFile: true
  path: verify/math/crt_test.nim
  requiredBy: []
  timestamp: '2026-10-02 19:57:44+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/crt_test.nim
layout: document
redirect_from:
- /verify/verify/math/crt_test.nim
- /verify/verify/math/crt_test.nim.html
title: verify/math/crt_test.nim
---
