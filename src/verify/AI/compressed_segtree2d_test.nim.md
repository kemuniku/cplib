---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_segtree2d.nim
    title: cplib/collections/compressed_segtree2d.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_segtree2d.nim
    title: cplib/collections/compressed_segtree2d.nim
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
    import cplib/collections/compressed_segtree2d\nimport random, algorithm\n\nproc\
    \ sum(a, b: int64): int64 = a + b\n\nblock:\n    let empty = newCompressedSeg2DWith(newSeq[(int,\
    \ int)](), l + r, 0)\n    doAssert empty.len == 0 and empty.get_all() == 0\n \
    \   doAssert empty.get(-10, 10, -10, 10) == 0\n    doAssert empty[0, 0] == 0\n\
    \    var rejected = false\n    try: empty[0, 0] = 1\n    except AssertionDefect:\
    \ rejected = true\n    doAssert rejected\n\nblock:\n    let points = @[(0, 0),\
    \ (0, 2), (2, 0), (2, 3), (4, 0), (4, 2), (4, 5), (0, 0)]\n    let original =\
    \ points\n    let st = newCompressedSeg2DWith(points, min(l, r), high(int))\n\
    \    doAssert points == original and st.len == 7\n    doAssert st.get_all() ==\
    \ high(int)\n    st[0, 0] = -10\n    st[2, 0] = -20\n    st[4, 0] = -30\n    doAssert\
    \ st.get(-1, 5, 0, 1) == -30\n    st[4, 0] = 100\n    doAssert st.get(-1, 5, 0,\
    \ 1) == -20\n    st[2, 0] = 200\n    doAssert st.get_all() == -10\n    doAssert\
    \ st[2, 2] == high(int)\n    for point in [(2, 2), (1, 0), (4, 3)]:\n        var\
    \ rejected = false\n        try: st[point[0], point[1]] = -100\n        except\
    \ AssertionDefect: rejected = true\n        doAssert rejected and st.get_all()\
    \ == -10\n    var rejected = false\n    try: discard st.get(2, 1, 0, 1)\n    except\
    \ AssertionDefect: rejected = true\n    doAssert rejected\n\nblock:\n    var rng\
    \ = initRand(20260917)\n    for n in 0..65:\n        var points: seq[(int, int)]\n\
    \        for i in 0..<n: points.add((rng.rand(-8..8) * 3, rng.rand(-8..8) * 5))\n\
    \        let original = points\n        let ordinary = initCompressedSegmentTree2D(points,\
    \ sum, 0'i64)\n        let direct: CompressedSegmentTree2D[int, int64] = newCompressedSeg2DWith(points,\
    \ l + r, 0'i64)\n        doAssert points == original\n        points.sort()\n\
    \        var unique: seq[(int, int)]\n        for p in points:\n            if\
    \ unique.len == 0 or unique[^1] != p: unique.add(p)\n        for st in [ordinary,\
    \ direct]:\n            var values = newSeq[int64](unique.len)\n            doAssert\
    \ st.len == unique.len\n            for step in 0..<400:\n                if unique.len\
    \ > 0 and rng.rand(2) != 0:\n                    let i = rng.rand(unique.len -\
    \ 1)\n                    values[i] = int64(rng.rand(-1000..1000))\n         \
    \           st[unique[i][0], unique[i][1]] = values[i]\n                    doAssert\
    \ st[unique[i][0], unique[i][1]] == values[i]\n                var xl = rng.rand(-30..30)\n\
    \                var xr = rng.rand(-30..30)\n                var yl = rng.rand(-45..45)\n\
    \                var yr = rng.rand(-45..45)\n                if xr < xl: swap(xl,\
    \ xr)\n                if yr < yl: swap(yl, yr)\n                var expected,\
    \ total: int64\n                for i, p in unique:\n                    total\
    \ += values[i]\n                    if xl <= p[0] and p[0] < xr and yl <= p[1]\
    \ and p[1] < yr:\n                        expected += values[i]\n            \
    \    doAssert st.get(xl, xr, yl, yr) == expected\n                doAssert st.get_all()\
    \ == total\n                doAssert st.get(xl, xl, yl, yr) == 0\n           \
    \     doAssert st.get(xl, xr, yl, yl) == 0\n\nblock:\n    let st = newCompressedSeg2DWith(@[(low(int64),\
    \ high(int64)), (high(int64), low(int64))], l + r, 0)\n    st[low(int64), high(int64)]\
    \ = 3\n    st[high(int64), low(int64)] = 5\n    doAssert st.get_all() == 8\n \
    \   doAssert st.get(low(int64), high(int64), low(int64), high(int64)) == 0\n \
    \   doAssert st[low(int64), high(int64)] == 3\n    let generic = newCompressedSeg2DWith(@[(\"\
    a\", \"b\"), (\"c\", \"b\")], l + r, 0)\n    generic[\"a\", \"b\"] = 7\n    doAssert\
    \ generic.get(\"a\", \"c\", \"a\", \"z\") == 7\n\nblock:\n    proc make(modulus:\
    \ int): CompressedSegmentTree2D[int, int] =\n        newCompressedSeg2DWith(@[(0,\
    \ 0), (1, 0), (1, 1)], (l + r) mod modulus, 0)\n    let a = make(7)\n    let b\
    \ = make(11)\n    for st in [a, b]:\n        st[0, 0] = 5\n        st[1, 0] =\
    \ 6\n        st[1, 1] = 4\n    doAssert a.get_all() == 1 and b.get_all() == 4\n\
    \    doAssert a.get(0, 2, 0, 1) == 4 and b.get(0, 2, 0, 1) == 0\n\nblock:\n  \
    \  let points = @[(3, 4, 10), (1, 2, 7), (3, 4, -3), (1, 4, 5), (9, 9, 0)]\n \
    \   let original = points\n    let st = newCompressedSeg2DWith(points, l + r,\
    \ 0)\n    doAssert points == original and st.len == 4\n    doAssert st[3, 4] ==\
    \ 7 and st.get_all() == 19\n    st[9, 9] = 6\n    st[3, 4] = 20\n    doAssert\
    \ st.get_all() == 38\n    let empty = newCompressedSeg2DWith(newSeq[(int, int,\
    \ int)](), l + r, 0)\n    doAssert empty.len == 0 and empty.get_all() == 0\n \
    \   let minimum = newCompressedSeg2DWith(@[(0, 0, 3), (0, 0, 5), (1, 0, -2)],\
    \ min(l, r), high(int))\n    doAssert minimum[0, 0] == 3 and minimum.get_all()\
    \ == -2\n    minimum[1, 0] = 9\n    doAssert minimum.get_all() == 3\n    let generic\
    \ = newCompressedSeg2DWith(@[(\"a\", \"b\", 4), (\"c\", \"b\", 7)], l + r, 0)\n\
    \    doAssert generic.get(\"a\", \"c\", \"a\", \"z\") == 4\n\nblock:\n    var\
    \ rng = initRand(20260920)\n    for n in 0..80:\n        var points: seq[(int,\
    \ int, int64)]\n        var coords: seq[(int, int)]\n        for i in 0..<n:\n\
    \            let x = rng.rand(-8..8)\n            let y = rng.rand(-8..8)\n  \
    \          points.add((x, y, int64(rng.rand(-100..100))))\n            coords.add((x,\
    \ y))\n        let bulk = newCompressedSeg2DWith(points, l + r, 0'i64)\n     \
    \   let ordinary = initCompressedSegmentTree2D(points, sum, 0'i64)\n        let\
    \ incremental = newCompressedSeg2DWith(coords, l + r, 0'i64)\n        for p in\
    \ points: incremental[p[0], p[1]] = incremental[p[0], p[1]] + p[2]\n        for\
    \ st in [bulk, ordinary]:\n            doAssert st.len == incremental.len and\
    \ st.get_all() == incremental.get_all()\n            for p in points: doAssert\
    \ st[p[0], p[1]] == incremental[p[0], p[1]]\n        for step in 0..<200:\n  \
    \          if n > 0:\n                let p = points[rng.rand(n - 1)]\n      \
    \          let value = int64(rng.rand(-100..100))\n                for st in [bulk,\
    \ ordinary, incremental]: st[p[0], p[1]] = value\n            var xl = rng.rand(-10..10)\n\
    \            var xr = rng.rand(-10..10)\n            var yl = rng.rand(-10..10)\n\
    \            var yr = rng.rand(-10..10)\n            if xr < xl: swap(xl, xr)\n\
    \            if yr < yl: swap(yl, yr)\n            for st in [bulk, ordinary]:\n\
    \                doAssert st.get(xl, xr, yl, yr) == incremental.get(xl, xr, yl,\
    \ yr)\n                doAssert st.get_all() == incremental.get_all()\n\necho\
    \ \"Hello World\"\n"
  dependsOn:
  - cplib/collections/compressed_segtree2d.nim
  - cplib/collections/compressed_segtree2d.nim
  isVerificationFile: true
  path: verify/AI/compressed_segtree2d_test.nim
  requiredBy: []
  timestamp: '2026-09-18 00:52:17+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/compressed_segtree2d_test.nim
layout: document
redirect_from:
- /verify/verify/AI/compressed_segtree2d_test.nim
- /verify/verify/AI/compressed_segtree2d_test.nim.html
title: verify/AI/compressed_segtree2d_test.nim
---
