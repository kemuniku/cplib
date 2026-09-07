---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/wordsizetree_test.nim
    title: verify/AI/wordsizetree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/wordsizetree_test.nim
    title: verify/AI/wordsizetree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/word_size_tree_test.nim
    title: verify/collections/word_size_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/word_size_tree_test.nim
    title: verify/collections/word_size_tree_test.nim
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
  code: "## \u8A08\u7B97\u91CF\u3067\u306FN\u3092\u5165\u529B\u914D\u5217\u9577\u3001\
    U\u3092\u5BB9\u91CF2^24\u3068\u3057\u307E\u3059\u3002\u6728\u306E\u6BB5\u6570\u3068\
    \u6574\u6570\u306E\u30D3\u30C3\u30C8\u5E45\u306F\u56FA\u5B9A\u3067\u3059\u3002\
    \nwhen not declared CPLIB_COLLECTIONS_WORD_SIZE_TREE:\n    const CPLIB_COLLECTIONS_WORD_SIZE_TREE*\
    \ = 1\n    import bitops\n    type WordsizeTree = object\n        A0 : uint\n\
    \        A1 : array[64,uint]\n        A2 : array[64*64,uint]\n        A3 : array[64*64*64,uint]\n\
    \n    proc initWordsizeTree*():WordsizeTree=\n        ## \u7A7A\u306E\u30D3\u30C3\
    \u30C8\u96C6\u5408\u6728\u3092\u4F5C\u6210\u3057\u307E\u3059\u3002\u6642\u9593\
    \u8A08\u7B97\u91CF: O(U/64)\u3001\u623B\u308A\u5024\u306E\u7A7A\u9593: O(U/64)\uFF08\
    \u5168\u9818\u57DF\u306E\u30BC\u30ED\u521D\u671F\u5316\u3092\u542B\u3080\uFF09\
    \u3002\n        discard\n\n    proc initWordsizeTree*(v:openArray[bool]):WordsizeTree=\n\
    \        ## \u771F\u507D\u5024\u914D\u5217\u304B\u3089\u30D3\u30C3\u30C8\u96C6\
    \u5408\u6728\u3092\u4F5C\u6210\u3057\u307E\u3059\u3002\u6642\u9593\u8A08\u7B97\
    \u91CF: O(N + U/64)\u3001\u623B\u308A\u5024\u306E\u7A7A\u9593: O(U/64)\uFF08\u5168\
    \u9818\u57DF\u306E\u30BC\u30ED\u521D\u671F\u5316\u3092\u542B\u3080\uFF09\u3002\
    \n        # \u5404\u30D3\u30C3\u30C8\u306E\u5024\u306B\u3088\u308B\u5206\u5C90\
    \u3092\u907F\u3051\u300164\u30D3\u30C3\u30C8\u305A\u3064\u307E\u3068\u3081\u3066\
    \u683C\u7D0D\u3057\u307E\u3059\u3002\n        for blockIndex in 0..<((len(v) +\
    \ 63) shr 6):\n            let start = blockIndex shl 6\n            var bits\
    \ = 0u\n            for bit in 0..<min(64, len(v) - start):\n                bits\
    \ = bits or (uint(v[start + bit]) shl bit)\n            result.A3[blockIndex]\
    \ = bits\n        for i in 0..<((len(v)+(63)) shr 6):\n            if result.A3[i]\
    \ != 0:result.A2[i shr 6] = result.A2[i shr 6] or (1u shl (i and(0b111111)))\n\
    \        for i in 0..<((len(v)+(64*64-1)) shr 12):\n            if result.A2[i]\
    \ != 0:result.A1[i shr 6] = result.A1[i shr 6] or (1u shl (i and(0b111111)))\n\
    \        for i in 0..<((len(v)+(64*64*64-1)) shr 18):\n            if result.A1[i]\
    \ != 0:result.A0 = result.A0 or (1u shl (i and(0b111111)))\n\n\n    proc incl*(self:var\
    \ WordsizeTree,x:int)=\n        ## \u8981\u7D20x\u3092\u8FFD\u52A0\u3057\u307E\
    \u3059\u3002 \u6642\u9593\u8A08\u7B97\u91CF: O(1)\u3001\u8FFD\u52A0\u7A7A\u9593\
    : O(1)\u3002\n        var y = x and (0b111111)\n        var x = x shr 6\n    \
    \    self.A3[x] = self.A3[x] or (1u shl y)\n        y = x and (0b111111)\n   \
    \     x = x shr 6\n        self.A2[x] = self.A2[x] or (1u shl y)\n        y =\
    \ x and (0b111111)\n        x = x shr 6\n        self.A1[x] = self.A1[x] or (1u\
    \ shl y)\n        y = x and (0b111111)\n        x = x shr 6\n        self.A0 =\
    \ self.A0 or (1u shl y)\n\n    proc `[]`*(self:var WordsizeTree,x:int):bool=\n\
    \        ## \u8981\u7D20x\u304C\u542B\u307E\u308C\u3066\u3044\u308B\u304B\u3092\
    \u8FD4\u3057\u307E\u3059\u3002 \u6642\u9593\u8A08\u7B97\u91CF: O(1)\u3001\u8FFD\
    \u52A0\u7A7A\u9593: O(1)\u3002\n        var y = x and (0b111111)\n        var\
    \ x = x shr 6\n        return (self.A3[x] and (1u shl y)) != 0\n\n    proc excl*(self:var\
    \ WordsizeTree,x:int)=\n        ## \u8981\u7D20x\u3092\u524A\u9664\u3057\u307E\
    \u3059\u3002 \u6642\u9593\u8A08\u7B97\u91CF: O(1)\u3001\u8FFD\u52A0\u7A7A\u9593\
    : O(1)\u3002\n        if self[x]:\n            var y = x and (0b111111)\n    \
    \        var x = x shr 6\n            self.A3[x].clearBit(y)\n            if self.A3[x]\
    \ != 0:return\n            y = x and (0b111111)\n            x = x shr 6\n   \
    \         self.A2[x].clearBit(y)\n            if self.A2[x] != 0:return\n    \
    \        y = x and (0b111111)\n            x = x shr 6\n            self.A1[x].clearBit(y)\n\
    \            if self.A1[x] != 0:return\n            y = x and (0b111111)\n   \
    \         x = x shr 6\n            self.A0.clearBit(y)\n\n\n    proc ge*(self:var\
    \ WordsizeTree,x:int):int=\n        ## x\u4EE5\u4E0A\u306E\u6700\u5C0F\u306E\u8981\
    \u7D20\u3092\u8FD4\u3057\u3001\u5B58\u5728\u3057\u306A\u3051\u308C\u3070-1\u3092\
    \u8FD4\u3057\u307E\u3059\u3002 \u6642\u9593\u8A08\u7B97\u91CF: O(1)\u3001\u8FFD\
    \u52A0\u7A7A\u9593: O(1)\u3002\n        var y = x and (0b111111)\n        var\
    \ x = x shr 6\n        var t = self.A3[x] and (bitnot(0u) shl y)\n        if t\
    \ != 0:\n            return (x shl 6) or (t.firstSetBit()-1)\n        \n     \
    \   y = (x and (0b111111))+1\n        x = x shr 6\n        t = self.A2[x] and\
    \ (bitnot(0u) shl y)\n        if y != 64 and t != 0:\n            x = (x shl 6)\
    \ or (t.firstSetBit()-1)\n            return (x shl 6) or (self.A3[x].firstSetBit()-1)\n\
    \        \n        y = (x and (0b111111))+1\n        x = x shr 6\n        t =\
    \ self.A1[x] and (bitnot(0u) shl y)\n        if y != 64 and t != 0:\n        \
    \    x = (x shl 6) or (t.firstSetBit()-1)\n            x = (x shl 6) or (self.A2[x].firstSetBit()-1)\n\
    \            return (x shl 6) or (self.A3[x].firstSetBit()-1)\n        y = (x\
    \ and (0b111111))+1\n        x = x shr 6\n        t = self.A0 and (bitnot(0u)\
    \ shl y)\n        if y != 64 and t != 0:\n            x = (t.firstSetBit()-1)\n\
    \            x = (x shl 6) or (self.A1[x].firstSetBit()-1)\n            x = (x\
    \ shl 6) or (self.A2[x].firstSetBit()-1)\n            return (x shl 6) or (self.A3[x].firstSetBit()-1)\n\
    \        return -1\n\n    proc le*(self:var WordsizeTree,x:int):int=\n       \
    \ ## x\u4EE5\u4E0B\u306E\u6700\u5927\u306E\u8981\u7D20\u3092\u8FD4\u3057\u3001\
    \u5B58\u5728\u3057\u306A\u3051\u308C\u3070-1\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \ \u6642\u9593\u8A08\u7B97\u91CF: O(1)\u3001\u8FFD\u52A0\u7A7A\u9593: O(1)\u3002\
    \n        var y = 64-(x and (0b111111))-1\n        var x = x shr 6\n        var\
    \ t = self.A3[x] and (bitnot(0u) shr y)\n        if t != 0:\n            return\
    \ (x shl 6) or (t.fastLog2())\n        y = 64-((x and (0b111111)))\n        x\
    \ = x shr 6\n        t = self.A2[x] and (bitnot(0u) shr y)\n        if y != 64\
    \ and t != 0:\n            x = (x shl 6) or (t.fastLog2())\n            return\
    \ (x shl 6) or (self.A3[x].fastLog2())\n        y = 64-((x and (0b111111)))\n\
    \        x = x shr 6\n        t = self.A1[x] and (bitnot(0u) shr y)\n        if\
    \ y != 64 and t != 0:\n            x = (x shl 6) or (t.fastLog2())\n         \
    \   x = (x shl 6) or (self.A2[x].fastLog2())\n            return (x shl 6) or\
    \ (self.A3[x].fastLog2())\n        y = 64-((x and (0b111111)))\n        x = x\
    \ shr 6\n        t = self.A0 and (bitnot(0u) shr y)\n        if y != 64 and t\
    \ != 0:\n            x = (t.fastLog2())\n            x = (x shl 6) or (self.A1[x].fastLog2())\n\
    \            x = (x shl 6) or (self.A2[x].fastLog2())\n            return (x shl\
    \ 6) or (self.A3[x].fastLog2())\n        return -1\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/wordsizetree.nim
  requiredBy: []
  timestamp: '2026-09-08 05:12:42+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/word_size_tree_test.nim
  - verify/collections/word_size_tree_test.nim
  - verify/AI/wordsizetree_test.nim
  - verify/AI/wordsizetree_test.nim
documentation_of: cplib/collections/wordsizetree.nim
layout: document
redirect_from:
- /library/cplib/collections/wordsizetree.nim
- /library/cplib/collections/wordsizetree.nim.html
title: cplib/collections/wordsizetree.nim
---
