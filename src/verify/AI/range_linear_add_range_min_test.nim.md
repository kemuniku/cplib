---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_linear_add_range_min.nim
    title: cplib/collections/range_linear_add_range_min.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_linear_add_range_min.nim
    title: cplib/collections/range_linear_add_range_min.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
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
    import random\nimport cplib/collections/range_linear_add_range_min\n\nproc checkAll(seg:\
    \ RangeLinearAddRangeMin, a: seq[int]) =\n    doAssert seg.len == a.len\n    for\
    \ l in 0..a.len:\n        var expected = high(int)\n        doAssert seg.prod(l,\
    \ l) == expected\n        for r in l + 1..a.len:\n            expected = min(expected,\
    \ a[r - 1])\n            doAssert seg.prod(l, r) == expected\n            doAssert\
    \ seg[l..<r] == expected\n    for i in 0..<a.len:\n        doAssert seg[i] ==\
    \ a[i]\n\nproc apply(seg: RangeLinearAddRangeMin, a: var seq[int], l, r, b, c:\
    \ int) =\n    seg.add(l, r, b, c)\n    for i in l..<r:\n        a[i] += b * i\
    \ + c\n\nlet empty = initRangeLinearAddRangeMin(newSeq[int]())\nempty.add(0..<0,\
    \ 1, 2)\ncheckAll(empty, @[])\n\nvar rng = initRand(20260908)\nfor n in [1, 2,\
    \ 3, 5, 8, 13, 16, 31, 32, 33, 65]:\n    for shape in 0..4:\n        var a = newSeq[int](n)\n\
    \        for i in 0..<n:\n            a[i] = case shape\n                of 0:\
    \ 0\n                of 1: 13 * i - 100\n                of 2: i * i\n       \
    \         of 3: -i * i\n                else: rng.rand(-1000..1000)\n        let\
    \ seg = initRangeLinearAddRangeMin(a)\n        checkAll(seg, a)\n        for step\
    \ in 0..<150:\n            var l = rng.rand(0..n)\n            var r = rng.rand(0..n)\n\
    \            if l > r: swap(l, r)\n            if step mod 5 == 0:\n         \
    \       l = 0\n                r = n\n            let b = rng.rand(-100..100)\n\
    \            let c = rng.rand(-1000..1000)\n            apply(seg, a, l, r, b,\
    \ c)\n            if step mod 10 == 0:\n                checkAll(seg, a)\n   \
    \         else:\n                let x = rng.rand(0..<n)\n                let\
    \ y = rng.rand(x + 1..n)\n                var expected = high(int)\n         \
    \       for i in x..<y: expected = min(expected, a[i])\n                doAssert\
    \ seg.prod(x..<y) == expected\n        checkAll(seg, a)\n\nblock:\n    var a =\
    \ @[high(int) - 100, low(int) + 100, high(int) - 200,\n              low(int)\
    \ + 200, 0, high(int) - 300, low(int) + 300]\n    let seg = initRangeLinearAddRangeMin(a)\n\
    \    checkAll(seg, a)\n    apply(seg, a, 0, a.len, 1, -5)\n    checkAll(seg, a)\n\
    \    apply(seg, a, 1, 6, -2, 10)\n    checkAll(seg, a)\n\nblock:\n    var a =\
    \ newSeq[int](129)\n    let seg = initRangeLinearAddRangeMin(a)\n    for step\
    \ in 0..<2000:\n        seg.add(0..<a.len, 99, 9_999_999)\n        for i in 0..<a.len:\
    \ a[i] += 99 * i + 9_999_999\n    apply(seg, a, 1, 128, -1_000_000, -1_000_000_000_000.int)\n\
    \    checkAll(seg, a)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/range_linear_add_range_min.nim
  - cplib/math/int128.nim
  - cplib/collections/range_linear_add_range_min.nim
  - cplib/math/int128.nim
  isVerificationFile: true
  path: verify/AI/range_linear_add_range_min_test.nim
  requiredBy: []
  timestamp: '2026-09-09 00:03:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/range_linear_add_range_min_test.nim
layout: document
redirect_from:
- /verify/verify/AI/range_linear_add_range_min_test.nim
- /verify/verify/AI/range_linear_add_range_min_test.nim.html
title: verify/AI/range_linear_add_range_min_test.nim
---
