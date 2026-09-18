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
    path: verify/AI/euler_tour_test.nim
    title: verify/AI/euler_tour_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/euler_tour_test.nim
    title: verify/AI/euler_tour_test.nim
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
  code: "when not declared CPLIB_GRAPH_EULER_TOUR:\n    const CPLIB_GRAPH_EULER_TOUR*\
    \ = 1\n    import cplib/graph/graph\n    import algorithm\n\n    proc euler_walk(g:\
    \ DirectedGraph or UnDirectedGraph, start: int, closed: bool): seq[int] =\n  \
    \      ## \u6B21\u6570\u6761\u4EF6\u3092\u78BA\u8A8D\u3057\u3001\u975E\u518D\u5E30\
    \u306E Hierholzer \u6CD5\u3067\u5168\u8FBA\u3092\u4E00\u5EA6\u305A\u3064\u901A\
    \u308B\u3002O(V+E) \u6642\u9593\u30FB\u9818\u57DF\u3002\n        when g is StaticGraphTypes:\n\
    \            g.static_graph_initialized_check()\n        assert start >= -1 and\
    \ (start == -1 or start < g.len), \"\u59CB\u70B9\u304C\u7BC4\u56F2\u5916\u3067\
    \u3059\"\n        if g.edge_count == 0: return\n        var degree = newSeq[int](g.len)\n\
    \        for e in g.edge_info:\n            inc degree[e.src]\n            when\
    \ g is DirectedGraph:\n                dec degree[e.dst]\n            else:\n\
    \                inc degree[e.dst]\n        var requiredStart = -1\n        var\
    \ endpoints = 0\n        for v in 0..<g.len:\n            when g is DirectedGraph:\n\
    \                if degree[v] == 1:\n                    if requiredStart != -1:\
    \ return\n                    requiredStart = v\n                elif degree[v]\
    \ == -1:\n                    inc endpoints\n                elif degree[v] !=\
    \ 0:\n                    return\n            else:\n                if degree[v]\
    \ mod 2 != 0:\n                    if requiredStart == -1: requiredStart = v\n\
    \                    inc endpoints\n        when g is DirectedGraph:\n       \
    \     if endpoints != ord(requiredStart != -1): return\n        else:\n      \
    \      if endpoints != 0 and endpoints != 2: return\n        if closed and requiredStart\
    \ != -1: return\n        var root = start\n        if root == -1:\n          \
    \  root = if requiredStart != -1: requiredStart else: g.edge_info[0].src\n   \
    \     elif requiredStart != -1:\n            when g is DirectedGraph:\n      \
    \          if root != requiredStart: return\n            else:\n             \
    \   if degree[root] mod 2 == 0: return\n        var next = newSeq[int](g.len)\n\
    \        var used = newSeq[bool](g.edge_count)\n        var vertices = @[root]\n\
    \        var incoming = @[-1]\n        result = newSeqOfCap[int](g.edge_count)\n\
    \        while vertices.len > 0:\n            let v = vertices[^1]\n         \
    \   when g is StaticGraphTypes:\n                let count = int(g.start[v + 1]\
    \ - g.start[v])\n            else:\n                let count = g.edges[v].len\n\
    \            if next[v] == count:\n                discard vertices.pop()\n  \
    \              let id = incoming.pop()\n                if id != -1: result.add(id)\n\
    \                continue\n            when g is StaticGraphTypes:\n         \
    \       let e = g.elist[int(g.start[v]) + next[v]]\n            else:\n      \
    \          let e = g.edges[v][next[v]]\n            inc next[v]\n            if\
    \ used[e.id]: continue\n            used[e.id] = true\n            vertices.add(e.dst.int)\n\
    \            incoming.add(e.id.int)\n        if result.len != g.edge_count:\n\
    \            result.setLen(0)\n        else:\n            result.reverse()\n\n\
    \    proc euler_tour*(g: DirectedGraph or UnDirectedGraph, start: int = -1): seq[int]\
    \ =\n        ## \u5168\u8FBA\u3092\u4E00\u5EA6\u305A\u3064\u901A\u308A\u59CB\u70B9\
    \u306B\u623B\u308B\u9589\u8DEF\u3092\u3001\u901A\u904E\u9806\u306E\u8FBA\u756A\
    \u53F7\u5217\u3067\u8FD4\u3059\u3002O(V+E) \u6642\u9593\u30FB\u9818\u57DF\u3002\
    \n        ## start = -1 \u306A\u3089\u59CB\u70B9\u3092\u81EA\u52D5\u9078\u629E\
    \u3059\u308B\u3002\u6307\u5B9A\u3057\u305F\u59CB\u70B9\u304B\u3089\u5B58\u5728\
    \u3057\u306A\u3051\u308C\u3070\u7A7A\u5217\u3002\u8FBA\u304C\u306A\u3044\u5834\
    \u5408\u3082\u7A7A\u5217\u3002\n        ## \u8FBA\u756A\u53F7\u306F add_edge \u306E\
    \u623B\u308A\u5024\u3002\u7121\u5411\u8FBA\u306F\u3069\u3061\u3089\u5411\u304D\
    \u306B\u3082\u901A\u308C\u308B\u3002\u5B64\u7ACB\u70B9\u306F\u7121\u8996\u3059\
    \u308B\u3002\n        ## \u81EA\u5DF1\u30EB\u30FC\u30D7\u30FB\u591A\u91CD\u8FBA\
    \u306B\u5BFE\u5FDC\u3057\u3001\u91CD\u307F\u306F\u7121\u8996\u3059\u308B\u3002\
    \u9759\u7684\u30B0\u30E9\u30D5\u306F build \u6E08\u307F\u3068\u3059\u308B\u3002\
    \u30B0\u30E9\u30D5\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        euler_walk(g,\
    \ start, true)\n\n    proc euler_trail*(g: DirectedGraph or UnDirectedGraph, start:\
    \ int = -1): seq[int] =\n        ## \u5168\u8FBA\u3092\u4E00\u5EA6\u305A\u3064\
    \u901A\u308B\u7D4C\u8DEF\u3092\u3001\u901A\u904E\u9806\u306E\u8FBA\u756A\u53F7\
    \u5217\u3067\u8FD4\u3059\u3002\u59CB\u70B9\u3068\u7D42\u70B9\u306F\u7570\u306A\
    \u3063\u3066\u3082\u3088\u3044\u3002O(V+E) \u6642\u9593\u30FB\u9818\u57DF\u3002\
    \n        ## start = -1 \u306A\u3089\u59CB\u70B9\u3092\u81EA\u52D5\u9078\u629E\
    \u3059\u308B\u3002\u6307\u5B9A\u3057\u305F\u59CB\u70B9\u304B\u3089\u5B58\u5728\
    \u3057\u306A\u3051\u308C\u3070\u7A7A\u5217\u3002\u8FBA\u304C\u306A\u3044\u5834\
    \u5408\u3082\u7A7A\u5217\u3002\n        ## \u8FBA\u756A\u53F7\u30FB\u5BFE\u5FDC\
    \u30B0\u30E9\u30D5\u30FB\u975E\u7834\u58CA\u6027\u306F euler_tour \u3068\u540C\
    \u3058\u3002\n        euler_walk(g, start, false)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/euler_tour.nim
  requiredBy: []
  timestamp: '2026-09-18 12:10:16+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/euler_tour_test.nim
  - verify/AI/euler_tour_test.nim
documentation_of: cplib/graph/euler_tour.nim
layout: document
redirect_from:
- /library/cplib/graph/euler_tour.nim
- /library/cplib/graph/euler_tour.nim.html
title: cplib/graph/euler_tour.nim
---
