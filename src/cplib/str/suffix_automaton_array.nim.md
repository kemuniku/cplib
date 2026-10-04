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
    path: verify/str/suffix_automaton_array_number_of_substrings_test.nim
    title: verify/str/suffix_automaton_array_number_of_substrings_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/suffix_automaton_array_number_of_substrings_test.nim
    title: verify/str/suffix_automaton_array_number_of_substrings_test.nim
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
  code: "when not declared CPLIB_STR_SUFFIX_AUTOMATON_ARRAY:\n    ## \u56FA\u5B9A\u6587\
    \u5B57\u7BC4\u56F2\u306Earray\u9077\u79FB\u3067\u9023\u7D9A\u90E8\u5206\u6587\u5B57\
    \u5217\u3092\u8A8D\u8B58\u3059\u308B\u30AA\u30F3\u30E9\u30A4\u30F3Suffix Automaton\u3002\
    \n    ## chars\u306F\u30B3\u30F3\u30D1\u30A4\u30EB\u6642\u306E\u975E\u7A7AHSlice[char,char]\u3002\
    string\u306FUnicode\u6587\u5B57\u3067\u306A\u304Fbyte\u5217\u3068\u3057\u3066\u6271\
    \u3046\u3002\n    ## \u4EFB\u610F\u306Ehashable\u8981\u7D20\u5217\u306Etable\u7248\
    \u306F cplib/str/suffix_automaton_table \u3092\u4F7F\u3046\u3002\n    ## 1\u72B6\
    \u614B\u306F\u7D42\u7AEF\u4F4D\u7F6E\u96C6\u5408\u304C\u7B49\u3057\u3044\u6587\
    \u5B57\u5217\u7FA4\u3092\u8868\u3057\u3001\u5358\u4E00\u306E\u6587\u5B57\u5217\
    \u3068\u306F\u9650\u3089\u306A\u3044\u3002\n    ## \u72B6\u614Bv\u306E\u9577\u3055\
    \u7BC4\u56F2\u306F nodes[nodes[v].link].len + 1 .. nodes[v].len\uFF08\u6839\u3092\
    \u9664\u304F\uFF09\u3002\n    ## \u6839\u304B\u3089\u306E\u7D4C\u8DEF\u304C\u5168\
    \u9023\u7D9A\u90E8\u5206\u6587\u5B57\u5217\u3001last\u304B\u3089suffix link\u3092\
    \u305F\u3069\u3063\u305F\u72B6\u614B\u304C\u5168suffix\u3092\u8868\u3059\u3002\
    \n    ## extend\u5F8C\u3082\u72B6\u614BID\u306F\u6709\u52B9\u3060\u304C\u3001\u65E2\
    \u5B58\u72B6\u614B\u306Elink\u3068next\u306F\u5909\u308F\u308B\u5834\u5408\u304C\
    \u3042\u308B\u3002\n    ## next[c]\u306Fint32\u306E\u9077\u79FB\u5148ID\u3001\u4E0D\
    \u5728\u306F -1\u3002clone\u306E\u914D\u5217\u306F\u5024\u30B3\u30D4\u30FC\u3067\
    \u72EC\u7ACB\u3059\u308B\u3002\n    ## \u7BC0\u70B9\u6570\u304Cint32.high\u4EE5\
    \u4E0A\u306A\u3089extend\u306F\u5909\u66F4\u524D\u306BValueError\u3002\u516C\u958B\
    \u30E1\u30BD\u30C3\u30C9\u306EID\u306Fint\u3002\n    ## \u521D\u671F\u5316\u3057\
    \u305F\u7A7ASAM\u306F\u68391\u72B6\u614B\u3001\u7A7A\u6587\u5B57\u5217\u3092\u8A8D\
    \u8B58\u3057\u3001\u7570\u306A\u308B\u90E8\u5206\u6587\u5B57\u5217\u6570\u306F\
    \u7A7A\u3092\u9664\u3044\u30660\u3002\n    ## default\u5024\u306F\u672A\u521D\u671F\
    \u5316\u3067\u3001findNode\u306F\u7A7A\u3082 -1\u3002\u6700\u521D\u306Eextend\u3067\
    \u81EA\u52D5\u521D\u671F\u5316\u3059\u308B\u3002\n    ## occurrence\u96C6\u7D04\
    \u3084\u7D42\u7AEF\u30D5\u30E9\u30B0\u306F\u4FDD\u6301\u3057\u306A\u3044\u3002\
    nodes\u30FBlast\u306E\u76F4\u63A5\u5909\u66F4\u306F\u4E0D\u53EF\u3002\n    ##\
    \ \u03C3 = ord(chars.b) - ord(chars.a) + 1\u3002N\u6587\u5B57\u306E\u69CB\u7BC9\
    \u6642\u9593\u30FB\u7A7A\u9593 O((N + 1)\u03C3)\u3002\n    ## \u914D\u5217\u521D\
    \u671F\u5316\u30FBclone\u306E\u30B3\u30D4\u30FC\u306B O(\u03C3)\u3002\u03C3\u56FA\
    \u5B9A\u306A\u3089extend\u306F\u511F\u5374 O(1)\u3002\n    ## seq\u306E\u518D\u78BA\
    \u4FDD\u3092\u542B\u30801\u56DE\u306Eextend\u306F\u6700\u60AA O((N + 1)\u03C3\
    )\u3002\n    ## \u4F7F\u7528\u4F8B:\n    ##   var sam = initSuffixAutomatonArray('a'..'z')\n\
    \    ##   discard sam.extend('a')\n    ##   discard sam.extend('b')\n    ##  \
    \ let v = sam.findNode(\"ab\")  # v == sam.last\n    ##   let missing = sam.next(v,\
    \ 'a')  # -1\n    ##   let count = sam.countDistinctSubstrings()  # 3\uFF08\u7A7A\
    \u3092\u9664\u304F\uFF09\n    ##   let digits = initSuffixAutomatonArray(\"01201\"\
    , '0'..'9')\n    const CPLIB_STR_SUFFIX_AUTOMATON_ARRAY* = 1\n\n    type\n   \
    \     SuffixAutomatonArrayNode*[chars: static[HSlice[char, char]]] = object\n\
    \            ## \u6839\u306F0\u3002len\u306F\u6700\u5927\u9577\u3001link\u306F\
    suffix link\uFF08\u6839\u3067\u306F -1\uFF09\u3001next\u306F\u6587\u5B57\u3067\
    \u76F4\u63A5\u6DFB\u5B57\u5316\u3059\u308B\u3002\n            len*: int\n    \
    \        link*: int\n            next*: array[chars.a..chars.b, int32]\n     \
    \   SuffixAutomatonArray*[chars: static[HSlice[char, char]]] = object\n      \
    \      ## initSuffixAutomatonArray\u3067\u521D\u671F\u5316\u3059\u308B\u3002\u516C\
    \u958B\u30D5\u30A3\u30FC\u30EB\u30C9\u306F\u53C2\u7167\u30FB\u9077\u79FB\u5217\
    \u6319\u7528\u3002\n            nodes*: seq[SuffixAutomatonArrayNode[chars]]\n\
    \            last*: int\n\n    proc initSuffixAutomatonArrayNode(chars: static[HSlice[char,\
    \ char]]): SuffixAutomatonArrayNode[chars] =\n        ## \u5168\u9077\u79FB\u3092\
    \u4E0D\u5728\u306B\u3057\u305F\u72B6\u614B\u3092\u4F5C\u308B\u3002O(\u03C3)\u3002\
    \n        for c in chars.a..chars.b:\n            result.next[c] = -1\n\n    proc\
    \ initSuffixAutomatonArray*(chars: static[HSlice[char, char]]): SuffixAutomatonArray[chars]\
    \ =\n        ## \u6307\u5B9A\u6587\u5B57\u7BC4\u56F2\u306E\u7A7ASAM\u3092\u4F5C\
    \u308B\u3002\u9006\u9806\u306E\u7BC4\u56F2\u306F\u30B3\u30F3\u30D1\u30A4\u30EB\
    \u30A8\u30E9\u30FC\u3002\u6642\u9593\u30FB\u7A7A\u9593 O(\u03C3)\u3002\n     \
    \   when chars.a > chars.b:\n            {.error: \"SuffixAutomatonArray requires\
    \ a nonempty character range\".}\n        var node = initSuffixAutomatonArrayNode(chars)\n\
    \        node.link = -1\n        result.nodes.add(node)\n\n    proc extend*[chars](self:\
    \ var SuffixAutomatonArray[chars], c: char): int =\n        ## \u672B\u5C3E\u306B\
    1\u6587\u5B57\u8FFD\u52A0\u3057\u5168\u4F53\u306E\u72B6\u614BID\u3092\u8FD4\u3059\
    \u3002\u5168N\u6587\u5B57\u3067 O((N + 1)\u03C3)\u3002\u7BC4\u56F2\u5916\u306F\
    \u5909\u66F4\u524D\u306BValueError\u3002\n        if c < chars.a or c > chars.b:\n\
    \            raise newException(ValueError, \"character outside SuffixAutomatonArray\
    \ alphabet\")\n        if self.nodes.len >= int(high(int32)):\n            raise\
    \ newException(ValueError, \"too many SuffixAutomatonArray states\")\n       \
    \ if self.nodes.len == 0:\n            self = initSuffixAutomatonArray(chars)\n\
    \        result = self.nodes.len\n        var node = initSuffixAutomatonArrayNode(chars)\n\
    \        node.len = self.nodes[self.last].len + 1\n        self.nodes.add(node)\n\
    \        var p = self.last\n        while p != -1 and self.nodes[p].next[c] ==\
    \ -1:\n            self.nodes[p].next[c] = int32(result)\n            p = self.nodes[p].link\n\
    \        if p != -1:\n            let q = int(self.nodes[p].next[c])\n       \
    \     if self.nodes[p].len + 1 == self.nodes[q].len:\n                self.nodes[result].link\
    \ = q\n            else:\n                let clone = self.nodes.len\n       \
    \         var cloned = self.nodes[q]\n                cloned.len = self.nodes[p].len\
    \ + 1\n                self.nodes.add(cloned)\n                while p != -1 and\
    \ int(self.nodes[p].next[c]) == q:\n                    self.nodes[p].next[c]\
    \ = int32(clone)\n                    p = self.nodes[p].link\n               \
    \ self.nodes[q].link = clone\n                self.nodes[result].link = clone\n\
    \        self.last = result\n\n    proc initSuffixAutomatonArray*(s: openArray[char],\
    \ chars: static[HSlice[char, char]]): SuffixAutomatonArray[chars] =\n        ##\
    \ \u6587\u5B57\u5217\u30FB\u6587\u5B57\u914D\u5217\u304B\u3089\u69CB\u7BC9\u3059\
    \u308B\u3002\u7BC4\u56F2\u5916\u306FValueError\u3002\u6642\u9593\u30FB\u7A7A\u9593\
    \ O((|s| + 1)\u03C3)\u3002\n        result = initSuffixAutomatonArray(chars)\n\
    \        for c in s:\n            discard result.extend(c)\n\n    proc root*[chars](self:\
    \ SuffixAutomatonArray[chars]): int =\n        ## \u6839\u306E\u72B6\u614BID\uFF08\
    0\uFF09\u3092\u8FD4\u3059\u3002O(1)\u3002\n        return 0\n\n    proc nodeCount*[chars](self:\
    \ SuffixAutomatonArray[chars]): int =\n        ## \u6839\u30FBclone\u3092\u542B\
    \u3080\u72B6\u614B\u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n        return self.nodes.len\n\
    \n    proc next*[chars](self: SuffixAutomatonArray[chars], node: int, c: char):\
    \ int =\n        ## \u6709\u52B9\u306A\u72B6\u614Bnode\u304B\u3089c\u3067\u9077\
    \u79FB\u3057\u305FID\u3092\u8FD4\u3059\u3002\u4E0D\u5728\u30FB\u7BC4\u56F2\u5916\
    \u306F -1\u3002\u5909\u66F4\u305B\u305A O(1)\u3002\n        if c < chars.a or\
    \ c > chars.b:\n            return -1\n        return int(self.nodes[node].next[c])\n\
    \n    proc findNode*[chars](self: SuffixAutomatonArray[chars], s: openArray[char]):\
    \ int =\n        ## \u9023\u7D9A\u90E8\u5206\u6587\u5B57\u5217s\u3092\u305F\u3069\
    \u308B\u3002\u7A7A\u306F\u6839\u3001\u4E0D\u5728\u30FB\u7BC4\u56F2\u5916\u306F\
    \ -1\u3002O(|s| + 1)\u3002\n        if self.nodes.len == 0:\n            return\
    \ -1\n        for c in s:\n            result = self.next(result, c)\n       \
    \     if result == -1:\n                return\n\n    proc contains*[chars](self:\
    \ SuffixAutomatonArray[chars], s: openArray[char]): bool =\n        ## \u9023\u7D9A\
    \u90E8\u5206\u6587\u5B57\u5217s\u304C\u5B58\u5728\u3059\u308B\u304B\u3092\u8FD4\
    \u3059\u3002\u7A7A\u3082\u542B\u3080\u3002\u7BC4\u56F2\u5916\u306Ffalse\u3002\
    O(|s| + 1)\u3002\n        return self.findNode(s) != -1\n\n    proc countDistinctSubstrings*[chars](self:\
    \ SuffixAutomatonArray[chars]): int64 =\n        ## \u7A7A\u3092\u9664\u304F\u7570\
    \u306A\u308B\u9023\u7D9A\u90E8\u5206\u6587\u5B57\u5217\u306E\u500B\u6570\u3092\
    \u8FD4\u3059\u3002\u6642\u9593 O(\u72B6\u614B\u6570)\u3001\u8FFD\u52A0\u7A7A\u9593\
    \ O(1)\u3002\n        for node in 1..<self.nodes.len:\n            result += int64(self.nodes[node].len\
    \ - self.nodes[self.nodes[node].link].len)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/suffix_automaton_array.nim
  requiredBy: []
  timestamp: '2026-10-04 16:38:19+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/suffix_automaton_array_test.nim
  - verify/AI/suffix_automaton_array_test.nim
  - verify/str/suffix_automaton_array_number_of_substrings_test.nim
  - verify/str/suffix_automaton_array_number_of_substrings_test.nim
documentation_of: cplib/str/suffix_automaton_array.nim
layout: document
redirect_from:
- /library/cplib/str/suffix_automaton_array.nim
- /library/cplib/str/suffix_automaton_array.nim.html
title: cplib/str/suffix_automaton_array.nim
---
