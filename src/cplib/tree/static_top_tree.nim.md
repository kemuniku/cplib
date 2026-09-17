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
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/tree/rerooting_static_top_tree_dp.nim
    title: cplib/tree/rerooting_static_top_tree_dp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/rerooting_static_top_tree_dp.nim
    title: cplib/tree/rerooting_static_top_tree_dp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/static_top_tree_dp.nim
    title: cplib/tree/static_top_tree_dp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/static_top_tree_dp.nim
    title: cplib/tree/static_top_tree_dp.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_top_tree_test.nim
    title: verify/AI/static_top_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_top_tree_test.nim
    title: verify/AI/static_top_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
    title: verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
    title: verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/point_set_tree_path_composite_sum_test.nim
    title: verify/tree/point_set_tree_path_composite_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/point_set_tree_path_composite_sum_test.nim
    title: verify/tree/point_set_tree_path_composite_sum_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://maspypy.com/library-checker-point-set-tree-path-composite-sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "## \u9802\u70B9\u3068\u89AA\u8FBA\u3092\u8449\u3068\u3059\u308BStatic Top\
    \ Tree\u3002\u6728\u306E\u5F62\u3068\u69CB\u7BC9\u6642\u306E\u6839\u306F\u56FA\
    \u5B9A\u3059\u308B\u3002\n## \u30AF\u30E9\u30B9\u30BF\u306F\u4E0A\u7AEF\u306E\u9802\
    \u70B9\u5024\u3092\u542B\u307E\u305A\u3001\u4E0B\u7AEF\u306E\u9802\u70B9\u5024\
    \u3068\u679D\u90E8\u5206\u3092\u542B\u3080\u3002\n## Compress\u306F\u4E0A\u4E0B\
    \u306E\u30D1\u30B9\u3092\u9023\u7D50\u3057\u3001Rake\u306F\u5171\u901A\u306E\u4E0A\
    \u7AEF\u3067\u679D\u3092\u307E\u3068\u3081\u3066\u5DE6\u306E\u30D1\u30B9\u3092\
    \u6B8B\u3059\u3002\n## \u8449\u306EID\u306F\u5143\u306E\u9802\u70B9\u756A\u53F7\
    \u3068\u7B49\u3057\u3044\u3002\u8FBA\u306E\u66F4\u65B0\u306F\u3001\u69CB\u7BC9\
    \u6642\u306E\u5B50\u5074\u306E\u8449\u3092\u66F4\u65B0\u3059\u308B\u3002\n## https://maspypy.com/library-checker-point-set-tree-path-composite-sum\
    \ \u3092\u53C2\u8003\u306B\u3057\u305F\u3002\nwhen not declared CPLIB_TREE_STATIC_TOP_TREE:\n\
    \    const CPLIB_TREE_STATIC_TOP_TREE* = 1\n    import cplib/tree/heavylightdecomposition\n\
    \n    type\n        StaticTopTreeNodeKind* = enum\n            sttLeaf, sttCompress,\
    \ sttRake\n        StaticTopTreeNode* = object\n            kind*: StaticTopTreeNodeKind\n\
    \            parent*, left*, right*: int\n            upper*, lower*, size*: int\n\
    \        StaticTopTree* = ref object\n            numVertices*, root*: int\n \
    \           nodes*: seq[StaticTopTreeNode]\n\n    proc mergeRange(tree: StaticTopTree,\
    \ items, prefix: seq[int], left, right: int,\n                    kind: StaticTopTreeNodeKind):\
    \ int =\n        ## \u7D2F\u7A4D\u9802\u70B9\u6570\u3067\u5206\u5272\u3057\u3001\
    \u9806\u5E8F\u3092\u4FDD\u3063\u3066\u30AF\u30E9\u30B9\u30BF\u3092\u7D50\u5408\
    \u3059\u308B\u3002\n        if right - left == 1:\n            return items[left]\n\
    \        let weight = prefix[right] - prefix[left]\n        let target = prefix[left]\
    \ + (weight + 1) div 2\n        var lo = left + 1\n        var hi = right - 1\n\
    \        while lo < hi:\n            let mid = (lo + hi) div 2\n            if\
    \ prefix[mid] < target:\n                lo = mid + 1\n            else:\n   \
    \             hi = mid\n        var mid = lo\n        if mid > left + 1 and\n\
    \                abs(2 * (prefix[mid - 1] - prefix[left]) - weight) <=\n     \
    \           abs(2 * (prefix[mid] - prefix[left]) - weight):\n            dec mid\n\
    \        let l = tree.mergeRange(items, prefix, left, mid, kind)\n        let\
    \ r = tree.mergeRange(items, prefix, mid, right, kind)\n        let upper = tree.nodes[l].upper\n\
    \        let lower = if kind == sttCompress: tree.nodes[r].lower else: tree.nodes[l].lower\n\
    \        if kind == sttCompress:\n            assert tree.nodes[l].lower == tree.nodes[r].upper,\
    \ \"compress\u3059\u308B\u30AF\u30E9\u30B9\u30BF\u306E\u63A5\u7D9A\u9802\u70B9\
    \u304C\u4E00\u81F4\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       else:\n            assert tree.nodes[l].upper == tree.nodes[r].upper,\
    \ \"rake\u3059\u308B\u30AF\u30E9\u30B9\u30BF\u306E\u4E0A\u7AEF\u306E\u9802\u70B9\
    \u304C\u4E00\u81F4\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       result = tree.nodes.len\n        tree.nodes.add(StaticTopTreeNode(kind:\
    \ kind, parent: -1, left: l, right: r,\n            upper: upper, lower: lower,\
    \ size: weight))\n        tree.nodes[l].parent = result\n        tree.nodes[r].parent\
    \ = result\n\n    proc mergeBalanced(tree: StaticTopTree, items: seq[int], kind:\
    \ StaticTopTreeNodeKind): int =\n        ## \u9802\u70B9\u6570\u3092\u91CD\u307F\
    \u306B\u3057\u305F\u5E73\u8861\u306A\u7D50\u5408\u6728\u3092\u4F5C\u308B\u3002\
    O(K log K)\n        assert items.len > 0, \"items.len\u306F\u6B63\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        if items.len == 1:\n   \
    \         return items[0]\n        var prefix = newSeq[int](items.len + 1)\n \
    \       for i, node in items:\n            prefix[i + 1] = prefix[i] + tree.nodes[node].size\n\
    \        return tree.mergeRange(items, prefix, 0, items.len, kind)\n\n    proc\
    \ initStaticTopTree*(hld: HeavyLightDecomposition): StaticTopTree =\n        ##\
    \ \u975E\u7A7A\u306E\u6728\u306EHLD\u304B\u3089\u9AD8\u3055O(log N)\u306E\u69CB\
    \u9020\u3092\u4F5C\u308B\u3002O(N log N)\u6642\u9593\u3001O(N)\u7A7A\u9593\n \
    \       let n = hld.numVertices\n        assert n > 0, \"n\u306F\u6B63\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        let tree = StaticTopTree(numVertices:\
    \ n, nodes: newSeqOfCap[StaticTopTreeNode](2 * n - 1))\n        for v in 0..<n:\n\
    \            tree.nodes.add(StaticTopTreeNode(kind: sttLeaf, parent: -1, left:\
    \ -1, right: -1,\n                upper: hld.parentOf(v), lower: v, size: 1))\n\
    \        var pathRoot = newSeq[int](n)\n        for i in countdown(n - 1, 0):\n\
    \            let head = hld.toVtx(i)\n            if hld.heavyRootOf(head) !=\
    \ head:\n                continue\n            var path = @[head]\n          \
    \  var v = head\n            while true:\n                let heavy = hld.heavyChildOf(v)\n\
    \                if heavy == -1:\n                    break\n                var\
    \ branches = @[heavy]\n                for child in hld.children(v):\n       \
    \             if child != heavy:\n                        branches.add(pathRoot[child])\n\
    \                path.add(tree.mergeBalanced(branches, sttRake))\n           \
    \     v = heavy\n            pathRoot[head] = tree.mergeBalanced(path, sttCompress)\n\
    \        tree.root = pathRoot[hld.toVtx(0)]\n        assert tree.nodes.len ==\
    \ 2 * n - 1, \"\u69CB\u7BC9\u3057\u305F\u30AF\u30E9\u30B9\u30BF\u306E\u500B\u6570\
    \u306F2 * n - 1\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n\
    \        return tree\n\n    proc initStaticTopTreeFromParent*(parent: openArray[int],\
    \ root: int = 0): StaticTopTree =\n        ## \u89AA\u914D\u5217\u304B\u3089\u69CB\
    \u7BC9\u3059\u308B\u3002parent[root]\u306F\u53C2\u7167\u3057\u306A\u3044\u3002\
    O(N log N)\n        return initStaticTopTree(initHldFromParent(parent, root))\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  isVerificationFile: false
  path: cplib/tree/static_top_tree.nim
  requiredBy:
  - cplib/tree/static_top_tree_dp.nim
  - cplib/tree/static_top_tree_dp.nim
  - cplib/tree/rerooting_static_top_tree_dp.nim
  - cplib/tree/rerooting_static_top_tree_dp.nim
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tree/point_set_tree_path_composite_sum_test.nim
  - verify/tree/point_set_tree_path_composite_sum_test.nim
  - verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
  - verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
  - verify/AI/static_top_tree_test.nim
  - verify/AI/static_top_tree_test.nim
documentation_of: cplib/tree/static_top_tree.nim
layout: document
redirect_from:
- /library/cplib/tree/static_top_tree.nim
- /library/cplib/tree/static_top_tree.nim.html
title: cplib/tree/static_top_tree.nim
---
