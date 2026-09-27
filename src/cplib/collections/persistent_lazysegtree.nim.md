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
    path: verify/AI/persistent_lazysegtree_test.nim
    title: verify/AI/persistent_lazysegtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/persistent_lazysegtree_test.nim
    title: verify/AI/persistent_lazysegtree_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_PERSISTENT_LAZYSEGTREE:\n    const CPLIB_COLLECTIONS_PERSISTENT_LAZYSEGTREE*\
    \ = 1\n    import cplib/utils/backwards_index\n    import strutils\n\n    type\n\
    \        PersistentLazySegmentTreeNode[S, F] = ptr PersistentLazySegmentTreeNodeData[S,\
    \ F]\n        PersistentLazySegmentTreeNodeData[S, F] = object\n            value:\
    \ S\n            lazy: F\n            pending: bool\n            left, right:\
    \ PersistentLazySegmentTreeNode[S, F]\n        PersistentLazySegmentTreeArena[S,\
    \ F] = ref object\n            blocks: seq[seq[PersistentLazySegmentTreeNodeData[S,\
    \ F]]]\n            used: int\n        PersistentLazySegmentTreeOwner[S, F] =\
    \ ref object\n            arena: PersistentLazySegmentTreeArena[S, F]\n      \
    \      parent: PersistentLazySegmentTreeOwner[S, F]\n            arenas: seq[PersistentLazySegmentTreeArena[S,\
    \ F]]\n        PersistentLazySegmentTree*[S, F] = ref object\n            owner:\
    \ PersistentLazySegmentTreeOwner[S, F]\n            root: PersistentLazySegmentTreeNode[S,\
    \ F]\n            lastnode, length: int\n            merge: proc(l, r: S): S\n\
    \            default: S\n            mapping: proc(f: F, x: S): S\n          \
    \  composition: proc(f, g: F): F\n            id: F\n        PLazySegmentTree*[S,\
    \ F] = PersistentLazySegmentTree[S, F]\n\n    proc newNode[S, F](arena: PersistentLazySegmentTreeArena[S,\
    \ F], value: S,\n            lazy: F, left: PersistentLazySegmentTreeNode[S, F]\
    \ = nil,\n            right: PersistentLazySegmentTreeNode[S, F] = nil): PersistentLazySegmentTreeNode[S,\
    \ F] {.inline.} =\n        ## \u30CE\u30FC\u30C9\u3092\u307E\u3068\u3081\u3066\
    \u78BA\u4FDD\u3057\u3001\u53C2\u7167\u306E\u79FB\u52D5\u3057\u306A\u3044\u9818\
    \u57DF\u306B\u683C\u7D0D\u3057\u307E\u3059\u3002\u511F\u5374O(1)\u3002\n     \
    \   const blockSize = 1024\n        if arena.blocks.len == 0 or arena.used ==\
    \ blockSize:\n            arena.blocks.add(newSeq[PersistentLazySegmentTreeNodeData[S,\
    \ F]](blockSize))\n            arena.used = 0\n        result = addr arena.blocks[^1][arena.used]\n\
    \        inc arena.used\n        result.value = value\n        result.lazy = lazy\n\
    \        result.left = left\n        result.right = right\n\n    proc rootOwner[S,\
    \ F](owner: PersistentLazySegmentTreeOwner[S, F]): PersistentLazySegmentTreeOwner[S,\
    \ F] =\n        ## \u9818\u57DF\u306E\u6240\u6709\u8005\u3092\u53D6\u5F97\u3057\
    \u3001\u7D4C\u8DEF\u3092\u5727\u7E2E\u3057\u307E\u3059\u3002\u72EC\u7ACB\u3057\
    \u305F\u6728\u306E\u6570\u3092K\u3068\u3057\u3066\u511F\u5374O(alpha(K))\u3002\
    \n        result = owner\n        while result.parent != nil: result = result.parent\n\
    \        var current = owner\n        while current.parent != nil:\n         \
    \   let next = current.parent\n            current.parent = result\n         \
    \   current = next\n\n    proc shareOwners[S, F](a, b: PersistentLazySegmentTreeOwner[S,\
    \ F]) =\n        ## \u5C0F\u3055\u3044\u5074\u306E\u9818\u57DF\u3092\u79FB\u3057\
    \u3001\u5FAA\u74B0\u3084\u9577\u3044\u89E3\u653E\u30C1\u30A7\u30FC\u30F3\u3092\
    \u4F5C\u3089\u305A\u5171\u6709\u3057\u307E\u3059\u3002\n        if a == b: return\n\
    \        var left = rootOwner(a)\n        var right = rootOwner(b)\n        if\
    \ left == right: return\n        if left.arenas.len < right.arenas.len: swap(left,\
    \ right)\n        for arena in right.arenas: left.arenas.add(arena)\n        right.arenas.setLen(0)\n\
    \        right.parent = left\n\n    proc initPersistentLazySegmentTree*[S, F](v:\
    \ openArray[S], merge: proc(l, r: S): S,\n            default: S, mapping: proc(f:\
    \ F, x: S): S,\n            composition: proc(f, g: F): F, id: F): PersistentLazySegmentTree[S,\
    \ F] =\n        ## v\u304B\u3089\u6C38\u7D9A\u9045\u5EF6\u30BB\u30B0\u6728\u3092\
    O(N)\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002composition(f,g)\u306Fg\u306E\u5F8C\
    \u306Bf\u3092\u4F5C\u7528\u3055\u305B\u307E\u3059\u3002\n        ## merge\u306F\
    \u7D50\u5408\u7684\u3067default\u306F\u5358\u4F4D\u5143\u3001mapping\u306Fmerge\u3068\
    \u4E21\u7ACB\u3057\u3001id\u306F\u6052\u7B49\u4F5C\u7528\u3068\u3057\u307E\u3059\
    \u3002\n        ## \u5404\u6F14\u7B97\u306FO(1)\u3068\u3057\u3001\u5F15\u6570\u3084\
    \u5171\u6709\u3059\u308B\u53C2\u7167\u5148\u3092\u5909\u66F4\u3057\u306A\u3044\
    \u3067\u304F\u3060\u3055\u3044\u3002\n        ## \u5171\u6709\u30FB\u7D71\u5408\
    \u3057\u305F\u30CE\u30FC\u30C9\u9818\u57DF\u306F\u3001\u305D\u308C\u3092\u6240\
    \u6709\u3059\u308B\u3059\u3079\u3066\u306E\u7248\u306E\u7834\u68C4\u6642\u306B\
    \u89E3\u653E\u3057\u307E\u3059\u3002\n        ## \u500B\u5225\u306E\u53E4\u3044\
    \u7248\u3092\u7834\u68C4\u3057\u3066\u3082\u3001\u305D\u306E\u9818\u57DF\u306E\
    \u30CE\u30FC\u30C9\u306F\u56DE\u53CE\u3057\u307E\u305B\u3093\u3002\n        let\
    \ values = @v\n        let arena = PersistentLazySegmentTreeArena[S, F]()\n  \
    \      let owner = PersistentLazySegmentTreeOwner[S, F](arena: arena, arenas:\
    \ @[arena])\n        var size = 1\n        while size < v.len: size *= 2\n   \
    \     proc build(l, r: int): PersistentLazySegmentTreeNode[S, F] =\n         \
    \   ## \u533A\u9593[l,r)\u306E\u90E8\u5206\u6728\u3092O(r-l)\u3067\u69CB\u7BC9\
    \u3057\u307E\u3059\u3002\n            if r - l == 1:\n                return arena.newNode((if\
    \ l < values.len: values[l] else: default), id)\n            let mid = (l + r)\
    \ shr 1\n            let left = build(l, mid)\n            let right = build(mid,\
    \ r)\n            arena.newNode(merge(left.value, right.value), id, left, right)\n\
    \        PersistentLazySegmentTree[S, F](owner: owner, root: build(0, size), lastnode:\
    \ size, length: v.len,\n            merge: merge, default: default, mapping: mapping,\
    \ composition: composition, id: id)\n\n    proc initPersistentLazySegmentTree*[S,\
    \ F](n: int, merge: proc(l, r: S): S,\n            default: S, mapping: proc(f:\
    \ F, x: S): S,\n            composition: proc(f, g: F): F, id: F): PersistentLazySegmentTree[S,\
    \ F] =\n        ## \u5168\u8981\u7D20\u3092\u5358\u4F4D\u5143\u3068\u3059\u308B\
    \u9577\u3055n\u306E\u6C38\u7D9A\u9045\u5EF6\u30BB\u30B0\u6728\u3092O(N)\u3067\u69CB\
    \u7BC9\u3057\u307E\u3059\u3002\n        assert n >= 0, \"\u9577\u3055\u306F\u975E\
    \u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n       \
    \ var values = newSeq[S](n)\n        for value in values.mitems: value = default\n\
    \        initPersistentLazySegmentTree(values, merge, default, mapping, composition,\
    \ id)\n\n    proc initLazySegmentTree*[S, F](v: openArray[S], merge: proc(l, r:\
    \ S): S,\n            default: S, mapping: proc(f: F, x: S): S,\n            composition:\
    \ proc(f, g: F): F, id: F): PersistentLazySegmentTree[S, F] =\n        ## \u901A\
    \u5E38\u306E\u9045\u5EF6\u30BB\u30B0\u6728\u3068\u540C\u3058\u540D\u524D\u3067\
    \u6C38\u7D9A\u7248\u3092O(N)\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\n     \
    \   initPersistentLazySegmentTree(v, merge, default, mapping, composition, id)\n\
    \n    proc initLazySegmentTree*[S, F](n: int, merge: proc(l, r: S): S,\n     \
    \       default: S, mapping: proc(f: F, x: S): S,\n            composition: proc(f,\
    \ g: F): F, id: F): PersistentLazySegmentTree[S, F] =\n        ## \u5168\u8981\
    \u7D20\u3092\u5358\u4F4D\u5143\u3068\u3059\u308B\u6C38\u7D9A\u9045\u5EF6\u30BB\
    \u30B0\u6728\u3092O(N)\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        initPersistentLazySegmentTree(n,\
    \ merge, default, mapping, composition, id)\n\n    proc withRoot[S, F](self: PersistentLazySegmentTree[S,\
    \ F],\n            root: PersistentLazySegmentTreeNode[S, F]): PersistentLazySegmentTree[S,\
    \ F] =\n        ## \u6307\u5B9A\u3057\u305F\u6839\u3092\u6301\u3064\u7248\u3092\
    O(1)\u3067\u751F\u6210\u3057\u307E\u3059\u3002\n        PersistentLazySegmentTree[S,\
    \ F](owner: self.owner, root: root, lastnode: self.lastnode, length: self.length,\n\
    \            merge: self.merge, default: self.default, mapping: self.mapping,\n\
    \            composition: self.composition, id: self.id)\n\n    proc applied[S,\
    \ F](self: PersistentLazySegmentTree[S, F],\n            node: PersistentLazySegmentTreeNode[S,\
    \ F], f: F): PersistentLazySegmentTreeNode[S, F] =\n        ## \u30CE\u30FC\u30C9\
    \u3092\u8907\u88FD\u3057\u3066\u4F5C\u7528\u3092\u9069\u7528\u3057\u307E\u3059\
    \u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(1)\u3002\n        result = self.owner.arena.newNode(self.mapping(f,\
    \ node.value), self.id, node.left, node.right)\n        if node.left != nil:\n\
    \            result.lazy = if node.pending: self.composition(f, node.lazy) else:\
    \ f\n            result.pending = true\n\n    proc carried[S, F](self: PersistentLazySegmentTree[S,\
    \ F],\n            node: PersistentLazySegmentTreeNode[S, F], carry: F,\n    \
    \        pending: bool): PersistentLazySegmentTreeNode[S, F] {.inline.} =\n  \
    \      ## \u7956\u5148\u306E\u4F5C\u7528\u304C\u3042\u308B\u5834\u5408\u3060\u3051\
    \u30CE\u30FC\u30C9\u3092\u8907\u88FD\u3057\u307E\u3059\u3002O(1)\u3002\n     \
    \   if pending: self.applied(node, carry)\n        else: node\n\n    proc descend[S,\
    \ F](self: PersistentLazySegmentTree[S, F],\n            node: PersistentLazySegmentTreeNode[S,\
    \ F], carry: F,\n            pending: bool): tuple[value: F, pending: bool] {.inline.}\
    \ =\n        ## \u7956\u5148\u3068\u73FE\u5728\u306E\u30CE\u30FC\u30C9\u306E\u9045\
    \u5EF6\u4F5C\u7528\u3092\u5408\u6210\u3057\u307E\u3059\u3002O(1)\u3002\n     \
    \   if not node.pending: (carry, pending)\n        elif not pending: (node.lazy,\
    \ true)\n        else: (self.composition(carry, node.lazy), true)\n\n    proc\
    \ update*[S, F](self: PersistentLazySegmentTree[S, F], p: Natural,\n         \
    \               val: S): PersistentLazySegmentTree[S, F] =\n        ## p\u3092\
    val\u306B\u7F6E\u304D\u63DB\u3048\u305F\u65B0\u3057\u3044\u7248\u3092\u3001\u6642\
    \u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\
    \n        assert p < self.length, \"\u6DFB\u5B57\u304C\u7BC4\u56F2\u5916\u3067\
    \u3059\"\n        proc dfs(node: PersistentLazySegmentTreeNode[S, F], l, r: int,\n\
    \                 carry: F, pending: bool): PersistentLazySegmentTreeNode[S, F]\
    \ =\n            ## \u9045\u5EF6\u4F5C\u7528\u3092\u5F15\u6570\u3067\u6E21\u3057\
    \u3001\u7D50\u679C\u306B\u5FC5\u8981\u306A\u30CE\u30FC\u30C9\u306E\u307F\u8907\
    \u88FD\u3057\u307E\u3059\u3002O(log N)\u3002\n            if r - l == 1: return\
    \ self.owner.arena.newNode(val, self.id)\n            let mid = (l + r) shr 1\n\
    \            let next = self.descend(node, carry, pending)\n            var left,\
    \ right: PersistentLazySegmentTreeNode[S, F]\n            if p < mid:\n      \
    \          left = dfs(node.left, l, mid, next.value, next.pending)\n         \
    \       right = self.carried(node.right, next.value, next.pending)\n         \
    \   else:\n                left = self.carried(node.left, next.value, next.pending)\n\
    \                right = dfs(node.right, mid, r, next.value, next.pending)\n \
    \           self.owner.arena.newNode(self.merge(left.value, right.value), self.id,\
    \ left, right)\n        self.withRoot(dfs(self.root, 0, self.lastnode, self.id,\
    \ false))\n\n    proc apply*[S, F](self: PersistentLazySegmentTree[S, F], q_left,\
    \ q_right: int,\n                       f: F): PersistentLazySegmentTree[S, F]\
    \ =\n        ## \u534A\u958B\u533A\u9593[q_left,q_right)\u306Bf\u3092\u4F5C\u7528\
    \u3055\u305B\u305F\u65B0\u3057\u3044\u7248\u3092\u3001\u6642\u9593\u30FB\u8FFD\
    \u52A0\u9818\u57DFO(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        assert\
    \ 0 <= q_left and q_left <= q_right and q_right <= self.length, \"\u533A\u9593\
    \u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        if q_left == q_right: return self\n\
    \        proc dfs(node: PersistentLazySegmentTreeNode[S, F], l, r: int,\n    \
    \             carry: F, pending: bool): PersistentLazySegmentTreeNode[S, F] =\n\
    \            ## \u9014\u4E2D\u306E\u4F1D\u64AD\u7528\u30CE\u30FC\u30C9\u3092\u751F\
    \u6210\u305B\u305A\u3001\u66F4\u65B0\u7D50\u679C\u3092\u69CB\u7BC9\u3057\u307E\
    \u3059\u3002\u5168\u4F53\u3067O(log N)\u3002\n            if q_right <= l or r\
    \ <= q_left: return self.carried(node, carry, pending)\n            if q_left\
    \ <= l and r <= q_right:\n                return self.applied(node, if pending:\
    \ self.composition(f, carry) else: f)\n            let mid = (l + r) shr 1\n \
    \           let next = self.descend(node, carry, pending)\n            let left\
    \ = dfs(node.left, l, mid, next.value, next.pending)\n            let right =\
    \ dfs(node.right, mid, r, next.value, next.pending)\n            self.owner.arena.newNode(self.merge(left.value,\
    \ right.value), self.id, left, right)\n        self.withRoot(dfs(self.root, 0,\
    \ self.lastnode, self.id, false))\n\n    proc apply*[S, F](self: PersistentLazySegmentTree[S,\
    \ F], segment: HSlice[int, int],\n                       f: F): PersistentLazySegmentTree[S,\
    \ F] =\n        ## \u30B9\u30E9\u30A4\u30B9\u306Bf\u3092\u4F5C\u7528\u3055\u305B\
    \u305F\u65B0\u3057\u3044\u7248\u3092\u3001\u6642\u9593\u30FB\u8FFD\u52A0\u9818\
    \u57DFO(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.apply(segment.a,\
    \ segment.b + 1, f)\n\n    proc copy_range*[S, F](self, source: PersistentLazySegmentTree[S,\
    \ F],\n                            q_left, q_right: int): PersistentLazySegmentTree[S,\
    \ F] =\n        ## \u534A\u958B\u533A\u9593[q_left,q_right)\u3092source\u306E\u540C\
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
    \ \"\u533A\u9593\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        if q_left == q_right:\
    \ return self\n        if q_left == 0 and q_right == self.length:\n          \
    \  result = self.withRoot(source.root)\n            result.owner = source.owner\n\
    \            return\n        if self.root == source.root: return self\n      \
    \  proc dfs(dest, src: PersistentLazySegmentTreeNode[S, F],\n                \
    \ l, r: int, destCarry, srcCarry: F,\n                 destPending, srcPending:\
    \ bool): PersistentLazySegmentTreeNode[S, F] =\n            ## \u63A1\u7528\u3059\
    \u308B\u90E8\u5206\u6728\u3060\u3051\u306B\u9045\u5EF6\u4F5C\u7528\u3092\u53CD\
    \u6620\u3057\u307E\u3059\u3002\u5168\u4F53\u3067O(log N)\u3002\n            if\
    \ q_right <= l or r <= q_left: return self.carried(dest, destCarry, destPending)\n\
    \            if q_left <= l and r <= q_right: return source.carried(src, srcCarry,\
    \ srcPending)\n            let mid = (l + r) shr 1\n            let dc = self.descend(dest,\
    \ destCarry, destPending)\n            let sc = source.descend(src, srcCarry,\
    \ srcPending)\n            let left = dfs(dest.left, src.left, l, mid, dc.value,\
    \ sc.value, dc.pending, sc.pending)\n            let right = dfs(dest.right, src.right,\
    \ mid, r, dc.value, sc.value, dc.pending, sc.pending)\n            self.owner.arena.newNode(self.merge(left.value,\
    \ right.value), self.id, left, right)\n        result = self.withRoot(dfs(self.root,\
    \ source.root, 0, self.lastnode, self.id, source.id, false, false))\n        shareOwners(self.owner,\
    \ source.owner)\n\n    proc copy_range*[S, F](self, source: PersistentLazySegmentTree[S,\
    \ F],\n                            segment: HSlice[int, int]): PersistentLazySegmentTree[S,\
    \ F] =\n        ## \u30B9\u30E9\u30A4\u30B9\u3092source\u306E\u540C\u3058\u533A\
    \u9593\u3067\u7F6E\u304D\u63DB\u3048\u305F\u65B0\u3057\u3044\u7248\u3092\u3001\
    \u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(log N)\u3067\u8FD4\u3057\u307E\u3059\
    \u3002\n        self.copy_range(source, segment.a, segment.b + 1)\n\n    proc\
    \ get*[S, F](self: PersistentLazySegmentTree[S, F], q_left, q_right: int): S =\n\
    \        ## \u534A\u958B\u533A\u9593[q_left,q_right)\u306E\u7A4D\u3092O(log N)\u3067\
    \u8FD4\u3057\u307E\u3059\u3002\u30CE\u30FC\u30C9\u306F\u5909\u66F4\u30FB\u8907\
    \u88FD\u3057\u307E\u305B\u3093\u3002\n        assert 0 <= q_left and q_left <=\
    \ q_right and q_right <= self.length, \"\u533A\u9593\u304C\u7BC4\u56F2\u5916\u3067\
    \u3059\"\n        if q_left == q_right: return self.default\n        proc dfs(node:\
    \ PersistentLazySegmentTreeNode[S, F], l, r: int): S =\n            ## \u4EA4\u5DEE\
    \u3059\u308B\u5B50\u3060\u3051\u3092\u63A2\u7D22\u3057\u3001\u533A\u9593\u7A4D\
    \u306B\u9045\u5EF6\u4F5C\u7528\u3092\u4E00\u5EA6\u53CD\u6620\u3057\u307E\u3059\
    \u3002\u5168\u4F53\u3067O(log N)\u3002\n            if q_left <= l and r <= q_right:\
    \ return node.value\n            let mid = (l + r) shr 1\n            if q_right\
    \ <= mid: result = dfs(node.left, l, mid)\n            elif mid <= q_left: result\
    \ = dfs(node.right, mid, r)\n            else: result = self.merge(dfs(node.left,\
    \ l, mid), dfs(node.right, mid, r))\n            if node.pending: result = self.mapping(node.lazy,\
    \ result)\n        dfs(self.root, 0, self.lastnode)\n\n    proc query*[S, F](self:\
    \ PersistentLazySegmentTree[S, F], l, r: int): S =\n        ## \u534A\u958B\u533A\
    \u9593[l,r)\u306E\u7A4D\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n  \
    \      self.get(l, r)\n\n    proc get*[S, F](self: PersistentLazySegmentTree[S,\
    \ F], segment: HSlice[int, int]): S =\n        ## \u30B9\u30E9\u30A4\u30B9\u306E\
    \u533A\u9593\u7A4D\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n       \
    \ self.get(segment.a, segment.b + 1)\n\n    proc `[]`*[S, F](self: PersistentLazySegmentTree[S,\
    \ F], segment: HSlice[int, int]): S =\n        ## \u30B9\u30E9\u30A4\u30B9\u306E\
    \u533A\u9593\u7A4D\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n       \
    \ self.get(segment)\n\n    proc len*[S, F](self: PersistentLazySegmentTree[S,\
    \ F]): int =\n        ## \u8981\u7D20\u6570\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\
    \u3002\n        self.length\n\n    proc `[]`*[S, F](self: PersistentLazySegmentTree[S,\
    \ F], p: Natural): S {.backwardsIndex.} =\n        ## p\u306E\u8981\u7D20\u3092\
    O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        assert p < self.length,\
    \ \"\u6DFB\u5B57\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        self.get(p, p\
    \ + 1)\n\n    proc `[]=`*[S, F](self: var PersistentLazySegmentTree[S, F], p:\
    \ Natural, val: S) {.backwardsIndex.} =\n        ## \u5909\u6570\u3092\u66F4\u65B0\
    \u5F8C\u306E\u7248\u3078O(log N)\u3067\u5DEE\u3057\u66FF\u3048\u307E\u3059\u3002\
    \u4ED6\u306E\u5909\u6570\u306B\u4FDD\u5B58\u3057\u305F\u7248\u306F\u5909\u5316\
    \u3057\u307E\u305B\u3093\u3002\n        self = self.update(p, val)\n\n    proc\
    \ get_all*[S, F](self: PersistentLazySegmentTree[S, F]): S =\n        ## \u5168\
    \u8981\u7D20\u306E\u7A4D\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u306E\
    \u5834\u5408\u306F\u5358\u4F4D\u5143\u3067\u3059\u3002\n        self.root.value\n\
    \n    proc `$`*[S, F](self: PersistentLazySegmentTree[S, F]): string =\n     \
    \   ## \u8981\u7D20\u3092\u7A7A\u767D\u533A\u5207\u308A\u3067\u6587\u5B57\u5217\
    \u5316\u3057\u307E\u3059\u3002O(N + \u51FA\u529B\u9577)\u3002\n        var values:\
    \ seq[string]\n        proc visit(node: PersistentLazySegmentTreeNode[S, F], l,\
    \ r: int, carry: F) =\n            ## \u7956\u5148\u306E\u672A\u4F1D\u64AD\u4F5C\
    \u7528\u3092\u53CD\u6620\u3057\u3066\u8449\u3092\u5217\u6319\u3057\u307E\u3059\
    \u3002\u5168\u4F53\u3067O(N)\u3002\n            if l >= self.length: return\n\
    \            if r - l == 1:\n                values.add($self.mapping(carry, node.value))\n\
    \                return\n            let mid = (l + r) shr 1\n            let\
    \ next = self.composition(carry, node.lazy)\n            visit(node.left, l, mid,\
    \ next)\n            visit(node.right, mid, r, next)\n        visit(self.root,\
    \ 0, self.lastnode, self.id)\n        values.join(\" \")\n\n    template newPersistentLazySegWith*(v_or_n,\
    \ merge, default, mapping, composition, id: untyped): untyped =\n        ## l,r\u304A\
    \u3088\u3073f,x\u304A\u3088\u3073f,g\u306E\u5F0F\u3092\u5404\u6F14\u7B97\u3068\
    \u3057\u3066\u6C38\u7D9A\u9045\u5EF6\u30BB\u30B0\u6728\u3092O(N)\u3067\u69CB\u7BC9\
    \u3057\u307E\u3059\u3002\n        block:\n            type S = typeof(default)\n\
    \            type F = typeof(id)\n            initPersistentLazySegmentTree[S,\
    \ F](v_or_n,\n                proc(l {.inject.}, r {.inject.}: S): S = merge,\n\
    \                default, proc(f {.inject.}: F, x {.inject.}: S): S = mapping,\n\
    \                proc(f {.inject.}, g {.inject.}: F): F = composition, id)\n\n\
    \    template newLazySegWith*(v_or_n, merge, default, mapping, composition, id:\
    \ untyped): untyped =\n        ## \u901A\u5E38\u306E\u9045\u5EF6\u30BB\u30B0\u6728\
    \u3068\u540C\u3058\u540D\u524D\u306E\u69CB\u7BC9\u30C6\u30F3\u30D7\u30EC\u30FC\
    \u30C8\u3067\u3059\u3002O(N)\u3002\n        newPersistentLazySegWith(v_or_n, merge,\
    \ default, mapping, composition, id)\n\n    proc max_right*[S, F](self: PersistentLazySegmentTree[S,\
    \ F], l: int,\n                          f: proc(l: S): bool): int =\n       \
    \ ## f(get(l,r))\u3092\u6E80\u305F\u3059\u6700\u5927\u306Er\u3092O(log N)\u3067\
    \u8FD4\u3057\u307E\u3059\u3002\u30CE\u30FC\u30C9\u306F\u5909\u66F4\u30FB\u8907\
    \u88FD\u3057\u307E\u305B\u3093\u3002\n        ## f\u306F\u533A\u9593\u306E\u62E1\
    \u5927\u306B\u5BFE\u3057\u3066\u5358\u8ABF\u3067\u3001\u5358\u4F4D\u5143\u306B\
    \u5BFE\u3057\u3066true\u3092\u8FD4\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \u3002\n        assert 0 <= l and l <= self.length, \"\u6DFB\u5B57\u304C\u7BC4\
    \u56F2\u5916\u3067\u3059\"\n        assert f(self.default), \"\u5224\u5B9A\u95A2\
    \u6570\u306F\u5358\u4F4D\u5143\u306B\u5BFE\u3057\u3066true\u3092\u8FD4\u3059\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\"\n        var sm = self.default\n      \
    \  proc dfs(node: PersistentLazySegmentTreeNode[S, F], nl, nr: int, carry: F):\
    \ int =\n            ## \u7956\u5148\u306E\u4F5C\u7528\u3092\u53CD\u6620\u3057\
    \u3001\u5DE6\u304B\u3089\u6761\u4EF6\u3092\u6E80\u305F\u3059\u533A\u9593\u3092\
    \u4F38\u3070\u3057\u307E\u3059\u3002\n            if nr <= l or self.length <=\
    \ nl: return self.length\n            if l <= nl and nr <= self.length:\n    \
    \            let value = self.merge(sm, self.mapping(carry, node.value))\n   \
    \             if f(value):\n                    sm = value\n                 \
    \   return self.length\n                if nr - nl == 1: return nl\n         \
    \   let mid = (nl + nr) shr 1\n            let next = self.composition(carry,\
    \ node.lazy)\n            let boundary = dfs(node.left, nl, mid, next)\n     \
    \       if boundary != self.length: return boundary\n            dfs(node.right,\
    \ mid, nr, next)\n        dfs(self.root, 0, self.lastnode, self.id)\n\n    proc\
    \ min_left*[S, F](self: PersistentLazySegmentTree[S, F], r: int,\n           \
    \              f: proc(l: S): bool): int =\n        ## f(get(l,r))\u3092\u6E80\
    \u305F\u3059\u6700\u5C0F\u306El\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\
    \u30CE\u30FC\u30C9\u306F\u5909\u66F4\u30FB\u8907\u88FD\u3057\u307E\u305B\u3093\
    \u3002\n        ## f\u306F\u533A\u9593\u306E\u62E1\u5927\u306B\u5BFE\u3057\u3066\
    \u5358\u8ABF\u3067\u3001\u5358\u4F4D\u5143\u306B\u5BFE\u3057\u3066true\u3092\u8FD4\
    \u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n        assert 0 <= r\
    \ and r <= self.length, \"\u6DFB\u5B57\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n\
    \        assert f(self.default), \"\u5224\u5B9A\u95A2\u6570\u306F\u5358\u4F4D\u5143\
    \u306B\u5BFE\u3057\u3066true\u3092\u8FD4\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\"\n        var sm = self.default\n        proc dfs(node: PersistentLazySegmentTreeNode[S,\
    \ F], nl, nr: int, carry: F): int =\n            ## \u7956\u5148\u306E\u4F5C\u7528\
    \u3092\u53CD\u6620\u3057\u3001\u53F3\u304B\u3089\u6761\u4EF6\u3092\u6E80\u305F\
    \u3059\u533A\u9593\u3092\u4F38\u3070\u3057\u307E\u3059\u3002\n            if r\
    \ <= nl: return 0\n            if nr <= r:\n                let value = self.merge(self.mapping(carry,\
    \ node.value), sm)\n                if f(value):\n                    sm = value\n\
    \                    return 0\n                if nr - nl == 1: return nr\n  \
    \          let mid = (nl + nr) shr 1\n            let next = self.composition(carry,\
    \ node.lazy)\n            let boundary = dfs(node.right, mid, nr, next)\n    \
    \        if boundary != 0: return boundary\n            dfs(node.left, nl, mid,\
    \ next)\n        dfs(self.root, 0, self.lastnode, self.id)\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: false
  path: cplib/collections/persistent_lazysegtree.nim
  requiredBy: []
  timestamp: '2026-09-28 03:54:08+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/persistent_lazysegtree_test.nim
  - verify/AI/persistent_lazysegtree_test.nim
documentation_of: cplib/collections/persistent_lazysegtree.nim
layout: document
redirect_from:
- /library/cplib/collections/persistent_lazysegtree.nim
- /library/cplib/collections/persistent_lazysegtree.nim.html
title: cplib/collections/persistent_lazysegtree.nim
---
