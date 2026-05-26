---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/collections/rootvalue_unionfind.nim
    title: cplib/collections/rootvalue_unionfind.nim
  - icon: ':warning:'
    path: cplib/collections/rootvalue_unionfind.nim
    title: cplib/collections/rootvalue_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_DYNAMIC_BIPARTITE_GRAPH:\n    const CPLIB_GRAPH_DYNAMIC_BIPARTITE_GRAPH*\
    \ = 1\n    import cplib/graph/graph\n    import sequtils,sugar\n    import cplib/collections/rootvalue_unionfind\n\
    \    \n    type DynamicBipartite = ref object\n        N : int\n        uf : RootValueUnionFind[int]\n\
    \        is_bipartite : bool\n        cnt_sum* : int\n\n    proc var_add_x_to_y(x,y:var\
    \ int)=\n        x += y\n    proc initDynamicBipartite*(N:int):DynamicBipartite=\
    \ \n        return DynamicBipartite(N:N,uf:initRootValueUnionFind(2*N,var_add_x_to_y,newseqwith(N,0)\
    \ & newseqwith(N,1)),is_bipartite:true,cnt_sum : N)\n    \n    proc can_unite*(self:DynamicBipartite,u,v:int):bool=\n\
    \        ## \u8FBA(u,v)\u3092\u65B0\u305F\u306B\u8FFD\u52A0\u3057\u305F\u3068\u304D\
    \u306B\u30B0\u30E9\u30D5\u304C\u4E8C\u90E8\u30B0\u30E9\u30D5\u304B\u3069\u3046\
    \u304B\u5224\u5B9A\u3059\u308B\n        ## \u65E2\u306B\u4E8C\u90E8\u30B0\u30E9\
    \u30D5\u3067\u306F\u306A\u3044\u5834\u5408\u306F\u5E38\u306Bfalse\u304C\u8FD4\u308B\
    \n        return self.is_bipartite and (not self.uf.issame(u,v))\n\n    proc unite*(self:DynamicBipartite,u,v:int)=\n\
    \        ## \u8FBA(u,v)\u306E\u8FFD\u52A0\n        if self.uf.issame(u,v+self.N)\
    \ or not self.is_bipartite:\n            return\n        if self.uf.issame(u,v):\n\
    \            self.is_bipartite = false\n            self.cnt_sum = -1\n      \
    \      return\n        var u = self.uf.root(u)\n        var v = self.uf.root(v)\n\
    \        self.cnt_sum -= max(self.uf.get(u),self.uf.get(u+self.N)) + max(self.uf.get(v),self.uf.get(v+self.N))\n\
    \        self.uf.unite(u,self.N+v)\n        self.uf.unite(v,self.N+u)\n      \
    \  self.cnt_sum += max(self.uf.get(u),self.uf.get(u+self.N))\n    \n    proc is_bipartite*(self:DynamicBipartite):bool=\n\
    \        return self.is_bipartite"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/collections/rootvalue_unionfind.nim
  - cplib/collections/rootvalue_unionfind.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/dynamic_bipartite.nim
  requiredBy: []
  timestamp: '2026-05-26 09:16:21+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/graph/dynamic_bipartite.nim
layout: document
redirect_from:
- /library/cplib/graph/dynamic_bipartite.nim
- /library/cplib/graph/dynamic_bipartite.nim.html
title: cplib/graph/dynamic_bipartite.nim
---
