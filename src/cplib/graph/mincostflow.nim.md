---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/flow_test.nim
    title: verify/AI/flow_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/flow_test.nim
    title: verify/AI/flow_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/mincostflow_test.nim
    title: verify/graph/mincostflow_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/mincostflow_test.nim
    title: verify/graph/mincostflow_test.nim
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
  code: "when not declared CPLIB_GRAPH_MINCOSTFLOW:\n    const CPLIB_GRAPH_MINCOSTFLOW*\
    \ = 1\n    import heapqueue\n\n    type\n        MinCostFlowEdge*[Cap, Cost] =\
    \ object\n            src*, dst*: int\n            cap*, flow*: Cap\n        \
    \    cost*: Cost\n        MinCostFlowArc[Cap, Cost] = object\n            dst,\
    \ rev: int\n            cap: Cap\n            cost: Cost\n        MinCostFlow*[Cap,\
    \ Cost] = object\n            graph: seq[seq[MinCostFlowArc[Cap, Cost]]]\n   \
    \         positions: seq[tuple[src, index: int]]\n\n    proc initMinCostFlow*[Cap:\
    \ SomeInteger, Cost: SomeSignedInt](n: int, capacityZero: Cap = 0, costZero: Cost\
    \ = 0): MinCostFlow[Cap, Cost] =\n        ## n\u9802\u70B9\u306E\u6700\u5C0F\u8CBB\
    \u7528\u6D41\u30B0\u30E9\u30D5\u3092\u69CB\u7BC9\u3059\u308B\u3002\u5BB9\u91CF\
    \u30FB\u8CBB\u7528\u578B\u306E\u7701\u7565\u6642\u306Fint\u3002O(n)\u3002\n  \
    \      ## capacityZero\u3068costZero\u306F\u578B\u63A8\u8AD6\u7528\u3002\n   \
    \     assert n >= 0\n        result.graph = newSeq[seq[MinCostFlowArc[Cap, Cost]]](n)\n\
    \n    proc add_edge*[Cap, Cost](g: var MinCostFlow[Cap, Cost], src, dst: int,\
    \ cap: Cap, cost: Cost): int {.discardable.} =\n        ## \u5BB9\u91CFcap\u3001\
    \u5358\u4F4D\u8CBB\u7528cost\u306E\u6709\u5411\u8FBA\u3092\u8FFD\u52A0\u3057\u3001\
    \u8FBA\u756A\u53F7\u3092\u8FD4\u3059\u3002\u511F\u5374O(1)\u3002\n        assert\
    \ src in 0..<g.graph.len and dst in 0..<g.graph.len\n        assert cap >= Cap(0)\
    \ and cost != low(Cost)\n        result = g.positions.len\n        let index =\
    \ g.graph[src].len\n        let rev = g.graph[dst].len + ord(src == dst)\n   \
    \     g.positions.add((src, index))\n        g.graph[src].add(MinCostFlowArc[Cap,\
    \ Cost](dst: dst, rev: rev, cap: cap, cost: cost))\n        g.graph[dst].add(MinCostFlowArc[Cap,\
    \ Cost](dst: src, rev: index, cap: Cap(0), cost: -cost))\n\n    proc get_edge*[Cap,\
    \ Cost](g: MinCostFlow[Cap, Cost], i: int): MinCostFlowEdge[Cap, Cost] =\n   \
    \     ## i\u756A\u76EE\u306E\u8FBA\u306E\u5BB9\u91CF\u3001\u73FE\u5728\u306E\u6D41\
    \u91CF\u3001\u5358\u4F4D\u8CBB\u7528\u3092\u8FD4\u3059\u3002O(1)\u3002\n     \
    \   let (src, index) = g.positions[i]\n        let e = g.graph[src][index]\n \
    \       let flow = g.graph[e.dst][e.rev].cap\n        MinCostFlowEdge[Cap, Cost](src:\
    \ src, dst: e.dst, cap: e.cap + flow, flow: flow, cost: e.cost)\n\n    proc get_edges*[Cap,\
    \ Cost](g: MinCostFlow[Cap, Cost]): seq[MinCostFlowEdge[Cap, Cost]] =\n      \
    \  ## \u8FFD\u52A0\u9806\u306B\u5168\u8FBA\u306E\u60C5\u5831\u3092\u8FD4\u3059\
    \u3002O(E)\u3002\n        for i in 0..<g.positions.len:\n            result.add(g.get_edge(i))\n\
    \n    proc slope*[Cap, Cost](g: var MinCostFlow[Cap, Cost], src, dst: int, limit:\
    \ Cap = high(Cap)): seq[tuple[flow: Cap, cost: Cost]] =\n        ## \u8FFD\u52A0\
    \u6D41\u91CF\u3068\u6700\u5C0F\u8CBB\u7528\u306E\u6298\u308C\u70B9\u3092\u8FD4\
    \u3059\u3002\u540C\u3058\u50BE\u304D\u306F\u307E\u3068\u3081\u308B\u3002O(VE +\
    \ A E log V)\u3001A\u306F\u5897\u52A0\u56DE\u6570\u3002\n        ## \u8CA0\u8CBB\
    \u7528\u8FBA\u306B\u5BFE\u5FDC\u3059\u308B\u304C\u3001\u59CB\u70B9\u304B\u3089\
    \u5230\u9054\u53EF\u80FD\u306A\u8CA0\u9589\u8DEF\u306FValueError\u3002\u8CBB\u7528\
    \u306E\u4E2D\u9593\u5024\u306FCost\u306B\u53CE\u307E\u308B\u3053\u3068\u3002\n\
    \        assert src in 0..<g.graph.len and dst in 0..<g.graph.len and src != dst\n\
    \        assert limit >= Cap(0)\n        result = @[(Cap(0), Cost(0))]\n     \
    \   if limit == Cap(0):\n            return\n        let n = g.graph.len\n   \
    \     var potential = newSeq[Cost](n)\n        var reached = newSeq[bool](n)\n\
    \        reached[src] = true\n        for phase in 0..<n:\n            var changed\
    \ = false\n            for v in 0..<n:\n                if not reached[v]:\n \
    \                   continue\n                for e in g.graph[v]:\n         \
    \           if e.cap > Cap(0) and (not reached[e.dst] or potential[e.dst] > potential[v]\
    \ + e.cost):\n                        potential[e.dst] = potential[v] + e.cost\n\
    \                        reached[e.dst] = true\n                        changed\
    \ = true\n            if not changed:\n                break\n            if phase\
    \ == n - 1:\n                raise newException(ValueError, \"\u59CB\u70B9\u304B\
    \u3089\u5230\u9054\u53EF\u80FD\u306A\u8CA0\u9589\u8DEF\u304C\u3042\u308A\u307E\
    \u3059\")\n        var totalFlow = Cap(0)\n        var totalCost = Cost(0)\n \
    \       var previousCost = Cost(0)\n        var hasPrevious = false\n        var\
    \ distance = newSeq[Cost](n)\n        var prevVertex = newSeq[int](n)\n      \
    \  var prevEdge = newSeq[int](n)\n        while totalFlow < limit:\n         \
    \   for v in 0..<n:\n                reached[v] = false\n            distance[src]\
    \ = Cost(0)\n            reached[src] = true\n            var queue = initHeapQueue[(Cost,\
    \ int)]()\n            queue.push((Cost(0), src))\n            while queue.len\
    \ > 0:\n                let (d, v) = queue.pop()\n                if d != distance[v]:\n\
    \                    continue\n                for i, e in g.graph[v]:\n     \
    \               if e.cap == Cap(0):\n                        continue\n      \
    \              let nd = d + (e.cost + potential[v] - potential[e.dst])\n     \
    \               if not reached[e.dst] or nd < distance[e.dst]:\n             \
    \           reached[e.dst] = true\n                        distance[e.dst] = nd\n\
    \                        prevVertex[e.dst] = v\n                        prevEdge[e.dst]\
    \ = i\n                        queue.push((nd, e.dst))\n            if not reached[dst]:\n\
    \                break\n            for v in 0..<n:\n                if reached[v]:\n\
    \                    potential[v] += distance[v]\n            let unitCost = potential[dst]\
    \ - potential[src]\n            var pushed = limit - totalFlow\n            var\
    \ v = dst\n            while v != src:\n                let u = prevVertex[v]\n\
    \                pushed = min(pushed, g.graph[u][prevEdge[v]].cap)\n         \
    \       v = u\n            var nextCost = totalCost\n            if unitCost !=\
    \ Cost(0):\n                nextCost += Cost(pushed) * unitCost\n            v\
    \ = dst\n            while v != src:\n                let u = prevVertex[v]\n\
    \                let i = prevEdge[v]\n                let rev = g.graph[u][i].rev\n\
    \                g.graph[u][i].cap -= pushed\n                g.graph[v][rev].cap\
    \ += pushed\n                v = u\n            totalFlow += pushed\n        \
    \    totalCost = nextCost\n            if hasPrevious and previousCost == unitCost:\n\
    \                result.setLen(result.len - 1)\n            result.add((totalFlow,\
    \ totalCost))\n            previousCost = unitCost\n            hasPrevious =\
    \ true\n\n    proc flow*[Cap, Cost](g: var MinCostFlow[Cap, Cost], src, dst: int,\
    \ limit: Cap = high(Cap)): tuple[flow: Cap, cost: Cost] =\n        ## limit\u4EE5\
    \u4E0B\u306E\u6D41\u91CF\u3092\u8FFD\u52A0\u3057\u3001\u8FFD\u52A0\u6D41\u91CF\
    \u3068\u8CBB\u7528\u3092\u8FD4\u3059\u3002\u8A08\u7B97\u91CF\u3068\u5236\u7D04\
    \u306Fslope\u3068\u540C\u3058\u3002\n        g.slope(src, dst, limit)[^1]\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/graph/mincostflow.nim
  requiredBy: []
  timestamp: '2026-09-12 08:53:35+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/mincostflow_test.nim
  - verify/graph/mincostflow_test.nim
  - verify/AI/flow_test.nim
  - verify/AI/flow_test.nim
documentation_of: cplib/graph/mincostflow.nim
layout: document
redirect_from:
- /library/cplib/graph/mincostflow.nim
- /library/cplib/graph/mincostflow.nim.html
title: cplib/graph/mincostflow.nim
---
