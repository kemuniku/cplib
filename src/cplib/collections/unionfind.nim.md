---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/merge_tree.nim
    title: cplib/graph/merge_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/merge_tree.nim
    title: cplib/graph/merge_tree.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/unionfind_test.nim
    title: verify/collections/unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/unionfind_test.nim
    title: verify/collections/unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/merge_tree_test.nim
    title: verify/graph/merge_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/merge_tree_test.nim
    title: verify/graph/merge_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/itertools/itertools_combinations_test.nim
    title: verify/itertools/itertools_combinations_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/itertools/itertools_combinations_test.nim
    title: verify/itertools/itertools_combinations_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_past202004o_test.nim
    title: verify/tree/hld/hld_past202004o_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_past202004o_test.nim
    title: verify/tree/hld/hld_past202004o_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_UNIONFIND:\n    const CPLIB_COLLECTIONS_UNIONFIND*\
    \ = 1\n    import algorithm, sequtils\n    type UnionFind* = ref object\n    \
    \    count*: int\n        par_or_siz: seq[int]\n    proc initUnionFind*(N: int):\
    \ UnionFind =\n        result = UnionFind(count: N, par_or_siz: newSeqwith(N,\
    \ -1))\n    proc root*(self: UnionFind, x: int): int =\n        if self.par_or_siz[x]\
    \ < 0:\n            return x\n        else:\n            self.par_or_siz[x] =\
    \ self.root(self.par_or_siz[x])\n            return self.par_or_siz[x]\n    proc\
    \ issame*(self: UnionFind, x: int, y: int): bool =\n        return self.root(x)\
    \ == self.root(y)\n    proc unite*(self: UnionFind, x: int, y: int) =\n      \
    \  var x = self.root(x)\n        var y = self.root(y)\n        if(x != y):\n \
    \           if(self.par_or_siz[x] > self.par_or_siz[y]):\n                swap(x,\
    \ y)\n            self.par_or_siz[x] += self.par_or_siz[y]\n            self.par_or_siz[y]\
    \ = x\n            self.count -= 1\n    proc siz*(self: UnionFind, x: int): int\
    \ =\n        var x = self.root(x)\n        return -self.par_or_siz[x]\n    proc\
    \ roots*(self:UnionFind):seq[int]=\n        ## O(N)\u304B\u3051\u3066\u3001root\u306B\
    \u306A\u3063\u3066\u3044\u308B\u9802\u70B9\u3092\u5217\u6319\u3057\u307E\u3059\
    \u3002\n        ## \u6CE8\u610F:O(root\u6570)\u3067\u306A\u3044\u3053\u3068\u306B\
    \u6CE8\u610F\u3057\u3066\u304F\u3060\u3055\u3044\u3002\n        result = newSeqOfCap[int](self.count)\n\
    \        for i in 0..<len(self.par_or_siz):\n            if self.par_or_siz[i]\
    \ < 0:\n                result.add(i)"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/unionfind.nim
  requiredBy:
  - cplib/graph/merge_tree.nim
  - cplib/graph/merge_tree.nim
  timestamp: '2024-11-02 13:05:22+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/unionfind_test.nim
  - verify/collections/unionfind_test.nim
  - verify/graph/merge_tree_test.nim
  - verify/graph/merge_tree_test.nim
  - verify/tree/hld/hld_past202004o_test.nim
  - verify/tree/hld/hld_past202004o_test.nim
  - verify/itertools/itertools_combinations_test.nim
  - verify/itertools/itertools_combinations_test.nim
documentation_of: cplib/collections/unionfind.nim
layout: document
redirect_from:
- /library/cplib/collections/unionfind.nim
- /library/cplib/collections/unionfind.nim.html
title: cplib/collections/unionfind.nim
---
