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
    path: verify/AI/tree_hash_test.nim
    title: verify/AI/tree_hash_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/tree_hash_test.nim
    title: verify/AI/tree_hash_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/rooted_tree_isomorphism_classification_test.nim
    title: verify/tree/rooted_tree_isomorphism_classification_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/rooted_tree_isomorphism_classification_test.nim
    title: verify/tree/rooted_tree_isomorphism_classification_test.nim
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
  code: "when not declared CPLIB_TREE_TREE_HASH:\n    const CPLIB_TREE_TREE_HASH*\
    \ = 1\n    import std/random\n    import cplib/graph/graph\n\n    const TREE_HASH_MOD*\
    \ = (1'u64 shl 61) - 1\n    type\n        TreeHashResult* = tuple[subtree, all_roots:\
    \ seq[uint64]]\n        TreeHashState = tuple[hash: uint64, height: int]\n   \
    \ const treeHashIdentity: TreeHashState = (1'u64, -1)\n    var treeHashRandom\
    \ = initRand()\n    var treeHashDepth: seq[uint64]\n\n    proc treeHashMul(a,\
    \ b: uint64): uint64 =\n        ## 61 bit \u672A\u6E80\u306E\u5024\u3092\u3001\
    128 bit \u6574\u6570\u3092\u4F7F\u308F\u305A\u306B\u4E57\u7B97\u3059\u308B\u3002\
    \n        const mask31 = (1'u64 shl 31) - 1\n        const mask30 = (1'u64 shl\
    \ 30) - 1\n        let\n            au = a shr 31\n            al = a and mask31\n\
    \            bu = b shr 31\n            bl = b and mask31\n            mid = al\
    \ * bu + au * bl\n            value = au * bu * 2 + (mid shr 30) +\n         \
    \       ((mid and mask30) shl 31) + al * bl\n        result = (value shr 61) +\
    \ (value and TREE_HASH_MOD)\n        if result >= TREE_HASH_MOD: result -= TREE_HASH_MOD\n\
    \n    proc treeHashMerge(a, b: TreeHashState): TreeHashState =\n        ## \u5B50\
    \u306E\u30CF\u30C3\u30B7\u30E5\u306E\u7A4D\u3068\u9AD8\u3055\u306E\u6700\u5927\
    \u5024\u3092\u307E\u3068\u3081\u308B\u3002\n        (treeHashMul(a.hash, b.hash),\
    \ max(a.height, b.height))\n\n    proc treeHashVertex(a: TreeHashState): TreeHashState\
    \ =\n        ## \u5B50\u3092\u307E\u3068\u3081\u305F\u5024\u306B\u3001\u9802\u70B9\
    \u3068\u305D\u306E\u90E8\u5206\u6728\u306E\u9AD8\u3055\u3092\u53CD\u6620\u3059\
    \u308B\u3002\n        result.height = a.height + 1\n        result.hash = a.hash\
    \ + treeHashDepth[result.height]\n        if result.hash >= TREE_HASH_MOD: result.hash\
    \ -= TREE_HASH_MOD\n\n    proc treeHashImpl(g: DirectedGraph or UnDirectedGraph,\
    \ root: int,\n                      reroot: static[bool]): TreeHashResult =\n\
    \        ## \u90E8\u5206\u6728\u3092\u4E0B\u304B\u3089\u8A08\u7B97\u3057\u3001\
    \u5FC5\u8981\u306A\u3089\u89AA\u5074\u304B\u3089\u306E\u5BC4\u4E0E\u3082\u4F1D\
    \u64AD\u3059\u308B\u3002\n        let n = g.len\n        if n == 0: return\n \
    \       assert root in 0..<n\n        while treeHashDepth.len < n:\n         \
    \   treeHashDepth.add(treeHashRandom.rand(0'u64..TREE_HASH_MOD - 1))\n       \
    \ var parent = newSeq[int](n)\n        for v in 0..<n: parent[v] = -2\n      \
    \  parent[root] = -1\n        var order = @[root]\n        var children = newSeq[seq[int]](n)\n\
    \        var index = 0\n        while index < order.len:\n            let u =\
    \ order[index]\n            inc index\n            for (v, _) in g.to_and_cost(u):\n\
    \                if v == parent[u]: continue\n                assert parent[v]\
    \ == -2, \"\u5165\u529B\u306F\u6728\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n                parent[v] = u\n                children[u].add(v)\n\
    \                order.add(v)\n        assert order.len == n, \"\u6307\u5B9A\u3057\
    \u305F\u6839\u304B\u3089\u5168\u9802\u70B9\u306B\u5230\u9054\u3067\u304D\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        var down = newSeq[TreeHashState](n)\n\
    \        result.subtree = newSeq[uint64](n)\n        for i in countdown(n - 1,\
    \ 0):\n            let u = order[i]\n            var value = treeHashIdentity\n\
    \            for v in children[u]: value = treeHashMerge(value, down[v])\n   \
    \         down[u] = treeHashVertex(value)\n            result.subtree[u] = down[u].hash\n\
    \        when reroot:\n            var up = newSeq[TreeHashState](n)\n       \
    \     up[root] = treeHashIdentity\n            result.all_roots = newSeq[uint64](n)\n\
    \            var prefix: seq[TreeHashState]\n            for u in order:\n   \
    \             let count = children[u].len\n                prefix.setLen(count\
    \ + 1)\n                prefix[0] = up[u]\n                for i, v in children[u]:\n\
    \                    prefix[i + 1] = treeHashMerge(prefix[i], down[v])\n     \
    \           result.all_roots[u] = treeHashVertex(prefix[count]).hash\n       \
    \         var suffix = treeHashIdentity\n                for i in countdown(count\
    \ - 1, 0):\n                    let v = children[u][i]\n                    up[v]\
    \ = treeHashVertex(treeHashMerge(prefix[i], suffix))\n                    suffix\
    \ = treeHashMerge(down[v], suffix)\n\n    proc subtree_hash*(g: DirectedGraph\
    \ or UnDirectedGraph,\n                       root: int = 0): seq[uint64] =\n\
    \        ## root \u3092\u6839\u3068\u3057\u305F\u5404\u9802\u70B9\u306E\u90E8\u5206\
    \u6728\u30CF\u30C3\u30B7\u30E5\u3092 O(N) \u6642\u9593\u30FB\u9818\u57DF\u3067\
    \u8FD4\u3059\u3002\u6709\u5411\u6728\u306F\u89AA\u304B\u3089\u5B50\u3078\u8FBA\
    \u3092\u5F35\u308B\u3002\n        treeHashImpl(g, root, false).subtree\n\n   \
    \ proc tree_hash*(g: UnDirectedGraph, root: int = 0): TreeHashResult =\n     \
    \   ## root \u306B\u5BFE\u3059\u308B\u90E8\u5206\u6728\u3068\u3001\u5404\u9802\
    \u70B9\u3092\u6839\u3068\u3057\u305F\u6728\u5168\u4F53\u306E\u30CF\u30C3\u30B7\
    \u30E5\u3092 O(N) \u6642\u9593\u30FB\u9818\u57DF\u3067\u8FD4\u3059\u3002\n   \
    \     treeHashImpl(g, root, true)\n\n    proc all_roots_hash*(g: UnDirectedGraph,\
    \ root: int = 0): seq[uint64] =\n        ## \u5404\u9802\u70B9\u3092\u6839\u3068\
    \u3057\u305F\u6728\u5168\u4F53\u306E\u30CF\u30C3\u30B7\u30E5\u3092 O(N) \u6642\
    \u9593\u30FB\u9818\u57DF\u3067\u8FD4\u3059\u3002root \u306F\u8A08\u7B97\u958B\u59CB\
    \u70B9\u3002\n        tree_hash(g, root).all_roots\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/tree/tree_hash.nim
  requiredBy: []
  timestamp: '2026-09-06 08:45:23+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tree/rooted_tree_isomorphism_classification_test.nim
  - verify/tree/rooted_tree_isomorphism_classification_test.nim
  - verify/AI/tree_hash_test.nim
  - verify/AI/tree_hash_test.nim
documentation_of: cplib/tree/tree_hash.nim
layout: document
redirect_from:
- /library/cplib/tree/tree_hash.nim
- /library/cplib/tree/tree_hash.nim.html
title: cplib/tree/tree_hash.nim
---
