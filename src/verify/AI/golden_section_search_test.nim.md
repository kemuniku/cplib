---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/golden_section_search.nim
    title: cplib/utils/golden_section_search.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/golden_section_search.nim
    title: cplib/utils/golden_section_search.nim
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
    \nimport math, random, sets\nimport cplib/utils/golden_section_search\n\nproc\
    \ checkInteger(values: seq[int], left: int, maximize: bool) =\n    var seen =\
    \ initHashSet[int]()\n    proc f(x: int): int =\n        doAssert left <= x and\
    \ x <= left + values.high\n        doAssert x notin seen\n        seen.incl(x)\n\
    \        values[x - left]\n    let answer = golden_section_search(left, left +\
    \ values.high, f,\n        maximize = maximize)\n    var expected = values[0]\n\
    \    for value in values:\n        if (if maximize: expected < value else: value\
    \ < expected):\n            expected = value\n    doAssert left <= answer.x and\
    \ answer.x <= left + values.high\n    doAssert answer.fx == values[answer.x -\
    \ left]\n    doAssert answer.fx == expected\n    doAssert seen.len <= 2 + int(ceil(ln(float(values.len\
    \ + 1)) / ln(1.618033988749895)))\n\nblock:\n    var rng = initRand(20260926)\n\
    \    for n in 1..24:\n        for first in 0..<n:\n            for last in first..<n:\n\
    \                var values = newSeq[int](n)\n                for i in countdown(first\
    \ - 1, 0):\n                    values[i] = values[i + 1] + rng.rand(1..20)\n\
    \                for i in last + 1..<n:\n                    values[i] = values[i\
    \ - 1] + rng.rand(1..20)\n                checkInteger(values, -n div 2, false)\n\
    \                for value in values.mitems: value = -value\n                checkInteger(values,\
    \ -n div 2, true)\n    for _ in 0..<1000:\n        let n = rng.rand(1..1000)\n\
    \        let first = rng.rand(0..<n)\n        let last = rng.rand(first..<n)\n\
    \        var values = newSeq[int](n)\n        for i in countdown(first - 1, 0):\n\
    \            values[i] = values[i + 1] + rng.rand(1..100)\n        for i in last\
    \ + 1..<n:\n            values[i] = values[i - 1] + rng.rand(1..100)\n       \
    \ checkInteger(values, rng.rand(-10000..10000), false)\n        for value in values.mitems:\
    \ value = -value\n        checkInteger(values, rng.rand(-10000..10000), true)\n\
    \nblock:\n    proc f(x: int): float = float((x - 7) * (x - 7)) + 0.5\n    let\
    \ answer = golden_section_search(-10, 20, f)\n    doAssert answer == (x: 7, fx:\
    \ 0.5)\n\ntype Score = object\n    value: int\nproc `<`(a, b: Score): bool = a.value\
    \ < b.value\n\nblock:\n    proc f(x: int): Score = Score(value: abs(x - 4))\n\
    \    let answer = golden_section_search(-20, 20, f)\n    doAssert answer.x ==\
    \ 4 and answer.fx.value == 0\n    let maximum = golden_section_search(-20, 4,\
    \ f, maximize = true)\n    doAssert maximum.x == -20 and maximum.fx.value == 24\n\
    \nblock:\n    proc checkWide(left, right: int, maximize: bool) =\n        var\
    \ seen = initHashSet[int]()\n        proc f(x: int): int =\n            doAssert\
    \ left <= x and x <= right\n            doAssert x notin seen\n            seen.incl(x)\n\
    \            x\n        let answer = golden_section_search(left, right, f, maximize\
    \ = maximize)\n        let expected = if maximize: right else: left\n        doAssert\
    \ answer == (x: expected, fx: expected)\n        doAssert seen.len <= sizeof(int)\
    \ * 12 + 2\n    for (left, right) in [(low(int), high(int)), (low(int), 0), (0,\
    \ high(int)),\n            (low(int), low(int)), (high(int), high(int)),\n   \
    \         (low(int), low(int) + 1), (high(int) - 1, high(int)),\n            (low(int),\
    \ low(int) + 100), (high(int) - 100, high(int))]:\n        checkWide(left, right,\
    \ false)\n        checkWide(left, right, true)\n\n    for target in [low(int),\
    \ low(int) + 1, low(int) div 2, -1, 0, 1,\n            high(int) div 2, high(int)\
    \ - 1, high(int)]:\n        for maximize in [false, true]:\n            var seen\
    \ = initHashSet[int]()\n            proc f(x: int): uint =\n                doAssert\
    \ x notin seen\n                seen.incl(x)\n                let distance = if\
    \ x < target:\n                    cast[uint](target) - cast[uint](x)\n      \
    \          else:\n                    cast[uint](x) - cast[uint](target)\n   \
    \             if maximize: high(uint) - distance else: distance\n            let\
    \ answer = golden_section_search(low(int), high(int), f,\n                maximize\
    \ = maximize)\n            doAssert answer.x == target\n            doAssert answer.fx\
    \ == (if maximize: high(uint) else: 0'u)\n            doAssert seen.len <= sizeof(int)\
    \ * 12 + 2\n\nproc checkFloat[T: SomeFloat](tolerance: T) =\n    for target in\
    \ [T(-12), T(-10), T(-3.125), T(0), T(4.375), T(10), T(12)]:\n        for maximize\
    \ in [false, true]:\n            var calls = 0\n            proc f(x: T): T =\n\
    \                doAssert T(-10) <= x and x <= T(10)\n                inc calls\n\
    \                if maximize: -abs(x - target) else: abs(x - target)\n       \
    \     let answer = golden_section_search(T(-10), T(10), f,\n                maximize\
    \ = maximize)\n            let expected = min(T(10), max(T(-10), target))\n  \
    \          doAssert abs(answer.x - expected) <= tolerance\n            let expectedValue\
    \ = if maximize: -abs(answer.x - target) else: abs(answer.x - target)\n      \
    \      doAssert answer.fx == expectedValue\n            doAssert calls <= 104\n\
    \n    block:\n        var calls = 0\n        proc f(x: T): T =\n            inc\
    \ calls\n            x * x\n        let answer = golden_section_search(T(3), T(3),\
    \ f)\n        doAssert answer == (x: T(3), fx: T(9))\n        doAssert calls ==\
    \ 1\n\n    block:\n        var calls = 0\n        proc f(x: T): T =\n        \
    \    inc calls\n            abs(x - T(0.25))\n        let answer = golden_section_search(T(0),\
    \ T(1), f, iterations = 0)\n        doAssert T(0) <= answer.x and answer.x <=\
    \ T(1)\n        doAssert answer.fx == abs(answer.x - T(0.25))\n        doAssert\
    \ calls == 4\n        let refined = golden_section_search(T(0), T(1), f, iterations\
    \ = 20)\n        doAssert refined.fx <= answer.fx\n\n    block:\n        proc\
    \ f(x: T): T = max(T(0), abs(x) - T(2))\n        let answer = golden_section_search(T(-10),\
    \ T(10), f)\n        doAssert abs(answer.x) <= T(2)\n        doAssert answer.fx\
    \ == T(0)\n\n    block:\n        proc f(x: T): T = T(7)\n        let answer =\
    \ golden_section_search(T(-10), T(10), f, iterations = 1000)\n        doAssert\
    \ T(-10) <= answer.x and answer.x <= T(10)\n        doAssert answer.fx == T(7)\n\
    \ncheckFloat[float64](1e-10)\ncheckFloat[float32](1e-5'f32)\n\nblock:\n    for\
    \ maximize in [false, true]:\n        proc f(x: float): float =\n            let\
    \ value = (x - 3.0) * (x - 3.0) + 2.0\n            if maximize: -value else: value\n\
    \        let answer = golden_section_search(-10.0, 10.0, f, maximize = maximize)\n\
    \        doAssert abs(answer.x - 3.0) <= 1e-7\n        doAssert abs(abs(answer.fx)\
    \ - 2.0) <= 1e-12\n\nblock:\n    let left = 1.0\n    let right = 1.0000000000000002\n\
    \    var calls = 0\n    proc f(x: float): float =\n        doAssert x == left\
    \ or x == right\n        inc calls\n        x\n    doAssert golden_section_search(left,\
    \ right, f).x == left\n    doAssert calls == 2\n    calls = 0\n    doAssert golden_section_search(left,\
    \ right, f, maximize = true).x == right\n    doAssert calls == 2\n\nblock:\n \
    \   for (left, right) in [(-1.7e308, 1.7e308), (1.6e308, 1.7e308),\n         \
    \   (-1.7e308, -1.6e308)]:\n        for maximize in [false, true]:\n         \
    \   proc f(x: float): float =\n                doAssert left <= x and x <= right\n\
    \                let value = abs(x / 1e308 - 0.25)\n                if maximize:\
    \ -value else: value\n            let answer = golden_section_search(left, right,\
    \ f, maximize = maximize)\n            let expected = max(left, min(right, 0.25e308))\n\
    \            doAssert abs(answer.x / 1e308 - expected / 1e308) < 1e-12\n     \
    \       doAssert answer.fx == f(answer.x)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/golden_section_search.nim
  - cplib/utils/golden_section_search.nim
  isVerificationFile: true
  path: verify/AI/golden_section_search_test.nim
  requiredBy: []
  timestamp: '2026-09-27 01:47:52+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/golden_section_search_test.nim
layout: document
redirect_from:
- /verify/verify/AI/golden_section_search_test.nim
- /verify/verify/AI/golden_section_search_test.nim.html
title: verify/AI/golden_section_search_test.nim
---
