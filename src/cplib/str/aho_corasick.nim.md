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
    path: verify/AI/aho_corasick_test.nim
    title: verify/AI/aho_corasick_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/aho_corasick_test.nim
    title: verify/AI/aho_corasick_test.nim
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
  code: "import cplib/graph/graph\n\nwhen not declared CPLIB_STR_AHO_CORASICK:\n \
    \   ## \u767B\u9332\u8A9E\u306E\u96C6\u5408\u3092\u56FA\u5B9A\u3057\u305FAho\u2013\
    Corasick\u3002\u9802\u70B9\u306F\u767B\u9332\u8A9E\u306Eprefix\uFF08\u6839\u306F\
    \u7A7A\u6587\u5B57\u5217\uFF09\u3092\u8868\u3059\u3002\n    ## \u9802\u70B9ID\u306F\
    \u5165\u529B\u9806\u306B\u767B\u9332\u8A9E\u3092\u8D70\u67FB\u3057\u3066\u9802\
    \u70B9\u3092\u4F5C\u3063\u305F\u9806\u306E\u9023\u756A\u3002\u6839\u306F0\u3002\
    \n    ## initAhoCorasick\u3067\u69CB\u7BC9\u3057\u3066\u304B\u3089\u4F7F\u7528\
    \u3059\u308B\u3002\u69CB\u7BC9\u5F8C\u306E\u767B\u9332\u8A9E\u306E\u8FFD\u52A0\
    \u30FB\u524A\u9664\u306B\u306F\u5BFE\u5FDC\u3057\u306A\u3044\u3002\n    ## matchCount\u306F\
    \u73FE\u5728\u4F4D\u7F6E\u3067\u7D42\u308F\u308B\u4E00\u81F4\u6570\u3002\u7A7A\
    \u6587\u5B57\u5217\u306F\u6839\u3092\u542B\u3080\u3059\u3079\u3066\u306E\u4F4D\
    \u7F6E\u3067\u4E00\u81F4\u3059\u308B\u3002\n    ## matches\u306F\u767B\u9332\u8A9E\
    \u306E\u9802\u70B9ID\u3092\u8FD4\u3057\u3001\u91CD\u8907\u6570\u306Fterminal\u3001\
    \u5165\u529B\u3068\u306E\u5BFE\u5FDC\u306FpatternNode\u3067\u53D6\u5F97\u3059\u308B\
    \u3002\n    ## \u4F7F\u7528\u4F8B:\n    ##   var ac = initAhoCorasick(@[\"he\"\
    , \"she\", \"hers\"], 'a'..'z')\n    ##   var p = ac.initAhoCorasickPointer()\n\
    \    ##   p.add(\"ush\")  # $p == \"sh\"\uFF08\u767B\u9332\u8A9E\u306E\u9014\u4E2D\
    \u306E\u9802\u70B9\u306B\u3082\u9077\u79FB\u3059\u308B\uFF09\n    ##   p &= 'e'\
    \      # $p == \"she\", p.matchCount == 2\n    ##   p &= \"rs\"     # $p == \"\
    hers\"\n    const CPLIB_STR_AHO_CORASICK* = 1\n\n    type\n        AhoCorasickNode[chars:\
    \ static[HSlice[char, char]]] = object\n            next: array[chars.a..chars.b,\
    \ int32]\n            parent, failure, output: int32\n            character: char\n\
    \            terminal, matched: int\n        AhoCorasick*[chars: static[HSlice[char,\
    \ char]]] = object\n            nodes: seq[AhoCorasickNode[chars]]\n         \
    \   patterns: seq[int32]\n        AhoCorasickPointer*[chars: static[HSlice[char,\
    \ char]]] = object\n            ## \u5143\u306EAhoCorasick\u304C\u751F\u5B58\u3057\
    \u3001\u79FB\u52D5\u30FB\u518D\u4EE3\u5165\u3055\u308C\u306A\u3044\u9593\u3060\
    \u3051\u4F7F\u7528\u53EF\u80FD\u3002\u30B3\u30D4\u30FC\u5F8C\u306E\u4F4D\u7F6E\
    \u306F\u72EC\u7ACB\u3059\u308B\u3002\n            owner: ptr AhoCorasick[chars]\n\
    \            id: int32\n\n    proc initAhoCorasick*(words: openArray[string],\
    \ chars: static[HSlice[char, char]]): AhoCorasick[chars] =\n        ## \u767B\u9332\
    \u8A9E\u304B\u3089\u69CB\u7BC9\u3059\u308B\u3002\u6587\u5B57\u7A2E\u6570\u03C3\
    \u3001\u9802\u70B9\u6570N\u3068\u3057\u3066\u6642\u9593 O(\u03A3|s| + words.len\
    \ + \u03C3N)\u3001\u7A7A\u9593 O(\u03C3N + words.len)\u3002\n        static: doAssert\
    \ chars.a <= chars.b\n        result.nodes.setLen(1)\n        result.nodes[0].parent\
    \ = -1\n        result.nodes[0].output = -1\n        for s in words:\n       \
    \     var node = 0\n            for c in s:\n                doAssert c >= chars.a\
    \ and c <= chars.b\n                if result.nodes[node].next[c] == 0:\n    \
    \                let child = result.nodes.len\n                    doAssert child\
    \ <= int(high(int32))\n                    result.nodes.add(AhoCorasickNode[chars](parent:\
    \ int32(node), character: c, output: -1))\n                    result.nodes[node].next[c]\
    \ = int32(child)\n                node = int(result.nodes[node].next[c])\n   \
    \         inc result.nodes[node].terminal\n            result.patterns.add(int32(node))\n\
    \        result.nodes[0].matched = result.nodes[0].terminal\n        var queue\
    \ = @[0'i32]\n        var head = 0\n        while head < queue.len:\n        \
    \    let node = queue[head]\n            inc head\n            for c in chars.a..chars.b:\n\
    \                let child = result.nodes[node].next[c]\n                if child\
    \ == 0:\n                    if node != 0:\n                        result.nodes[node].next[c]\
    \ = result.nodes[result.nodes[node].failure].next[c]\n                    continue\n\
    \                var failure = 0'i32\n                if node != 0:\n        \
    \            failure = result.nodes[result.nodes[node].failure].next[c]\n    \
    \            result.nodes[child].failure = failure\n                result.nodes[child].matched\
    \ = result.nodes[child].terminal + result.nodes[failure].matched\n           \
    \     result.nodes[child].output = if result.nodes[failure].terminal > 0: failure\
    \ else: result.nodes[failure].output\n                queue.add(child)\n\n   \
    \ proc root*[chars](self: AhoCorasick[chars]): int =\n        ## \u6839\u306E\u9802\
    \u70B9ID\uFF080\uFF09\u3092\u8FD4\u3059\u3002O(1)\u3002\n        return 0\n\n\
    \    proc nodeCount*[chars](self: AhoCorasick[chars]): int =\n        ## \u6839\
    \u3092\u542B\u3080\u9802\u70B9\u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n     \
    \   return self.nodes.len\n\n    proc patternNode*[chars](self: AhoCorasick[chars],\
    \ index: int): int =\n        ## \u5165\u529B\u306Eindex\u756A\u76EE\u306E\u767B\
    \u9332\u8A9E\u306E\u9802\u70B9ID\u3092\u8FD4\u3059\u3002\u91CD\u8907\u8A9E\u306F\
    \u540C\u3058ID\u3002O(1)\u3002\n        return self.patterns[index]\n\n    proc\
    \ findNode*[chars](self: AhoCorasick[chars], s: string): int =\n        ## s\u306B\
    \u5B8C\u5168\u4E00\u81F4\u3059\u308B\u9802\u70B9ID\u3092\u8FD4\u3059\u3002\u767B\
    \u9332\u8A9E\u306Eprefix\u3082\u5BFE\u8C61\u3068\u3057\u3001\u5B58\u5728\u3057\
    \u306A\u3051\u308C\u3070 -1\u3002O(|s| + 1)\u3002\n        if self.nodes.len ==\
    \ 0:\n            return -1\n        for c in s:\n            if c < chars.a or\
    \ c > chars.b:\n                return -1\n            let child = int(self.nodes[result].next[c])\n\
    \            # failure\u7D4C\u7531\u306E\u9077\u79FB\u3092\u9664\u304D\u3001Trie\u4E0A\
    \u306E\u5B50\u3060\u3051\u3092\u305F\u3069\u308B\u3002\n            if self.nodes[child].parent\
    \ != int32(result):\n                return -1\n            result = child\n\n\
    \    proc next*[chars](self: AhoCorasick[chars], node: int, c: char): int =\n\
    \        ## c\u3092\u8FFD\u52A0\u3057\u305F\u6587\u5B57\u5217\u306E\u6700\u9577\
    suffix\u306B\u5BFE\u5FDC\u3059\u308B\u9802\u70B9\u3078\u9077\u79FB\u3059\u308B\
    \u3002\u7BC4\u56F2\u5916\u306E\u6587\u5B57\u306A\u3089\u6839\u3002O(1)\u3002\n\
    \        doAssert node >= 0 and node < self.nodes.len\n        if c >= chars.a\
    \ and c <= chars.b:\n            result = int(self.nodes[node].next[c])\n\n  \
    \  proc next*[chars](self: AhoCorasick[chars], node: int, s: string): int =\n\
    \        ## s\u3092\u8FFD\u52A0\u3057\u305F\u6587\u5B57\u5217\u306E\u6700\u9577\
    suffix\u306B\u5BFE\u5FDC\u3059\u308B\u9802\u70B9\u3078\u9077\u79FB\u3059\u308B\
    \u3002O(|s| + 1)\u3002\n        doAssert node >= 0 and node < self.nodes.len\n\
    \        result = node\n        for c in s:\n            result = self.next(result,\
    \ c)\n\n    proc getParent*[chars](self: AhoCorasick[chars], node: int): int =\n\
    \        ## Trie\u4E0A\u306E\u89AA\u306E\u9802\u70B9ID\u3092\u8FD4\u3059\u3002\
    \u6839\u306E\u89AA\u306F -1\u3002O(1)\u3002\n        doAssert node >= 0 and node\
    \ < self.nodes.len\n        return int(self.nodes[node].parent)\n\n    proc failure*[chars](self:\
    \ AhoCorasick[chars], node: int): int =\n        ## \u6700\u9577\u306E\u771F\u306E\
    suffix\u306B\u5BFE\u5FDC\u3059\u308B\u9802\u70B9ID\u3092\u8FD4\u3059\u3002\u6839\
    \u3067\u306F0\u3002O(1)\u3002\n        doAssert node >= 0 and node < self.nodes.len\n\
    \        return int(self.nodes[node].failure)\n\n    proc terminal*[chars](self:\
    \ AhoCorasick[chars], node: int): int =\n        ## \u9802\u70B9\u306E\u6587\u5B57\
    \u5217\u3068\u5B8C\u5168\u4E00\u81F4\u3059\u308B\u767B\u9332\u8A9E\u306E\u500B\
    \u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n        doAssert node >= 0 and node\
    \ < self.nodes.len\n        return self.nodes[node].terminal\n\n    proc matchCount*[chars](self:\
    \ AhoCorasick[chars], node: int): int =\n        ## \u73FE\u5728\u4F4D\u7F6E\u3067\
    \u7D42\u308F\u308B\u767B\u9332\u8A9E\u306E\u500B\u6570\u3092\u91CD\u8907\u30FB\
    \u7A7A\u6587\u5B57\u5217\u3082\u542B\u3081\u3066\u8FD4\u3059\u3002O(1)\u3002\n\
    \        doAssert node >= 0 and node < self.nodes.len\n        return self.nodes[node].matched\n\
    \n    iterator matches*[chars](self: AhoCorasick[chars], node: int): int =\n \
    \       ## \u73FE\u5728\u4F4D\u7F6E\u3067\u7D42\u308F\u308B\u767B\u9332\u8A9E\u306E\
    \u9802\u70B9\u3092\u9577\u3044\u9806\u306B\u91CD\u8907\u306A\u304F\u5217\u6319\
    \u3059\u308B\u3002O(\u5217\u6319\u6570 + 1)\u3002\n        doAssert node >= 0\
    \ and node < self.nodes.len\n        var current = int32(node)\n        if self.nodes[current].terminal\
    \ == 0:\n            current = self.nodes[current].output\n        while current\
    \ != -1:\n            yield int(current)\n            current = self.nodes[current].output\n\
    \n    proc restoreString*[chars](self: AhoCorasick[chars], node: int): string\
    \ =\n        ## \u9802\u70B9\u304C\u793A\u3059\u6587\u5B57\u5217\u3092\u5FA9\u5143\
    \u3059\u308B\u3002O(\u6DF1\u3055 + 1)\u3002\n        doAssert node >= 0 and node\
    \ < self.nodes.len\n        var current = node\n        while current != 0:\n\
    \            result.add(self.nodes[current].character)\n            current =\
    \ int(self.nodes[current].parent)\n        for i in 0..<result.len div 2:\n  \
    \          swap(result[i], result[result.high - i])\n\n    proc toTrieGraph*[chars](self:\
    \ AhoCorasick[chars]): WeightedDirectedGraph[char] =\n        ## \u9802\u70B9\
    ID\u3092\u4FDD\u3061\u3001Trie\u306E\u89AA\u304B\u3089\u5B50\u3078\u6587\u5B57\
    \u3092\u91CD\u307F\u3068\u3059\u308B\u8FBA\u3092\u5F35\u308B\u3002\u6642\u9593\
    \u30FB\u7A7A\u9593 O(N)\u3002\n        doAssert self.nodes.len > 0\n        result\
    \ = initWeightedDirectedGraph(self.nodes.len, char, self.nodes.len - 1)\n    \
    \    for node in 1..<self.nodes.len:\n            result.add_edge(int(self.nodes[node].parent),\
    \ node, self.nodes[node].character)\n\n    proc toFailureGraph*[chars](self: AhoCorasick[chars]):\
    \ UnWeightedDirectedGraph =\n        ## \u9802\u70B9ID\u3092\u4FDD\u3061\u3001\
    \u5404\u9802\u70B9\u304B\u3089failure\u5148\u3078\u8FBA\u3092\u5F35\u308B\u3002\
    \u6839\u306E\u81EA\u5DF1\u30EB\u30FC\u30D7\u306F\u9664\u304F\u3002\u6642\u9593\
    \u30FB\u7A7A\u9593 O(N)\u3002\n        doAssert self.nodes.len > 0\n        result\
    \ = initUnWeightedDirectedGraph(self.nodes.len, self.nodes.len - 1)\n        for\
    \ node in 1..<self.nodes.len:\n            result.add_edge(node, int(self.nodes[node].failure))\n\
    \n    proc initAhoCorasickPointer*[chars](self: var AhoCorasick[chars], node:\
    \ int = 0): AhoCorasickPointer[chars] =\n        ## \u6307\u5B9A\u3057\u305F\u9802\
    \u70B9\u3092\u6307\u3059\u30DD\u30A4\u30F3\u30BF\u3092\u4F5C\u308B\u3002\u7701\
    \u7565\u6642\u306F\u6839\u3002O(1)\u3002\n        doAssert node >= 0 and node\
    \ < self.nodes.len\n        result.owner = addr self\n        result.id = int32(node)\n\
    \n    proc nodeId*[chars](self: AhoCorasickPointer[chars]): int =\n        ##\
    \ \u6307\u3057\u3066\u3044\u308B\u9802\u70B9ID\u3092\u8FD4\u3059\u3002O(1)\u3002\
    \n        doAssert self.owner != nil\n        return int(self.id)\n\n    proc\
    \ getParent*[chars](self: AhoCorasickPointer[chars]): AhoCorasickPointer[chars]\
    \ =\n        ## \u73FE\u5728\u306E\u9802\u70B9\u306E\u6587\u5B57\u5217\u304B\u3089\
    \u672B\u5C3E\u30921\u6587\u5B57\u524A\u3063\u305F\u89AA\u3092\u8FD4\u3059\u3002\
    \u6839\u3067\u306F\u547C\u3079\u306A\u3044\u3002O(1)\u3002\n        doAssert self.owner\
    \ != nil and self.id != 0\n        result = self\n        result.id = int32(self.owner[].getParent(self.id))\n\
    \n    proc failure*[chars](self: AhoCorasickPointer[chars]): AhoCorasickPointer[chars]\
    \ =\n        ## \u6700\u9577\u306E\u771F\u306Esuffix\u306B\u5BFE\u5FDC\u3059\u308B\
    \u9802\u70B9\u3092\u6307\u3059\u30DD\u30A4\u30F3\u30BF\u3092\u8FD4\u3059\u3002\
    \u6839\u3067\u306F\u6839\u3092\u8FD4\u3059\u3002O(1)\u3002\n        doAssert self.owner\
    \ != nil\n        result = self\n        result.id = int32(self.owner[].failure(self.id))\n\
    \n    proc next*[chars](self: AhoCorasickPointer[chars], c: char): AhoCorasickPointer[chars]\
    \ =\n        ## c\u3092\u8FFD\u52A0\u3057\u3001\u6700\u9577suffix\u3078\u9077\u79FB\
    \u3057\u305F\u30DD\u30A4\u30F3\u30BF\u3092\u8FD4\u3059\u3002O(1)\u3002\n     \
    \   doAssert self.owner != nil\n        result = self\n        result.id = int32(self.owner[].next(self.id,\
    \ c))\n\n    proc next*[chars](self: AhoCorasickPointer[chars], s: string): AhoCorasickPointer[chars]\
    \ =\n        ## s\u3092\u8FFD\u52A0\u3057\u3001\u6700\u9577suffix\u3078\u9077\u79FB\
    \u3057\u305F\u30DD\u30A4\u30F3\u30BF\u3092\u8FD4\u3059\u3002O(|s| + 1)\u3002\n\
    \        doAssert self.owner != nil\n        result = self\n        result.id\
    \ = int32(self.owner[].next(self.id, s))\n\n    proc `&`*[chars](self: AhoCorasickPointer[chars],\
    \ s: char|string): AhoCorasickPointer[chars] =\n        ## \u6587\u5B57\u307E\u305F\
    \u306F\u6587\u5B57\u5217\u3092\u8FFD\u52A0\u3057\u3066\u9077\u79FB\u3057\u305F\
    \u30DD\u30A4\u30F3\u30BF\u3092\u8FD4\u3059\u3002O(|s| + 1)\u3002\n        return\
    \ self.next(s)\n\n    proc add*[chars](self: var AhoCorasickPointer[chars], s:\
    \ char|string) =\n        ## \u6587\u5B57\u307E\u305F\u306F\u6587\u5B57\u5217\u3092\
    \u8FFD\u52A0\u3057\u3066\u6700\u9577suffix\u3078\u79FB\u52D5\u3059\u308B\u3002\
    O(|s| + 1)\u3002\n        self = self.next(s)\n\n    proc `&=`*[chars](self: var\
    \ AhoCorasickPointer[chars], s: char|string) =\n        ## \u6587\u5B57\u307E\u305F\
    \u306F\u6587\u5B57\u5217\u3092\u8FFD\u52A0\u3057\u3066\u6700\u9577suffix\u3078\
    \u79FB\u52D5\u3059\u308B\u3002O(|s| + 1)\u3002\n        self.add(s)\n\n    proc\
    \ terminal*[chars](self: AhoCorasickPointer[chars]): int =\n        ## \u6307\u3057\
    \u3066\u3044\u308B\u6587\u5B57\u5217\u3068\u5B8C\u5168\u4E00\u81F4\u3059\u308B\
    \u767B\u9332\u8A9E\u306E\u500B\u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n     \
    \   doAssert self.owner != nil\n        return self.owner[].terminal(self.id)\n\
    \n    proc matchCount*[chars](self: AhoCorasickPointer[chars]): int =\n      \
    \  ## \u73FE\u5728\u4F4D\u7F6E\u3067\u7D42\u308F\u308B\u767B\u9332\u8A9E\u306E\
    \u500B\u6570\u3092\u91CD\u8907\u30FB\u7A7A\u6587\u5B57\u5217\u3082\u542B\u3081\
    \u3066\u8FD4\u3059\u3002O(1)\u3002\n        doAssert self.owner != nil\n     \
    \   return self.owner[].matchCount(self.id)\n\n    iterator matches*[chars](self:\
    \ AhoCorasickPointer[chars]): int =\n        ## \u73FE\u5728\u4F4D\u7F6E\u3067\
    \u7D42\u308F\u308B\u767B\u9332\u8A9E\u306E\u9802\u70B9\u3092\u9577\u3044\u9806\
    \u306B\u91CD\u8907\u306A\u304F\u5217\u6319\u3059\u308B\u3002O(\u5217\u6319\u6570\
    \ + 1)\u3002\n        doAssert self.owner != nil\n        for node in self.owner[].matches(self.id):\n\
    \            yield node\n\n    proc restoreString*[chars](self: AhoCorasickPointer[chars]):\
    \ string =\n        ## \u6307\u3057\u3066\u3044\u308B\u9802\u70B9\u306E\u6587\u5B57\
    \u5217\u3092\u5FA9\u5143\u3059\u308B\u3002O(\u6DF1\u3055 + 1)\u3002\n        doAssert\
    \ self.owner != nil\n        return self.owner[].restoreString(self.id)\n\n  \
    \  proc `$`*[chars](self: AhoCorasickPointer[chars]): string =\n        ## \u6307\
    \u3057\u3066\u3044\u308B\u9802\u70B9\u3092\u6587\u5B57\u5217\u3068\u3057\u3066\
    \u8FD4\u3059\u3002O(\u6DF1\u3055 + 1)\u3002\n        return self.restoreString()\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/str/aho_corasick.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/aho_corasick_test.nim
  - verify/AI/aho_corasick_test.nim
documentation_of: cplib/str/aho_corasick.nim
layout: document
redirect_from:
- /library/cplib/str/aho_corasick.nim
- /library/cplib/str/aho_corasick.nim.html
title: cplib/str/aho_corasick.nim
---
