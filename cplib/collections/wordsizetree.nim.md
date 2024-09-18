---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_WORD_SIZE_TREE:\n    const CPLIB_COLLECTIONS_WORD_SIZE_TREE*\
    \ = 1\n    import bitops\n    type WordsizeTree = object\n        A0 : uint\n\
    \        A1 : array[64,uint]\n        A2 : array[64*64,uint]\n        A3 : array[64*64*64,uint]\n\
    \n    proc initWordsizeTree*():WordsizeTree=\n        discard\n\n    proc initWordsizeTree*(v:seq[bool]):WordsizeTree=\n\
    \        for i in 0..<len(v):\n            if v[i]: result.A3[i shr 6] = result.A3[i\
    \ shr 6] or (1u shl (i and(0b111111)))\n        for i in 0..<((len(v)+(63)) shr\
    \ 6):\n            if result.A3[i] != 0:result.A2[i shr 6] = result.A2[i shr 6]\
    \ or (1u shl (i and(0b111111)))\n        for i in 0..<((len(v)+(64*64-1)) shr\
    \ 12):\n            if result.A2[i] != 0:result.A1[i shr 6] = result.A1[i shr\
    \ 6] or (1u shl (i and(0b111111)))\n        for i in 0..<((len(v)+(64*64*64-1))\
    \ shr 18):\n            if result.A1[i] != 0:result.A0 = result.A0 or (1u shl\
    \ (i and(0b111111)))\n\n\n    proc incl*(self:var WordsizeTree,x:int)=\n     \
    \   var y = x and (0b111111)\n        var x = x shr 6\n        self.A3[x] = self.A3[x]\
    \ or (1u shl y)\n        y = x and (0b111111)\n        x = x shr 6\n        self.A2[x]\
    \ = self.A2[x] or (1u shl y)\n        y = x and (0b111111)\n        x = x shr\
    \ 6\n        self.A1[x] = self.A1[x] or (1u shl y)\n        y = x and (0b111111)\n\
    \        x = x shr 6\n        self.A0 = self.A0 or (1u shl y)\n\n    proc `[]`*(self:var\
    \ WordsizeTree,x:int):bool=\n        var y = x and (0b111111)\n        var x =\
    \ x shr 6\n        return (self.A3[x] and (1u shl y)) != 0\n\n    proc excl*(self:var\
    \ WordsizeTree,x:int)=\n        if self[x]:\n            var y = x and (0b111111)\n\
    \            var x = x shr 6\n            self.A3[x].clearBit(y)\n           \
    \ if self.A3[x] != 0:return\n            y = x and (0b111111)\n            x =\
    \ x shr 6\n            self.A2[x].clearBit(y)\n            if self.A2[x] != 0:return\n\
    \            y = x and (0b111111)\n            x = x shr 6\n            self.A1[x].clearBit(y)\n\
    \            if self.A1[x] != 0:return\n            y = x and (0b111111)\n   \
    \         x = x shr 6\n            self.A0.clearBit(y)\n\n\n    proc ge*(self:var\
    \ WordsizeTree,x:int):int=\n        ## \u3042\u308Bbit\u4F4D\u7F6E\u3088\u308A\
    \u4E0A\u306E\u5834\u6240\u306B\u7ACB\u3063\u3066\u308Bbit\u3092\u8ABF\u3079\u305F\
    \u3044\n        var y = x and (0b111111)\n        var x = x shr 6\n        var\
    \ t = self.A3[x] and (bitnot(0u) shl y)\n        if t != 0:\n            return\
    \ (x shl 6) or (t.firstSetBit()-1)\n        \n        y = (x and (0b111111))+1\n\
    \        x = x shr 6\n        t = self.A2[x] and (bitnot(0u) shl y)\n        if\
    \ y != 64 and t != 0:\n            x = (x shl 6) or (t.firstSetBit()-1)\n    \
    \        return (x shl 6) or (self.A3[x].firstSetBit()-1)\n        \n        y\
    \ = (x and (0b111111))+1\n        x = x shr 6\n        t = self.A1[x] and (bitnot(0u)\
    \ shl y)\n        if y != 64 and t != 0:\n            x = (x shl 6) or (t.firstSetBit()-1)\n\
    \            x = (x shl 6) or (self.A2[x].firstSetBit()-1)\n            return\
    \ (x shl 6) or (self.A3[x].firstSetBit()-1)\n        y = (x and (0b111111))+1\n\
    \        x = x shr 6\n        t = self.A0 and (bitnot(0u) shl y)\n        if y\
    \ != 64 and t != 0:\n            x = (t.firstSetBit()-1)\n            x = (x shl\
    \ 6) or (self.A1[x].firstSetBit()-1)\n            x = (x shl 6) or (self.A2[x].firstSetBit()-1)\n\
    \            return (x shl 6) or (self.A3[x].firstSetBit()-1)\n        return\
    \ -1\n\n    proc le*(self:var WordsizeTree,x:int):int=\n        ## \u3042\u308B\
    bit\u4F4D\u7F6E\u3088\u308A\u4E0A\u306E\u5834\u6240\u306B\u7ACB\u3063\u3066\u308B\
    bit\u3092\u8ABF\u3079\u305F\u3044\n        var y = 64-(x and (0b111111))-1\n \
    \       var x = x shr 6\n        var t = self.A3[x] and (bitnot(0u) shr y)\n \
    \       if t != 0:\n            return (x shl 6) or (t.fastLog2())\n        y\
    \ = 64-((x and (0b111111)))\n        x = x shr 6\n        t = self.A2[x] and (bitnot(0u)\
    \ shr y)\n        if y != 64 and t != 0:\n            x = (x shl 6) or (t.fastLog2())\n\
    \            return (x shl 6) or (self.A3[x].fastLog2())\n        y = 64-((x and\
    \ (0b111111)))\n        x = x shr 6\n        t = self.A1[x] and (bitnot(0u) shr\
    \ y)\n        if y != 64 and t != 0:\n            x = (x shl 6) or (t.fastLog2())\n\
    \            x = (x shl 6) or (self.A2[x].fastLog2())\n            return (x shl\
    \ 6) or (self.A3[x].fastLog2())\n        y = 64-((x and (0b111111)))\n       \
    \ x = x shr 6\n        t = self.A0 and (bitnot(0u) shr y)\n        if y != 64\
    \ and t != 0:\n            x = (t.fastLog2())\n            x = (x shl 6) or (self.A1[x].fastLog2())\n\
    \            x = (x shl 6) or (self.A2[x].fastLog2())\n            return (x shl\
    \ 6) or (self.A3[x].fastLog2())\n        return -1"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/wordsizetree.nim
  requiredBy: []
  timestamp: '2024-09-15 02:30:26+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/word_size_tree_test.nim
  - verify/collections/word_size_tree_test.nim
documentation_of: cplib/collections/wordsizetree.nim
layout: document
redirect_from:
- /library/cplib/collections/wordsizetree.nim
- /library/cplib/collections/wordsizetree.nim.html
title: cplib/collections/wordsizetree.nim
---
