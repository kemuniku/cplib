---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_unionfind.nim
    title: cplib/collections/persistent_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_unionfind.nim
    title: cplib/collections/persistent_unionfind.nim
  _extendedVerifiedWith:
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
  code: "when not declared CPLIB_COLLECTIONS_PERSISTENT_ARRAY:\n    const CPLIB_COLLECTIONS_PERSISTENT_ARRAY*\
    \ = 1\n    import bitops\n\n    type PersistentArrayNode*[shift:static int,T]\
    \ {.acyclic.} = ref object\n        arr :seq[PersistentArrayNode[shift,T]]\n \
    \       value: T\n\n    type PersistentArray*[shift:static int,T] = ref object\n\
    \        size : int\n        root : PersistentArrayNode[shift,T]\n        h:int\n\
    \n    proc initPersistentArray*[T](v:seq[T],shift:static int = 5):PersistentArray[shift,T]\
    \ =\n        var v = v\n        var bitsize = fastLog2(len(v))+1\n        var\
    \ h = (bitsize+shift-1) div shift\n        result = PersistentArray[shift,T]()\n\
    \        result.size = len(v)\n        result.root = PersistentArrayNode[shift,T]()\n\
    \        result.h = h\n        proc dfs[shift,T](node:PersistentArrayNode[shift,T],now:int,depth:int):bool=\n\
    \            if depth == h:\n                if now < len(v):\n              \
    \      node.value = v[now]\n                else:\n                    return\
    \ false\n            else:\n                for i in 0..<(1 shl shift):\n    \
    \                node.arr.add PersistentArrayNode[shift,T]()\n               \
    \     if not dfs(node.arr[i],(now shl shift) or i,depth+1):\n                \
    \        return false\n            return true\n        discard dfs[shift,T](result.root,0,0)\n\
    \n\n    proc toseq*[shift,T](PA:PersistentArray[shift,T]):seq[T]=\n        var\
    \ PA = PA\n        var v : seq[T]\n        proc dfs[shift,T](node:PersistentArrayNode[shift,T],now:int,depth:int):bool=\n\
    \            if depth == PA.h:\n                if now < PA.size:\n          \
    \          v.add node.value\n                else:\n                    return\
    \ false\n            else:\n                for i in 0..<(1 shl shift):\n    \
    \                if not dfs(node.arr[i],(now shl shift) or i,depth+1):\n     \
    \                   return false\n            return true\n        discard dfs(PA.root,0,0)\n\
    \        return v\n\n    proc `[]`*[shift,T](PA:PersistentArray[shift,T],index:Natural):T=\n\
    \        assert index in 0..<PA.size\n        var idx = index\n        var indexs\
    \ = newseq[int](PA.h)\n        for i in countdown(PA.h-1,0,1):\n            indexs[i]\
    \ = idx and ((1 shl shift)-1)\n            idx = idx shr shift\n        var now\
    \ = PA.root\n        for i in 0..<PA.h:\n            now = now.arr[indexs[i]]\n\
    \        return now.value\n\n    proc change_value*[shift,T](PA:PersistentArray[shift,T],index:Natural,value:T):PersistentArray[shift,T]=\n\
    \        assert index in 0..<PA.size\n        var idx = index\n        var indexs\
    \ = newseq[int](PA.h)\n        for i in countdown(PA.h-1,0,1):\n            indexs[i]\
    \ = idx and ((1 shl shift)-1)\n            idx = idx shr shift\n        var now\
    \ = PA.root\n        var stack : seq[PersistentArrayNode[shift,T]]\n        for\
    \ i in 0..<PA.h:\n            stack.add(now)\n            now = now.arr[indexs[i]]\n\
    \        now = PersistentArrayNode[shift,T](value:value)\n        for i in countdown(PA.h-1,0,1):\n\
    \            var tmp = PersistentArrayNode[shift,T](arr:stack[i].arr)\n      \
    \      tmp.arr[indexs[i]] = now\n            now = tmp\n        return PersistentArray[shift,T](root:now,size:PA.size,h:PA.h)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/persistent_array.nim
  requiredBy:
  - cplib/collections/persistent_unionfind.nim
  - cplib/collections/persistent_unionfind.nim
  timestamp: '2024-09-25 00:57:26+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/persistent_unionfind_test.nim
  - verify/collections/persistent_unionfind_test.nim
documentation_of: cplib/collections/persistent_array.nim
layout: document
redirect_from:
- /library/cplib/collections/persistent_array.nim
- /library/cplib/collections/persistent_array.nim.html
title: cplib/collections/persistent_array.nim
---
