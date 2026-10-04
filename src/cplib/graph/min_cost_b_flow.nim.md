---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/min_cost_b_flow_test.nim
    title: verify/AI/min_cost_b_flow_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/min_cost_b_flow_test.nim
    title: verify/AI/min_cost_b_flow_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/min_cost_b_flow_test.nim
    title: verify/graph/min_cost_b_flow_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/min_cost_b_flow_test.nim
    title: verify/graph/min_cost_b_flow_test.nim
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
  code: "when not declared CPLIB_GRAPH_MIN_COST_B_FLOW:\n    const CPLIB_GRAPH_MIN_COST_B_FLOW*\
    \ = 1\n    import heapqueue\n    import cplib/math/int128\n\n    type\n      \
    \  MinCostBFlowEdge* = object\n            src*, dst*: int\n            lower*,\
    \ upper*, cost*, flow*: int64\n        MinCostBFlowResult* = object\n        \
    \    feasible*: bool\n            cost*: Int128\n        MinCostBFlow* = object\n\
    \            supply: seq[Int128]\n            edges: seq[MinCostBFlowEdge]\n \
    \           potential: seq[Int128]\n            solved: bool\n        BFlowArc\
    \ = object\n            dst: int\n            cap, cost: Int128\n\n    proc initMinCostBFlow*(n:\
    \ int): MinCostBFlow =\n        ## n\u9802\u70B9\u306E\u6700\u5C0F\u8CBB\u7528\
    b-flow\u3092\u69CB\u7BC9\u3059\u308B\u3002b > 0\u306F\u4F9B\u7D66\uFF08\u6D41\u51FA\
    \u2212\u6D41\u5165=b\uFF09\u3002O(n)\u3002\n        ## \u5165\u529B\u30FB\u5143\
    \u8FBA\u6D41\u91CF\u306Fint64\uFF08-2^63..2^63-1\uFF09\u3001\u4E2D\u9593\u5024\
    \u30FB\u7DCF\u8CBB\u7528\u30FBpotential\u306FInt128\uFF08-2^127..2^127-1\uFF09\
    \u3002\n        ## C++ backend\u3001__int128\u5BFE\u5FDC\u306EGCC/Clang\u3068\
    libstdc++\u304C\u5FC5\u8981\u3002\u8868\u793A\u30FB\u6F14\u7B97\u306B\u306Fcplib/math/int128\u3082\
    import\u3059\u308B\u3002\n        assert n >= 0, \"n\u306F\u975E\u8CA0\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        result.supply = newSeq[Int128](n)\n\
    \n    proc add_supply*(g: var MinCostBFlow, v: int, amount: int64) =\n       \
    \ ## \u9802\u70B9v\u306E\u4F9B\u7D66\u306Bamount\u3092\u52A0\u7B97\u3059\u308B\
    \u3002\u8CA0\u5024\u306F\u9700\u8981\u3002\u89E3\u3092\u7121\u52B9\u5316\u3059\
    \u308B\u3002O(1)\u3002\n        assert v in 0..<g.supply.len, \"\u9802\u70B9\u756A\
    \u53F7\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        g.supply[v] += to_Int128(amount)\n\
    \        g.solved = false\n\n    proc add_edge*(g: var MinCostBFlow, src, dst:\
    \ int, lower, upper, cost: int64): int {.discardable.} =\n        ## \u4E0A\u4E0B\
    \u9650\u3068\u5358\u4F4D\u8CBB\u7528\u3092\u6301\u3064\u8FBA\u3092\u8FFD\u52A0\
    \u3057\u3001\u8FBA\u756A\u53F7\u3092\u8FD4\u3059\u3002\u8CA0\u306E\u4E0A\u4E0B\
    \u9650\u30FB\u81EA\u5DF1\u30EB\u30FC\u30D7\u3082\u8A31\u3059\u3002\u511F\u5374\
    O(1)\u3002\n        assert src in 0..<g.supply.len and dst in 0..<g.supply.len,\
    \ \"\u9802\u70B9\u756A\u53F7\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        assert\
    \ lower <= upper, \"lower <= upper\u304C\u5FC5\u8981\u3067\u3059\"\n        result\
    \ = g.edges.len\n        g.edges.add(MinCostBFlowEdge(src: src, dst: dst, lower:\
    \ lower, upper: upper, cost: cost))\n        g.solved = false\n\n    proc bFlowInt64(x:\
    \ Int128): int64 {.importcpp: \"((long long)(#))\", nodecl.}\n\n    proc solve*(g:\
    \ var MinCostBFlow): MinCostBFlowResult =\n        ## \u6700\u5C0F\u8CBB\u7528\
    b-flow\u3092\u6BCE\u56DE\u6700\u521D\u304B\u3089\u6C42\u3081\u308B\u3002\u5B9F\
    \u884C\u4E0D\u80FD\u306A\u3089feasible=false\uFF08cost=0\uFF09\u3002\n       \
    \ ## \u5BB9\u91CF\u30B9\u30B1\u30FC\u30EA\u30F3\u30B0\u3002O((N+M)^2 log(N+M+2)\
    \ log(U+2) + NM)\u3001\u7A7A\u9593O(N+M)\u3002\n        ## U\u306F1\u3001\u4E0A\
    \u4E0B\u9650\u306E\u5DEE\u3001\u4E0B\u9650\u3092\u6D41\u3057\u305F\u5F8C\u306E\
    \u5404\u9802\u70B9\u53CE\u652F\u306E\u7D76\u5BFE\u5024\u306E\u6700\u5927\u5024\
    \u3002\n        ## \u5168\u3066\u306E\u53CE\u652F\u30FB\u6B8B\u4F59\u5BB9\u91CF\
    \u30FB\u8DDD\u96E2\u30FBpotential\u30FB\u8CBB\u7528\u306E\u4E2D\u9593\u5024\u306F\
    \u7B26\u53F7\u3064\u304D128\u30D3\u30C3\u30C8\u306B\u53CE\u307E\u308B\u3053\u3068\
    \u3002\n        g.solved = false\n        let n = g.supply.len\n        var balance\
    \ = newSeq[Int128](n)\n        var total: Int128 = 0\n        for v in 0..<n:\n\
    \            balance[v] = g.supply[v]\n            total += balance[v]\n     \
    \   if total != 0:\n            return\n        var graph = newSeq[seq[int]](n)\n\
    \        var arcs: seq[BFlowArc]\n        var bound: Int128 = 1\n        for e\
    \ in g.edges:\n            let width = to_Int128(e.upper) - to_Int128(e.lower)\n\
    \            let cost = to_Int128(e.cost)\n            graph[e.src].add(arcs.len)\n\
    \            arcs.add(BFlowArc(dst: e.dst, cap: width, cost: cost))\n        \
    \    graph[e.dst].add(arcs.len)\n            arcs.add(BFlowArc(dst: e.src, cap:\
    \ 0, cost: -cost))\n            if e.src != e.dst:\n                balance[e.src]\
    \ -= to_Int128(e.lower)\n                balance[e.dst] += to_Int128(e.lower)\n\
    \            bound = max(bound, width)\n        for b in balance:\n          \
    \  bound = max(bound, abs(b))\n        var delta: Int128 = 1\n        while delta\
    \ <= bound div 2:\n            delta *= 2\n        var potential = newSeq[Int128](n)\n\
    \        var distance = newSeq[Int128](n)\n        var reached = newSeq[bool](n)\n\
    \        var parent = newSeq[int](n)\n        while delta > 0:\n            #\
    \ delta\u4EE5\u4E0A\u306E\u6B8B\u4F59\u8FBA\u306E\u88AB\u7D04\u8CBB\u7528\u3092\
    \u975E\u8CA0\u306B\u3059\u308B\u3002\n            for u in 0..<n:\n          \
    \      for i in graph[u]:\n                    let v = arcs[i].dst\n         \
    \           if arcs[i].cost + potential[u] - potential[v] < 0:\n             \
    \           let amount = arcs[i].cap - arcs[i].cap mod delta\n               \
    \         arcs[i].cap -= amount\n                        arcs[i xor 1].cap +=\
    \ amount\n                        if u != v:\n                            balance[u]\
    \ -= amount\n                            balance[v] += amount\n            while\
    \ true:\n                var queue = initHeapQueue[(Int128, int)]()\n        \
    \        for v in 0..<n:\n                    reached[v] = balance[v] >= delta\n\
    \                    parent[v] = -1\n                    if reached[v]:\n    \
    \                    distance[v] = 0\n                        queue.push((to_Int128(0),\
    \ v))\n                var target = -1\n                while queue.len > 0:\n\
    \                    let (d, u) = queue.pop()\n                    if d != distance[u]:\n\
    \                        continue\n                    if balance[u] <= -delta:\n\
    \                        target = u\n                        break\n         \
    \           for i in graph[u]:\n                        if arcs[i].cap < delta:\n\
    \                            continue\n                        let v = arcs[i].dst\n\
    \                        let nd = d + arcs[i].cost + potential[u] - potential[v]\n\
    \                        if not reached[v] or nd < distance[v]:\n            \
    \                reached[v] = true\n                            distance[v] =\
    \ nd\n                            parent[v] = i\n                            queue.push((nd,\
    \ v))\n                if target < 0:\n                    break\n           \
    \     for v in 0..<n:\n                    potential[v] += (if reached[v]: min(distance[v],\
    \ distance[target]) else: distance[target])\n                var amount = -balance[target]\n\
    \                var root = target\n                while parent[root] >= 0:\n\
    \                    let i = parent[root]\n                    amount = min(amount,\
    \ arcs[i].cap)\n                    root = arcs[i xor 1].dst\n               \
    \ amount = min(amount, balance[root])\n                amount -= amount mod delta\n\
    \                var v = target\n                while v != root:\n          \
    \          let i = parent[v]\n                    arcs[i].cap -= amount\n    \
    \                arcs[i xor 1].cap += amount\n                    v = arcs[i xor\
    \ 1].dst\n                balance[root] -= amount\n                balance[target]\
    \ += amount\n            delta = delta div 2\n        for b in balance:\n    \
    \        if b != 0:\n                return\n        # \u5168\u9802\u70B9\u3092\
    \u59CB\u70B9\u306BBellman-Ford\u3092\u884C\u3044\u3001\u7D76\u5BFE\u5024\u304C\
    (N-1)*max|cost|\u4EE5\u4E0B\u306E\u53CC\u5BFE\u89E3\u3092\u8FD4\u3059\u3002\n\
    \        g.potential = newSeq[Int128](n)\n        for phase in 0..<n:\n      \
    \      var changed = false\n            for u in 0..<n:\n                for i\
    \ in graph[u]:\n                    let v = arcs[i].dst\n                    if\
    \ arcs[i].cap > 0 and g.potential[v] > g.potential[u] + arcs[i].cost:\n      \
    \                  g.potential[v] = g.potential[u] + arcs[i].cost\n          \
    \              changed = true\n            if not changed:\n                break\n\
    \        result.feasible = true\n        result.cost = 0\n        for i in 0..<g.edges.len:\n\
    \            let f = to_Int128(g.edges[i].lower) + arcs[2 * i + 1].cap\n     \
    \       g.edges[i].flow = bFlowInt64(f)\n            result.cost += f * to_Int128(g.edges[i].cost)\n\
    \        g.solved = true\n\n    proc get_edge*(g: MinCostBFlow, i: int): MinCostBFlowEdge\
    \ =\n        ## solve\u6210\u529F\u5F8C\u306Ei\u756A\u76EE\u306E\u5143\u8FBA\u3068\
    \u305D\u306E\u6D41\u91CF\u3092\u8FD4\u3059\u3002\u4F9B\u7D66\u30FB\u8FBA\u306E\
    \u8FFD\u52A0\u5F8C\u306F\u518D\u8A08\u7B97\u304C\u5FC5\u8981\u3002O(1)\u3002\n\
    \        assert g.solved, \"\u5148\u306Bsolve\u3067\u5B9F\u73FE\u53EF\u80FD\u306A\
    \u6D41\u308C\u3092\u6C42\u3081\u3066\u304F\u3060\u3055\u3044\"\n        g.edges[i]\n\
    \n    proc get_edges*(g: MinCostBFlow): seq[MinCostBFlowEdge] =\n        ## solve\u6210\
    \u529F\u5F8C\u306E\u5143\u8FBA\u3068\u6D41\u91CF\u3092\u8FFD\u52A0\u9806\u306B\
    \u8FD4\u3059\u3002O(M)\u3002\n        assert g.solved, \"\u5148\u306Bsolve\u3067\
    \u5B9F\u73FE\u53EF\u80FD\u306A\u6D41\u308C\u3092\u6C42\u3081\u3066\u304F\u3060\
    \u3055\u3044\"\n        for e in g.edges:\n            result.add(e)\n\n    proc\
    \ get_potential*(g: MinCostBFlow): seq[Int128] =\n        ## solve\u6210\u529F\
    \u5F8C\u306E\u53CC\u5BFE\u89E3p\u3092\u8FD4\u3059\u3002\u6B8B\u4F59\u8FBA\u306E\
    cost+p[src]-p[dst] >= 0\u3092\u6E80\u305F\u3059\u3002O(N)\u3002\n        assert\
    \ g.solved, \"\u5148\u306Bsolve\u3067\u5B9F\u73FE\u53EF\u80FD\u306A\u6D41\u308C\
    \u3092\u6C42\u3081\u3066\u304F\u3060\u3055\u3044\"\n        for p in g.potential:\n\
    \            result.add(p)\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  isVerificationFile: false
  path: cplib/graph/min_cost_b_flow.nim
  requiredBy: []
  timestamp: '2026-10-03 01:29:57+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/min_cost_b_flow_test.nim
  - verify/graph/min_cost_b_flow_test.nim
  - verify/AI/min_cost_b_flow_test.nim
  - verify/AI/min_cost_b_flow_test.nim
documentation_of: cplib/graph/min_cost_b_flow.nim
layout: document
redirect_from:
- /library/cplib/graph/min_cost_b_flow.nim
- /library/cplib/graph/min_cost_b_flow.nim.html
title: cplib/graph/min_cost_b_flow.nim
---
