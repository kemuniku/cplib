---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_lazysegtree.nim
    title: cplib/collections/compressed_lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_lazysegtree.nim
    title: cplib/collections/compressed_lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree.nim
    title: cplib/collections/lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree.nim
    title: cplib/collections/lazysegtree.nim
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
    import cplib/collections/compressed_lazysegtree\nimport random, strutils\n\ntype\n\
    \    S = tuple[sum, size: int64]\n    F = tuple[a, b: int64]\nproc merge(x, y:\
    \ S): S = (x.sum + y.sum, x.size + y.size)\nproc mapping(f: F, x: S): S = (f.a\
    \ * x.sum + f.b * x.size, x.size)\nproc composition(f, g: F): F = (f.a * g.a,\
    \ f.a * g.b + f.b)\nproc pointInitial(x: int): S = (0'i64, 1'i64)\nproc intervalInitial(l,\
    \ r: int): S = (0'i64, int64(r - l))\nconst zero: S = (0'i64, 0'i64)\nconst id:\
    \ F = (1'i64, 0'i64)\n\nblock:\n    let st = initCompressedLazySegmentTree([9,\
    \ -100, 9, 100], merge, zero,\n        mapping, composition, id, pointInitial)\n\
    \    doAssert st.len == 3\n    st.apply(-1000, 1000, (1'i64, 3'i64))\n    st.apply(-99,\
    \ 101, (2'i64, 1'i64))\n    doAssert st.get_all() == (17'i64, 3'i64)\n    doAssert\
    \ st[-100] == (3'i64, 1'i64)\n    doAssert st[9] == (7'i64, 1'i64)\n    doAssert\
    \ st[8] == zero\n    st[9] = (20'i64, 1'i64)\n    doAssert st.get(-99, 100) ==\
    \ (20'i64, 1'i64)\n    var rejected = false\n    try: st[8] = zero\n    except\
    \ AssertionDefect: rejected = true\n    doAssert rejected\n\nblock:\n    let st\
    \ = initCompressedLazySegmentTree([1000000000000'i64, -1000000000000'i64, 0'i64],\n\
    \        merge, zero, mapping, composition, id,\n        proc(l, r: int64): S\
    \ = (0'i64, r - l))\n    st.apply(-1000000000000'i64, 1000000000000'i64, (1'i64,\
    \ 3'i64))\n    st.apply(0'i64, 1000000000000'i64, (2'i64, 1'i64))\n    doAssert\
    \ st.len == 2\n    doAssert st.get_all() == (10000000000000'i64, 2000000000000'i64)\n\
    \    doAssert st[0'i64] == (7000000000000'i64, 1000000000000'i64)\n    var rejected\
    \ = false\n    try: discard st.get(-1'i64, 0'i64)\n    except AssertionDefect:\
    \ rejected = true\n    doAssert rejected\n    rejected = false\n    try: st.apply(-1'i64,\
    \ 0'i64, id)\n    except AssertionDefect: rejected = true\n    doAssert rejected\n\
    \    rejected = false\n    try: st[1000000000000'i64] = zero\n    except AssertionDefect:\
    \ rejected = true\n    doAssert rejected\n\nblock:\n    let empty = initCompressedLazySegmentTree(newSeq[int](),\
    \ merge, zero, mapping, composition, id)\n    empty.apply(-10, 10, (1'i64, 5'i64))\n\
    \    doAssert empty.len == 0 and empty.get_all() == zero\n    doAssert empty.get(-10,\
    \ 10) == zero and empty[0] == zero\n    let intervals = initCompressedLazySegmentTree(newSeq[int](),\
    \ merge, zero,\n        mapping, composition, id, intervalInitial)\n    doAssert\
    \ intervals.len == 0 and intervals.get_all() == zero\n    let single = initCompressedLazySegmentTree([5,\
    \ 5], merge, zero,\n        mapping, composition, id, intervalInitial)\n    single.apply(5,\
    \ 5, (0'i64, 9'i64))\n    doAssert single.len == 0 and single.get(5, 5) == zero\n\
    \nblock:\n    for specialized in [false, true]:\n        var rng = initRand(20260914)\n\
    \        for n in 1..30:\n            var coords = @[-100]\n            for i\
    \ in 0..<n: coords.add(coords[^1] + rng.rand(1..9))\n            let points =\
    \ if specialized:\n                newCompressedLazySegWith(coords, merge(l, r),\
    \ zero, mapping(f, x), composition(f, g), id, pointInitial)\n            else:\n\
    \                initCompressedLazySegmentTree(coords, merge, zero, mapping, composition,\
    \ id, pointInitial)\n            let intervals = if specialized:\n           \
    \     newCompressedLazySegWith(coords, merge(l, r), zero, mapping(f, x), composition(f,\
    \ g), id, intervalInitial)\n            else:\n                initCompressedLazySegmentTree(coords,\
    \ merge, zero, mapping, composition, id, intervalInitial)\n            var pointValues\
    \ = newSeq[int64](coords.len)\n            var denseValues = newSeq[int64](coords[^1]\
    \ - coords[0])\n            for step in 0..<400:\n                var a = rng.rand(n)\n\
    \                var b = rng.rand(n)\n                if b < a: swap(a, b)\n \
    \               let l = coords[a]\n                let r = coords[b]\n       \
    \         case rng.rand(2)\n                of 0:\n                    let f:\
    \ F = (int64(rng.rand(0..1)), int64(rng.rand(-5..5)))\n                    points.apply(l,\
    \ r, f)\n                    intervals.apply(l, r, f)\n                    for\
    \ i in a..<b: pointValues[i] = f.a * pointValues[i] + f.b\n                  \
    \  for i in l..<r:\n                        denseValues[i - coords[0]] = f.a *\
    \ denseValues[i - coords[0]] + f.b\n                of 1:\n                  \
    \  let value = int64(rng.rand(-10..10))\n                    points[coords[a]]\
    \ = (value, 1'i64)\n                    pointValues[a] = value\n             \
    \       if a < n:\n                        intervals[coords[a]] = (value * int64(coords[a\
    \ + 1] - coords[a]), int64(coords[a + 1] - coords[a]))\n                     \
    \   for x in coords[a]..<coords[a + 1]: denseValues[x - coords[0]] = value\n \
    \               else: discard\n                var expectedPoints, expectedDense:\
    \ S\n                for i in a..<b: expectedPoints = merge(expectedPoints, (pointValues[i],\
    \ 1'i64))\n                for x in l..<r: expectedDense = merge(expectedDense,\
    \ (denseValues[x - coords[0]], 1'i64))\n                doAssert points.get(l,\
    \ r) == expectedPoints\n                doAssert intervals.get(l, r) == expectedDense\n\
    \                var totalPoints, totalDense: S\n                for v in pointValues:\
    \ totalPoints = merge(totalPoints, (v, 1'i64))\n                for v in denseValues:\
    \ totalDense = merge(totalDense, (v, 1'i64))\n                doAssert points.get_all()\
    \ == totalPoints\n                doAssert intervals.get_all() == totalDense\n\
    \                doAssert points[coords[a]] == (pointValues[a], 1'i64)\n\nblock:\n\
    \    let st = newCompressedLazySegWith([30, 10, 20, 10], merge(l, r), zero,\n\
    \        mapping(f, x), composition(f, g), id, pointInitial)\n    st.apply(10..20,\
    \ (1'i64, 3'i64))\n    doAssert st[10..20] == (6'i64, 2'i64)\n    doAssert st.get(low(int)..high(int))\
    \ == (6'i64, 3'i64)\n    doAssert st[20..<20] == zero\n    st.apply(20..<20, (0'i64,\
    \ 99'i64))\n    doAssert st.get_all() == (6'i64, 3'i64)\n    doAssert $st == \"\
    (sum: 3, size: 1) (sum: 3, size: 1) (sum: 0, size: 1)\"\n    let empty = newCompressedLazySegWith(newSeq[int](),\
    \ merge(l, r), zero,\n        mapping(f, x), composition(f, g), id)\n    doAssert\
    \ $empty == \"\"\n    doAssert empty[low(int)..high(int)] == zero\n    let intervals\
    \ = newCompressedLazySegWith([0, 10, 30], merge(l, r), zero,\n        mapping(f,\
    \ x), composition(f, g), id, intervalInitial)\n    intervals.apply(0..<30, (1'i64,\
    \ 2'i64))\n    doAssert intervals[10..<30] == (40'i64, 20'i64)\n    var rejected\
    \ = false\n    try: discard intervals[0..10]\n    except AssertionDefect: rejected\
    \ = true\n    doAssert rejected\n\nblock:\n    let st = initCompressedLazySegmentTree([\"\
    a\", \"m\", \"z\"], merge, zero,\n        mapping, composition, id, proc(x: string):\
    \ S = (0'i64, 1'i64))\n    st.apply(\"b\"..\"z\", (1'i64, 4'i64))\n    doAssert\
    \ st[\"a\"..\"m\"] == (4'i64, 2'i64)\n\nproc makeCaptured[K](coords: seq[K], scale:\
    \ int64): CompressedLazySegmentTree[K, S, F] =\n    newCompressedLazySegWith(coords,\
    \ merge(l, r), zero,\n        (f.a * x.sum + f.b * scale * x.size, x.size), composition(f,\
    \ g), id,\n        proc(x: K): S = (0'i64, 1'i64))\n\nblock:\n    var coords:\
    \ seq[uint64]\n    for i in countdown(5999, 0):\n        coords.add(high(uint64)\
    \ - uint64(i * 2))\n        coords.add(high(uint64) - uint64(i * 2))\n    let\
    \ original = coords\n    let a = makeCaptured(coords, 2)\n    let b = makeCaptured(coords,\
    \ 3)\n    doAssert coords == original\n    for st in [a, b]:\n        doAssert\
    \ st.len == 6000\n        st.apply(0u64..high(uint64), (0'i64, 7'i64))\n     \
    \   st[high(uint64)] = (11'i64, 1'i64)\n        doAssert st[high(uint64)] == (11'i64,\
    \ 1'i64)\n        doAssert st[high(uint64) - 1] == zero\n    doAssert a[0u64..high(uint64)]\
    \ == (5999'i64 * 14 + 11, 6000'i64)\n    doAssert b[0u64..high(uint64)] == (5999'i64\
    \ * 21 + 11, 6000'i64)\n    let signed = makeCaptured(@[low(int64), -1'i64, 0'i64,\
    \ high(int64)], 1)\n    signed.apply(low(int64)..high(int64), (1'i64, 3'i64))\n\
    \    doAssert signed[low(int64)..high(int64)] == (12'i64, 4'i64)\n\nblock:\n \
    \   var coords: seq[int]\n    for i in countdown(4096, 0): coords.add(i * 3)\n\
    \    let st: CompressedLazySegmentTree[int, S, F] = newCompressedLazySegWith(coords,\n\
    \        merge(l, r), zero, mapping(f, x), composition(f, g), id, intervalInitial)\n\
    \    st.apply(0, 4096 * 3, (0'i64, 2'i64))\n    doAssert st[0..<4096 * 3] == (24576'i64,\
    \ 12288'i64)\n    st.apply(3..<9, (2'i64, 1'i64))\n    doAssert st[3] == (15'i64,\
    \ 3'i64)\n    var rejected = false\n    try: st.apply(1, 3, id)\n    except AssertionDefect:\
    \ rejected = true\n    doAssert rejected\n    rejected = false\n    try: discard\
    \ st[4096 * 3]\n    except AssertionDefect: rejected = true\n    doAssert rejected\n\
    \    rejected = false\n    try: st[4096 * 3] = zero\n    except AssertionDefect:\
    \ rejected = true\n    doAssert rejected\n    let empty = newCompressedLazySegWith(newSeq[int](),\
    \ merge(l, r), zero,\n        mapping(f, x), composition(f, g), id, intervalInitial)\n\
    \    rejected = false\n    try: discard empty[0]\n    except AssertionDefect:\
    \ rejected = true\n    doAssert rejected\n\nblock:\n    let st = newCompressedLazySegWith([\"\
    z\", \"a\", \"m\", \"a\"], l & r, \"\",\n        (if f == '\\0': x else: repeat($f,\
    \ x.len)), (if f == '\\0': g else: f), '\\0',\n        proc(x: string): string\
    \ = x)\n    st.apply(\"a\"..\"m\", 'X')\n    st[\"m\"] = \"YZ\"\n    doAssert\
    \ st[\"a\"..\"z\"] == \"XYZz\"\n    doAssert st.get(\"b\", \"z\") == \"YZ\"\n\
    \    doAssert $st == \"X YZ z\"\n    st.apply(\"m\"..\"z\", 'Q')\n    doAssert\
    \ st.get_all() == \"XQQQ\"\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/compressed_lazysegtree.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/lazysegtree.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/lazysegtree.nim
  - cplib/collections/compressed_lazysegtree.nim
  isVerificationFile: true
  path: verify/AI/compressed_lazysegtree_test.nim
  requiredBy: []
  timestamp: '2026-09-17 19:00:20+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/compressed_lazysegtree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/compressed_lazysegtree_test.nim
- /verify/verify/AI/compressed_lazysegtree_test.nim.html
title: verify/AI/compressed_lazysegtree_test.nim
---
