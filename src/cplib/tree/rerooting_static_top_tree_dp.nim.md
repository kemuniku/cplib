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
  - icon: ':heavy_check_mark:'
    path: cplib/tree/static_top_tree.nim
    title: cplib/tree/static_top_tree.nim
  - icon: ':heavy_check_mark:'
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
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "## \u4EFB\u610F\u306E\u9802\u70B9\u3092\u6839\u3068\u3059\u308B\u6728DP\u3092\
    \u3001\u69CB\u9020\u3092\u5909\u66F4\u305B\u305A\u306B\u554F\u3044\u5408\u308F\
    \u305B\u308B\u3002\n## Forward\u306F\u4E0A\u7AEF\u3092\u9664\u304D\u4E0B\u7AEF\
    \u3092\u542B\u3080\u5411\u304D\u3001Backward\u306F\u540C\u3058\u9802\u70B9\u96C6\
    \u5408\u3092\u4E0B\u7AEF\u304B\u3089\u898B\u305F\u5411\u304D\u3002\n## compressReverse\u306F\
    \u9006\u5411\u304D\u306E\u30D1\u30B9\u3092\u9023\u7D50\u3059\u308B\u3002rakeAtRoot\u3068\
    rakeAtEnd\u306F\u305D\u308C\u305E\u308C\n## Backward\u306E\u59CB\u70B9\u30FB\u7D42\
    \u70B9\u306BForward\u306E\u679D\u3092\u4ED8\u3051\u3001Backward\u306E\u30D1\u30B9\
    \u3092\u7DAD\u6301\u3059\u308B\u3002\n## \u5404\u6F14\u7B97\u306F\u30AF\u30E9\u30B9\
    \u30BF\u306E\u7D50\u5408\u3092\u8868\u3057\u3001\u679D\u306E\u9806\u5E8F\u3084\
    \u5408\u6CD5\u306A\u7D50\u5408\u9806\u5E8F\u306B\u4F9D\u5B58\u3057\u306A\u3044\
    \u3082\u306E\u3068\u3059\u308B\u3002\n## \u7A7A\u30AF\u30E9\u30B9\u30BF\u306E\u5358\
    \u4F4D\u5143\u3084\u9006\u6F14\u7B97\u306F\u4E0D\u8981\u3002\u5404\u6F14\u7B97\
    \u304CO(1)\u306A\u3089\u66F4\u65B0\u30FB\u554F\u3044\u5408\u308F\u305B\u306FO(log\
    \ N)\u3002\nwhen not declared CPLIB_TREE_REROOTING_STATIC_TOP_TREE_DP:\n    const\
    \ CPLIB_TREE_REROOTING_STATIC_TOP_TREE_DP* = 1\n    import cplib/tree/static_top_tree\n\
    \n    type RerootingStaticTopTreeDP*[Forward, Backward] = ref object\n       \
    \ tree*: StaticTopTree\n        forward: seq[Forward]\n        backward: seq[Backward]\n\
    \        compress, rake: proc(l, r: Forward): Forward\n        compressReverse:\
    \ proc(l, r: Backward): Backward\n        rakeAtRoot, rakeAtEnd: proc(l: Backward,\
    \ r: Forward): Backward\n\n    proc recalculate[Forward, Backward](self: RerootingStaticTopTreeDP[Forward,\
    \ Backward], node: int) =\n        ## \u5B50\u306E\u96C6\u7D04\u5024\u304B\u3089\
    \u5185\u90E8\u30CE\u30FC\u30C9\u306E\u4E21\u65B9\u5411\u3092\u518D\u8A08\u7B97\
    \u3059\u308B\u3002O(1)\u56DE\u306E\u6F14\u7B97\n        let x = self.tree.nodes[node]\n\
    \        case x.kind\n        of sttCompress:\n            self.forward[node]\
    \ = self.compress(self.forward[x.left], self.forward[x.right])\n            self.backward[node]\
    \ = self.compressReverse(self.backward[x.right], self.backward[x.left])\n    \
    \    of sttRake:\n            self.forward[node] = self.rake(self.forward[x.left],\
    \ self.forward[x.right])\n            self.backward[node] = self.rakeAtEnd(self.backward[x.left],\
    \ self.forward[x.right])\n        of sttLeaf:\n            discard\n\n    proc\
    \ initRerootingStaticTopTreeDP*[Forward, Backward](tree: StaticTopTree,\n    \
    \        forward: openArray[Forward], backward: openArray[Backward],\n       \
    \     compress, rake: proc(l, r: Forward): Forward,\n            compressReverse:\
    \ proc(l, r: Backward): Backward,\n            rakeAtRoot, rakeAtEnd: proc(l:\
    \ Backward, r: Forward): Backward\n            ): RerootingStaticTopTreeDP[Forward,\
    \ Backward] =\n        ## \u9802\u70B9\u756A\u53F7\u9806\u306E\u8449\u306E\u5024\
    \u304B\u3089\u4E21\u65B9\u5411\u306EDP\u3092\u69CB\u7BC9\u3059\u308B\u3002O(N)\u56DE\
    \u306E\u6F14\u7B97\n        assert forward.len == tree.numVertices and backward.len\
    \ == tree.numVertices, \"\u9806\u65B9\u5411\u3068\u9006\u65B9\u5411\u306E\u5024\
    \u306E\u914D\u5217\u306E\u9577\u3055\u306F\u6728\u306E\u9802\u70B9\u6570\u3068\
    \u4E00\u81F4\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n       \
    \ result = RerootingStaticTopTreeDP[Forward, Backward](tree: tree,\n         \
    \   forward: newSeq[Forward](tree.nodes.len), backward: newSeq[Backward](tree.nodes.len),\n\
    \            compress: compress, rake: rake, compressReverse: compressReverse,\n\
    \            rakeAtRoot: rakeAtRoot, rakeAtEnd: rakeAtEnd)\n        for v in 0..<tree.numVertices:\n\
    \            result.forward[v] = forward[v]\n            result.backward[v] =\
    \ backward[v]\n        for node in tree.numVertices..<tree.nodes.len:\n      \
    \      result.recalculate(node)\n\n    proc set*[Forward, Backward](self: RerootingStaticTopTreeDP[Forward,\
    \ Backward], v: int,\n            forward: Forward, backward: Backward) =\n  \
    \      ## \u9802\u70B9v\u3068\u89AA\u8FBA\u3092\u8868\u3059\u8449\u306E\u4E21\u65B9\
    \u5411\u306E\u5024\u3092\u66F4\u65B0\u3059\u308B\u3002O(log N)\u56DE\u306E\u6F14\
    \u7B97\n        assert 0 <= v and v < self.tree.numVertices, \"\u9802\u70B9\u756A\
    \u53F7\u304C\u7BC4\u56F2\u5916\u3067\u3059: 0 <= v and v < self.tree.numVertices\"\
    \n        self.forward[v] = forward\n        self.backward[v] = backward\n   \
    \     var node = self.tree.nodes[v].parent\n        while node != -1:\n      \
    \      self.recalculate(node)\n            node = self.tree.nodes[node].parent\n\
    \n    proc getAll*[Forward, Backward](self: RerootingStaticTopTreeDP[Forward,\
    \ Backward]): Forward =\n        ## \u69CB\u7BC9\u6642\u306E\u6839\u306B\u5BFE\
    \u3059\u308B\u6728\u5168\u4F53\u306E\u96C6\u7D04\u5024\u3092\u8FD4\u3059\u3002\
    O(1)\n        return self.forward[self.tree.root]\n\n    proc prod*[Forward, Backward](self:\
    \ RerootingStaticTopTreeDP[Forward, Backward], v: int): Backward =\n        ##\
    \ \u9802\u70B9v\u3092\u6839\u3068\u3059\u308B\u6728\u5168\u4F53\u306E\u96C6\u7D04\
    \u5024\u3092\u8FD4\u3059\u3002O(log N)\u6642\u9593\u30FB\u4F5C\u696D\u7A7A\u9593\
    \n        assert 0 <= v and v < self.tree.numVertices, \"\u9802\u70B9\u756A\u53F7\
    \u304C\u7BC4\u56F2\u5916\u3067\u3059: 0 <= v and v < self.tree.numVertices\"\n\
    \        var path: seq[int]\n        var node = v\n        while self.tree.nodes[node].parent\
    \ != -1:\n            path.add(node)\n            node = self.tree.nodes[node].parent\n\
    \        var upper: Backward\n        var lower: Forward\n        var hasUpper\
    \ = false\n        var hasLower = false\n        # \u4E0A\u7AEF\u5074\u306E\u5916\
    \u90E8\u306F\u4E0A\u7AEF\u306E\u9802\u70B9\u3092\u542B\u307F\u3001\u4E0B\u7AEF\
    \u5074\u306E\u5916\u90E8\u306F\u4E0B\u7AEF\u306E\u9802\u70B9\u3092\u542B\u307E\
    \u306A\u3044\u3002\n        for i in countdown(path.len - 1, 0):\n           \
    \ let child = path[i]\n            let x = self.tree.nodes[self.tree.nodes[child].parent]\n\
    \            case x.kind\n            of sttCompress:\n                if child\
    \ == x.left:\n                    lower = if hasLower: self.compress(self.forward[x.right],\
    \ lower)\n                            else: self.forward[x.right]\n          \
    \          hasLower = true\n                else:\n                    upper =\
    \ if hasUpper: self.compressReverse(self.backward[x.left], upper)\n          \
    \                  else: self.backward[x.left]\n                    hasUpper =\
    \ true\n            of sttRake:\n                assert hasUpper, \"rake\u306B\
    \u3088\u308B\u96C6\u7D04\u306B\u306F\u4E0A\u5074\u306E\u96C6\u7D04\u5024\u304C\
    \u5FC5\u8981\u3067\u3059\"\n                if child == x.left:\n            \
    \        upper = self.rakeAtRoot(upper, self.forward[x.right])\n             \
    \   else:\n                    let rest = if hasLower: self.compress(self.forward[x.left],\
    \ lower)\n                               else: self.forward[x.left]\n        \
    \            upper = self.rakeAtRoot(upper, rest)\n                    hasLower\
    \ = false\n            of sttLeaf:\n                assert false, \"\u5B50\u3092\
    \u6301\u3064\u30AF\u30E9\u30B9\u30BF\u304C\u8449\u3068\u3057\u3066\u767B\u9332\
    \u3055\u308C\u3066\u3044\u307E\u3059\"\n        result = self.backward[v]\n  \
    \      if hasUpper:\n            result = self.compressReverse(result, upper)\n\
    \        if hasLower:\n            result = self.rakeAtRoot(result, lower)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/tree/static_top_tree.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/static_top_tree.nim
  - cplib/tree/heavylightdecomposition.nim
  isVerificationFile: false
  path: cplib/tree/rerooting_static_top_tree_dp.nim
  requiredBy: []
  timestamp: '2026-09-14 07:58:37+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tree/point_set_tree_path_composite_sum_test.nim
  - verify/tree/point_set_tree_path_composite_sum_test.nim
  - verify/AI/static_top_tree_test.nim
  - verify/AI/static_top_tree_test.nim
documentation_of: cplib/tree/rerooting_static_top_tree_dp.nim
layout: document
redirect_from:
- /library/cplib/tree/rerooting_static_top_tree_dp.nim
- /library/cplib/tree/rerooting_static_top_tree_dp.nim.html
title: cplib/tree/rerooting_static_top_tree_dp.nim
---
