---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/count_subarrays_with_sum.nim
    title: cplib/utils/count_subarrays_with_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/count_subarrays_with_sum.nim
    title: cplib/utils/count_subarrays_with_sum.nim
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
    import cplib/utils/count_subarrays_with_sum\nimport cplib/math/int128\nimport\
    \ random\n\nproc oracle[T: SomeInteger](a: openArray[T], x: T): int64 =\n    let\
    \ target = to_Int128(x)\n    for l in 0..<a.len:\n        var total = to_Int128(0)\n\
    \        for r in l..<a.len:\n            total += to_Int128(a[r])\n         \
    \   if total == target: inc result\n\nproc check[T: SomeInteger](a: openArray[T],\
    \ x: T) =\n    doAssert count_subarrays_with_sum(a, x) == oracle(a, x)\n\nproc\
    \ checkType[T: SomeInteger]() =\n    static: doAssert count_subarrays_with_sum(newSeq[T](),\
    \ T(0)) is int64\n    check(newSeq[T](), T(0))\n    check(newSeq[T](), high(T))\n\
    \    check([T(0)], T(0))\n    check([T(0)], T(1))\n    check([T(7)], T(7))\n \
    \   check([T(7)], T(6))\n    check([T(0), T(0), T(0), T(0)], T(0))\n    check([T(0),\
    \ T(1), T(0), T(1), T(0)], T(1))\n    check([high(T), T(0)], high(T))\n    when\
    \ T is SomeSignedInt:\n        check([low(T), T(0)], low(T))\n        check([high(T),\
    \ low(T), T(1), T(0)], T(0))\n        check([T(1), T(-1), T(1), T(-1), T(0)],\
    \ T(0))\n        check([T(-3), T(2), T(-1), T(0), T(4)], T(-2))\n    when sizeof(T)\
    \ < 8:\n        check([high(T), high(T), T(0)], high(T))\n        when T is SomeSignedInt:\n\
    \            check([low(T), low(T), high(T)], low(T))\n\ncheckType[int]()\ncheckType[int8]()\n\
    checkType[int16]()\ncheckType[int32]()\ncheckType[int64]()\ncheckType[uint]()\n\
    checkType[uint8]()\ncheckType[uint16]()\ncheckType[uint32]()\ncheckType[uint64]()\n\
    \nfor n in 0..7:\n    var combinations = 1\n    for i in 0..<n: combinations *=\
    \ 3\n    for mask in 0..<combinations:\n        var code = mask\n        var a\
    \ = newSeq[int](n)\n        for i in 0..<n:\n            a[i] = code mod 3 - 1\n\
    \            code = code div 3\n        for x in -n-1..n+1: check(a, x)\n\nvar\
    \ rng = initRand(233023)\nfor trial in 0..<1000:\n    var a = newSeq[int64](rng.rand(0..35))\n\
    \    var b = newSeq[uint64](a.len)\n    for i in 0..<a.len:\n        a[i] = int64(rng.rand(-10..10))\n\
    \        b[i] = uint64(rng.rand(0..10))\n    check(a, int64(rng.rand(-30..30)))\n\
    \    check(b, uint64(rng.rand(0..30)))\n\nlet lo = low(int64)\nlet hi = high(int64)\n\
    for a in [@[lo, 0'i64, hi, 1], @[hi, -hi, -1, 1], @[0'i64, -1, 1, lo],\n     \
    \   @[1'i64, -1, hi, -hi], @[lo, hi, lo + 1, hi]]:\n    for x in [lo, lo + 1,\
    \ -1'i64, 0, 1, hi - 1, hi]: check(a, x)\nlet uhi = high(uint64)\nfor a in [@[0'u64,\
    \ uhi, 0], @[1'u64, uhi - 1, 0], @[uhi - 1, 0'u64, 1]]:\n    for x in [0'u64,\
    \ 1, uhi - 1, uhi]: check(a, x)\n\ntemplate expectOverflow(body: untyped) =\n\
    \    block:\n        var caught = false\n        try: body\n        except OverflowDefect:\
    \ caught = true\n        doAssert caught\n\nproc checkContract[T: SomeInteger](a:\
    \ openArray[T], x: T) =\n    var prefix = to_Int128(0)\n    var outside = false\n\
    \    when T is SomeSignedInt:\n        let minimum = to_Int128(low(int64))\n \
    \       let maximum = to_Int128(high(int64))\n    else:\n        let minimum =\
    \ to_Int128(0)\n        let maximum = to_Int128(high(uint64))\n    for value in\
    \ a:\n        prefix += to_Int128(value)\n        if prefix < minimum or prefix\
    \ > maximum: outside = true\n    if outside:\n        expectOverflow: discard\
    \ count_subarrays_with_sum(a, x)\n    else:\n        check(a, x)\n\nproc checkBoundaries[T:\
    \ SomeInteger](values: openArray[T]) =\n    for n in 0..4:\n        var combinations\
    \ = 1\n        for i in 0..<n: combinations *= values.len\n        for mask in\
    \ 0..<combinations:\n            var code = mask\n            var a = newSeq[T](n)\n\
    \            for i in 0..<n:\n                a[i] = values[code mod values.len]\n\
    \                code = code div values.len\n            for x in values: checkContract(a,\
    \ x)\n\ncheckBoundaries([lo, lo + 1, -1'i64, 0, 1, hi - 1, hi])\ncheckBoundaries([0'u64,\
    \ 1, uhi - 1, uhi])\n\nexpectOverflow: discard count_subarrays_with_sum([hi, 1'i64],\
    \ 0'i64)\nexpectOverflow: discard count_subarrays_with_sum([lo, -1'i64], 0'i64)\n\
    expectOverflow: discard count_subarrays_with_sum([hi, hi], hi)\nexpectOverflow:\
    \ discard count_subarrays_with_sum([lo, lo], lo)\nexpectOverflow: discard count_subarrays_with_sum([uhi,\
    \ 1'u64], 0'u64)\nexpectOverflow: discard count_subarrays_with_sum([uhi, uhi],\
    \ uhi)\n\nlet zeros = newSeq[int8](100000)\ndoAssert count_subarrays_with_sum(zeros,\
    \ 0'i8) == 5000050000'i64\ndoAssert count_subarrays_with_sum(zeros, 1'i8) == 0\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/utils/count_subarrays_with_sum.nim
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  - cplib/utils/count_subarrays_with_sum.nim
  isVerificationFile: true
  path: verify/AI/count_subarrays_with_sum_test.nim
  requiredBy: []
  timestamp: '2026-10-05 11:50:12+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/count_subarrays_with_sum_test.nim
layout: document
redirect_from:
- /verify/verify/AI/count_subarrays_with_sum_test.nim
- /verify/verify/AI/count_subarrays_with_sum_test.nim.html
title: verify/AI/count_subarrays_with_sum_test.nim
---
