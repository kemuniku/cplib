---
data:
  _extendedDependsOn:
  - icon: ':x:'
    path: cplib/math/monoid_floor_sum.nim
    title: cplib/math/monoid_floor_sum.nim
  - icon: ':x:'
    path: cplib/math/monoid_floor_sum.nim
    title: cplib/math/monoid_floor_sum.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
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
    \nimport cplib/math/monoid_floor_sum\nimport random, strutils\n\nproc concat(l,\
    \ r: string): string = l & r\n\nfor n in 0..12:\n    for m in 1..12:\n       \
    \ for a in 0..12:\n            for b in 0..12:\n                var expected =\
    \ repeat(\"y\", b div m)\n                for i in 1..n:\n                   \
    \ expected.add(\"x\")\n                    expected.add(repeat(\"y\", (a * i +\
    \ b) div m - (a * (i - 1) + b) div m))\n                doAssert monoidFloorSum(n,\
    \ m, a, b, \"x\", \"y\", concat, \"\") == expected\n\ntype FloorSum = tuple[width,\
    \ height, sum: int]\n\nproc combine(l, r: FloorSum): FloorSum =\n    (l.width\
    \ + r.width, l.height + r.height, l.sum + r.sum + l.height * r.width)\n\nlet\n\
    \    x: FloorSum = (1, 0, 0)\n    y: FloorSum = (0, 1, 0)\n    e: FloorSum = (0,\
    \ 0, 0)\nvar rng = initRand(20260912)\nfor test in 0..<2000:\n    let\n      \
    \  n = rng.rand(100)\n        m = rng.rand(1..1000)\n        a = rng.rand(1000)\n\
    \        b = rng.rand(1000)\n    var expected = 0\n    for i in 0..<n:\n     \
    \   expected += (a * i + b) div m\n    let actual = monoidFloorSum(n, m, a, b,\
    \ x, y, combine, e)\n    doAssert actual == (n, (a * n + b) div m, expected)\n\
    \nlet large = 1_000_000_000\ndoAssert monoidFloorSum(large, 1, 1, 0, x, y, combine,\
    \ e) ==\n    (large, large, large * (large - 1) div 2)\ndoAssert monoidFloorSum(large,\
    \ large, large - 1, 0, x, y, combine, e) ==\n    (large, large - 1, (large - 1)\
    \ * (large - 2) div 2)\ndoAssert monoidFloorSum(0, 1, high(int), high(int), x,\
    \ y, combine, e) ==\n    (0, high(int), 0)\ndoAssert monoidFloorSum(1, high(int),\
    \ high(int), 0, x, y, combine, e) == (1, 1, 0)\ndoAssert monoidFloorSum(2, high(int)\
    \ - 1, high(int) div 2, 1, x, y, combine, e) == (2, 1, 0)\n\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/math/monoid_floor_sum.nim
  - cplib/math/monoid_floor_sum.nim
  isVerificationFile: true
  path: verify/math/monoid_floor_sum_test.nim
  requiredBy: []
  timestamp: '2026-09-12 15:14:35+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/math/monoid_floor_sum_test.nim
layout: document
redirect_from:
- /verify/verify/math/monoid_floor_sum_test.nim
- /verify/verify/math/monoid_floor_sum_test.nim.html
title: verify/math/monoid_floor_sum_test.nim
---
