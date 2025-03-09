---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/binary_trie_test.nim
    title: verify/collections/binary_trie_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/binary_trie_test.nim
    title: verify/collections/binary_trie_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_BINARY_TRIE:\n    const CPLIB_COLLECTION_BINARY_TRIE*\
    \ = 1\n    type BinaryTrieNode = ref object\n        zero:BinaryTrieNode\n   \
    \     one:BinaryTrieNode\n        value : int\n    type BinaryTrie = object\n\
    \        root : BinaryTrieNode\n        h: int\n\n\n    proc initBineryTrie*(h:int):BinaryTrie=\n\
    \        return BinaryTrie(root:BinaryTrieNode(),h:h)\n\n    proc incl*(self:BinaryTrie,x:Natural,v:int=1)=\n\
    \        var now = self.root\n        now.value += v\n        for i in countdown(self.h-1,0,1):\n\
    \            if (x and (1 shl i)) == 0:\n                if now.zero.isNil():\n\
    \                    now.zero = BinaryTrieNode()\n                now = now.zero\n\
    \            else:\n                if now.one.isNil():\n                    now.one\
    \ = BinaryTrieNode()\n                now = now.one\n            now.value +=\
    \ v\n\n    proc excl*(self:BinaryTrie,x:Natural,v:int=1)=\n        var now = self.root\n\
    \        now.value -= v\n        assert now.value >= 0\n        for i in countdown(self.h-1,0,1):\n\
    \            if (x and (1 shl i)) == 0:\n                if now.zero.isNil():\n\
    \                    now.zero = BinaryTrieNode()\n                now = now.zero\n\
    \            else:\n                if now.one.isNil():\n                    now.one\
    \ = BinaryTrieNode()\n                now = now.one\n            now.value -=\
    \ v\n            assert now.value >= 0\n\n    proc count*(self:BinaryTrie,x:Natural):int=\n\
    \        var now = self.root\n        for i in countdown(self.h-1,0,1):\n    \
    \        if (x and (1 shl i)) == 0:\n                if now.zero.isNil():\n  \
    \                  return 0\n                now = now.zero\n            else:\n\
    \                if now.one.isNil():\n                    return 0\n         \
    \       now = now.one\n        return now.value\n\n    proc contains*(self:BinaryTrie,x:Natural):bool=\n\
    \        return self.count(x) != 0\n\n    proc get_kth*(self:BinaryTrie,k:Natural,xor_value:int=0):int=\n\
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
    \   \n    proc upperBound*(self:BinaryTrie,x:Natural):int=\n        ## x\u4EE5\
    \u4E0B\u306E\u8981\u7D20\u6570\n        var now = self.root\n        for i in\
    \ countdown(self.h-1,0,1):\n            if (x and (1 shl i)) == 0:\n         \
    \       if now.zero.isNil():\n                    return result\n            \
    \    now = now.zero\n            else:\n                if not now.zero.isNil():\n\
    \                    result += now.zero.value\n                if now.one.isNil():\n\
    \                    return result\n                now = now.one\n        result\
    \ += now.value\n    proc lowerBound*(self:BinaryTrie,x:Natural):int=\n       \
    \ ## x\u672A\u6E80\u306E\u8981\u7D20\u6570\n        var now = self.root\n    \
    \    for i in countdown(self.h-1,0,1):\n            if (x and (1 shl i)) == 0:\n\
    \                if now.zero.isNil():\n                    return result\n   \
    \             now = now.zero\n            else:\n                if not now.zero.isNil():\n\
    \                    result += now.zero.value\n                if now.one.isNil():\n\
    \                    return result\n                now = now.one\n    proc `[]`*(self:BinaryTrie,idx:Natural):int=\n\
    \        return self.get_kth(idx)\n\n    proc `$`*(self:BinaryTrie):string=\n\
    \        var S : seq[(int,int)]\n        proc dfs_node(self:BinaryTrieNode,now:int)=\n\
    \            if not self.zero.isNil():\n                dfs_node(self.zero,(now\
    \ shl 1))\n            if not self.one.isNil():\n                dfs_node(self.one,(now\
    \ shl 1) + 1)\n            if self.zero.isNil() and self.one.isNil():\n      \
    \          if self.value != 0:\n                    S.add((now,self.value))\n\
    \        dfs_node(self.root,0)\n        return $S\n    \n    proc len*(self:BinaryTrie):int=\n\
    \        return self.root.value"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/binary_trie.nim
  requiredBy: []
  timestamp: '2025-03-09 17:40:43+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/binary_trie_test.nim
  - verify/collections/binary_trie_test.nim
documentation_of: cplib/collections/binary_trie.nim
layout: document
redirect_from:
- /library/cplib/collections/binary_trie.nim
- /library/cplib/collections/binary_trie.nim.html
title: cplib/collections/binary_trie.nim
---
