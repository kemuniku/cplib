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
    path: cplib/collections/fenwick_avx2.nim
    title: cplib/collections/fenwick_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/fenwick_avx2.nim
    title: cplib/collections/fenwick_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix_fenwick.nim
    title: cplib/collections/waveletmatrix_fenwick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix_fenwick.nim
    title: cplib/collections/waveletmatrix_fenwick.nim
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
    import algorithm, random\nimport cplib/collections/waveletmatrix_fenwick\n\nblock:\n\
    \    let wm = initWaveletMatrixFenwick(@[(3, 10), (1, 20), (3, -5), (7, 8)])\n\
    \    assert wm.len == 4\n    assert wm.range_sum(0, 4, 3) == 25\n    assert wm.range_sum(1,\
    \ 4, 3, 7) == -5\n    assert wm.range_sum(0, 4) == 33\n    wm.add(2, 12)\n   \
    \ assert wm[2] == 7\n    assert wm.range_sum(0, 4, 3) == 37\n    wm[1] = -4\n\
    \    assert wm.range_sum(0, 4, 3) == 13\n    assert wm.range_sum(1, 3) == 3\n\n\
    proc check(values: seq[(int, int)]) =\n    let wm = initWaveletMatrixFenwick(values)\n\
    \    var expected = values\n    for i in 0..<values.len:\n        assert wm[i]\
    \ == values[i][1]\n    var thresholds = @[int.low, -101, -1, 0, 1, 101, int.high]\n\
    \    for value in values:\n        thresholds.add(value[0])\n    thresholds.sort()\n\
    \    for step in 0..<30:\n        if values.len > 0:\n            let i = rand(values.high)\n\
    \            let value = rand(-100..100)\n            if step mod 2 == 0:\n  \
    \              wm.add(i, value)\n                expected[i][1] += value\n   \
    \         else:\n                wm[i] = value\n                expected[i][1]\
    \ = value\n        for i in 0..<values.len:\n            assert wm[i] == expected[i][1]\n\
    \        for l in 0..values.len:\n            for r in l..values.len:\n      \
    \          var total = 0\n                for i in l..<r:\n                  \
    \  total += expected[i][1]\n                assert wm.range_sum(l, r) == total\n\
    \                for x in thresholds:\n                    var sum = 0\n     \
    \               for i in l..<r:\n                        if expected[i][0] <=\
    \ x:\n                            sum += expected[i][1]\n                    assert\
    \ wm.range_sum(l, r, x) == sum\n                let a = rand(thresholds.high)\n\
    \                let b = rand(a..thresholds.high)\n                let lower =\
    \ thresholds[a]\n                let upper = thresholds[b]\n                var\
    \ sum = 0\n                for i in l..<r:\n                    if lower <= expected[i][0]\
    \ and expected[i][0] < upper:\n                        sum += expected[i][1]\n\
    \                assert wm.range_sum(l, r, lower, upper) == sum\n\nrandomize(20260909)\n\
    check(@[])\ncheck(@[(0, 5)])\ncheck(@[(-3, 1), (-3, -2), (-3, 7)])\ncheck(@[(int.low,\
    \ 4), (int.high, -3), (0, 8), (int.low, -2)])\nfor n in 0..16:\n    var values\
    \ = newSeq[(int, int)](n)\n    for i in 0..<n:\n        values[i] = (rand(-10..10),\
    \ rand(-100..100))\n    check(values)\n\nfor n in [63, 64, 65, 127, 128, 129]:\n\
    \    var values = newSeq[(int, int)](n)\n    for i in 0..<n:\n        values[i]\
    \ = (i - 64, i mod 7 - 3)\n    let wm = initWaveletMatrixFenwick(values)\n   \
    \ for step in 0..<300:\n        let i = rand(n - 1)\n        let delta = rand(-100..100)\n\
    \        wm.add(i, delta)\n        values[i][1] += delta\n        let l = rand(n)\n\
    \        let r = rand(l..n)\n        let x = rand(-100..100)\n        var sum\
    \ = 0\n        for j in l..<r:\n            if values[j][0] <= x:\n          \
    \      sum += values[j][1]\n        assert wm.range_sum(l, r, x) == sum\n\necho\
    \ \"Hello World\"\n"
  dependsOn:
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/fenwick_avx2.nim
  - cplib/collections/waveletmatrix_fenwick.nim
  - cplib/collections/fenwick_avx2.nim
  - cplib/collections/waveletmatrix_fenwick.nim
  - cplib/collections/bitvector.nim
  - cplib/collections/bitvector.nim
  - cplib/collections/waveletmatrix.nim
  isVerificationFile: true
  path: verify/AI/waveletmatrix_fenwick_test.nim
  requiredBy: []
  timestamp: '2026-09-14 23:35:39+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/waveletmatrix_fenwick_test.nim
layout: document
redirect_from:
- /verify/verify/AI/waveletmatrix_fenwick_test.nim
- /verify/verify/AI/waveletmatrix_fenwick_test.nim.html
title: verify/AI/waveletmatrix_fenwick_test.nim
---
