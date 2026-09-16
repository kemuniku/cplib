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
    path: cplib/graph/warshall_floyd.nim
    title: cplib/graph/warshall_floyd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd.nim
    title: cplib/graph/warshall_floyd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_avx.nim
    title: cplib/graph/warshall_floyd_avx.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_avx.nim
    title: cplib/graph/warshall_floyd_avx.nim
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
    echo \"Hello World\"\nimport sequtils, random\nimport cplib/graph/graph\nwhen\
    \ defined(testAvx512):\n    import cplib/graph/warshall_floyd_avx512\nelif defined(testAvx):\n\
    \    import cplib/graph/warshall_floyd_avx\nelse:\n    import cplib/graph/warshall_floyd\n\
    \nproc reference(a: seq[seq[int]], inf: int): seq[seq[int]] =\n    let n = a.len\n\
    \    result = newSeqWith(n, newSeqWith(n, inf))\n    for source in 0..<n:\n  \
    \      var dist = newSeqWith(n, inf)\n        dist[source] = 0\n        var affected\
    \ = newSeq[bool](n)\n        for step in 0..<n:\n            var next = dist\n\
    \            for i in 0..<n:\n                if dist[i] == inf: continue\n  \
    \              for j in 0..<n:\n                    if a[i][j] != inf and dist[i]\
    \ + a[i][j] < next[j]:\n                        next[j] = dist[i] + a[i][j]\n\
    \                        if step == n - 1: affected[j] = true\n            dist\
    \ = next\n        for step in 0..<n:\n            for i in 0..<n:\n          \
    \      if affected[i]:\n                    for j in 0..<n:\n                \
    \        if a[i][j] != inf: affected[j] = true\n        for j in 0..<n:\n    \
    \        result[source][j] = if affected[j]: -inf else: dist[j]\n\nproc check[T](a:\
    \ seq[seq[int]], expected: seq[seq[int]]) =\n    let inf = T(1000000)\n    var\
    \ matrix = newSeqWith(a.len, newSeq[T](a.len))\n    var answer = newSeqWith(a.len,\
    \ newSeq[T](a.len))\n    var graph = initWeightedDirectedGraph(a.len, T)\n   \
    \ var staticGraph = initWeightedDirectedStaticGraph(a.len, T)\n    for i in 0..<a.len:\n\
    \        for j in 0..<a.len:\n            matrix[i][j] = T(a[i][j])\n        \
    \    answer[i][j] = T(expected[i][j])\n            if a[i][j] != 1000000:\n  \
    \              graph.add_edge(i, j, T(a[i][j]))\n                staticGraph.add_edge(i,\
    \ j, T(a[i][j]))\n    let saved = matrix\n    let actual: seq[seq[T]] = matrix.warshall_floyd(T(0),\
    \ inf)\n    doAssert actual == answer\n    doAssert matrix == saved\n    doAssert\
    \ graph.warshall_floyd(T(0), inf) == answer\n    staticGraph.build()\n    doAssert\
    \ staticGraph.warshall_floyd(T(0), inf) == answer\n    matrix.warshall_floyd_inplace(T(0),\
    \ inf)\n    doAssert matrix == answer\n\nlet inf = 1000000\nvar rng = initRand(719)\n\
    for n in 0..12:\n    for trial in 0..<20:\n        var a = newSeqWith(n, newSeqWith(n,\
    \ inf))\n        for i in 0..<n:\n            a[i][i] = 0\n            for j in\
    \ 0..<n:\n                if rng.rand(99) < 25: a[i][j] = rng.rand(-8..12)\n \
    \       let expected = reference(a, inf)\n        check[int](a, expected)\n  \
    \      check[int32](a, expected)\n        check[float](a, expected)\n        check[float32](a,\
    \ expected)\n\nfor n in [65, 257, 513]:\n    var a = newSeqWith(n, newSeqWith(n,\
    \ inf))\n    for i in 0..<n: a[i][i] = 0\n    a[0][1] = 2\n    a[1][2] = -3\n\
    \    a[2][1] = 1\n    a[2][3] = 5\n    a[0][4] = 7\n    a[5][4] = -2\n    a[4][6]\
    \ = 3\n    a[n-2][n-1] = -4\n    a[n-1][n-2] = 1\n    var expected = a\n    expected[0][6]\
    \ = 10\n    expected[5][6] = 1\n    for i in [0, 1, 2]:\n        for j in [1,\
    \ 2, 3]: expected[i][j] = -inf\n    for i in [n-2, n-1]:\n        for j in [n-2,\
    \ n-1]: expected[i][j] = -inf\n    check[int](a, expected)\n    check[int32](a,\
    \ expected)\n"
  dependsOn:
  - cplib/graph/warshall_floyd.nim
  - cplib/utils/constants.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/graph/warshall_floyd_avx.nim
  - cplib/graph/warshall_floyd_avx.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/utils/constants.nim
  - cplib/graph/warshall_floyd_avx512.nim
  - cplib/graph/graph.nim
  - cplib/graph/warshall_floyd_avx512.nim
  - cplib/graph/warshall_floyd.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/warshall_floyd_negative_test.nim
  requiredBy: []
  timestamp: '2026-09-14 16:47:56+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/warshall_floyd_negative_test.nim
layout: document
redirect_from:
- /verify/verify/AI/warshall_floyd_negative_test.nim
- /verify/verify/AI/warshall_floyd_negative_test.nim.html
title: verify/AI/warshall_floyd_negative_test.nim
---
