---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/palindromic_tree_test.nim
    title: verify/AI/palindromic_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/palindromic_tree_test.nim
    title: verify/AI/palindromic_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/palindromic_tree_append_test.nim
    title: verify/str/palindromic_tree_append_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/palindromic_tree_append_test.nim
    title: verify/str/palindromic_tree_append_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/palindromic_tree_eertree_test.nim
    title: verify/str/palindromic_tree_eertree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/palindromic_tree_eertree_test.nim
    title: verify/str/palindromic_tree_eertree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/palindromic_tree_series_link_test.nim
    title: verify/str/palindromic_tree_series_link_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/palindromic_tree_series_link_test.nim
    title: verify/str/palindromic_tree_series_link_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/palindromic_tree_test.nim
    title: verify/str/palindromic_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/palindromic_tree_test.nim
    title: verify/str/palindromic_tree_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_PALINDROMIC_TREE:\n    ## \u9759\u7684\u306A\u8981\
    \u7D20\u7BC4\u56F2\u3092array\u3067\u7BA1\u7406\u3059\u308B\u56DE\u6587\u6728\u3002\
    \u6587\u5B57\u7A2E\u6570\u03C3\u3001\u5206\u5C90\u30CE\u30FC\u30C9\u6570B\u3068\
    \u3057\u3066\u7A7A\u9593O(N+\u03C3B)\u3002\n    ## \u4F7F\u7528\u4F8B: var pt\
    \ = initPalindromicTree('a'..'z'); pt.add('a')\n    ## \u30CE\u30FC\u30C9\u306F\
    \u5185\u90E8\u914D\u5217\u3068ID\u3092\u4FDD\u6301\u3059\u308B\u30CF\u30F3\u30C9\
    \u30EB\u3002\u30EA\u30F3\u30AF\u3068\u30CE\u30FC\u30C9\u60C5\u5831\u306F\u8AAD\
    \u307F\u53D6\u308A\u5C02\u7528\u3002\n    const CPLIB_STR_PALINDROMIC_TREE* =\
    \ 1\n    when NimMajor >= 2:\n        type PalindromicTreeAlphabet = HSlice\n\
    \    else:\n        # Nim 1.6\u3067\u306F\u578B\u5F15\u6570\u306B\u4F9D\u5B58\u3059\
    \u308Bstatic HSlice\u3092\u89E3\u6C7A\u3067\u304D\u306A\u3044\u305F\u3081\u3001\
    \u5185\u90E8\u3060\u3051\u6574\u6570\u7BC4\u56F2\u306B\u3059\u308B\u3002\n   \
    \     type PalindromicTreeAlphabet = HSlice[int, int]\n    type\n        PalindromicTreeNodeData[T;\
    \ alphabet: static[PalindromicTreeAlphabet]] = object\n            length, parent,\
    \ suffix, series: int32\n            # 0\u306F\u5B50\u306A\u3057\u3001\u6B63\u306F\
    \u552F\u4E00\u306E\u5B50\u306EID\u3001\u8CA0\u306F\u9077\u79FB\u914D\u5217\u306E\
    \u6DFB\u5B57\u3092-(\u6DFB\u5B57+1)\u3067\u4FDD\u6301\u3059\u308B\u3002\n    \
    \        children: int32\n            terminal_count, total_count: int32\n   \
    \         character: T\n        PalindromicTreeStorage[T; alphabet: static[PalindromicTreeAlphabet]]\
    \ = ref object\n            data: seq[T]\n            nodes: seq[PalindromicTreeNodeData[T,\
    \ alphabet]]\n            branches: seq[array[alphabet.a..alphabet.b, int32]]\n\
    \            updated: bool\n        PalindromicTreeNode*[T; alphabet: static[PalindromicTreeAlphabet]]\
    \ = object\n            storage: PalindromicTreeStorage[T, alphabet]\n       \
    \     index: int32\n        PalindromicTreeLinks*[T; alphabet: static[PalindromicTreeAlphabet]]\
    \ = object\n            storage: PalindromicTreeStorage[T, alphabet]\n       \
    \     parent: int32\n        PalindromicTree*[T; alphabet: static[PalindromicTreeAlphabet]]\
    \ = object\n            storage: PalindromicTreeStorage[T, alphabet]\n       \
    \     nodes*: seq[PalindromicTreeNode[T, alphabet]]\n            last_node*: PalindromicTreeNode[T,\
    \ alphabet]\n            prefix_nodes*: seq[PalindromicTreeNode[T, alphabet]]\n\
    \n    proc nodeAt[T, alphabet](storage: PalindromicTreeStorage[T, alphabet], index:\
    \ int32): PalindromicTreeNode[T, alphabet] {.inline.} =\n        ## ID\u304B\u3089\
    \u30CF\u30F3\u30C9\u30EB\u3092O(1)\u3067\u4F5C\u308B\u3002\u8CA0\u306EID\u306A\
    \u3089\u7A7A\u306E\u30CF\u30F3\u30C9\u30EB\u3002\n        if index >= 0: result\
    \ = PalindromicTreeNode[T, alphabet](storage: storage, index: index)\n\n    proc\
    \ isNil*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): bool {.inline.}\
    \ =\n        ## \u7A7A\u306E\u30CF\u30F3\u30C9\u30EB\u304B\u3092O(1)\u3067\u8FD4\
    \u3059\u3002\n        node.storage == nil\n\n    proc `==`*[T, alphabet](a, b:\
    \ PalindromicTreeNode[T, alphabet]): bool {.inline.} =\n        ## \u540C\u3058\
    \u6728\u306E\u540C\u3058\u30CE\u30FC\u30C9\u304B\u3092O(1)\u3067\u8FD4\u3059\u3002\
    \n        a.storage == b.storage and (a.storage == nil or a.index == b.index)\n\
    \n    proc `==`*[T, alphabet](node: PalindromicTreeNode[T, alphabet], value: typeof(nil)):\
    \ bool {.inline.} =\n        ## \u7A7A\u306E\u30CF\u30F3\u30C9\u30EB\u3068nil\u306E\
    \u6BD4\u8F03\u3092O(1)\u3067\u884C\u3046\u3002\n        node.isNil\n\n    proc\
    \ `==`*[T, alphabet](value: typeof(nil), node: PalindromicTreeNode[T, alphabet]):\
    \ bool {.inline.} =\n        ## nil\u3068\u7A7A\u306E\u30CF\u30F3\u30C9\u30EB\u306E\
    \u6BD4\u8F03\u3092O(1)\u3067\u884C\u3046\u3002\n        node.isNil\n\n    proc\
    \ len*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): int {.inline.} =\n\
    \        ## \u56DE\u6587\u306E\u9577\u3055\u3092O(1)\u3067\u8FD4\u3059\u3002\n\
    \        node.storage.nodes[node.index].length.int\n\n    proc id*[T, alphabet](node:\
    \ PalindromicTreeNode[T, alphabet]): int {.inline.} =\n        ## ID\u3092O(1)\u3067\
    \u8FD4\u3059\u3002\u9577\u3055-1\u30680\u306E\u6839\u306EID\u306F\u305D\u308C\u305E\
    \u308C0\u30681\u3002\n        node.index.int\n\n    proc character*[T, alphabet](node:\
    \ PalindromicTreeNode[T, alphabet]): T {.inline.} =\n        ## \u89AA\u306E\u4E21\
    \u7AEF\u306B\u8FFD\u52A0\u3057\u305F\u8981\u7D20\u3092\u8FD4\u3059\u3002\u6839\
    \u3067\u306F\u4F7F\u7528\u3057\u306A\u3044\u3002\n        node.storage.nodes[node.index].character\n\
    \n    proc parent*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): PalindromicTreeNode[T,\
    \ alphabet] {.inline.} =\n        ## \u4E21\u7AEF\u306E\u8981\u7D20\u3092\u9664\
    \u3044\u305F\u89AA\u3092O(1)\u3067\u8FD4\u3059\u3002\u6839\u3067\u306F\u7A7A\u306E\
    \u30CF\u30F3\u30C9\u30EB\u3002\n        node.storage.nodeAt(node.storage.nodes[node.index].parent)\n\
    \n    proc suffix_link*[T, alphabet](node: PalindromicTreeNode[T, alphabet]):\
    \ PalindromicTreeNode[T, alphabet] {.inline.} =\n        ## \u6700\u9577\u306E\
    \u771F\u306E\u56DE\u6587\u63A5\u5C3E\u8F9E\u3092O(1)\u3067\u8FD4\u3059\u3002\u9577\
    \u3055-1\u306E\u6839\u3067\u306F\u7A7A\u306E\u30CF\u30F3\u30C9\u30EB\u3002\n \
    \       node.storage.nodeAt(node.storage.nodes[node.index].suffix)\n\n    proc\
    \ series_link*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): PalindromicTreeNode[T,\
    \ alphabet] {.inline.} =\n        ## \u9577\u3055\u306E\u5DEE\u5206\u304C\u7570\
    \u306A\u308B\u6700\u9577\u306E\u63A5\u5C3E\u56DE\u6587\u3092O(1)\u3067\u8FD4\u3059\
    \u3002\u9577\u3055-1\u306E\u6839\u3067\u306F\u7A7A\u306E\u30CF\u30F3\u30C9\u30EB\
    \u3002\n        node.storage.nodeAt(node.storage.nodes[node.index].series)\n\n\
    \    proc diff*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): int {.inline.}\
    \ =\n        ## suffix_link\u5148\u3068\u306E\u9577\u3055\u306E\u5DEE\u3092O(1)\u3067\
    \u8FD4\u3059\u3002\u6839\u3067\u306F0\u3002\n        if node.index < 2: return\
    \ 0\n        let storage = node.storage\n        storage.nodes[node.index].length.int\
    \ - storage.nodes[storage.nodes[node.index].suffix].length.int\n\n    proc count*[T,\
    \ alphabet](node: PalindromicTreeNode[T, alphabet]): int {.inline.} =\n      \
    \  ## O(1)\u3002update_count\u5F8C\u306F\u7DCF\u51FA\u73FE\u56DE\u6570\u3001\u69CB\
    \u7BC9\u30FB\u8FFD\u52A0\u5F8C\u306F\u6700\u9577\u56DE\u6587\u63A5\u5C3E\u8F9E\
    \u3068\u3057\u3066\u306E\u51FA\u73FE\u56DE\u6570\u3002\n        if node.storage.updated:\
    \ node.storage.nodes[node.index].total_count.int\n        else: node.storage.nodes[node.index].terminal_count.int\n\
    \n    proc findChild[T, alphabet](storage: PalindromicTreeStorage[T, alphabet],\
    \ parent: int32, value: T): int32 {.inline.} =\n        ## \u6307\u5B9A\u3057\u305F\
    \u8981\u7D20\u3067\u62E1\u5F35\u3057\u305F\u5B50\u306EID\u3092O(1)\u3067\u8FD4\
    \u3059\u3002\u5B58\u5728\u3057\u306A\u3051\u308C\u30700\u3002\n        if ord(value)\
    \ < ord(alphabet.a) or ord(value) > ord(alphabet.b): return 0\n        let children\
    \ = storage.nodes[parent].children\n        if children > 0:\n            if storage.nodes[children].character\
    \ == value: return children\n        elif children < 0:\n            return storage.branches[-children\
    \ - 1][typeof(alphabet.a)(value)]\n\n    proc addChild[T, alphabet](storage: PalindromicTreeStorage[T,\
    \ alphabet], parent, index: int32, value: T) {.inline.} =\n        ## \u5B50\u3092\
    \u767B\u9332\u3059\u308B\u30022\u3064\u76EE\u306E\u5B50\u3092\u8FFD\u52A0\u3059\
    \u308B\u3068\u304D\u3060\u3051O(\u03C3)\u3067\u9077\u79FB\u914D\u5217\u3092\u78BA\
    \u4FDD\u3059\u308B\u3002\n        let children = storage.nodes[parent].children\n\
    \        if children == 0:\n            storage.nodes[parent].children = index\n\
    \        elif children > 0:\n            var branch: typeof(storage.branches[0])\n\
    \            branch[typeof(alphabet.a)(storage.nodes[children].character)] = children\n\
    \            branch[typeof(alphabet.a)(value)] = index\n            storage.branches.add(branch)\n\
    \            storage.nodes[parent].children = -int32(storage.branches.len)\n \
    \       else:\n            storage.branches[-children - 1][typeof(alphabet.a)(value)]\
    \ = index\n\n    proc link*[T, alphabet](node: PalindromicTreeNode[T, alphabet]):\
    \ PalindromicTreeLinks[T, alphabet] {.inline.} =\n        ## \u5B50\u3078\u306E\
    \u9077\u79FB\u306E\u8AAD\u307F\u53D6\u308A\u5C02\u7528\u30D3\u30E5\u30FC\u3092\
    O(1)\u3067\u8FD4\u3059\u3002\n        PalindromicTreeLinks[T, alphabet](storage:\
    \ node.storage, parent: node.index)\n\n    proc len*[T, alphabet](links: PalindromicTreeLinks[T,\
    \ alphabet]): int {.inline.} =\n        ## \u5B50\u306E\u500B\u6570\u3092O(\u03C3\
    )\u3067\u8FD4\u3059\u3002\n        let children = links.storage.nodes[links.parent].children\n\
    \        if children > 0: return 1\n        if children < 0:\n            for\
    \ value in alphabet.a..alphabet.b:\n                if links.storage.branches[-children\
    \ - 1][value] != 0: inc result\n\n    proc getOrDefault*[T, alphabet](links: PalindromicTreeLinks[T,\
    \ alphabet], value: T): PalindromicTreeNode[T, alphabet] {.inline.} =\n      \
    \  ## \u5B50\u3092O(1)\u3067\u8FD4\u3059\u3002\u5B58\u5728\u3057\u306A\u3051\u308C\
    \u3070\u7A7A\u306E\u30CF\u30F3\u30C9\u30EB\u3002\n        let index = links.storage.findChild(links.parent,\
    \ value)\n        if index != 0: result = links.storage.nodeAt(index)\n\n    proc\
    \ hasKey*[T, alphabet](links: PalindromicTreeLinks[T, alphabet], value: T): bool\
    \ {.inline.} =\n        ## \u5BFE\u5FDC\u3059\u308B\u5B50\u304C\u5B58\u5728\u3059\
    \u308B\u304B\u3092O(1)\u3067\u8FD4\u3059\u3002\n        links.storage.findChild(links.parent,\
    \ value) != 0\n\n    proc `[]`*[T, alphabet](links: PalindromicTreeLinks[T, alphabet],\
    \ value: T): PalindromicTreeNode[T, alphabet] {.inline.} =\n        ## \u5B50\u3092\
    O(1)\u3067\u8FD4\u3059\u3002\u5B58\u5728\u3057\u306A\u3051\u308C\u3070KeyError\u3002\
    \n        let index = links.storage.findChild(links.parent, value)\n        if\
    \ index == 0: raise newException(KeyError, \"palindromic tree transition not found\"\
    )\n        links.storage.nodeAt(index)\n\n    iterator pairs*[T, alphabet](links:\
    \ PalindromicTreeLinks[T, alphabet]): tuple[key: T, val: PalindromicTreeNode[T,\
    \ alphabet]] =\n        ## \u8981\u7D20\u3068\u5B50\u3092\u5217\u6319\u3059\u308B\
    \u3002O(\u03C3)\u3002\n        let children = links.storage.nodes[links.parent].children\n\
    \        if children > 0:\n            yield (links.storage.nodes[children].character,\
    \ links.storage.nodeAt(children))\n        elif children < 0:\n            for\
    \ value in alphabet.a..alphabet.b:\n                let index = links.storage.branches[-children\
    \ - 1][value]\n                if index != 0:\n                    yield (T(value),\
    \ links.storage.nodeAt(index))\n\n    proc len*[T, alphabet](pt: PalindromicTree[T,\
    \ alphabet]): int {.inline.} =\n        ## \u73FE\u5728\u306E\u5217\u306E\u9577\
    \u3055\u3092O(1)\u3067\u8FD4\u3059\u3002\n        pt.storage.data.len\n\n    proc\
    \ initPalindromicTree*[T: Ordinal](alphabet: static[HSlice[T, T]], capacity: int\
    \ = 0): auto =\n        ## \u9759\u7684\u306A\u8981\u7D20\u7BC4\u56F2\u306E\u7A7A\
    \u306E\u6728\u3092\u4F5C\u308B\u3002capacity\u8981\u7D20\u5206\u3092\u4E8B\u524D\
    \u78BA\u4FDD\u3057\u3001\u8D85\u3048\u305F\u3089\u81EA\u52D5\u62E1\u5F35\u3059\
    \u308B\u3002\n        ## \u521D\u671F\u78BA\u4FDD\u306F\u6642\u9593\u30FB\u7A7A\
    \u9593O(capacity+1)\u3002\u5206\u5C90\u30CE\u30FC\u30C9\u6570B\u3068\u3057\u3066\
    \u69CB\u7BC9\u5168\u4F53\u306E\u6642\u9593\u306FO(N+\u03C3B)\u3002\n        when\
    \ NimMajor >= 2:\n            const bounds = alphabet\n        else:\n       \
    \     const bounds = ord(alphabet.a)..ord(alphabet.b)\n        static: assert\
    \ bounds.a <= bounds.b\n        assert capacity >= 0 and capacity <= int32.high.int\
    \ - 2\n        var pt: PalindromicTree[T, bounds]\n        pt.storage = PalindromicTreeStorage[T,\
    \ bounds](data: newSeqOfCap[T](capacity),\n            nodes: newSeqOfCap[PalindromicTreeNodeData[T,\
    \ bounds]](capacity + 2))\n        pt.nodes = newSeqOfCap[PalindromicTreeNode[T,\
    \ bounds]](capacity + 2)\n        pt.prefix_nodes = newSeqOfCap[PalindromicTreeNode[T,\
    \ bounds]](capacity)\n        pt.storage.nodes.add(PalindromicTreeNodeData[T,\
    \ bounds](length: -1, parent: -1, suffix: -1, series: -1))\n        pt.storage.nodes.add(PalindromicTreeNodeData[T,\
    \ bounds](parent: -1, suffix: 0, series: 0))\n        pt.nodes.add(pt.storage.nodeAt(0))\n\
    \        pt.nodes.add(pt.storage.nodeAt(1))\n        pt.last_node = pt.nodes[1]\n\
    \        pt\n\n    proc find_longest[T, alphabet](storage: PalindromicTreeStorage[T,\
    \ alphabet], node: int32): int32 {.inline.} =\n        ## \u672B\u5C3E\u306E\u8981\
    \u7D20\u3067\u62E1\u5F35\u3067\u304D\u308B\u6700\u9577\u306E\u63A5\u5C3E\u56DE\
    \u6587\u3092\u63A2\u3059\u3002\u6700\u60AAO(\u5217\u306E\u9577\u3055)\u3002\n\
    \        result = node\n        let pos = storage.data.len - 1\n        while\
    \ true:\n            let left = pos - storage.nodes[result].length.int - 1\n \
    \           if left >= 0 and storage.data[left] == storage.data[pos]: return\n\
    \            result = storage.nodes[result].suffix\n\n    proc add*[T, alphabet](pt:\
    \ var PalindromicTree[T, alphabet], value: T): PalindromicTreeNode[T, alphabet]\
    \ {.discardable.} =\n        ## \u672B\u5C3E\u306B\u8981\u7D20\u3092\u8FFD\u52A0\
    \u3057\u6700\u9577\u56DE\u6587\u63A5\u5C3E\u8F9E\u3092\u8FD4\u3059\u3002\u511F\
    \u5374O(\u03C3)\u3002\u03C3\u56FA\u5B9A\u306A\u3089\u511F\u5374O(1)\u3002\n  \
    \      ## \u7DCF\u51FA\u73FE\u56DE\u6570\u306Fupdate_count\u3067\u518D\u96C6\u8A08\
    \u3059\u308B\u3002\u5217\u306E\u9577\u3055\u306E\u4E0A\u9650\u306Fint32.high-2\u3002\
    \n        let storage = pt.storage\n        assert storage.data.len < int32.high.int\
    \ - 2\n        assert ord(value) >= ord(alphabet.a) and ord(value) <= ord(alphabet.b)\n\
    \        storage.data.add(value)\n        let parent = storage.find_longest(pt.last_node.index)\n\
    \        var index = storage.findChild(parent, value)\n        if index == 0:\n\
    \            let suffix = if parent == 0: 1'i32\n                else: storage.findChild(storage.find_longest(storage.nodes[parent].suffix),\
    \ value)\n            let length = storage.nodes[parent].length + 2\n        \
    \    let diff = length - storage.nodes[suffix].length\n            let suffixDiff\
    \ = if suffix < 2: 0'i32\n                else: storage.nodes[suffix].length -\
    \ storage.nodes[storage.nodes[suffix].suffix].length\n            let series =\
    \ if diff == suffixDiff: storage.nodes[suffix].series else: suffix\n         \
    \   index = int32(storage.nodes.len)\n            storage.nodes.add(PalindromicTreeNodeData[T,\
    \ alphabet](length: length, parent: parent,\n                suffix: suffix, series:\
    \ series, character: value))\n            pt.nodes.add(storage.nodeAt(index))\n\
    \            storage.addChild(parent, index, value)\n        inc storage.nodes[index].terminal_count\n\
    \        result = storage.nodeAt(index)\n        pt.prefix_nodes.add(result)\n\
    \        pt.last_node = result\n        storage.updated = false\n\n    proc initPalindromicTree*[T:\
    \ Ordinal](a: openArray[T], alphabet: static[HSlice[T, T]]): auto =\n        ##\
    \ \u9759\u7684\u306A\u8981\u7D20\u7BC4\u56F2\u3092\u6307\u5B9A\u3057\u3001\u5217\
    \u304B\u3089O(\u03C3(a.len+1))\u3067\u69CB\u7BC9\u3059\u308B\u3002\n        var\
    \ pt = initPalindromicTree(alphabet, a.len)\n        for value in a:\n       \
    \     pt.add(value)\n        pt\n\n    proc initPalindromicTree*(s: openArray[char]):\
    \ auto =\n        ## \u82F1\u5C0F\u6587\u5B57\u5217\u304B\u3089\u56DE\u6587\u6728\
    \u3092O(s.len+1)\u3067\u69CB\u7BC9\u3059\u308B\u3002\n        initPalindromicTree(s,\
    \ 'a'..'z')\n\n    proc get_palindrome*[T, alphabet](node: PalindromicTreeNode[T,\
    \ alphabet]): seq[T] =\n        ## \u89AA\u30EA\u30F3\u30AF\u304B\u3089\u56DE\u6587\
    \u3092O(node.len)\u3067\u5FA9\u5143\u3059\u308B\u3002\u6839\u3067\u306F\u7A7A\u306E\
    \u5217\u3002\n        result = newSeq[T](max(0, node.len))\n        var index\
    \ = node.index\n        var left = 0\n        var right = result.len - 1\n   \
    \     while node.storage.nodes[index].length > 0:\n            result[left] =\
    \ node.storage.nodes[index].character\n            result[right] = node.storage.nodes[index].character\n\
    \            inc left\n            dec right\n            index = node.storage.nodes[index].parent\n\
    \n    proc get_palindrome*[T, alphabet](pt: PalindromicTree[T, alphabet], node:\
    \ PalindromicTreeNode[T, alphabet]): seq[T] =\n        ## \u6307\u5B9A\u3057\u305F\
    \u30CE\u30FC\u30C9\u306E\u56DE\u6587\u3092O(node.len)\u3067\u5FA9\u5143\u3059\u308B\
    \u3002\n        node.get_palindrome()\n\n    proc update_count*[T, alphabet](pt:\
    \ PalindromicTree[T, alphabet]) =\n        ## \u5404\u56DE\u6587\u306E\u7DCF\u51FA\
    \u73FE\u56DE\u6570\u3092O(pt.nodes.len)\u3067\u518D\u96C6\u8A08\u3059\u308B\u3002\
    \u7E70\u308A\u8FD4\u3057\u547C\u3073\u51FA\u3057\u53EF\u80FD\u3002\n        let\
    \ storage = pt.storage\n        for node in storage.nodes.mitems:\n          \
    \  node.total_count = node.terminal_count\n        for i in countdown(storage.nodes.len\
    \ - 1, 1):\n            let suffix = storage.nodes[i].suffix\n            storage.nodes[suffix].total_count\
    \ += storage.nodes[i].total_count\n        storage.updated = true\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/palindromic_tree.nim
  requiredBy: []
  timestamp: '2026-10-01 03:07:49+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/palindromic_tree_test.nim
  - verify/str/palindromic_tree_test.nim
  - verify/str/palindromic_tree_series_link_test.nim
  - verify/str/palindromic_tree_series_link_test.nim
  - verify/str/palindromic_tree_append_test.nim
  - verify/str/palindromic_tree_append_test.nim
  - verify/str/palindromic_tree_eertree_test.nim
  - verify/str/palindromic_tree_eertree_test.nim
  - verify/AI/palindromic_tree_test.nim
  - verify/AI/palindromic_tree_test.nim
documentation_of: cplib/str/palindromic_tree.nim
layout: document
redirect_from:
- /library/cplib/str/palindromic_tree.nim
- /library/cplib/str/palindromic_tree.nim.html
title: cplib/str/palindromic_tree.nim
---
