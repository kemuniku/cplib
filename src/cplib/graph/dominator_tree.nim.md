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
    path: verify/AI/dominator_tree_test.nim
    title: verify/AI/dominator_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dominator_tree_test.nim
    title: verify/AI/dominator_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dominator_tree_test.nim
    title: verify/graph/dominator_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dominator_tree_test.nim
    title: verify/graph/dominator_tree_test.nim
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
  code: "when not declared CPLIB_GRAPH_DOMINATOR_TREE:\n    const CPLIB_GRAPH_DOMINATOR_TREE*\
    \ = 1\n    import cplib/graph/graph\n    import sequtils\n\n    proc dominator_tree*(g:\
    \ DirectedGraph or seq[seq[int]], root: int): seq[int] =\n        ## \u5404\u9802\
    \u70B9\u306E\u76F4\u8FD1\u652F\u914D\u9802\u70B9\u3092\u8FD4\u3059\u3002\u6839\
    \u306F\u81EA\u8EAB\u3001\u6839\u304B\u3089\u5230\u9054\u4E0D\u80FD\u306A\u9802\
    \u70B9\u306F-1\u3002\u6839\u306F\u6709\u52B9\u306A\u9802\u70B9\u3068\u3059\u308B\
    \u3002\n        ## Lengauer-Tarjan\u6CD5\u3067O((V+E)log V)\u6642\u9593\u3001\
    O(V+E)\u9818\u57DF\u3002DFS\u30FB\u7D4C\u8DEF\u5727\u7E2E\u3068\u3082\u306B\u975E\
    \u518D\u5E30\u3002\n        ## \u81EA\u5DF1\u30EB\u30FC\u30D7\u30FB\u591A\u91CD\
    \u8FBA\u306B\u5BFE\u5FDC\u3059\u308B\u3002\u91CD\u307F\u306F\u7121\u8996\u3057\
    \u3001\u9759\u7684\u30B0\u30E9\u30D5\u306Fbuild\u6E08\u307F\u3068\u3059\u308B\u3002\
    \n        let n = g.len\n        assert root in 0..<n, \"\u6839\u306E\u9802\u70B9\
    \u756A\u53F7\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        when g is StaticGraphTypes:\n\
    \            g.static_graph_initialized_check()\n        var order = newSeqWith(n,\
    \ -1)\n        var vertex = newSeqOfCap[int](n)\n        var parent = newSeq[int](n)\n\
    \        var next = newSeq[int](n)\n        var pred = newSeq[seq[int]](n)\n \
    \       var stack = newSeqOfCap[int](n)\n        order[root] = 0\n        vertex.add(root)\n\
    \        stack.add(root)\n        while stack.len > 0:\n            let v = stack[^1]\n\
    \            when g is StaticGraphTypes:\n                let degree = int(g.start[v\
    \ + 1] - g.start[v])\n            elif g is DirectedGraph:\n                let\
    \ degree = g.edges[v].len\n            else:\n                let degree = g[v].len\n\
    \            if next[v] == degree:\n                discard stack.pop()\n    \
    \            continue\n            when g is StaticGraphTypes:\n             \
    \   let to = g.elist[int(g.start[v]) + next[v]].dst.int\n            elif g is\
    \ DirectedGraph:\n                let to = g.edges[v][next[v]].dst.int\n     \
    \       else:\n                let to = g[v][next[v]]\n            inc next[v]\n\
    \            assert to in 0..<n, \"\u8FBA\u306E\u7AEF\u70B9\u304C\u7BC4\u56F2\u5916\
    \u3067\u3059\"\n            pred[to].add(v)\n            if order[to] == -1:\n\
    \                order[to] = vertex.len\n                parent[vertex.len] =\
    \ order[v]\n                vertex.add(to)\n                stack.add(to)\n\n\
    \        # \u4EE5\u964D\u306E\u914D\u5217\u306F\u5230\u9054\u53EF\u80FD\u306A\u9802\
    \u70B9\u306EDFS\u9806\u3067\u6DFB\u5B57\u3092\u4ED8\u3051\u308B\u3002\n      \
    \  let reachable = vertex.len\n        var semi = newSeq[int](reachable)\n   \
    \     var label = newSeq[int](reachable)\n        var ancestor = newSeqWith(reachable,\
    \ -1)\n        var idom = newSeq[int](reachable)\n        var bucketHead = newSeqWith(reachable,\
    \ -1)\n        var bucketNext = newSeq[int](reachable)\n        for i in 0..<reachable:\n\
    \            semi[i] = i\n            label[i] = i\n\n        proc eval(v: int):\
    \ int =\n            ## \u9023\u7D50\u6E08\u307F\u7956\u5148\u3078\u306E\u7D4C\
    \u8DEF\u4E0A\u3067semi\u304C\u6700\u5C0F\u306E\u9802\u70B9\u3092\u3001\u7D4C\u8DEF\
    \u5727\u7E2E\u3057\u306A\u304C\u3089\u8FD4\u3059\u3002\n            var x = v\n\
    \            while ancestor[x] != -1 and ancestor[ancestor[x]] != -1:\n      \
    \          stack.add(x)\n                x = ancestor[x]\n            while stack.len\
    \ > 0:\n                let u = stack.pop()\n                let p = ancestor[u]\n\
    \                if semi[label[p]] < semi[label[u]]:\n                    label[u]\
    \ = label[p]\n                ancestor[u] = ancestor[p]\n            return label[v]\n\
    \n        for w in countdown(reachable - 1, 1):\n            for v in pred[vertex[w]]:\n\
    \                semi[w] = min(semi[w], semi[eval(order[v])])\n            bucketNext[w]\
    \ = bucketHead[semi[w]]\n            bucketHead[semi[w]] = w\n            let\
    \ p = parent[w]\n            ancestor[w] = p\n            var v = bucketHead[p]\n\
    \            while v != -1:\n                let u = eval(v)\n               \
    \ idom[v] = if semi[u] < semi[v]: u else: p\n                v = bucketNext[v]\n\
    \            bucketHead[p] = -1\n        for w in 1..<reachable:\n           \
    \ if idom[w] != semi[w]:\n                idom[w] = idom[idom[w]]\n\n        result\
    \ = newSeqWith(n, -1)\n        result[root] = root\n        for w in 1..<reachable:\n\
    \            result[vertex[w]] = vertex[idom[w]]\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/dominator_tree.nim
  requiredBy: []
  timestamp: '2026-09-27 01:45:17+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/dominator_tree_test.nim
  - verify/graph/dominator_tree_test.nim
  - verify/AI/dominator_tree_test.nim
  - verify/AI/dominator_tree_test.nim
documentation_of: cplib/graph/dominator_tree.nim
layout: document
redirect_from:
- /library/cplib/graph/dominator_tree.nim
- /library/cplib/graph/dominator_tree.nim.html
title: cplib/graph/dominator_tree.nim
---
