---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/trie_test.nim
    title: verify/AI/trie_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/trie_test.nim
    title: verify/AI/trie_test.nim
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
  code: "when not declared CPLIB_STR_TRIE:\n    import cplib/graph/graph\n    const\
    \ CPLIB_STR_TRIE* = 1\n\n    type\n        TrieNode*[chars: static[HSlice[char,\
    \ char]]] = object\n            ## \u6839\u306EID\u306F0\u3001\u89AA\u306F -1\u3002\
    child\u306E0\u306F\u5B50\u306A\u3057\u3002character\u306F\u89AA\u304B\u3089\u306E\
    \u6587\u5B57\uFF08\u6839\u3067\u306F\u672A\u4F7F\u7528\uFF09\u3002\n         \
    \   child*: array[chars.a..chars.b, int32]\n            terminal*, subtree*: int32\n\
    \            parent*: int32\n            character*: char\n        Trie*[chars:\
    \ static[HSlice[char, char]]] = object\n            nodes*: seq[TrieNode[chars]]\n\
    \        TriePointer*[chars: static[HSlice[char, char]]] = object\n          \
    \  ## \u5143\u306ETrie\u304C\u751F\u5B58\u3057\u3001\u79FB\u52D5\u30FB\u518D\u4EE3\
    \u5165\u3055\u308C\u306A\u3044\u9593\u3060\u3051\u4F7F\u7528\u53EF\u80FD\u3002\
    \u30B3\u30D4\u30FC\u5F8C\u306E\u4F4D\u7F6E\u306F\u72EC\u7ACB\u3059\u308B\u3002\
    \n            owner: ptr Trie[chars]\n            id: int32\n\n    proc initTrie*(chars:\
    \ static[HSlice[char, char]]): Trie[chars] =\n        ## \u6307\u5B9A\u3057\u305F\
    \u6587\u5B57\u7BC4\u56F2\u306E\u7A7A\u306E\u591A\u91CD\u96C6\u5408\u3092\u4F5C\
    \u308B\u3002\u6587\u5B57\u7A2E\u6570\u3092\u03C3\u3068\u3057\u3066 O(\u03C3)\u3002\
    \n        static: doAssert chars.a <= chars.b\n        result.nodes.setLen(1)\n\
    \        result.nodes[0].parent = -1\n\n    proc root*[chars](self: Trie[chars]):\
    \ int =\n        ## \u6839\u306E\u7BC0\u70B9ID\uFF080\uFF09\u3092\u8FD4\u3059\u3002\
    O(1)\u3002\n        return 0\n\n    proc getChild*[chars](self: var Trie[chars],\
    \ node: int, c: char): int =\n        ## c\u3092\u672B\u5C3E\u306B\u8FFD\u52A0\
    \u3057\u305F\u7BC0\u70B9ID\u3092\u8FD4\u3057\u3001\u306A\u3051\u308C\u3070\u4F5C\
    \u308B\u3002\u500B\u6570\u306F\u5909\u3048\u306A\u3044\u3002\u03C3\u56FA\u5B9A\
    \u3067\u511F\u5374 O(1)\u3002\n        doAssert c >= chars.a and c <= chars.b\n\
    \        if self.nodes.len == 0:\n            doAssert node == 0\n           \
    \ self = initTrie(chars)\n        doAssert node >= 0 and node < self.nodes.len\n\
    \        result = self.nodes[node].child[c]\n        if result == 0:\n       \
    \     result = self.nodes.len\n            doAssert result <= int(high(int32))\n\
    \            self.nodes.setLen(result + 1)\n            self.nodes[result].parent\
    \ = int32(node)\n            self.nodes[result].character = c\n            self.nodes[node].child[c]\
    \ = int32(result)\n\n    proc getParent*[chars](self: Trie[chars], node: int):\
    \ int =\n        ## \u89AA\u306E\u7BC0\u70B9ID\u3092\u8FD4\u3059\u3002\u6839\u306E\
    \u89AA\u306F -1\u3002O(1)\u3002\n        doAssert node >= 0 and node < self.nodes.len\n\
    \        return self.nodes[node].parent\n\n    proc restoreString*[chars](self:\
    \ Trie[chars], node: int): string =\n        ## \u7BC0\u70B9\u304C\u793A\u3059\
    \u6587\u5B57\u5217\u3092\u5FA9\u5143\u3059\u308B\u3002\u6839\u306A\u3089\u7A7A\
    \u6587\u5B57\u5217\u3002O(\u6DF1\u3055 + 1)\u3002\n        doAssert node >= 0\
    \ and node < self.nodes.len\n        var current = node\n        while current\
    \ != 0:\n            result.add(self.nodes[current].character)\n            current\
    \ = self.nodes[current].parent\n        for i in 0..<result.len div 2:\n     \
    \       swap(result[i], result[result.high - i])\n\n    proc len*[chars](self:\
    \ Trie[chars]): int =\n        ## \u91CD\u8907\u3092\u542B\u3080\u6587\u5B57\u5217\
    \u306E\u7DCF\u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n        if self.nodes.len\
    \ > 0:\n            result = self.nodes[0].subtree\n\n    proc findNode*[chars](self:\
    \ Trie[chars], s: string): int =\n        ## s\u306B\u5BFE\u5FDC\u3059\u308B\u7BC0\
    \u70B9ID\u3092\u500B\u6570\u304C0\u3067\u3082\u8FD4\u3059\u3002\u5B58\u5728\u3057\
    \u306A\u3051\u308C\u3070 -1\u3002O(|s|)\u3002\n        if self.nodes.len == 0:\n\
    \            return -1\n        for c in s:\n            if c < chars.a or c >\
    \ chars.b:\n                return -1\n            result = self.nodes[result].child[c]\n\
    \            if result == 0:\n                return -1\n\n    proc count*[chars](self:\
    \ Trie[chars], s: string): int =\n        ## s\u3068\u5B8C\u5168\u4E00\u81F4\u3059\
    \u308B\u6587\u5B57\u5217\u306E\u500B\u6570\u3092\u8FD4\u3059\u3002O(|s|)\u3002\
    \n        let node = self.findNode(s)\n        if node >= 0:\n            result\
    \ = self.nodes[node].terminal\n\n    proc contains*[chars](self: Trie[chars],\
    \ s: string): bool =\n        ## s\u304C1\u500B\u4EE5\u4E0A\u542B\u307E\u308C\u308B\
    \u304B\u3092\u8FD4\u3059\u3002O(|s|)\u3002\n        return self.count(s) > 0\n\
    \n    proc countPrefix*[chars](self: Trie[chars], prefix: string): int =\n   \
    \     ## prefix\u3067\u59CB\u307E\u308B\u6587\u5B57\u5217\u306E\u500B\u6570\u3092\
    \u8FD4\u3059\u3002\u7A7A\u306Eprefix\u306A\u3089\u7DCF\u6570\u3002O(|prefix|)\u3002\
    \n        let node = self.findNode(prefix)\n        if node >= 0:\n          \
    \  result = self.nodes[node].subtree\n\n    proc incl*[chars](self: var Trie[chars],\
    \ s: string, v: Natural = 1) =\n        ## s\u3092v\u500B\u8FFD\u52A0\u3059\u308B\
    \u3002\u7BC4\u56F2\u5916\u306E\u6587\u5B57\u306F\u8A31\u3055\u306A\u3044\u3002\
    \u511F\u5374 O(\u03C3|s| + 1)\u3002\n        if v == 0:\n            return\n\
    \        for c in s:\n            doAssert c >= chars.a and c <= chars.b\n   \
    \     doAssert v <= int(high(int32)) - self.len\n        let added = int32(v)\n\
    \        if self.nodes.len == 0:\n            self = initTrie(chars)\n       \
    \ var node = 0\n        self.nodes[node].subtree += added\n        for c in s:\n\
    \            node = self.getChild(node, c)\n            self.nodes[node].subtree\
    \ += added\n        self.nodes[node].terminal += added\n\n    proc initTrie*(words:\
    \ openArray[string], chars: static[HSlice[char, char]]): Trie[chars] =\n     \
    \   ## \u6587\u5B57\u5217\u5217\u304B\u3089\u91CD\u8907\u3092\u4FDD\u3063\u3066\
    \u69CB\u7BC9\u3059\u308B\u3002O(\u03C3(1 + \u03A3|s|) + words.len)\u3002\n   \
    \     result = initTrie(chars)\n        for s in words:\n            result.incl(s)\n\
    \n    proc excl*[chars](self: var Trie[chars], s: string, v: Natural = 1) =\n\
    \        ## s\u3092\u6700\u5927v\u500B\u524A\u9664\u3059\u308B\u3002\u4E0D\u8DB3\
    \u5206\u306F\u7121\u8996\u3057\u3001\u7BC0\u70B9\u306F\u4FDD\u6301\u3059\u308B\
    \u3002O(|s|)\u3002\n        let removed = int32(min(v, self.count(s)))\n     \
    \   if removed == 0:\n            return\n        var node = 0\n        self.nodes[node].subtree\
    \ -= removed\n        for c in s:\n            node = self.nodes[node].child[c]\n\
    \            self.nodes[node].subtree -= removed\n        self.nodes[node].terminal\
    \ -= removed\n\n    proc lowerBound*[chars](self: Trie[chars], s: string): int\
    \ =\n        ## \u8F9E\u66F8\u9806\u3067s\u672A\u6E80\u306E\u6587\u5B57\u5217\u306E\
    \u500B\u6570\u3092\u8FD4\u3059\u3002\u7BC4\u56F2\u5916\u306E\u6587\u5B57\u3082\
    \u6BD4\u8F03\u53EF\u80FD\u3002O(\u03C3|s| + 1)\u3002\n        if self.nodes.len\
    \ == 0:\n            return 0\n        var node = 0\n        for c in s:\n   \
    \         result += self.nodes[node].terminal\n            for smaller in chars.a..chars.b:\n\
    \                if smaller >= c:\n                    break\n               \
    \ let next = self.nodes[node].child[smaller]\n                if next != 0:\n\
    \                    result += self.nodes[next].subtree\n            if c < chars.a\
    \ or c > chars.b:\n                return\n            node = self.nodes[node].child[c]\n\
    \            if node == 0:\n                return\n\n    proc upperBound*[chars](self:\
    \ Trie[chars], s: string): int =\n        ## \u8F9E\u66F8\u9806\u3067s\u4EE5\u4E0B\
    \u306E\u6587\u5B57\u5217\u306E\u500B\u6570\u3092\u8FD4\u3059\u3002O(\u03C3|s|\
    \ + 1)\u3002\n        return self.lowerBound(s) + self.count(s)\n\n    proc toGraph*[chars](self:\
    \ Trie[chars]): WeightedDirectedGraph[char] =\n        ## \u7BC0\u70B9ID\u3092\
    \u9802\u70B9\u756A\u53F7\u3068\u3057\u3001\u89AA\u304B\u3089\u5B50\u3078\u6587\
    \u5B57\u3092\u91CD\u307F\u3068\u3059\u308B\u8FBA\u3092\u5F35\u308B\u3002\u5168\
    \u7BC0\u70B9\u3092\u542B\u3081 O(N + 1)\u3002\n        let n = max(1, self.nodes.len)\n\
    \        result = initWeightedDirectedGraph(n, char, n - 1)\n        for node\
    \ in 1..<self.nodes.len:\n            result.add_edge(int(self.nodes[node].parent),\
    \ node, self.nodes[node].character)\n\n    proc initTriePointer*[chars](self:\
    \ var Trie[chars], node: int = 0): TriePointer[chars] =\n        ## \u6307\u5B9A\
    \u3057\u305F\u7BC0\u70B9\u3092\u6307\u3059\u30DD\u30A4\u30F3\u30BF\u3092\u4F5C\
    \u308B\u3002\u7701\u7565\u6642\u306F\u6839\u3002\u03C3\u56FA\u5B9A\u3067 O(1)\u3002\
    \n        if self.nodes.len == 0:\n            doAssert node == 0\n          \
    \  self = initTrie(chars)\n        doAssert node >= 0 and node < self.nodes.len\n\
    \        result.owner = addr self\n        result.id = int32(node)\n\n    proc\
    \ nodeId*[chars](self: TriePointer[chars]): int =\n        ## \u6307\u3057\u3066\
    \u3044\u308B\u7BC0\u70B9ID\u3092\u8FD4\u3059\u3002O(1)\u3002\n        doAssert\
    \ self.owner != nil\n        return self.id\n\n    proc subtree*[chars](self:\
    \ TriePointer[chars]): int =\n        ## \u6307\u3057\u3066\u3044\u308B\u6587\u5B57\
    \u5217\u3092prefix\u3068\u3059\u308B\u767B\u9332\u500B\u6570\u3092\u8FD4\u3059\
    \u3002O(1)\u3002\n        doAssert self.owner != nil\n        return self.owner[].nodes[self.id].subtree\n\
    \n    proc terminal*[chars](self: TriePointer[chars]): int =\n        ## \u6307\
    \u3057\u3066\u3044\u308B\u6587\u5B57\u5217\u3068\u5B8C\u5168\u4E00\u81F4\u3059\
    \u308B\u767B\u9332\u500B\u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n        doAssert\
    \ self.owner != nil\n        return self.owner[].nodes[self.id].terminal\n\n \
    \   proc restoreString*[chars](self: TriePointer[chars]): string =\n        ##\
    \ \u6307\u3057\u3066\u3044\u308B\u7BC0\u70B9\u306E\u6587\u5B57\u5217\u3092\u5FA9\
    \u5143\u3059\u308B\u3002O(\u6DF1\u3055 + 1)\u3002\n        doAssert self.owner\
    \ != nil\n        return self.owner[].restoreString(self.id)\n\n    proc `$`*[chars](self:\
    \ TriePointer[chars]): string =\n        ## \u6307\u3057\u3066\u3044\u308B\u7BC0\
    \u70B9\u3092\u6587\u5B57\u5217\u3068\u3057\u3066\u8FD4\u3059\u3002O(\u6DF1\u3055\
    \ + 1)\u3002\n        return self.restoreString()\n\n    proc getChild*[chars](self:\
    \ TriePointer[chars], c: char): TriePointer[chars] =\n        ## c\u3092\u672B\
    \u5C3E\u306B\u8FFD\u52A0\u3057\u305F\u4F4D\u7F6E\u3092\u8FD4\u3057\u3001\u306A\
    \u3051\u308C\u3070\u7BC0\u70B9\u3092\u4F5C\u308B\u3002\u03C3\u56FA\u5B9A\u3067\
    \u511F\u5374 O(1)\u3002\n        doAssert self.owner != nil\n        result =\
    \ self\n        result.id = int32(self.owner[].getChild(self.id, c))\n\n    proc\
    \ getParent*[chars](self: TriePointer[chars]): TriePointer[chars] =\n        ##\
    \ \u672B\u5C3E\u30921\u6587\u5B57\u524A\u9664\u3057\u305F\u4F4D\u7F6E\u3092\u8FD4\
    \u3059\u3002\u6839\u3067\u306F\u547C\u3079\u306A\u3044\u3002O(1)\u3002\n     \
    \   doAssert self.owner != nil and self.id != 0\n        result = self\n     \
    \   result.id = int32(self.owner[].getParent(self.id))\n\n    proc `&`*[chars](self:\
    \ TriePointer[chars], c: char): TriePointer[chars] =\n        ## \u672B\u5C3E\u306B\
    c\u3092\u8FFD\u52A0\u3057\u305F\u4F4D\u7F6E\u3092\u8FD4\u3059\u3002\u03C3\u56FA\
    \u5B9A\u3067\u511F\u5374 O(1)\u3002\n        return self.getChild(c)\n\n    proc\
    \ add*[chars](self: var TriePointer[chars], c: char) =\n        ## \u672B\u5C3E\
    \u306Bc\u3092\u8FFD\u52A0\u3057\u305F\u4F4D\u7F6E\u3078\u79FB\u52D5\u3059\u308B\
    \u3002\u767B\u9332\u500B\u6570\u306F\u5909\u3048\u306A\u3044\u3002\u03C3\u56FA\
    \u5B9A\u3067\u511F\u5374 O(1)\u3002\n        self = self.getChild(c)\n\n    proc\
    \ `&=`*[chars](self: var TriePointer[chars], c: char) =\n        ## \u672B\u5C3E\
    \u306Bc\u3092\u8FFD\u52A0\u3057\u305F\u4F4D\u7F6E\u3078\u79FB\u52D5\u3059\u308B\
    \u3002\u03C3\u56FA\u5B9A\u3067\u511F\u5374 O(1)\u3002\n        self.add(c)\n\n\
    \    proc pop*[chars](self: var TriePointer[chars]): char =\n        ## \u672B\
    \u5C3E\u306E\u6587\u5B57\u3092\u8FD4\u3057\u3066\u89AA\u3078\u79FB\u52D5\u3059\
    \u308B\u3002\u7A7A\u6587\u5B57\u5217\u3067\u306F\u547C\u3079\u306A\u3044\u3002\
    O(1)\u3002\n        doAssert self.owner != nil and self.id != 0\n        result\
    \ = self.owner[].nodes[self.id].character\n        self = self.getParent()\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/str/trie.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/trie_test.nim
  - verify/AI/trie_test.nim
documentation_of: cplib/str/trie.nim
layout: document
redirect_from:
- /library/cplib/str/trie.nim
- /library/cplib/str/trie.nim.html
title: cplib/str/trie.nim
---
