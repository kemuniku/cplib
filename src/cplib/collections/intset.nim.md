---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/intset_test.nim
    title: verify/AI/intset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/intset_test.nim
    title: verify/AI/intset_test.nim
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
  code: "## \u5B9F\u884C\u6642\u306B\u6307\u5B9A\u3057\u305F\u6574\u6570\u306E\u7BC4\
    \u56F2\u3092\u6271\u3046\u96C6\u5408\u3067\u3059\u3002U\u306F\u7BC4\u56F2\u306E\
    \u5E45\u3001k\u306F\u73FE\u5728\u306E\u8981\u7D20\u6570\u3067\u3059\u3002\n##\
    \ uint64\u306E\u30D3\u30C3\u30C8\u5217\u3068\u975E\u7A7A\u30D6\u30ED\u30C3\u30AF\
    \u306E\u53CC\u65B9\u5411\u30EA\u30B9\u30C8\u3092\u6301\u3061\u3001\u5358\u4E00\
    \u8981\u7D20\u306E\u64CD\u4F5C\u306F\u6700\u60AAO(1)\u3067\u3059\u3002\n## items\u306F\
    O(k + 1)\u3001\u6B21\u306E\u8981\u7D20\u306E\u53D6\u5F97\u306F\u6700\u60AAO(1)\u3067\
    \u3059\u3002\u5217\u6319\u9806\u306F\u4E0D\u5B9A\u3067\u3001\u5217\u6319\u4E2D\
    \u306E\u5909\u66F4\u306F\u3067\u304D\u307E\u305B\u3093\u3002\n## \u521D\u671F\u5316\
    \u306FO(1 + U / 64)\u3001\u30E1\u30E2\u30EA\u306Fceil(U / 64) * (8 + 2 * sizeof(int))\u30D0\
    \u30A4\u30C8\u3068\u5B9A\u6570\u9818\u57DF\u3067\u3059\u3002\n## \u7BC4\u56F2\u5916\
    \u306E\u5024\u306F\u542B\u307E\u308C\u305A\u3001\u524A\u9664\u306F\u4F55\u3082\
    \u3057\u307E\u305B\u3093\u3002\u7BC4\u56F2\u5916\u3078\u306E\u633F\u5165\u306F\
    IndexDefect\u306B\u306A\u308A\u307E\u3059\u3002\n## \u4F7F\u7528\u4F8B::\n## \
    \  import cplib/collections/intset\n##   var s = initIntSet(1000) # 0..<1000\n\
    ##   s.incl(42)\n##   s.incl(999)\n##   echo 42 in s\n##   for x in s:\n##   \
    \  echo x\n##   var t = initIntSet(-100..100)\n##   t.incl(-7)\nwhen not declared\
    \ CPLIB_COLLECTIONS_INTSET:\n    const CPLIB_COLLECTIONS_INTSET* = 1\n    import\
    \ bitops\n\n    type\n        IntSetBlock = object\n            bits: uint64\n\
    \            prev, next: int\n        IntSet* {.byref.} = object\n           \
    \ blocks: seq[IntSetBlock]\n            lower, size, count: int\n            head:\
    \ int\n\n    proc initIntSet*(size: int): IntSet =\n        ## 0..<size\u3092\u6271\
    \u3046\u7A7A\u96C6\u5408\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002size\u306F\u975E\
    \u8CA0\u3067\u3059\u3002O(1 + size / 64)\u3002\n        if size < 0:\n       \
    \     raise newException(ValueError, \"IntSet size must be non-negative\")\n \
    \       result.size = size\n        result.blocks = newSeq[IntSetBlock]((size\
    \ shr 6) + ord((size and 63) != 0))\n\n    proc initIntSet*(bounds: Slice[int]):\
    \ IntSet =\n        ## \u4E21\u7AEF\u3092\u542B\u3080bounds\u306E\u7BC4\u56F2\u3092\
    \u6271\u3046\u7A7A\u96C6\u5408\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\u9006\
    \u8EE2\u3057\u305F\u7BC4\u56F2\u306F\u7A7A\u3067\u3059\u3002O(1 + U / 64)\u3002\
    \n        if bounds.a <= bounds.b:\n            let span = cast[uint](bounds.b)\
    \ - cast[uint](bounds.a)\n            if span >= uint(high(int)):\n          \
    \      raise newException(ValueError, \"IntSet range is too wide\")\n        \
    \    result = initIntSet(int(span) + 1)\n        result.lower = bounds.a\n\n \
    \   proc len*(self: IntSet): int {.inline.} =\n        ## \u73FE\u5728\u306E\u8981\
    \u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        self.count\n\
    \n    proc offset(self: IntSet, x: int): int {.inline.} =\n        ## \u7BC4\u56F2\
    \u306E\u5148\u982D\u304B\u3089\u306E\u4F4D\u7F6E\u3092\u8FD4\u3057\u3001\u7BC4\
    \u56F2\u5916\u306A\u3089-1\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n   \
    \     if x < self.lower:\n            return -1\n        let delta = cast[uint](x)\
    \ - cast[uint](self.lower)\n        if delta >= uint(self.size):\n           \
    \ return -1\n        int(delta)\n\n    proc contains*(self: IntSet, x: int): bool\
    \ {.inline.} =\n        ## x\u304C\u542B\u307E\u308C\u308B\u304B\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\u7BC4\u56F2\u5916\u306Ffalse\u3067\u3059\u3002O(1)\u3002\n\
    \        let pos = self.offset(x)\n        pos >= 0 and (self.blocks[pos shr 6].bits\
    \ and (1'u64 shl (pos and 63))) != 0\n\n    proc containsOrIncl*(self: var IntSet,\
    \ x: int): bool =\n        ## x\u3092\u633F\u5165\u3057\u3001\u65E2\u306B\u542B\
    \u307E\u308C\u3066\u3044\u305F\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002\u7BC4\
    \u56F2\u5916\u306FIndexDefect\u3067\u3059\u3002O(1)\u3002\n        let pos = self.offset(x)\n\
    \        if pos < 0:\n            raise newException(IndexDefect, \"IntSet value\
    \ out of bounds\")\n        let i = pos shr 6\n        let mask = 1'u64 shl (pos\
    \ and 63)\n        if (self.blocks[i].bits and mask) != 0:\n            return\
    \ true\n        if self.blocks[i].bits == 0:\n            self.blocks[i].prev\
    \ = 0\n            self.blocks[i].next = self.head\n            if self.head !=\
    \ 0:\n                self.blocks[self.head - 1].prev = i + 1\n            self.head\
    \ = i + 1\n        self.blocks[i].bits = self.blocks[i].bits or mask\n       \
    \ inc self.count\n\n    proc incl*(self: var IntSet, x: int) {.inline.} =\n  \
    \      ## x\u3092\u633F\u5165\u3057\u307E\u3059\u3002\u91CD\u8907\u306F\u7121\u8996\
    \u3057\u3001\u7BC4\u56F2\u5916\u306FIndexDefect\u306B\u306A\u308A\u307E\u3059\u3002\
    O(1)\u3002\n        discard self.containsOrIncl(x)\n\n    proc missingOrExcl*(self:\
    \ var IntSet, x: int): bool =\n        ## x\u3092\u524A\u9664\u3057\u3001\u5143\
    \u3005\u542B\u307E\u308C\u3066\u3044\u306A\u304B\u3063\u305F\u304B\u3092\u8FD4\
    \u3057\u307E\u3059\u3002\u7BC4\u56F2\u5916\u3082true\u3067\u3059\u3002O(1)\u3002\
    \n        let pos = self.offset(x)\n        if pos < 0:\n            return true\n\
    \        let i = pos shr 6\n        let mask = 1'u64 shl (pos and 63)\n      \
    \  if (self.blocks[i].bits and mask) == 0:\n            return true\n        self.blocks[i].bits\
    \ = self.blocks[i].bits and not mask\n        dec self.count\n        if self.blocks[i].bits\
    \ == 0:\n            let prev = self.blocks[i].prev\n            let next = self.blocks[i].next\n\
    \            if prev == 0:\n                self.head = next\n            else:\n\
    \                self.blocks[prev - 1].next = next\n            if next != 0:\n\
    \                self.blocks[next - 1].prev = prev\n\n    proc excl*(self: var\
    \ IntSet, x: int) {.inline.} =\n        ## x\u3092\u524A\u9664\u3057\u307E\u3059\
    \u3002\u542B\u307E\u308C\u3066\u3044\u306A\u3044\u5024\u306B\u306F\u4F55\u3082\
    \u3057\u307E\u305B\u3093\u3002O(1)\u3002\n        discard self.missingOrExcl(x)\n\
    \n    iterator items*(self: IntSet): int =\n        ## \u8981\u7D20\u3092\u4EFB\
    \u610F\u9806\u306B\u5217\u6319\u3057\u307E\u3059\u3002\u5217\u6319\u4E2D\u306E\
    \u5909\u66F4\u306F\u4E0D\u53EF\u3067\u3059\u3002\u5168\u4F53O(k + 1)\u30011\u8981\
    \u7D20\u3042\u305F\u308AO(1)\u3002\n        var node = self.head\n        while\
    \ node != 0:\n            let i = node - 1\n            var bits = self.blocks[i].bits\n\
    \            while bits != 0:\n                yield self.lower + (i * 64 + countTrailingZeroBits(bits))\n\
    \                bits = bits and (bits - 1)\n            node = self.blocks[i].next\n\
    \n    proc pop*(self: var IntSet): int =\n        ## \u4EFB\u610F\u306E\u8981\u7D20\
    \u30921\u3064\u53D6\u308A\u51FA\u3057\u3066\u524A\u9664\u3057\u307E\u3059\u3002\
    \u7A7A\u96C6\u5408\u306FKeyError\u306B\u306A\u308A\u307E\u3059\u3002O(1)\u3002\
    \n        if self.count == 0:\n            raise newException(KeyError, \"IntSet\
    \ is empty\")\n        let i = self.head - 1\n        result = self.lower + (i\
    \ * 64 + countTrailingZeroBits(self.blocks[i].bits))\n        self.excl(result)\n\
    \n    proc clear*(self: var IntSet) =\n        ## \u7BC4\u56F2\u3068\u78BA\u4FDD\
    \u6E08\u307F\u9818\u57DF\u3092\u4FDD\u3063\u3066\u7A7A\u306B\u3057\u307E\u3059\
    \u3002\u975E\u7A7A\u30D6\u30ED\u30C3\u30AF\u6570\u3092B\u3068\u3057\u3066O(B +\
    \ 1)\u3002\n        var node = self.head\n        while node != 0:\n         \
    \   let i = node - 1\n            node = self.blocks[i].next\n            self.blocks[i]\
    \ = IntSetBlock()\n        self.head = 0\n        self.count = 0\n\n    proc toIntSet*(values:\
    \ openArray[int], size: int): IntSet =\n        ## values\u30920..<size\u306E\u96C6\
    \u5408\u306B\u5909\u63DB\u3057\u307E\u3059\u3002O(1 + size / 64 + values.len)\u3002\
    \n        result = initIntSet(size)\n        for x in values:\n            result.incl(x)\n\
    \n    proc toIntSet*(values: openArray[int], bounds: Slice[int]): IntSet =\n \
    \       ## values\u3092bounds\u306E\u7BC4\u56F2\u306E\u96C6\u5408\u306B\u5909\u63DB\
    \u3057\u307E\u3059\u3002O(1 + U / 64 + values.len)\u3002\n        result = initIntSet(bounds)\n\
    \        for x in values:\n            result.incl(x)\n\n    proc `==`*(a, b:\
    \ IntSet): bool =\n        ## \u7BC4\u56F2\u3084\u633F\u5165\u9806\u306B\u3088\
    \u3089\u305A\u8981\u7D20\u304C\u7B49\u3057\u3044\u304B\u3092\u8FD4\u3057\u307E\
    \u3059\u3002O(a.len + 1)\u3002\n        if a.len != b.len:\n            return\
    \ false\n        for x in a:\n            if x notin b:\n                return\
    \ false\n        true\n\n    proc `$`*(self: IntSet): string =\n        ## \u8981\
    \u7D20\u3092\u4EFB\u610F\u9806\u306B\u4E26\u3079\u305F\u6587\u5B57\u5217\u8868\
    \u73FE\u3092\u8FD4\u3057\u307E\u3059\u3002O(k + 1)\u3002\n        result = \"\
    {\"\n        for x in self:\n            if result.len > 1:\n                result.add(\"\
    , \")\n            result.add($x)\n        result.add('}')\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/intset.nim
  requiredBy: []
  timestamp: '2026-09-27 00:37:42+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/intset_test.nim
  - verify/AI/intset_test.nim
documentation_of: cplib/collections/intset.nim
layout: document
redirect_from:
- /library/cplib/collections/intset.nim
- /library/cplib/collections/intset.nim.html
title: cplib/collections/intset.nim
---
