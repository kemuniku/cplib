---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/trie_string_import_test.nim
    title: verify/str/trie_string_import_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/trie_string_import_test.nim
    title: verify/str/trie_string_import_test.nim
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
  code: "when not declared CPLIB_STR_TRIE_STRING:\n    ## Trie\u306Earena\u3068\u578B\
    \u4ED8\u304D\u7BC0\u70B9\u3067\u904E\u53BB\u306E\u6587\u5B57\u5217\u30FB\u8981\
    \u7D20\u5217\u3092\u4FDD\u6301\u3059\u308B\u3002\u540C\u3058(\u89AA,\u8981\u7D20\
    )\u306F\u540C\u3058\u7BC0\u70B9\u306B\u306A\u308B\u3002\n    ## initTrieStringArray('a'..'z')\
    \ / initTrieStringTable(T)\u3067arena\u3092\u4F5C\u308A\u3001root\u3067\u7A7A\u5217\
    \u306E\u7BC0\u70B9\u3092\u5F97\u308B\u3002\n    ## TrieStringArrayNode[chars]\
    \ / TrieStringTableNode[T]\u306Fowner\u306E\u5F37\u53C2\u7167\u3068\u5185\u90E8\
    \u6DFB\u5B57\u3092\u6301\u3064\u5024\u578B\u3002\n    ## \u7BC0\u70B9\u30B3\u30D4\
    \u30FC\u30FBarena\u306Eseq\u518D\u78BA\u4FDD\u30FB\u5143\u306Earena\u5909\u6570\
    \u306E\u30B9\u30B3\u30FC\u30D7\u7D42\u4E86\u5F8C\u3082\u5B89\u5168\u306B\u5229\
    \u7528\u3067\u304D\u308B\u3002\n    ## arena\u306E\u30B3\u30D4\u30FC\u306F\u540C\
    \u4E00arena\u3092\u5171\u6709\u3059\u308B\u3002\u7BC0\u70B9\u306E\u5185\u90E8\u72B6\
    \u614B\u306F\u5909\u66F4\u3067\u304D\u305A\u3001\u6574\u6570ID\u304B\u3089\u306F\
    \u751F\u6210\u3067\u304D\u306A\u3044\u3002\n    ## N.add(c)\u3001N.pop()\u3001\
    N.cmp(M)\u3001N.lcp(M)\u3001N.lcpNode(M)\u3001N.prefix(length)\u3001N[index]\u3092\
    \u4F7F\u3046\u3002\n    ## \u7BC0\u70B9\u306E<\u3001<=\u3001>\u3001>=\u306F\u8981\
    \u7D20\u5217\u306E\u8F9E\u66F8\u9806\u3067\u6BD4\u8F03\u3059\u308B\u3002\u6700\
    \u60AAO(log N)\u3002\n    ## $N\u306Fchar\u7248\u3001N.toSeq()\u306F\u4E21\u7248\
    \u3002N.len / N.length\u306F\u8981\u7D20\u6570\u3001arena.nodeCount\u306F\u7DCF\
    \u7BC0\u70B9\u6570\u3002\n    ## N.id\u306Farena\u5185\u3067\u4E00\u610F\u306A\
    \u8AAD\u307F\u53D6\u308A\u5C02\u7528ID\u3002\u6839\u306F0\u3001\u65B0\u7BC0\u70B9\
    \u306F\u4F5C\u6210\u9806\u3067\u3001\u8FFD\u52A0\u5F8C\u3082\u5909\u308F\u3089\
    \u306A\u3044\u3002\u53D6\u5F97O(1)\u3002\n    ## add/pop\u306F\u65B0\u3057\u3044\
    \u7BC0\u70B9\u30CF\u30F3\u30C9\u30EB\u3092\u8FD4\u3057\u3001\u5143\u306E\u30CF\
    \u30F3\u30C9\u30EB\u3068\u5C65\u6B74\u3092\u5909\u66F4\u3057\u306A\u3044\u3002\
    \u6839\u306Epop\u306F\u6839\u3002\n    ## \u6BD4\u8F03\u30FBLCP\u30FB\u7BC0\u70B9\
    \u306E==\u306F\u540C\u3058owner\u306E\u307F\u8A31\u3059\u3002\u7570\u306A\u308B\
    owner\u3001default\u7BC0\u70B9\u306FValueError\u3002\n    ## \u7570\u306A\u308B\
    \u8981\u7D20\u578B\u30FBArray\u306E\u7570\u306A\u308B\u6587\u5B57\u7BC4\u56F2\u306E\
    \u7BC0\u70B9\u540C\u58EB\u306E\u6F14\u7B97\u306F\u578B\u691C\u67FB\u3067\u62D2\
    \u5426\u3055\u308C\u308B\u3002\n    ## prefix\u306E\u9577\u3055\u306F0..N.length\u3001\
    \u6DFB\u5B57\u306F0..<N.length\u3002\u7BC4\u56F2\u5916\u306F\u5207\u308A\u8A70\
    \u3081\u305AValueError\u3002\n    ## \u540C\u3058\u7BC0\u70B9\u306ELCP\u306F\u5217\
    \u5168\u4F53\u3001\u63A5\u982D\u8F9E\u306A\u3089\u77ED\u3044\u65B9\u3001\u6839\
    \u3068\u306ELCP\u306F\u6839/\u9577\u30550\u3002char\u306F0..255\u306Ebyte\u3002\
    \n    ## \u500B\u5225\u7BC0\u70B9\u306EGC\u306F\u884C\u308F\u306A\u3044\u3002\
    arena\u307E\u305F\u306F\u7BC0\u70B9\u304C1\u3064\u3067\u3082\u751F\u5B58\u3057\
    \u3066\u3044\u308B\u9593\u306F\u5168\u5C65\u6B74\u3092\u4FDD\u6301\u3059\u308B\
    \u3002\n    ## arena\u5185\u90E8\u306B\u7BC0\u70B9\u30CF\u30F3\u30C9\u30EB\u306F\
    \u683C\u7D0D\u305B\u305A\u3001\u6240\u6709\u53C2\u7167\u306E\u5FAA\u74B0\u306F\
    \u4F5C\u3089\u306A\u3044\u3002\n    ## \u6700\u5F8C\u306E\u6240\u6709\u53C2\u7167\
    \u3092\u5931\u3063\u305Farena\u5168\u4F53\u306E\u89E3\u653E\u306FNim\u306E\u30E1\
    \u30E2\u30EA\u7BA1\u7406\u306B\u5F93\u3044\u3001\u4E0B\u8A18\u306E\u64CD\u4F5C\
    \u8A08\u7B97\u91CF\u3068\u306F\u5225\u3002\n    ##\n    ## N\u306F\u6839\u3092\
    \u542B\u3080\u4F5C\u6210\u6E08\u307F\u7BC0\u70B9\u6570\u3001\u03C3\u306FArray\u7248\
    \u306E\u6587\u5B57\u7A2E\u6570\u3002\n    ## Array\u7248: \u65B0\u898Fadd\u306F\
    \u511F\u5374O(\u03C3)\u3001\u65E2\u5B58\u8FBA\u306F\u6700\u60AAO(1)\u3001\u7A7A\
    \u9593O(N\u03C3)\u3002\u03C3\u56FA\u5B9A\u306A\u3089\u511F\u5374O(1)\u3001\u7A7A\
    \u9593O(N)\u3002\n    ## Table\u7248: add\u306F\u671F\u5F85\u511F\u5374O(1)\u3001\
    \u7A7A\u9593O(N)\u3002T\u306E\u30B3\u30D4\u30FC/hash/==/<\u304C\u5B9A\u6570\u6642\
    \u9593\u304B\u3064\u6574\u5408\u7684\u3067\u4E0D\u5909\u3068\u3059\u308B\u3002\
    \n    ## \u300C\u671F\u5F85\u300D\u306F\u826F\u597D\u306Ahash\u5206\u5E03\u306E\
    \u4EEE\u5B9A\u3067\u3042\u308A\u3001\u60AA\u610F\u3042\u308B\u885D\u7A81\u3067\
    \u306F\u8FFD\u52A0\u304C\u7DDA\u5F62\u6642\u9593\u306B\u306A\u308A\u5F97\u308B\
    \u3002\n    ## \u30B8\u30E3\u30F3\u30D7\u4F5C\u6210\u305D\u306E\u3082\u306E\u306F\
    \u6700\u60AAO(1)\u3060\u304C\u3001seq/Table\u306E\u518D\u78BA\u4FDD\u3092\u542B\
    \u3080\u8FFD\u52A0\u306F\u6700\u60AAO(1)\u3067\u306F\u306A\u3044\u3002\n    ##\
    \ pop\u306F\u6700\u60AAO(1)\u3001compare/lcp/lcpNode/prefix/[]\u306F\u6700\u60AA\
    O(log(N+1))\u3001\u8FFD\u52A0\u7A7A\u9593O(1)\u3002\n    ## \u5909\u63DB\u306F\
    \u9577\u3055L\u306B\u5BFE\u3057\u3066\u6642\u9593\u30FB\u51FA\u529B\u7A7A\u9593\
    O(L+1)\u3002\u30CF\u30F3\u30C9\u30EB\u306E\u30B3\u30D4\u30FC\u306FO(1)\u3001\u547C\
    \u3073\u51FA\u3057\u5074\u306EH\u500B\u306E\u30CF\u30F3\u30C9\u30EB\u306F\u5225\
    \u9014O(H)\u3002\n    ## \u6BD4\u8F03\u306B\u306Fhash\u3092\u4F7F\u7528\u3057\u306A\
    \u3044\u3002\u8F9E\u66F8\u306Ehash\u885D\u7A81\u3067\u3082==\u3067\u8FBA\u3092\
    \u533A\u5225\u3059\u308B\u305F\u3081\u7B54\u3048\u306F\u53B3\u5BC6\u3002\n   \
    \ ##\n    ## \u5404\u7BC0\u70B9\u306Ejump\u306F1\u672C\u3060\u3051\u3067\u3001\
    \u7D4C\u8DEF\u3092\u9577\u30552^k-1\u306Eskew binary\u30D6\u30ED\u30C3\u30AF\u3078\
    \u5206\u5272\u3059\u308B\u3002\n    ## jump\u5217\u306E\u9577\u3055\u306F\u975E\
    \u6E1B\u5C11\u3001\u7B49\u9577\u304C\u8A31\u3055\u308C\u308B\u306E\u306F\u5148\
    \u982D\u306E2\u500B\u3060\u3051\u3002\n    ## \u8FFD\u52A0\u6642\u306F\u5148\u982D\
    2\u500B\u304C\u540C\u9577\u306A\u3089\u65B0\u7BC0\u70B9\u3068\u5408\u4F53\u3057\
    \u3001\u305D\u308C\u4EE5\u5916\u306F\u9577\u30551\u3092\u5148\u982D\u306B\u7F6E\
    \u304F\u306E\u3067\u66F4\u65B0\u306F\u5B9A\u6570\u6642\u9593\u3002\n    ## \u7956\
    \u5148\u63A2\u7D22\u306F\u30D6\u30ED\u30C3\u30AF\u3092\u98DB\u3070\u3059\u304B\
    \u3001\u89AA\u30781\u6B69\u9032\u307F\u30D6\u30ED\u30C3\u30AF\u30922\u3064\u306E\
    \u5C0F\u3055\u3044rank\u3078\u5206\u5272\u3059\u308B\u3002\n    ## \u6700\u521D\
    \u306E\u30D6\u30ED\u30C3\u30AF\u5217\u3068\u5206\u5272\u968E\u5C64\u306F\u3044\
    \u305A\u308C\u3082\u5BFE\u6570\u500B\u3001\u5404rank\u3067\u98DB\u3070\u3059\u5144\
    \u5F1F\u306F\u9AD8\u30051\u500B\u306A\u306E\u3067\u6700\u60AAO(log N)\u3002\n\
    \    ## \u540C\u3058\u6DF1\u3055\u306A\u3089jump\u9577\u3082\u540C\u3058\u3002\
    2\u7BC0\u70B9\u306Ejump\u5148\u304C\u7570\u306A\u308B\u6642\u3060\u3051\u540C\u6642\
    \u306Bjump\u3057\u3001\u540C\u3058\u306A\u3089\u89AA\u3078\u9032\u3080\u3068\u3001\
    \n    ## LCA\u306E1\u3064\u4E0B\u306E\u6DF1\u3055\u3092\u76EE\u6A19\u3068\u3059\
    \u308B\u7956\u5148\u63A2\u7D22\u306B\u306A\u308B\u3002\u6B63\u898F\u5316\u3057\
    \u305FTrie\u3067\u306FLCA\u304CLCP\u3092\u8868\u3059\u3002\n    ## \u4E8C\u5206\
    \u7D2F\u4E57\u8868\u30FBrolling hash\u30FB\u500B\u5225\u7BC0\u70B9GC\u306F\u4F7F\
    \u7528\u3057\u306A\u3044\u3002\n    ##\n    ## \u4F7F\u7528\u4F8B:\n    ##   let\
    \ t = initTrieStringArray('a'..'z')\n    ##   let a = t.root.add('a')\n    ##\
    \   let ab = a.add('b')\n    ##   echo $ab                 # ab\n    ##   echo\
    \ ab[1]               # b\n    ##   echo a.lcp(ab)           # 1\n    ##   echo\
    \ ab.prefix(1) == a   # true\n    const CPLIB_STR_TRIE_STRING* = 1\n    import\
    \ tables\n\n    type\n        TrieStringEntry[T] = object\n            parent,\
    \ jump, depth: int\n            character: T\n        TrieStringTable*[T] = ref\
    \ object\n            ## \u7BC0\u70B9\u3092\u6240\u6709\u3059\u308Barena\u3002\
    T\u306Ehash\u30FB==\u30FB<\u306F\u6574\u5408\u7684\u304B\u3064\u4E0D\u5909\u3068\
    \u3059\u308B\u3002\n            nodes: seq[TrieStringEntry[T]]\n            edges:\
    \ Table[tuple[parent: int, character: T], int]\n        TrieStringArray*[chars:\
    \ static[HSlice[char, char]]] = ref object\n            ## \u65E2\u5B58Trie\u3068\
    \u540C\u3058char\u7BC4\u56F2\u6307\u5B9A\u3002\u56FA\u5B9A\u30A2\u30EB\u30D5\u30A1\
    \u30D9\u30C3\u30C8\u306A\u3089\u7A7A\u9593 O(N)\u3002\n            nodes: seq[TrieStringEntry[char]]\n\
    \            children: seq[array[chars.a..chars.b, int]]\n        TrieStringTableNode*[T]\
    \ = object\n            ## owner\u3092\u5F37\u53C2\u7167\u3059\u308B\u7BC0\u70B9\
    \u3002\u30B3\u30D4\u30FC\u306F\u540C\u3058arena\u30FB\u7BC0\u70B9\u3092\u5171\u6709\
    \u3057\u3001id\u306F\u8AAD\u307F\u53D6\u308A\u5C02\u7528\u3002\n            owner:\
    \ TrieStringTable[T]\n            id: int\n        TrieStringArrayNode*[chars:\
    \ static[HSlice[char, char]]] = object\n            ## owner\u3092\u5F37\u53C2\
    \u7167\u3059\u308B\u7BC0\u70B9\u3002arena\u306E\u518D\u78BA\u4FDD\u3084\u5143\u306E\
    \u5909\u6570\u306E\u5BFF\u547D\u306B\u4F9D\u5B58\u3057\u306A\u3044\u3002\n   \
    \         owner: TrieStringArray[chars]\n            id: int\n        TrieString*\
    \ = TrieStringTable[char]\n\n    proc initTrieStringTable*(T: typedesc): TrieStringTable[T]\
    \ =\n        ## \u7A7A\u6587\u5B57\u5217\uFF08\u68390\uFF09\u3092\u542B\u3080\u69CB\
    \u9020\u3092\u4F5C\u308B\u3002\u6642\u9593\u30FB\u7A7A\u9593 O(1)\u3002\n    \
    \    new(result)\n        result.nodes.add(TrieStringEntry[T]())\n\n    proc initTrieStringArray*(chars:\
    \ static[HSlice[char, char]]): TrieStringArray[chars] =\n        ## \u6307\u5B9A\
    \u6587\u5B57\u7BC4\u56F2\u306E\u6839\u3092\u4F5C\u308B\u3002\u6642\u9593\u30FB\
    \u7A7A\u9593 O(\u03C3)\u3002\n        when chars.a > chars.b:\n            {.error:\
    \ \"empty TrieStringArray alphabet\".}\n        new(result)\n        result.nodes.add(TrieStringEntry[char]())\n\
    \        result.children.setLen(1)\n\n    proc initTrieString*(): TrieString =\n\
    \        ## byte\u5217\u7528Table\u7248\u306E\u6839\u3092\u4F5C\u308B\u3002\u6642\
    \u9593\u30FB\u7A7A\u9593 O(1)\u3002\n        return initTrieStringTable(char)\n\
    \n    proc checkNode[S: TrieStringArray | TrieStringTable](self: S, node: int)\
    \ {.inline.} =\n        ## \u672A\u521D\u671F\u5316\u30FB\u7BC4\u56F2\u5916\u30CF\
    \u30F3\u30C9\u30EB\u306FValueError\u3068\u3059\u308B\u3002O(1)\u3002\n       \
    \ if self == nil or node < 0 or node >= self.nodes.len:\n            raise newException(ValueError,\
    \ \"invalid TrieString node\")\n\n    proc root*[T](self: TrieStringTable[T]):\
    \ TrieStringTableNode[T] =\n        ## \u7A7A\u5217\u306E\u7BC0\u70B9\u3092\u8FD4\
    \u3059\u3002\u672A\u521D\u671F\u5316arena\u306FValueError\u3002O(1)\u3002\n  \
    \      self.checkNode(0)\n        return TrieStringTableNode[T](owner: self, id:\
    \ 0)\n\n    proc root*[chars](self: TrieStringArray[chars]): TrieStringArrayNode[chars]\
    \ =\n        ## \u7A7A\u5217\u306E\u7BC0\u70B9\u3092\u8FD4\u3059\u3002\u672A\u521D\
    \u671F\u5316arena\u306FValueError\u3002O(1)\u3002\n        self.checkNode(0)\n\
    \        return TrieStringArrayNode[chars](owner: self, id: 0)\n\n    proc nodeCount*[S:\
    \ TrieStringArray | TrieStringTable](self: S): int =\n        ## arena\u306E\u6839\
    \u3092\u542B\u3080\u4F5C\u6210\u6E08\u307F\u7BC0\u70B9\u6570\u3092\u8FD4\u3059\
    \u3002\u672A\u521D\u671F\u5316\u306A\u30890\u3002O(1)\u3002\n        if self !=\
    \ nil:\n            result = self.nodes.len\n\n    proc addNode[S: TrieStringArray\
    \ | TrieStringTable, T](self: S, node: int, c: T): int =\n        ## \u65B0\u7BC0\
    \u70B9\u306E\u30B8\u30E3\u30F3\u30D7\u3092\u5B9A\u6570\u6642\u9593\u3067\u6C42\
    \u3081\u308B\u3002seq\u78BA\u4FDD\u3092\u542B\u3081\u511F\u5374 O(1)\u3002\n \
    \       let j = self.nodes[node].jump\n        let jj = self.nodes[j].jump\n \
    \       var jump = node\n        if self.nodes[node].depth - self.nodes[j].depth\
    \ ==\n                self.nodes[j].depth - self.nodes[jj].depth:\n          \
    \  jump = jj\n        result = self.nodes.len\n        self.nodes.add(TrieStringEntry[T](parent:\
    \ node, jump: jump,\n            depth: self.nodes[node].depth + 1, character:\
    \ c))\n\n    proc addId[T](self: TrieStringTable[T], node: int, c: T): int =\n\
    \        ## \u672B\u5C3E\u306B1\u8981\u7D20\u8FFD\u52A0\u3057\u305F\u30CF\u30F3\
    \u30C9\u30EB\u3092\u8FD4\u3059\u3002\u540C\u3058\u8FBA\u306F\u5171\u6709\u3059\
    \u308B\u3002\u671F\u5F85\u511F\u5374 O(1)\u3002\n        self.checkNode(node)\n\
    \        let key = (parent: node, character: c)\n        result = self.edges.getOrDefault(key,\
    \ -1)\n        if result >= 0:\n            return\n        result = self.addNode(node,\
    \ c)\n        self.edges[key] = result\n\n    proc addId[chars](self: TrieStringArray[chars],\
    \ node: int, c: char): int =\n        ## \u672B\u5C3E\u306B1byte\u8FFD\u52A0\u3059\
    \u308B\u3002\u65E2\u5B58\u8FBA O(1)\u3001\u65B0\u898F\u8FBA\u306F\u511F\u5374\
    \ O(\u03C3)\u3002\n        self.checkNode(node)\n        if c < chars.a or c >\
    \ chars.b:\n            raise newException(ValueError, \"character outside TrieStringArray\
    \ alphabet\")\n        result = self.children[node][c]\n        if result != 0:\n\
    \            return\n        result = self.addNode(node, c)\n        self.children.setLen(self.nodes.len)\n\
    \        self.children[node][c] = result\n\n    proc parentId[S: TrieStringArray\
    \ | TrieStringTable](self: S, node: int): int =\n        ## \u672B\u5C3E1\u8981\
    \u7D20\u3092\u9664\u3044\u305F\u89AA\u3092\u8FD4\u3059\u3002\u6839\u3067\u306F\
    \u6839\u3092\u8FD4\u3059\u3002\u7BC0\u70B9\u306F\u6D88\u3055\u306A\u3044\u3002\
    \u6700\u60AA O(1)\u3002\n        self.checkNode(node)\n        return self.nodes[node].parent\n\
    \n    proc ancestorAtDepth[S: TrieStringArray | TrieStringTable](self: S, node,\
    \ depth: int): int =\n        ## \u6307\u5B9A\u6DF1\u3055\u306E\u7956\u5148\u3092\
    \u8FD4\u3059\uFF08\u5185\u90E8\u7528\u3001\u6709\u52B9\u306A\u6DF1\u3055\u306E\
    \u307F\uFF09\u3002\u6700\u60AA O(log N)\u3002\n        result = node\n       \
    \ while self.nodes[result].depth > depth:\n            let j = self.nodes[result].jump\n\
    \            if self.nodes[j].depth >= depth:\n                result = j\n  \
    \          else:\n                result = self.nodes[result].parent\n\n    proc\
    \ lcaId[S: TrieStringArray | TrieStringTable](self: S, a, b: int): int =\n   \
    \     ## \u6700\u9577\u5171\u901A\u63A5\u982D\u8F9E\u306E\u7BC0\u70B9ID\u3092\u53B3\
    \u5BC6\u306B\u8FD4\u3059\u3002\u6700\u60AA O(log N)\u3001\u8FFD\u52A0\u7A7A\u9593\
    \ O(1)\u3002\n        self.checkNode(a)\n        self.checkNode(b)\n        var\
    \ u = a\n        var v = b\n        let da = self.nodes[u].depth\n        let\
    \ db = self.nodes[v].depth\n        if da > db:\n            u = self.ancestorAtDepth(u,\
    \ db)\n        elif db > da:\n            v = self.ancestorAtDepth(v, da)\n  \
    \      if u == v:\n            return u\n        while self.nodes[u].parent !=\
    \ self.nodes[v].parent:\n            let ju = self.nodes[u].jump\n           \
    \ let jv = self.nodes[v].jump\n            if ju != jv:\n                u = ju\n\
    \                v = jv\n            else:\n                u = self.nodes[u].parent\n\
    \                v = self.nodes[v].parent\n        return self.nodes[u].parent\n\
    \n    proc prefixId[S: TrieStringArray | TrieStringTable](self: S, node, length:\
    \ int): int =\n        ## \u5148\u982Dlength\u8981\u7D20\u306E\u7BC0\u70B9ID\u3092\
    \u8FD4\u3059\u3002\u7BC4\u56F2\u5916\u306FValueError\u3002\u6700\u60AA O(log N)\u3002\
    \n        self.checkNode(node)\n        if length < 0 or length > self.nodes[node].depth:\n\
    \            raise newException(ValueError, \"invalid TrieString prefix length\"\
    )\n        return self.ancestorAtDepth(node, length)\n\n    proc nodeAtIndex[S:\
    \ TrieStringArray | TrieStringTable](self: S, node, index: int): int =\n     \
    \   ## 0\u59CB\u307E\u308Aindex\u306E\u8981\u7D20\u3092\u672B\u5C3E\u306B\u6301\
    \u3064\u7956\u5148\u3092\u8FD4\u3059\u3002\u6700\u60AA O(log N)\u3002\n      \
    \  self.checkNode(node)\n        if index < 0 or index >= self.nodes[node].depth:\n\
    \            raise newException(ValueError, \"invalid TrieString index\")\n  \
    \      return self.ancestorAtDepth(node, index + 1)\n\n    proc valueAt[T](self:\
    \ TrieStringTable[T], node, index: int): T =\n        ## 0\u59CB\u307E\u308Aindex\u306E\
    \u8981\u7D20\u3092\u8FD4\u3059\u3002\u7BC4\u56F2\u5916\u306FValueError\u3002\u6700\
    \u60AA O(log N)\u3002\n        return self.nodes[self.nodeAtIndex(node, index)].character\n\
    \n    proc valueAt[chars](self: TrieStringArray[chars], node, index: int): char\
    \ =\n        ## 0\u59CB\u307E\u308Aindex\u306Ebyte\u3092\u8FD4\u3059\u3002\u7BC4\
    \u56F2\u5916\u306FValueError\u3002\u6700\u60AA O(log N)\u3002\n        return\
    \ self.nodes[self.nodeAtIndex(node, index)].character\n\n    proc restoreSeq[T](nodes:\
    \ seq[TrieStringEntry[T]], node: int): seq[T] =\n        ## \u6709\u52B9\u306A\
    \u7BC0\u70B9\u304B\u3089\u5217\u3092\u5FA9\u5143\u3059\u308B\u3002\u6642\u9593\
    \u30FB\u51FA\u529B\u7A7A\u9593 O(\u9577\u3055+1)\u3002\n        result = newSeq[T](nodes[node].depth)\n\
    \        var v = node\n        var i = result.len\n        while i > 0:\n    \
    \        dec i\n            result[i] = nodes[v].character\n            v = nodes[v].parent\n\
    \n    proc restore[T](self: TrieStringTable[T], node: int): seq[T] =\n       \
    \ ## \u8981\u7D20\u5217\u3092\u5FA9\u5143\u3059\u308B\u3002\u6642\u9593\u30FB\u51FA\
    \u529B\u7A7A\u9593 O(\u9577\u3055+1)\u3002\n        self.checkNode(node)\n   \
    \     return restoreSeq(self.nodes, node)\n\n    proc restore[chars](self: TrieStringArray[chars],\
    \ node: int): seq[char] =\n        ## byte\u5217\u3092\u5FA9\u5143\u3059\u308B\
    \u3002\u6642\u9593\u30FB\u51FA\u529B\u7A7A\u9593 O(\u9577\u3055+1)\u3002\n   \
    \     self.checkNode(node)\n        return restoreSeq(self.nodes, node)\n\n  \
    \  proc restoreString[S: TrieStringArray | TrieStringTable[char]](self: S, node:\
    \ int): string =\n        ## byte\u5217\u3092string\u3078\u5FA9\u5143\u3059\u308B\
    \u3002\u6642\u9593\u30FB\u51FA\u529B\u7A7A\u9593 O(\u9577\u3055+1)\u3002\n   \
    \     self.checkNode(node)\n        result = newString(self.nodes[node].depth)\n\
    \        var v = node\n        var i = result.len\n        while i > 0:\n    \
    \        dec i\n            result[i] = self.nodes[v].character\n            v\
    \ = self.nodes[v].parent\n\n    proc compareIds[S: TrieStringArray | TrieStringTable](self:\
    \ S, a, b: int): int =\n        ## \u8981\u7D20\u306E\u8F9E\u66F8\u9806\u3067\
    -1/0/1\u3092\u53B3\u5BC6\u306B\u8FD4\u3059\u3002\u6700\u60AA O(log N)\u3001\u8FFD\
    \u52A0\u7A7A\u9593 O(1)\u3002\n        self.checkNode(a)\n        self.checkNode(b)\n\
    \        if a == b:\n            return 0\n        let da = self.nodes[a].depth\n\
    \        let db = self.nodes[b].depth\n        var u = a\n        var v = b\n\
    \        if da > db:\n            u = self.ancestorAtDepth(u, db)\n        elif\
    \ db > da:\n            v = self.ancestorAtDepth(v, da)\n        if u == v:\n\
    \            return (if da < db: -1 else: 1)\n        while self.nodes[u].parent\
    \ != self.nodes[v].parent:\n            let ju = self.nodes[u].jump\n        \
    \    let jv = self.nodes[v].jump\n            if ju != jv:\n                u\
    \ = ju\n                v = jv\n            else:\n                u = self.nodes[u].parent\n\
    \                v = self.nodes[v].parent\n        return (if self.nodes[u].character\
    \ < self.nodes[v].character: -1 else: 1)\n\n    proc checkHandle[S: TrieStringArrayNode\
    \ | TrieStringTableNode](self: S) {.inline.} =\n        ## default\u7BC0\u70B9\
    \u3068\u4E0D\u6B63\u306A\u5185\u90E8\u6DFB\u5B57\u3092\u62D2\u5426\u3059\u308B\
    \u3002O(1)\u3002\n        self.owner.checkNode(self.id)\n\n    proc checkCompatible[S:\
    \ TrieStringArrayNode | TrieStringTableNode](a, b: S) {.inline.} =\n        ##\
    \ \u4E21\u7BC0\u70B9\u306E\u6709\u52B9\u6027\u3068owner\u306E\u4E00\u81F4\u3092\
    \u691C\u67FB\u3059\u308B\u3002O(1)\u3002\n        a.checkHandle()\n        b.checkHandle()\n\
    \        if a.owner != b.owner:\n            raise newException(ValueError, \"\
    incompatible TrieString owners\")\n\n    proc id*[S: TrieStringArrayNode | TrieStringTableNode](self:\
    \ S): int {.inline.} =\n        ## arena\u5185\u306E\u7BC0\u70B9ID\u3092\u8FD4\
    \u3059\u3002\u6839\u306F0\u3001\u4E0D\u6B63\u306A\u7BC0\u70B9\u306FValueError\u3002\
    O(1)\u3002\n        self.checkHandle()\n        return self.id\n\n    proc `==`*[T](a,\
    \ b: TrieStringTableNode[T]): bool =\n        ## \u540C\u3058arena\u306E\u6B63\
    \u898F\u5316\u3055\u308C\u305F\u7BC0\u70B9\u304B\u3092\u8FD4\u3059\u3002\u4E0D\
    \u6B63\u30FB\u7570\u306A\u308Bowner\u306FValueError\u3002O(1)\u3002\n        checkCompatible(a,\
    \ b)\n        return a.id == b.id\n\n    proc `==`*[chars](a, b: TrieStringArrayNode[chars]):\
    \ bool =\n        ## \u540C\u3058arena\u306E\u6B63\u898F\u5316\u3055\u308C\u305F\
    \u7BC0\u70B9\u304B\u3092\u8FD4\u3059\u3002\u4E0D\u6B63\u30FB\u7570\u306A\u308B\
    owner\u306FValueError\u3002O(1)\u3002\n        checkCompatible(a, b)\n       \
    \ return a.id == b.id\n\n    proc length*[S: TrieStringArrayNode | TrieStringTableNode](self:\
    \ S): int =\n        ## \u7BC0\u70B9\u304C\u8868\u3059\u5217\u306E\u8981\u7D20\
    \u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n        self.checkHandle()\n       \
    \ return self.owner.nodes[self.id].depth\n\n    proc len*[S: TrieStringArrayNode\
    \ | TrieStringTableNode](self: S): int {.inline.} =\n        ## \u7BC0\u70B9\u304C\
    \u8868\u3059\u5217\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3059\u3002\u4E0D\u6B63\
    \u306A\u7BC0\u70B9\u306FValueError\u3002O(1)\u3002\n        return self.length\n\
    \n    proc add*[T](self: TrieStringTableNode[T], c: T): TrieStringTableNode[T]\
    \ =\n        ## \u672B\u5C3E\u306B1\u8981\u7D20\u8FFD\u52A0\u3057\u305F\u7BC0\u70B9\
    \u3092\u8FD4\u3059\u3002\u671F\u5F85\u511F\u5374O(1)\u3002\u5143\u306E\u7BC0\u70B9\
    \u306F\u5909\u308F\u3089\u306A\u3044\u3002\n        self.checkHandle()\n     \
    \   result = self\n        result.id = self.owner.addId(self.id, c)\n\n    proc\
    \ add*[chars](self: TrieStringArrayNode[chars], c: char): TrieStringArrayNode[chars]\
    \ =\n        ## \u672B\u5C3E\u306B1byte\u8FFD\u52A0\u3057\u305F\u7BC0\u70B9\u3092\
    \u8FD4\u3059\u3002\u65E2\u5B58\u8FBAO(1)\u3001\u65B0\u898F\u8FBA\u306F\u511F\u5374\
    O(\u03C3)\u3002\n        self.checkHandle()\n        result = self\n        result.id\
    \ = self.owner.addId(self.id, c)\n\n    proc pop*[S: TrieStringArrayNode | TrieStringTableNode](self:\
    \ S): S =\n        ## \u89AA\u7BC0\u70B9\u3092\u8FD4\u3059\u3002\u6839\u3067\u306F\
    \u6839\u3001\u5143\u306E\u7BC0\u70B9\u3068\u5C65\u6B74\u306F\u5909\u308F\u3089\
    \u306A\u3044\u3002\u6700\u60AAO(1)\u3002\n        self.checkHandle()\n       \
    \ result = self\n        result.id = self.owner.parentId(self.id)\n\n    proc\
    \ cmp*[chars](a, b: TrieStringArrayNode[chars]): int =\n        ## \u540C\u3058\
    arena\u306E\u5217\u3092\u53B3\u5BC6\u306A\u8F9E\u66F8\u9806\u3067-1/0/1\u306B\u6BD4\
    \u8F03\u3059\u308B\u3002\u6700\u60AAO(log N)\u3002\n        checkCompatible(a,\
    \ b)\n        return a.owner.compareIds(a.id, b.id)\n\n    proc cmp*[T](a, b:\
    \ TrieStringTableNode[T]): int =\n        ## \u540C\u3058arena\u306E\u5217\u3092\
    \u53B3\u5BC6\u306A\u8F9E\u66F8\u9806\u3067-1/0/1\u306B\u6BD4\u8F03\u3059\u308B\
    \u3002\u6700\u60AAO(log N)\u3002\n        checkCompatible(a, b)\n        return\
    \ a.owner.compareIds(a.id, b.id)\n\n    proc `<`*[chars](a, b: TrieStringArrayNode[chars]):\
    \ bool {.inline.} =\n        ## \u540C\u3058arena\u306E\u5217\u304C\u8F9E\u66F8\
    \u9806\u3067\u5C0F\u3055\u3044\u304B\u3092\u8FD4\u3059\u3002\u6700\u60AAO(log\
    \ N)\u3002\n        return cmp(a, b) < 0\n\n    proc `<`*[T](a, b: TrieStringTableNode[T]):\
    \ bool {.inline.} =\n        ## \u540C\u3058arena\u306E\u5217\u304C\u8F9E\u66F8\
    \u9806\u3067\u5C0F\u3055\u3044\u304B\u3092\u8FD4\u3059\u3002\u6700\u60AAO(log\
    \ N)\u3002\n        return cmp(a, b) < 0\n\n    proc `<=`*[chars](a, b: TrieStringArrayNode[chars]):\
    \ bool {.inline.} =\n        ## \u540C\u3058arena\u306E\u5217\u304C\u8F9E\u66F8\
    \u9806\u3067\u4EE5\u4E0B\u304B\u3092\u8FD4\u3059\u3002\u6700\u60AAO(log N)\u3002\
    \n        return cmp(a, b) <= 0\n\n    proc `<=`*[T](a, b: TrieStringTableNode[T]):\
    \ bool {.inline.} =\n        ## \u540C\u3058arena\u306E\u5217\u304C\u8F9E\u66F8\
    \u9806\u3067\u4EE5\u4E0B\u304B\u3092\u8FD4\u3059\u3002\u6700\u60AAO(log N)\u3002\
    \n        return cmp(a, b) <= 0\n\n    proc `>`*[chars](a, b: TrieStringArrayNode[chars]):\
    \ bool {.inline.} =\n        ## \u540C\u3058arena\u306E\u5217\u304C\u8F9E\u66F8\
    \u9806\u3067\u5927\u304D\u3044\u304B\u3092\u8FD4\u3059\u3002\u6700\u60AAO(log\
    \ N)\u3002\n        return cmp(a, b) > 0\n\n    proc `>`*[T](a, b: TrieStringTableNode[T]):\
    \ bool {.inline.} =\n        ## \u540C\u3058arena\u306E\u5217\u304C\u8F9E\u66F8\
    \u9806\u3067\u5927\u304D\u3044\u304B\u3092\u8FD4\u3059\u3002\u6700\u60AAO(log\
    \ N)\u3002\n        return cmp(a, b) > 0\n\n    proc `>=`*[chars](a, b: TrieStringArrayNode[chars]):\
    \ bool {.inline.} =\n        ## \u540C\u3058arena\u306E\u5217\u304C\u8F9E\u66F8\
    \u9806\u3067\u4EE5\u4E0A\u304B\u3092\u8FD4\u3059\u3002\u6700\u60AAO(log N)\u3002\
    \n        return cmp(a, b) >= 0\n\n    proc `>=`*[T](a, b: TrieStringTableNode[T]):\
    \ bool {.inline.} =\n        ## \u540C\u3058arena\u306E\u5217\u304C\u8F9E\u66F8\
    \u9806\u3067\u4EE5\u4E0A\u304B\u3092\u8FD4\u3059\u3002\u6700\u60AAO(log N)\u3002\
    \n        return cmp(a, b) >= 0\n\n    proc lcpNode*[S: TrieStringArrayNode |\
    \ TrieStringTableNode](a, b: S): S =\n        ## \u540C\u3058arena\u306E\u6700\
    \u9577\u5171\u901A\u63A5\u982D\u8F9E\u306E\u7BC0\u70B9\u3092\u8FD4\u3059\u3002\
    \u6700\u60AAO(log N)\u3002\n        checkCompatible(a, b)\n        result = a\n\
    \        result.id = a.owner.lcaId(a.id, b.id)\n\n    proc lcp*[S: TrieStringArrayNode\
    \ | TrieStringTableNode](a, b: S): int =\n        ## \u540C\u3058arena\u306E\u6700\
    \u9577\u5171\u901A\u63A5\u982D\u8F9E\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3059\
    \u3002\u6700\u60AAO(log N)\u3002\n        return a.lcpNode(b).length\n\n    proc\
    \ prefix*[S: TrieStringArrayNode | TrieStringTableNode](self: S, length: int):\
    \ S =\n        ## \u5148\u982Dlength\u8981\u7D20\u306E\u7BC0\u70B9\u3092\u8FD4\
    \u3059\u3002\u7BC4\u56F2\u5916\u306FValueError\u3002\u6700\u60AAO(log N)\u3002\
    \n        self.checkHandle()\n        result = self\n        result.id = self.owner.prefixId(self.id,\
    \ length)\n\n    proc `[]`*[T](self: TrieStringTableNode[T], index: int): T =\n\
    \        ## 0\u59CB\u307E\u308Aindex\u306E\u8981\u7D20\u3092\u8FD4\u3059\u3002\
    \u7BC4\u56F2\u5916\u306FValueError\u3002\u6700\u60AAO(log N)\u3002\n        self.checkHandle()\n\
    \        return self.owner.valueAt(self.id, index)\n\n    proc `[]`*[chars](self:\
    \ TrieStringArrayNode[chars], index: int): char =\n        ## 0\u59CB\u307E\u308A\
    index\u306Ebyte\u3092\u8FD4\u3059\u3002\u7BC4\u56F2\u5916\u306FValueError\u3002\
    \u6700\u60AAO(log N)\u3002\n        self.checkHandle()\n        return self.owner.valueAt(self.id,\
    \ index)\n\n    proc toSeq*[T](self: TrieStringTableNode[T]): seq[T] =\n     \
    \   ## \u8981\u7D20\u5217\u3092\u5FA9\u5143\u3059\u308B\u3002\u6642\u9593\u30FB\
    \u51FA\u529B\u7A7A\u9593O(\u9577\u3055+1)\u3002\n        self.checkHandle()\n\
    \        return self.owner.restore(self.id)\n\n    proc toSeq*[chars](self: TrieStringArrayNode[chars]):\
    \ seq[char] =\n        ## byte\u5217\u3092\u5FA9\u5143\u3059\u308B\u3002\u6642\
    \u9593\u30FB\u51FA\u529B\u7A7A\u9593O(\u9577\u3055+1)\u3002\n        self.checkHandle()\n\
    \        return self.owner.restore(self.id)\n\n    proc `$`*[chars](self: TrieStringArrayNode[chars]):\
    \ string =\n        ## byte\u5217\u3092string\u3078\u5FA9\u5143\u3059\u308B\u3002\
    \u6642\u9593\u30FB\u51FA\u529B\u7A7A\u9593O(\u9577\u3055+1)\u3002\n        self.checkHandle()\n\
    \        return self.owner.restoreString(self.id)\n\n    proc `$`*(self: TrieStringTableNode[char]):\
    \ string =\n        ## byte\u5217\u3092string\u3078\u5FA9\u5143\u3059\u308B\u3002\
    \u6642\u9593\u30FB\u51FA\u529B\u7A7A\u9593O(\u9577\u3055+1)\u3002\n        self.checkHandle()\n\
    \        return self.owner.restoreString(self.id)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/trie_string.nim
  requiredBy: []
  timestamp: '2026-10-26 02:50:53+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/trie_string_import_test.nim
  - verify/str/trie_string_import_test.nim
documentation_of: cplib/str/trie_string.nim
layout: document
redirect_from:
- /library/cplib/str/trie_string.nim
- /library/cplib/str/trie_string.nim.html
title: cplib/str/trie_string.nim
---
