---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_ROOT_VALUE_UNIONFIND:\n    const CPLIB_COLLECTIONS_UNIONFIND*\
    \ = 1\n    import algorithm, sequtils\n    type RootValueUnionFind[T] = ref object\n\
    \        count*: int\n        par_or_siz: seq[int]\n        op : proc(x,y:var\
    \ T)\n        values* : seq[T]\n    proc initRootValueUnionFind*[T](N: int,op:(proc(x,y:var\
    \ T)),default:(proc():T)): RootValueUnionFind[T] =\n        ## op\u306B\u3064\u3044\
    \u3066\u3001x\u306E\u307B\u3046\u304C\u65B0\u3057\u304Froot\u306B\u306A\u308B\u3082\
    \u306E\u3068\u3059\u308B(\u3088\u3063\u3066\u3001x\u306E\u30B5\u30A4\u30BA\u306F\
    y\u306E\u30B5\u30A4\u30BA\u4EE5\u4E0A\u3067\u3042\u308B)\n        ## \u95A2\u6570\
    \u306Bvar\u3067\u4E0E\u3048\u3089\u308C\u308B\u306E\u3067\u3001\u95A2\u6570\u5185\
    \u3067x\u3092\u66F8\u304D\u63DB\u3048\u3066\u304F\u3060\u3055\u3044\n        ##\
    \ \u306A\u3093\u3067\u3053\u3046\u3057\u3066\u308B\u306E\uFF1F\u3000-> HashSet\u3068\
    \u304B\u3092\u8F09\u305B\u3066\u30DE\u30FC\u30B8\u3067\u304D\u308B\u3068\u5B09\
    \u3057\u3055\u304C\u3042\u308B\u306E\u3067\u3002\n        result = RootValueUnionFind[T](count:\
    \ N, par_or_siz: newSeqwith(N, -1),op:op,values:newseqwith(N,default()))\n   \
    \ proc initRootValueUnionFind*[T](N: int,op:(proc(x,y:var T)),default:T): RootValueUnionFind[T]\
    \ =\n        ## op\u306B\u3064\u3044\u3066\u3001x\u306E\u307B\u3046\u304C\u65B0\
    \u3057\u304Froot\u306B\u306A\u308B\u3082\u306E\u3068\u3059\u308B(\u3088\u3063\u3066\
    \u3001x\u306E\u30B5\u30A4\u30BA\u306Fy\u306E\u30B5\u30A4\u30BA\u4EE5\u4E0A\u3067\
    \u3042\u308B)\n        ## \u95A2\u6570\u306Bvar\u3067\u4E0E\u3048\u3089\u308C\u308B\
    \u306E\u3067\u3001\u95A2\u6570\u5185\u3067x\u3092\u66F8\u304D\u63DB\u3048\u3066\
    \u304F\u3060\u3055\u3044\n        ## \u306A\u3093\u3067\u3053\u3046\u3057\u3066\
    \u308B\u306E\uFF1F\u3000-> HashSet\u3068\u304B\u3092\u8F09\u305B\u3066\u30DE\u30FC\
    \u30B8\u3067\u304D\u308B\u3068\u5B09\u3057\u3055\u304C\u3042\u308B\u306E\u3067\
    \u3002\n        result = RootValueUnionFind[T](count: N, par_or_siz: newSeqwith(N,\
    \ -1),op:op,values:newseqwith(N,default))\n    proc initRootValueUnionFind*[T](N:\
    \ int,op:(proc(x,y:var T)),values:seq[T]): RootValueUnionFind[T] =\n        ##\
    \ op\u306B\u3064\u3044\u3066\u3001x\u306E\u307B\u3046\u304C\u65B0\u3057\u304F\
    root\u306B\u306A\u308B\u3082\u306E\u3068\u3059\u308B(\u3088\u3063\u3066\u3001\
    x\u306E\u30B5\u30A4\u30BA\u306Fy\u306E\u30B5\u30A4\u30BA\u4EE5\u4E0A\u3067\u3042\
    \u308B)\n        ## \u95A2\u6570\u306Bvar\u3067\u4E0E\u3048\u3089\u308C\u308B\u306E\
    \u3067\u3001\u95A2\u6570\u5185\u3067x\u3092\u66F8\u304D\u63DB\u3048\u3066\u304F\
    \u3060\u3055\u3044\n        ## \u306A\u3093\u3067\u3053\u3046\u3057\u3066\u308B\
    \u306E\uFF1F\u3000-> HashSet\u3068\u304B\u3092\u8F09\u305B\u3066\u30DE\u30FC\u30B8\
    \u3067\u304D\u308B\u3068\u5B09\u3057\u3055\u304C\u3042\u308B\u306E\u3067\u3002\
    \n        result = RootValueUnionFind[T](count: N, par_or_siz: newSeqwith(N, -1),op:op,values:values)\n\
    \    proc root*[T](self: RootValueUnionFind[T], x: int): int =\n        if self.par_or_siz[x]\
    \ < 0:\n            return x\n        else:\n            self.par_or_siz[x] =\
    \ self.root(self.par_or_siz[x])\n            return self.par_or_siz[x]\n    proc\
    \ issame*[T](self: RootValueUnionFind[T], x: int, y: int): bool =\n        return\
    \ self.root(x) == self.root(y)\n    proc unite*[T](self: RootValueUnionFind[T],\
    \ x: int, y: int) =\n        var x = self.root(x)\n        var y = self.root(y)\n\
    \        if(x != y):\n            if(self.par_or_siz[x] > self.par_or_siz[y]):\n\
    \                swap(x, y)\n            self.op(self.values[x],self.values[y])\n\
    \            self.par_or_siz[x] += self.par_or_siz[y]\n            self.par_or_siz[y]\
    \ = x\n            self.count -= 1\n    proc siz*[T](self: RootValueUnionFind[T],\
    \ x: int): int =\n        var x = self.root(x)\n        return -self.par_or_siz[x]\n\
    \    proc get*[T](self: RootValueUnionFind[T],x:int): var T=\n        return self.values[self.root(x)]\n\
    \    proc set*[T](self: RootValueUnionFind[T],x:int,value:T)=\n        self.values[self.root(x)]\
    \ = value\n\n\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/rootvalue_unionfind.nim
  requiredBy: []
  timestamp: '2024-09-21 22:43:30+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/rootvalue_unionfind.nim
layout: document
redirect_from:
- /library/cplib/collections/rootvalue_unionfind.nim
- /library/cplib/collections/rootvalue_unionfind.nim.html
title: cplib/collections/rootvalue_unionfind.nim
---
