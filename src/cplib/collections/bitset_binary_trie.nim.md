---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_binary_trie_test.nim
    title: verify/AI/bitset_binary_trie_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_binary_trie_test.nim
    title: verify/AI/bitset_binary_trie_test.nim
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
  code: "## \u56FA\u5B9A\u3057\u305F\u30D3\u30C3\u30C8\u6570\u306Ebitset\u3092\u30AD\
    \u30FC\u306B\u3059\u308B\u591A\u91CD\u96C6\u5408\u3067\u3059\u3002bitset\u306E\
    \u30E2\u30B8\u30E5\u30FC\u30EB\u3068\u4F75\u305B\u3066import\u3057\u307E\u3059\
    \u3002\n## \u901A\u5E38\u30FBAVX2\u30FBAVX512\u306E\u52D5\u7684\u7248\u3068\u56FA\
    \u5B9A\u9577\u7248\u306B\u5BFE\u5FDC\u3057\u3001\u6DFB\u5B570\u304B\u3089false\
    \ < true\u306E\u8F9E\u66F8\u9806\u3067\u6271\u3044\u307E\u3059\u3002\n## N\u306F\
    \u30AD\u30FC\u306E\u30D3\u30C3\u30C8\u6570\u3067\u3059\u3002\u5404\u64CD\u4F5C\
    \u306FO(1 + N)\uFF08\u633F\u5165\u306F\u511F\u5374\uFF09\u3001len\u306FO(1)\u3067\
    \u3059\u3002\n## \u5206\u5C90\u3092\u9806\u306B\u305F\u3069\u308B\u305F\u3081\
    SIMD\u547D\u4EE4\u306F\u4F7F\u7528\u3057\u307E\u305B\u3093\u3002\n## \u30CE\u30FC\
    \u30C9\u306F\u914D\u5217\u306B\u4FDD\u6301\u3057\u3001\u524A\u9664\u3067\u4E0D\
    \u8981\u306B\u306A\u3063\u305F\u30CE\u30FC\u30C9\u3092\u518D\u5229\u7528\u3057\
    \u307E\u3059\u3002\u30AD\u30FC\u306F\u8449\u3060\u3051\u306B\u30B3\u30D4\u30FC\
    \u3057\u3066\u4FDD\u6301\u3057\u307E\u3059\u3002\n## \u30CE\u30FC\u30C9\u9818\u57DF\
    \u306F\u904E\u53BB\u306E\u6700\u5927\u4F7F\u7528\u6570\u306B\u6BD4\u4F8B\u3057\
    \u307E\u3059\u3002\u5727\u7E2E\u30C8\u30E9\u30A4\u3067\u306F\u306A\u3044\u305F\
    \u3081\u30011\u30AD\u30FC\u306E\u633F\u5165\u3067\u6700\u5927N\u30CE\u30FC\u30C9\
    \u3092\u8FFD\u52A0\u3057\u307E\u3059\u3002\n## \u4F7F\u7528\u4F8B::\n##   import\
    \ cplib/collections/bitset\n##   import cplib/collections/bitset_binary_trie\n\
    ##   var trie = initBitSetBinaryTrie[BitSet](128)\n##   var key = initBitSet(128)\n\
    ##   key[0] = true\n##   trie.incl(key, 2)\n##   trie.excl(key)\n##   doAssert\
    \ trie.count(key) == 1\nwhen not declared CPLIB_COLLECTIONS_BITSET_BINARY_TRIE:\n\
    \    const CPLIB_COLLECTIONS_BITSET_BINARY_TRIE* = 1\n\n    type\n        BitSetTrieNode[T]\
    \ = object\n            children: array[2, int]\n            count: int\n    \
    \        key: ref T\n        BitSetBinaryTrie*[T] = object\n            nodes:\
    \ seq[BitSetTrieNode[T]]\n            freeNodes: seq[int]\n            h: int\n\
    \n    proc initBitSetBinaryTrie*[T](h: int): BitSetBinaryTrie[T] =\n        ##\
    \ h\u30D3\u30C3\u30C8\u306E\u30AD\u30FC\u3092\u6271\u3046\u7A7A\u306E\u591A\u91CD\
    \u96C6\u5408\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002O(1)\u3002\n        if h\
    \ < 0:\n            raise newException(ValueError, \"BitSet length must be non-negative\"\
    )\n        result.h = h\n        result.nodes = @[BitSetTrieNode[T](children:\
    \ [-1, -1])]\n\n    proc initBitSetBinaryTrie*[T](sample: T): BitSetBinaryTrie[T]\
    \ =\n        ## sample\u3068\u540C\u3058\u578B\u30FB\u9577\u3055\u306E\u30AD\u30FC\
    \u3092\u6271\u3046\u7A7A\u96C6\u5408\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\
    sample\u306F\u633F\u5165\u3057\u307E\u305B\u3093\u3002O(1)\u3002\n        mixin\
    \ len\n        initBitSetBinaryTrie[T](sample.len)\n\n    proc len*[T](self: BitSetBinaryTrie[T]):\
    \ int {.inline.} =\n        ## \u91CD\u8907\u3092\u542B\u3081\u305F\u8981\u7D20\
    \u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        if self.nodes.len\
    \ == 0: 0 else: self.nodes[0].count\n\n    proc checkKey[T](self: BitSetBinaryTrie[T],\
    \ x: T) {.inline.} =\n        ## \u521D\u671F\u5316\u6E08\u307F\u3067\u3042\u308B\
    \u3053\u3068\u3068\u30AD\u30FC\u306E\u9577\u3055\u3092\u691C\u8A3C\u3057\u307E\
    \u3059\u3002O(1)\u3002\n        mixin len\n        if self.nodes.len == 0:\n \
    \           raise newException(ValueError, \"BitSetBinaryTrie is not initialized\"\
    )\n        if x.len != self.h:\n            raise newException(ValueError, \"\
    BitSet length must match trie height\")\n\n    proc count*[T](self: BitSetBinaryTrie[T],\
    \ x: T): int =\n        ## x\u306E\u91CD\u8907\u6570\u3092\u8FD4\u3057\u307E\u3059\
    \u3002O(1 + N)\u3002\n        mixin `[]`\n        self.checkKey(x)\n        var\
    \ node = 0\n        for i in 0..<self.h:\n            node = self.nodes[node].children[ord(x[i])]\n\
    \            if node < 0:\n                return 0\n        self.nodes[node].count\n\
    \n    proc contains*[T](self: BitSetBinaryTrie[T], x: T): bool =\n        ## x\u304C\
    1\u500B\u4EE5\u4E0A\u5B58\u5728\u3059\u308B\u304B\u3092\u8FD4\u3057\u307E\u3059\
    \u3002O(1 + N)\u3002\n        self.count(x) > 0\n\n    proc newNode[T](self: var\
    \ BitSetBinaryTrie[T]): int =\n        ## \u7A7A\u304D\u30CE\u30FC\u30C9\u3092\
    \u518D\u5229\u7528\u3057\u3001\u306A\u3051\u308C\u3070\u8FFD\u52A0\u3057\u307E\
    \u3059\u3002\u511F\u5374O(1)\u3002\n        if self.freeNodes.len > 0:\n     \
    \       result = self.freeNodes.pop()\n        else:\n            result = self.nodes.len\n\
    \            self.nodes.add(BitSetTrieNode[T](children: [-1, -1]))\n\n    proc\
    \ incl*[T](self: var BitSetBinaryTrie[T], x: T, v: int = 1) =\n        ## x\u3092\
    v\u500B\u633F\u5165\u3057\u307E\u3059\u3002v\u306F\u975E\u8CA0\u3067\u3059\u3002\
    \u511F\u5374O(1 + N)\u3002\n        mixin `[]`\n        self.checkKey(x)\n   \
    \     if v < 0:\n            raise newException(ValueError, \"Multiplicity must\
    \ be non-negative\")\n        if v > high(int) - self.len:\n            raise\
    \ newException(OverflowDefect, \"BitSetBinaryTrie size overflow\")\n        if\
    \ v == 0:\n            return\n        var node = 0\n        self.nodes[node].count\
    \ += v\n        for i in 0..<self.h:\n            let bit = ord(x[i])\n      \
    \      if self.nodes[node].children[bit] < 0:\n                let child = self.newNode()\n\
    \                self.nodes[node].children[bit] = child\n            node = self.nodes[node].children[bit]\n\
    \            self.nodes[node].count += v\n        if self.nodes[node].key.isNil:\n\
    \            new(self.nodes[node].key)\n            self.nodes[node].key[] = x\n\
    \n    proc excl*[T](self: var BitSetBinaryTrie[T], x: T, v: int = 1) =\n     \
    \   ## x\u3092v\u500B\u524A\u9664\u3057\u307E\u3059\u3002\u4E0D\u8DB3\u30FB\u8CA0\
    \u306Ev\u306F\u5909\u66F4\u305B\u305AValueError\u306B\u3057\u307E\u3059\u3002\
    O(1 + N)\u3002\n        mixin `[]`\n        self.checkKey(x)\n        if v < 0:\n\
    \            raise newException(ValueError, \"Multiplicity must be non-negative\"\
    )\n        if v == 0:\n            return\n        var path = @[0]\n        for\
    \ i in 0..<self.h:\n            let child = self.nodes[path[^1]].children[ord(x[i])]\n\
    \            if child < 0:\n                raise newException(ValueError, \"\
    Not enough copies of key\")\n            path.add(child)\n        if self.nodes[path[^1]].count\
    \ < v:\n            raise newException(ValueError, \"Not enough copies of key\"\
    )\n        for node in path:\n            self.nodes[node].count -= v\n      \
    \  if self.nodes[path[^1]].count == 0:\n            self.nodes[path[^1]].key =\
    \ nil\n        for i in countdown(self.h, 1):\n            let node = path[i]\n\
    \            if self.nodes[node].count != 0:\n                break\n        \
    \    self.nodes[path[i - 1]].children[ord(x[i - 1])] = -1\n            self.nodes[node]\
    \ = BitSetTrieNode[T](children: [-1, -1])\n            self.freeNodes.add(node)\n\
    \n    proc kth[T](self: BitSetBinaryTrie[T], k: Natural, mask: ptr T): T =\n \
    \       ## XOR\u5F8C\u306E\u8F9E\u66F8\u9806\u30670\u59CB\u307E\u308Ak\u756A\u76EE\
    \u306E\u5143\u306E\u30AD\u30FC\u3092\u8FD4\u3057\u307E\u3059\u3002O(1 + N)\u3002\
    \n        mixin `[]`\n        if k >= self.len:\n            raise newException(IndexDefect,\
    \ \"BitSetBinaryTrie index out of bounds\")\n        var node = 0\n        var\
    \ remaining = int(k)\n        for i in 0..<self.h:\n            let first = if\
    \ mask.isNil: 0 else: ord(mask[][i])\n            let child = self.nodes[node].children[first]\n\
    \            let firstCount = if child < 0: 0 else: self.nodes[child].count\n\
    \            if remaining < firstCount:\n                node = child\n      \
    \      else:\n                remaining -= firstCount\n                node =\
    \ self.nodes[node].children[1 - first]\n        result = self.nodes[node].key[]\n\
    \n    proc get_kth*[T](self: BitSetBinaryTrie[T], k: Natural): T =\n        ##\
    \ \u8F9E\u66F8\u9806\u30670\u59CB\u307E\u308Ak\u756A\u76EE\u306E\u30AD\u30FC\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\u7BC4\u56F2\u5916\u306FIndexDefect\u3067\u3059\u3002\
    O(1 + N)\u3002\n        self.kth(k, nil)\n\n    proc get_kth*[T](self: BitSetBinaryTrie[T],\
    \ k: Natural, xor_value: T): T =\n        ## xor_value\u3068\u306EXOR\u5F8C\u306E\
    \u8F9E\u66F8\u9806\u3067k\u756A\u76EE\u306E\u5143\u306E\u30AD\u30FC\u3092\u8FD4\
    \u3057\u307E\u3059\u3002\u7BC4\u56F2\u5916\u306FIndexDefect\u3067\u3059\u3002\
    O(1 + N)\u3002\n        self.checkKey(xor_value)\n        self.kth(k, unsafeAddr\
    \ xor_value)\n\n    proc `[]`*[T](self: BitSetBinaryTrie[T], k: Natural): T =\n\
    \        ## \u8F9E\u66F8\u9806\u30670\u59CB\u307E\u308Ak\u756A\u76EE\u306E\u30AD\
    \u30FC\u3092\u8FD4\u3057\u307E\u3059\u3002\u7BC4\u56F2\u5916\u306FIndexDefect\u3067\
    \u3059\u3002O(1 + N)\u3002\n        self.get_kth(k)\n\n    proc bound[T](self:\
    \ BitSetBinaryTrie[T], x: T, mask: ptr T, inclusive: bool): int =\n        ##\
    \ XOR\u5F8C\u306E\u30AD\u30FC\u304Cx\u672A\u6E80\uFF08inclusive\u306A\u3089\u4EE5\
    \u4E0B\uFF09\u306E\u500B\u6570\u3092\u6C42\u3081\u307E\u3059\u3002O(1 + N)\u3002\
    \n        mixin `[]`\n        self.checkKey(x)\n        var node = 0\n       \
    \ for i in 0..<self.h:\n            let first = if mask.isNil: 0 else: ord(mask[][i])\n\
    \            let bit = ord(x[i])\n            if bit == 1:\n                let\
    \ child = self.nodes[node].children[first]\n                if child >= 0:\n \
    \                   result += self.nodes[child].count\n            node = self.nodes[node].children[first\
    \ xor bit]\n            if node < 0:\n                return\n        if inclusive:\n\
    \            result += self.nodes[node].count\n\n    proc lowerBound*[T](self:\
    \ BitSetBinaryTrie[T], x: T): int =\n        ## \u8F9E\u66F8\u9806\u3067x\u672A\
    \u6E80\u306E\u8981\u7D20\u6570\u3092\u91CD\u8907\u8FBC\u307F\u3067\u8FD4\u3057\
    \u307E\u3059\u3002O(1 + N)\u3002\n        self.bound(x, nil, false)\n\n    proc\
    \ upperBound*[T](self: BitSetBinaryTrie[T], x: T): int =\n        ## \u8F9E\u66F8\
    \u9806\u3067x\u4EE5\u4E0B\u306E\u8981\u7D20\u6570\u3092\u91CD\u8907\u8FBC\u307F\
    \u3067\u8FD4\u3057\u307E\u3059\u3002O(1 + N)\u3002\n        self.bound(x, nil,\
    \ true)\n\n    proc lowerBound*[T](self: BitSetBinaryTrie[T], x, xor_value: T):\
    \ int =\n        ## xor_value\u3068\u306EXOR\u5F8C\u306E\u30AD\u30FC\u304Cx\u672A\
    \u6E80\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1 + N)\u3002\
    \n        self.checkKey(xor_value)\n        self.bound(x, unsafeAddr xor_value,\
    \ false)\n\n    proc upperBound*[T](self: BitSetBinaryTrie[T], x, xor_value: T):\
    \ int =\n        ## xor_value\u3068\u306EXOR\u5F8C\u306E\u30AD\u30FC\u304Cx\u4EE5\
    \u4E0B\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1 + N)\u3002\
    \n        self.checkKey(xor_value)\n        self.bound(x, unsafeAddr xor_value,\
    \ true)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/bitset_binary_trie.nim
  requiredBy: []
  timestamp: '2026-09-13 04:30:30+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/bitset_binary_trie_test.nim
  - verify/AI/bitset_binary_trie_test.nim
documentation_of: cplib/collections/bitset_binary_trie.nim
layout: document
redirect_from:
- /library/cplib/collections/bitset_binary_trie.nim
- /library/cplib/collections/bitset_binary_trie.nim.html
title: cplib/collections/bitset_binary_trie.nim
---
