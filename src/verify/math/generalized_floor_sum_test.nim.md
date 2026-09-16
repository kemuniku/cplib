---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/generalized_floor_sum.nim
    title: cplib/math/generalized_floor_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/generalized_floor_sum.nim
    title: cplib/math/generalized_floor_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/monoid_floor_sum.nim
    title: cplib/math/monoid_floor_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/monoid_floor_sum.nim
    title: cplib/math/monoid_floor_sum.nim
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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    \ninclude cplib/math/generalized_floor_sum\nimport cplib/modint/modint\nimport\
    \ random\n\nproc naive[T](n, m, a, b, p, q: int): seq[seq[T]] =\n    result =\
    \ newSeq[seq[T]](p + 1)\n    for j in 0..p:\n        result[j] = newSeq[T](q +\
    \ 1)\n    for i in 0..<n:\n        let xi: T = i\n        let yi: T = (a * i +\
    \ b) div m\n        var xp: T = 1\n        for j in 0..p:\n            var yp:\
    \ T = 1\n            for k in 0..q:\n                result[j][k] = result[j][k]\
    \ + xp * yp\n                yp = yp * yi\n            xp = xp * xi\n\nfor n in\
    \ 0..6:\n    for m in 1..6:\n        for a in 0..6:\n            for b in 0..6:\n\
    \                doAssert generalizedFloorSumTable[int](n, m, a, b, 3, 3) ==\n\
    \                    naive[int](n, m, a, b, 3, 3)\n\nproc values[T](table: seq[seq[T]]):\
    \ seq[seq[int]] =\n    result = newSeq[seq[int]](table.len)\n    for j in 0..<table.len:\n\
    \        for value in table[j]:\n            result[j].add(value.val)\n\nproc\
    \ check[T]() =\n    var rng = initRand(20260912)\n    for test in 0..<150:\n \
    \       let\n            n = rng.rand(30)\n            m = rng.rand(1..100)\n\
    \            a = rng.rand(100)\n            b = rng.rand(100)\n            p =\
    \ rng.rand(5)\n            q = rng.rand(5)\n        let expected = naive[T](n,\
    \ m, a, b, p, q)\n        doAssert generalizedFloorSumTable[T](n, m, a, b, p,\
    \ q).values == expected.values\n        doAssert generalizedFloorSum[T](n, m,\
    \ a, b, p, q).val == expected[p][q].val\n\n    let n = 1_000_000_000\n    let\
    \ nn: T = n\n    let triangle: T = n * (n - 1) div 2\n    doAssert generalizedFloorSum[T](n,\
    \ 1, 1, 0, 0, 0).val == nn.val\n    doAssert generalizedFloorSum[T](n, 1, 1, 0,\
    \ 1, 0).val == triangle.val\n    doAssert generalizedFloorSum[T](n, 1, 1, 0, 0,\
    \ 1).val == triangle.val\n    doAssert generalizedFloorSum[T](n, 1, 1, 0, 1, 2).val\
    \ == (triangle * triangle).val\n    doAssert generalizedFloorSum[T](n, n, n -\
    \ 1, 0, 0, 1).val == (triangle - (nn - 1)).val\n    doAssert generalizedFloorSumTable[T](0,\
    \ 1, high(int), high(int), 2, 3).values ==\n        naive[T](0, 1, high(int),\
    \ high(int), 2, 3).values\n    doAssert generalizedFloorSumTable[T](2, high(int)\
    \ - 1, high(int) div 2, 1, 2, 3).values ==\n        naive[T](2, high(int) - 1,\
    \ high(int) div 2, 1, 2, 3).values\n\ncheck[modint998244353_montgomery]()\ncheck[modint1000000007_barrett]()\n\
    modint_barrett.setMod(12)\ncheck[modint_barrett]()\nmodint_barrett.setMod(2)\n\
    check[modint_barrett]()\n\ndoAssert generalizedFloorSum[int](4, 3, 2, 1, 1, 2)\
    \ == 15\necho \"Hello World\"\n"
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/generalized_floor_sum.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/math/generalized_floor_sum.nim
  - cplib/math/monoid_floor_sum.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/monoid_floor_sum.nim
  isVerificationFile: true
  path: verify/math/generalized_floor_sum_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/generalized_floor_sum_test.nim
layout: document
redirect_from:
- /verify/verify/math/generalized_floor_sum_test.nim
- /verify/verify/math/generalized_floor_sum_test.nim.html
title: verify/math/generalized_floor_sum_test.nim
---
