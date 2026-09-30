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
    path: cplib/utils/static_rectangle_add_rectangle_sum.nim
    title: cplib/utils/static_rectangle_add_rectangle_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/static_rectangle_add_rectangle_sum.nim
    title: cplib/utils/static_rectangle_add_rectangle_sum.nim
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
    import cplib/utils/static_rectangle_add_rectangle_sum\nimport cplib/modint/modint\n\
    import random\n\nblock:\n    let rectangles = [(0, 0, 2, 4, 1), (1, 1, 3, 5, 2)]\n\
    \    let queries = [(0, 0, 1, 1), (1, 1, 2, 2), (2, 2, 3, 3), (0, 0, 3, 5),\n\
    \        (0, 0, 3, 2), (0, 1, 3, 3), (3, 0, 4, 4)]\n    let answers = static_rectangle_add_rectangle_sum(rectangles,\
    \ queries)\n    static: doAssert typeof(answers) is seq[int]\n    doAssert answers\
    \ == @[1, 3, 2, 24, 8, 12, 0]\n\nblock:\n    let emptyRectangles: seq[(int, int,\
    \ int, int, int64)] = @[]\n    let emptyQueries: seq[(int, int, int, int)] = @[]\n\
    \    doAssert static_rectangle_add_rectangle_sum(emptyRectangles, [(0, 0, 1, 1)])\
    \ == @[0'i64]\n    doAssert static_rectangle_add_rectangle_sum([(0, 0, 1, 1, 5'i64)],\
    \ emptyQueries).len == 0\n    doAssert static_rectangle_add_rectangle_sum(emptyRectangles,\
    \ emptyQueries).len == 0\n    doAssert static_rectangle_add_rectangle_sum([(2,\
    \ -1, 2, 5, 9), (-4, 3, 8, 3, 7)],\n        [(-10, -10, 10, 10)]) == @[0]\n  \
    \  doAssert static_rectangle_add_rectangle_sum([(-3, -2, 4, 5, 7)],\n        [(-1,\
    \ -8, -1, 9), (-8, 3, 9, 3)]) == @[0, 0]\n\nblock:\n    let rectangles = @[(-5,\
    \ -3, 2, 4, 6'i64), (-5, -3, 2, 4, -6'i64),\n        (-2, -1, 3, 5, -4'i64), (3,\
    \ -1, 7, 5, 8'i64)]\n    let queries = @[(-20, -20, 20, 20), (-2, -1, 3, 5), (3,\
    \ -1, 7, 5),\n        (2, 0, 4, 2), (-20, -20, -5, -3), (7, -1, 10, 5)]\n    let\
    \ originalRectangles = rectangles\n    let originalQueries = queries\n    doAssert\
    \ static_rectangle_add_rectangle_sum(rectangles, queries) == @[72'i64, -120, 192,\
    \ 8, 0, 0]\n    doAssert rectangles == originalRectangles and queries == originalQueries\n\
    \nblock:\n    let x = 1_000_000_000_000'i64\n    let rectangles = [(x, -3'i64,\
    \ x + 7, 5'i64, 9'i64)]\n    doAssert static_rectangle_add_rectangle_sum(rectangles,\n\
    \        [(x - 1, -9'i64, x + 20, 8'i64), (x + 2, -1'i64, x + 4, 2'i64)]) == @[504'i64,\
    \ 54]\n    let wide = static_rectangle_add_rectangle_sum(\n        [(0'i32, 0'i32,\
    \ 100_000'i32, 100_000'i32, 7'i64)],\n        [(1'i32, 2'i32, 100_001'i32, 100_002'i32)])\n\
    \    static: doAssert typeof(wide) is seq[int64]\n    doAssert wide == @[7'i64\
    \ * 99_999 * 99_998]\n\nblock:\n    let answers = static_rectangle_add_rectangle_sum(\n\
    \        [(-1.5, 0.25, 2.5, 1.75, 2.0), (0.5, -0.5, 3.0, 0.5, -3.0)],\n      \
    \  [(-2.0, -2.0, 4.0, 3.0), (0.0, 0.0, 1.0, 1.0), (2.5, 0.5, 3.0, 2.0)])\n   \
    \ for i, expected in [4.5, 0.75, 0.0]:\n        doAssert abs(answers[i] - expected)\
    \ < 1e-9\n\ntype\n    Coordinate = distinct int64\n    Pair = object\n       \
    \ a, b: int64\nproc `<`(a, b: Coordinate): bool = int64(a) < int64(b)\nproc `+=`(a:\
    \ var Pair, b: Pair) =\n    a.a += b.a\n    a.b += b.b\nproc `-`(a, b: Pair):\
    \ Pair = Pair(a: a.a - b.a, b: a.b - b.b)\nproc `*`(a: Pair, b: Coordinate): Pair\
    \ = Pair(a: a.a * int64(b), b: a.b * int64(b))\n\nblock:\n    let answers = static_rectangle_add_rectangle_sum(\n\
    \        [(Coordinate(-2), Coordinate(1), Coordinate(3), Coordinate(4), Pair(a:\
    \ 2, b: -3))],\n        [(Coordinate(-1), Coordinate(2), Coordinate(5), Coordinate(5))])\n\
    \    doAssert answers == @[Pair(a: 16, b: -24)]\n\nproc checkModint[M](rectangles:\
    \ seq[(int, int, int, int, int64)],\n    queries: seq[(int, int, int, int)], expected:\
    \ seq[int64]) =\n    var modular = newSeq[(int, int, int, int, M)](rectangles.len)\n\
    \    for i, rectangle in rectangles:\n        modular[i] = (rectangle[0], rectangle[1],\
    \ rectangle[2], rectangle[3], M.init(rectangle[4]))\n    let answers = static_rectangle_add_rectangle_sum(modular,\
    \ queries)\n    for i, value in expected: doAssert answers[i] == M.init(value)\n\
    \nblock:\n    var rng = initRand(20260927)\n    modint_barrett.setMod(1_000_000_007)\n\
    \    modint_montgomery.setMod(998_244_353)\n    for trial in 0..<160:\n      \
    \  var rectangles: seq[(int, int, int, int, int64)]\n        var queries: seq[(int,\
    \ int, int, int)]\n        for i in 0..<rng.rand(0..40):\n            var l =\
    \ rng.rand(-15..15) * 7\n            var r = rng.rand(-15..15) * 7\n         \
    \   var d = rng.rand(-15..15) * 11\n            var u = rng.rand(-15..15) * 11\n\
    \            if r < l: swap(l, r)\n            if u < d: swap(d, u)\n        \
    \    rectangles.add((l, d, r, u, int64(rng.rand(-1_000_000..1_000_000))))\n  \
    \      for i in 0..<rng.rand(0..60):\n            var l = rng.rand(-120..120)\n\
    \            var r = rng.rand(-120..120)\n            var d = rng.rand(-180..180)\n\
    \            var u = rng.rand(-180..180)\n            if r < l: swap(l, r)\n \
    \           if u < d: swap(d, u)\n            queries.add((l, d, r, u))\n    \
    \    var expected = newSeq[int64](queries.len)\n        for i, q in queries:\n\
    \            for r in rectangles:\n                let width = max(0, min(q[2],\
    \ r[2]) - max(q[0], r[0]))\n                let height = max(0, min(q[3], r[3])\
    \ - max(q[1], r[1]))\n                expected[i] += r[4] * int64(width) * int64(height)\n\
    \        doAssert static_rectangle_add_rectangle_sum(rectangles, queries) == expected\n\
    \        checkModint[modint998244353_montgomery](rectangles, queries, expected)\n\
    \        checkModint[modint998244353_barrett](rectangles, queries, expected)\n\
    \        checkModint[modint_montgomery](rectangles, queries, expected)\n     \
    \   checkModint[modint_barrett](rectangles, queries, expected)\n\nblock:\n   \
    \ type mint = modint998244353_montgomery\n    let l = low(int64)\n    let r =\
    \ high(int64)\n    let weight = mint.init(17)\n    let answers = static_rectangle_add_rectangle_sum([(l,\
    \ l, r, r, weight)],\n        [(l, l, r, r), (-1'i64, -2'i64, 3'i64, 5'i64)])\n\
    \    let width = mint.init(r) - mint.init(l)\n    doAssert answers == @[weight\
    \ * width * width, weight * 28]\n    let unsigned = static_rectangle_add_rectangle_sum([(0'u64,\
    \ 0'u64, high(uint64), high(uint64), weight)],\n        [(0'u64, 0'u64, high(uint64),\
    \ high(uint64))])\n    let side = mint.init(high(uint64))\n    doAssert unsigned\
    \ == @[weight * side * side]\n\nblock:\n    for invalid in [(1, 0, 0, 1), (0,\
    \ 1, 1, 0)]:\n        var rejected = false\n        try:\n            discard\
    \ static_rectangle_add_rectangle_sum(\n                [(invalid[0], invalid[1],\
    \ invalid[2], invalid[3], 1)], newSeq[(int, int, int, int)]())\n        except\
    \ AssertionDefect: rejected = true\n        doAssert rejected\n        rejected\
    \ = false\n        try:\n            discard static_rectangle_add_rectangle_sum(newSeq[(int,\
    \ int, int, int, int)](), [invalid])\n        except AssertionDefect: rejected\
    \ = true\n        doAssert rejected\n\nproc checkCoordinateType[K](coordinates:\
    \ openArray[K]) =\n    type mint = modint998244353_montgomery\n    var rng = initRand(20260928)\n\
    \    var rectangles: seq[(K, K, K, K, mint)]\n    var queries: seq[(K, K, K, K)]\n\
    \    for i in 0..<100:\n        var l = coordinates[rng.rand(coordinates.high)]\n\
    \        var r = coordinates[rng.rand(coordinates.high)]\n        var d = coordinates[rng.rand(coordinates.high)]\n\
    \        var u = coordinates[rng.rand(coordinates.high)]\n        if r < l: swap(l,\
    \ r)\n        if u < d: swap(d, u)\n        rectangles.add((l, d, r, u, mint.init(rng.rand(-1000..1000))))\n\
    \    for i in 0..<120:\n        var l = coordinates[rng.rand(coordinates.high)]\n\
    \        var r = coordinates[rng.rand(coordinates.high)]\n        var d = coordinates[rng.rand(coordinates.high)]\n\
    \        var u = coordinates[rng.rand(coordinates.high)]\n        if r < l: swap(l,\
    \ r)\n        if u < d: swap(d, u)\n        queries.add((l, d, r, u))\n    let\
    \ answers = static_rectangle_add_rectangle_sum(rectangles, queries)\n    for i,\
    \ q in queries:\n        var expected: mint\n        for rectangle in rectangles:\n\
    \            let l = max(q[0], rectangle[0])\n            let r = min(q[2], rectangle[2])\n\
    \            let d = max(q[1], rectangle[1])\n            let u = min(q[3], rectangle[3])\n\
    \            if l < r and d < u:\n                expected += rectangle[4] * (mint.init(r)\
    \ - mint.init(l)) * (mint.init(u) - mint.init(d))\n        doAssert answers[i]\
    \ == expected\n\ncheckCoordinateType([low(int8), -1'i8, 0'i8, 1'i8, high(int8)])\n\
    checkCoordinateType([0'u8, 1'u8, 127'u8, 128'u8, high(uint8)])\ncheckCoordinateType([low(int16),\
    \ -256'i16, -1'i16, 0'i16, 256'i16, high(int16)])\ncheckCoordinateType([0'u16,\
    \ 1'u16, 255'u16, 256'u16, high(uint16)])\ncheckCoordinateType([low(int32), -2048'i32,\
    \ -1'i32, 0'i32, 2048'i32, high(int32)])\ncheckCoordinateType([0'u32, 1'u32, 2047'u32,\
    \ 2048'u32, high(uint32)])\ncheckCoordinateType([low(int64), low(int64) + 1, -1_000_000_000_000'i64,\
    \ -1'i64,\n    0'i64, 1'i64, 1_000_000_000_000'i64, high(int64) - 1, high(int64)])\n\
    checkCoordinateType([0'u64, 1'u64, 1'u64 shl 32, (1'u64 shl 63) - 1,\n    1'u64\
    \ shl 63, high(uint64) - 1, high(uint64)])\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/static_rectangle_add_rectangle_sum.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/utils/static_rectangle_add_rectangle_sum.nim
  isVerificationFile: true
  path: verify/AI/static_rectangle_add_rectangle_sum_test.nim
  requiredBy: []
  timestamp: '2026-09-30 20:31:36+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/static_rectangle_add_rectangle_sum_test.nim
layout: document
redirect_from:
- /verify/verify/AI/static_rectangle_add_rectangle_sum_test.nim
- /verify/verify/AI/static_rectangle_add_rectangle_sum_test.nim.html
title: verify/AI/static_rectangle_add_rectangle_sum_test.nim
---
