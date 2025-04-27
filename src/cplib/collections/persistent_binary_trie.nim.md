---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/persistent_binary_trie_test.nim
    title: verify/collections/persistent_binary_trie_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/persistent_binary_trie_test.nim
    title: verify/collections/persistent_binary_trie_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/persistnt_binary_trie_unionfind_test.nim
    title: verify/collections/persistnt_binary_trie_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/persistnt_binary_trie_unionfind_test.nim
    title: verify/collections/persistnt_binary_trie_unionfind_test.nim
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
  code: "## --mm:arc\u63A8\u5968\u304B\u3082\u3002\nwhen not declared CPLIB_COLLECTIONS_PERSITENT_BINARY_TRIE:\n\
    \    const CPLIB_COLLECTION_PERSITENT_BINARY_TRIE* = 1\n    type PersistentBinaryTrieNode\
    \ = ref object\n        zero:PersistentBinaryTrieNode\n        one:PersistentBinaryTrieNode\n\
    \        value : int\n    type PersistentBinaryTrie* = object\n        root :\
    \ PersistentBinaryTrieNode\n        h: int\n\n    proc initPersistentBineryTrie*(h:int):PersistentBinaryTrie=\n\
    \        return PersistentBinaryTrie(root:PersistentBinaryTrieNode(),h:h)\n\n\
    \    proc incl*(self:PersistentBinaryTrie,x:Natural,v:int=1):PersistentBinaryTrie=\n\
    \        var now = PersistentBinaryTrieNode(zero:self.root.zero,one:self.root.one,value:self.root.value+v)\n\
    \        result.root = now\n        result.h = self.h\n        for i in countdown(self.h-1,0,1):\n\
    \            if (x and (1 shl i)) == 0:\n                if now.zero.isNil():\n\
    \                    now.zero = PersistentBinaryTrieNode(value:v)\n          \
    \      else:\n                    now.zero = PersistentBinaryTrieNode(zero:now.zero.zero,one:now.zero.one,value:now.zero.value+v)\n\
    \                now = now.zero\n            else:\n                if now.one.isNil():\n\
    \                    now.one = PersistentBinaryTrieNode(value:v)\n           \
    \     else:\n                    now.one = PersistentBinaryTrieNode(zero:now.one.zero,one:now.one.one,value:now.one.value+v)\n\
    \                now = now.one\n\n    proc excl*(self:PersistentBinaryTrie,x:Natural,v:int=1):PersistentBinaryTrie=\n\
    \        var now = PersistentBinaryTrieNode(zero:self.root.zero,one:self.root.one,value:self.root.value-v)\n\
    \        result.root = now\n        result.h = self.h\n        assert now.value\
    \ >= 0\n        for i in countdown(self.h-1,0,1):\n            if (x and (1 shl\
    \ i)) == 0:\n                assert not now.zero.isNil()\n                now.zero\
    \ = PersistentBinaryTrieNode(zero:now.zero.zero,one:now.zero.one,value:now.zero.value-v)\n\
    \                now = now.zero\n            else:\n                assert not\
    \ now.one.isNil()\n                now.one = PersistentBinaryTrieNode(zero:now.one.zero,one:now.one.one,value:now.one.value-v)\n\
    \                now = now.one\n            assert now.value >= 0\n    \n    proc\
    \ count*(self:PersistentBinaryTrie,x:Natural):int=\n        var now = self.root\n\
    \        for i in countdown(self.h-1,0,1):\n            if (x and (1 shl i)) ==\
    \ 0:\n                if now.zero.isNil():\n                    return 0\n   \
    \             now = now.zero\n            else:\n                if now.one.isNil():\n\
    \                    return 0\n                now = now.one\n        return now.value\n\
    \n    proc set_value*(self:PersistentBinaryTrie,x:Natural,v:int):PersistentBinaryTrie=\n\
    \        var cnt = self.count(x)\n        return self.incl(x,v-cnt)\n\n    proc\
    \ contains*(self:PersistentBinaryTrie,x:Natural):bool=\n        return self.count(x)\
    \ != 0\n\n    proc get_kth*(self:PersistentBinaryTrie,k:Natural,xor_value:int=0):int=\n\
    \        ## \u5B58\u5728\u3059\u308B\u306A\u3089\u3070\u5024\u3092\u8FD4\u3059\
    \n        ## \u3057\u306A\u3044\u306A\u3089\u3070-1\u3092\u8FD4\u3059\n      \
    \  var now = self.root\n        if now.value <= k:\n            return -1\n  \
    \      var cnt = 0\n        \n        for i in countdown(self.h-1,0,1):\n    \
    \        if now.zero.isNil():\n                now = now.one\n               \
    \ result = (result shl 1) or 1\n            elif now.one.isNil():\n          \
    \      now = now.zero\n                result = (result shl 1)\n            else:\n\
    \                if (xor_value and (1 shl i)) == 0:\n                    if cnt\
    \ + now.zero.value > k:\n                        now = now.zero\n            \
    \            result = (result shl 1)\n                    else:\n            \
    \            cnt += now.zero.value\n                        now = now.one\n  \
    \                      result = (result shl 1) or 1\n                else:\n \
    \                   if cnt + now.one.value > k:\n                        now =\
    \ now.one\n                        result = (result shl 1) or 1\n            \
    \        else:\n                        cnt += now.one.value\n               \
    \         now = now.zero\n                        result = (result shl 1) \n \
    \   \n    proc upperBound*(self:PersistentBinaryTrie,x:Natural):int=\n       \
    \ ## x\u4EE5\u4E0B\u306E\u8981\u7D20\u6570\n        var now = self.root\n    \
    \    for i in countdown(self.h-1,0,1):\n            if (x and (1 shl i)) == 0:\n\
    \                if now.zero.isNil():\n                    return result\n   \
    \             now = now.zero\n            else:\n                if not now.zero.isNil():\n\
    \                    result += now.zero.value\n                if now.one.isNil():\n\
    \                    return result\n                now = now.one\n        result\
    \ += now.value\n    proc lowerBound*(self:PersistentBinaryTrie,x:Natural):int=\n\
    \        ## x\u672A\u6E80\u306E\u8981\u7D20\u6570\n        var now = self.root\n\
    \        for i in countdown(self.h-1,0,1):\n            if (x and (1 shl i)) ==\
    \ 0:\n                if now.zero.isNil():\n                    return result\n\
    \                now = now.zero\n            else:\n                if not now.zero.isNil():\n\
    \                    result += now.zero.value\n                if now.one.isNil():\n\
    \                    return result\n                now = now.one\n    proc `[]`*(self:PersistentBinaryTrie,idx:Natural):int=\n\
    \        return self.get_kth(idx)\n\n    proc RLE*(self:PersistentBinaryTrie):seq[(int,int)]=\n\
    \        var S : seq[(int,int)]\n        proc dfs_node(self:PersistentBinaryTrieNode,now:int)=\n\
    \            if not self.zero.isNil():\n                dfs_node(self.zero,(now\
    \ shl 1))\n            if not self.one.isNil():\n                dfs_node(self.one,(now\
    \ shl 1) + 1)\n            if self.zero.isNil() and self.one.isNil():\n      \
    \          if self.value != 0:\n                    S.add((now,self.value))\n\
    \        dfs_node(self.root,0)\n        return S\n    proc `$`*(self:PersistentBinaryTrie):string=\n\
    \        return $(self.RLE())\n\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/persistent_binary_trie.nim
  requiredBy: []
  timestamp: '2024-09-21 18:34:12+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/persistnt_binary_trie_unionfind_test.nim
  - verify/collections/persistnt_binary_trie_unionfind_test.nim
  - verify/collections/persistent_binary_trie_test.nim
  - verify/collections/persistent_binary_trie_test.nim
documentation_of: cplib/collections/persistent_binary_trie.nim
layout: document
redirect_from:
- /library/cplib/collections/persistent_binary_trie.nim
- /library/cplib/collections/persistent_binary_trie.nim.html
title: cplib/collections/persistent_binary_trie.nim
---
