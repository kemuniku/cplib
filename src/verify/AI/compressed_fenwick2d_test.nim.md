---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_fenwick2d.nim
    title: cplib/collections/compressed_fenwick2d.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_fenwick2d.nim
    title: cplib/collections/compressed_fenwick2d.nim
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
    import cplib/collections/compressed_fenwick2d\nimport random, algorithm\n\nblock:\n\
    \    let fw = initCompressedFenwick2D(@[(1'i64, 2'i64), (3'i64, 4'i64)])\n   \
    \ static: doAssert typeof(fw) is CompressedFenwick2D[int64, int]\n    fw.add(1'i64,\
    \ 2'i64, 10)\n    fw[3'i64, 4'i64] = 20\n    doAssert fw.get(0'i64, 4'i64, 0'i64,\
    \ 5'i64) == 30\n    let empty = initCompressedFenwick2D(newSeq[(int, int)]())\n\
    \    static: doAssert typeof(empty) is CompressedFenwick2D[int, int]\n    doAssert\
    \ empty.get_all() == 0\n    let fromArray = initCompressedFenwick2D([(1, 2), (3,\
    \ 4)])\n    static: doAssert typeof(fromArray) is CompressedFenwick2D[int, int]\n\
    \    fromArray.add(1, 2, 7)\n    doAssert fromArray.get_all() == 7\n    let wide\
    \ = initCompressedFenwick2D[int, int64]([(1, 2)])\n    static: doAssert typeof(wide)\
    \ is CompressedFenwick2D[int, int64]\n    wide.add(1, 2, 1'i64 shl 40)\n    doAssert\
    \ wide.get_all() == 1'i64 shl 40\n\nblock:\n    let fw = initCompressedFenwick2D[int,\
    \ int64](newSeq[(int, int)]())\n    doAssert fw.len == 0 and fw.get_all() == 0\n\
    \    doAssert fw.prefix(0, 0) == 0 and fw.getLess(-1, 1, 0) == 0\n    doAssert\
    \ fw.get(-10, 10, -10, 10) == 0 and fw[0, 0] == 0\n    var rejected = false\n\
    \    try: fw.add(0, 0, 1)\n    except AssertionDefect: rejected = true\n    doAssert\
    \ rejected\n\nblock:\n    let points = @[(0, 0), (1, 1), (2, 0), (2, 0), (3, 2)]\n\
    \    let original = points\n    let fw = initCompressedFenwick2D[int, int64](points)\n\
    \    doAssert points == original and fw.len == 4\n    fw.add(0, 0, 5)\n    fw.add(1,\
    \ 1, 7)\n    fw.add(2, 0, -3)\n    fw[3, 2] = 11\n    doAssert fw.get_all() ==\
    \ 20\n    for p in [(1, 0), (3, 0), (3, 1), (0, 1), (4, 2), (-1, 0)]:\n      \
    \  doAssert fw[p[0], p[1]] == 0\n        var rejected = false\n        try: fw.add(p[0],\
    \ p[1], 100)\n        except AssertionDefect: rejected = true\n        doAssert\
    \ rejected and fw.get_all() == 20\n        rejected = false\n        try: fw[p[0],\
    \ p[1]] = 100\n        except AssertionDefect: rejected = true\n        doAssert\
    \ rejected and fw.get_all() == 20\n    doAssert fw[0, 0] == 5 and fw[1, 1] ==\
    \ 7 and fw[2, 0] == -3 and fw[3, 2] == 11\n    for axis in 0..1:\n        var\
    \ rejected = false\n        try:\n            if axis == 0: discard fw.get(1,\
    \ 0, 0, 1)\n            else: discard fw.get(0, 1, 1, 0)\n        except AssertionDefect:\
    \ rejected = true\n        doAssert rejected\n\nblock:\n    var rng = initRand(20260918)\n\
    \    for shape in 0..3:\n        for n in 0..65:\n            var points: seq[(int,\
    \ int)]\n            for i in 0..<n:\n                case shape\n           \
    \     of 0: points.add((rng.rand(-10..10) * 3, rng.rand(-10..10) * 5))\n     \
    \           of 1: points.add((0, i - 30))\n                of 2: points.add((i\
    \ - 30, 0))\n                else: points.add((i - 30, (i * 17 mod 67) - 30))\n\
    \            let original = points\n            let fw = initCompressedFenwick2D[int,\
    \ int64](points)\n            doAssert points == original\n            points.sort()\n\
    \            var unique: seq[(int, int)]\n            for p in points:\n     \
    \           if unique.len == 0 or unique[^1] != p: unique.add(p)\n           \
    \ var values = newSeq[int64](unique.len)\n            doAssert fw.len == unique.len\n\
    \            for step in 0..<200:\n                if unique.len > 0:\n      \
    \              let i = rng.rand(unique.len - 1)\n                    let delta\
    \ = int64(rng.rand(-1000..1000))\n                    if step mod 4 == 0:\n  \
    \                      fw[unique[i][0], unique[i][1]] = delta\n              \
    \          values[i] = delta\n                    else:\n                    \
    \    fw.add(unique[i][0], unique[i][1], delta)\n                        values[i]\
    \ += delta\n                    doAssert fw[unique[i][0], unique[i][1]] == values[i]\n\
    \                var xl = rng.rand(-40..40)\n                var xr = rng.rand(-40..40)\n\
    \                var yl = rng.rand(-55..55)\n                var yr = rng.rand(-55..55)\n\
    \                if xr < xl: swap(xl, xr)\n                if yr < yl: swap(yl,\
    \ yr)\n                var expected, total, prefix, less, point: int64\n     \
    \           for i, p in unique:\n                    total += values[i]\n    \
    \                if p[0] < xr and p[1] < yr: prefix += values[i]\n           \
    \         if xl <= p[0] and p[0] < xr and p[1] < yr: less += values[i]\n     \
    \               if xl <= p[0] and p[0] < xr and yl <= p[1] and p[1] < yr:\n  \
    \                      expected += values[i]\n                    if p == (xl,\
    \ yl): point = values[i]\n                doAssert fw.get(xl, xr, yl, yr) == expected\n\
    \                doAssert fw.prefix(xr, yr) == prefix\n                doAssert\
    \ fw.getLess(xl, xr, yr) == less\n                doAssert fw.get_all() == total\n\
    \                doAssert fw[xl, yl] == point\n                doAssert fw.get(xl,\
    \ xl, yl, yr) == 0\n                doAssert fw.get(xl, xr, yl, yl) == 0\n\nblock:\n\
    \    let fw = initCompressedFenwick2D[int64, int64](@[\n        (low(int64), high(int64)),\
    \ (high(int64), low(int64)), (0'i64, 0'i64)])\n    fw[low(int64), high(int64)]\
    \ = 3\n    fw[high(int64), low(int64)] = 5\n    fw[0'i64, 0'i64] = 7\n    doAssert\
    \ fw.get_all() == 15\n    doAssert fw.get(low(int64), high(int64), low(int64),\
    \ high(int64)) == 7\n    doAssert fw[low(int64), high(int64)] == 3\n    doAssert\
    \ fw[high(int64), low(int64)] == 5\n    doAssert fw.prefix(high(int64), high(int64))\
    \ == 7\n    let unsigned = initCompressedFenwick2D[uint64, int](@[(0'u64, high(uint64)),\
    \ (high(uint64), 0'u64)])\n    unsigned[high(uint64), 0'u64] = 9\n    doAssert\
    \ unsigned[high(uint64), 0'u64] == 9\n    doAssert unsigned.get_all() == 9\n \
    \   let generic = initCompressedFenwick2D[string, int](@[(\"a\", \"b\"), (\"c\"\
    , \"b\")])\n    generic.add(\"a\", \"b\", 7)\n    generic.add(\"c\", \"b\", 11)\n\
    \    doAssert generic.get(\"a\", \"c\", \"a\", \"z\") == 7\n    doAssert generic[\"\
    c\", \"b\"] == 11\n\ntype Pair = object\n    a, b: int\nproc `+=`(x: var Pair,\
    \ y: Pair) =\n    x.a += y.a\n    x.b += y.b\nproc `-`(x, y: Pair): Pair = Pair(a:\
    \ x.a - y.a, b: x.b - y.b)\nblock:\n    let fw = initCompressedFenwick2D[int,\
    \ Pair](@[(0, 0), (1, 0)])\n    fw.add(0, 0, Pair(a: 1, b: 10))\n    fw.add(1,\
    \ 0, Pair(a: 2, b: 20))\n    doAssert fw.get(0, 2, 0, 1) == Pair(a: 3, b: 30)\n\
    \    fw[1, 0] = Pair(a: 4, b: 5)\n    doAssert fw.get_all() == Pair(a: 5, b: 15)\n\
    \nblock:\n    let points = @[(3, 4, 10), (1, 2, 7), (3, 4, -3), (1, 4, 5), (9,\
    \ 9, 0), (8, 8, 3), (8, 8, -3)]\n    let original = points\n    let fw = initCompressedFenwick2D(points)\n\
    \    static: doAssert typeof(fw) is CompressedFenwick2D[int, int]\n    doAssert\
    \ points == original and fw.len == 5\n    doAssert fw[3, 4] == 7 and fw[1, 2]\
    \ == 7 and fw[1, 4] == 5\n    doAssert fw.get(0, 4, 0, 5) == 19 and fw.get_all()\
    \ == 19\n    fw.add(9, 9, 6)\n    fw.add(8, 8, 2)\n    fw[3, 4] = 20\n    doAssert\
    \ fw.get_all() == 40\n    let fromArray = initCompressedFenwick2D([(1'i64, 2'i64,\
    \ 1'i64 shl 40), (1'i64, 2'i64, 3'i64)])\n    static: doAssert typeof(fromArray)\
    \ is CompressedFenwick2D[int64, int64]\n    doAssert fromArray[1'i64, 2'i64] ==\
    \ (1'i64 shl 40) + 3\n    let explicit = initCompressedFenwick2D[int, int64](@[(1,\
    \ 2, 7'i64), (1, 2, 9'i64)])\n    static: doAssert typeof(explicit) is CompressedFenwick2D[int,\
    \ int64]\n    doAssert explicit.get_all() == 16\n    let empty = initCompressedFenwick2D(newSeq[(int,\
    \ int, int64)]())\n    doAssert empty.len == 0 and empty.get_all() == 0\n    doAssert\
    \ empty.get(-1, 1, -1, 1) == 0\n    let custom = initCompressedFenwick2D([(\"\
    x\", \"y\", Pair(a: 2, b: 3)), (\"x\", \"y\", Pair(a: 5, b: -3))])\n    doAssert\
    \ custom.len == 1 and custom[\"x\", \"y\"] == Pair(a: 7, b: 0)\n\nblock:\n   \
    \ var rng = initRand(20260919)\n    for n in 0..80:\n        var points: seq[(int,\
    \ int, int64)]\n        var coords: seq[(int, int)]\n        for i in 0..<n:\n\
    \            let x = rng.rand(-8..8)\n            let y = rng.rand(-8..8)\n  \
    \          points.add((x, y, int64(rng.rand(-100..100))))\n            coords.add((x,\
    \ y))\n        let fw = initCompressedFenwick2D(points)\n        let incremental\
    \ = initCompressedFenwick2D[int, int64](coords)\n        for p in points: incremental.add(p[0],\
    \ p[1], p[2])\n        doAssert fw.len == incremental.len and fw.get_all() ==\
    \ incremental.get_all()\n        for p in points: doAssert fw[p[0], p[1]] == incremental[p[0],\
    \ p[1]]\n        for step in 0..<200:\n            if n > 0:\n               \
    \ let p = points[rng.rand(n - 1)]\n                let value = int64(rng.rand(-100..100))\n\
    \                if step mod 2 == 0:\n                    fw.add(p[0], p[1], value)\n\
    \                    incremental.add(p[0], p[1], value)\n                else:\n\
    \                    fw[p[0], p[1]] = value\n                    incremental[p[0],\
    \ p[1]] = value\n                doAssert fw[p[0], p[1]] == incremental[p[0],\
    \ p[1]]\n            var xl = rng.rand(-10..10)\n            var xr = rng.rand(-10..10)\n\
    \            var yl = rng.rand(-10..10)\n            var yr = rng.rand(-10..10)\n\
    \            if xr < xl: swap(xl, xr)\n            if yr < yl: swap(yl, yr)\n\
    \            doAssert fw.get(xl, xr, yl, yr) == incremental.get(xl, xr, yl, yr)\n\
    \            doAssert fw.prefix(xr, yr) == incremental.prefix(xr, yr)\n      \
    \      doAssert fw.getLess(xl, xr, yr) == incremental.getLess(xl, xr, yr)\n  \
    \          doAssert fw.get_all() == incremental.get_all()\n\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/collections/compressed_fenwick2d.nim
  - cplib/collections/compressed_fenwick2d.nim
  isVerificationFile: true
  path: verify/AI/compressed_fenwick2d_test.nim
  requiredBy: []
  timestamp: '2026-09-18 00:52:17+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/compressed_fenwick2d_test.nim
layout: document
redirect_from:
- /verify/verify/AI/compressed_fenwick2d_test.nim
- /verify/verify/AI/compressed_fenwick2d_test.nim.html
title: verify/AI/compressed_fenwick2d_test.nim
---
