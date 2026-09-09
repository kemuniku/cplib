---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/tree/lazy_subtree_link_cut_tree.nim
    title: cplib/tree/lazy_subtree_link_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/lazy_subtree_link_cut_tree.nim
    title: cplib/tree/lazy_subtree_link_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/link_cut_tree.nim
    title: cplib/tree/link_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/link_cut_tree.nim
    title: cplib/tree/link_cut_tree.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/tree/link_cut_tree/link_cut_tree_test.nim
    title: verify/tree/link_cut_tree/link_cut_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/link_cut_tree/link_cut_tree_test.nim
    title: verify/tree/link_cut_tree/link_cut_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/link_cut_tree/subtree_add_subtree_sum_test.nim
    title: verify/tree/link_cut_tree/subtree_add_subtree_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/link_cut_tree/subtree_add_subtree_sum_test.nim
    title: verify/tree/link_cut_tree/subtree_add_subtree_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/link_cut_tree/vertex_add_path_sum_test.nim
    title: verify/tree/link_cut_tree/vertex_add_path_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/link_cut_tree/vertex_add_path_sum_test.nim
    title: verify/tree/link_cut_tree/vertex_add_path_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/link_cut_tree/vertex_add_subtree_sum_test.nim
    title: verify/tree/link_cut_tree/vertex_add_subtree_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/link_cut_tree/vertex_add_subtree_sum_test.nim
    title: verify/tree/link_cut_tree/vertex_add_subtree_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/link_cut_tree/vertex_set_path_composite_test.nim
    title: verify/tree/link_cut_tree/vertex_set_path_composite_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/link_cut_tree/vertex_set_path_composite_test.nim
    title: verify/tree/link_cut_tree/vertex_set_path_composite_test.nim
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
  code: "when not declared CPLIB_TREE_PRIVATE_LINK_CUT_TREE_BASE:\n    const CPLIB_TREE_PRIVATE_LINK_CUT_TREE_BASE*\
    \ = 1\n\n    template declareLinkCutTreeOperations*(TreeType: untyped) {.dirty.}\
    \ =\n        ## \u96C6\u7D04\u30FB\u9045\u5EF6\u60C5\u5831\u306E\u66F4\u65B0\u3092\
    \u5404\u578B\u306B\u4EFB\u305B\u3001\u5171\u901A\u306ELCT\u64CD\u4F5C\u3092\u5B9A\
    \u7FA9\u3059\u308B\u3002\n        proc isAuxRoot[T: TreeType](self: T, v: int):\
    \ bool {.inline.} =\n            ## v\u304C\u88DC\u52A9splay\u6728\u306E\u6839\
    \u304B\u3092\u8FD4\u3059\u3002O(1)\u3002\n            let p = self.nodes[v].parent\n\
    \            p == 0 or (self.nodes[p].left != v and self.nodes[p].right != v)\n\
    \n        proc toggle[T: TreeType](self: T, v: int) =\n            ## \u88DC\u52A9\
    splay\u6728\u306E\u30D1\u30B9\u306E\u5411\u304D\u3092\u53CD\u8EE2\u3059\u308B\u3002\
    O(1)\u3002\n            if v == 0: return\n            swap(self.nodes[v].left,\
    \ self.nodes[v].right)\n            swap(self.nodes[v].prod, self.nodes[v].rprod)\n\
    \            self.nodes[v].rev = not self.nodes[v].rev\n\n        proc rotate[T:\
    \ TreeType](self: T, v: int) =\n            ## v\u3092\u89AA\u306E\u4F4D\u7F6E\
    \u3078\u56DE\u8EE2\u3057\u3001\u96C6\u7D04\u3068\u89AA\u306B\u4F9D\u5B58\u3059\
    \u308B\u60C5\u5831\u3092\u66F4\u65B0\u3059\u308B\u3002O(1)\u3002\n           \
    \ let p = self.nodes[v].parent\n            let g = self.nodes[p].parent\n   \
    \         let right = self.nodes[p].right == v\n            let middle = if right:\
    \ self.nodes[v].left else: self.nodes[v].right\n            if not self.isAuxRoot(p):\n\
    \                if self.nodes[g].left == p:\n                    self.nodes[g].left\
    \ = v\n                else:\n                    self.nodes[g].right = v\n  \
    \          self.setParent(middle, p)\n            self.setParent(v, g)\n     \
    \       self.setParent(p, v)\n            if right:\n                self.nodes[p].right\
    \ = middle\n                self.nodes[v].left = p\n            else:\n      \
    \          self.nodes[p].left = middle\n                self.nodes[v].right =\
    \ p\n            self.pull(p)\n            self.pull(v)\n\n        proc splay[T:\
    \ TreeType](self: T, v: int) =\n            ## v\u3092\u88DC\u52A9splay\u6728\u306E\
    \u6839\u3078\u79FB\u52D5\u3059\u308B\u3002\u511F\u5374O(log N)\u3002\n       \
    \     self.stack.setLen(0)\n            var x = v\n            self.stack.add(x)\n\
    \            while not self.isAuxRoot(x):\n                x = self.nodes[x].parent\n\
    \                self.stack.add(x)\n            for i in countdown(self.stack.len\
    \ - 1, 0):\n                self.push(self.stack[i])\n            while not self.isAuxRoot(v):\n\
    \                let p = self.nodes[v].parent\n                let g = self.nodes[p].parent\n\
    \                if not self.isAuxRoot(p):\n                    if (self.nodes[p].left\
    \ == v) == (self.nodes[g].left == p):\n                        self.rotate(p)\n\
    \                    else:\n                        self.rotate(v)\n         \
    \       self.rotate(v)\n\n        proc accessNode[T: TreeType](self: T, v: int)\
    \ =\n            ## \u6839\u304B\u3089v\u307E\u3067\u3092preferred path\u306B\u3057\
    \u3001v\u3092\u88DC\u52A9\u6728\u306E\u6839\u306B\u3059\u308B\u3002\u511F\u5374\
    O(log N)\u3002\n            var last = 0\n            var x = v\n            while\
    \ x != 0:\n                self.splay(x)\n                self.addVirtual(x, self.nodes[x].right)\n\
    \                self.removeVirtual(x, last)\n                self.nodes[x].right\
    \ = last\n                self.pull(x)\n                last = x\n           \
    \     x = self.nodes[x].parent\n            self.splay(v)\n\n        proc len*[T:\
    \ TreeType](self: T): int =\n            ## \u9802\u70B9\u6570\u3092\u8FD4\u3059\
    \u3002O(1)\u3002\n            self.nodes.len - 1\n\n        proc makeRoot*[T:\
    \ TreeType](self: T, v: int) =\n            ## v\u3092\u6240\u5C5E\u3059\u308B\
    \u6728\u306E\u6839\u306B\u3059\u308B\u3002\u511F\u5374O(log N)\u3002\n       \
    \     assert 0 <= v and v < self.len\n            self.accessNode(v + 1)\n   \
    \         self.toggle(v + 1)\n\n        proc findRoot*[T: TreeType](self: T, v:\
    \ int): int =\n            ## v\u304C\u6240\u5C5E\u3059\u308B\u6728\u306E\u73FE\
    \u5728\u306E\u6839\u3092\u8FD4\u3059\u3002\u511F\u5374O(log N)\u3002\n       \
    \     assert 0 <= v and v < self.len\n            var x = v + 1\n            self.accessNode(x)\n\
    \            self.push(x)\n            while self.nodes[x].left != 0:\n      \
    \          x = self.nodes[x].left\n                self.push(x)\n            self.splay(x)\n\
    \            x - 1\n\n        proc connected*[T: TreeType](self: T, u, v: int):\
    \ bool =\n            ## u\u3068v\u304C\u540C\u3058\u6728\u306B\u5C5E\u3059\u308B\
    \u304B\u3092\u8FD4\u3059\u3002\u511F\u5374O(log N)\u3002\n            assert 0\
    \ <= u and u < self.len and 0 <= v and v < self.len\n            u == v or self.findRoot(u)\
    \ == self.findRoot(v)\n\n        proc link*[T: TreeType](self: T, u, v: int) =\n\
    \            ## \u7570\u306A\u308B\u6728\u306E\u9802\u70B9u, v\u3092\u8FBA\u3067\
    \u7D50\u3076\u3002\u511F\u5374O(log N)\u3002\n            ## \u7D50\u5408\u5F8C\
    \u306E\u6839\u306F\u7D50\u5408\u524D\u306Ev\u5074\u306E\u6839\u306B\u306A\u308B\
    \u3002\n            assert 0 <= u and u < self.len and 0 <= v and v < self.len\n\
    \            self.makeRoot(u)\n            assert self.findRoot(v) != u, \"link\u3059\
    \u308B\u9802\u70B9\u306F\u7570\u306A\u308B\u6728\u306B\u5C5E\u3059\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\"\n            self.accessNode(v + 1)\n \
    \           self.setParent(u + 1, v + 1)\n            self.addVirtual(v + 1, u\
    \ + 1)\n            self.pull(v + 1)\n\n        proc cut*[T: TreeType](self: T,\
    \ u, v: int) =\n            ## \u5B58\u5728\u3059\u308B\u8FBA(u, v)\u3092\u524A\
    \u9664\u3059\u308B\u3002\u511F\u5374O(log N)\u3002\n            ## \u5207\u65AD\
    \u5F8C\u306E\u4E8C\u3064\u306E\u6728\u306E\u6839\u306F\u305D\u308C\u305E\u308C\
    u\u3068v\u306B\u306A\u308B\u3002\n            assert 0 <= u and u < self.len and\
    \ 0 <= v and v < self.len\n            self.makeRoot(u)\n            self.accessNode(v\
    \ + 1)\n            self.push(u + 1)\n            assert self.nodes[v + 1].left\
    \ == u + 1 and self.nodes[u + 1].right == 0,\n                \"cut\u3059\u308B\
    \u8FBA\u304C\u5B58\u5728\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \"\n            self.setParent(u + 1, 0)\n            self.nodes[v + 1].left =\
    \ 0\n            self.pull(v + 1)\n\n        proc update*[T: TreeType](self: T,\
    \ v: int, value: T.S) =\n            ## \u9802\u70B9v\u306E\u5024\u3092value\u306B\
    \u5909\u66F4\u3059\u308B\u3002\u511F\u5374O(log N)\u3002\n            assert 0\
    \ <= v and v < self.len\n            self.accessNode(v + 1)\n            self.nodes[v\
    \ + 1].value = value\n            self.pull(v + 1)\n\n        proc `[]`*[T: TreeType](self:\
    \ T, v: int): T.S =\n            ## \u9802\u70B9v\u306E\u5024\u3092\u8FD4\u3059\
    \u3002\u511F\u5374O(log N)\u3002\n            assert 0 <= v and v < self.len\n\
    \            self.accessNode(v + 1)\n            self.nodes[v + 1].value\n\n \
    \       proc `[]=`*[T: TreeType](self: T, v: int, value: T.S) =\n            ##\
    \ \u9802\u70B9v\u306E\u5024\u3092value\u306B\u5909\u66F4\u3059\u308B\u3002\u511F\
    \u5374O(log N)\u3002\n            self.update(v, value)\n\n        proc pathProd*[T:\
    \ TreeType](self: T, u, v: int): T.S =\n            ## \u540C\u3058\u6728\u306E\
    u\u304B\u3089v\u3078\u306E\u30D1\u30B9\u3092\u4E21\u7AEF\u8FBC\u307F\u3067\u9806\
    \u306B\u96C6\u7D04\u3059\u308B\u3002\u511F\u5374O(log N)\u3002\u6839\u3092u\u306B\
    \u5909\u66F4\u3059\u308B\u3002\n            assert 0 <= u and u < self.len and\
    \ 0 <= v and v < self.len\n            self.makeRoot(u)\n            self.accessNode(v\
    \ + 1)\n            self.nodes[v + 1].prod\n\n        proc get*[T: TreeType](self:\
    \ T, u, v: int): T.S =\n            ## \u540C\u3058\u6728\u306Eu\u304B\u3089v\u3078\
    \u306E\u30D1\u30B9\u306E\u96C6\u7D04\u3092\u8FD4\u3059\u3002pathProd\u3068\u540C\
    \u3058\u3002\u511F\u5374O(log N)\u3002\n            self.pathProd(u, v)\n\n  \
    \      proc componentProd*[T: TreeType](self: T, v: int): T.S =\n            ##\
    \ v\u3092\u542B\u3080\u6728\u5168\u4F53\u3092\u96C6\u7D04\u3059\u308B\u3002\u53EF\
    \u63DB\u7FA4\u3068\u9006\u5143\u306E\u6307\u5B9A\u304C\u5FC5\u8981\u3002\u511F\
    \u5374O(log N)\u3002\n            assert 0 <= v and v < self.len\n           \
    \ assert self.inverse != nil, \"\u90E8\u5206\u6728\u30FB\u6210\u5206\u306E\u96C6\
    \u7D04\u306B\u306Finverse\u304C\u5FC5\u8981\u3067\u3059\"\n            self.accessNode(v\
    \ + 1)\n            self.nodes[v + 1].all\n\n        proc subtreeProd*[T: TreeType](self:\
    \ T, v, parent: int): T.S =\n            ## \u8FBA(v, parent)\u306Ev\u5074\u3092\
    \u96C6\u7D04\u3059\u308B\u3002\u53EF\u63DB\u7FA4\u3068\u9006\u5143\u306E\u6307\
    \u5B9A\u304C\u5FC5\u8981\u3002\u511F\u5374O(log N)\u3002\u6839\u3092parent\u306B\
    \u5909\u66F4\u3059\u308B\u3002\n            assert 0 <= v and v < self.len and\
    \ 0 <= parent and parent < self.len\n            assert self.inverse != nil, \"\
    \u90E8\u5206\u6728\u30FB\u6210\u5206\u306E\u96C6\u7D04\u306B\u306Finverse\u304C\
    \u5FC5\u8981\u3067\u3059\"\n            self.makeRoot(parent)\n            self.accessNode(v\
    \ + 1)\n            self.push(parent + 1)\n            assert self.nodes[v + 1].left\
    \ == parent + 1 and self.nodes[parent + 1].right == 0,\n                \"parent\u306F\
    v\u306E\u96A3\u63A5\u9802\u70B9\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n            self.merge(self.nodes[v + 1].value, self.nodes[v +\
    \ 1].virtual)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/tree/private/link_cut_tree_base.nim
  requiredBy:
  - cplib/tree/link_cut_tree.nim
  - cplib/tree/link_cut_tree.nim
  - cplib/tree/lazy_subtree_link_cut_tree.nim
  - cplib/tree/lazy_subtree_link_cut_tree.nim
  timestamp: '2026-09-10 04:41:56+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tree/link_cut_tree/vertex_set_path_composite_test.nim
  - verify/tree/link_cut_tree/vertex_set_path_composite_test.nim
  - verify/tree/link_cut_tree/vertex_add_subtree_sum_test.nim
  - verify/tree/link_cut_tree/vertex_add_subtree_sum_test.nim
  - verify/tree/link_cut_tree/link_cut_tree_test.nim
  - verify/tree/link_cut_tree/link_cut_tree_test.nim
  - verify/tree/link_cut_tree/vertex_add_path_sum_test.nim
  - verify/tree/link_cut_tree/vertex_add_path_sum_test.nim
  - verify/tree/link_cut_tree/subtree_add_subtree_sum_test.nim
  - verify/tree/link_cut_tree/subtree_add_subtree_sum_test.nim
documentation_of: cplib/tree/private/link_cut_tree_base.nim
layout: document
redirect_from:
- /library/cplib/tree/private/link_cut_tree_base.nim
- /library/cplib/tree/private/link_cut_tree_base.nim.html
title: cplib/tree/private/link_cut_tree_base.nim
---
