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
    path: cplib/graph/warshall_floyd_avx.nim
    title: cplib/graph/warshall_floyd_avx.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_avx.nim
    title: cplib/graph/warshall_floyd_avx.nim
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
    proc hasNegativeCycle[T](a: seq[seq[T]]): bool =\n    for i in 0..<a.len:\n  \
    \      if a[i][i] < T(0): return true\n\nimport cplib/graph/warshall_floyd_avx\n\
    import cplib/utils/constants\nimport random, sequtils\n\nproc reference(a: seq[seq[int]],\
    \ inf: int): seq[seq[int]] =\n    result = a\n    for i in 0..<a.len:\n      \
    \  result[i][i] = min(result[i][i], 0)\n    for k in 0..<a.len:\n        for i\
    \ in 0..<a.len:\n            for j in 0..<a.len:\n                if result[i][k]\
    \ != inf and result[k][j] != inf:\n                    result[i][j] = min(result[i][j],\
    \ result[i][k] + result[k][j])\n\nproc check(a: seq[seq[int]], inf: int) =\n \
    \   let expected = reference(a, inf)\n    let actual = a.warshall_floyd(inf =\
    \ inf)\n    doAssert not actual.hasNegativeCycle()\n    doAssert actual == expected\n\
    \    doAssert a.warshall_floyd_nonnegative(inf = inf) == expected\n    var inplace\
    \ = a\n    inplace.warshall_floyd_inplace(inf = inf)\n    doAssert not inplace.hasNegativeCycle()\n\
    \    doAssert inplace == expected\n    inplace = a\n    inplace.warshall_floyd_nonnegative_inplace(inf\
    \ = inf)\n    doAssert inplace == expected\n\nrandomize(20260914)\nfor n in [127,\
    \ 128, 129, 255, 256, 257]:\n    for density in [0, 3, 100]:\n        var a =\
    \ newSeqWith(n, newSeqWith(n, INF64))\n        for i in 0..<n:\n            for\
    \ j in 0..<n:\n                if rand(99) < density:\n                    a[i][j]\
    \ = rand(0..1_000_000_000)\n        check(a, INF64)\n\nfor n in [129, 257]:\n\
    \    let limit = (1 shl 52) div n\n    for weight in [limit - 1, limit, limit\
    \ + 1]:\n        var a = newSeqWith(n, newSeqWith(n, INF64))\n        for i in\
    \ 0..<n - 1:\n            a[i][i + 1] = weight - (i mod 2)\n        a[n - 1][0]\
    \ = 0\n        check(a, INF64)\n\nblock:\n    const n = 129\n    var a = newSeqWith(n,\
    \ newSeqWith(n, 100))\n    a[0][1] = 70\n    a[1][2] = 70\n    a[2][3] = 0\n \
    \   for i in 3..<n:\n        a[i][(i + 1) mod n] = 0\n    check(a, 100)\n    a[0][1]\
    \ = 101\n    check(a, 100)\n\n    a = newSeqWith(n, newSeqWith(n, INF64))\n  \
    \  a[0][1] = (1 shl 53) + 1\n    a[1][2] = 2\n    a[0][2] = (1 shl 53) + 4\n \
    \   check(a, INF64)\n    a[0][1] = -1\n    a[1][2] = 2\n    check(a, INF64)\n\
    \    a[1][0] = 0\n    doAssert a.warshall_floyd().hasNegativeCycle()\n\nfor n\
    \ in [128, 129, 255, 256, 257]:\n    for dense in [false, true]:\n        let\
    \ potential = newSeqWith(n, rand(-1_000_000_000..1_000_000_000))\n        var\
    \ a = newSeqWith(n, newSeqWith(n, INF64))\n        for i in 0..<n:\n         \
    \   for j in 0..<n:\n                if i != j and (dense or (i div 64 == j div\
    \ 64 and rand(9) < 3)):\n                    a[i][j] = rand(0..1000) + potential[j]\
    \ - potential[i]\n        check(a, INF64)\n\nfor n in [129, 257]:\n    let limit\
    \ = (1 shl 52) div n\n    for magnitude in [limit - 1, limit, limit + 1]:\n  \
    \      var a = newSeqWith(n, newSeqWith(n, INF64))\n        for i in 0..<n - 1:\n\
    \            a[i][i + 1] = -magnitude + (i mod 2)\n            if i + 2 < n:\n\
    \                a[i][i + 2] = 0\n        check(a, INF64)\n\nblock:\n    const\
    \ n = 129\n    var a = newSeqWith(n, newSeqWith(n, 100))\n    a[0][1] = 70\n \
    \   a[1][2] = 70\n    a[2][3] = -80\n    for i in 4..<n:\n        for j in 4..<n:\n\
    \            a[i][j] = 0\n    check(a, 100)\n\necho \"Hello World\"\n\n\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/graph/warshall_floyd_avx.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/warshall_floyd_avx.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/graph/graph.nim
  - cplib/graph/warshall_floyd_negative.nim
  isVerificationFile: true
  path: verify/AI/warshall_floyd_avx_exact_test.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/warshall_floyd_avx_exact_test.nim
layout: document
redirect_from:
- /verify/verify/AI/warshall_floyd_avx_exact_test.nim
- /verify/verify/AI/warshall_floyd_avx_exact_test.nim.html
title: verify/AI/warshall_floyd_avx_exact_test.nim
---
