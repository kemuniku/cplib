---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/min_cost_b_flow.nim
    title: cplib/graph/min_cost_b_flow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/min_cost_b_flow.nim
    title: cplib/graph/min_cost_b_flow.nim
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
    import cplib/graph/min_cost_b_flow\nimport cplib/math/int128\nimport random\n\n\
    proc checkCertificate(g: MinCostBFlow, supply: seq[Int128], cost: Int128) =\n\
    \    let potential = g.get_potential()\n    doAssert potential.len == supply.len\n\
    \    var balance = newSeq[Int128](supply.len)\n    var reconstructed: Int128 =\
    \ 0\n    for i, e in g.get_edges():\n        doAssert e == g.get_edge(i)\n   \
    \     doAssert e.lower <= e.flow and e.flow <= e.upper\n        balance[e.src]\
    \ += to_Int128(e.flow)\n        balance[e.dst] -= to_Int128(e.flow)\n        reconstructed\
    \ += to_Int128(e.flow) * to_Int128(e.cost)\n        let reduced = to_Int128(e.cost)\
    \ + potential[e.src] - potential[e.dst]\n        if e.flow > e.lower:\n      \
    \      doAssert reduced <= 0\n        if e.flow < e.upper:\n            doAssert\
    \ reduced >= 0\n    doAssert reconstructed == cost\n    doAssert balance == supply\n\
    \nproc check(g: var MinCostBFlow, supply: seq[Int128], expected: Int128) =\n \
    \   for repeat in 0..1:\n        let answer = g.solve()\n        doAssert answer.feasible\n\
    \        doAssert answer.cost == expected\n        checkCertificate(g, supply,\
    \ answer.cost)\n\nblock:\n    var g = initMinCostBFlow(0)\n    g.check(@[], to_Int128(0))\n\
    \    g = initMinCostBFlow(3)\n    g.check(@[to_Int128(0), to_Int128(0), to_Int128(0)],\
    \ to_Int128(0))\n    g.add_supply(0, 1)\n    doAssert not g.solve().feasible\n\
    \    g.add_supply(1, -1)\n    doAssert not g.solve().feasible\n    g.add_edge(0,\
    \ 1, 0, 1, 2)\n    g.check(@[to_Int128(1), to_Int128(-1), to_Int128(0)], to_Int128(2))\n\
    \    g.add_edge(0, 1, 0, 1, -3)\n    g.check(@[to_Int128(1), to_Int128(-1), to_Int128(0)],\
    \ to_Int128(-3))\n    g.add_supply(0, -2)\n    g.add_supply(1, 2)\n    doAssert\
    \ not g.solve().feasible\n    g.add_edge(0, 1, -2, -1, 4)\n    g.check(@[to_Int128(-1),\
    \ to_Int128(1), to_Int128(0)], to_Int128(-11))\n\nblock:\n    var g = initMinCostBFlow(4)\n\
    \    g.add_edge(0, 1, 2, 2, -5)\n    g.add_edge(1, 0, 0, 3, 1)\n    g.add_edge(2,\
    \ 3, -3, -1, 7)\n    g.add_edge(3, 2, -3, -1, -2)\n    g.add_edge(2, 2, -4, 5,\
    \ -8)\n    g.add_edge(3, 3, -2, 3, 9)\n    g.add_edge(0, 0, 1, 1, 100)\n    g.check(@[to_Int128(0),\
    \ to_Int128(0), to_Int128(0), to_Int128(0)], to_Int128(19))\n\nblock:\n    var\
    \ g = initMinCostBFlow(1)\n    for i in 0..<1000:\n        g.add_edge(0, 0, -1_000_000_000,\
    \ 1_000_000_000, -1_000_000_000)\n    g.check(@[to_Int128(0)], -to_Int128(1000)\
    \ * to_Int128(1_000_000_000) * to_Int128(1_000_000_000))\n\nblock:\n    var g\
    \ = initMinCostBFlow(1)\n    for i in 0..<100:\n        g.add_edge(0, 0, 1_000_000_000,\
    \ 1_000_000_000, 1_000_000_000)\n    for i in 0..<100:\n        g.add_edge(0,\
    \ 0, 1_000_000_000, 1_000_000_000, -1_000_000_000)\n    g.check(@[to_Int128(0)],\
    \ to_Int128(0))\n\nblock:\n    var g = initMinCostBFlow(2)\n    g.add_supply(0,\
    \ high(int64))\n    g.add_supply(0, 1)\n    g.add_supply(1, low(int64))\n    g.add_edge(1,\
    \ 0, low(int64), high(int64), low(int64))\n    let amount = to_Int128(low(int64))\n\
    \    g.check(@[-amount, amount], amount * amount)\n\nblock:\n    var g = initMinCostBFlow(1)\n\
    \    g.add_edge(0, 0, low(int64), high(int64), low(int64))\n    g.check(@[to_Int128(0)],\
    \ to_Int128(high(int64)) * to_Int128(low(int64)))\n    g = initMinCostBFlow(1)\n\
    \    g.add_edge(0, 0, low(int64), high(int64), high(int64))\n    g.check(@[to_Int128(0)],\
    \ to_Int128(low(int64)) * to_Int128(high(int64)))\n\nblock:\n    var g = initMinCostBFlow(3)\n\
    \    g.add_supply(0, 1)\n    g.add_supply(2, -1)\n    g.add_edge(0, 1, 0, 2, low(int64))\n\
    \    g.add_edge(1, 2, 0, 2, low(int64))\n    g.check(@[to_Int128(1), to_Int128(0),\
    \ to_Int128(-1)], to_Int128(2) * to_Int128(low(int64)))\n    var snapshot = g.get_edges()\n\
    \    snapshot[0].flow = 100\n    doAssert g.get_edge(0).flow == 1\n    var potentials\
    \ = g.get_potential()\n    potentials[0] = 100\n    checkCertificate(g, @[to_Int128(1),\
    \ to_Int128(0), to_Int128(-1)], to_Int128(2) * to_Int128(low(int64)))\n\nwhen\
    \ compileOption(\"assertions\"):\n    block:\n        var g = initMinCostBFlow(1)\n\
    \        discard g.solve()\n        g.add_supply(0, 1)\n        var caught = false\n\
    \        try:\n            discard g.get_potential()\n        except AssertionDefect:\n\
    \            caught = true\n        doAssert caught\n        g.add_supply(0, -1)\n\
    \        discard g.solve()\n        g.add_edge(0, 0, 0, 1, 0)\n        caught\
    \ = false\n        try:\n            discard g.get_edges()\n        except AssertionDefect:\n\
    \            caught = true\n        doAssert caught\n\ntype Edge = tuple[src,\
    \ dst, lower, upper, cost: int]\n\nproc bruteForce(supply: seq[int], edges: seq[Edge]):\
    \ tuple[feasible: bool, cost: int] =\n    var balance = newSeq[int](supply.len)\n\
    \    var best = high(int)\n    proc dfs(i, cost: int) =\n        if i == edges.len:\n\
    \            if balance == supply:\n                best = min(best, cost)\n \
    \           return\n        let e = edges[i]\n        for amount in e.lower..e.upper:\n\
    \            balance[e.src] += amount\n            balance[e.dst] -= amount\n\
    \            dfs(i + 1, cost + amount * e.cost)\n            balance[e.src] -=\
    \ amount\n            balance[e.dst] += amount\n    dfs(0, 0)\n    (best != high(int),\
    \ best)\n\nproc compare(supply: seq[int], edges: seq[Edge]) =\n    var g = initMinCostBFlow(supply.len)\n\
    \    var wideSupply: seq[Int128]\n    for v, b in supply:\n        g.add_supply(v,\
    \ int64(b))\n        wideSupply.add(to_Int128(b))\n    for i, e in edges:\n  \
    \      doAssert g.add_edge(e.src, e.dst, int64(e.lower), int64(e.upper), int64(e.cost))\
    \ == i\n    let expected = bruteForce(supply, edges)\n    let actual = g.solve()\n\
    \    doAssert actual.feasible == expected.feasible\n    if actual.feasible:\n\
    \        doAssert actual.cost == to_Int128(expected.cost)\n        checkCertificate(g,\
    \ wideSupply, actual.cost)\n        for i, e in g.get_edges():\n            doAssert\
    \ (e.src, e.dst, int(e.lower), int(e.upper), int(e.cost)) == edges[i]\n    else:\n\
    \        doAssert actual.cost == 0\n    let again = g.solve()\n    doAssert again.feasible\
    \ == actual.feasible and again.cost == actual.cost\n\nfor src in 0..1:\n    for\
    \ dst in 0..1:\n        for lower in -1..1:\n            for upper in lower..1:\n\
    \                for cost in -1..1:\n                    for b0 in -2..2:\n  \
    \                      for b1 in -2..2:\n                            compare(@[b0,\
    \ b1], @[(src, dst, lower, upper, cost)])\n\nvar rng = initRand(20261003)\nfor\
    \ trial in 0..<5000:\n    let n = rng.rand(1..5)\n    var supply = newSeq[int](n)\n\
    \    var edges: seq[Edge]\n    for i in 0..<rng.rand(0..7):\n        let src =\
    \ rng.rand(0..<n)\n        let dst = rng.rand(0..<n)\n        let lower = rng.rand(-3..3)\n\
    \        let upper = lower + rng.rand(0..3)\n        let cost = rng.rand(-5..5)\n\
    \        edges.add((src, dst, lower, upper, cost))\n        let f = rng.rand(lower..upper)\n\
    \        supply[src] += f\n        supply[dst] -= f\n    if trial mod 3 == 0:\n\
    \        for b in supply.mitems:\n            b = rng.rand(-3..3)\n    elif trial\
    \ mod 3 == 1:\n        supply[rng.rand(0..<n)] += 1\n        supply[rng.rand(0..<n)]\
    \ -= 1\n    compare(supply, edges)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  - cplib/graph/min_cost_b_flow.nim
  - cplib/graph/min_cost_b_flow.nim
  isVerificationFile: true
  path: verify/AI/min_cost_b_flow_test.nim
  requiredBy: []
  timestamp: '2026-10-03 01:29:57+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/min_cost_b_flow_test.nim
layout: document
redirect_from:
- /verify/verify/AI/min_cost_b_flow_test.nim
- /verify/verify/AI/min_cost_b_flow_test.nim.html
title: verify/AI/min_cost_b_flow_test.nim
---
