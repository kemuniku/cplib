---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/merge_tree_test.nim
    title: verify/graph/merge_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/merge_tree_test.nim
    title: verify/graph/merge_tree_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_MERGE_TREE:\n    const CPLIB_GRAPH_MERGE_TREE*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/collections/unionfind\n\
    \    import sequtils\n    type MergeTree* = object\n        ein : seq[int]\n \
    \       eout : seq[int]\n        et : seq[int]\n        ret : seq[int]\n     \
    \   tree : UnWeightedUnDirectedGraph\n        uf : UnionFind\n        now : seq[int]\n\
    \        N : int\n        alr_query : int\n        v:seq[(int,int)]\n    proc\
    \ initMergeTree*(N:int,v:seq[(int,int)]):MergeTree=\n        ## \u30AF\u30A8\u30EA\
    \u3092\u524D\u8AAD\u307F\u3059\u308B\u5FC5\u8981\u304C\u3042\u308B\u306E\u3067\
    \u3001\u9802\u70B9\u6570\u3068\u30DE\u30FC\u30B8\u3092\u914D\u5217\u3067\u4E0E\
    \u3048\u308B\n        var tree = initUnWeightedUnDirectedGraph(N+len(v)+1)\n \
    \       var uf = initUnionFind(N)\n        var now = newseqwith(N,0)\n       \
    \ for i in 0..<(N):\n            now[i] = i\n        for i in 0..<len(v):\n  \
    \          var (u,v) = v[i]\n            var x = now[uf.root(u)]\n           \
    \ var y = now[uf.root(v)]\n            \n            tree.add_edge(x,N+i)\n  \
    \          if x != y:\n                tree.add_edge(y,N+i)\n            uf.unite(u,v)\n\
    \            now[uf.root(u)] = N+i\n        var alr = newSeqWith(N,false)\n  \
    \      for i in 0..<N:\n            if not alr[uf.root(i)]:\n                alr[uf.root(i)]\
    \ = true\n                tree.add_edge(N+len(v),now[uf.root(i)])\n        var\
    \ ein = newseqwith(N+len(v)+1,-1)\n        var eout = newseqwith(N+len(v)+1,-1)\n\
    \        var et : seq[int]\n        proc dfs(x,p:int)=\n            ein[x] = len(et)\n\
    \            if x < N:\n                et.add(x)\n            for y in tree[x]:\n\
    \                if y != p:\n                    dfs(y,x)\n            eout[x]\
    \ = len(et)\n        dfs(N+len(v),-1)\n        result.tree = move(tree)\n    \
    \    result.ein = move(ein)\n        result.eout = move(eout)\n        result.et\
    \ = move(et)\n        result.ret = newseqwith(N,-1)\n        result.uf = initUnionFind(N)\n\
    \        result.now = newseqwith(N,0)\n        result.v = v\n        result.N\
    \ = N\n        for i in 0..<(N):\n            result.now[i] = i\n        for i\
    \ in 0..<N:\n            result.ret[result.et[i]] = i\n\n    proc unite*(self:var\
    \ MergeTree,u,v:int)=\n        ## \u9802\u70B9u,v\u3092\u30DE\u30FC\u30B8\u3059\
    \u308B\n        ## \u5148\u8AAD\u307F\u3067\u4E0E\u3048\u305F\u9806\u756A\u306B\
    unite\u3057\u3066\u304F\u3060\u3055\u3044\n        assert (self.v[self.alr_query][0]\
    \ == u or self.v[self.alr_query][0] == v) and (self.v[self.alr_query][1] == v\
    \ or self.v[self.alr_query][1] == u)\n        self.uf.unite(u,v)\n        self.now[self.uf.root(u)]\
    \ = self.N+self.alr_query\n        self.alr_query += 1\n\n    proc get_id*(self:var\
    \ MergeTree,x:int):int=\n        ## x\u304C\u73FE\u5728\u306E\u72B6\u614B\u3067\
    \u3069\u3053\u306E\u9802\u70B9\u3067\u8868\u3055\u308C\u308B\u96C6\u5408\u306B\
    \u5C5E\u3057\u3066\u3044\u308B\u304B\u3092\u8FD4\u3059\n        return self.now[self.uf.root(x)]\n\
    \n    proc get_range*(self:var MergeTree,x:int):HSlice[int,int]=\n        ## \u3042\
    \u308B\u96C6\u5408\u306B\u3064\u3044\u3066\u3001\u305D\u308C\u306B\u5C5E\u3057\
    \u3066\u3044\u308B\u9802\u70B9\u3092\u533A\u9593\u3067\u8FD4\u3059\n        return\
    \ (self.ein[self.now[self.uf.root(x)]]..<self.eout[self.now[self.uf.root(x)]])\n\
    \n    proc make_seq*[T](self:var MergeTree,v:seq[T]):seq[T]=\n        ## \u30AA\
    \u30A4\u30E9\u30FC\u30C4\u30A2\u30FC\u9806\u306B\u914D\u5217\u3092\u4E26\u3073\
    \u66FF\u3048\u308B\n        assert len(v) == self.N\n        result = newseq[T](len(v))\n\
    \        for i in 0..<self.N:\n            result[self.ret[i]] = v[i]\n\n    proc\
    \ restore_seq*[T](self:var MergeTree,v:seq[T]):seq[T]=\n        ## \u30AA\u30A4\
    \u30E9\u30FC\u30C4\u30A2\u30FC\u9806\u306B\u306A\u3063\u3066\u3044\u308B\u914D\
    \u5217\u3092\u3082\u3068\u306B\u623B\u3059\n        assert len(v) == self.N\n\
    \        result = newseq[T](len(v))\n        for i in 0..<self.N:\n          \
    \  result[self.et[i]] = v[i]\n\n    proc index*(self:var MergeTree,x:int):int=\n\
    \        ## \u30AA\u30A4\u30E9\u30FC\u30C4\u30A2\u30FC\u9806\u3067x\u306F\u4F55\
    \u756A\u76EE\u304B\u3092\u8FD4\u3059\n        self.ret[x]"
  dependsOn:
  - cplib/collections/unionfind.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/collections/unionfind.nim
  isVerificationFile: false
  path: cplib/graph/merge_tree.nim
  requiredBy: []
  timestamp: '2024-10-21 02:50:20+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/merge_tree_test.nim
  - verify/graph/merge_tree_test.nim
documentation_of: cplib/graph/merge_tree.nim
layout: document
redirect_from:
- /library/cplib/graph/merge_tree.nim
- /library/cplib/graph/merge_tree.nim.html
title: cplib/graph/merge_tree.nim
---
