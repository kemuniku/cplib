---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy:
  - icon: ':question:'
    path: cplib/graph/biconnected_components.nim
    title: cplib/graph/biconnected_components.nim
  - icon: ':question:'
    path: cplib/graph/biconnected_components.nim
    title: cplib/graph/biconnected_components.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/block_cut_tree.nim
    title: cplib/graph/block_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/block_cut_tree.nim
    title: cplib/graph/block_cut_tree.nim
  - icon: ':question:'
    path: cplib/graph/two_edge_connected_components.nim
    title: cplib/graph/two_edge_connected_components.nim
  - icon: ':question:'
    path: cplib/graph/two_edge_connected_components.nim
    title: cplib/graph/two_edge_connected_components.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/lowlink_test.nim
    title: verify/AI/lowlink_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lowlink_test.nim
    title: verify/AI/lowlink_test.nim
  - icon: ':x:'
    path: verify/graph/biconnected_components_test.nim
    title: verify/graph/biconnected_components_test.nim
  - icon: ':x:'
    path: verify/graph/biconnected_components_test.nim
    title: verify/graph/biconnected_components_test.nim
  - icon: ':x:'
    path: verify/graph/lowlink_articulation_test.nim
    title: verify/graph/lowlink_articulation_test.nim
  - icon: ':x:'
    path: verify/graph/lowlink_articulation_test.nim
    title: verify/graph/lowlink_articulation_test.nim
  - icon: ':x:'
    path: verify/graph/lowlink_bridges_test.nim
    title: verify/graph/lowlink_bridges_test.nim
  - icon: ':x:'
    path: verify/graph/lowlink_bridges_test.nim
    title: verify/graph/lowlink_bridges_test.nim
  - icon: ':x:'
    path: verify/graph/two_edge_connected_components_test.nim
    title: verify/graph/two_edge_connected_components_test.nim
  - icon: ':x:'
    path: verify/graph/two_edge_connected_components_test.nim
    title: verify/graph/two_edge_connected_components_test.nim
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':question:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_LOWLINK:\n    const CPLIB_GRAPH_LOWLINK* =\
    \ 1\n    import cplib/graph/graph\n    import sequtils\n\n    type LowLink* =\
    \ object\n        ord*, low*, parent*: seq[int]\n        preorder*, postorder*:\
    \ seq[int]\n        articulation*: seq[int]\n        is_articulation*: seq[bool]\n\
    \        bridges*: seq[(int, int)]\n\n    proc initLowLink*(g: UnDirectedGraph):\
    \ LowLink =\n        ## \u7121\u5411\u30B0\u30E9\u30D5\u306Elowlink\u30FB\u95A2\
    \u7BC0\u70B9\u30FB\u6A4B\u3092O(V+E)\u6642\u9593\u30FB\u9818\u57DF\u3067\u6C42\
    \u3081\u307E\u3059\u3002\u9759\u7684\u30B0\u30E9\u30D5\u306Fbuild\u6E08\u307F\u3068\
    \u3057\u307E\u3059\u3002\n        ## \u591A\u91CD\u8FBA\u30FB\u81EA\u5DF1\u30EB\
    \u30FC\u30D7\u306B\u5BFE\u5FDC\u3057\u3001\u6A4B\u306F(\u89AA, \u5B50)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002DFS\u306F\u975E\u518D\u5E30\u3067\u3059\u3002\n      \
    \  let n = g.len\n        result.ord = newSeqWith(n, -1)\n        result.low =\
    \ newSeq[int](n)\n        result.parent = newSeqWith(n, -1)\n        result.is_articulation\
    \ = newSeq[bool](n)\n        when g is StaticGraphTypes:\n            g.static_graph_initialized_check()\n\
    \        var next = newSeq[int](n)\n        var children = newSeq[int](n)\n  \
    \      var skippedParent = newSeq[bool](n)\n        var stack: seq[int]\n    \
    \    for root in 0..<n:\n            if result.ord[root] != -1: continue\n   \
    \         result.ord[root] = result.preorder.len\n            result.low[root]\
    \ = result.ord[root]\n            result.preorder.add(root)\n            stack.add(root)\n\
    \            while stack.len > 0:\n                let v = stack[^1]\n       \
    \         when g is StaticGraphTypes:\n                    let degree = int(g.start[v+1]\
    \ - g.start[v])\n                else:\n                    let degree = g.edges[v].len\n\
    \                if next[v] < degree:\n                    when g is StaticGraphTypes:\n\
    \                        let to = g.elist[int(g.start[v]) + next[v]][0].int\n\
    \                    else:\n                        let to = g.edges[v][next[v]][0].int\n\
    \                    inc next[v]\n                    if to == result.parent[v]\
    \ and not skippedParent[v]:\n                        skippedParent[v] = true\n\
    \                        continue\n                    if result.ord[to] == -1:\n\
    \                        result.parent[to] = v\n                        inc children[v]\n\
    \                        result.ord[to] = result.preorder.len\n              \
    \          result.low[to] = result.ord[to]\n                        result.preorder.add(to)\n\
    \                        stack.add(to)\n                    else:\n          \
    \              result.low[v] = min(result.low[v], result.ord[to])\n          \
    \      else:\n                    discard stack.pop()\n                    result.postorder.add(v)\n\
    \                    let p = result.parent[v]\n                    if p == -1:\n\
    \                        result.is_articulation[v] = children[v] > 1\n       \
    \             else:\n                        result.low[p] = min(result.low[p],\
    \ result.low[v])\n                        if result.low[v] > result.ord[p]:\n\
    \                            result.bridges.add((p, v))\n                    \
    \    if result.parent[p] != -1 and result.low[v] >= result.ord[p]:\n         \
    \                   result.is_articulation[p] = true\n        for v in 0..<n:\n\
    \            if result.is_articulation[v]: result.articulation.add(v)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/lowlink.nim
  requiredBy:
  - cplib/graph/two_edge_connected_components.nim
  - cplib/graph/two_edge_connected_components.nim
  - cplib/graph/biconnected_components.nim
  - cplib/graph/biconnected_components.nim
  - cplib/graph/block_cut_tree.nim
  - cplib/graph/block_cut_tree.nim
  timestamp: '2026-09-13 13:39:58+09:00'
  verificationStatus: LIBRARY_SOME_WA
  verifiedWith:
  - verify/graph/lowlink_bridges_test.nim
  - verify/graph/lowlink_bridges_test.nim
  - verify/graph/two_edge_connected_components_test.nim
  - verify/graph/two_edge_connected_components_test.nim
  - verify/graph/biconnected_components_test.nim
  - verify/graph/biconnected_components_test.nim
  - verify/graph/lowlink_articulation_test.nim
  - verify/graph/lowlink_articulation_test.nim
  - verify/AI/lowlink_test.nim
  - verify/AI/lowlink_test.nim
documentation_of: cplib/graph/lowlink.nim
layout: document
redirect_from:
- /library/cplib/graph/lowlink.nim
- /library/cplib/graph/lowlink.nim.html
title: cplib/graph/lowlink.nim
---
