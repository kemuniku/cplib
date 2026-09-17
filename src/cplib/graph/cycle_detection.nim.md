---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/cycle_detection_test.nim
    title: verify/AI/cycle_detection_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/cycle_detection_test.nim
    title: verify/AI/cycle_detection_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/cycle_detection_test.nim
    title: verify/graph/cycle_detection_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/cycle_detection_test.nim
    title: verify/graph/cycle_detection_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/cycle_detection_undirected_test.nim
    title: verify/graph/cycle_detection_undirected_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/cycle_detection_undirected_test.nim
    title: verify/graph/cycle_detection_undirected_test.nim
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
  code: "when not declared CPLIB_GRAPH_CYCLE_DETECTION:\n    const CPLIB_GRAPH_CYCLE_DETECTION*\
    \ = 1\n    import cplib/graph/graph\n    import sequtils\n\n    proc restore_cycle_vertices*(g:\
    \ DirectedGraph or UnDirectedGraph, edges: openArray[int]): seq[int] =\n     \
    \   ## \u901A\u904E\u9806\u306E\u9589\u8DEF\u306E\u8FBA\u756A\u53F7\u5217\u304B\
    \u3089\u9802\u70B9\u5217\u3092\u5FA9\u5143\u3059\u308B\u3002O(L) \u6642\u9593\u30FB\
    \u9818\u57DF\u3002\u7A7A\u5217\u306B\u306F\u7A7A\u5217\u3092\u8FD4\u3059\u3002\
    \n        ## \u5165\u529B\u306F cycle_detection \u306E\u7D50\u679C\u3068\u540C\
    \u69D8\u306B\u9802\u70B9\u30FB\u8FBA\u304C\u91CD\u8907\u3057\u306A\u3044\u9589\
    \u8DEF\u3068\u3059\u308B\u3002\n        ## edges[i] \u306F\u7D50\u679C\u306E i\
    \ \u756A\u76EE\u304B\u3089 (i+1) mod L \u756A\u76EE\u3078\u306E\u8FBA\u3002\u672B\
    \u5C3E\u306B\u59CB\u70B9\u3092\u91CD\u8907\u3055\u305B\u306A\u3044\u3002\n   \
    \     if edges.len == 0: return\n        let first = g.get_edge(edges[0])\n  \
    \      var v = first.src\n        when g is UnDirectedGraph:\n            if edges.len\
    \ > 1:\n                let second = g.get_edge(edges[1])\n                if\
    \ first.dst != second.src and first.dst != second.dst:\n                    v\
    \ = first.dst\n        result = newSeqOfCap[int](edges.len)\n        for id in\
    \ edges:\n            result.add(v)\n            let e = g.get_edge(id)\n    \
    \        when g is DirectedGraph:\n                v = e.dst\n            else:\n\
    \                v = if e.src == v: e.dst else: e.src\n\n    proc cycle_detection*(g:\
    \ DirectedGraph or UnDirectedGraph): seq[int] =\n        ## \u9589\u8DEF\u3092\
    \u4E00\u3064\u3001\u901A\u904E\u9806\u306E\u8FBA\u756A\u53F7\u5217\u3067\u8FD4\
    \u3059\u3002\u5B58\u5728\u3057\u306A\u3051\u308C\u3070\u7A7A\u5217\u3002O(V+E)\
    \ \u6642\u9593\u3001O(V) \u8FFD\u52A0\u9818\u57DF\u3002\n        ## \u9589\u8DEF\
    \u5185\u306E\u9802\u70B9\u30FB\u8FBA\u306F\u91CD\u8907\u3057\u306A\u3044\u3002\
    \u5404\u8FBA\u306E\u7AEF\u70B9\u306F get_edge \u3067\u53D6\u5F97\u3067\u304D\u308B\
    \u3002\n        ## \u81EA\u5DF1\u30EB\u30FC\u30D7\u30FB\u591A\u91CD\u8FBA\u306B\
    \u5BFE\u5FDC\u3059\u308B\u975E\u518D\u5E30 DFS\u3002\u91CD\u307F\u306F\u7121\u8996\
    \u3057\u3001\u9759\u7684\u30B0\u30E9\u30D5\u306F build \u6E08\u307F\u3068\u3059\
    \u308B\u3002\n        when g is StaticGraphTypes:\n            g.static_graph_initialized_check()\n\
    \        var state = newSeq[uint8](g.len)\n        var next = newSeq[int](g.len)\n\
    \        var parentEdge = newSeqWith(g.len, -1)\n        var position = newSeq[int](g.len)\n\
    \        var stack: seq[int]\n        for root in 0..<g.len:\n            if state[root]\
    \ != 0: continue\n            state[root] = 1\n            stack.add(root)\n \
    \           position[root] = 0\n            while stack.len > 0:\n           \
    \     let v = stack[^1]\n                when g is StaticGraphTypes:\n       \
    \             let degree = int(g.start[v + 1] - g.start[v])\n                else:\n\
    \                    let degree = g.edges[v].len\n                if next[v] ==\
    \ degree:\n                    state[v] = 2\n                    discard stack.pop()\n\
    \                    continue\n                when g is StaticGraphTypes:\n \
    \                   let e = g.elist[int(g.start[v]) + next[v]]\n             \
    \   else:\n                    let e = g.edges[v][next[v]]\n                inc\
    \ next[v]\n                let to = e.dst.int\n                let id = e.id.int\n\
    \                when g is UnDirectedGraph:\n                    if id == parentEdge[v]:\
    \ continue\n                if state[to] == 0:\n                    parentEdge[to]\
    \ = id\n                    position[to] = stack.len\n                    state[to]\
    \ = 1\n                    stack.add(to)\n                elif state[to] == 1:\n\
    \                    for i in position[to] + 1..<stack.len:\n                \
    \        result.add(parentEdge[stack[i]])\n                    result.add(id)\n\
    \                    return\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/cycle_detection.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/cycle_detection_undirected_test.nim
  - verify/graph/cycle_detection_undirected_test.nim
  - verify/graph/cycle_detection_test.nim
  - verify/graph/cycle_detection_test.nim
  - verify/AI/cycle_detection_test.nim
  - verify/AI/cycle_detection_test.nim
documentation_of: cplib/graph/cycle_detection.nim
layout: document
redirect_from:
- /library/cplib/graph/cycle_detection.nim
- /library/cplib/graph/cycle_detection.nim.html
title: cplib/graph/cycle_detection.nim
---
