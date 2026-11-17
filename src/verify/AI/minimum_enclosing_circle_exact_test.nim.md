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
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/minimum_enclosing_circle.nim
    title: cplib/geometry/minimum_enclosing_circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/minimum_enclosing_circle.nim
    title: cplib/geometry/minimum_enclosing_circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import options, random, algorithm, strutils\nimport cplib/geometry/base\nimport\
    \ cplib/geometry/circle\nimport cplib/geometry/minimum_enclosing_circle\nimport\
    \ cplib/math/bigint\nimport cplib/math/int128\nimport cplib/math/fractions\n\n\
    proc bi(x: int): BigInt = initBigInt(x)\nproc rat(n, d: int): Fraction[BigInt]\
    \ = initFraction(bi(n), bi(d))\nproc check[T](input: seq[Point[T]], expected:\
    \ string) =\n    var original: seq[Point[T]]\n    for p in input: original.add(p)\n\
    \    var reversed = input\n    reversed.reverse()\n    var first = none(Circle[T])\n\
    \    for seed in [0'i64, 1, -1, 63355030]:\n        for points in [input, reversed]:\n\
    \            let circle = minimum_enclosing_circle(points, seed)\n           \
    \ doAssert $circle.radius_squared_exact == expected\n            static: doAssert\
    \ typeof(circle) is Circle[T]\n            for p in circle.points_exact: doAssert\
    \ circle.on_circle(p)\n            for p in input: doAssert circle.contains(p)\n\
    \            if first.isSome: doAssert first.get == circle\n            else:\
    \ first = some(circle)\n    for i, p in input: doAssert p == original[i]\n   \
    \ doAssert minimum_enclosing_circle(input, 42).points == minimum_enclosing_circle(input,\
    \ 42).points\n\nproc checkType[T](zero, one, two, four: T) =\n    var rejected\
    \ = false\n    try: discard minimum_enclosing_circle(newSeq[Point[T]]())\n   \
    \ except ValueError: rejected = true\n    doAssert rejected\n    check(@[initPoint(zero,\
    \ zero)], \"0/1\")\n    check(@[initPoint(zero, zero), initPoint(one, zero)],\
    \ \"1/4\")\n    check(@[initPoint(zero, zero), initPoint(four, zero), initPoint(one,\
    \ zero), initPoint(two, zero)], \"4/1\")\n    check(@[initPoint(zero, zero), initPoint(two,\
    \ zero), initPoint(zero, two)], \"2/1\")\n    check(@[initPoint(zero, zero), initPoint(four,\
    \ zero), initPoint(two, four)], \"25/4\")\n    check(@[initPoint(zero, zero),\
    \ initPoint(four, zero), initPoint(one, one)], \"4/1\")\n    var duplicates: seq[Point[T]]\n\
    \    for _ in 0..<100: duplicates.add(initPoint(one, one))\n    check(duplicates,\
    \ \"0/1\")\n\ncheckType(0, 1, 2, 4)\ncheckType(bi(0), bi(1), bi(2), bi(4))\ncheckType(parseInt128(\"\
    0\"), parseInt128(\"1\"), parseInt128(\"2\"), parseInt128(\"4\"))\ncheckType(initFraction(0),\
    \ initFraction(1), initFraction(2), initFraction(4))\ncheckType(initFraction(parseInt128(\"\
    0\")), initFraction(parseInt128(\"1\")), initFraction(parseInt128(\"2\")), initFraction(parseInt128(\"\
    4\")))\ncheckType(rat(0, 1), rat(1, 1), rat(2, 1), rat(4, 1))\n\nlet half = minimum_enclosing_circle(@[initPoint(0,\
    \ 0), initPoint(1, 0)])\nstatic:\n    doAssert typeof(half) is Circle[int]\n \
    \   doAssert typeof(half.center_exact) is Point[Fraction[int]]\n    doAssert typeof(half.radius_squared_exact)\
    \ is Fraction[int]\ndoAssert half.center_exact == initPoint(initFraction(1, 2),\
    \ initFraction(0))\ndoAssert half.point_scale == 2\nfor p in half.points_exact:\
    \ doAssert half.on_circle(p)\ncheck(@[initPoint(1000000, 1000000), initPoint(1000001,\
    \ 1000000)], \"1/4\")\nlet wide = parseInt128(\"1000000000000000000000000000000\"\
    )\ncheck(@[initPoint(wide, wide), initPoint(wide + parseInt128(\"1\"), wide)],\
    \ \"1/4\")\nlet giant = parseBigInt(\"1\" & repeat('0', 1000))\ncheck(@[initPoint(giant,\
    \ giant), initPoint(giant + bi(1), giant)], \"1/4\")\nlet tiny = initFraction(bi(1),\
    \ giant)\ncheck(@[initPoint(rat(0, 1), rat(0, 1)), initPoint(tiny, rat(0, 1))],\
    \ $(tiny * tiny / bi(4)))\nlet zero128 = initFraction(parseInt128(\"0\"))\nlet\
    \ tiny128 = initFraction(parseInt128(\"1\"), parseInt128(\"1000000\"))\ncheck(@[initPoint(zero128,\
    \ zero128), initPoint(tiny128, zero128)], \"1/4000000000000\")\nlet raw = Fraction[int](num:\
    \ -6, den: -6)\ncheck(@[initPoint(raw, raw), initPoint(initFraction(2), raw)],\
    \ \"1/4\")\nvar rejected = false\ntry: discard minimum_enclosing_circle(@[initPoint(Fraction[int](num:\
    \ 1, den: 0), initFraction(0))])\nexcept ValueError: rejected = true\ndoAssert\
    \ rejected\nrandomize(422)\nlet before = rand(high(int))\ndiscard minimum_enclosing_circle(@[initPoint(0,\
    \ 0), initPoint(1, 0)], 7)\nlet after = rand(high(int))\nrandomize(422)\ndoAssert\
    \ before == rand(high(int)) and after == rand(high(int))\nvar large: seq[Point[int]]\n\
    for i in 0..<10000: large.add(initPoint(i mod 3, (i * 17) mod 3))\nlet enclosing\
    \ = minimum_enclosing_circle(large)\nfor p in large: doAssert enclosing.contains(p)\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/math/inv_gcd.nim
  - cplib/math/isqrt.nim
  - cplib/geometry/base.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/int128.nim
  - cplib/math/isprime.nim
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/circle.nim
  - cplib/math/bigint.nim
  - cplib/math/bigint.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/barrett_impl.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/geometry/circle.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isprime.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/fractions.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/int128.nim
  isVerificationFile: true
  path: verify/AI/minimum_enclosing_circle_exact_test.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/minimum_enclosing_circle_exact_test.nim
layout: document
redirect_from:
- /verify/verify/AI/minimum_enclosing_circle_exact_test.nim
- /verify/verify/AI/minimum_enclosing_circle_exact_test.nim.html
title: verify/AI/minimum_enclosing_circle_exact_test.nim
---
