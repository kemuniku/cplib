---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
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
    echo \"Hello World\"\n\nimport cplib/collections/waveletmatrix\nimport algorithm,\
    \ options, random\n\nlet wm = initWaveletMatrix(@[3, 1, 4, 1, 5, 9, 2, 6])\nassert\
    \ wm.kth_smallest(0, 8, 0) == 1\nassert wm.kth_smallest(0, 8, 3) == 3\nassert\
    \ wm.kth_smallest(2, 6, 1) == 4\nassert wm.range_lowerbound(0, 8, 4) == 4\nassert\
    \ wm.range_upperbound(0, 8, 4) == 5\nassert wm.range_lowerbound(1, 5, 2) == 2\n\
    assert wm.range_upperbound(1, 5, 1) == 2\nlet child = wm.get_child(3, 0, 8)\n\
    assert child == (l0: 0, r0: 7, l1: 7, r1: 8)\n\nlet boundary = initWaveletMatrix(@[0,\
    \ 7, 3, 7])\nassert boundary.range_lowerbound(0, 4, 8) == 4\nassert boundary.range_lowerbound(1,\
    \ 4, 9) == 3\nassert boundary.range_lowerbound(0, 4, int.high) == 4\nassert boundary.range_lowerbound(0,\
    \ 4, -1) == 0\n\nlet empty = initWaveletMatrix(@[])\nassert empty.range_lowerbound(0,\
    \ 0, 10) == 0\n\nassert boundary.range_upperbound(0, 4, -1) == 0\nassert boundary.count(0,\
    \ 4, -1) == 0\nassert boundary.prev_value(0, 4, 3) == some(0)\nassert boundary.next_value(0,\
    \ 4, 3) == some(3)\nassert boundary.prev_value(0, 4, 0) == none(int)\nassert boundary.next_value(0,\
    \ 4, 8) == none(int)\nassert boundary.range_freq(0, 4, 3, 7) == 1\nassert boundary.count(0,\
    \ 4, 7) == 2\nassert boundary.kth_largest(0, 4, 0) == 7\n\nlet withSum = initWaveletMatrix(@[3,\
    \ 1, 4, 1, 5, 9, 2, 6], with_sum=true)\nassert withSum.sum_smallest(0, 8, 0) ==\
    \ 0\nassert withSum.sum_smallest(0, 8, 4) == 7\nassert withSum.sum_smallest(0,\
    \ 8, 8) == 31\nassert withSum.sum_smallest(2, 6, 3) == 10\nassert withSum.sum_smallest(3,\
    \ 3, 0) == 0\nassert withSum.sum_upperbound(0, 8, 4) == 11\nassert withSum.sum_lowerbound(0,\
    \ 8, 4) == 7\nassert withSum.range_sum(0, 8, 2, 5) == 9\nassert withSum.range_sum(2,\
    \ 6, 2, 5) == 4\n\nproc checkRange(a: seq[int], wm: WaveletMatrix, l, r: int,\
    \ withSum: bool) =\n    let values = sorted(a[l..<r])\n    var total = 0\n   \
    \ if withSum:\n        assert wm.sum_smallest(l, r, 0) == 0\n    for k, x in values:\n\
    \        assert wm.kth_smallest(l, r, k) == x\n        assert wm.kth_largest(l,\
    \ r, k) == values[values.len-1-k]\n        total += x\n        if withSum:\n \
    \           assert wm.sum_smallest(l, r, k+1) == total\n    let thresholds = @[int.low,\
    \ -1, 0, 1, 2, 3, 7, 8, 15, 16, 63, 64, 127, 128, int.high]\n    for x in thresholds:\n\
    \        var less, lessEqual, equal = 0\n        var sumLess, sumLessEqual = 0\n\
    \        var prev, next = none(int)\n        for v in values:\n            if\
    \ v < x:\n                inc less\n                sumLess += v\n           \
    \     prev = some(v)\n            elif next.isNone:\n                next = some(v)\n\
    \            if v <= x:\n                inc lessEqual\n                sumLessEqual\
    \ += v\n            if v == x:\n                inc equal\n        assert wm.range_lowerbound(l,\
    \ r, x) == less\n        assert wm.range_upperbound(l, r, x) == lessEqual\n  \
    \      assert wm.count(l, r, x) == equal\n        assert wm.prev_value(l, r, x)\
    \ == prev\n        assert wm.next_value(l, r, x) == next\n        if withSum:\n\
    \            assert wm.sum_lowerbound(l, r, x) == sumLess\n            assert\
    \ wm.sum_upperbound(l, r, x) == sumLessEqual\n        for high in thresholds:\n\
    \            var freq = 0\n            var sumRange = 0\n            for v in\
    \ values:\n                if x <= v and v < high:\n                    inc freq\n\
    \                    sumRange += v\n            assert wm.range_freq(l, r, x,\
    \ high) == freq\n            if withSum:\n                assert wm.range_sum(l,\
    \ r, x, high) == sumRange\n\nproc checkAll(a: seq[int], h: int = -1) =\n    for\
    \ withSum in [false, true]:\n        let wm = initWaveletMatrix(a, H=h, with_sum=withSum)\n\
    \        for l in 0..a.len:\n            for r in l..a.len:\n                checkRange(a,\
    \ wm, l, r, withSum)\n\ncheckAll(@[])\ncheckAll(@[], 8)\ncheckAll(@[0])\ncheckAll(@[0,\
    \ 0, 0, 0])\ncheckAll(@[0, 0, 0, 0], 0)\ncheckAll(@[7, 7, 7, 7])\ncheckAll(@[3,\
    \ 1, 4, 1, 5, 9, 2, 6])\ncheckAll(@[0, 7, 3, 7], 10)\ncheckAll(@[int.high])\n\
    checkAll(@[0, int.high-2, 1, 1])\n\nvar rng = initRand(20260909)\nfor trial in\
    \ 0..<30:\n    var a = newSeq[int](rng.rand(12))\n    for v in a.mitems:\n   \
    \     v = rng.rand(127)\n    checkAll(a)\n\nfor n in [63, 64, 65, 127, 128, 129]:\n\
    \    var a = newSeq[int](n)\n    for v in a.mitems:\n        v = rng.rand(127)\n\
    \    for withSum in [false, true]:\n        let wm = initWaveletMatrix(a, with_sum=withSum)\n\
    \        checkRange(a, wm, 0, n, withSum)\n        checkRange(a, wm, n, n, withSum)\n\
    \        for trial in 0..<20:\n            let l = rng.rand(n)\n            let\
    \ r = l + rng.rand(n-l)\n            checkRange(a, wm, l, r, withSum)\n"
  dependsOn:
  - cplib/collections/bitvector.nim
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/bitvector.nim
  - cplib/collections/waveletmatrix.nim
  isVerificationFile: true
  path: verify/AI/waveletmatrix_test.nim
  requiredBy: []
  timestamp: '2026-09-09 17:27:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/waveletmatrix_test.nim
layout: document
redirect_from:
- /verify/verify/AI/waveletmatrix_test.nim
- /verify/verify/AI/waveletmatrix_test.nim.html
title: verify/AI/waveletmatrix_test.nim
---
