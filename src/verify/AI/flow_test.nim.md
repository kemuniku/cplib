---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/mincostflow.nim
    title: cplib/graph/mincostflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/mincostflow.nim
    title: cplib/graph/mincostflow.nim
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
    import cplib/graph/maxflow\nimport cplib/graph/mincostflow\nimport random, tables\n\
    \nblock:\n    var g = initMaxFlow[int64](3)\n    g.add_edge(0, 0, 7)\n    g.add_edge(0,\
    \ 1, 5)\n    g.add_edge(0, 1, 2)\n    g.add_edge(1, 2, 6)\n    doAssert g.flow(0,\
    \ 2, 0) == 0\n    doAssert g.flow(0, 2, 2) == 2\n    doAssert g.flow(0, 2) ==\
    \ 4\n    doAssert g.flow(0, 2) == 0\n    doAssert g.get_edge(0).cap == 7 and g.get_edge(0).flow\
    \ == 0\n    doAssert g.min_cut(0) == @[true, true, false]\n\nblock:\n    var g\
    \ = initMinCostFlow[int32, int64](3)\n    g.add_edge(0, 0, 3, 1)\n    g.add_edge(0,\
    \ 1, 2, -3)\n    g.add_edge(1, 2, 2, 5)\n    doAssert g.flow(0, 2, 0) == (0'i32,\
    \ 0'i64)\n    doAssert g.flow(0, 2, 1) == (1'i32, 2'i64)\n    doAssert g.flow(0,\
    \ 2) == (1'i32, 2'i64)\n    doAssert g.flow(0, 2) == (0'i32, 0'i64)\n    doAssert\
    \ g.get_edge(0).flow == 0\n    doAssert g.get_edge(1).flow == 2\n\nblock:\n  \
    \  var g = initMinCostFlow[uint64, int64](2)\n    let capacity = high(uint64)\n\
    \    g.add_edge(0, 1, capacity, 0)\n    doAssert g.flow(0, 1) == (capacity, 0'i64)\n\
    \    doAssert g.get_edge(0).flow == capacity\n    doAssert g.flow(0, 1) == (0'u64,\
    \ 0'i64)\n\nblock:\n    var g = initMinCostFlow[uint64, int32](3)\n    let capacity\
    \ = uint64(high(int32)) + 1\n    g.add_edge(0, 1, capacity, -1)\n    g.add_edge(1,\
    \ 2, capacity, 1)\n    doAssert g.flow(0, 2) == (capacity, 0'i32)\n    doAssert\
    \ g.get_edge(0).flow == capacity\n    doAssert g.get_edge(1).flow == capacity\n\
    \nwhen compileOption(\"rangeChecks\"):\n    block:\n        var g = initMinCostFlow[uint64,\
    \ int64](2)\n        g.add_edge(0, 1, uint64(high(int64)) + 1, 1)\n        let\
    \ before = g.get_edges()\n        var caught = false\n        try:\n         \
    \   discard g.flow(0, 1)\n        except RangeDefect:\n            caught = true\n\
    \        doAssert caught\n        doAssert g.get_edges() == before\n        doAssert\
    \ g.flow(0, 1, 1) == (1'u64, 1'i64)\n\nwhen compileOption(\"overflowChecks\"):\n\
    \    block:\n        var g = initMinCostFlow[int64, int64](2)\n        g.add_edge(0,\
    \ 1, high(int64) div 2 + 1, 2)\n        let before = g.get_edges()\n        var\
    \ caught = false\n        try:\n            discard g.flow(0, 1)\n        except\
    \ OverflowDefect:\n            caught = true\n        doAssert caught\n      \
    \  doAssert g.get_edges() == before\n\n    block:\n        var g = initMinCostFlow[int64,\
    \ int64](2)\n        let capacity = high(int64) div 2\n        g.add_edge(0, 1,\
    \ capacity, 1)\n        g.add_edge(0, 1, capacity, 2)\n        var caught = false\n\
    \        try:\n            discard g.flow(0, 1)\n        except OverflowDefect:\n\
    \            caught = true\n        doAssert caught\n        doAssert g.get_edge(0).flow\
    \ == capacity\n        doAssert g.get_edge(1).flow == 0\n\nblock:\n    var g =\
    \ initMinCostFlow[int, int](2)\n    g.add_edge(0, 0, 1, -1)\n    var caught =\
    \ false\n    try:\n        discard g.flow(0, 1)\n    except ValueError:\n    \
    \    caught = true\n    doAssert caught\n\nblock:\n    var g = initMaxFlow[int](100000)\n\
    \    for i in 0..<99999:\n        g.add_edge(i, i + 1, 1)\n    doAssert g.flow(0,\
    \ 99999) == 1\n\nblock:\n    var g = initMaxFlow(2)\n    doAssert g is MaxFlow[int]\n\
    \    g.add_edge(0, 1, 3)\n    doAssert g.flow(0, 1) == 3\n    var h = initMinCostFlow(2)\n\
    \    doAssert h is MinCostFlow[int, int]\n    h.add_edge(0, 1, 3, 2)\n    doAssert\
    \ h.flow(0, 1) == (3, 6)\n\nvar rng = initRand(712367)\nfor trial in 0..<400:\n\
    \    let n = rng.rand(2..5)\n    var es: seq[tuple[src, dst, cap, cost: int]]\n\
    \    var mf = initMaxFlow[int](n)\n    var mcf = initMinCostFlow[int, int](n)\n\
    \    var repeated = initMinCostFlow[int, int](n)\n    for i in 0..<7:\n      \
    \  var src = rng.rand(n - 1)\n        var dst = rng.rand(n - 1)\n        var cost\
    \ = rng.rand(0..5)\n        if trial mod 2 == 0:\n            if src == dst:\n\
    \                continue\n            if src > dst:\n                swap(src,\
    \ dst)\n            cost -= 3\n        let cap = rng.rand(0..2)\n        es.add((src,\
    \ dst, cap, cost))\n        mf.add_edge(src, dst, cap)\n        mcf.add_edge(src,\
    \ dst, cap, cost)\n        repeated.add_edge(src, dst, cap, cost)\n    var best\
    \ = initTable[int, int]()\n    var balance = newSeq[int](n)\n    proc enumerate(i,\
    \ cost: int) =\n        if i == es.len:\n            for v in 1..<n - 1:\n   \
    \             if balance[v] != 0:\n                    return\n            if\
    \ balance[0] > 0 or balance[n - 1] != -balance[0]:\n                return\n \
    \           let f = -balance[0]\n            if f notin best or cost < best[f]:\n\
    \                best[f] = cost\n            return\n        let e = es[i]\n \
    \       for f in 0..e.cap:\n            balance[e.src] -= f\n            balance[e.dst]\
    \ += f\n            enumerate(i + 1, cost + f * e.cost)\n            balance[e.src]\
    \ += f\n            balance[e.dst] -= f\n    enumerate(0, 0)\n    var maximum\
    \ = 0\n    for f in best.keys:\n        maximum = max(maximum, f)\n    doAssert\
    \ mf.flow(0, n - 1) == maximum\n    let cut = mf.min_cut(0)\n    var cutCap =\
    \ 0\n    for e in es:\n        if cut[e.src] and not cut[e.dst]:\n           \
    \ cutCap += e.cap\n    doAssert cutCap == maximum\n    let points = mcf.slope(0,\
    \ n - 1)\n    doAssert points[0] == (0, 0)\n    doAssert points[^1] == (maximum,\
    \ best[maximum])\n    for i in 1..<points.len:\n        let a = points[i - 1]\n\
    \        let b = points[i]\n        let unit = (b.cost - a.cost) div (b.flow -\
    \ a.flow)\n        for f in a.flow..b.flow:\n            doAssert best[f] == a.cost\
    \ + (f - a.flow) * unit\n        if i > 1:\n            let p = points[i - 2]\n\
    \            doAssert unit > (a.cost - p.cost) div (a.flow - p.flow)\n    var\
    \ total = 0\n    for f in 1..maximum:\n        let answer = repeated.flow(0, n\
    \ - 1, 1)\n        doAssert answer.flow == 1\n        total += answer.cost\n \
    \       doAssert total == best[f]\n    doAssert repeated.flow(0, n - 1) == (0,\
    \ 0)\n    var actualCost = 0\n    for e in mcf.get_edges:\n        doAssert e.flow\
    \ >= 0 and e.flow <= e.cap\n        actualCost += e.flow * e.cost\n    doAssert\
    \ actualCost == best[maximum]\nblock:\n    var rng = initRand(901237)\n    for\
    \ trial in 0..<500:\n        let n = rng.rand(2..8)\n        var g = initMaxFlow[int64](n)\n\
    \        for i in 0..<rng.rand(0..40):\n            g.add_edge(rng.rand(n - 1),\
    \ rng.rand(n - 1), int64(rng.rand(0..100)))\n        let original = g.get_edges\n\
    \        var minimum = high(int64)\n        for mask in 0..<(1 shl n):\n     \
    \       if (mask and 1) == 0 or (mask and (1 shl (n - 1))) != 0:\n           \
    \     continue\n            var capacity = 0'i64\n            for e in original:\n\
    \                if (mask and (1 shl e.src)) != 0 and (mask and (1 shl e.dst))\
    \ == 0:\n                    capacity += e.cap\n            minimum = min(minimum,\
    \ capacity)\n        var total = 0'i64\n        while true:\n            let limit\
    \ = int64(rng.rand(1..50))\n            let added = g.flow(0, n - 1, limit)\n\
    \            doAssert added >= 0 and added <= limit\n            total += added\n\
    \            var balance = newSeq[int64](n)\n            for i, e in g.get_edges:\n\
    \                doAssert e.cap == original[i].cap\n                doAssert e.src\
    \ == original[i].src and e.dst == original[i].dst\n                doAssert e.flow\
    \ >= 0 and e.flow <= e.cap\n                balance[e.src] -= e.flow\n       \
    \         balance[e.dst] += e.flow\n            doAssert balance[0] == -total\
    \ and balance[n - 1] == total\n            for v in 1..<n - 1:\n             \
    \   doAssert balance[v] == 0\n            if added < limit:\n                break\n\
    \        doAssert total == minimum\n        let cut = g.min_cut(0)\n        var\
    \ capacity = 0'i64\n        for e in original:\n            if cut[e.src] and\
    \ not cut[e.dst]:\n                capacity += e.cap\n        doAssert capacity\
    \ == minimum\n        g.add_edge(0, n - 1, 123)\n        doAssert g.flow(0, n\
    \ - 1) == 123\n\nblock:\n    var g = initMaxFlow[uint64](4)\n    let capacity\
    \ = high(uint64)\n    g.add_edge(0, 1, capacity)\n    g.add_edge(1, 2, capacity)\n\
    \    g.add_edge(2, 3, capacity)\n    doAssert g.flow(0, 3, capacity - 1) == capacity\
    \ - 1\n    doAssert g.flow(0, 3) == 1\n\nblock:\n    var g = initMaxFlow[int](5)\n\
    \    g.add_edge(0, 1, 2)\n    g.add_edge(0, 2, 3)\n    g.add_edge(1, 3, 2)\n \
    \   g.add_edge(2, 3, 3)\n    g.add_edge(3, 4, 5)\n    doAssert g.flow(0, 4, 4)\
    \ == 4\n    doAssert g.flow(0, 4) == 1\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/maxflow.nim
  - cplib/graph/mincostflow.nim
  - cplib/graph/maxflow.nim
  - cplib/graph/mincostflow.nim
  isVerificationFile: true
  path: verify/AI/flow_test.nim
  requiredBy: []
  timestamp: '2026-09-12 08:53:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/flow_test.nim
layout: document
redirect_from:
- /verify/verify/AI/flow_test.nim
- /verify/verify/AI/flow_test.nim.html
title: verify/AI/flow_test.nim
---
