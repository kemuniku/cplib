---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tree/private/link_cut_tree_base.nim
    title: cplib/tree/private/link_cut_tree_base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/private/link_cut_tree_base.nim
    title: cplib/tree/private/link_cut_tree_base.nim
  _extendedRequiredBy: []
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
  code: "when not declared CPLIB_TREE_LAZY_SUBTREE_LINK_CUT_TREE:\n    const CPLIB_TREE_LAZY_SUBTREE_LINK_CUT_TREE*\
    \ = 1\n    import sequtils\n    import cplib/tree/private/link_cut_tree_base\n\
    \n    type LazySubtreeLinkCutTreeNode[S, F] = object\n        left, right, parent:\
    \ int\n        rev: bool\n        value, prod, rprod, virtual, all: S\n      \
    \  lazy, cancel: F # \u5168\u4F53\u3078\u306E\u7D2F\u7A4D\u4F5C\u7528\u3068\u3001\
    \u89AA\u304B\u3089\u53D7\u3051\u53D6\u308A\u6E08\u307F\u306E\u7D2F\u7A4D\u4F5C\
    \u7528\u3002\n        pathLazy: F # \u5DE6\u53F3\u306E\u5B50\u3060\u3051\u3078\
    \u4F1D\u64AD\u3059\u308B\u30D1\u30B9\u306E\u4F5C\u7528\u3002\n        hasPathLazy:\
    \ bool\n\n    type LazySubtreeLinkCutTree*[S, F] = ref object\n        nodes:\
    \ seq[LazySubtreeLinkCutTreeNode[S, F]]\n        stack: seq[int]\n        merge:\
    \ proc(x, y: S): S\n        default: S\n        mapping: proc(f: F, x: S): S\n\
    \        composition: proc(f, g: F): F\n        id: F\n        inverse: proc(x:\
    \ S): S\n        inverseAction: proc(f: F): F\n\n    proc initLazySubtreeLinkCutTree*[S,\
    \ F](\n        v: openArray[S], merge: proc(x, y: S): S, default: S,\n       \
    \ mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F,\n      \
    \  inverse: proc(x: S): S, inverseAction: proc(f: F): F\n    ): LazySubtreeLinkCutTree[S,\
    \ F] =\n        ## \u9802\u70B9\u306E\u5024v\u3092\u6301\u3064\u3001\u30D1\u30B9\
    \u30FB\u90E8\u5206\u6728\u3078\u306E\u9045\u5EF6\u66F4\u65B0\u304C\u53EF\u80FD\
    \u306A\u68EE\u3092\u4F5C\u308B\u3002\u6642\u9593\u30FB\u7A7A\u9593O(N)\u3002\n\
    \        ## (S, merge, default, inverse)\u3068(F, composition, id, inverseAction)\u306F\
    \u53EF\u63DB\u7FA4\u3068\u3059\u308B\u3002\n        ## mapping\u306Fmerge\u306B\
    \u5206\u914D\u3057\u3001mapping(id, x) = x\u3001mapping(f, default) = default\u3092\
    \u6E80\u305F\u3059\u3053\u3068\u3002\n        ## composition(f, g)\u306Fg\u306E\
    \u5F8C\u306Bf\u3092\u4F5C\u7528\u3055\u305B\u308B\u5408\u6210\u3002\u4EE3\u6570\
    \u7684\u6761\u4EF6\u306F\u5229\u7528\u8005\u304C\u4FDD\u8A3C\u3059\u308B\u3002\
    \n        ## mapping(composition(f, g), x) = mapping(f, mapping(g, x))\u3082\u6E80\
    \u305F\u3059\u3053\u3068\u3002\n        ## \u5404\u6F14\u7B97\u306E\u8A08\u7B97\
    \u91CF\u306Fmerge\u3001mapping\u7B49\u304CO(1)\u306E\u5834\u5408\u3002\u9802\u70B9\
    \u6570\u304C\u5FC5\u8981\u306A\u3089S\u306B\u542B\u3081\u308B\u3002\n        assert\
    \ inverse != nil and inverseAction != nil\n        result = LazySubtreeLinkCutTree[S,\
    \ F](\n            nodes: newSeq[LazySubtreeLinkCutTreeNode[S, F]](v.len + 1),\n\
    \            merge: merge, default: default, mapping: mapping,\n            composition:\
    \ composition, id: id, inverse: inverse, inverseAction: inverseAction\n      \
    \  )\n        for i in 0..v.len:\n            let value = if i == 0: default else:\
    \ v[i - 1]\n            result.nodes[i] = LazySubtreeLinkCutTreeNode[S, F](\n\
    \                value: value, prod: value, rprod: value, virtual: default, all:\
    \ value,\n                lazy: id, cancel: id, pathLazy: id\n            )\n\n\
    \    proc initLazySubtreeLinkCutTree*[S, F](\n        n: int, merge: proc(x, y:\
    \ S): S, default: S,\n        mapping: proc(f: F, x: S): S, composition: proc(f,\
    \ g: F): F, id: F,\n        inverse: proc(x: S): S, inverseAction: proc(f: F):\
    \ F\n    ): LazySubtreeLinkCutTree[S, F] =\n        ## \u5168\u9802\u70B9\u306E\
    \u5024\u304Cdefault\u306E\u68EE\u3092\u4F5C\u308B\u3002\u6642\u9593\u30FB\u7A7A\
    \u9593O(N)\u3002\u9802\u70B9\u6570\u3082default\u306E\u307E\u307E\u306A\u306E\u3067\
    \u6CE8\u610F\u3002\n        assert n >= 0\n        initLazySubtreeLinkCutTree(newSeqWith(n,\
    \ default), merge, default, mapping, composition, id, inverse, inverseAction)\n\
    \n    template newLazySubtreeLinkCutTreeWith*(\n        vOrN, merge, default,\
    \ mapping, composition, id, inverse, inverseAction: untyped\n    ): untyped =\n\
    \        ## merge\u306Fl,r\u3001mapping\u306Ff,x\u3001composition\u306Ff,g\u3001\
    inverse\u306Fx\u3001inverseAction\u306Ff\u3067\u8A18\u8FF0\u3059\u308B\u3002\n\
    \        block:\n            type S = typeof(default)\n            type F = typeof(id)\n\
    \            initLazySubtreeLinkCutTree[S, F](\n                vOrN, proc(l{.inject.},\
    \ r{.inject.}: S): S = merge,\n                default, proc(f{.inject.}: F, x{.inject.}:\
    \ S): S = mapping,\n                proc(f{.inject.}, g{.inject.}: F): F = composition,\n\
    \                id, proc(x{.inject.}: S): S = inverse,\n                proc(f{.inject.}:\
    \ F): F = inverseAction\n            )\n\n    proc applyAll[S, F](self: LazySubtreeLinkCutTree[S,\
    \ F], v: int, f: F) =\n        ## \u88DC\u52A9\u6728\u3068\u305D\u306Evirtual\
    \ child\u5168\u4F53\u3078\u4F5C\u7528\u3055\u305B\u3001\u7D2F\u7A4D\u30BF\u30B0\
    \u3082\u66F4\u65B0\u3059\u308B\u3002O(1)\u3002\n        if v == 0: return\n  \
    \      self.nodes[v].value = self.mapping(f, self.nodes[v].value)\n        self.nodes[v].prod\
    \ = self.mapping(f, self.nodes[v].prod)\n        self.nodes[v].rprod = self.mapping(f,\
    \ self.nodes[v].rprod)\n        self.nodes[v].virtual = self.mapping(f, self.nodes[v].virtual)\n\
    \        self.nodes[v].all = self.mapping(f, self.nodes[v].all)\n        self.nodes[v].lazy\
    \ = self.composition(f, self.nodes[v].lazy)\n\n    proc applyPathNode[S, F](self:\
    \ LazySubtreeLinkCutTree[S, F], v: int, f: F) =\n        ## \u88DC\u52A9\u6728\
    \u306E\u30D1\u30B9\u3060\u3051\u3078\u4F5C\u7528\u3055\u305B\u3001\u305D\u306E\
    \u5DEE\u5206\u3067\u5168\u4F53\u96C6\u7D04\u3092\u66F4\u65B0\u3059\u308B\u3002\
    O(1)\u3002\n        if v == 0: return\n        let oldProd = self.nodes[v].prod\n\
    \        self.nodes[v].value = self.mapping(f, self.nodes[v].value)\n        self.nodes[v].prod\
    \ = self.mapping(f, oldProd)\n        self.nodes[v].rprod = self.mapping(f, self.nodes[v].rprod)\n\
    \        self.nodes[v].all = self.merge(\n            self.nodes[v].all, self.merge(self.inverse(oldProd),\
    \ self.nodes[v].prod)\n        )\n        if self.nodes[v].hasPathLazy:\n    \
    \        self.nodes[v].pathLazy = self.composition(f, self.nodes[v].pathLazy)\n\
    \        else:\n            self.nodes[v].pathLazy = f\n            self.nodes[v].hasPathLazy\
    \ = true\n\n    proc push[S, F](self: LazySubtreeLinkCutTree[S, F], v: int) =\n\
    \        ## \u89AA\u304B\u3089\u672A\u53CD\u6620\u306E\u4F5C\u7528\u3092\u53D7\
    \u3051\u53D6\u308A\u3001\u53CD\u8EE2\u3068\u30D1\u30B9\u306E\u4F5C\u7528\u3092\
    \u5DE6\u53F3\u306E\u5B50\u3078\u4F1D\u64AD\u3059\u308B\u3002O(1)\u3002\n     \
    \   if v == 0: return\n        let p = self.nodes[v].parent\n        if p != 0:\n\
    \            var pending = true\n            when compiles(self.nodes[p].lazy\
    \ == self.nodes[v].cancel):\n                pending = not (self.nodes[p].lazy\
    \ == self.nodes[v].cancel)\n            if pending:\n                self.applyAll(v,\
    \ self.composition(self.nodes[p].lazy, self.inverseAction(self.nodes[v].cancel)))\n\
    \                self.nodes[v].cancel = self.nodes[p].lazy\n        if self.nodes[v].rev:\n\
    \            for child in [self.nodes[v].left, self.nodes[v].right]:\n       \
    \         if child != 0:\n                    swap(self.nodes[child].left, self.nodes[child].right)\n\
    \                    swap(self.nodes[child].prod, self.nodes[child].rprod)\n \
    \                   self.nodes[child].rev = not self.nodes[child].rev\n      \
    \      self.nodes[v].rev = false\n        if self.nodes[v].hasPathLazy:\n    \
    \        self.applyPathNode(self.nodes[v].left, self.nodes[v].pathLazy)\n    \
    \        self.applyPathNode(self.nodes[v].right, self.nodes[v].pathLazy)\n   \
    \         self.nodes[v].pathLazy = self.id\n            self.nodes[v].hasPathLazy\
    \ = false\n\n    proc setParent[S, F](self: LazySubtreeLinkCutTree[S, F], v, parent:\
    \ int) =\n        ## \u65E7\u89AA\u304B\u3089\u306E\u4F5C\u7528\u3092\u53CD\u6620\
    \u3057\u3001\u65B0\u89AA\u306E\u904E\u53BB\u306E\u4F5C\u7528\u3092\u53D7\u3051\
    \u53D6\u3089\u306A\u3044\u3088\u3046\u306B\u4ED8\u3051\u66FF\u3048\u308B\u3002\
    O(1)\u3002\n        if v == 0: return\n        self.push(v)\n        self.nodes[v].parent\
    \ = parent\n        self.nodes[v].cancel = self.nodes[parent].lazy\n\n    proc\
    \ pull[S, F](self: LazySubtreeLinkCutTree[S, F], v: int) =\n        ## \u5B50\u306E\
    \u672A\u53CD\u6620\u30BF\u30B0\u3092\u51E6\u7406\u3057\u3066\u3001\u30D1\u30B9\
    \u3068\u90E8\u5206\u6728\u306E\u60C5\u5831\u3092\u518D\u8A08\u7B97\u3059\u308B\
    \u3002O(1)\u3002\n        let l = self.nodes[v].left\n        let r = self.nodes[v].right\n\
    \        self.push(l)\n        self.push(r)\n        self.nodes[v].prod = self.merge(self.merge(self.nodes[l].prod,\
    \ self.nodes[v].value), self.nodes[r].prod)\n        self.nodes[v].rprod = self.merge(self.merge(self.nodes[r].rprod,\
    \ self.nodes[v].value), self.nodes[l].rprod)\n        self.nodes[v].all = self.merge(\n\
    \            self.merge(self.nodes[l].all, self.nodes[r].all),\n            self.merge(self.nodes[v].value,\
    \ self.nodes[v].virtual)\n        )\n\n    proc addVirtual[S, F](self: LazySubtreeLinkCutTree[S,\
    \ F], v, child: int) =\n        ## preferred path\u304B\u3089\u5916\u308C\u308B\
    \u5B50\u306E\u5BC4\u4E0E\u3092\u3001\u4F5C\u7528\u3092\u53CD\u6620\u3057\u3066\
    \u52A0\u3048\u308B\u3002O(1)\u3002\n        if child == 0: return\n        self.push(child)\n\
    \        self.nodes[v].virtual = self.merge(self.nodes[v].virtual, self.nodes[child].all)\n\
    \n    proc removeVirtual[S, F](self: LazySubtreeLinkCutTree[S, F], v, child: int)\
    \ =\n        ## preferred path\u306B\u5165\u308B\u5B50\u306E\u5BC4\u4E0E\u3092\
    \u3001\u4F5C\u7528\u3092\u53CD\u6620\u3057\u3066\u53D6\u308A\u9664\u304F\u3002\
    O(1)\u3002\n        if child == 0: return\n        self.push(child)\n        self.nodes[v].virtual\
    \ = self.merge(self.nodes[v].virtual, self.inverse(self.nodes[child].all))\n\n\
    \    declareLinkCutTreeOperations(LazySubtreeLinkCutTree)\n\n    proc pathApply*[S,\
    \ F](self: LazySubtreeLinkCutTree[S, F], u, v: int, f: F) =\n        ## \u540C\
    \u3058\u6728\u306Eu\u304B\u3089v\u3078\u306E\u30D1\u30B9\u3078\u4E21\u7AEF\u8FBC\
    \u307F\u3067f\u3092\u4F5C\u7528\u3055\u305B\u308B\u3002\u511F\u5374O(log N)\u3002\
    \u6839\u3092u\u306B\u5909\u66F4\u3059\u308B\u3002\n        ## \u30D1\u30B9\u5916\
    \u306E\u9802\u70B9\u306B\u306F\u4F5C\u7528\u3057\u306A\u3044\u3002\u90E8\u5206\
    \u6728\u30FB\u6210\u5206\u3078\u306E\u66F4\u65B0\u3068\u6DF7\u5728\u3055\u305B\
    \u3089\u308C\u308B\u3002\n        assert 0 <= u and u < self.len and 0 <= v and\
    \ v < self.len\n        self.makeRoot(u)\n        self.accessNode(v + 1)\n   \
    \     self.applyPathNode(v + 1, f)\n\n    proc componentApply*[S, F](self: LazySubtreeLinkCutTree[S,\
    \ F], v: int, f: F) =\n        ## v\u3092\u542B\u3080\u6728\u5168\u4F53\u3078\
    f\u3092\u4F5C\u7528\u3055\u305B\u308B\u3002\u511F\u5374O(log N)\u3002\n      \
    \  assert 0 <= v and v < self.len\n        self.accessNode(v + 1)\n        self.applyAll(v\
    \ + 1, f)\n\n    proc subtreeApply*[S, F](self: LazySubtreeLinkCutTree[S, F],\
    \ v, parent: int, f: F) =\n        ## \u5B58\u5728\u3059\u308B\u8FBA(v, parent)\u306E\
    v\u5074\u3078f\u3092\u4F5C\u7528\u3055\u305B\u308B\u3002\u511F\u5374O(log N)\u3002\
    \n        ## \u6839\u3092parent\u306B\u5909\u66F4\u3059\u308B\u3002\u4F5C\u7528\
    \u3055\u305B\u305F\u5F8C\u306B\u63A5\u7D9A\u3057\u305F\u9802\u70B9\u3078\u306F\
    \u3001\u3053\u306E\u4F5C\u7528\u3092\u9069\u7528\u3057\u306A\u3044\u3002\n   \
    \     self.cut(v, parent)\n        self.componentApply(v, f)\n        self.link(v,\
    \ parent)\n"
  dependsOn:
  - cplib/tree/private/link_cut_tree_base.nim
  - cplib/tree/private/link_cut_tree_base.nim
  isVerificationFile: false
  path: cplib/tree/lazy_subtree_link_cut_tree.nim
  requiredBy: []
  timestamp: '2026-09-10 04:41:56+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tree/link_cut_tree/link_cut_tree_test.nim
  - verify/tree/link_cut_tree/link_cut_tree_test.nim
  - verify/tree/link_cut_tree/subtree_add_subtree_sum_test.nim
  - verify/tree/link_cut_tree/subtree_add_subtree_sum_test.nim
documentation_of: cplib/tree/lazy_subtree_link_cut_tree.nim
layout: document
redirect_from:
- /library/cplib/tree/lazy_subtree_link_cut_tree.nim
- /library/cplib/tree/lazy_subtree_link_cut_tree.nim.html
title: cplib/tree/lazy_subtree_link_cut_tree.nim
---
