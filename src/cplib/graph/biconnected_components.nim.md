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
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/block_cut_tree.nim
    title: cplib/graph/block_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/block_cut_tree.nim
    title: cplib/graph/block_cut_tree.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/lowlink_test.nim
    title: verify/AI/lowlink_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lowlink_test.nim
    title: verify/AI/lowlink_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/biconnected_components_test.nim
    title: verify/graph/biconnected_components_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/biconnected_components_test.nim
    title: verify/graph/biconnected_components_test.nim
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
  code: "when not declared CPLIB_GRAPH_BICONNECTED_COMPONENTS:\n    const CPLIB_GRAPH_BICONNECTED_COMPONENTS*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/graph/lowlink\n    import\
    \ sequtils\n\n    type BiconnectedComponents* = object\n        groups*: seq[seq[int]]\n\
    \        belong*: seq[seq[int]]\n        articulation*: seq[int]\n\n    proc initBiconnectedComponents*(ll:\
    \ LowLink): BiconnectedComponents =\n        ## \u8A08\u7B97\u6E08\u307Flowlink\u304B\
    \u3089\u4E8C\u91CD\u9802\u70B9\u9023\u7D50\u6210\u5206\u306E\u9802\u70B9\u96C6\
    \u5408\u3092O(V)\u3067\u6C42\u3081\u307E\u3059\u3002\n        ## \u6A4B\u306E\u4E21\
    \u7AEF\u3082\u4E00\u6210\u5206\u3068\u3057\u3001\u81EA\u5DF1\u30EB\u30FC\u30D7\
    \u306F\u7121\u8996\u3057\u307E\u3059\u3002\u5B64\u7ACB\u70B9\u306F\u5358\u72EC\
    \u306E\u6210\u5206\u3067\u3059\u3002\n        result.articulation = ll.articulation\n\
    \        result.belong = newSeq[seq[int]](ll.ord.len)\n        # \u672A\u78BA\u5B9A\
    \u306E\u9802\u70B9\u3092\u5E30\u308A\u304C\u3051\u9806\u306B\u7A4D\u307F\u3001\
    \u6210\u5206\u306E\u5883\u754C\u3067\u5B50\u5B6B\u3092\u307E\u3068\u3081\u3066\
    \u53D6\u308A\u51FA\u3057\u307E\u3059\u3002\n        var pending: seq[int]\n  \
    \      for v in ll.postorder:\n            let p = ll.parent[v]\n            var\
    \ group: seq[int]\n            if p == -1:\n                if result.belong[v].len\
    \ == 0: group.add(v)\n            elif ll.low[v] >= ll.ord[p]:\n             \
    \   while pending.len > 0 and ll.ord[pending[^1]] > ll.ord[v]:\n             \
    \       group.add(pending.pop())\n                group.add(v)\n             \
    \   group.add(p)\n            else:\n                pending.add(v)\n        \
    \    if group.len > 0:\n                let id = result.groups.len\n         \
    \       for u in group: result.belong[u].add(id)\n                result.groups.add(group)\n\
    \n    proc initBiconnectedComponents*(g: UnDirectedGraph): BiconnectedComponents\
    \ =\n        ## \u7121\u5411\u30B0\u30E9\u30D5\u3092O(V+E)\u6642\u9593\u30FB\u9818\
    \u57DF\u3067\u4E8C\u91CD\u9802\u70B9\u9023\u7D50\u6210\u5206\u306B\u5206\u89E3\
    \u3057\u307E\u3059\u3002\n        ## \u9759\u7684\u30B0\u30E9\u30D5\u306Fbuild\u6E08\
    \u307F\u3068\u3057\u307E\u3059\u3002\u81EA\u5DF1\u30EB\u30FC\u30D7\u306F\u7121\
    \u8996\u3057\u3001DFS\u306F\u975E\u518D\u5E30\u3067\u3059\u3002\n        let n\
    \ = g.len\n        when g is StaticGraphTypes:\n            g.static_graph_initialized_check()\n\
    \        result.belong = newSeq[seq[int]](n)\n        var ord = newSeqWith(n,\
    \ -1)\n        var low = newSeq[int](n)\n        var parent = newSeqWith(n, -1)\n\
    \        var next = newSeq[int](n)\n        var pending: seq[int]\n        var\
    \ timer = 0\n        for root in 0..<n:\n            if ord[root] != -1: continue\n\
    \            var v = root\n            ord[v] = timer\n            low[v] = timer\n\
    \            inc timer\n            while v != -1:\n                when g is\
    \ StaticGraphTypes:\n                    let degree = int(g.start[v+1] - g.start[v])\n\
    \                else:\n                    let degree = g.edges[v].len\n    \
    \            if next[v] < degree:\n                    when g is StaticGraphTypes:\n\
    \                        let to = g.elist[int(g.start[v]) + next[v]][0].int\n\
    \                    else:\n                        let to = g.edges[v][next[v]][0].int\n\
    \                    inc next[v]\n                    if ord[to] == -1:\n    \
    \                    parent[to] = v\n                        ord[to] = timer\n\
    \                        low[to] = timer\n                        inc timer\n\
    \                        v = to\n                    else:\n                 \
    \       # \u89AA\u3078\u306E\u8FBA\u3082\u542B\u3081\u3066\u3088\u3044\u3002\u6210\
    \u5206\u5883\u754C\u306E >= \u5224\u5B9A\u306B\u306F\u5F71\u97FF\u3057\u307E\u305B\
    \u3093\u3002\n                        low[v] = min(low[v], ord[to])\n        \
    \        else:\n                    let p = parent[v]\n                    var\
    \ group: seq[int]\n                    if p == -1:\n                        if\
    \ result.belong[v].len == 0: group = @[v]\n                    else:\n       \
    \                 low[p] = min(low[p], low[v])\n                        if low[v]\
    \ >= ord[p]:\n                            var first = pending.len\n          \
    \                  while first > 0 and ord[pending[first-1]] > ord[v]: dec first\n\
    \                            let size = pending.len - first\n                \
    \            group = newSeq[int](size + 2)\n                            for i\
    \ in 0..<size: group[i] = pending[pending.len-1-i]\n                         \
    \   pending.setLen(first)\n                            group[size] = v\n     \
    \                       group[size+1] = p\n                        else:\n   \
    \                         pending.add(v)\n                    if group.len > 0:\n\
    \                        let id = result.groups.len\n                        for\
    \ u in group: result.belong[u].add(id)\n                        result.groups.add(move(group))\n\
    \                    v = p\n        for v in 0..<n:\n            if result.belong[v].len\
    \ > 1: result.articulation.add(v)\n"
  dependsOn:
  - cplib/graph/lowlink.nim
  - cplib/graph/graph.nim
  - cplib/graph/lowlink.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/biconnected_components.nim
  requiredBy:
  - cplib/graph/block_cut_tree.nim
  - cplib/graph/block_cut_tree.nim
  timestamp: '2026-09-13 04:56:49+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/biconnected_components_test.nim
  - verify/graph/biconnected_components_test.nim
  - verify/AI/lowlink_test.nim
  - verify/AI/lowlink_test.nim
documentation_of: cplib/graph/biconnected_components.nim
layout: document
redirect_from:
- /library/cplib/graph/biconnected_components.nim
- /library/cplib/graph/biconnected_components.nim.html
title: cplib/graph/biconnected_components.nim
---
