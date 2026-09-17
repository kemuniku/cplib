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
    path: verify/AI/centroid_decomposition_test.nim
    title: verify/AI/centroid_decomposition_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/centroid_decomposition_test.nim
    title: verify/AI/centroid_decomposition_test.nim
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
  code: "when not declared CPLIB_TREE_CENTROID_DECOMPOSITION:\n    const CPLIB_TREE_CENTROID_DECOMPOSITION*\
    \ = 1\n    import cplib/graph/graph\n\n    type CentroidDecomposition* = ref object\n\
    \        ## \u9802\u70B9\u756A\u53F7\u306F\u5143\u306E\u6728\u3068\u5171\u901A\
    \u3002parent[root] = -1\u3001depth[root] = 0\u3002\n        root*: int\n     \
    \   parent*, depth*: seq[int]\n        children*: seq[seq[int]]\n\n    proc initCentroidDecompositionImpl(g:\
    \ UnDirectedGraph,\n                                      root: int,\n       \
    \                               return_tree: static[bool]): auto =\n        ##\
    \ \u7121\u5411\u6728\u306E\u91CD\u5FC3\u5206\u89E3\u6728\u3092 O(N log N) \u6642\
    \u9593\u30FBO(N) \u9818\u57DF\u3067\u69CB\u7BC9\u3059\u308B\u3002\n        let\
    \ n = g.len\n        when return_tree:\n            result = (tree: initUnWeightedDirectedGraph(n),\
    \ root: -1,\n                size: newSeq[int](n), depth: newSeq[int](n))\n  \
    \      else:\n            result = CentroidDecomposition(root: -1,\n         \
    \       parent: newSeq[int](n), depth: newSeq[int](n),\n                children:\
    \ newSeq[seq[int]](n))\n        if n == 0: return\n        assert root in 0..<n,\
    \ \"\u9802\u70B9\u756A\u53F7\u304C\u7BC4\u56F2\u5916\u3067\u3059: root in 0 ..<\
    \ n\"\n        var removed = newSeq[bool](n)\n        var parent = newSeq[int](n)\n\
    \        var size = newSeq[int](n)\n        var largest = newSeq[int](n)\n   \
    \     var seen = newSeq[int](n)\n        var stamp = 0\n        var order: seq[int]\n\
    \        var tasks = @[(root, -1)]\n        while tasks.len > 0:\n           \
    \ let (start, decompositionParent) = tasks.pop()\n            inc stamp\n    \
    \        order.setLen(0)\n            order.add(start)\n            parent[start]\
    \ = -1\n            seen[start] = stamp\n            var index = 0\n         \
    \   while index < order.len:\n                let u = order[index]\n         \
    \       inc index\n                size[u] = 1\n                largest[u] = 0\n\
    \                for (v, _) in g.to_and_cost(u):\n                    if removed[v]\
    \ or v == parent[u]: continue\n                    assert seen[v] != stamp, \"\
    \u5165\u529B\u306F\u6728\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\"\n                    seen[v] = stamp\n                    parent[v] =\
    \ u\n                    order.add(v)\n            if decompositionParent == -1:\n\
    \                assert order.len == n, \"\u5165\u529B\u306F\u9023\u7D50\u306A\
    \u6728\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n       \
    \     var centroid = -1\n            for i in countdown(order.len - 1, 0):\n \
    \               let u = order[i]\n                if max(largest[u], order.len\
    \ - size[u]) <= order.len div 2:\n                    centroid = u\n         \
    \       let p = parent[u]\n                if p != -1:\n                    size[p]\
    \ += size[u]\n                    largest[p] = max(largest[p], size[u])\n    \
    \        when return_tree:\n                result.size[centroid] = order.len\n\
    \            else:\n                result.parent[centroid] = decompositionParent\n\
    \            if decompositionParent == -1:\n                result.root = centroid\n\
    \            else:\n                result.depth[centroid] = result.depth[decompositionParent]\
    \ + 1\n                when return_tree:\n                    result.tree.add_edge(decompositionParent,\
    \ centroid)\n                else:\n                    result.children[decompositionParent].add(centroid)\n\
    \            removed[centroid] = true\n            for (v, _) in g.to_and_cost(centroid):\n\
    \                if not removed[v]: tasks.add((v, centroid))\n\n    proc initCentroidDecomposition*(g:\
    \ UnDirectedGraph,\n                                   root: int = 0): CentroidDecomposition\
    \ =\n        ## \u7121\u5411\u6728\u306E\u91CD\u5FC3\u5206\u89E3\u6728\u3092 O(N\
    \ log N) \u6642\u9593\u30FBO(N) \u9818\u57DF\u3067\u69CB\u7BC9\u3059\u308B\u3002\
    \n        ## root \u306F\u63A2\u7D22\u958B\u59CB\u70B9\u3067\u3001\u5206\u89E3\
    \u6728\u306E\u6839\u3068\u306F\u9650\u3089\u306A\u3044\u3002\u8FBA\u306E\u91CD\
    \u307F\u306F\u4F7F\u308F\u306A\u3044\u3002\n        ## \u7A7A\u306E\u6728\u3067\
    \u306F root = -1\u3001\u5404\u914D\u5217\u306F\u7A7A\u3002\u9759\u7684\u30B0\u30E9\
    \u30D5\u306F\u4E8B\u524D\u306B build \u3059\u308B\u3002\n        initCentroidDecompositionImpl(g,\
    \ root, false)\n\n    proc initCentroidDecompositionTree*(g: UnDirectedGraph,\n\
    \                                       root: int = 0): tuple[tree: UnWeightedDirectedGraph,\
    \ root: int, size, depth: seq[int]] =\n        ## \u91CD\u5FC3\u5206\u89E3\u6728\
    \u306E\u6709\u5411\u30B0\u30E9\u30D5\u30FB\u6839\u30FB\u90E8\u5206\u6728\u30B5\
    \u30A4\u30BA\u30FB\u6DF1\u3055\u3092 O(N log N) \u6642\u9593\u30FBO(N) \u9818\u57DF\
    \u3067\u69CB\u7BC9\u3059\u308B\u3002\n        ## \u6709\u5411\u8FBA\u306F\u5206\
    \u89E3\u6728\u306E\u89AA\u304B\u3089\u5B50\u3078\u5F35\u308A\u3001\u9802\u70B9\
    \u756A\u53F7\u306F\u5143\u306E\u6728\u3068\u5171\u901A\u3002\n        ## size[v]\
    \ \u306F\u91CD\u5FC3\u5206\u89E3\u6728\u3067 v \u3092\u6839\u3068\u3059\u308B\u90E8\
    \u5206\u6728\u306E\u9802\u70B9\u6570\uFF08v \u81EA\u8EAB\u3092\u542B\u3080\uFF09\
    \u3002\n        ## depth[v] \u306F\u91CD\u5FC3\u5206\u89E3\u6728\u306E\u6839\u304B\
    \u3089\u306E\u6DF1\u3055\u3067\u3001\u6839\u306E\u6DF1\u3055\u306F 0\u3002\n \
    \       ## root \u306F\u63A2\u7D22\u958B\u59CB\u70B9\u3067\u3001\u5206\u89E3\u6728\
    \u306E\u6839\u3068\u306F\u9650\u3089\u306A\u3044\u3002\u8FBA\u306E\u91CD\u307F\
    \u306F\u4F7F\u308F\u306A\u3044\u3002\n        ## \u7A7A\u306E\u6728\u3067\u306F\
    \u6839\u306F -1\u3001size \u3068 depth \u306F\u7A7A\u3002\u9759\u7684\u30B0\u30E9\
    \u30D5\u306F\u4E8B\u524D\u306B build \u3059\u308B\u3002\n        initCentroidDecompositionImpl(g,\
    \ root, true)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/tree/centroid_decomposition.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/centroid_decomposition_test.nim
  - verify/AI/centroid_decomposition_test.nim
documentation_of: cplib/tree/centroid_decomposition.nim
layout: document
redirect_from:
- /library/cplib/tree/centroid_decomposition.nim
- /library/cplib/tree/centroid_decomposition.nim.html
title: cplib/tree/centroid_decomposition.nim
---
