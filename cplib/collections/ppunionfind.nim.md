---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/ppunionfind/past_ppuf_test.nim
    title: verify/collections/ppunionfind/past_ppuf_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/ppunionfind/past_ppuf_test.nim
    title: verify/collections/ppunionfind/past_ppuf_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/ppunionfind/stamp_rally_test.nim
    title: verify/collections/ppunionfind/stamp_rally_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/ppunionfind/stamp_rally_test.nim
    title: verify/collections/ppunionfind/stamp_rally_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/ppunionfind/yosupo_unionfind_test.nim
    title: verify/collections/ppunionfind/yosupo_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/ppunionfind/yosupo_unionfind_test.nim
    title: verify/collections/ppunionfind/yosupo_unionfind_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_PARTIALPERSISTENTUNIONFIND:\n    const\
    \ CPLIB_COLLECTIONS_PARTIALPERSISTENTUNIONFIND* = 1\n    import sequtils,algorithm\n\
    \    type PartialPersistentUnionFind* = object\n        par_or_siz : seq[int]\
    \ #0\u4EE5\u4E0A\u306E\u3068\u304D\u3001\u89AA\u306E\u9802\u70B9\u756A\u53F7\u3092\
    \u8868\u3059\u30020\u672A\u6E80\u306E\u3068\u304D\u3001-(\u96C6\u5408\u306E\u30B5\
    \u30A4\u30BA)\u3092\u8868\u3059\u3002\n        time : seq[int] # \u89AA\u3068\u306E\
    \u8FBA\u304C\u3064\u306A\u304C\u3063\u305F\u6642\u9593\u3092\u8868\u3059\u3002\
    -1\u306E\u3068\u304D\u3001root\u3067\u3042\u308B\u3002\n        size_time : seq[seq[int]]\n\
    \        size_value : seq[seq[int]] # \u3042\u308B\u6642\u70B9\u3067\u306E\u9802\
    \u70B9x\u304Croot\u3068\u306A\u308B\u96C6\u5408\u306E\u5927\u304D\u3055\n    \
    \    last : int \n\n    proc initPartialPersistentUnionFind*(N:int): PartialPersistentUnionFind=\n\
    \        result.par_or_siz = newSeqWith(N,-1)\n        result.time = newseqwith(N,-1)\n\
    \        result.size_time = newseqwith(N,@[-1])\n        result.size_value = newseqwith(N,@[1])\n\
    \        result.last = -1\n\n    proc root*(self:var PartialPersistentUnionFind,x:int,t:int):int=\n\
    \        var now = x\n        while self.time[now] != -1 and self.time[now] <=\
    \ t:\n            now = self.par_or_siz[now]\n        return now\n\n    proc root*(self:var\
    \ PartialPersistentUnionFind,x:int):int=\n        return self.root(x,self.last)\n\
    \n    proc unite*(self:var PartialPersistentUnionFind,u,v,t:int):bool {.discardable.}=\n\
    \        assert self.last < t\n        self.last = t\n        var u = self.root(u)\n\
    \        var v = self.root(v)\n        if u == v:\n            return false\n\
    \        if self.par_or_siz[u] > self.par_or_siz[v]:\n            swap(u,v)\n\
    \        self.par_or_siz[u] += self.par_or_siz[v]\n        self.par_or_siz[v]\
    \ = u\n        self.size_time[u].add(t)\n        self.size_value[u].add(-self.par_or_siz[u])\n\
    \        self.time[v] = t\n        return true\n\n    proc unite*(self:var PartialPersistentUnionFind,u,v:int):int\
    \ {.discardable.}=\n        self.unite(u,v,self.last+1)\n        return self.last\n\
    \n    proc issame*(self:var PartialPersistentUnionFind,u,v,t:int):bool=\n    \
    \    return self.root(u,t) == self.root(v,t)\n\n    proc issame*(self:var PartialPersistentUnionFind,u,v:int):bool=\n\
    \        return self.root(u) == self.root(v)\n\n    proc size*(self:var PartialPersistentUnionFind,x,t:int):int=\n\
    \        assert t >= -1\n        var x = self.root(x,t)\n        return self.size_value[x][self.size_time[x].upperBound(t)-1]\n\
    \n    proc size*(self:var PartialPersistentUnionFind,x:int):int=\n        return\
    \ self.size(x,self.last)\n\n    proc when_unite*(self:var PartialPersistentUnionFind,u,v:int):int=\n\
    \        ## \u9802\u70B9u\u3068v\u304C\u9023\u7D50\u306B\u306A\u3063\u305F\u6642\
    \u9593\u3092\u8FD4\u3059\u3002\n        ## \u9023\u7D50\u3067\u306F\u306A\u3044\
    \u5834\u5408\u3001-2\u304C\u8FD4\u308B(\u6700\u60AA\u304B\uFF1F \u6642\u523B-1\u3092\
    \u958B\u59CB\u306B\u3057\u3066\u3057\u307E\u3063\u305F\u305F\u3081\u4ED5\u65B9\
    \u306A\u304F...)\n        \n        var tu : seq[int]\n        var u = u\n   \
    \     var tv : seq[int]\n        var v = v\n        while self.time[u] != -1:\n\
    \            tu.add(self.time[u])\n            u = self.par_or_siz[u]\n      \
    \  while self.time[v] != -1:\n            tv.add(self.time[v])\n            v\
    \ = self.par_or_siz[v]\n        if u != v:\n            return -2\n        while\
    \ len(tu) > 0 and len(tv) > 0 and tu[^1] == tv[^1]:\n            discard tu.pop()\n\
    \            discard tv.pop()\n        result = -1\n        for t in tu:\n   \
    \         if t > result:\n                result = t\n        for t in tv:\n \
    \           if t > result:\n                result = t\n\n    proc size_ge(self:var\
    \ PartialPersistentUnionFind,x,size:int):int=\n        ## x\u304C\u5C5E\u3059\u308B\
    \u96C6\u5408\u306E\u30B5\u30A4\u30BA\u304Csize\u3092\u8D85\u3048\u308B\u6642\u9593\
    \u3092\u8FD4\u3059\n        if size <= 1:\n            return -1\n        var\
    \ now = x\n        while self.time[now] != -1:\n            now = self.par_or_siz[now]\n\
    \            if self.size_value[now][^1] >= size:\n                return self.size_time[now][self.size_value[now].lowerBound(size)]\n\
    \n\n\n\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/ppunionfind.nim
  requiredBy: []
  timestamp: '2024-09-19 01:13:36+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/ppunionfind/yosupo_unionfind_test.nim
  - verify/collections/ppunionfind/yosupo_unionfind_test.nim
  - verify/collections/ppunionfind/stamp_rally_test.nim
  - verify/collections/ppunionfind/stamp_rally_test.nim
  - verify/collections/ppunionfind/past_ppuf_test.nim
  - verify/collections/ppunionfind/past_ppuf_test.nim
documentation_of: cplib/collections/ppunionfind.nim
layout: document
redirect_from:
- /library/cplib/collections/ppunionfind.nim
- /library/cplib/collections/ppunionfind.nim.html
title: cplib/collections/ppunionfind.nim
---
