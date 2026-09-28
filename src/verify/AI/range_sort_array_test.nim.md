---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_sort_array.nim
    title: cplib/collections/range_sort_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_sort_array.nim
    title: cplib/collections/range_sort_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_sort_segtree.nim
    title: cplib/collections/range_sort_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_sort_segtree.nim
    title: cplib/collections/range_sort_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
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
    import algorithm, random\nimport cplib/collections/range_sort_array\nimport cplib/collections/range_sort_segtree\n\
    \nproc check(a: RangeSortArray, expected: seq[int]) =\n    doAssert a.len == expected.len\n\
    \    doAssert a.toSeq() == expected\n    var actual: seq[int]\n    for value in\
    \ a.items: actual.add(value)\n    doAssert actual == expected\n    for i, value\
    \ in expected:\n        doAssert a[i] == value\n        doAssert a.get(i) == value\n\
    \        doAssert a.key(i) == value\n        doAssert a[^(a.len - i)] == value\n\
    \nblock:\n    let a = initRangeSortArray([], 0)\n    a.sort(0, 0)\n    a.sort(0..<0,\
    \ Descending)\n    a.check(@[])\n\nblock:\n    let a = initRangeSortArray([0],\
    \ 1)\n    a.sort(0, 1)\n    a.sort(0..<1, Descending)\n    a[^1] = 0\n    a.check(@[0])\n\
    \nblock:\n    let a = initRangeSortArray([3, 1, 2], 5)\n    a.sort(0, 3)\n   \
    \ a.check(@[1, 2, 3])\n    a.sort(0..<2, Descending)\n    a.check(@[2, 1, 3])\n\
    \    a[^1] = 4\n    a.check(@[2, 1, 4])\n    let seg = initRangeSortSegmentTree([1,\
    \ 0], [\"a\", \"b\"], 2,\n        proc(x, y: string): string = x & y, \"\")\n\
    \    seg.sort(0, 2)\n    doAssert seg.get_all() == \"ba\"\n\nvar rng = initRand(20260928)\n\
    for n in [1, 2, 3, 7, 16, 31, 64]:\n    for mode in 0..2:\n        let limit =\
    \ if mode == 0: n * 4 + 7 else: int.high\n        let base = if mode == 2: int.high\
    \ - n * 4 - 7 else: 0\n        var expected = newSeq[int](n)\n        for i in\
    \ 0..<n:\n            expected[i] = base + (2 * i + 1) *\n                (if\
    \ mode == 1: int.high div (n * 4 + 7) else: 1)\n        rng.shuffle(expected)\n\
    \        let a = initRangeSortArray(expected, limit)\n        a.check(expected)\n\
    \        for step in 0..<1500:\n            case rng.rand(3)\n            of 0,\
    \ 1:\n                var l = rng.rand(n)\n                var r = rng.rand(n)\n\
    \                if l > r: swap(l, r)\n                if step mod 5 == 0:\n \
    \                   l = 0\n                    r = n\n                let order\
    \ = if step mod 2 == 0: Ascending else: Descending\n                var part =\
    \ expected[l..<r]\n                part.sort(order)\n                for i, value\
    \ in part: expected[l + i] = value\n                if step mod 2 == 0: a.sort(l,\
    \ r, order)\n                else: a.sort(l..<r, order)\n            else:\n \
    \               let index = rng.rand(n - 1)\n                var value = base\
    \ + rng.rand(limit - base - 1)\n                while value != expected[index]\
    \ and value in expected:\n                    value = base + rng.rand(limit -\
    \ base - 1)\n                case step mod 3\n                of 0: a.update(index,\
    \ value)\n                of 1: a[index] = value\n                else: a[^(n\
    \ - index)] = value\n                expected[index] = value\n            a.check(expected)\n\
    \nblock:\n    let a = initRangeSortArray([int.high - 1, 0, 1, int.high div 2],\
    \ int.high)\n    for _ in 0..<1000:\n        a.sort(0, 4)\n        a.check(@[0,\
    \ 1, int.high div 2, int.high - 1])\n        a.sort(1, 3, Descending)\n      \
    \  a.check(@[0, int.high div 2, 1, int.high - 1])\n        a.sort(0, 4, Descending)\n\
    \        a.check(@[int.high - 1, int.high div 2, 1, 0])\n\nwhen compileOption(\"\
    assertions\"):\n    block:\n        var rejected = false\n        try:\n     \
    \       discard initRangeSortArray([1, 1], 2)\n        except AssertionDefect:\n\
    \            rejected = true\n        doAssert rejected\n    block:\n        let\
    \ a = initRangeSortArray([0, 1, 2], 4)\n        a.sort(0, 3, Descending)\n   \
    \     for value in [-1, 2, 4]:\n            var rejected = false\n           \
    \ try:\n                a[1] = value\n            except AssertionDefect:\n  \
    \              rejected = true\n            doAssert rejected\n            a.check(@[2,\
    \ 1, 0])\n        a[1] = 1\n        a[1] = 3\n        a.check(@[2, 3, 0])\n\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/collections/range_sort_segtree.nim
  - cplib/collections/segtree.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/segtree.nim
  - cplib/collections/range_sort_segtree.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/range_sort_array.nim
  - cplib/collections/range_sort_array.nim
  isVerificationFile: true
  path: verify/AI/range_sort_array_test.nim
  requiredBy: []
  timestamp: '2026-09-28 03:02:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/range_sort_array_test.nim
layout: document
redirect_from:
- /verify/verify/AI/range_sort_array_test.nim
- /verify/verify/AI/range_sort_array_test.nim.html
title: verify/AI/range_sort_array_test.nim
---
