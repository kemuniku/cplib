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
    \      if a[i][i] < T(0): return true\n\necho \"Hello World\"\n\n\n\nimport cplib/graph/graph\n\
    import cplib/graph/warshall_floyd_avx512\nimport cplib/utils/constants\n\nvar\
    \ g = initWeightedDirectedGraph(3)\ng.add_edge(0, 1, 2)\ng.add_edge(1, 2, 3)\n\
    g.add_edge(0, 2, 10)\nlet wf = g.warshall_floyd()\nassert not wf.hasNegativeCycle()\n\
    assert wf[0][2] == 5\n\nvar parallel = initWeightedDirectedGraph(2)\nparallel.add_edge(0,\
    \ 1, 3)\nparallel.add_edge(0, 1, 7)\nparallel.add_edge(0, 0, 5)\nlet parallelWf\
    \ = parallel.warshall_floyd()\nassert not parallelWf.hasNegativeCycle()\nassert\
    \ parallelWf[0][0] == 0\nassert parallelWf[0][1] == 3\n\n# Exercise both the four-lane\
    \ AVX2 loop and its scalar tail with costs which\n# cannot be represented by int32.\n\
    var wide = initWeightedDirectedGraph(10)\nwide.add_edge(0, 1, int(3_000_000_000))\n\
    wide.add_edge(1, 2, int(4_000_000_000))\nwide.add_edge(2, 9, int(5_000_000_000))\n\
    wide.add_edge(0, 9, int(20_000_000_000))\nlet wideWf = wide.warshall_floyd()\n\
    assert not wideWf.hasNegativeCycle()\nassert wideWf[0][2] == int(7_000_000_000)\n\
    assert wideWf[0][9] == int(12_000_000_000)\nassert wideWf[9][0] == INF64\n\n#\
    \ A complete graph selects the branch-free dense int64 kernel.  Potentials\n#\
    \ make some edges negative while every cycle remains positive.\nvar dense64 =\
    \ initWeightedDirectedGraph(9)\nfor i in 0..<9:\n    for j in 0..<9:\n       \
    \ if i != j:\n            dense64.add_edge(i, j, 10 + 3 * j - 3 * i)\nlet denseWf64\
    \ = dense64.warshall_floyd()\nassert not denseWf64.hasNegativeCycle()\nfor i in\
    \ 0..<9:\n    for j in 0..<9:\n        let expected = if i == j: 0 else: 10 +\
    \ 3 * j - 3 * i\n        assert denseWf64[i][j] == expected\n\n# Cross the dense\
    \ 256-vertex tile boundary.  Reduced costs are either one on\n# the directed ring\
    \ or 100 otherwise; vertex potentials also create negative\n# edges without creating\
    \ a negative cycle.\nconst denseBlockedN = 257\nvar denseBlocked = initWeightedDirectedGraph(denseBlockedN)\n\
    for i in 0..<denseBlockedN:\n    let pi = 3 * (i mod 17)\n    for j in 0..<denseBlockedN:\n\
    \        if i != j:\n            let pj = 3 * (j mod 17)\n            let reduced\
    \ = if j == (i + 1) mod denseBlockedN: 1 else: 100\n            denseBlocked.add_edge(i,\
    \ j, reduced + pj - pi)\nlet denseBlockedWf = denseBlocked.warshall_floyd()\n\
    assert not denseBlockedWf.hasNegativeCycle()\nfor i in 0..<denseBlockedN:\n  \
    \  for j in 0..<denseBlockedN:\n        let ringDistance = (j - i + denseBlockedN)\
    \ mod denseBlockedN\n        let reduced = if i == j: 0 else: min(ringDistance,\
    \ 100)\n        let expected = reduced + 3 * (j mod 17) - 3 * (i mod 17)\n   \
    \     assert denseBlockedWf[i][j] == expected\n\nlet empty = initWeightedDirectedGraph(0).warshall_floyd()\n\
    assert not empty.hasNegativeCycle()\nassert empty.len == 0\n\n# Cross a cache-block\
    \ boundary in every phase of the blocked algorithm.\nvar blocked = initWeightedDirectedGraph(217)\n\
    for i in 0..<216:\n    blocked.add_edge(i, i + 1, 1)\nlet blockedWf = blocked.warshall_floyd()\n\
    assert not blockedWf.hasNegativeCycle()\nassert blockedWf[0][216] == 216\nassert\
    \ blockedWf[216][0] == INF64\n\n# int32 uses eight AVX2 lanes and a separately\
    \ tuned cache block.\nvar g32 = initWeightedDirectedGraph(11, int32)\ng32.add_edge(0,\
    \ 1, 300_000_000.int32)\ng32.add_edge(1, 2, 400_000_000.int32)\ng32.add_edge(2,\
    \ 10, 50_000_000.int32)\ng32.add_edge(0, 10, 900_000_000.int32)\nlet wf32 = g32.warshall_floyd()\n\
    assert not wf32.hasNegativeCycle()\nassert wf32[0][2] == 700_000_000.int32\nassert\
    \ wf32[0][10] == 750_000_000.int32\nassert wf32[10][0] == INF32\n\nvar parallel32\
    \ = initWeightedDirectedGraph(2, int32)\nparallel32.add_edge(0, 1, 3.int32)\n\
    parallel32.add_edge(0, 1, 7.int32)\nparallel32.add_edge(0, 0, 5.int32)\nlet parallelWf32\
    \ = parallel32.warshall_floyd()\nassert not parallelWf32.hasNegativeCycle()\n\
    assert parallelWf32[0][0] == 0.int32\nassert parallelWf32[0][1] == 3.int32\n\n\
    let empty32 = initWeightedDirectedGraph(0, int32).warshall_floyd()\nassert not\
    \ empty32.hasNegativeCycle()\nassert empty32.len == 0\n\nvar blocked32 = initWeightedDirectedGraph(257,\
    \ int32)\nfor i in 0..<256:\n    blocked32.add_edge(i, i + 1, 1.int32)\nlet blockedWf32\
    \ = blocked32.warshall_floyd()\nassert not blockedWf32.hasNegativeCycle()\nassert\
    \ blockedWf32[0][256] == 256.int32\nassert blockedWf32[256][0] == INF32\n\nvar\
    \ static32 = initWeightedDirectedStaticGraph(4, int32)\nstatic32.add_edge(0, 1,\
    \ 2.int32)\nstatic32.add_edge(1, 2, 3.int32)\nstatic32.add_edge(2, 3, 4.int32)\n\
    static32.add_edge(0, 3, 20.int32)\nstatic32.build()\nlet staticWf32 = static32.warshall_floyd()\n\
    assert not staticWf32.hasNegativeCycle()\nassert staticWf32[0][3] == 9.int32\n\
    \nvar ng = initWeightedDirectedGraph(2)\nng.add_edge(0, 1, -2)\nng.add_edge(1,\
    \ 0, -2)\nassert ng.warshall_floyd().hasNegativeCycle()\n\nimport random, sequtils\n\
    \nproc checkRandom[T](n: int, dense: bool, inf: T) =\n    var graph = initWeightedDirectedGraph(n,\
    \ T)\n    var expected = newSeqWith(n, newSeqWith(n, inf))\n    for i in 0..<n:\n\
    \        expected[i][i] = T(0)\n        for j in 0..<n:\n            if i != j\
    \ and (dense or rand(9) == 0):\n                let cost = T(rand(1..100) + 3\
    \ * (j mod 17) - 3 * (i mod 17))\n                graph.add_edge(i, j, cost)\n\
    \                expected[i][j] = cost\n    for k in 0..<n:\n        for i in\
    \ 0..<n:\n            for j in 0..<n:\n                if expected[i][k] != inf\
    \ and expected[k][j] != inf:\n                    expected[i][j] = min(expected[i][j],\
    \ expected[i][k] + expected[k][j])\n    let actual = graph.warshall_floyd(T(0),\
    \ inf)\n    doAssert not actual.hasNegativeCycle()\n    doAssert actual == expected\n\
    \nrandomize(512)\nfor n in [1, 7, 8, 9, 15, 16, 17, 215, 216, 217, 255, 256, 257]:\n\
    \    for dense in [false, true]:\n        checkRandom[int](n, dense, INF64)\n\
    \        checkRandom[int32](n, dense, INF32)\n\nfor n in [17, 257]:\n    var negative32\
    \ = initWeightedDirectedGraph(n, int32)\n    var negative64 = initWeightedDirectedGraph(n)\n\
    \    for i in 0..<n:\n        let cost = if i == n - 1: -n else: 1\n        negative32.add_edge(i,\
    \ (i + 1) mod n, cost.int32)\n        negative64.add_edge(i, (i + 1) mod n, cost)\n\
    \    doAssert negative32.warshall_floyd().hasNegativeCycle()\n    doAssert negative64.warshall_floyd().hasNegativeCycle()\n\
    \n\nblock:\n    proc checkMatrix[T](zero, inf: T) =\n        let a = @[@[inf,\
    \ T(2), T(10)], @[inf, T(5), T(3)], @[inf, inf, zero]]\n        let expected =\
    \ @[@[zero, T(2), T(5)], @[inf, zero, T(3)], @[inf, inf, zero]]\n        let actual\
    \ = a.warshall_floyd(zero, inf)\n        doAssert not actual.hasNegativeCycle()\n\
    \        doAssert actual == expected\n        doAssert a == @[@[inf, T(2), T(10)],\
    \ @[inf, T(5), T(3)], @[inf, inf, zero]]\n        doAssert not newSeq[seq[T]]().warshall_floyd(zero,\
    \ inf).hasNegativeCycle()\n        doAssert newSeq[seq[T]]().warshall_floyd(zero,\
    \ inf).len == 0\n        doAssert @[@[T(-1)]].warshall_floyd(zero, inf).hasNegativeCycle()\n\
    \        doAssert @[@[zero, T(-2)], @[T(1), zero]].warshall_floyd(zero, inf).hasNegativeCycle()\n\
    \        let unreachable = @[@[zero, inf, inf], @[inf, zero, T(-2)], @[inf, inf,\
    \ zero]]\n        doAssert unreachable.warshall_floyd(zero, inf) == unreachable\n\
    \n    checkMatrix[int](0, 1_000_000)\n    checkMatrix[int32](0.int32, 1_000_000.int32)\n\
    \    checkMatrix[float](0.0, 1e100)\n    checkMatrix[float32](0.0'f32, 1e30'f32)\n\
    \    checkMatrix[int16](0.int16, 10_000.int16)\n    doAssert @[@[0, 2], @[3, 0]].warshall_floyd()[0][1]\
    \ == 2\n    doAssert @[@[0.int32]].warshall_floyd() == @[@[0.int32]]\n    doAssert\
    \ @[@[0.0]].warshall_floyd() == @[@[0.0]]\n    doAssert @[@[0.0'f32]].warshall_floyd()\
    \ == @[@[0.0'f32]]\n\n    for n in [17, 217, 257]:\n        var a = newSeq[seq[int]](n)\n\
    \        var a32 = newSeq[seq[int32]](n)\n        for i in 0..<n:\n          \
    \  a[i] = newSeq[int](n)\n            a32[i] = newSeq[int32](n)\n            for\
    \ j in 0..<n:\n                a[i][j] = 1_000_000\n                a32[i][j]\
    \ = 1_000_000.int32\n            if i + 1 < n:\n                a[i][i + 1] =\
    \ 1\n                a32[i][i + 1] = 1.int32\n        let actual = a.warshall_floyd(0,\
    \ 1_000_000)\n        let actual32 = a32.warshall_floyd(0.int32, 1_000_000.int32)\n\
    \        doAssert not actual.hasNegativeCycle()\n        doAssert not actual32.hasNegativeCycle()\n\
    \        for i in 0..<n:\n            for j in 0..<n:\n                let expected\
    \ = if i <= j: j - i else: 1_000_000\n                doAssert actual[i][j] ==\
    \ expected\n                doAssert actual32[i][j] == expected.int32\n      \
    \  doAssert a[0][n - 1] == 1_000_000\n        doAssert a32[0][n - 1] == 1_000_000.int32\n\
    \n\nblock:\n    proc checkNonnegative[T](n: int, dense: bool, zero, inf, unit:\
    \ T) =\n        var a = newSeq[seq[T]](n)\n        var graph = initWeightedDirectedGraph(n,\
    \ T)\n        for i in 0..<n:\n            a[i] = newSeq[T](n)\n            for\
    \ j in 0..<n:\n                a[i][j] = inf\n            a[i][i] = zero\n   \
    \         for j in 0..<n:\n                if i != j and (dense or j == i + 1\
    \ or (i * 17 + j * 31) mod 29 == 0):\n                    let cost = T((i * 7\
    \ + j * 11) mod 13) * unit\n                    a[i][j] = cost\n             \
    \       graph.add_edge(i, j, cost)\n        let expected = a.warshall_floyd(zero,\
    \ inf)\n        doAssert not expected.hasNegativeCycle()\n        let fromMatrix:\
    \ seq[seq[T]] = a.warshall_floyd_nonnegative(zero, inf)\n        let fromGraph:\
    \ seq[seq[T]] = graph.warshall_floyd_nonnegative(zero, inf)\n        doAssert\
    \ fromMatrix == expected\n        doAssert fromGraph == expected\n        var\
    \ checkedInplace = a\n        var uncheckedInplace = a\n        let checkedRow\
    \ = if n == 0: nil else: addr checkedInplace[0][0]\n        let uncheckedRow =\
    \ if n == 0: nil else: addr uncheckedInplace[0][0]\n        checkedInplace.warshall_floyd_inplace(zero,\
    \ inf)\n        doAssert not checkedInplace.hasNegativeCycle()\n        uncheckedInplace.warshall_floyd_nonnegative_inplace(zero,\
    \ inf)\n        doAssert checkedInplace == expected\n        doAssert uncheckedInplace\
    \ == expected\n        if n > 0:\n            doAssert addr(checkedInplace[0][0])\
    \ == checkedRow\n            doAssert addr(uncheckedInplace[0][0]) == uncheckedRow\n\
    \        for i in 0..<n:\n            for j in 0..<n:\n                let original\
    \ = if i == j: zero\n                    elif dense or j == i + 1 or (i * 17 +\
    \ j * 31) mod 29 == 0:\n                        T((i * 7 + j * 11) mod 13) * unit\n\
    \                    else: inf\n                doAssert a[i][j] == original\n\
    \n    for n in [0, 1, 7, 8, 9, 15, 16, 17, 217, 257]:\n        for dense in [false,\
    \ true]:\n            checkNonnegative[int](n, dense, 0, int.high div 4, int(3_000_000_000))\n\
    \            checkNonnegative[int32](n, dense, 0.int32, 1_000_000.int32, 1.int32)\n\
    \    checkNonnegative[float](17, false, 0.0, 1e100, 0.5)\n    checkNonnegative[float32](17,\
    \ true, 0.0'f32, 1e30'f32, 0.5'f32)\n    checkNonnegative[int16](17, false, 0.int16,\
    \ 10_000.int16, 1.int16)\n\n    doAssert @[@[5, 2], @[100, 100]].warshall_floyd_nonnegative(inf\
    \ = 100) == @[@[0, 2], @[100, 0]]\n    doAssert @[@[0.int32]].warshall_floyd_nonnegative()\
    \ == @[@[0.int32]]\n    doAssert @[@[0.0]].warshall_floyd_nonnegative() == @[@[0.0]]\n\
    \    doAssert @[@[0.0'f32]].warshall_floyd_nonnegative() == @[@[0.0'f32]]\n  \
    \  var parallel = initWeightedDirectedGraph(2)\n    parallel.add_edge(0, 1, 0)\n\
    \    parallel.add_edge(0, 1, 5)\n    parallel.add_edge(0, 0, 3)\n    doAssert\
    \ parallel.warshall_floyd_nonnegative(inf = 100) == @[@[0, 0], @[100, 0]]\n  \
    \  var unweighted = initUnWeightedDirectedGraph(3)\n    unweighted.add_edge(0,\
    \ 1)\n    unweighted.add_edge(1, 2)\n    doAssert unweighted.warshall_floyd_nonnegative()[0][2]\
    \ == 2\n    var staticGraph = initWeightedDirectedStaticGraph(3, int32)\n    staticGraph.add_edge(0,\
    \ 1, 2.int32)\n    staticGraph.add_edge(1, 2, 3.int32)\n    staticGraph.build()\n\
    \    doAssert staticGraph.warshall_floyd_nonnegative()[0][2] == 5.int32\n\n\n\
    block:\n    proc checkInplace[T](zero, inf: T) =\n        var d = @[@[inf, T(-2),\
    \ T(10)], @[inf, T(5), T(3)], @[inf, inf, zero]]\n        let expected = @[@[zero,\
    \ T(-2), T(1)], @[inf, zero, T(3)], @[inf, inf, zero]]\n        var unchecked\
    \ = d\n        d.warshall_floyd_inplace(zero, inf)\n        doAssert not d.hasNegativeCycle()\n\
    \        unchecked.warshall_floyd_nonnegative_inplace(zero, inf)\n        doAssert\
    \ d == expected\n        doAssert unchecked == expected\n        var negativeLoop\
    \ = @[@[T(-1)]]\n        negativeLoop.warshall_floyd_inplace(zero, inf)\n    \
    \    doAssert negativeLoop.hasNegativeCycle()\n        doAssert negativeLoop[0][0]\
    \ < zero\n        var negativeCycle = @[@[zero, T(-2)], @[T(1), zero]]\n     \
    \   negativeCycle.warshall_floyd_inplace(zero, inf)\n        doAssert negativeCycle.hasNegativeCycle()\n\
    \        doAssert negativeCycle[0][0] < zero or negativeCycle[1][1] < zero\n\n\
    \    checkInplace[int](0, 1_000_000)\n    checkInplace[int32](0.int32, 1_000_000.int32)\n\
    \    checkInplace[float](0.0, 1e100)\n    checkInplace[float32](0.0'f32, 1e30'f32)\n\
    \    checkInplace[int16](0.int16, 10_000.int16)\n    var d = @[@[10, 2], @[100,\
    \ 100]]\n    d.warshall_floyd_inplace(inf = 100)\n    doAssert not d.hasNegativeCycle()\n\
    \    doAssert d == @[@[0, 2], @[100, 0]]\n    d.warshall_floyd_nonnegative_inplace(inf\
    \ = 100)\n    doAssert d == @[@[0, 2], @[100, 0]]\n    var d32 = @[@[0.int32]]\n\
    \    var df = @[@[0.0]]\n    var df32 = @[@[0.0'f32]]\n    d32.warshall_floyd_inplace()\n\
    \    doAssert not d32.hasNegativeCycle()\n    df.warshall_floyd_inplace()\n  \
    \  doAssert not df.hasNegativeCycle()\n    df32.warshall_floyd_inplace()\n   \
    \ doAssert not df32.hasNegativeCycle()\n    d32.warshall_floyd_nonnegative_inplace()\n\
    \    df.warshall_floyd_nonnegative_inplace()\n    df32.warshall_floyd_nonnegative_inplace()\n"
  dependsOn:
  - cplib/graph/warshall_floyd_avx512.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/warshall_floyd_avx512.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/AI/warshall_floyd_avx512_test.nim
  requiredBy: []
  timestamp: '2026-09-14 16:47:56+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/warshall_floyd_avx512_test.nim
layout: document
redirect_from:
- /verify/verify/AI/warshall_floyd_avx512_test.nim
- /verify/verify/AI/warshall_floyd_avx512_test.nim.html
title: verify/AI/warshall_floyd_avx512_test.nim
---
