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
    echo \"Hello World\"\n\nimport cplib/graph/graph\nimport cplib/graph/warshall_floyd_avx\n\
    import cplib/utils/constants\n\nvar g = initWeightedDirectedGraph(3)\ng.add_edge(0,\
    \ 1, 2)\ng.add_edge(1, 2, 3)\ng.add_edge(0, 2, 10)\nlet wf = g.warshall_floyd()\n\
    assert not wf.negative_cycle\nassert wf.d[0][2] == 5\n\nvar parallel = initWeightedDirectedGraph(2)\n\
    parallel.add_edge(0, 1, 3)\nparallel.add_edge(0, 1, 7)\nparallel.add_edge(0, 0,\
    \ 5)\nlet parallelWf = parallel.warshall_floyd()\nassert not parallelWf.negative_cycle\n\
    assert parallelWf.d[0][0] == 0\nassert parallelWf.d[0][1] == 3\n\n# Exercise both\
    \ the four-lane AVX2 loop and its scalar tail with costs which\n# cannot be represented\
    \ by int32.\nvar wide = initWeightedDirectedGraph(10)\nwide.add_edge(0, 1, int(3_000_000_000))\n\
    wide.add_edge(1, 2, int(4_000_000_000))\nwide.add_edge(2, 9, int(5_000_000_000))\n\
    wide.add_edge(0, 9, int(20_000_000_000))\nlet wideWf = wide.warshall_floyd()\n\
    assert not wideWf.negative_cycle\nassert wideWf.d[0][2] == int(7_000_000_000)\n\
    assert wideWf.d[0][9] == int(12_000_000_000)\nassert wideWf.d[9][0] == INF64\n\
    \n# A complete graph selects the branch-free dense int64 kernel.  Potentials\n\
    # make some edges negative while every cycle remains positive.\nvar dense64 =\
    \ initWeightedDirectedGraph(9)\nfor i in 0..<9:\n    for j in 0..<9:\n       \
    \ if i != j:\n            dense64.add_edge(i, j, 10 + 3 * j - 3 * i)\nlet denseWf64\
    \ = dense64.warshall_floyd()\nassert not denseWf64.negative_cycle\nfor i in 0..<9:\n\
    \    for j in 0..<9:\n        let expected = if i == j: 0 else: 10 + 3 * j - 3\
    \ * i\n        assert denseWf64.d[i][j] == expected\n\n# Cross the dense 256-vertex\
    \ tile boundary.  Reduced costs are either one on\n# the directed ring or 100\
    \ otherwise; vertex potentials also create negative\n# edges without creating\
    \ a negative cycle.\nconst denseBlockedN = 257\nvar denseBlocked = initWeightedDirectedGraph(denseBlockedN)\n\
    for i in 0..<denseBlockedN:\n    let pi = 3 * (i mod 17)\n    for j in 0..<denseBlockedN:\n\
    \        if i != j:\n            let pj = 3 * (j mod 17)\n            let reduced\
    \ = if j == (i + 1) mod denseBlockedN: 1 else: 100\n            denseBlocked.add_edge(i,\
    \ j, reduced + pj - pi)\nlet denseBlockedWf = denseBlocked.warshall_floyd()\n\
    assert not denseBlockedWf.negative_cycle\nfor i in 0..<denseBlockedN:\n    for\
    \ j in 0..<denseBlockedN:\n        let ringDistance = (j - i + denseBlockedN)\
    \ mod denseBlockedN\n        let reduced = if i == j: 0 else: min(ringDistance,\
    \ 100)\n        let expected = reduced + 3 * (j mod 17) - 3 * (i mod 17)\n   \
    \     assert denseBlockedWf.d[i][j] == expected\n\nlet empty = initWeightedDirectedGraph(0).warshall_floyd()\n\
    assert not empty.negative_cycle\nassert empty.d.len == 0\n\n# Cross a cache-block\
    \ boundary in every phase of the blocked algorithm.\nvar blocked = initWeightedDirectedGraph(217)\n\
    for i in 0..<216:\n    blocked.add_edge(i, i + 1, 1)\nlet blockedWf = blocked.warshall_floyd()\n\
    assert not blockedWf.negative_cycle\nassert blockedWf.d[0][216] == 216\nassert\
    \ blockedWf.d[216][0] == INF64\n\n# int32 uses eight AVX2 lanes and a separately\
    \ tuned cache block.\nvar g32 = initWeightedDirectedGraph(11, int32)\ng32.add_edge(0,\
    \ 1, 300_000_000.int32)\ng32.add_edge(1, 2, 400_000_000.int32)\ng32.add_edge(2,\
    \ 10, 50_000_000.int32)\ng32.add_edge(0, 10, 900_000_000.int32)\nlet wf32 = g32.warshall_floyd()\n\
    assert not wf32.negative_cycle\nassert wf32.d[0][2] == 700_000_000.int32\nassert\
    \ wf32.d[0][10] == 750_000_000.int32\nassert wf32.d[10][0] == INF32\n\nvar parallel32\
    \ = initWeightedDirectedGraph(2, int32)\nparallel32.add_edge(0, 1, 3.int32)\n\
    parallel32.add_edge(0, 1, 7.int32)\nparallel32.add_edge(0, 0, 5.int32)\nlet parallelWf32\
    \ = parallel32.warshall_floyd()\nassert not parallelWf32.negative_cycle\nassert\
    \ parallelWf32.d[0][0] == 0.int32\nassert parallelWf32.d[0][1] == 3.int32\n\n\
    let empty32 = initWeightedDirectedGraph(0, int32).warshall_floyd()\nassert not\
    \ empty32.negative_cycle\nassert empty32.d.len == 0\n\nvar blocked32 = initWeightedDirectedGraph(257,\
    \ int32)\nfor i in 0..<256:\n    blocked32.add_edge(i, i + 1, 1.int32)\nlet blockedWf32\
    \ = blocked32.warshall_floyd()\nassert not blockedWf32.negative_cycle\nassert\
    \ blockedWf32.d[0][256] == 256.int32\nassert blockedWf32.d[256][0] == INF32\n\n\
    var static32 = initWeightedDirectedStaticGraph(4, int32)\nstatic32.add_edge(0,\
    \ 1, 2.int32)\nstatic32.add_edge(1, 2, 3.int32)\nstatic32.add_edge(2, 3, 4.int32)\n\
    static32.add_edge(0, 3, 20.int32)\nstatic32.build()\nlet staticWf32 = static32.warshall_floyd()\n\
    assert not staticWf32.negative_cycle\nassert staticWf32.d[0][3] == 9.int32\n\n\
    var ng = initWeightedDirectedGraph(2)\nng.add_edge(0, 1, -2)\nng.add_edge(1, 0,\
    \ -2)\nassert ng.warshall_floyd().negative_cycle\n"
  dependsOn:
  - cplib/graph/warshall_floyd_avx.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/warshall_floyd_avx.nim
  isVerificationFile: true
  path: verify/AI/warshall_floyd_avx_test.nim
  requiredBy: []
  timestamp: '2026-09-03 23:28:44+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/warshall_floyd_avx_test.nim
layout: document
redirect_from:
- /verify/verify/AI/warshall_floyd_avx_test.nim
- /verify/verify/AI/warshall_floyd_avx_test.nim.html
title: verify/AI/warshall_floyd_avx_test.nim
---
