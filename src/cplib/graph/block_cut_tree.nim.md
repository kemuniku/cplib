---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/biconnected_components.nim
    title: cplib/graph/biconnected_components.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/biconnected_components.nim
    title: cplib/graph/biconnected_components.nim
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
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/lowlink_test.nim
    title: verify/AI/lowlink_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lowlink_test.nim
    title: verify/AI/lowlink_test.nim
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
  code: "when not declared CPLIB_GRAPH_BLOCK_CUT_TREE:\n    const CPLIB_GRAPH_BLOCK_CUT_TREE*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/graph/biconnected_components\n\
    \n    type BlockCutTree* = object\n        forest*: UnWeightedUnDirectedGraph\n\
    \        id*: seq[int]\n        articulation*: seq[int]\n        groups*: seq[seq[int]]\n\
    \n    proc initBlockCutTree*(bc: BiconnectedComponents): BlockCutTree =\n    \
    \    ## \u6210\u5206\u30CE\u30FC\u30C9[0, groups.len)\u3068\u95A2\u7BC0\u70B9\u30CE\
    \u30FC\u30C9\u304B\u3089\u306A\u308Bblock-cut forest\u3092O(V)\u3067\u69CB\u7BC9\
    \u3057\u307E\u3059\u3002\n        ## id[v]\u306F\u95A2\u7BC0\u70B9\u306A\u3089\
    \u5C02\u7528\u30CE\u30FC\u30C9\u3001\u305D\u308C\u4EE5\u5916\u306A\u3089\u6240\
    \u5C5E\u6210\u5206\u3092\u6307\u3057\u307E\u3059\u3002\n        ## \u95A2\u7BC0\
    \u70B9\u30CE\u30FC\u30C9groups.len+i\u306Farticulation[i]\u306B\u5BFE\u5FDC\u3057\
    \u307E\u3059\u3002\n        result.groups = bc.groups\n        result.articulation\
    \ = bc.articulation\n        result.id = newSeq[int](bc.belong.len)\n        result.forest\
    \ = initUnWeightedUnDirectedGraph(bc.groups.len + bc.articulation.len)\n     \
    \   for v in 0..<bc.belong.len:\n            result.id[v] = bc.belong[v][0]\n\
    \        for i, v in bc.articulation:\n            let node = bc.groups.len +\
    \ i\n            result.id[v] = node\n            for group in bc.belong[v]: result.forest.add_edge(node,\
    \ group)\n\n    proc initBlockCutTree*(g: UnDirectedGraph): BlockCutTree =\n \
    \       ## \u7121\u5411\u30B0\u30E9\u30D5\u306Eblock-cut forest\u3092O(V+E)\u6642\
    \u9593\u30FB\u9818\u57DF\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        result\
    \ = initBlockCutTree(initBiconnectedComponents(g))\n"
  dependsOn:
  - cplib/graph/lowlink.nim
  - cplib/graph/biconnected_components.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/biconnected_components.nim
  - cplib/graph/lowlink.nim
  isVerificationFile: false
  path: cplib/graph/block_cut_tree.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/lowlink_test.nim
  - verify/AI/lowlink_test.nim
documentation_of: cplib/graph/block_cut_tree.nim
layout: document
redirect_from:
- /library/cplib/graph/block_cut_tree.nim
- /library/cplib/graph/block_cut_tree.nim.html
title: cplib/graph/block_cut_tree.nim
---
