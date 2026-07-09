---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_array.nim
    title: cplib/collections/persistent_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_array.nim
    title: cplib/collections/persistent_array.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/persistent_unionfind_test.nim
    title: verify/AI/persistent_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/persistent_unionfind_test.nim
    title: verify/AI/persistent_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/persistent_unionfind_test.nim
    title: verify/collections/persistent_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/persistent_unionfind_test.nim
    title: verify/collections/persistent_unionfind_test.nim
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
  code: "\nwhen not declared CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND:\n    const CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND*\
    \ = 1\n    import algorithm, sequtils, bitops\n    import cplib/collections/persistent_array\n\
    \    type PersistentUnionFind* = ref object\n        count*: int\n        par_or_siz:\
    \ PersistentArray[6,int32]\n\n    proc initPersistentUnionFind*(N: int): PersistentUnionFind\
    \ =\n        result = PersistentUnionFind(count: N, par_or_siz: initPersistentArray(newseqwith(N,-1'i32),6))\n\
    \    proc root_i32(self: PersistentUnionFind, x: int): int32 =\n        var c\
    \ = self.par_or_siz[x]\n        if c < 0:\n            return x.int32\n      \
    \  else:\n            return self.root_i32(c.int)\n    proc root*(self: PersistentUnionFind,\
    \ x: int): int =\n        return self.root_i32(x).int\n    proc issame*(self:\
    \ PersistentUnionFind, x: int, y: int): bool =\n        return self.root_i32(x)\
    \ == self.root_i32(y)\n    proc unite*(self: PersistentUnionFind, x: int, y: int):\
    \ PersistentUnionFind =\n        var x = self.root_i32(x)\n        var y = self.root_i32(y)\n\
    \        result = PersistentUnionFind(count:self.count,par_or_siz:self.par_or_siz)\n\
    \        if(x != y):\n            if(result.par_or_siz[x.int] > result.par_or_siz[y.int]):\n\
    \                swap(x, y)\n            let xi = x.int\n            let yi =\
    \ y.int\n            result.par_or_siz = result.par_or_siz.change_value(xi,result.par_or_siz[xi]\
    \ + result.par_or_siz[yi])\n            result.par_or_siz = result.par_or_siz.change_value(yi,x)\n\
    \            result.count -= 1\n    proc siz*(self: PersistentUnionFind, x: int):\
    \ int =\n        var x = self.root_i32(x)\n        return (-(self.par_or_siz[x.int])).int\n"
  dependsOn:
  - cplib/collections/persistent_array.nim
  - cplib/collections/persistent_array.nim
  isVerificationFile: false
  path: cplib/collections/persistent_unionfind.nim
  requiredBy: []
  timestamp: '2026-07-09 02:51:42+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/persistent_unionfind_test.nim
  - verify/AI/persistent_unionfind_test.nim
  - verify/collections/persistent_unionfind_test.nim
  - verify/collections/persistent_unionfind_test.nim
documentation_of: cplib/collections/persistent_unionfind.nim
layout: document
redirect_from:
- /library/cplib/collections/persistent_unionfind.nim
- /library/cplib/collections/persistent_unionfind.nim.html
title: cplib/collections/persistent_unionfind.nim
---
