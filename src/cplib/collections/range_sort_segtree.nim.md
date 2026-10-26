---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/range_sort_array_test.nim
    title: verify/AI/range_sort_array_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/range_sort_array_test.nim
    title: verify/AI/range_sort_array_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/range_sort_segtree_test.nim
    title: verify/AI/range_sort_segtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/range_sort_segtree_test.nim
    title: verify/AI/range_sort_segtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_sort_segtree_test.nim
    title: verify/collections/range_sort_segtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_sort_segtree_test.nim
    title: verify/collections/range_sort_segtree_test.nim
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
  code: "## \u6574\u6570\u30AD\u30FC\u306B\u3088\u308B\u533A\u9593\u30BD\u30FC\u30C8\
    \u3068\u3001\u73FE\u5728\u306E\u914D\u5217\u9806\u3067\u306E\u30E2\u30CE\u30A4\
    \u30C9\u306E\u533A\u9593\u7A4D\u3092\u6271\u3044\u307E\u3059\u3002\n## \u30AD\u30FC\
    \u306F [0,keyLimit) \u5185\u3067\u3001\u73FE\u5728\u306E\u8981\u7D20\u9593\u3067\
    \u76F8\u7570\u306A\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n## merge\u306B\
    \u306F\u5DE6\u3001\u53F3\u306E\u9806\u306B\u7D50\u5408\u3059\u308B\u6F14\u7B97\
    \u3001default\u306B\u306F\u5358\u4F4D\u5143\u3092\u6E21\u3057\u307E\u3059\u3002\
    \n## N\u3092\u8981\u7D20\u6570\u3001U\u3092keyLimit\u3068\u3057\u3001merge\u304C\
    O(1)\u306A\u3089\u69CB\u7BC9\u3068Q\u64CD\u4F5C\u306E\u5408\u8A08\u306F\n## O((N+Q)(log(N+1)+log(U+1)))\u3001\
    \u7A7A\u9593\u306FO(N)\u3067\u3059\u3002\n## \u30BD\u30FC\u30C8\u306E\u8A08\u7B97\
    \u91CF\u306F\u511F\u5374\u3067\u3059\u3002\u4E0D\u8981\u306A\u30CE\u30FC\u30C9\
    \u306F\u518D\u5229\u7528\u3057\u307E\u3059\u3002\n## \u6DFB\u5B57\u306F\u5E38\u306B\
    \u73FE\u5728\u306E\u914D\u5217\u4E0A\u306E\u4F4D\u7F6E\u3067\u3001\u30BD\u30FC\
    \u30C8\u6642\u306B\u30AD\u30FC\u3068\u5024\u304C\u4E00\u7DD2\u306B\u79FB\u52D5\
    \u3057\u307E\u3059\u3002\n## \u7A7A\u533A\u9593\u306E\u7A4D\u306Fdefault\u3001\
    \u7A7A\u533A\u9593\u306E\u30BD\u30FC\u30C8\u306F\u4F55\u3082\u3057\u307E\u305B\
    \u3093\u3002\n## \u4F7F\u7528\u4F8B::\n##   import algorithm\n##   import cplib/collections/range_sort_segtree\n\
    ##   let seg = initRangeSortSegmentTree([3, 1, 2], [\"C\", \"A\", \"B\"], 4,\n\
    ##       proc(x, y: string): string = x & y, \"\")\n##   seg.sort(0, 3)      \
    \           # \u5024\u306E\u4E26\u3073\u306F A, B, C\n##   seg.sort(0..<2, Descending)\
    \    # \u5024\u306E\u4E26\u3073\u306F B, A, C\n##   seg[1] = \"a\"           \
    \       # \u30AD\u30FC1\u3092\u4FDD\u3063\u3066\u5024\u3060\u3051\u5909\u66F4\n\
    ##   seg.update(2, 0, \"D\")          # \u73FE\u5728\u306E\u4F4D\u7F6E2\u306E\u30AD\
    \u30FC\u3068\u5024\u3092\u5909\u66F4\n##   echo seg.get(0, 3)             # BaD\n\
    when not declared CPLIB_COLLECTIONS_RANGE_SORT_SEGTREE:\n    const CPLIB_COLLECTIONS_RANGE_SORT_SEGTREE*\
    \ = 1\n    import algorithm, bitops, sets\n    import cplib/collections/segtree\n\
    \    import cplib/utils/backwards_index\n\n    type\n        RangeSortSegmentTreeNode[T]\
    \ = object\n            left, right, count: int\n            key, bit: int\n \
    \           ascending, descending: T\n        RangeSortSegmentTree*[T] = ref object\n\
    \            nodes: seq[RangeSortSegmentTreeNode[T]]\n            freeNodes: seq[int]\n\
    \            roots, next: seq[int]\n            reversed: seq[bool]\n        \
    \    starts: SegmentTree[int]\n            products: SegmentTree[T]\n        \
    \    keyLimit: int\n            merge: proc(x, y: T): T\n            default:\
    \ T\n            when compileOption(\"assertions\"):\n                activeKeys:\
    \ HashSet[int]\n\n    proc len*[T](self: RangeSortSegmentTree[T]): int =\n   \
    \     ## \u8981\u7D20\u6570\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n  \
    \      self.roots.len\n\n    proc newNode[T](self: RangeSortSegmentTree[T]): int\
    \ =\n        ## \u7A7A\u304D\u30CE\u30FC\u30C9\u3092\u518D\u5229\u7528\u3057\u3001\
    \u306A\u3051\u308C\u3070\u78BA\u4FDD\u3057\u307E\u3059\u3002\u511F\u5374O(1)\u3002\
    \n        if self.freeNodes.len > 0:\n            return self.freeNodes.pop()\n\
    \        else:\n            result = self.nodes.len\n            self.nodes.add(RangeSortSegmentTreeNode[T]())\n\
    \n    proc releaseNode[T](self: RangeSortSegmentTree[T], node: int) =\n      \
    \  ## \u30CE\u30FC\u30C9\u306E\u5024\u3092\u89E3\u653E\u3057\u3066\u518D\u5229\
    \u7528\u5019\u88DC\u306B\u3057\u307E\u3059\u3002O(1)\u3002\n        self.nodes[node]\
    \ = RangeSortSegmentTreeNode[T]()\n        self.freeNodes.add(node)\n\n    proc\
    \ pull[T](self: RangeSortSegmentTree[T], node: int) =\n        ## \u5B50\u304B\
    \u3089\u8981\u7D20\u6570\u3068\u4E21\u65B9\u5411\u306E\u7A4D\u3092\u66F4\u65B0\
    \u3057\u307E\u3059\u3002O(1)\u3002\n        let left = self.nodes[node].left\n\
    \        let right = self.nodes[node].right\n        self.nodes[node].key = self.nodes[left].key\n\
    \        self.nodes[node].count = self.nodes[left].count + self.nodes[right].count\n\
    \        self.nodes[node].ascending = self.merge(\n            self.nodes[left].ascending,\
    \ self.nodes[right].ascending)\n        self.nodes[node].descending = self.merge(\n\
    \            self.nodes[right].descending, self.nodes[left].descending)\n\n  \
    \  proc newBranch[T](self: RangeSortSegmentTree[T], left, right, bit: int): int\
    \ =\n        ## \u6307\u5B9A\u3057\u305F\u5206\u5C90\u30D3\u30C3\u30C8\u3068\u7A7A\
    \u3067\u306A\u3044\u5B50\u304B\u3089\u5185\u90E8\u30CE\u30FC\u30C9\u3092\u751F\
    \u6210\u3057\u307E\u3059\u3002\u511F\u5374O(1)\u3002\n        result = self.newNode()\n\
    \        self.nodes[result].left = left\n        self.nodes[result].right = right\n\
    \        self.nodes[result].bit = bit\n        self.pull(result)\n\n    proc singleton[T](self:\
    \ RangeSortSegmentTree[T], key: int, value: T): int =\n        ## \u30AD\u30FC\
    1\u500B\u306E\u8449\u3092\u751F\u6210\u3057\u307E\u3059\u3002\u511F\u5374O(1)\u3002\
    \n        result = self.newNode()\n        self.nodes[result] = RangeSortSegmentTreeNode[T](\n\
    \            count: 1, key: key, bit: -1, ascending: value, descending: value)\n\
    \n    proc splitNode[T](self: RangeSortSegmentTree[T], node, k: int): (int, int)\
    \ =\n        ## \u5C0F\u3055\u3044\u30AD\u30FC\u304B\u3089k\u500B\u3068\u6B8B\u308A\
    \u306B\u7834\u58CA\u7684\u5206\u5272\u3057\u307E\u3059\u3002O(log(U+1))\u3002\n\
    \        if k == 0: return (0, node)\n        if k == self.nodes[node].count:\
    \ return (node, 0)\n        let left = self.nodes[node].left\n        let right\
    \ = self.nodes[node].right\n        let leftCount = self.nodes[left].count\n \
    \       if k == leftCount:\n            self.releaseNode(node)\n            return\
    \ (left, right)\n        if k < leftCount:\n            let (a, b) = self.splitNode(left,\
    \ k)\n            self.nodes[node].left = b\n            self.pull(node)\n   \
    \         return (a, node)\n        else:\n            let (a, b) = self.splitNode(right,\
    \ k - leftCount)\n            self.nodes[node].right = a\n            self.pull(node)\n\
    \            return (node, b)\n\n    proc meld[T](self: RangeSortSegmentTree[T],\
    \ a, b: int): int =\n        ## \u5206\u5C90\u306E\u306A\u3044\u7D4C\u8DEF\u3092\
    \u7701\u7565\u3057\u305F\u30AD\u30FC\u306E\u6728\u3092\u7834\u58CA\u7684\u306B\
    \u878D\u5408\u3057\u307E\u3059\u3002\n        let aBit = self.nodes[a].bit\n \
    \       let bBit = self.nodes[b].bit\n        let different = self.nodes[a].key\
    \ xor self.nodes[b].key\n        let bit = if different == 0: -1 else: fastLog2(uint(different))\n\
    \        if bit > max(aBit, bBit):\n            if self.nodes[a].key < self.nodes[b].key:\n\
    \                return self.newBranch(a, b, bit)\n            return self.newBranch(b,\
    \ a, bit)\n        if aBit < bBit:\n            return self.meld(b, a)\n     \
    \   if aBit > bBit:\n            if ((self.nodes[b].key shr aBit) and 1) == 0:\n\
    \                let child = self.meld(self.nodes[a].left, b)\n              \
    \  self.nodes[a].left = child\n            else:\n                let child =\
    \ self.meld(self.nodes[a].right, b)\n                self.nodes[a].right = child\n\
    \        else:\n            let left = self.meld(self.nodes[a].left, self.nodes[b].left)\n\
    \            let right = self.meld(self.nodes[a].right, self.nodes[b].right)\n\
    \            self.nodes[a].left = left\n            self.nodes[a].right = right\n\
    \            self.releaseNode(b)\n        self.pull(a)\n        a\n\n    proc\
    \ refresh[T](self: RangeSortSegmentTree[T], start: int) =\n        ## \u30D6\u30ED\
    \u30C3\u30AF\u5168\u4F53\u306E\u7A4D\u3092\u5916\u5074\u306E\u30BB\u30B0\u6728\
    \u3078\u53CD\u6620\u3057\u307E\u3059\u3002O(log(N+1))\u3002\n        let root\
    \ = self.roots[start]\n        self.products[start] = if self.reversed[start]:\n\
    \            self.nodes[root].descending\n        else:\n            self.nodes[root].ascending\n\
    \n    proc blockStart[T](self: RangeSortSegmentTree[T], index: int): int {.inline.}\
    \ =\n        ## index\u3092\u542B\u3080\u30D6\u30ED\u30C3\u30AF\u306E\u59CB\u70B9\
    \u3092\u6C42\u3081\u307E\u3059\u3002O(log(N+1))\u3002\n        if self.roots[index]\
    \ != 0: return index\n        var node = index + self.starts.arr.len div 2\n \
    \       while node > 1:\n            if (node and 1) != 0 and self.starts.arr[node\
    \ - 1] != -1:\n                return self.starts.arr[node - 1]\n            node\
    \ = node shr 1\n        -1\n\n    proc setStart[T](self: RangeSortSegmentTree[T],\
    \ index, value: int) =\n        ## \u30D6\u30ED\u30C3\u30AF\u5883\u754C\u3092\u66F4\
    \u65B0\u3057\u3001\u5024\u306E\u5909\u308F\u3089\u306A\u3044\u7956\u5148\u3067\
    \u6253\u3061\u5207\u308A\u307E\u3059\u3002O(log(N+1))\u3002\n        var node\
    \ = index + self.starts.arr.len div 2\n        self.starts.arr[node] = value\n\
    \        node = node shr 1\n        while node > 0:\n            let value = max(self.starts.arr[node\
    \ * 2], self.starts.arr[node * 2 + 1])\n            if self.starts.arr[node] ==\
    \ value: break\n            self.starts.arr[node] = value\n            node =\
    \ node shr 1\n\n    proc cut[T](self: RangeSortSegmentTree[T], index: int) =\n\
    \        ## \u914D\u5217\u4E0A\u306Eindex\u306E\u76F4\u524D\u306B\u30D6\u30ED\u30C3\
    \u30AF\u5883\u754C\u3092\u4F5C\u308A\u307E\u3059\u3002O(log(N+1)+log(U+1))\u3002\
    \n        if index == self.len or self.roots[index] != 0: return\n        let\
    \ start = self.blockStart(index)\n        let root = self.roots[start]\n     \
    \   let k = index - start\n        var a, b: int\n        if self.reversed[start]:\n\
    \            (b, a) = self.splitNode(root, self.nodes[root].count - k)\n     \
    \   else:\n            (a, b) = self.splitNode(root, k)\n        self.roots[start]\
    \ = a\n        self.roots[index] = b\n        self.reversed[index] = self.reversed[start]\n\
    \        self.next[index] = self.next[start]\n        self.next[start] = index\n\
    \        self.setStart(index, index)\n        self.refresh(start)\n        self.refresh(index)\n\
    \n    proc initRangeSortSegmentTree*[T](keys: openArray[int], values: openArray[T],\n\
    \            keyLimit: int, merge: proc(x, y: T): T,\n            default: T):\
    \ RangeSortSegmentTree[T] =\n        ## \u4E0E\u3048\u305F\u4E26\u3073\u9806\u3067\
    \u69CB\u7BC9\u3057\u307E\u3059\u3002O(N)\u6642\u9593\u30FB\u7A7A\u9593\u3002\n\
    \        ## keys\u3068values\u306F\u540C\u3058\u9577\u3055\u3001\u30AD\u30FC\u306F\
    [0,keyLimit)\u5185\u3067\u76F8\u7570\u306A\u308B\u3053\u3068\u304C\u5FC5\u8981\
    \u3067\u3059\u3002\n        ## \u30AD\u30FC\u306E\u91CD\u8907\u306Fassert\u6709\
    \u52B9\u6642\u306B\u691C\u67FB\u3057\u307E\u3059\uFF08\u30CF\u30C3\u30B7\u30E5\
    \u96C6\u5408\u64CD\u4F5C\u306F\u671F\u5F85O(1)\uFF09\u3002\n        assert keys.len\
    \ == values.len, \"\u30AD\u30FC\u3068\u5024\u306E\u500B\u6570\u306F\u4E00\u81F4\
    \u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        assert keyLimit\
    \ >= 0, \"keyLimit\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n        let n = keys.len\n        result = RangeSortSegmentTree[T](\n\
    \            roots: newSeq[int](n), next: newSeq[int](n), reversed: newSeq[bool](n),\n\
    \            keyLimit: keyLimit, merge: merge, default: default,\n           \
    \ nodes: newSeqOfCap[RangeSortSegmentTreeNode[T]](max(1, 2 * n)),\n          \
    \  products: initSegmentTree(values, merge, default))\n        result.nodes.add(RangeSortSegmentTreeNode[T](ascending:\
    \ default, descending: default))\n        var starts = newSeq[int](n)\n      \
    \  when compileOption(\"assertions\"):\n            result.activeKeys = initHashSet[int]()\n\
    \        for i in 0..<n:\n            assert 0 <= keys[i] and keys[i] < keyLimit,\
    \ \"\u30AD\u30FC\u306F[0,keyLimit)\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n            when compileOption(\"assertions\"):\n      \
    \          assert keys[i] notin result.activeKeys, \"\u30AD\u30FC\u306F\u76F8\u7570\
    \u306A\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n                result.activeKeys.incl(keys[i])\n\
    \            result.roots[i] = result.singleton(keys[i], values[i])\n        \
    \    result.next[i] = i + 1\n            starts[i] = i\n        result.starts\
    \ = initSegmentTree(starts, proc(x, y: int): int = max(x, y), -1)\n\n    proc\
    \ locate[T](self: RangeSortSegmentTree[T], index: int): tuple[node, key: int]\
    \ =\n        ## \u73FE\u5728\u306E\u4F4D\u7F6E\u306E\u8449\u3068\u30AD\u30FC\u3092\
    \u53D6\u5F97\u3057\u307E\u3059\u3002O(log(N+1)+log(U+1))\u3002\n        assert\
    \ 0 <= index and index < self.len, \"\u6DFB\u5B57\u306F[0,len)\u5185\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        let start = self.blockStart(index)\n\
    \        var node = self.roots[start]\n        var k = index - start\n       \
    \ if self.reversed[start]: k = self.nodes[node].count - 1 - k\n        while self.nodes[node].count\
    \ > 1:\n            let left = self.nodes[node].left\n            if k < self.nodes[left].count:\n\
    \                node = left\n            else:\n                k -= self.nodes[left].count\n\
    \                node = self.nodes[node].right\n        (node, self.nodes[node].key)\n\
    \n    proc `[]`*[T](self: RangeSortSegmentTree[T], index: int): T {.backwardsIndex.}\
    \ =\n        ## \u73FE\u5728\u306E\u4F4D\u7F6Eindex\u306E\u5024\u3092\u53D6\u5F97\
    \u3057\u307E\u3059\u3002O(log(N+1)+log(U+1))\u3002\n        self.nodes[self.locate(index).node].ascending\n\
    \n    proc key*[T](self: RangeSortSegmentTree[T], index: int): int =\n       \
    \ ## \u73FE\u5728\u306E\u4F4D\u7F6Eindex\u306E\u30AD\u30FC\u3092\u53D6\u5F97\u3057\
    \u307E\u3059\u3002O(log(N+1)+log(U+1))\u3002\n        self.locate(index).key\n\
    \n    proc updateValue[T](self: RangeSortSegmentTree[T], node, key: int, value:\
    \ T) =\n        ## \u6307\u5B9A\u30AD\u30FC\u306E\u5024\u3068\u7956\u5148\u306E\
    \u7A4D\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(log(U+1))\u3002\n        if\
    \ self.nodes[node].count == 1:\n            self.nodes[node].ascending = value\n\
    \            self.nodes[node].descending = value\n            return\n       \
    \ if ((key shr self.nodes[node].bit) and 1) == 0:\n            self.updateValue(self.nodes[node].left,\
    \ key, value)\n        else:\n            self.updateValue(self.nodes[node].right,\
    \ key, value)\n        self.pull(node)\n\n    proc update*[T](self: RangeSortSegmentTree[T],\
    \ index: int, value: T) =\n        ## \u30AD\u30FC\u3092\u4FDD\u3063\u3066\u5024\
    \u3092\u5909\u66F4\u3057\u307E\u3059\u3002O(log(N+1)+log(U+1))\u3002\n       \
    \ let key = self.key(index)\n        let start = self.blockStart(index)\n    \
    \    self.updateValue(self.roots[start], key, value)\n        self.refresh(start)\n\
    \n    proc `[]=`*[T](self: RangeSortSegmentTree[T], index: int, value: T) {.backwardsIndex.}\
    \ =\n        ## \u30AD\u30FC\u3092\u4FDD\u3063\u3066\u5024\u3092\u5909\u66F4\u3057\
    \u307E\u3059\u3002O(log(N+1)+log(U+1))\u3002\n        self.update(index, value)\n\
    \n    proc update*[T](self: RangeSortSegmentTree[T], index, key: int, value: T)\
    \ =\n        ## \u30AD\u30FC\u3068\u5024\u3092\u5909\u66F4\u3057\u307E\u3059\u3002\
    O(log(N+1)+log(U+1))\u3002\u4ED6\u306E\u8981\u7D20\u3068\u306E\u30AD\u30FC\u91CD\
    \u8907\u306F\u7981\u6B62\u3067\u3059\u3002\n        assert 0 <= index and index\
    \ < self.len, \"\u6DFB\u5B57\u306F[0,len)\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\"\n        assert 0 <= key and key < self.keyLimit, \"\
    \u30AD\u30FC\u306F[0,keyLimit)\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n        when compileOption(\"assertions\"):\n          \
    \  let oldKey = self.key(index)\n            assert key == oldKey or key notin\
    \ self.activeKeys, \"\u30AD\u30FC\u306F\u76F8\u7570\u306A\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\"\n            self.activeKeys.excl(oldKey)\n       \
    \     self.activeKeys.incl(key)\n        self.cut(index)\n        self.cut(index\
    \ + 1)\n        self.releaseNode(self.roots[index])\n        let root = self.singleton(key,\
    \ value)\n        self.roots[index] = root\n        self.reversed[index] = false\n\
    \        self.refresh(index)\n\n    proc nodeProduct[T](self: RangeSortSegmentTree[T],\
    \ node, l, r: int,\n            reversed: bool): T =\n        ## \u30AD\u30FC\u6607\
    \u9806\u306E\u9806\u4F4D[l,r)\u306E\u7A4D\u3092\u3001\u6307\u5B9A\u3055\u308C\u305F\
    \u65B9\u5411\u3067\u8FD4\u3057\u307E\u3059\u3002O(log(U+1))\u3002\n        if\
    \ l == 0 and r == self.nodes[node].count:\n            return if reversed: self.nodes[node].descending\
    \ else: self.nodes[node].ascending\n        let left = self.nodes[node].left\n\
    \        let right = self.nodes[node].right\n        let count = self.nodes[left].count\n\
    \        if r <= count: return self.nodeProduct(left, l, r, reversed)\n      \
    \  if l >= count: return self.nodeProduct(right, l - count, r - count, reversed)\n\
    \        let a = self.nodeProduct(left, l, count, reversed)\n        let b = self.nodeProduct(right,\
    \ 0, r - count, reversed)\n        if reversed: self.merge(b, a) else: self.merge(a,\
    \ b)\n\n    proc blockProduct[T](self: RangeSortSegmentTree[T], start, l, r: int):\
    \ T =\n        ## 1\u30D6\u30ED\u30C3\u30AF\u5185\u306E\u4F4D\u7F6E[l,r)\u306E\
    \u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002O(log(U+1))\u3002\n        let root\
    \ = self.roots[start]\n        if self.reversed[start]:\n            self.nodeProduct(root,\
    \ self.next[start] - r, self.next[start] - l, true)\n        else:\n         \
    \   self.nodeProduct(root, l - start, r - start, false)\n\n    proc get*[T](self:\
    \ RangeSortSegmentTree[T], l, r: int): T =\n        ## \u73FE\u5728\u306E\u4E26\
    \u3073\u9806\u3067[l,r)\u306E\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u533A\
    \u9593\u306F\u5358\u4F4D\u5143\u3002O(log(N+1)+log(U+1))\u3002\n        assert\
    \ 0 <= l and l <= r and r <= self.len, \"\u533A\u9593\u306F0 <= l <= r <= len\u3092\
    \u6E80\u305F\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        if l ==\
    \ r: return self.default\n        let left = self.blockStart(l)\n        let right\
    \ = self.blockStart(r - 1)\n        if left == right: return self.blockProduct(left,\
    \ l, r)\n        result = self.blockProduct(left, l, self.next[left])\n      \
    \  if self.next[left] < right:\n            result = self.merge(result, self.products.get(self.next[left],\
    \ right))\n        result = self.merge(result, self.blockProduct(right, right,\
    \ r))\n\n    proc get*[T](self: RangeSortSegmentTree[T], segment: HSlice[int,\
    \ int]): T =\n        ## \u30B9\u30E9\u30A4\u30B9\u3067\u6307\u5B9A\u3057\u305F\
    \u533A\u9593\u306E\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002O(log(N+1)+log(U+1))\u3002\
    \n        assert 0 <= segment.a and segment.a <= self.len and\n            segment.a\
    \ - 1 <= segment.b and segment.b < self.len, \"\u533A\u9593\u304C\u7BC4\u56F2\u5916\
    \u3067\u3059\"\n        self.get(segment.a, segment.b + 1)\n\n    proc `[]`*[T](self:\
    \ RangeSortSegmentTree[T], segment: HSlice[int, int]): T =\n        ## \u30B9\u30E9\
    \u30A4\u30B9\u3067\u6307\u5B9A\u3057\u305F\u533A\u9593\u306E\u7A4D\u3092\u8FD4\
    \u3057\u307E\u3059\u3002O(log(N+1)+log(U+1))\u3002\n        self.get(segment)\n\
    \n    proc get_all*[T](self: RangeSortSegmentTree[T]): T =\n        ## \u5168\u4F53\
    \u306E\u7A4D\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.products.get_all()\n\
    \n    proc sort*[T](self: RangeSortSegmentTree[T], l, r: int,\n            order:\
    \ SortOrder = Ascending) =\n        ## [l,r)\u3092\u30AD\u30FC\u9806\u306B\u30BD\
    \u30FC\u30C8\u3057\u307E\u3059\u3002\u511F\u5374O(log(N+1)+log(U+1))\u3002\u7A7A\
    \u533A\u9593\u306F\u5909\u66F4\u3057\u307E\u305B\u3093\u3002\n        assert 0\
    \ <= l and l <= r and r <= self.len, \"\u533A\u9593\u306F0 <= l <= r <= len\u3092\
    \u6E80\u305F\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        if r -\
    \ l <= 1: return\n        self.cut(l)\n        self.cut(r)\n        var root =\
    \ self.roots[l]\n        var start = self.next[l]\n        while start < r:\n\
    \            root = self.meld(root, self.roots[start])\n            self.roots[start]\
    \ = 0\n            self.products[start] = self.default\n            self.setStart(start,\
    \ -1)\n            start = self.next[start]\n        self.roots[l] = root\n  \
    \      self.next[l] = r\n        self.reversed[l] = order == Descending\n    \
    \    self.refresh(l)\n\n    proc sort*[T](self: RangeSortSegmentTree[T], segment:\
    \ HSlice[int, int],\n            order: SortOrder = Ascending) =\n        ## \u30B9\
    \u30E9\u30A4\u30B9\u3067\u6307\u5B9A\u3057\u305F\u533A\u9593\u3092\u30BD\u30FC\
    \u30C8\u3057\u307E\u3059\u3002\u511F\u5374O(log(N+1)+log(U+1))\u3002\n       \
    \ assert 0 <= segment.a and segment.a <= self.len and\n            segment.a -\
    \ 1 <= segment.b and segment.b < self.len, \"\u533A\u9593\u304C\u7BC4\u56F2\u5916\
    \u3067\u3059\"\n        self.sort(segment.a, segment.b + 1, order)\n"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/segtree.nim
  isVerificationFile: false
  path: cplib/collections/range_sort_segtree.nim
  requiredBy: []
  timestamp: '2026-09-28 03:02:53+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/range_sort_segtree_test.nim
  - verify/collections/range_sort_segtree_test.nim
  - verify/AI/range_sort_segtree_test.nim
  - verify/AI/range_sort_segtree_test.nim
  - verify/AI/range_sort_array_test.nim
  - verify/AI/range_sort_array_test.nim
documentation_of: cplib/collections/range_sort_segtree.nim
layout: document
redirect_from:
- /library/cplib/collections/range_sort_segtree.nim
- /library/cplib/collections/range_sort_segtree.nim.html
title: cplib/collections/range_sort_segtree.nim
---
