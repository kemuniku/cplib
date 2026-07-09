---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/weightedunionfind_test.nim
    title: verify/AI/weightedunionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/weightedunionfind_test.nim
    title: verify/AI/weightedunionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/WeightedUnionFind_test.nim
    title: verify/collections/WeightedUnionFind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/WeightedUnionFind_test.nim
    title: verify/collections/WeightedUnionFind_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_WEIGHTED_UNIONFIND:\n    const CPLIB_COLLECTIONS_WEIGHTED_UNIONFIND*\
    \ = 1\n    import algorithm\n    import sequtils\n    type WeightedUnionFind*[T]\
    \ = ref object\n        count*: int\n        par_or_siz: seq[int32]\n        potential_diff\
    \ : seq[T]\n    proc initWeightedUnionFind*(N: int,potential_type : typedesc =\
    \ int): WeightedUnionFind[potential_type] =\n        result = WeightedUnionFind[potential_type](count:\
    \ N, par_or_siz: newSeqwith(N, -1'i32),potential_diff:newseqwith(N,0.potential_type))\n\
    \    proc root_i32[T](self: WeightedUnionFind[T], x: int): int32 =\n        if\
    \ self.par_or_siz[x] < 0:\n            return x.int32\n        else:\n       \
    \     let p = self.par_or_siz[x].int\n            var r = self.root_i32(p)\n \
    \           self.potential_diff[x] += self.potential_diff[p]\n            self.par_or_siz[x]\
    \ = r\n            return r\n    proc root*[T](self: WeightedUnionFind[T], x:\
    \ int): int =\n        return self.root_i32(x).int\n    proc potential*[T](self:WeightedUnionFind[T],x:int):T=\n\
    \        discard self.root_i32(x)\n        return self.potential_diff[x]\n   \
    \ proc issame*[T](self: WeightedUnionFind[T], x: int, y: int): bool =\n      \
    \  return self.root_i32(x) == self.root_i32(y)\n    proc diff*[T](self:WeightedUnionFind[T],x,y:int):T=\n\
    \        assert self.root_i32(x) == self.root_i32(y)\n        return self.potential_diff[y]-self.potential_diff[x]\n\
    \    proc unite*[T](self: WeightedUnionFind[T], x: int, y: int, w:T):bool=\n \
    \       ## potential[y]-potential[x] = w\u3068\u306A\u308B\u3088\u3046\u306B\u8FBA\
    \u3092\u5F35\u308A\u307E\u3059\n        ## \u6B63\u3057\u304F\u8FBA\u304C\u5F35\
    \u308C\u308B\u306A\u3089\u3070\u3001true,\u305D\u3046\u3067\u306A\u3044\u306A\u3089\
    \u3070false\u3092\u8FD4\u3057\u307E\u3059\n        var w = w + self.potential(x)\
    \ - self.potential(y)\n        var x = self.root_i32(x)\n        var y = self.root_i32(y)\n\
    \        if(x != y):\n            if(self.par_or_siz[x.int] > self.par_or_siz[y.int]):\n\
    \                swap(x, y)\n                w = -w\n            let xi = x.int\n\
    \            let yi = y.int\n            self.par_or_siz[xi] += self.par_or_siz[yi]\n\
    \            self.par_or_siz[yi] = x\n            self.count -= 1\n          \
    \  self.potential_diff[yi] = w\n            return true\n        else:\n     \
    \       return w == 0\n    proc siz*[T](self: WeightedUnionFind[T], x: int): int\
    \ =\n        var x = self.root_i32(x)\n        return (-self.par_or_siz[x.int]).int\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/weightedunionfind.nim
  requiredBy: []
  timestamp: '2026-07-09 02:51:42+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/weightedunionfind_test.nim
  - verify/AI/weightedunionfind_test.nim
  - verify/collections/WeightedUnionFind_test.nim
  - verify/collections/WeightedUnionFind_test.nim
documentation_of: cplib/collections/weightedunionfind.nim
layout: document
redirect_from:
- /library/cplib/collections/weightedunionfind.nim
- /library/cplib/collections/weightedunionfind.nim.html
title: cplib/collections/weightedunionfind.nim
---
