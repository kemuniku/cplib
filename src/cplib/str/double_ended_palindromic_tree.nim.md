---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/double_ended_palindromic_tree_test.nim
    title: verify/AI/double_ended_palindromic_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/double_ended_palindromic_tree_test.nim
    title: verify/AI/double_ended_palindromic_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/double_ended_palindromic_tree_test.nim
    title: verify/str/double_ended_palindromic_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/double_ended_palindromic_tree_test.nim
    title: verify/str/double_ended_palindromic_tree_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://arxiv.org/abs/2210.02292
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_DOUBLE_ENDED_PALINDROMIC_TREE:\n    ## \u4E21\
    \u7AEF\u3078\u306E\u8FFD\u52A0\u30FB\u524A\u9664\u306B\u5BFE\u5FDC\u3059\u308B\
    \u56DE\u6587\u6728\u3002\u7A7A\u306E\u56DE\u6587\u306F\u500B\u6570\u306B\u542B\
    \u3081\u306A\u3044\u3002\n    ## \u6587\u5B57\u7A2E\u6570\u3092\u03C3\u3001\u4E8B\
    \u524D\u78BA\u4FDD\u5BB9\u91CF\u3068\u3053\u308C\u307E\u3067\u306E\u6700\u5927\
    \u9577\u306E\u5927\u304D\u3044\u65B9\u3092N\u3068\u3057\u3066\u3001\u8FFD\u52A0\
    \u306F\u511F\u5374 O(\u03C3)\u3001\u524A\u9664\u30FB\u53D6\u5F97\u306F O(1)\u3001\
    \u7A7A\u9593\u306F O(\u03C3(N + 1))\u3002\n    ## \u30CE\u30FC\u30C9\u756A\u53F7\
    \u306F32bit\u6574\u6570\u3067\u4FDD\u6301\u3059\u308B\u3002\n    ## surface \u306E\
    \u7BA1\u7406\u306F https://arxiv.org/abs/2210.02292 \u306E\u624B\u6CD5\u306B\u57FA\
    \u3065\u304F\u3002\n    const CPLIB_STR_DOUBLE_ENDED_PALINDROMIC_TREE* = 1\n \
    \   import deques\n\n    type\n        DoubleEndedPalindromicTreeNode = object\n\
    \            length, parent, suffix, depth: int\n            longestCount, suffixChildren:\
    \ int\n        DoubleEndedPalindromicTreeEntry = object\n            # surface\u306F\
    \u3001\u3088\u308A\u9577\u3044\u56DE\u6587\u306E\u63A5\u982D\u8F9E\u306B\u3082\
    \u63A5\u5C3E\u8F9E\u306B\u3082\u306A\u3089\u306A\u3044\u56DE\u6587\u306E\u51FA\
    \u73FE\u3002\n            value, prefixSurface, suffixSurface: int\n        DoubleEndedPalindromicTree*\
    \ = object\n            alphabetSize: int\n            charOffset: char\n    \
    \        nodes: seq[DoubleEndedPalindromicTreeNode]\n            children, direct:\
    \ seq[int32]\n            # \u7A7A\u304D\u30CE\u30FC\u30C9\u3067\u306Fparent\u3092\
    \u6B21\u306E\u7A7A\u304D\u30CE\u30FC\u30C9\u3078\u306E\u30EA\u30F3\u30AF\u3068\
    \u3057\u3066\u4F7F\u3046\u3002\n            freeHead, freeCount: int\n       \
    \     data: Deque[DoubleEndedPalindromicTreeEntry]\n            total: int64\n\
    \n    proc initDoubleEndedPalindromicTree*(amax: int = 26, c: char = 'a', capacity:\
    \ int = 0): DoubleEndedPalindromicTree =\n        ## \u7A7A\u306E\u56DE\u6587\u6728\
    \u3092\u4F5C\u308A\u3001capacity\u6587\u5B57\u5206\u3092\u4E8B\u524D\u78BA\u4FDD\
    \u3059\u308B\u3002O(amax * (capacity + 1))\u3002\n        ## \u6574\u6570\u306F\
    \ 0..<amax\u3001\u6587\u5B57\u306F ord(ch)-ord(c) \u3068\u3057\u3066\u6271\u3046\
    \u3002capacity\u3092\u8D85\u3048\u3066\u3082\u8FFD\u52A0\u53EF\u80FD\u3002\n \
    \       assert amax > 0 and capacity >= 0 and capacity <= int32.high.int - 2\n\
    \        result.alphabetSize = amax\n        result.charOffset = c\n        #\
    \ \u30CE\u30FC\u30C90\u306F\u9577\u3055-1\u306E\u6839\uFF08\u672A\u63A5\u7D9A\u306E\
    \u9077\u79FB\u30820\uFF09\u3001\u30CE\u30FC\u30C91\u306F\u7A7A\u6587\u5B57\u5217\
    \u306E\u6839\u3002\n        result.nodes = newSeqOfCap[DoubleEndedPalindromicTreeNode](capacity\
    \ + 2)\n        result.nodes.add(DoubleEndedPalindromicTreeNode(length: -1))\n\
    \        result.nodes.add(DoubleEndedPalindromicTreeNode())\n        result.children\
    \ = newSeqOfCap[int32]((capacity + 2) * amax)\n        result.direct = newSeqOfCap[int32]((capacity\
    \ + 2) * amax)\n        result.children.setLen(2 * amax)\n        result.direct.setLen(2\
    \ * amax)\n        result.data = initDeque[DoubleEndedPalindromicTreeEntry](max(4,\
    \ capacity))\n\n    proc len*(self: DoubleEndedPalindromicTree): int =\n     \
    \   ## \u73FE\u5728\u306E\u6587\u5B57\u5217\u306E\u9577\u3055\u3092 O(1) \u3067\
    \u8FD4\u3059\u3002\n        self.data.len\n\n    proc isEmpty*(self: DoubleEndedPalindromicTree):\
    \ bool =\n        ## \u73FE\u5728\u306E\u6587\u5B57\u5217\u304C\u7A7A\u304B\u3092\
    \ O(1) \u3067\u8FD4\u3059\u3002\n        self.data.len == 0\n\n    proc count_distinct_palindromes*(self:\
    \ DoubleEndedPalindromicTree): int =\n        ## \u73FE\u5728\u306E\u6587\u5B57\
    \u5217\u306B\u542B\u307E\u308C\u308B\u7570\u306A\u308B\u975E\u7A7A\u56DE\u6587\
    \u306E\u500B\u6570\u3092 O(1) \u3067\u8FD4\u3059\u3002\n        self.nodes.len\
    \ - self.freeCount - 2\n\n    proc count_palindromes*(self: DoubleEndedPalindromicTree):\
    \ int64 =\n        ## \u73FE\u5728\u306E\u6587\u5B57\u5217\u306E\u975E\u7A7A\u56DE\
    \u6587\u306E\u51FA\u73FE\u7DCF\u6570\u3092 O(1) \u3067\u8FD4\u3059\u3002\u4F4D\
    \u7F6E\u304C\u7570\u306A\u308B\u51FA\u73FE\u3082\u6570\u3048\u308B\u3002\n   \
    \     self.total\n\n    proc longest_prefix_palindrome*(self: DoubleEndedPalindromicTree):\
    \ int =\n        ## \u6700\u9577\u56DE\u6587\u63A5\u982D\u8F9E\u306E\u9577\u3055\
    \u3092 O(1) \u3067\u8FD4\u3059\u3002\u7A7A\u6587\u5B57\u5217\u306A\u30890\u3002\
    \n        if self.data.len == 0: return 0\n        self.nodes[self.data.peekFirst.prefixSurface].length\n\
    \n    proc longest_suffix_palindrome*(self: DoubleEndedPalindromicTree): int =\n\
    \        ## \u6700\u9577\u56DE\u6587\u63A5\u5C3E\u8F9E\u306E\u9577\u3055\u3092\
    \ O(1) \u3067\u8FD4\u3059\u3002\u7A7A\u6587\u5B57\u5217\u306A\u30890\u3002\n \
    \       if self.data.len == 0: return 0\n        self.nodes[self.data.peekLast.suffixSurface].length\n\
    \n    proc addNode(self: var DoubleEndedPalindromicTree, parent, suffix, value,\
    \ preceding: int): int =\n        ## \u30CE\u30FC\u30C9\u3092\u4F5C\u308A\u3001\
    \u771F\u306E\u63A5\u5C3E\u8F9E\u306E\u3046\u3061\u5404\u6587\u5B57\u3067\u5EF6\
    \u9577\u53EF\u80FD\u306A\u6700\u9577\u306E\u3082\u306E\u3092\u511F\u5374 O(\u03C3\
    ) \u3067\u8A18\u9332\u3059\u308B\u3002\n        let sigma = self.alphabetSize\n\
    \        if self.freeCount > 0:\n            result = self.freeHead\n        \
    \    self.freeHead = self.nodes[result].parent\n            dec self.freeCount\n\
    \        else:\n            result = self.nodes.len\n            assert result\
    \ <= int32.high.int\n            self.nodes.add(DoubleEndedPalindromicTreeNode())\n\
    \            self.children.setLen(self.nodes.len * sigma)\n            self.direct.setLen(self.nodes.len\
    \ * sigma)\n        self.nodes[result] = DoubleEndedPalindromicTreeNode(\n   \
    \         length: self.nodes[parent].length + 2, parent: parent,\n           \
    \ suffix: suffix, depth: self.nodes[suffix].depth + 1)\n        # \u30CE\u30FC\
    \u30C9\u756A\u53F7\u3060\u3051\u309232bit\u3067\u4FDD\u6301\u3057\u3001\u9023\u7D9A\
    \u3057\u305F\u9077\u79FB\u8868\u3092\u307E\u3068\u3081\u3066\u30B3\u30D4\u30FC\
    \u3059\u308B\u3002\n        zeroMem(addr self.children[result * sigma], sigma\
    \ * sizeof(int32))\n        copyMem(addr self.direct[result * sigma], addr self.direct[suffix\
    \ * sigma], sigma * sizeof(int32))\n        self.direct[result * sigma + preceding]\
    \ = int32(suffix)\n        self.children[parent * sigma + value] = int32(result)\n\
    \        inc self.nodes[suffix].suffixChildren\n\n    proc push(self: var DoubleEndedPalindromicTree,\
    \ value: int, front: static[bool]) =\n        ## \u6307\u5B9A\u5074\u306B1\u6587\
    \u5B57\u8FFD\u52A0\u3057\u3001\u5909\u5316\u3059\u308Bsurface\u3060\u3051\u3092\
    \u66F4\u65B0\u3059\u308B\u3002\u511F\u5374 O(\u03C3)\u3002\n        assert self.alphabetSize\
    \ > 0 and value >= 0 and value < self.alphabetSize\n        template entry(i:\
    \ int): untyped =\n            when front: self.data[i]\n            else: self.data[self.data.len\
    \ - 1 - i]\n        template nearSurface(i: int): untyped =\n            when\
    \ front: entry(i).prefixSurface\n            else: entry(i).suffixSurface\n  \
    \      template farSurface(i: int): untyped =\n            when front: entry(i).suffixSurface\n\
    \            else: entry(i).prefixSurface\n\n        var parent = if self.data.len\
    \ == 0: 1 else: nearSurface(0)\n        let item = DoubleEndedPalindromicTreeEntry(value:\
    \ value, prefixSurface: 1, suffixSurface: 1)\n        when front: self.data.addFirst(item)\n\
    \        else: self.data.addLast(item)\n        let sigma = self.alphabetSize\n\
    \        let opposite = self.nodes[parent].length + 1\n        if opposite >=\
    \ self.data.len or entry(opposite).value != value:\n            parent = self.direct[parent\
    \ * sigma + value].int\n        var node = self.children[parent * sigma + value].int\n\
    \        if node == 0:\n            let suffix = if parent == 0: 1\n         \
    \       else: self.children[self.direct[parent * sigma + value].int * sigma +\
    \ value].int\n            node = self.addNode(parent, suffix, value, entry(self.nodes[suffix].length).value)\n\
    \n        let length = self.nodes[node].length\n        let suffix = self.nodes[node].suffix\n\
    \        let suffixLength = self.nodes[suffix].length\n        nearSurface(0)\
    \ = node\n        farSurface(length - 1) = node\n        if suffixLength > 0 and\
    \ nearSurface(length - suffixLength) == suffix:\n            nearSurface(length\
    \ - suffixLength) = 1\n        inc self.nodes[node].longestCount\n        self.total\
    \ += int64(self.nodes[node].depth)\n\n    proc pop(self: var DoubleEndedPalindromicTree,\
    \ front: static[bool]) =\n        ## \u6307\u5B9A\u5074\u304B\u30891\u6587\u5B57\
    \u524A\u9664\u3057\u3001\u9732\u51FA\u3059\u308Bsurface\u3068\u4E0D\u8981\u306A\
    \u30CE\u30FC\u30C9\u3092 O(1) \u3067\u66F4\u65B0\u3059\u308B\u3002\n        if\
    \ self.data.len == 0:\n            raise newException(IndexDefect, \"the palindromic\
    \ tree is empty\")\n        template entry(i: int): untyped =\n            when\
    \ front: self.data[i]\n            else: self.data[self.data.len - 1 - i]\n  \
    \      template nearSurface(i: int): untyped =\n            when front: entry(i).prefixSurface\n\
    \            else: entry(i).suffixSurface\n        template farSurface(i: int):\
    \ untyped =\n            when front: entry(i).suffixSurface\n            else:\
    \ entry(i).prefixSurface\n\n        let node = nearSurface(0)\n        let suffix\
    \ = self.nodes[node].suffix\n        let length = self.nodes[node].length\n  \
    \      let suffixLength = self.nodes[suffix].length\n        farSurface(length\
    \ - 1) = 1\n        if suffixLength > 0 and self.nodes[nearSurface(length - suffixLength)].length\
    \ < suffixLength:\n            nearSurface(length - suffixLength) = suffix\n \
    \           farSurface(length - 1) = suffix\n        dec self.nodes[node].longestCount\n\
    \        self.total -= int64(self.nodes[node].depth)\n        # \u6700\u9577\u56DE\
    \u6587\u3068\u3057\u3066\u306E\u51FA\u73FE\u3082suffix link\u306E\u5B50\u3082\u306A\
    \u304F\u306A\u3063\u305F\u30CE\u30FC\u30C9\u3060\u3051\u304C\u6D88\u3048\u308B\
    \u3002\n        if self.nodes[node].longestCount == 0 and self.nodes[node].suffixChildren\
    \ == 0:\n            self.children[self.nodes[node].parent * self.alphabetSize\
    \ + entry(0).value] = 0\n            dec self.nodes[suffix].suffixChildren\n \
    \           self.nodes[node].parent = self.freeHead\n            self.freeHead\
    \ = node\n            inc self.freeCount\n        when front: discard self.data.popFirst()\n\
    \        else: discard self.data.popLast()\n\n    proc push_front*(self: var DoubleEndedPalindromicTree,\
    \ value: int) =\n        ## \u5148\u982D\u306B 0..<amax \u306E\u6574\u6570\u3092\
    \u8FFD\u52A0\u3059\u308B\u3002\u511F\u5374 O(\u03C3)\u3002\n        self.push(value,\
    \ true)\n\n    proc push_back*(self: var DoubleEndedPalindromicTree, value: int)\
    \ =\n        ## \u672B\u5C3E\u306B 0..<amax \u306E\u6574\u6570\u3092\u8FFD\u52A0\
    \u3059\u308B\u3002\u511F\u5374 O(\u03C3)\u3002\n        self.push(value, false)\n\
    \n    proc push_front*(self: var DoubleEndedPalindromicTree, value: char) =\n\
    \        ## \u5148\u982D\u306B\u6587\u5B57\u3092\u8FFD\u52A0\u3059\u308B\u3002\
    \u521D\u671F\u5316\u6642\u306Ec\u3068\u306E\u5DEE\u304C 0..<amax \u306B\u5165\u308B\
    \u5FC5\u8981\u304C\u3042\u308B\u3002\u511F\u5374 O(\u03C3)\u3002\n        self.push_front(ord(value)\
    \ - ord(self.charOffset))\n\n    proc push_back*(self: var DoubleEndedPalindromicTree,\
    \ value: char) =\n        ## \u672B\u5C3E\u306B\u6587\u5B57\u3092\u8FFD\u52A0\u3059\
    \u308B\u3002\u521D\u671F\u5316\u6642\u306Ec\u3068\u306E\u5DEE\u304C 0..<amax \u306B\
    \u5165\u308B\u5FC5\u8981\u304C\u3042\u308B\u3002\u511F\u5374 O(\u03C3)\u3002\n\
    \        self.push_back(ord(value) - ord(self.charOffset))\n\n    proc pop_front*(self:\
    \ var DoubleEndedPalindromicTree) =\n        ## \u5148\u982D\u30921\u6587\u5B57\
    \u524A\u9664\u3059\u308B\u3002O(1)\u3002\u7A7A\u306A\u3089IndexDefect\u3002\n\
    \        self.pop(true)\n\n    proc pop_back*(self: var DoubleEndedPalindromicTree)\
    \ =\n        ## \u672B\u5C3E\u30921\u6587\u5B57\u524A\u9664\u3059\u308B\u3002\
    O(1)\u3002\u7A7A\u306A\u3089IndexDefect\u3002\n        self.pop(false)\n\n   \
    \ proc initDoubleEndedPalindromicTree*(a: openArray[int], amax: int = -1): DoubleEndedPalindromicTree\
    \ =\n        ## \u975E\u8CA0\u6574\u6570\u5217\u304B\u3089 O(\u03C3(|a| + 1))\
    \ \u3067\u69CB\u7BC9\u3059\u308B\u3002amax\u7701\u7565\u6642\u306F\u6700\u5927\
    \u5024+1\uFF08\u7A7A\u306A\u30891\uFF09\u3002\n        var sigma = amax\n    \
    \    if sigma < 0:\n            sigma = 1\n            for value in a:\n     \
    \           assert value >= 0 and value < int.high\n                sigma = max(sigma,\
    \ value + 1)\n        result = initDoubleEndedPalindromicTree(sigma, capacity\
    \ = a.len)\n        for value in a:\n            result.push_back(value)\n\n \
    \   proc initDoubleEndedPalindromicTree*(s: openArray[char], c: char = 'a', amax:\
    \ int = 26): DoubleEndedPalindromicTree =\n        ## \u6587\u5B57\u5217\u304B\
    \u3089 O(amax(|s| + 1)) \u3067\u69CB\u7BC9\u3059\u308B\u3002\u65E2\u5B9A\u306E\
    \u6587\u5B57\u7BC4\u56F2\u306F 'a'..'z'\u3002\n        result = initDoubleEndedPalindromicTree(amax,\
    \ c, capacity = s.len)\n        for value in s:\n            result.push_back(value)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/double_ended_palindromic_tree.nim
  requiredBy: []
  timestamp: '2026-09-28 04:29:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/double_ended_palindromic_tree_test.nim
  - verify/AI/double_ended_palindromic_tree_test.nim
  - verify/str/double_ended_palindromic_tree_test.nim
  - verify/str/double_ended_palindromic_tree_test.nim
documentation_of: cplib/str/double_ended_palindromic_tree.nim
layout: document
redirect_from:
- /library/cplib/str/double_ended_palindromic_tree.nim
- /library/cplib/str/double_ended_palindromic_tree.nim.html
title: cplib/str/double_ended_palindromic_tree.nim
---
