---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/suffix_automaton_array_test.nim
    title: verify/AI/suffix_automaton_array_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/suffix_automaton_array_test.nim
    title: verify/AI/suffix_automaton_array_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/suffix_automaton_table_test.nim
    title: verify/AI/suffix_automaton_table_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/suffix_automaton_table_test.nim
    title: verify/AI/suffix_automaton_table_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/suffix_automaton_table_number_of_substrings_test.nim
    title: verify/str/suffix_automaton_table_number_of_substrings_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/suffix_automaton_table_number_of_substrings_test.nim
    title: verify/str/suffix_automaton_table_number_of_substrings_test.nim
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
  code: "when not declared CPLIB_STR_SUFFIX_AUTOMATON_TABLE:\n    ## Table\u9077\u79FB\
    \u3067\u9023\u7D9A\u90E8\u5206\u6587\u5B57\u5217\u3092\u8A8D\u8B58\u3059\u308B\
    \u30AA\u30F3\u30E9\u30A4\u30F3Suffix Automaton\u3002\n    ## \u56FA\u5B9A\u6587\
    \u5B57\u7BC4\u56F2\u306Earray\u7248\u306F cplib/str/suffix_automaton_array \u3092\
    \u4F7F\u3046\u3002\n    ## string\u306FNUL\u30FB\u975EASCII\u3082\u542B\u3081\
    0..255\u306Ebyte\u5217\u3068\u3057\u3066\u6271\u3046\u3002\u6574\u6570\u5217\u306A\
    \u3069\u306EopenArray\u306B\u3082\u5BFE\u5FDC\u3002\n    ## 1\u72B6\u614B\u306F\
    \u7D42\u7AEF\u4F4D\u7F6E\u96C6\u5408\u304C\u7B49\u3057\u3044\u6587\u5B57\u5217\
    \u7FA4\u3092\u8868\u3057\u3001\u5358\u4E00\u306E\u6587\u5B57\u5217\u3068\u306F\
    \u9650\u3089\u306A\u3044\u3002\n    ## \u72B6\u614Bv\u306E\u9577\u3055\u7BC4\u56F2\
    \u306F nodes[nodes[v].link].len + 1 .. nodes[v].len\uFF08\u6839\u3092\u9664\u304F\
    \uFF09\u3002\n    ## \u6839\u304B\u3089\u306E\u7D4C\u8DEF\u304C\u5168\u9023\u7D9A\
    \u90E8\u5206\u6587\u5B57\u5217\u3001last\u304B\u3089suffix link\u3092\u305F\u3069\
    \u3063\u305F\u72B6\u614B\u304C\u5168suffix\u3092\u8868\u3059\u3002\n    ## extend\u5F8C\
    \u3082\u72B6\u614BID\u306F\u6709\u52B9\u3060\u304C\u3001\u65E2\u5B58\u72B6\u614B\
    \u306Elink\u3068next\u306F\u5909\u308F\u308B\u5834\u5408\u304C\u3042\u308B\u3002\
    \n    ## \u9077\u79FB\u8868\u306E\u5217\u6319\u306B\u306F\u547C\u3073\u51FA\u3057\
    \u5074\u3067\u3082import tables\u3092\u4F7F\u3046\u3002occurrence\u96C6\u7D04\u3084\
    \u7D42\u7AEF\u30D5\u30E9\u30B0\u306F\u4FDD\u6301\u3057\u306A\u3044\u3002\n   \
    \ ## \u521D\u671F\u5316\u3057\u305F\u7A7ASAM\u306F\u68391\u72B6\u614B\u3001\u7A7A\
    \u6587\u5B57\u5217\u3092\u8A8D\u8B58\u3057\u3001\u7570\u306A\u308B\u90E8\u5206\
    \u6587\u5B57\u5217\u6570\u306F\u7A7A\u3092\u9664\u3044\u30660\u3002\n    ## default\u5024\
    \u306F\u672A\u521D\u671F\u5316\u3067\u3001findNode\u306F\u7A7A\u3082 -1\u3002\u6700\
    \u521D\u306Eextend\u3067\u81EA\u52D5\u521D\u671F\u5316\u3059\u308B\u3002\n   \
    \ ## \u72B6\u614B\u30FB\u9077\u79FB\u6570\u306F O(N)\u3002\u671F\u5F85\u6642\u9593\
    \u306Fhash\u30FB==\u304C O(1) \u306E\u5834\u5408\u3067\u30011\u56DE\u306Eextend\u306F\
    \ O(N) \u306B\u306A\u308A\u5F97\u308B\u3002\n    ## \u4F7F\u7528\u4F8B:\n    ##\
    \   var sam = initSuffixAutomatonTable(char)\n    ##   discard sam.extend('a')\n\
    \    ##   discard sam.extend('b')\n    ##   let v = sam.findNode(\"ab\")  # v\
    \ == sam.last\n    ##   let length = sam.nodes[v].len  # 2\n    ##   let suffix\
    \ = sam.nodes[v].link  # \"b\"\u306E\u72B6\u614B\n    ##   let missing = sam.next(v,\
    \ 'a')  # -1\u3001\u9077\u79FB\u8868\u306F\u5909\u66F4\u3057\u306A\u3044\n   \
    \ ##   let count = sam.countDistinctSubstrings()  # 3\uFF08\u7A7A\u3092\u9664\u304F\
    \uFF09\n    const CPLIB_STR_SUFFIX_AUTOMATON_TABLE* = 1\n    import tables\n\n\
    \    type\n        SuffixAutomatonTableNode*[T] = object\n            ## \u6839\
    \u306F0\u3002len\u306F\u6700\u5927\u9577\u3001link\u306Fsuffix link\uFF08\u6839\
    \u3067\u306F -1\uFF09\u3001next\u306F\u6587\u5B57\u304B\u3089\u9077\u79FB\u5148\
    ID\u3078\u306E\u8868\u3002\n            len*: int\n            link*: int\n  \
    \          next*: Table[T, int]\n        SuffixAutomatonTable*[T] = object\n \
    \           ## initSuffixAutomatonTable\u3067\u521D\u671F\u5316\u3059\u308B\u3002\
    nodes\u30FBlast\u306E\u76F4\u63A5\u5909\u66F4\u306F\u4E0D\u53EF\u3002T\u306B\u306F\
    hash\u3068==\u304C\u5FC5\u8981\u3002\n            nodes*: seq[SuffixAutomatonTableNode[T]]\n\
    \            last*: int\n\n    proc initSuffixAutomatonTable*(T: typedesc): SuffixAutomatonTable[T]\
    \ =\n        ## \u7A7A\u306E\u5217\u306ESAM\u3092\u4F5C\u308B\u3002\u6839\u3060\
    \u3051\u3092\u542B\u3080\u3002\u6642\u9593\u30FB\u7A7A\u9593 O(1)\u3002\n    \
    \    result.nodes.add(SuffixAutomatonTableNode[T](link: -1))\n\n    proc extend*[T](self:\
    \ var SuffixAutomatonTable[T], c: T): int =\n        ## \u672B\u5C3E\u306B1\u8981\
    \u7D20\u8FFD\u52A0\u3057\u3001\u5217\u5168\u4F53\u306E\u72B6\u614BID\u3092\u8FD4\
    \u3059\u3002\u5168N\u8981\u7D20\u3067\u671F\u5F85 O(N)\u3001\u7A7A\u9593 O(N)\u3002\
    \n        if self.nodes.len == 0:\n            self = initSuffixAutomatonTable(T)\n\
    \        result = self.nodes.len\n        self.nodes.add(SuffixAutomatonTableNode[T](len:\
    \ self.nodes[self.last].len + 1))\n        var p = self.last\n        while p\
    \ != -1 and not self.nodes[p].next.hasKey(c):\n            if self.nodes[p].next.len\
    \ == 0:\n                self.nodes[p].next = initTable[T, int](1)\n         \
    \   self.nodes[p].next[c] = result\n            p = self.nodes[p].link\n     \
    \   if p != -1:\n            let q = self.nodes[p].next[c]\n            if self.nodes[p].len\
    \ + 1 == self.nodes[q].len:\n                self.nodes[result].link = q\n   \
    \         else:\n                let clone = self.nodes.len\n                #\
    \ clone\u306E\u9077\u79FB\u8868\u3092\u72EC\u7ACB\u3055\u305B\u3001\u4EE5\u5F8C\
    \u306E\u66F4\u65B0\u304Cq\u3078\u6CE2\u53CA\u3057\u306A\u3044\u3088\u3046\u306B\
    \u3059\u308B\u3002\n                var node = SuffixAutomatonTableNode[T](len:\
    \ self.nodes[p].len + 1, link: self.nodes[q].link,\n                    next:\
    \ initTable[T, int](max(1, self.nodes[q].next.len)))\n                for key,\
    \ value in tables.pairs(self.nodes[q].next):\n                    node.next[key]\
    \ = value\n                self.nodes.add(node)\n                while p != -1\
    \ and self.nodes[p].next.getOrDefault(c, -1) == q:\n                    self.nodes[p].next[c]\
    \ = clone\n                    p = self.nodes[p].link\n                self.nodes[q].link\
    \ = clone\n                self.nodes[result].link = clone\n        self.last\
    \ = result\n\n    proc initSuffixAutomatonTable*[T](s: openArray[T]): SuffixAutomatonTable[T]\
    \ =\n        ## \u5217\u304B\u3089SAM\u3092\u4F5C\u308B\u3002hash\u30FB==\u304C\
    \ O(1) \u306E\u3068\u304D\u671F\u5F85\u6642\u9593 O(|s| + 1)\u3001\u7A7A\u9593\
    \ O(|s| + 1)\u3002\n        result = initSuffixAutomatonTable(T)\n        for\
    \ c in s:\n            discard result.extend(c)\n\n    proc root*[T](self: SuffixAutomatonTable[T]):\
    \ int =\n        ## \u6839\u306E\u72B6\u614BID\uFF080\uFF09\u3092\u8FD4\u3059\u3002\
    O(1)\u3002\n        return 0\n\n    proc nodeCount*[T](self: SuffixAutomatonTable[T]):\
    \ int =\n        ## \u6839\u30FBclone\u3092\u542B\u3080\u72B6\u614B\u6570\u3092\
    \u8FD4\u3059\u3002O(1)\u3002\n        return self.nodes.len\n\n    proc next*[T](self:\
    \ SuffixAutomatonTable[T], node: int, c: T): int =\n        ## \u6709\u52B9\u306A\
    \u72B6\u614Bnode\u304B\u3089c\u3067\u9077\u79FB\u3057\u305FID\u3092\u8FD4\u3059\
    \u3002\u4E0D\u5728\u306F -1\u3002\u8868\u3092\u5909\u66F4\u305B\u305A\u671F\u5F85\
    \ O(1)\u3002\n        return self.nodes[node].next.getOrDefault(c, -1)\n\n   \
    \ proc findNode*[T](self: SuffixAutomatonTable[T], s: openArray[T]): int =\n \
    \       ## \u90E8\u5206\u5217\u3067\u306A\u304F\u9023\u7D9A\u90E8\u5206\u6587\u5B57\
    \u5217s\u3092\u305F\u3069\u308B\u3002\u7A7A\u306F\u6839\u3001\u4E0D\u5728\u306F\
    \ -1\u3002\u671F\u5F85 O(|s| + 1)\u3002\n        if self.nodes.len == 0:\n   \
    \         return -1\n        for c in s:\n            result = self.next(result,\
    \ c)\n            if result == -1:\n                return\n\n    proc contains*[T](self:\
    \ SuffixAutomatonTable[T], s: openArray[T]): bool =\n        ## \u9023\u7D9A\u90E8\
    \u5206\u6587\u5B57\u5217s\u304C\u5B58\u5728\u3059\u308B\u304B\u3092\u8FD4\u3059\
    \u3002\u7A7A\u3082\u542B\u3080\u3002\u671F\u5F85 O(|s| + 1)\u3002\n        return\
    \ self.findNode(s) != -1\n\n    proc countDistinctSubstrings*[T](self: SuffixAutomatonTable[T]):\
    \ int64 =\n        ## \u7A7A\u3092\u9664\u304F\u7570\u306A\u308B\u9023\u7D9A\u90E8\
    \u5206\u6587\u5B57\u5217\u306E\u500B\u6570\u3092\u8FD4\u3059\u3002\u6642\u9593\
    \ O(\u72B6\u614B\u6570)\u3001\u8FFD\u52A0\u7A7A\u9593 O(1)\u3002\n        for\
    \ node in 1..<self.nodes.len:\n            result += int64(self.nodes[node].len\
    \ - self.nodes[self.nodes[node].link].len)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/suffix_automaton_table.nim
  requiredBy: []
  timestamp: '2026-10-04 16:38:19+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/suffix_automaton_array_test.nim
  - verify/AI/suffix_automaton_array_test.nim
  - verify/AI/suffix_automaton_table_test.nim
  - verify/AI/suffix_automaton_table_test.nim
  - verify/str/suffix_automaton_table_number_of_substrings_test.nim
  - verify/str/suffix_automaton_table_number_of_substrings_test.nim
documentation_of: cplib/str/suffix_automaton_table.nim
layout: document
redirect_from:
- /library/cplib/str/suffix_automaton_table.nim
- /library/cplib/str/suffix_automaton_table.nim.html
title: cplib/str/suffix_automaton_table.nim
---
