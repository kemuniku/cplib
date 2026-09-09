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
  code: "when not declared CPLIB_TREE_LINK_CUT_TREE:\n    const CPLIB_TREE_LINK_CUT_TREE*\
    \ = 1\n    import sequtils\n    import cplib/tree/private/link_cut_tree_base\n\
    \n    type LinkCutTreeNode[S] = object\n        left, right, parent: int\n   \
    \     rev: bool\n        value, prod, rprod, virtual, all: S\n\n    type LinkCutTree*[S]\
    \ = ref object\n        nodes: seq[LinkCutTreeNode[S]]\n        stack: seq[int]\n\
    \        merge: proc(x, y: S): S\n        default: S\n        inverse: proc(x:\
    \ S): S\n\n    proc initLinkCutTree*[S](\n        v: openArray[S], merge: proc(x,\
    \ y: S): S, default: S,\n        inverse: proc(x: S): S = nil\n    ): LinkCutTree[S]\
    \ =\n        ## \u9802\u70B9\u306E\u5024v\u3092\u6301\u3064\u3001\u8FBA\u306E\u306A\
    \u3044\u68EE\u3092\u4F5C\u308B\u3002\u6642\u9593\u30FB\u7A7A\u9593O(N)\u3002\n\
    \        ## merge\u3068default\u306F\u30E2\u30CE\u30A4\u30C9\u3092\u306A\u3059\
    \u3053\u3068\u3002\u30D1\u30B9\u306F\u975E\u53EF\u63DB\u3067\u3082\u3088\u3044\
    \u3002\n        ## \u90E8\u5206\u6728\u30FB\u6210\u5206\u3092\u96C6\u7D04\u3059\
    \u308B\u5834\u5408\u306Finverse\u3082\u6E21\u3057\u3001\u53EF\u63DB\u7FA4\u3067\
    \u3042\u308B\u3053\u3068\u3092\u5229\u7528\u8005\u304C\u4FDD\u8A3C\u3059\u308B\
    \u3002\n        ## inverse\u3092\u7701\u7565\u3059\u308B\u3068\u90E8\u5206\u6728\
    \u60C5\u5831\u3092\u66F4\u65B0\u3057\u306A\u3044\u3002\u5404\u6F14\u7B97\u306E\
    \u8A08\u7B97\u91CF\u306Fmerge\u7B49\u304CO(1)\u306E\u5834\u5408\u3002\n      \
    \  result = LinkCutTree[S](\n            nodes: newSeq[LinkCutTreeNode[S]](v.len\
    \ + 1),\n            merge: merge, default: default, inverse: inverse\n      \
    \  )\n        for i in 0..v.len:\n            let value = if i == 0: default else:\
    \ v[i - 1]\n            result.nodes[i] = LinkCutTreeNode[S](\n              \
    \  value: value, prod: value, rprod: value, virtual: default, all: value\n   \
    \         )\n\n    proc initLinkCutTree*[S](\n        n: int, merge: proc(x, y:\
    \ S): S, default: S,\n        inverse: proc(x: S): S = nil\n    ): LinkCutTree[S]\
    \ =\n        ## \u5168\u9802\u70B9\u306E\u5024\u304Cdefault\u306E\u3001\u8FBA\u306E\
    \u306A\u3044\u68EE\u3092\u4F5C\u308B\u3002\u6642\u9593\u30FB\u7A7A\u9593O(N)\u3002\
    \n        assert n >= 0\n        initLinkCutTree(newSeqWith(n, default), merge,\
    \ default, inverse)\n\n    template newLinkCutTreeWith*(vOrN, merge, default:\
    \ untyped): untyped =\n        ## l, r\u3092\u4F7F\u3063\u305F\u5F0F\u304B\u3089\
    \u3001\u30D1\u30B9\u96C6\u7D04\u7528\u306ELinkCutTree\u3092\u4F5C\u308B\u3002\n\
    \        initLinkCutTree[typeof(default)](\n            vOrN, proc(l{.inject.},\
    \ r{.inject.}: typeof(default)): typeof(default) = merge,\n            default\n\
    \        )\n\n    template newLinkCutTreeWith*(vOrN, merge, default, inverse:\
    \ untyped): untyped =\n        ## merge\u306B\u306Fl, r\u3001inverse\u306B\u306F\
    x\u3092\u4F7F\u3063\u305F\u5F0F\u3092\u6E21\u3059\u3002\u90E8\u5206\u6728\u96C6\
    \u7D04\u306B\u306F\u53EF\u63DB\u7FA4\u304C\u5FC5\u8981\u3002\n        initLinkCutTree[typeof(default)](\n\
    \            vOrN, proc(l{.inject.}, r{.inject.}: typeof(default)): typeof(default)\
    \ = merge,\n            default, proc(x{.inject.}: typeof(default)): typeof(default)\
    \ = inverse\n        )\n\n    proc push[S](self: LinkCutTree[S], v: int) =\n \
    \       ## \u53CD\u8EE2\u3092\u5DE6\u53F3\u306E\u5B50\u3078\u4F1D\u64AD\u3059\u308B\
    \u3002O(1)\u3002\n        if v == 0 or not self.nodes[v].rev: return\n       \
    \ for child in [self.nodes[v].left, self.nodes[v].right]:\n            if child\
    \ != 0:\n                swap(self.nodes[child].left, self.nodes[child].right)\n\
    \                swap(self.nodes[child].prod, self.nodes[child].rprod)\n     \
    \           self.nodes[child].rev = not self.nodes[child].rev\n        self.nodes[v].rev\
    \ = false\n\n    proc setParent[S](self: LinkCutTree[S], v, parent: int) =\n \
    \       ## v\u306E\u88DC\u52A9\u6728\u4E0A\u306E\u89AA\u307E\u305F\u306Fpath-parent\u3092\
    \u5909\u66F4\u3059\u308B\u3002O(1)\u3002\n        if v != 0: self.nodes[v].parent\
    \ = parent\n\n    proc pull[S](self: LinkCutTree[S], v: int) =\n        ## \u5DE6\
    \u53F3\u306E\u5B50\u3068\u9802\u70B9\u5024\u304B\u3089\u30D1\u30B9\u3068\u90E8\
    \u5206\u6728\u306E\u60C5\u5831\u3092\u518D\u8A08\u7B97\u3059\u308B\u3002O(1)\u3002\
    \n        let l = self.nodes[v].left\n        let r = self.nodes[v].right\n  \
    \      self.nodes[v].prod = self.merge(self.merge(self.nodes[l].prod, self.nodes[v].value),\
    \ self.nodes[r].prod)\n        self.nodes[v].rprod = self.merge(self.merge(self.nodes[r].rprod,\
    \ self.nodes[v].value), self.nodes[l].rprod)\n        if self.inverse != nil:\n\
    \            self.nodes[v].all = self.merge(\n                self.merge(self.nodes[l].all,\
    \ self.nodes[r].all),\n                self.merge(self.nodes[v].value, self.nodes[v].virtual)\n\
    \            )\n\n    proc addVirtual[S](self: LinkCutTree[S], v, child: int)\
    \ =\n        ## preferred path\u304B\u3089\u5916\u308C\u308B\u5B50\u306E\u5BC4\
    \u4E0E\u3092\u52A0\u3048\u308B\u3002O(1)\u3002\n        if self.inverse != nil\
    \ and child != 0:\n            self.nodes[v].virtual = self.merge(self.nodes[v].virtual,\
    \ self.nodes[child].all)\n\n    proc removeVirtual[S](self: LinkCutTree[S], v,\
    \ child: int) =\n        ## preferred path\u306B\u5165\u308B\u5B50\u306E\u5BC4\
    \u4E0E\u3092\u53D6\u308A\u9664\u304F\u3002O(1)\u3002\n        if self.inverse\
    \ != nil and child != 0:\n            self.nodes[v].virtual = self.merge(self.nodes[v].virtual,\
    \ self.inverse(self.nodes[child].all))\n\n    declareLinkCutTreeOperations(LinkCutTree)\n"
  dependsOn:
  - cplib/tree/private/link_cut_tree_base.nim
  - cplib/tree/private/link_cut_tree_base.nim
  isVerificationFile: false
  path: cplib/tree/link_cut_tree.nim
  requiredBy: []
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
documentation_of: cplib/tree/link_cut_tree.nim
layout: document
redirect_from:
- /library/cplib/tree/link_cut_tree.nim
- /library/cplib/tree/link_cut_tree.nim.html
title: cplib/tree/link_cut_tree.nim
---
