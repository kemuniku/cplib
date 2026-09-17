---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_avx512.nim
    title: cplib/graph/warshall_floyd_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_avx512.nim
    title: cplib/graph/warshall_floyd_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_negative.nim
    title: cplib/graph/warshall_floyd_negative.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_negative.nim
    title: cplib/graph/warshall_floyd_negative.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_int32_test.nim
    title: verify/AI/warshall_floyd_avx512_register_int32_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_int32_test.nim
    title: verify/AI/warshall_floyd_avx512_register_int32_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_large_test.nim
    title: verify/AI/warshall_floyd_avx512_register_large_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_large_test.nim
    title: verify/AI/warshall_floyd_avx512_register_large_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_test.nim
    title: verify/AI/warshall_floyd_avx512_register_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_test.nim
    title: verify/AI/warshall_floyd_avx512_register_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "proc hasNegativeCycle[T](a: seq[seq[T]]): bool =\n    for i in 0..<a.len:\n\
    \        if a[i][i] < T(0): return true\n\nimport cplib/graph/warshall_floyd_avx512\n\
    import cplib/utils/constants\nimport random, sequtils\n\nproc check[T](n: int,\
    \ inf: T, unit: int, enabled: bool) =\n    for mode in 0..2:\n        var a =\
    \ newSeqWith(n, newSeqWith(n, inf))\n        for i in 0..<n:\n            a[i][i]\
    \ = 0\n            for j in 0..<n:\n                if i != j and (mode == 0 or\
    \ (mode == 1 and rand(4) == 0) or\n                        (mode == 2 and i div\
    \ 19 == j div 19)):\n                    a[i][j] = T(rand(0..1000) + (j mod 17\
    \ - i mod 17) * unit)\n        # \u5206\u5272\u524D\u3068\u4E71\u6570\u5217\u3092\
    \u63C3\u3048\u308B\u305F\u3081\u3001\u62C5\u5F53\u5916\u306E\u5165\u529B\u3082\
    \u751F\u6210\u3057\u3066\u304B\u3089\u98DB\u3070\u3059\u3002\n        if not enabled:\
    \ continue\n        var expected = a\n        for k in 0..<n:\n            for\
    \ i in 0..<n:\n                for j in 0..<n:\n                    if expected[i][k]\
    \ != inf and expected[k][j] != inf:\n                        expected[i][j] =\
    \ min(expected[i][j], expected[i][k] + expected[k][j])\n        let checked =\
    \ a.warshall_floyd()\n        doAssert not checked.hasNegativeCycle()\n      \
    \  doAssert checked == expected\n        doAssert a.warshall_floyd_nonnegative()\
    \ == expected\n        var inplace = a\n        inplace.warshall_floyd_nonnegative_inplace()\n\
    \        doAssert inplace == expected\n        a[0][n - 1] = -2\n        a[n -\
    \ 1][0] = 1\n        doAssert a.warshall_floyd().hasNegativeCycle()\n\nproc runRegisterTests*(group:\
    \ int) =\n    randomize(512216)\n    for n in [217, 223, 224, 225, 255, 256, 257,\
    \ 433, 447, 448, 449,\n            511, 512, 513, 575, 576, 577]:\n        let\
    \ current = if n <= 257: 0\n                      elif n <= 449: 1\n         \
    \             elif n <= 513: 2\n                      elif n <= 576: 3\n     \
    \                 else: 4\n        check[int](n, INF64, int(10_000_000_001), group\
    \ == current)\n    for n in [257, 271, 272, 287, 288, 289, 513]:\n        check[int32](n,\
    \ INF32, 10_000, group == 5)\n    echo \"Hello World\"\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/graph/warshall_floyd_avx512.nim
  - cplib/graph/warshall_floyd_avx512.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: verify/AI/warshall_floyd_avx512_register_cases.nim
  requiredBy: []
  timestamp: '2026-09-14 17:13:02+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/warshall_floyd_avx512_register_packed_test.nim
  - verify/AI/warshall_floyd_avx512_register_packed_test.nim
  - verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
  - verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
  - verify/AI/warshall_floyd_avx512_register_int32_test.nim
  - verify/AI/warshall_floyd_avx512_register_int32_test.nim
  - verify/AI/warshall_floyd_avx512_register_large_test.nim
  - verify/AI/warshall_floyd_avx512_register_large_test.nim
  - verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
  - verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
  - verify/AI/warshall_floyd_avx512_register_test.nim
  - verify/AI/warshall_floyd_avx512_register_test.nim
documentation_of: verify/AI/warshall_floyd_avx512_register_cases.nim
layout: document
redirect_from:
- /library/verify/AI/warshall_floyd_avx512_register_cases.nim
- /library/verify/AI/warshall_floyd_avx512_register_cases.nim.html
title: verify/AI/warshall_floyd_avx512_register_cases.nim
---
