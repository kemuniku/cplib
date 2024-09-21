---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_binary_trie.nim
    title: cplib/collections/persistent_binary_trie.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_binary_trie.nim
    title: cplib/collections/persistent_binary_trie.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/persistent_unionfind
    links:
    - https://judge.yosupo.jp/problem/persistent_unionfind
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/persistent_unionfind\n\
    import cplib/collections/persistent_binary_trie\n\nwhen not declared CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND:\n\
    \    const CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND* = 1\n    import algorithm,\
    \ sequtils, bitops\n    type PersistentUnionFind* = ref object\n        count*:\
    \ int\n        par_or_siz: PersistentBinaryTrie\n    proc initPersistentUnionFind*(N:\
    \ int): PersistentUnionFind =\n        result = PersistentUnionFind(count: N,\
    \ par_or_siz: initPersistentBineryTrie(fastLog2(N)+1))\n    proc root*(self: PersistentUnionFind,\
    \ x: int): int =\n        var c = self.par_or_siz.count(x)-1\n        if c < 0:\n\
    \            return x\n        else:\n            return self.root(c)\n    proc\
    \ issame*(self: PersistentUnionFind, x: int, y: int): bool =\n        return self.root(x)\
    \ == self.root(y)\n    proc unite*(self: PersistentUnionFind, x: int, y: int):\
    \ PersistentUnionFind =\n        var x = self.root(x)\n        var y = self.root(y)\n\
    \        result = PersistentUnionFind(count:self.count,par_or_siz:self.par_or_siz)\n\
    \        if(x != y):\n            if(result.par_or_siz.count(x) > result.par_or_siz.count(y)):\n\
    \                swap(x, y)\n            result.par_or_siz = result.par_or_siz.incl(x,result.par_or_siz.count(y)-1)\n\
    \            result.par_or_siz = result.par_or_siz.set_value(y,x+1)\n        \
    \    result.count -= 1\n    proc siz*(self: PersistentUnionFind, x: int): int\
    \ =\n        var x = self.root(x)\n        return -(self.par_or_siz.count(x))\
    \ + 1\n\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc\
    \ ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\nimport tables\nvar N,Q\
    \ = ii()\nvar UFS : Table[int,PersistentUnionFind]\nUFS[-1] = initPersistentUnionFind(N)\n\
    for i in 0..<Q:\n    var t,k,u,v = ii()\n    if t == 0:\n        UFS[i] = UFS[k].unite(u,v)\n\
    \    else:\n        echo if UFS[k].issame(u,v):1 else:0\n"
  dependsOn:
  - cplib/collections/persistent_binary_trie.nim
  - cplib/collections/persistent_binary_trie.nim
  isVerificationFile: true
  path: verify/collections/persistnt_binary_trie_unionfind_test.nim
  requiredBy: []
  timestamp: '2024-09-21 18:34:12+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/persistnt_binary_trie_unionfind_test.nim
layout: document
redirect_from:
- /verify/verify/collections/persistnt_binary_trie_unionfind_test.nim
- /verify/verify/collections/persistnt_binary_trie_unionfind_test.nim.html
title: verify/collections/persistnt_binary_trie_unionfind_test.nim
---
