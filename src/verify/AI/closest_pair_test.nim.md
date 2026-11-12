---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/closest_pair.nim
    title: cplib/geometry/closest_pair.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/closest_pair.nim
    title: cplib/geometry/closest_pair.nim
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
    import math, options, random, sequtils\nimport cplib/geometry/base\nimport cplib/geometry/closest_pair\n\
    \nproc oracle[T](points: seq[Point[T]]): auto =\n    when T is SomeSignedInt:\n\
    \        type D = int64\n    else:\n        type D = float64\n    var best = none(D)\n\
    \    for i in 0..<points.len:\n        for j in i + 1..<points.len:\n        \
    \    let dx = D(points[i].x) - D(points[j].x)\n            let dy = D(points[i].y)\
    \ - D(points[j].y)\n            let d = dx * dx + dy * dy\n            if best.isNone\
    \ or d < best.get:\n                best = some(d)\n    best\n\nproc check[T](points:\
    \ seq[Point[T]]) =\n    var original = newSeq[Point[T]](points.len)\n    for i,\
    \ p in points:\n        original[i] = p\n    let answer = closest_pair(points)\n\
    \    for i, p in points:\n        doAssert p.x == original[i].x and p.y == original[i].y\n\
    \    let expected = oracle(points)\n    doAssert answer.isSome == expected.isSome\n\
    \    if answer.isSome:\n        let value = answer.get\n        let (i, j) = value.indices\n\
    \        doAssert 0 <= i and i < j and j < points.len\n        doAssert value.distanceSquared\
    \ == expected.get, $points\n        let pair = @[points[i], points[j]]\n     \
    \   doAssert oracle(pair).get == value.distanceSquared\n\nproc checkIntegers(points:\
    \ seq[(int64, int64)]) =\n    check(points.mapIt(initPoint(it)))\n\ncheckIntegers(@[])\n\
    checkIntegers(@[(17'i64, -11'i64)])\ncheckIntegers(@[(0'i64, 0'i64), (3'i64, 4'i64)])\n\
    checkIntegers(newSeqWith(100, (7'i64, -11'i64)))\ncheckIntegers(@[(5'i64, -8'i64),\
    \ (0'i64, 0'i64), (3'i64, 4'i64), (5'i64, -8'i64)])\nfor mask in 0..<512:\n  \
    \  var points: seq[(int64, int64)]\n    for i in 0..<9:\n        if (mask and\
    \ (1 shl i)) != 0:\n            points.add((int64(i div 3 - 1), int64(i mod 3\
    \ - 1)))\n    checkIntegers(points)\n\nfor n in 0..5:\n    for code in 0..<(1\
    \ shl (2 * n)):\n        var value = code\n        var points: seq[(int64, int64)]\n\
    \        for i in 0..<n:\n            points.add((int64((value and 3) div 2 -\
    \ 1), int64((value and 3) mod 2 - 1)))\n            value = value shr 2\n    \
    \    checkIntegers(points)\n\nvar rng = initRand(20261002)\nfor direction in [(0'i64,\
    \ 1'i64), (1'i64, 0'i64), (2'i64, 3'i64), (2'i64, -3'i64)]:\n    var points: seq[(int64,\
    \ int64)]\n    for i in -60..60:\n        points.add((direction[0] * int64(i)\
    \ + 17, direction[1] * int64(i) - 31))\n    for trial in 0..<5:\n        rng.shuffle(points)\n\
    \        checkIntegers(points)\n\nconst bound = 1_000_000_000'i64\ncheckIntegers(@[(-bound,\
    \ -bound), (bound, bound)])\ncheckIntegers(@[(-bound, -bound), (-bound, bound),\
    \ (bound, -bound), (bound, bound)])\ncheckIntegers(@[(low(int64), low(int64)),\
    \ (low(int64) + 2_000_000_000, low(int64) + 2_000_000_000)])\ncheckIntegers(@[(high(int64),\
    \ high(int64)), (high(int64) - 2_000_000_000, high(int64) - 2_000_000_000)])\n\
    for offset in [low(int64), -9_007_199_254_740_995'i64, 9_007_199_254_740_995'i64,\
    \ high(int64) - 100]:\n    checkIntegers(@[(offset, offset), (offset + 3, offset\
    \ + 4), (offset + 4, offset + 4)])\n\nfor trial in 0..<2000:\n    var points:\
    \ seq[(int64, int64)]\n    let n = rng.rand(0..70)\n    for i in 0..<n:\n    \
    \    case trial mod 5\n        of 0:\n            points.add((int64(rng.rand(-5..5)),\
    \ int64(rng.rand(-5..5))))\n        of 1:\n            points.add((int64(rng.rand(-1_000_000_000..1_000_000_000)),\n\
    \                int64(rng.rand(-1_000_000_000..1_000_000_000))))\n        of\
    \ 2:\n            points.add((9_007_199_254_740_992'i64 + int64(rng.rand(0..10000)),\n\
    \                -9_007_199_254_740_992'i64 + int64(rng.rand(0..10000))))\n  \
    \      of 3:\n            points.add((low(int64) + int64(rng.rand(0..10000)),\
    \ high(int64) - int64(rng.rand(0..10000))))\n        else:\n            let cluster\
    \ = int64(rng.rand(0..3)) * 10000\n            points.add((cluster + int64(rng.rand(-100..100)),\
    \ -cluster + int64(rng.rand(-100..100))))\n    rng.shuffle(points)\n    checkIntegers(points)\n\
    \ncheck(@[initPoint(-128'i8, -128'i8), initPoint(127'i8, 127'i8)])\ncheck(@[initPoint(-32768'i16,\
    \ -32768'i16), initPoint(32767'i16, 32767'i16)])\ncheck(@[initPoint(-1_000_000_000'i32,\
    \ -1_000_000_000'i32), initPoint(1_000_000_000'i32, 1_000_000_000'i32)])\ncheck(@[initPoint(0,\
    \ 0), initPoint(3, 4)])\nstatic:\n    doAssert not compiles(closest_pair([initPoint(0'u64,\
    \ 0'u64), initPoint(1'u64, 0'u64)]))\n\ncheck(newSeq[Point[float64]]())\ncheck(@[initPoint(1.0,\
    \ -2.0)])\ncheck(@[initPoint(0.0, 0.0), initPoint(3.0, 4.0)])\ncheck(@[initPoint(0.0,\
    \ -0.0), initPoint(-0.0, 0.0)])\ncheck(newSeqWith(100, initPoint(0.125, -0.25)))\n\
    check(@[initPoint(0.0, 0.0), initPoint(5e-12, 10.0), initPoint(1e-11, 0.0), initPoint(-5e-12,\
    \ 10.0)])\ncheck(@[initPoint(-1e150, -1e150), initPoint(1e150, 1e150)])\ncheck(@[initPoint(0.0,\
    \ 0.0), initPoint(2e-162, 0.0), initPoint(4e-162, 0.0), initPoint(0.0, 2e-162)])\n\
    check(@[initPoint(-1e30'f32, -1e30'f32), initPoint(1e30'f32, 1e30'f32)])\ncheck(@[initPoint(0'f32,\
    \ 0'f32), initPoint(1e-45'f32, 0'f32)])\ncheck(@[initPoint(1e-20'f32, -2e-20'f32),\
    \ initPoint(2e-20'f32, -2e-20'f32)])\ncheck(@[initPoint(9_007_199_254_740_992.0,\
    \ 0.0), initPoint(9_007_199_254_740_996.0, 0.0),\n    initPoint(9_007_199_254_740_998.0,\
    \ 0.0)])\nblock:\n    let originalEps = GEOMETRY_EPS\n    GEOMETRY_EPS = 1e20\n\
    \    check(@[initPoint(0.0, 0.0), initPoint(1e-12, 10.0), initPoint(2e-12, 0.0)])\n\
    \    GEOMETRY_EPS = originalEps\n\nfor trial in 0..<1500:\n    var points: seq[Point[float64]]\n\
    \    let n = rng.rand(0..70)\n    let scale = [1.0, 1e-12, 1e120, 1e-120, 2e-162][trial\
    \ mod 5]\n    for i in 0..<n:\n        points.add(initPoint(float64(rng.rand(-1000..1000))\
    \ * scale,\n            float64(rng.rand(-1000..1000)) * scale))\n    rng.shuffle(points)\n\
    \    check(points)\n    if trial mod 5 == 0:\n        check(points.mapIt(initPoint(float32(it.x),\
    \ float32(it.y))))\n\nfor trial in 0..<1000:\n    var points: seq[Point[float64]]\n\
    \    for i in 0..<rng.rand(0..70):\n        let x = float64(rng.rand(-1000..1000))\
    \ * pow(10.0, float64(rng.rand(-120..120)))\n        let y = float64(rng.rand(-1000..1000))\
    \ * pow(10.0, float64(rng.rand(-120..120)))\n        points.add(initPoint(x, y))\n\
    \    rng.shuffle(points)\n    check(points)\n\nproc rejects[T](points: seq[Point[T]])\
    \ =\n    var rejected = false\n    try:\n        discard closest_pair(points)\n\
    \    except ValueError:\n        rejected = true\n    doAssert rejected\n\nrejects(@[initPoint(low(int64),\
    \ 0'i64), initPoint(high(int64), 0'i64)])\nrejects(@[initPoint(0'i64, 0'i64),\
    \ initPoint(2_000_000_001'i64, 0'i64)])\nrejects(@[initPoint(0'i64, 0'i64), initPoint(0'i64,\
    \ 2_000_000_001'i64)])\nrejects(@[initPoint(0.0, 0.0), initPoint(system.Inf, 0.0)])\n\
    rejects(@[initPoint(0.0, NegInf)])\nrejects(@[initPoint(NaN, 0.0)])\nrejects(@[initPoint(-1e308,\
    \ 0.0), initPoint(1e308, 0.0)])\nrejects(@[initPoint(0.0, 0.0), initPoint(1e200,\
    \ 0.0)])\nrejects(@[initPoint(0.0, 0.0), initPoint(1e-200, 0.0)])\nrejects(@[initPoint(0.0,\
    \ 0.0), initPoint(0.0, 1e-200)])\n\nproc checkLarge[T](points: seq[Point[T]],\
    \ expected: auto) =\n    let answer = closest_pair(points).get\n    let (i, j)\
    \ = answer.indices\n    doAssert 0 <= i and i < j and j < points.len\n    doAssert\
    \ answer.distanceSquared == expected\n    doAssert oracle(@[points[i], points[j]]).get\
    \ == expected\n\nblock:\n    const n = 200000\n    checkLarge(newSeqWith(n, initPoint(7'i64,\
    \ -11'i64)), 0'i64)\n    checkLarge(newSeqWith(n, initPoint(0.125, -0.25)), 0.0)\n\
    \    var points = newSeq[Point[int64]](n)\n    for direction in [(0'i64, 1'i64),\
    \ (1'i64, 0'i64), (1'i64, -1'i64)]:\n        for i in 0..<n:\n            points[i]\
    \ = initPoint(direction[0] * int64(i), direction[1] * int64(i))\n        rng.shuffle(points)\n\
    \        checkLarge(points, direction[0] * direction[0] + direction[1] * direction[1])\n\
    \        checkLarge(points.mapIt(initPoint(float64(it.x), float64(it.y))),\n \
    \           float64(direction[0] * direction[0] + direction[1] * direction[1]))\n\
    \    for i in 0..<n:\n        points[i] = initPoint(int64(i div 500), int64(i\
    \ mod 500))\n    rng.shuffle(points)\n    checkLarge(points, 1'i64)\n    for i\
    \ in 0..<n:\n        points[i] = initPoint(10'i64 * int64(i), 10'i64 * int64(i\
    \ mod 101))\n    points[^1] = initPoint(1'i64, 0'i64)\n    rng.shuffle(points)\n\
    \    checkLarge(points, 1'i64)\n    checkLarge(points.mapIt(initPoint(float64(it.x),\
    \ float64(it.y))), 1.0)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/geometry/closest_pair.nim
  - cplib/geometry/closest_pair.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  isVerificationFile: true
  path: verify/AI/closest_pair_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:16:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/closest_pair_test.nim
layout: document
redirect_from:
- /verify/verify/AI/closest_pair_test.nim
- /verify/verify/AI/closest_pair_test.nim.html
title: verify/AI/closest_pair_test.nim
---
