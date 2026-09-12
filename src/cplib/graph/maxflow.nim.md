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
    path: verify/graph/maxflow_bipartitematching_test.nim
    title: verify/graph/maxflow_bipartitematching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/maxflow_bipartitematching_test.nim
    title: verify/graph/maxflow_bipartitematching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/maxflow_test.nim
    title: verify/graph/maxflow_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/maxflow_test.nim
    title: verify/graph/maxflow_test.nim
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
  code: "when not declared CPLIB_GRAPH_MAXFLOW:\n    const CPLIB_GRAPH_MAXFLOW* =\
    \ 1\n\n    type\n        MaxFlowEdge*[Cap] = object\n            src*, dst*: int\n\
    \            cap*, flow*: Cap\n        MaxFlowArc[Cap] = object\n            dst,\
    \ rev: int\n            cap: Cap\n        MaxFlow*[Cap] = object\n           \
    \ graph: seq[seq[MaxFlowArc[Cap]]]\n            positions: seq[tuple[src, index:\
    \ int]]\n\n    proc initMaxFlow*[Cap: SomeInteger](n: int, capacityZero: Cap =\
    \ 0): MaxFlow[Cap] =\n        ## n\u9802\u70B9\u306E\u6700\u5927\u6D41\u30B0\u30E9\
    \u30D5\u3092\u69CB\u7BC9\u3059\u308B\u3002\u5BB9\u91CF\u578B\u306E\u7701\u7565\
    \u6642\u306Fint\u3002capacityZero\u306F\u578B\u63A8\u8AD6\u7528\u3002O(n)\u3002\
    \n        assert n >= 0\n        result.graph = newSeq[seq[MaxFlowArc[Cap]]](n)\n\
    \n    proc add_edge*[Cap](g: var MaxFlow[Cap], src, dst: int, cap: Cap): int {.discardable.}\
    \ =\n        ## \u5BB9\u91CFcap\u306E\u6709\u5411\u8FBA\u3092\u8FFD\u52A0\u3057\
    \u3001\u8FBA\u756A\u53F7\u3092\u8FD4\u3059\u3002\u511F\u5374O(1)\u3002\n     \
    \   assert src in 0..<g.graph.len and dst in 0..<g.graph.len\n        assert cap\
    \ >= Cap(0)\n        result = g.positions.len\n        let index = g.graph[src].len\n\
    \        let rev = g.graph[dst].len + ord(src == dst)\n        g.positions.add((src,\
    \ index))\n        g.graph[src].add(MaxFlowArc[Cap](dst: dst, rev: rev, cap: cap))\n\
    \        g.graph[dst].add(MaxFlowArc[Cap](dst: src, rev: index, cap: Cap(0)))\n\
    \n    proc get_edge*[Cap](g: MaxFlow[Cap], i: int): MaxFlowEdge[Cap] =\n     \
    \   ## i\u756A\u76EE\u306E\u8FBA\u306E\u5BB9\u91CF\u3068\u73FE\u5728\u306E\u6D41\
    \u91CF\u3092\u8FD4\u3059\u3002O(1)\u3002\n        let (src, index) = g.positions[i]\n\
    \        let e = g.graph[src][index]\n        let flow = g.graph[e.dst][e.rev].cap\n\
    \        MaxFlowEdge[Cap](src: src, dst: e.dst, cap: e.cap + flow, flow: flow)\n\
    \n    proc get_edges*[Cap](g: MaxFlow[Cap]): seq[MaxFlowEdge[Cap]] =\n       \
    \ ## \u8FFD\u52A0\u9806\u306B\u5168\u8FBA\u306E\u60C5\u5831\u3092\u8FD4\u3059\u3002\
    O(E)\u3002\n        for i in 0..<g.positions.len:\n            result.add(g.get_edge(i))\n\
    \n    proc flow*[Cap](g: var MaxFlow[Cap], src, dst: int, limit: Cap = high(Cap)):\
    \ Cap =\n        ## Dinic\u6CD5\u3067limit\u4EE5\u4E0B\u306E\u6D41\u91CF\u3092\
    \u8FFD\u52A0\u3057\u3001\u8FFD\u52A0\u6D41\u91CF\u3092\u8FD4\u3059\u3002O(V^2\
    \ E)\u3002\n        assert src in 0..<g.graph.len and dst in 0..<g.graph.len and\
    \ src != dst\n        assert limit >= Cap(0)\n        let n = g.graph.len\n  \
    \      var level = newSeq[int](n)\n        var iter = newSeq[int](n)\n       \
    \ var queue = newSeq[int](n)\n        var requested = newSeq[Cap](n)\n       \
    \ var sent = newSeq[Cap](n)\n        while result < limit:\n            for i\
    \ in 0..<n:\n                level[i] = -1\n                iter[i] = 0\n    \
    \        level[src] = 0\n            queue[0] = src\n            var head = 0\n\
    \            var tail = 1\n            block bfs:\n                while head\
    \ < tail:\n                    let v = queue[head]\n                    inc head\n\
    \                    for e in g.graph[v]:\n                        if e.cap >\
    \ Cap(0) and level[e.dst] < 0:\n                            level[e.dst] = level[v]\
    \ + 1\n                            if e.dst == dst:\n                        \
    \        break bfs\n                            queue[tail] = e.dst\n        \
    \                    inc tail\n            if level[dst] < 0:\n              \
    \  break\n            # \u7D42\u70B9\u304B\u3089\u9006\u5411\u304D\u306B\u63A2\
    \u7D22\u3057\u3001\u5404\u9802\u70B9\u3067\u9001\u308C\u305F\u6D41\u91CF\u3092\
    \u307E\u3068\u3081\u3066\u89AA\u3078\u8FD4\u3059\u3002\n            var depth\
    \ = 0\n            queue[0] = dst\n            requested[0] = limit - result\n\
    \            sent[0] = Cap(0)\n            while depth >= 0:\n               \
    \ let v = queue[depth]\n                if v == src:\n                    sent[depth]\
    \ = requested[depth]\n                else:\n                    while iter[v]\
    \ < g.graph[v].len and sent[depth] < requested[depth]:\n                     \
    \   let e = g.graph[v][iter[v]]\n                        if level[e.dst] >= 0\
    \ and level[e.dst] < level[v] and g.graph[e.dst][e.rev].cap > Cap(0):\n      \
    \                      break\n                        inc iter[v]\n          \
    \          if sent[depth] < requested[depth] and iter[v] < g.graph[v].len:\n \
    \                       let e = g.graph[v][iter[v]]\n                        requested[depth\
    \ + 1] = min(requested[depth] - sent[depth], g.graph[e.dst][e.rev].cap)\n    \
    \                    sent[depth + 1] = Cap(0)\n                        queue[depth\
    \ + 1] = e.dst\n                        inc depth\n                        continue\n\
    \                    if sent[depth] < requested[depth]:\n                    \
    \    level[v] = n\n                let pushed = sent[depth]\n                dec\
    \ depth\n                if depth < 0:\n                    result += pushed\n\
    \                    break\n                let parent = queue[depth]\n      \
    \          let i = iter[parent]\n                let rev = g.graph[parent][i].rev\n\
    \                g.graph[parent][i].cap += pushed\n                g.graph[v][rev].cap\
    \ -= pushed\n                sent[depth] += pushed\n                if sent[depth]\
    \ < requested[depth]:\n                    inc iter[parent]\n\n    proc min_cut*[Cap](g:\
    \ MaxFlow[Cap], src: int): seq[bool] =\n        ## \u6B8B\u4F59\u30B0\u30E9\u30D5\
    \u3067src\u304B\u3089\u5230\u9054\u53EF\u80FD\u306A\u9802\u70B9\u3092\u8FD4\u3059\
    \u3002\u6700\u5927\u6D41\u8A08\u7B97\u5F8C\u306F\u6700\u5C0F\u30AB\u30C3\u30C8\
    \u3002O(V+E)\u3002\n        assert src in 0..<g.graph.len\n        result = newSeq[bool](g.graph.len)\n\
    \        result[src] = true\n        var queue = @[src]\n        var head = 0\n\
    \        while head < queue.len:\n            let v = queue[head]\n          \
    \  inc head\n            for e in g.graph[v]:\n                if e.cap > Cap(0)\
    \ and not result[e.dst]:\n                    result[e.dst] = true\n         \
    \           queue.add(e.dst)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/graph/maxflow.nim
  requiredBy: []
  timestamp: '2026-09-12 08:37:53+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/maxflow_bipartitematching_test.nim
  - verify/graph/maxflow_bipartitematching_test.nim
  - verify/graph/maxflow_test.nim
  - verify/graph/maxflow_test.nim
  - verify/AI/flow_test.nim
  - verify/AI/flow_test.nim
documentation_of: cplib/graph/maxflow.nim
layout: document
redirect_from:
- /library/cplib/graph/maxflow.nim
- /library/cplib/graph/maxflow.nim.html
title: cplib/graph/maxflow.nim
---
