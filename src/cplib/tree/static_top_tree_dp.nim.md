---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':question:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':question:'
    path: cplib/tree/static_top_tree.nim
    title: cplib/tree/static_top_tree.nim
  - icon: ':question:'
    path: cplib/tree/static_top_tree.nim
    title: cplib/tree/static_top_tree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_top_tree_test.nim
    title: verify/AI/static_top_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_top_tree_test.nim
    title: verify/AI/static_top_tree_test.nim
  - icon: ':x:'
    path: verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
    title: verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
  - icon: ':x:'
    path: verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
    title: verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
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
  code: "## \u56FA\u5B9A\u6839\u306E\u6728DP\u3092\u7BA1\u7406\u3059\u308B\u3002\u5404\
    \u6F14\u7B97\u304CO(1)\u306A\u3089\u66F4\u65B0\u306FO(log N)\u3001\u5168\u4F53\
    \u53D6\u5F97\u306FO(1)\u3002\n## compress(\u4E0A, \u4E0B)\u306F\u30D1\u30B9\u306E\
    \u9023\u7D50\u3001rake(\u672C\u4F53, \u679D)\u306F\u672C\u4F53\u306E\u30D1\u30B9\
    \u3092\u6B8B\u3059\u679D\u306E\u7D50\u5408\u3002\n## \u679D\u306E\u9806\u5E8F\u306B\
    \u4F9D\u5B58\u305B\u305A\u3001\u5408\u6CD5\u306A\u7D50\u5408\u9806\u5E8F\u3092\
    \u5909\u3048\u3066\u3082\u540C\u3058\u30AF\u30E9\u30B9\u30BF\u306E\u5024\u306B\
    \u306A\u308BDP\u3092\u5BFE\u8C61\u3068\u3059\u308B\u3002\n## \u8449v\u306B\u306F\
    \u9802\u70B9v\u3068\u89AA\u8FBA\u306E\u60C5\u5831\u3092\u4E0E\u3048\u3001\u69CB\
    \u7BC9\u6642\u306E\u6839\u306E\u89AA\u8FBA\u306F\u554F\u984C\u306B\u5FDC\u3058\
    \u305F\u6052\u7B49\u7684\u306A\u8FBA\u3068\u3059\u308B\u3002\nwhen not declared\
    \ CPLIB_TREE_STATIC_TOP_TREE_DP:\n    const CPLIB_TREE_STATIC_TOP_TREE_DP* = 1\n\
    \    import cplib/tree/static_top_tree\n\n    type StaticTopTreeDP*[Forward] =\
    \ ref object\n        tree*: StaticTopTree\n        values: seq[Forward]\n   \
    \     compress, rake: proc(l, r: Forward): Forward\n\n    proc recalculate[Forward](self:\
    \ StaticTopTreeDP[Forward], node: int) =\n        ## \u5B50\u306E\u96C6\u7D04\u5024\
    \u304B\u3089\u5185\u90E8\u30CE\u30FC\u30C9\u3092\u518D\u8A08\u7B97\u3059\u308B\
    \u3002O(1)\u56DE\u306E\u6F14\u7B97\n        let x = self.tree.nodes[node]\n  \
    \      case x.kind\n        of sttCompress:\n            self.values[node] = self.compress(self.values[x.left],\
    \ self.values[x.right])\n        of sttRake:\n            self.values[node] =\
    \ self.rake(self.values[x.left], self.values[x.right])\n        of sttLeaf:\n\
    \            discard\n\n    proc initStaticTopTreeDP*[Forward](tree: StaticTopTree,\
    \ values: openArray[Forward],\n            compress, rake: proc(l, r: Forward):\
    \ Forward): StaticTopTreeDP[Forward] =\n        ## \u9802\u70B9\u756A\u53F7\u9806\
    \u306E\u8449\u306E\u5024\u304B\u3089\u56FA\u5B9A\u6839DP\u3092\u69CB\u7BC9\u3059\
    \u308B\u3002O(N)\u56DE\u306E\u6F14\u7B97\n        assert values.len == tree.numVertices\n\
    \        result = StaticTopTreeDP[Forward](tree: tree, values: newSeq[Forward](tree.nodes.len),\n\
    \            compress: compress, rake: rake)\n        for v in 0..<values.len:\n\
    \            result.values[v] = values[v]\n        for node in values.len..<tree.nodes.len:\n\
    \            result.recalculate(node)\n\n    proc set*[Forward](self: StaticTopTreeDP[Forward],\
    \ v: int, value: Forward) =\n        ## \u9802\u70B9v\u3068\u89AA\u8FBA\u3092\u8868\
    \u3059\u8449\u306E\u5024\u3092\u66F4\u65B0\u3059\u308B\u3002O(log N)\u56DE\u306E\
    \u6F14\u7B97\n        assert 0 <= v and v < self.tree.numVertices\n        self.values[v]\
    \ = value\n        var node = self.tree.nodes[v].parent\n        while node !=\
    \ -1:\n            self.recalculate(node)\n            node = self.tree.nodes[node].parent\n\
    \n    proc getAll*[Forward](self: StaticTopTreeDP[Forward]): Forward =\n     \
    \   ## \u69CB\u7BC9\u6642\u306E\u6839\u306B\u5BFE\u3059\u308B\u6728\u5168\u4F53\
    \u306E\u96C6\u7D04\u5024\u3092\u8FD4\u3059\u3002O(1)\n        return self.values[self.tree.root]\n"
  dependsOn:
  - cplib/tree/static_top_tree.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/static_top_tree.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/tree/static_top_tree_dp.nim
  requiredBy: []
  timestamp: '2026-09-13 13:39:58+09:00'
  verificationStatus: LIBRARY_SOME_WA
  verifiedWith:
  - verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
  - verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
  - verify/AI/static_top_tree_test.nim
  - verify/AI/static_top_tree_test.nim
documentation_of: cplib/tree/static_top_tree_dp.nim
layout: document
redirect_from:
- /library/cplib/tree/static_top_tree_dp.nim
- /library/cplib/tree/static_top_tree_dp.nim.html
title: cplib/tree/static_top_tree_dp.nim
---
