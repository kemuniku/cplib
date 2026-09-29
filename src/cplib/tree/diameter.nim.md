---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/tree/diameter_path_dynamic_test_.nim
    title: verify/tree/diameter_path_dynamic_test_.nim
  - icon: ':warning:'
    path: verify/tree/diameter_path_dynamic_test_.nim
    title: verify/tree/diameter_path_dynamic_test_.nim
  - icon: ':warning:'
    path: verify/tree/diameter_path_static_test_.nim
    title: verify/tree/diameter_path_static_test_.nim
  - icon: ':warning:'
    path: verify/tree/diameter_path_static_test_.nim
    title: verify/tree/diameter_path_static_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/diameter_test.nim
    title: verify/AI/diameter_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/diameter_test.nim
    title: verify/AI/diameter_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_dynamic_test.nim
    title: verify/tree/diameter_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_dynamic_test.nim
    title: verify/tree/diameter_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_random_test.nim
    title: verify/tree/diameter_random_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_random_test.nim
    title: verify/tree/diameter_random_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_static_test.nim
    title: verify/tree/diameter_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_static_test.nim
    title: verify/tree/diameter_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_yosupo_test.nim
    title: verify/tree/diameter_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_yosupo_test.nim
    title: verify/tree/diameter_yosupo_test.nim
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
  code: "when not declared CPLIB_TREE_DIAMETER:\n    const CPLIB_TREE_DIAMETER* =\
    \ 1\n    import algorithm\n    import cplib/graph/graph\n\n    proc diameter_impl(g:\
    \ UnDirectedGraph, restorePath: static bool): auto =\n        ## \u975E\u8CA0\u91CD\
    \u307F\u306E\u6728\u306E\u76F4\u5F84\u3092\u3001\u96A3\u63A5\u8FBA\u306E\u8D70\
    \u67FB1\u56DE\u3068\u9006\u9806\u306E\u6728DP\u3067\u6C42\u3081\u308B\u3002\u6642\
    \u9593\u30FB\u7A7A\u9593 O(V)\u3002\n        assert g.len > 0, \"\u6728\u306F\
    1\u9802\u70B9\u4EE5\u4E0A\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\"\n        when g is WeightedGraph:\n            type Cost = g.T\n    \
    \    else:\n            type Cost = int\n        # \u9802\u70B9\u3054\u3068\u306E\
    \u60C5\u5831\u3092\u307E\u3068\u3081\u3001\u6728DP\u3067\u53C2\u7167\u3059\u308B\
    \u914D\u5217\u3092\u6E1B\u3089\u3059\u3002\n        var nodes = newSeq[tuple[parent:\
    \ int, cost, down: Cost, endpoint: int]](g.len)\n        var order = newSeq[int](g.len)\n\
    \        nodes[0].parent = -1\n        var tail = 1\n        for i in 0..<g.len:\n\
    \            let x = order[i]\n            nodes[x].endpoint = x\n           \
    \ for (y, cost) in g.to_and_cost(x):\n                if y == nodes[x].parent:\
    \ continue\n                nodes[y].parent = x\n                nodes[y].cost\
    \ = cost\n                order[tail] = y\n                inc tail\n\n      \
    \  var best = Cost(0)\n        var u, v: int\n        when restorePath:\n    \
    \        var center = 0\n        for i in countdown(g.len - 1, 1):\n         \
    \   let x = order[i]\n            let p = nodes[x].parent\n            let d =\
    \ nodes[x].down + nodes[x].cost\n            if nodes[p].down + d > best:\n  \
    \              best = nodes[p].down + d\n                u = nodes[p].endpoint\n\
    \                v = nodes[x].endpoint\n                when restorePath:\n  \
    \                  center = p\n            if d > nodes[p].down:\n           \
    \     nodes[p].down = d\n                nodes[p].endpoint = nodes[x].endpoint\n\
    \n        when restorePath:\n            var path = newSeq[int]()\n          \
    \  var x = u\n            while x != center:\n                path.add(x)\n  \
    \              x = nodes[x].parent\n            path.add(center)\n           \
    \ let split = path.len\n            x = v\n            while x != center:\n  \
    \              path.add(x)\n                x = nodes[x].parent\n            path.reverse(split,\
    \ path.high)\n            return (best, path)\n        else:\n            return\
    \ (best, u, v)\n\n    proc diameter_and_edge*(g: UnDirectedGraph): auto =\n  \
    \      ## \u975E\u8CA0\u91CD\u307F\u306E\u6728\u306E\u76F4\u5F84\u9577\u3068\u4E21\
    \u7AEF\u70B9\u3092\u8FD4\u3059\u3002\u540C\u9577\u306E\u76F4\u5F84\u306E\u9078\
    \u629E\u306F\u4EFB\u610F\u3002\u6642\u9593\u30FB\u7A7A\u9593 O(V)\u3002\n    \
    \    g.diameter_impl(false)\n\n    proc diameter*(g: UnDirectedGraph): auto =\n\
    \        ## \u975E\u8CA0\u91CD\u307F\u306E\u6728\u306E\u76F4\u5F84\u9577\u3092\
    \u8FD4\u3059\u3002\u6642\u9593\u30FB\u7A7A\u9593 O(V)\u3002\n        let (d, _,\
    \ _) = g.diameter_and_edge()\n        return d\n\n    proc diameter_path*(g: UnDirectedGraph):\
    \ auto =\n        ## \u975E\u8CA0\u91CD\u307F\u306E\u6728\u306E\u76F4\u5F84\u9577\
    \u3068\u7D4C\u8DEF\u3092\u8FD4\u3059\u3002\u540C\u9577\u306E\u76F4\u5F84\u306E\
    \u9078\u629E\u306F\u4EFB\u610F\u3002\u6642\u9593\u30FB\u7A7A\u9593 O(V)\u3002\n\
    \        g.diameter_impl(true)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/tree/diameter.nim
  requiredBy:
  - verify/tree/diameter_path_dynamic_test_.nim
  - verify/tree/diameter_path_dynamic_test_.nim
  - verify/tree/diameter_path_static_test_.nim
  - verify/tree/diameter_path_static_test_.nim
  timestamp: '2026-09-30 06:49:19+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/graph_weight_type_test.nim
  - verify/AI/graph_weight_type_test.nim
  - verify/AI/diameter_test.nim
  - verify/AI/diameter_test.nim
  - verify/tree/diameter_random_test.nim
  - verify/tree/diameter_random_test.nim
  - verify/tree/diameter_yosupo_test.nim
  - verify/tree/diameter_yosupo_test.nim
  - verify/tree/diameter_static_test.nim
  - verify/tree/diameter_static_test.nim
  - verify/tree/diameter_dynamic_test.nim
  - verify/tree/diameter_dynamic_test.nim
documentation_of: cplib/tree/diameter.nim
layout: document
redirect_from:
- /library/cplib/tree/diameter.nim
- /library/cplib/tree/diameter.nim.html
title: cplib/tree/diameter.nim
---
