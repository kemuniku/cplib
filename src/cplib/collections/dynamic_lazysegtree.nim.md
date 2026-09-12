---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/dynamic_lazysegtree_test.nim
    title: verify/AI/dynamic_lazysegtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dynamic_lazysegtree_test.nim
    title: verify/AI/dynamic_lazysegtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/lazysegtree/dynamic_rangeaffinerangesum_test.nim
    title: verify/collections/lazysegtree/dynamic_rangeaffinerangesum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/lazysegtree/dynamic_rangeaffinerangesum_test.nim
    title: verify/collections/lazysegtree/dynamic_rangeaffinerangesum_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_DYNAMIC_LAZYSEGTREE:\n    const CPLIB_COLLECTIONS_DYNAMIC_LAZYSEGTREE*\
    \ = 1\n\n    type\n        DynamicLazySegmentTreeNode[S, F] = ref object\n   \
    \         a, b, lo, hi, height: int\n            value, product: S\n         \
    \   tag, lazy: F\n            pending: bool\n            left, right: DynamicLazySegmentTreeNode[S,\
    \ F]\n        DynamicLazySegmentTree*[S, F] = ref object\n            root: DynamicLazySegmentTreeNode[S,\
    \ F]\n            length, nodes: int\n            merge: proc(x, y: S): S\n  \
    \          default: S\n            mapping: proc(f: F, x: S): S\n            composition:\
    \ proc(f, g: F): F\n            id: F\n            initial: proc(l, r: int): S\n\
    \n    proc makeNode[S, F](self: DynamicLazySegmentTree[S, F], a, b: int,\n   \
    \                     tag: F): DynamicLazySegmentTreeNode[S, F] =\n        ##\
    \ \u521D\u671F\u533A\u9593\u306B\u4F5C\u7528\u3092\u9069\u7528\u3057\u305F1\u30CE\
    \u30FC\u30C9\u3092O(1)\u3067\u78BA\u4FDD\u3057\u307E\u3059\u3002\n        let\
    \ value = self.mapping(tag, self.initial(a, b))\n        inc self.nodes\n    \
    \    DynamicLazySegmentTreeNode[S, F](a: a, b: b, lo: a, hi: b,\n            height:\
    \ 1, value: value, product: value, tag: tag, lazy: self.id)\n\n    proc initDynamicLazySegmentTree*[S,\
    \ F](n: int, merge: proc(x, y: S): S,\n            default: S, mapping: proc(f:\
    \ F, x: S): S,\n            composition: proc(f, g: F): F, id: F,\n          \
    \  initial: proc(l, r: int): S): DynamicLazySegmentTree[S, F] =\n        ## [0,n)\u3092\
    O(1)\u3067\u751F\u6210\u3057\u307E\u3059\u3002initial\u306F\u521D\u671F\u72B6\u614B\
    \u306E\u533A\u9593\u7A4D\u3001composition(f,g)\u306Fg\u306E\u5F8C\u306Bf\u3067\
    \u3059\u3002\n        ## initial(l,r)\u306F\u3001\u66F4\u65B0\u3092\u4E00\u5EA6\
    \u3082\u884C\u3063\u3066\u3044\u306A\u3044\u914D\u5217\u306E\u534A\u958B\u533A\
    \u9593[l,r)\u306E\u96C6\u7D04\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\n    \
    \    ## \u4F8B\u3048\u3070S=(sum,size)\u306E\u30BC\u30ED\u521D\u671F\u5316\u306A\
    \u3089(0,r-l)\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u533A\u9593\u306E\u5358\
    \u4F4D\u5143(0,0)\u3068\u306F\u533A\u5225\u3057\u307E\u3059\u3002\n        ##\
    \ \u533A\u9593\u5206\u5272\u3084\u533A\u9593\u306E\u4E00\u90E8\u306E\u53D6\u5F97\
    \u306B\u3082\u4F7F\u3044\u3001\u4FDD\u5B58\u6E08\u307F\u306E\u4F5C\u7528\u306F\
    \u6728\u304C\u9069\u7528\u3059\u308B\u305F\u3081\u3001\u66F4\u65B0\u3092\u53CD\
    \u6620\u3055\u305B\u306A\u3044\u3067\u304F\u3060\u3055\u3044\u3002\n        ##\
    \ initial(l,r)=merge(initial(l,m),initial(m,r))\u3001initial(l,l)=default\u3092\
    \u6E80\u305F\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n        ##\
    \ \u8A18\u8F09\u306E\u8A08\u7B97\u91CF\u306Finitial\u3092\u542B\u3080\u5404\u30B3\
    \u30FC\u30EB\u30D0\u30C3\u30AF\u304CO(1)\u306E\u5834\u5408\u3067\u3059\u3002\n\
    \        assert n >= 0\n        result = DynamicLazySegmentTree[S, F](length:\
    \ n, merge: merge,\n            default: default, mapping: mapping, composition:\
    \ composition,\n            id: id, initial: initial)\n        if n > 0:\n   \
    \         result.root = result.makeNode(0, n, id)\n\n    proc height[S, F](node:\
    \ DynamicLazySegmentTreeNode[S, F]): int =\n        ## \u7A7A\u306E\u90E8\u5206\
    \u6728\u3092\u9AD8\u30550\u3068\u3057\u3066O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\
    \n        if node == nil: 0 else: node.height\n\n    proc pull[S, F](self: DynamicLazySegmentTree[S,\
    \ F], node: DynamicLazySegmentTreeNode[S, F]) =\n        ## \u5B50\u304B\u3089\
    \u533A\u9593\u7A4D\u30FB\u5EA7\u6A19\u7BC4\u56F2\u30FB\u9AD8\u3055\u3092O(1)\u3067\
    \u518D\u8A08\u7B97\u3057\u307E\u3059\u3002\u672A\u4F1D\u64AD\u306E\u4F5C\u7528\
    \u306F\u4E8B\u524D\u306B\u4F1D\u64AD\u3057\u307E\u3059\u3002\n        node.product\
    \ = node.value\n        node.lo = node.a\n        node.hi = node.b\n        if\
    \ node.left != nil:\n            node.product = self.merge(node.left.product,\
    \ node.product)\n            node.lo = node.left.lo\n        if node.right !=\
    \ nil:\n            node.product = self.merge(node.product, node.right.product)\n\
    \            node.hi = node.right.hi\n        node.height = max(height(node.left),\
    \ height(node.right)) + 1\n\n    proc allApply[S, F](self: DynamicLazySegmentTree[S,\
    \ F],\n                        node: DynamicLazySegmentTreeNode[S, F], f: F) =\n\
    \        ## \u90E8\u5206\u6728\u5168\u4F53\u3078O(1)\u3067\u4F5C\u7528\u3055\u305B\
    \u307E\u3059\u3002tag\u306F\u81EA\u8EAB\u306E\u533A\u9593\u306E\u521D\u671F\u72B6\
    \u614B\u304B\u3089\u306E\u4F5C\u7528\u3067\u3059\u3002\n        if node == nil:\
    \ return\n        node.value = self.mapping(f, node.value)\n        node.product\
    \ = self.mapping(f, node.product)\n        node.tag = self.composition(f, node.tag)\n\
    \        if node.pending:\n            node.lazy = self.composition(f, node.lazy)\n\
    \        else:\n            node.lazy = f\n            node.pending = true\n\n\
    \    proc push[S, F](self: DynamicLazySegmentTree[S, F], node: DynamicLazySegmentTreeNode[S,\
    \ F]) =\n        ## \u5B50\u3078\u9045\u5EF6\u4F5C\u7528\u3092O(1)\u3067\u4F1D\
    \u64AD\u3057\u307E\u3059\u3002\u30CE\u30FC\u30C9\u306F\u8FFD\u52A0\u3057\u307E\
    \u305B\u3093\u3002\n        if node.pending:\n            self.allApply(node.left,\
    \ node.lazy)\n            self.allApply(node.right, node.lazy)\n            node.lazy\
    \ = self.id\n            node.pending = false\n\n    proc rotateLeft[S, F](self:\
    \ DynamicLazySegmentTree[S, F],\n                          node: DynamicLazySegmentTreeNode[S,\
    \ F]): DynamicLazySegmentTreeNode[S, F] =\n        ## \u9045\u5EF6\u4F5C\u7528\
    \u306E\u5BFE\u8C61\u3092\u4FDD\u3061\u306A\u304C\u3089\u5DE6\u56DE\u8EE2\u3092\
    O(1)\u3067\u884C\u3044\u307E\u3059\u3002\n        self.push(node)\n        result\
    \ = node.right\n        self.push(result)\n        node.right = result.left\n\
    \        result.left = node\n        self.pull(node)\n        self.pull(result)\n\
    \n    proc rotateRight[S, F](self: DynamicLazySegmentTree[S, F],\n           \
    \                node: DynamicLazySegmentTreeNode[S, F]): DynamicLazySegmentTreeNode[S,\
    \ F] =\n        ## \u9045\u5EF6\u4F5C\u7528\u306E\u5BFE\u8C61\u3092\u4FDD\u3061\
    \u306A\u304C\u3089\u53F3\u56DE\u8EE2\u3092O(1)\u3067\u884C\u3044\u307E\u3059\u3002\
    \n        self.push(node)\n        result = node.left\n        self.push(result)\n\
    \        node.left = result.right\n        result.right = node\n        self.pull(node)\n\
    \        self.pull(result)\n\n    proc balance[S, F](self: DynamicLazySegmentTree[S,\
    \ F],\n                       node: DynamicLazySegmentTreeNode[S, F]): DynamicLazySegmentTreeNode[S,\
    \ F] =\n        ## 1\u533A\u9593\u306E\u633F\u5165\u5F8C\u306BAVL\u6728\u306E\u9AD8\
    \u3055\u3092O(1)\u3067\u4FEE\u5FA9\u3057\u307E\u3059\u3002\n        self.pull(node)\n\
    \        if height(node.left) > height(node.right) + 1:\n            if height(node.left.left)\
    \ < height(node.left.right):\n                node.left = self.rotateLeft(node.left)\n\
    \            return self.rotateRight(node)\n        if height(node.right) > height(node.left)\
    \ + 1:\n            if height(node.right.right) < height(node.right.left):\n \
    \               node.right = self.rotateRight(node.right)\n            return\
    \ self.rotateLeft(node)\n        node\n\n    proc insertFirst[S, F](self: DynamicLazySegmentTree[S,\
    \ F],\n            node, added: DynamicLazySegmentTreeNode[S, F]): DynamicLazySegmentTreeNode[S,\
    \ F] =\n        ## \u90E8\u5206\u6728\u306E\u5168\u533A\u9593\u3088\u308A\u524D\
    \u306B\u3042\u308B\u533A\u9593\u3092O(log K)\u3067\u633F\u5165\u3057\u307E\u3059\
    \u3002\n        if node == nil: return added\n        self.push(node)\n      \
    \  node.left = self.insertFirst(node.left, added)\n        self.balance(node)\n\
    \n    proc splitAt[S, F](self: DynamicLazySegmentTree[S, F],\n            node:\
    \ DynamicLazySegmentTreeNode[S, F], p: int): DynamicLazySegmentTreeNode[S, F]\
    \ =\n        ## \u5EA7\u6A19p\u306B\u5883\u754C\u3092O(log K)\u3067\u4F5C\u308A\
    \u307E\u3059\u3002\u65E2\u5B58\u5883\u754C\u306A\u3089\u8FFD\u52A0\u305B\u305A\
    \u3001\u65B0\u898F\u306A\u30891\u30CE\u30FC\u30C9\u5897\u3048\u307E\u3059\u3002\
    \n        if node == nil or p == node.a or p == node.b: return node\n        self.push(node)\n\
    \        if p < node.a:\n            node.left = self.splitAt(node.left, p)\n\
    \        elif node.b < p:\n            node.right = self.splitAt(node.right, p)\n\
    \        else:\n            let added = self.makeNode(p, node.b, node.tag)\n \
    \           node.b = p\n            node.value = self.mapping(node.tag, self.initial(node.a,\
    \ p))\n            node.right = self.insertFirst(node.right, added)\n        self.balance(node)\n\
    \n    proc applyNode[S, F](self: DynamicLazySegmentTree[S, F],\n            node:\
    \ DynamicLazySegmentTreeNode[S, F], l, r: int, f: F) =\n        ## \u5883\u754C\
    \u3067\u5206\u5272\u6E08\u307F\u306E\u533A\u9593\u3078O(log K)\u3067\u4F5C\u7528\
    \u3055\u305B\u307E\u3059\u3002\n        if node == nil or r <= node.lo or node.hi\
    \ <= l: return\n        if l <= node.lo and node.hi <= r:\n            self.allApply(node,\
    \ f)\n            return\n        self.push(node)\n        self.applyNode(node.left,\
    \ l, r, f)\n        if l <= node.a and node.b <= r:\n            node.value =\
    \ self.mapping(f, node.value)\n            node.tag = self.composition(f, node.tag)\n\
    \        self.applyNode(node.right, l, r, f)\n        self.pull(node)\n\n    proc\
    \ apply*[S, F](self: DynamicLazySegmentTree[S, F], l, r: int, f: F) =\n      \
    \  ## [l,r)\u3078\u6700\u60AAO(log(K+2))\u3067\u4F5C\u7528\u3055\u305B\u307E\u3059\
    \u3002\u8FFD\u52A0\u30CE\u30FC\u30C9\u306F\u9AD8\u30052\u500B\u3001Q\u56DE\u66F4\
    \u65B0\u5F8C\u306E\u7A7A\u9593\u306FO(Q+1)\u3002\n        assert 0 <= l and l\
    \ <= r and r <= self.length\n        if l == r: return\n        self.root = self.splitAt(self.root,\
    \ l)\n        self.root = self.splitAt(self.root, r)\n        self.applyNode(self.root,\
    \ l, r, f)\n\n    proc getNode[S, F](self: DynamicLazySegmentTree[S, F],\n   \
    \         node: DynamicLazySegmentTreeNode[S, F], l, r: int): S =\n        ##\
    \ \u533A\u9593\u3092\u5206\u5272\u305B\u305A\u306B\u533A\u9593\u7A4D\u3092O(log\
    \ K)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        if node == nil or r <= node.lo\
    \ or node.hi <= l: return self.default\n        if l <= node.lo and node.hi <=\
    \ r: return node.product\n        self.push(node)\n        result = self.getNode(node.left,\
    \ l, r)\n        let a = max(l, node.a)\n        let b = min(r, node.b)\n    \
    \    if a < b:\n            let value = if a == node.a and b == node.b: node.value\n\
    \                        else: self.mapping(node.tag, self.initial(a, b))\n  \
    \          result = self.merge(result, value)\n        result = self.merge(result,\
    \ self.getNode(node.right, l, r))\n\n    proc get*[S, F](self: DynamicLazySegmentTree[S,\
    \ F], l, r: int): S =\n        ## \u534A\u958B\u533A\u9593[l,r)\u306E\u7A4D\u3092\
    \u6700\u60AAO(log(K+2))\u3067\u8FD4\u3057\u307E\u3059\u3002\u53D6\u5F97\u3067\u306F\
    \u30CE\u30FC\u30C9\u3092\u8FFD\u52A0\u3057\u307E\u305B\u3093\u3002\n        assert\
    \ 0 <= l and l <= r and r <= self.length\n        if l == r: return self.default\n\
    \        self.getNode(self.root, l, r)\n\n    proc setNode[S, F](self: DynamicLazySegmentTree[S,\
    \ F],\n            node: DynamicLazySegmentTreeNode[S, F], p: int, value: S) =\n\
    \        ## \u9577\u30551\u306B\u5206\u5272\u6E08\u307F\u306E\u533A\u9593\u3092\
    O(log K)\u3067\u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002\n        self.push(node)\n\
    \        if p < node.a:\n            self.setNode(node.left, p, value)\n     \
    \   elif p >= node.b:\n            self.setNode(node.right, p, value)\n      \
    \  else:\n            node.value = value\n            node.tag = self.id\n   \
    \     self.pull(node)\n\n    proc update*[S, F](self: DynamicLazySegmentTree[S,\
    \ F], p: Natural, value: S) =\n        ## 1\u70B9\u3092\u6700\u60AAO(log(K+2))\u3067\
    \u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002\u8FFD\u52A0\u30CE\u30FC\u30C9\u306F\
    \u9AD8\u30052\u500B\u3067\u3059\u3002\n        assert p < self.length\n      \
    \  self.root = self.splitAt(self.root, p)\n        self.root = self.splitAt(self.root,\
    \ p + 1)\n        self.setNode(self.root, p, value)\n\n    proc get*[S, F](self:\
    \ DynamicLazySegmentTree[S, F], segment: HSlice[int, int]): S =\n        ## \u30B9\
    \u30E9\u30A4\u30B9\u306E\u533A\u9593\u7A4D\u3092\u6700\u60AAO(log(K+2))\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\n        assert segment.b < self.length\n        self.get(segment.a,\
    \ segment.b + 1)\n\n    proc apply*[S, F](self: DynamicLazySegmentTree[S, F],\
    \ segment: HSlice[int, int], f: F) =\n        ## \u30B9\u30E9\u30A4\u30B9\u306E\
    \u533A\u9593\u3078\u6700\u60AAO(log(K+2))\u3067\u4F5C\u7528\u3055\u305B\u307E\u3059\
    \u3002\n        assert segment.b < self.length\n        self.apply(segment.a,\
    \ segment.b + 1, f)\n\n    proc `[]`*[S, F](self: DynamicLazySegmentTree[S, F],\
    \ segment: HSlice[int, int]): S =\n        ## \u30B9\u30E9\u30A4\u30B9\u306E\u533A\
    \u9593\u7A4D\u3092\u6700\u60AAO(log(K+2))\u3067\u8FD4\u3057\u307E\u3059\u3002\n\
    \        self.get(segment)\n\n    proc `[]`*[S, F](self: DynamicLazySegmentTree[S,\
    \ F], p: Natural): S =\n        ## 1\u70B9\u3092\u6700\u60AAO(log(K+2))\u3067\u53D6\
    \u5F97\u3057\u307E\u3059\u3002\n        assert p < self.length\n        self.get(p,\
    \ p + 1)\n\n    proc `[]=`*[S, F](self: DynamicLazySegmentTree[S, F], p: Natural,\
    \ value: S) =\n        ## 1\u70B9\u3092\u6700\u60AAO(log(K+2))\u3067\u4E0A\u66F8\
    \u304D\u3057\u307E\u3059\u3002\n        self.update(p, value)\n\n    proc get_all*[S,\
    \ F](self: DynamicLazySegmentTree[S, F]): S =\n        ## \u5168\u533A\u9593\u306E\
    \u7A4D\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        if self.root ==\
    \ nil: self.default else: self.root.product\n\n    proc len*[S, F](self: DynamicLazySegmentTree[S,\
    \ F]): int =\n        ## \u5EA7\u6A19\u7BC4\u56F2\u306E\u9577\u3055\u3092O(1)\u3067\
    \u8FD4\u3057\u307E\u3059\u3002\n        self.length\n\n    proc node_count*[S,\
    \ F](self: DynamicLazySegmentTree[S, F]): int =\n        ## \u4FDD\u6301\u3059\
    \u308B\u533A\u9593\u6570K\uFF08\u78BA\u4FDD\u3057\u305F\u30CE\u30FC\u30C9\u6570\
    \uFF09\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.nodes\n\n \
    \   template newDynamicLazySegWith*(n, merge, default, mapping, composition, id,\
    \ initial: untyped): untyped =\n        ## \u6F14\u7B97\u3092\u5F0F\u3067\u6307\
    \u5B9A\u3057\u3066O(1)\u3067\u751F\u6210\u3057\u307E\u3059\u3002initial\u306E\
    l,r\u306F\u521D\u671F\u533A\u9593\u306E\u4E21\u7AEF\u3067\u3059\u3002\n      \
    \  initDynamicLazySegmentTree[typeof(default), typeof(id)](n,\n            proc(l\
    \ {.inject.}, r {.inject.}: typeof(default)): typeof(default) = merge,\n     \
    \       default,\n            proc(f {.inject.}: typeof(id), x {.inject.}: typeof(default)):\
    \ typeof(default) = mapping,\n            proc(f {.inject.}, g {.inject.}: typeof(id)):\
    \ typeof(id) = composition,\n            id, proc(l {.inject.}, r {.inject.}:\
    \ int): typeof(default) = initial)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/dynamic_lazysegtree.nim
  requiredBy: []
  timestamp: '2026-09-12 20:28:08+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/lazysegtree/dynamic_rangeaffinerangesum_test.nim
  - verify/collections/lazysegtree/dynamic_rangeaffinerangesum_test.nim
  - verify/AI/dynamic_lazysegtree_test.nim
  - verify/AI/dynamic_lazysegtree_test.nim
documentation_of: cplib/collections/dynamic_lazysegtree.nim
layout: document
redirect_from:
- /library/cplib/collections/dynamic_lazysegtree.nim
- /library/cplib/collections/dynamic_lazysegtree.nim.html
title: cplib/collections/dynamic_lazysegtree.nim
---
