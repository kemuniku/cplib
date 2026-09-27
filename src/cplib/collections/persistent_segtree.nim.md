---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/persistent_segtree_test.nim
    title: verify/AI/persistent_segtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/persistent_segtree_test.nim
    title: verify/AI/persistent_segtree_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_PERSISTENT_SEGTREE:\n    const CPLIB_COLLECTIONS_PERSISTENT_SEGTREE*\
    \ = 1\n    import cplib/utils/backwards_index\n    import strutils\n\n    type\n\
    \        SegmentTreeNode*[T] = ref object\n            value: T\n            left,\
    \ right: SegmentTreeNode[T]\n        PersistentSegmentTreeNode[T] = ptr PersistentSegmentTreeNodeData[T]\n\
    \        PersistentSegmentTreeNodeData[T] = object\n            value: T\n   \
    \         left, right: PersistentSegmentTreeNode[T]\n        PersistentSegmentTreeArena[T]\
    \ = ref object\n            blocks: seq[seq[PersistentSegmentTreeNodeData[T]]]\n\
    \            used: int\n        PersistentSegmentTreeOwner[T] = ref object\n \
    \           arena: PersistentSegmentTreeArena[T]\n            parent: PersistentSegmentTreeOwner[T]\n\
    \            arenas: seq[PersistentSegmentTreeArena[T]]\n        PSegmentTree*[T]\
    \ = ref object\n            owner: PersistentSegmentTreeOwner[T]\n           \
    \ root: PersistentSegmentTreeNode[T]\n            lastnode, length: int\n    \
    \        op: proc(l, r: T): T\n            e: T\n        PersistentSegmentTree*[T]\
    \ = PSegmentTree[T]\n\n    proc newNode[T](arena: PersistentSegmentTreeArena[T],\
    \ value: T,\n            left: PersistentSegmentTreeNode[T] = nil,\n         \
    \   right: PersistentSegmentTreeNode[T] = nil): PersistentSegmentTreeNode[T] {.inline.}\
    \ =\n        ## \u30CE\u30FC\u30C9\u3092\u307E\u3068\u3081\u3066\u78BA\u4FDD\u3057\
    \u3001\u53C2\u7167\u306E\u79FB\u52D5\u3057\u306A\u3044\u9818\u57DF\u306B\u683C\
    \u7D0D\u3057\u307E\u3059\u3002\u511F\u5374O(1)\u3002\n        const blockSize\
    \ = 1024\n        if arena.blocks.len == 0 or arena.used == blockSize:\n     \
    \       arena.blocks.add(newSeq[PersistentSegmentTreeNodeData[T]](blockSize))\n\
    \            arena.used = 0\n        result = addr arena.blocks[^1][arena.used]\n\
    \        inc arena.used\n        result.value = value\n        result.left = left\n\
    \        result.right = right\n\n    proc rootOwner[T](owner: PersistentSegmentTreeOwner[T]):\
    \ PersistentSegmentTreeOwner[T] =\n        ## \u9818\u57DF\u306E\u6240\u6709\u8005\
    \u3092\u53D6\u5F97\u3057\u3001\u7D4C\u8DEF\u3092\u5727\u7E2E\u3057\u307E\u3059\
    \u3002\u72EC\u7ACB\u3057\u305F\u6728\u306E\u6570\u3092K\u3068\u3057\u3066\u511F\
    \u5374O(alpha(K))\u3002\n        result = owner\n        while result.parent !=\
    \ nil: result = result.parent\n        var current = owner\n        while current.parent\
    \ != nil:\n            let next = current.parent\n            current.parent =\
    \ result\n            current = next\n\n    proc shareOwners[T](a, b: PersistentSegmentTreeOwner[T])\
    \ =\n        ## \u5C0F\u3055\u3044\u5074\u306E\u9818\u57DF\u3092\u79FB\u3057\u3001\
    \u5FAA\u74B0\u3084\u9577\u3044\u89E3\u653E\u30C1\u30A7\u30FC\u30F3\u3092\u4F5C\
    \u3089\u305A\u5171\u6709\u3057\u307E\u3059\u3002\n        if a == b: return\n\
    \        var left = rootOwner(a)\n        var right = rootOwner(b)\n        if\
    \ left == right: return\n        if left.arenas.len < right.arenas.len: swap(left,\
    \ right)\n        for arena in right.arenas: left.arenas.add(arena)\n        right.arenas.setLen(0)\n\
    \        right.parent = left\n\n    proc withRoot[T](self: PSegmentTree[T], root:\
    \ PersistentSegmentTreeNode[T]): PSegmentTree[T] =\n        ## \u6307\u5B9A\u3057\
    \u305F\u6839\u3092\u5171\u6709\u3059\u308B\u7248\u3092O(1)\u3067\u751F\u6210\u3057\
    \u307E\u3059\u3002\n        PSegmentTree[T](owner: self.owner, root: root, lastnode:\
    \ self.lastnode,\n                       length: self.length, op: self.op, e:\
    \ self.e)\n\n    proc initPersistentSegmentTree*[T](v: openArray[T], merge: proc(l,\
    \ r: T): T,\n                                       default: T): PSegmentTree[T]\
    \ =\n        ## v\u304B\u3089\u6C38\u7D9A\u30BB\u30B0\u6728\u3092O(N)\u3067\u69CB\
    \u7BC9\u3057\u307E\u3059\u3002merge\u306F\u7D50\u5408\u7684\u3067\u3001default\u306F\
    \u5358\u4F4D\u5143\u3067\u3059\u3002\n        ## \u5404\u6F14\u7B97\u306FO(1)\u3068\
    \u3057\u3001\u5F15\u6570\u3084\u5171\u6709\u3059\u308B\u53C2\u7167\u5148\u3092\
    \u5909\u66F4\u3057\u306A\u3044\u3067\u304F\u3060\u3055\u3044\u3002\n        ##\
    \ \u5171\u6709\u30FB\u7D71\u5408\u3057\u305F\u30CE\u30FC\u30C9\u9818\u57DF\u306F\
    \u3001\u305D\u308C\u3092\u6240\u6709\u3059\u308B\u3059\u3079\u3066\u306E\u7248\
    \u306E\u7834\u68C4\u6642\u306B\u89E3\u653E\u3057\u307E\u3059\u3002\n        ##\
    \ \u500B\u5225\u306E\u53E4\u3044\u7248\u3092\u7834\u68C4\u3057\u3066\u3082\u3001\
    \u305D\u306E\u9818\u57DF\u306E\u30CE\u30FC\u30C9\u306F\u56DE\u53CE\u3057\u307E\
    \u305B\u3093\u3002\n        let values = @v\n        let arena = PersistentSegmentTreeArena[T]()\n\
    \        let owner = PersistentSegmentTreeOwner[T](arena: arena, arenas: @[arena])\n\
    \        var size = 1\n        while size < v.len: size *= 2\n        proc build(l,\
    \ r: int): PersistentSegmentTreeNode[T] =\n            ## \u533A\u9593[l,r)\u306E\
    \u90E8\u5206\u6728\u3092O(r-l)\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\n   \
    \         if r - l == 1:\n                return arena.newNode(if l < values.len:\
    \ values[l] else: default)\n            let mid = (l + r) shr 1\n            let\
    \ left = build(l, mid)\n            let right = build(mid, r)\n            arena.newNode(merge(left.value,\
    \ right.value), left, right)\n        PSegmentTree[T](owner: owner, root: build(0,\
    \ size), lastnode: size, length: v.len, op: merge, e: default)\n\n    proc initPersistentSegmentTree*[T](n:\
    \ int, merge: proc(l, r: T): T,\n                                       default:\
    \ T): PSegmentTree[T] =\n        ## \u5168\u8981\u7D20\u3092\u5358\u4F4D\u5143\
    \u3068\u3059\u308B\u9577\u3055n\u306E\u6C38\u7D9A\u30BB\u30B0\u6728\u3092O(N)\u3067\
    \u69CB\u7BC9\u3057\u307E\u3059\u3002\n        assert n >= 0, \"\u9577\u3055\u306F\
    \u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       var values = newSeq[T](n)\n        for value in values.mitems: value =\
    \ default\n        initPersistentSegmentTree(values, merge, default)\n\n    proc\
    \ initSegmentTree*[T](v: openArray[T], op: proc(l, r: T): T, e: T): PSegmentTree[T]\
    \ =\n        ## \u5F93\u6765\u306E\u540D\u524D\u3067\u6C38\u7D9A\u30BB\u30B0\u6728\
    \u3092O(N)\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        initPersistentSegmentTree(v,\
    \ op, e)\n\n    proc initSegmentTree*[T](n: int, op: proc(l, r: T): T, e: T):\
    \ PSegmentTree[T] =\n        ## \u5168\u8981\u7D20\u3092\u5358\u4F4D\u5143\u3068\
    \u3059\u308B\u6C38\u7D9A\u30BB\u30B0\u6728\u3092O(N)\u3067\u69CB\u7BC9\u3057\u307E\
    \u3059\u3002\n        initPersistentSegmentTree(n, op, e)\n\n    proc update*[T](st:\
    \ PSegmentTree[T], idx: int, value: T): PSegmentTree[T] =\n        ## idx\u3092\
    value\u306B\u7F6E\u304D\u63DB\u3048\u305F\u65B0\u3057\u3044\u7248\u3092\u3001\u6642\
    \u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\
    \n        assert 0 <= idx and idx < st.length, \"\u6DFB\u5B57\u304C\u7BC4\u56F2\
    \u5916\u3067\u3059\"\n        proc dfs(node: PersistentSegmentTreeNode[T], l,\
    \ r: int): PersistentSegmentTreeNode[T] =\n            ## \u66F4\u65B0\u7D4C\u8DEF\
    \u306E\u307F\u3092\u8907\u88FD\u3057\u307E\u3059\u3002O(log N)\u3002\n       \
    \     if r - l == 1: return st.owner.arena.newNode(value)\n            let mid\
    \ = (l + r) shr 1\n            var left = node.left\n            var right = node.right\n\
    \            if idx < mid: left = dfs(left, l, mid)\n            else: right =\
    \ dfs(right, mid, r)\n            st.owner.arena.newNode(st.op(left.value, right.value),\
    \ left, right)\n        st.withRoot(dfs(st.root, 0, st.lastnode))\n\n    proc\
    \ copy_range*[T](self, source: PSegmentTree[T], q_left, q_right: int): PSegmentTree[T]\
    \ =\n        ## \u534A\u958B\u533A\u9593[q_left,q_right)\u3092source\u306E\u540C\
    \u3058\u533A\u9593\u3067\u7F6E\u304D\u63DB\u3048\u307E\u3059\u3002\u6728\u306E\
    \u64CD\u4F5C\u306F\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(log N)\u3002\n \
    \       ## \u4E21\u65B9\u306E\u6728\u306F\u540C\u3058\u9577\u3055\u30FB\u6F14\u7B97\
    \u30FB\u5358\u4F4D\u5143\u3067\u69CB\u7BC9\u3057\u3066\u304F\u3060\u3055\u3044\
    \u3002\u5143\u306E\u7248\u306F\u5909\u66F4\u3057\u307E\u305B\u3093\u3002\n   \
    \     ## \u72EC\u7ACB\u306B\u69CB\u7BC9\u3057\u305F\u6728\u306E\u90E8\u5206\u30B3\
    \u30D4\u30FC\u3067\u306F\u9818\u57DF\u306E\u6240\u6709\u6A29\u3082\u7D71\u5408\
    \u3057\u307E\u3059\u3002\n        ## K\u500B\u306E\u72EC\u7ACB\u3057\u305F\u6728\
    \u306E\u7D71\u5408\u306B\u4F34\u3046\u9818\u57DF\u53C2\u7167\u306E\u79FB\u52D5\
    \u306F\u5168\u64CD\u4F5C\u3067O(K log K)\u3002\n        assert self.length ==\
    \ source.length, \"\u6728\u306E\u9577\u3055\u304C\u7570\u306A\u308A\u307E\u3059\
    \"\n        assert 0 <= q_left and q_left <= q_right and q_right <= self.length,\
    \ \"\u533A\u9593\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        if q_left == q_right\
    \ or self.root == source.root: return self\n        if q_left == 0 and q_right\
    \ == self.length:\n            result = self.withRoot(source.root)\n         \
    \   result.owner = source.owner\n            return\n        proc dfs(dest, src:\
    \ PersistentSegmentTreeNode[T], l, r: int): PersistentSegmentTreeNode[T] =\n \
    \           ## \u5883\u754C\u4E0A\u306E\u30CE\u30FC\u30C9\u306E\u307F\u8907\u88FD\
    \u3057\u3001\u5B8C\u5168\u306B\u542B\u307E\u308C\u308B\u90E8\u5206\u6728\u3092\
    \u5171\u6709\u3057\u307E\u3059\u3002\u5168\u4F53\u3067O(log N)\u3002\n       \
    \     if dest == src or q_right <= l or r <= q_left: return dest\n           \
    \ if q_left <= l and r <= q_right: return src\n            let mid = (l + r) shr\
    \ 1\n            let left = dfs(dest.left, src.left, l, mid)\n            let\
    \ right = dfs(dest.right, src.right, mid, r)\n            if left == dest.left\
    \ and right == dest.right: return dest\n            return self.owner.arena.newNode(self.op(left.value,\
    \ right.value), left, right)\n        result = self.withRoot(dfs(self.root, source.root,\
    \ 0, self.lastnode))\n        shareOwners(self.owner, source.owner)\n\n    proc\
    \ copy_range*[T](self, source: PSegmentTree[T], segment: HSlice[int, int]): PSegmentTree[T]\
    \ =\n        ## \u30B9\u30E9\u30A4\u30B9\u3092source\u306E\u540C\u3058\u533A\u9593\
    \u3067\u7F6E\u304D\u63DB\u3048\u305F\u65B0\u3057\u3044\u7248\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\n        self.copy_range(source, segment.a, segment.b + 1)\n\
    \n    proc get*[T](self: PSegmentTree[T], q_left, q_right: int): T =\n       \
    \ ## \u534A\u958B\u533A\u9593[q_left,q_right)\u306E\u7A4D\u3092O(log N)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\n        assert 0 <= q_left and q_left <= q_right and\
    \ q_right <= self.length, \"\u533A\u9593\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\
    \n        if q_left == q_right: return self.e\n        proc dfs(node: PersistentSegmentTreeNode[T],\
    \ l, r: int): T =\n            ## \u6307\u5B9A\u533A\u9593\u3068\u306E\u5171\u901A\
    \u90E8\u5206\u306E\u7A4D\u3092\u53D6\u5F97\u3057\u307E\u3059\u3002\u5168\u4F53\
    \u3067O(log N)\u3002\n            if q_left <= l and r <= q_right: return node.value\n\
    \            let mid = (l + r) shr 1\n            if q_right <= mid: return dfs(node.left,\
    \ l, mid)\n            if mid <= q_left: return dfs(node.right, mid, r)\n    \
    \        self.op(dfs(node.left, l, mid), dfs(node.right, mid, r))\n        dfs(self.root,\
    \ 0, self.lastnode)\n\n    proc query*[T](st: PSegmentTree[T], l, r: int): T =\n\
    \        ## \u5F93\u6765\u306E\u540D\u524D\u3067\u534A\u958B\u533A\u9593[l,r)\u306E\
    \u7A4D\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        st.get(l, r)\n\
    \n    proc get*[T](self: PSegmentTree[T], segment: HSlice[int, int]): T =\n  \
    \      ## \u30B9\u30E9\u30A4\u30B9\u306E\u533A\u9593\u7A4D\u3092O(log N)\u3067\
    \u8FD4\u3057\u307E\u3059\u3002\n        self.get(segment.a, segment.b + 1)\n\n\
    \    proc `[]`*[T](self: PSegmentTree[T], segment: HSlice[int, int]): T =\n  \
    \      ## \u30B9\u30E9\u30A4\u30B9\u306E\u533A\u9593\u7A4D\u3092O(log N)\u3067\
    \u8FD4\u3057\u307E\u3059\u3002\n        self.get(segment)\n\n    proc len*[T](self:\
    \ PSegmentTree[T]): int =\n        ## \u8981\u7D20\u6570\u3092O(1)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\n        self.length\n\n    proc `[]`*[T](self: PSegmentTree[T],\
    \ index: Natural): T {.backwardsIndex.} =\n        ## index\u306E\u8981\u7D20\u3092\
    O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        assert index < self.length,\
    \ \"\u6DFB\u5B57\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        var node = self.root\n\
    \        var l = 0\n        var r = self.lastnode\n        while r - l > 1:\n\
    \            let mid = (l + r) shr 1\n            if index < mid:\n          \
    \      node = node.left\n                r = mid\n            else:\n        \
    \        node = node.right\n                l = mid\n        node.value\n\n  \
    \  proc `[]=`*[T](self: var PSegmentTree[T], index: Natural, val: T) {.backwardsIndex.}\
    \ =\n        ## \u5909\u6570\u3092\u66F4\u65B0\u5F8C\u306E\u7248\u3078O(log N)\u3067\
    \u5DEE\u3057\u66FF\u3048\u307E\u3059\u3002\u4ED6\u306E\u5909\u6570\u306B\u4FDD\
    \u5B58\u3057\u305F\u7248\u306F\u5909\u5316\u3057\u307E\u305B\u3093\u3002\n   \
    \     self = self.update(index, val)\n\n    proc get_all*[T](self: PSegmentTree[T]):\
    \ T =\n        ## \u5168\u8981\u7D20\u306E\u7A4D\u3092O(1)\u3067\u8FD4\u3057\u307E\
    \u3059\u3002\u7A7A\u306E\u5834\u5408\u306F\u5358\u4F4D\u5143\u3067\u3059\u3002\
    \n        self.root.value\n\n    proc `$`*[T](self: PSegmentTree[T]): string =\n\
    \        ## \u8981\u7D20\u3092\u7A7A\u767D\u533A\u5207\u308A\u3067\u6587\u5B57\
    \u5217\u5316\u3057\u307E\u3059\u3002O(N + \u51FA\u529B\u9577)\u3002\n        var\
    \ values: seq[string]\n        proc visit(node: PersistentSegmentTreeNode[T],\
    \ l, r: int) =\n            ## \u8449\u3092\u6DFB\u5B57\u9806\u306B\u5217\u6319\
    \u3057\u307E\u3059\u3002\u5168\u4F53\u3067O(N)\u3002\n            if l >= self.length:\
    \ return\n            if r - l == 1:\n                values.add($node.value)\n\
    \                return\n            let mid = (l + r) shr 1\n            visit(node.left,\
    \ l, mid)\n            visit(node.right, mid, r)\n        visit(self.root, 0,\
    \ self.lastnode)\n        values.join(\" \")\n\n    template newPersistentSegWith*(V,\
    \ merge, default: untyped): untyped =\n        ## l\u3068r\u3092\u7528\u3044\u305F\
    \u5F0F\u3092\u6F14\u7B97\u3068\u3057\u3066\u6C38\u7D9A\u30BB\u30B0\u6728\u3092\
    O(N)\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        initPersistentSegmentTree[typeof(default)](V,\n\
    \            proc(l {.inject.}, r {.inject.}: typeof(default)): typeof(default)\
    \ = merge, default)\n\n    template newSegWith*(V, merge, default: untyped): untyped\
    \ =\n        ## \u901A\u5E38\u306E\u30BB\u30B0\u6728\u3068\u540C\u3058\u540D\u524D\
    \u306E\u69CB\u7BC9\u30C6\u30F3\u30D7\u30EC\u30FC\u30C8\u3067\u3059\u3002O(N)\u3002\
    \n        newPersistentSegWith(V, merge, default)\n\n    proc max_right*[T](self:\
    \ PSegmentTree[T], l: int, f: proc(l: T): bool): int =\n        ## f(get(l,r))\u3092\
    \u6E80\u305F\u3059\u6700\u5927\u306Er\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\
    \u3002\n        ## f\u306F\u533A\u9593\u306E\u62E1\u5927\u306B\u5BFE\u3057\u3066\
    \u5358\u8ABF\u3067\u3001\u5358\u4F4D\u5143\u306B\u5BFE\u3057\u3066true\u3092\u8FD4\
    \u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n        assert 0 <= l\
    \ and l <= self.length, \"\u6DFB\u5B57\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n\
    \        assert f(self.e), \"\u5224\u5B9A\u95A2\u6570\u306F\u5358\u4F4D\u5143\u306B\
    \u5BFE\u3057\u3066true\u3092\u8FD4\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \"\n        var sm = self.e\n        proc dfs(node: PersistentSegmentTreeNode[T],\
    \ nl, nr: int): int =\n            ## \u5DE6\u304B\u3089\u533A\u9593\u7A4D\u3092\
    \u4F38\u3070\u3057\u3001\u6700\u521D\u306B\u6761\u4EF6\u3092\u6E80\u305F\u3055\
    \u306A\u304F\u306A\u308B\u5883\u754C\u3092\u63A2\u3057\u307E\u3059\u3002\n   \
    \         if nr <= l or self.length <= nl: return self.length\n            if\
    \ l <= nl and nr <= self.length:\n                let value = self.op(sm, node.value)\n\
    \                if f(value):\n                    sm = value\n              \
    \      return self.length\n                if nr - nl == 1: return nl\n      \
    \      let mid = (nl + nr) shr 1\n            let boundary = dfs(node.left, nl,\
    \ mid)\n            if boundary != self.length: return boundary\n            dfs(node.right,\
    \ mid, nr)\n        dfs(self.root, 0, self.lastnode)\n\n    proc min_left*[T](self:\
    \ PSegmentTree[T], r: int, f: proc(l: T): bool): int =\n        ## f(get(l,r))\u3092\
    \u6E80\u305F\u3059\u6700\u5C0F\u306El\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\
    \u3002\n        ## f\u306F\u533A\u9593\u306E\u62E1\u5927\u306B\u5BFE\u3057\u3066\
    \u5358\u8ABF\u3067\u3001\u5358\u4F4D\u5143\u306B\u5BFE\u3057\u3066true\u3092\u8FD4\
    \u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n        assert 0 <= r\
    \ and r <= self.length, \"\u6DFB\u5B57\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n\
    \        assert f(self.e), \"\u5224\u5B9A\u95A2\u6570\u306F\u5358\u4F4D\u5143\u306B\
    \u5BFE\u3057\u3066true\u3092\u8FD4\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \"\n        var sm = self.e\n        proc dfs(node: PersistentSegmentTreeNode[T],\
    \ nl, nr: int): int =\n            ## \u53F3\u304B\u3089\u533A\u9593\u7A4D\u3092\
    \u4F38\u3070\u3057\u3001\u6700\u521D\u306B\u6761\u4EF6\u3092\u6E80\u305F\u3055\
    \u306A\u304F\u306A\u308B\u5883\u754C\u3092\u63A2\u3057\u307E\u3059\u3002\n   \
    \         if r <= nl: return 0\n            if nr <= r:\n                let value\
    \ = self.op(node.value, sm)\n                if f(value):\n                  \
    \  sm = value\n                    return 0\n                if nr - nl == 1:\
    \ return nr\n            let mid = (nl + nr) shr 1\n            let boundary =\
    \ dfs(node.right, mid, nr)\n            if boundary != 0: return boundary\n  \
    \          dfs(node.left, nl, mid)\n        dfs(self.root, 0, self.lastnode)\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: false
  path: cplib/collections/persistent_segtree.nim
  requiredBy: []
  timestamp: '2026-09-28 04:00:38+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/persistent_segtree_test.nim
  - verify/AI/persistent_segtree_test.nim
documentation_of: cplib/collections/persistent_segtree.nim
layout: document
redirect_from:
- /library/cplib/collections/persistent_segtree.nim
- /library/cplib/collections/persistent_segtree.nim.html
title: cplib/collections/persistent_segtree.nim
---
