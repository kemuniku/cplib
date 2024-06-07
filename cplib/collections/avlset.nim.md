---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC217_gele_test.nim
    title: verify/collections/avlset/ABC217_gele_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC217_gele_test.nim
    title: verify/collections/avlset/ABC217_gele_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC217_gtlt_test.nim
    title: verify/collections/avlset/ABC217_gtlt_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC217_gtlt_test.nim
    title: verify/collections/avlset/ABC217_gtlt_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC217_index_test.nim
    title: verify/collections/avlset/ABC217_index_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC217_index_test.nim
    title: verify/collections/avlset/ABC217_index_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC234D_access_test.nim
    title: verify/collections/avlset/ABC234D_access_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC234D_access_test.nim
    title: verify/collections/avlset/ABC234D_access_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC236_test.nim
    title: verify/collections/avlset/ABC236_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC236_test.nim
    title: verify/collections/avlset/ABC236_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC294_test.nim
    title: verify/collections/avlset/ABC294_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC294_test.nim
    title: verify/collections/avlset/ABC294_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC337_test.nim
    title: verify/collections/avlset/ABC337_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/ABC337_test.nim
    title: verify/collections/avlset/ABC337_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/index_right_test.nim
    title: verify/collections/avlset/index_right_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avlset/index_right_test.nim
    title: verify/collections/avlset/index_right_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_AVLSET:\n    const CPLIB_COLLECTIONS_AVLSET*\
    \ = 1\n    import cplib/collections/avltreenode\n    import options\n\n    type\
    \ AvlSortedMultiSet*[T] = object\n        root*: AvlTreeNode[T]\n\n    proc len*[T](self:\
    \ AvlSortedMultiSet[T]): int = self.root.len\n    proc lowerBound*[T](self: AvlSortedMultiSet[T],\
    \ x: T): int =\n        var (ql, qr) = self.root.lower_bound_node(x)\n       \
    \ if qr == get_avltree_nilnode[T](): return self.len\n        return qr.index\n\
    \    proc index*[T](self: AvlSortedMultiSet[T], x: T): int = self.lowerBound(x)\n\
    \    proc upperBound*[T](self: AvlSortedMultiSet[T], x: T): int =\n        var\
    \ (ql, qr) = self.root.upper_bound_node(x)\n        if qr == get_avltree_nilnode[T]():\
    \ return self.len\n        return qr.index\n    proc index_right*[T](self: AvlSortedMultiSet[T],\
    \ x: T): int = self.upperBound(x)\n    proc count*[T](self: AvlSortedMultiSet[T],\
    \ x: T): int = self.upperBound(x) - self.lowerBound(x)\n    proc newnode[T](x:\
    \ T): AvlTreeNode[T] =\n        var nil_node = get_avltree_nilnode[T]()\n    \
    \    return AvlTreeNode[T](p: nil_node, l: nil_node, r: nil_node, len: 1, h: 1,\
    \ key: x)\n    proc lt*[T](self: AvlSortedMultiSet[T], x: T): Option[T] =\n  \
    \      var (node, _) = self.root.lower_bound_node(x)\n        if node == get_avltree_nilnode[T]():\
    \ return none(T)\n        return some(node.key)\n    proc le*[T](self: AvlSortedMultiSet[T],\
    \ x: T): Option[T] =\n        var (node, _) = self.root.upper_bound_node(x)\n\
    \        if node == get_avltree_nilnode[T](): return none(T)\n        return some(node.key)\n\
    \    proc gt*[T](self: AvlSortedMultiSet[T], x: T): Option[T] =\n        var (_,\
    \ node) = self.root.upper_bound_node(x)\n        if node == get_avltree_nilnode[T]():\
    \ return none(T)\n        return some(node.key)\n    proc ge*[T](self: AvlSortedMultiSet[T],\
    \ x: T): Option[T] =\n        var (_, node) = self.root.lower_bound_node(x)\n\
    \        if node == get_avltree_nilnode[T](): return none(T)\n        return some(node.key)\n\
    \    proc contains*[T](self: AvlSortedMultiSet[T], x: T): bool =\n        var\
    \ (_, node) = self.root.lower_bound_node(x)\n        return node != get_avltree_nilnode[T]()\
    \ and node.key == x\n    proc incl*[T](self: var AvlSortedMultiSet[T], x: T) =\n\
    \        var node = newnode(x)\n        self.root = self.root.insert(node)\n \
    \   proc excl*[T](self: var AvlSortedMultiSet[T], x: T): bool {.discardable.}\
    \ =\n        if x notin self: return false\n        var (_, node) = self.root.lower_bound_node(x)\n\
    \        self.root = self.root.erase(node, node.next)\n        return true\n \
    \   proc `[]`*[T](self: AvlSortedMultiSet[T], idx: int): T =\n        assert idx\
    \ < self.root.len\n        return self.root.get(idx).key\n    proc `[]`*[T](self:\
    \ AvlSortedMultiSet[T], idx: BackwardsIndex): T =\n        var idx = self.len\
    \ - int(idx)\n        return self[idx]\n    proc pop*[T](self: var AvlSortedMultiSet[T],\
    \ idx: int = -1): T =\n        var idx = idx\n        if idx < 0: idx = self.len\
    \ - idx\n        assert idx < self.root.len\n        var node = self.root.get(idx)\n\
    \        result = node.key\n        self.root = self.root.erase(node, node.next)\n\
    \    iterator items*[T](self: AvlSortedMultiSet[T]): T =\n        var stack =\
    \ @[(0, self.root)]\n        while stack.len > 0:\n            var (t, node) =\
    \ stack.pop\n            if t == 0:\n                stack.add((1, node))\n  \
    \              if node.l != get_avltree_nilnode[T](): stack.add((0, node.l))\n\
    \            elif t == 1:\n                yield node.key\n                if\
    \ node.r != get_avltree_nilnode[T](): stack.add((0, node.r))\n    proc initAvlSortedMultiSet*[T](v:\
    \ seq[T] = @[]): AvlSortedMultiSet[T] =\n        result = AvlSortedMultiSet[T](root:\
    \ get_avltree_nilnode[T]())\n        for item in v: result.incl(item)\n"
  dependsOn:
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: false
  path: cplib/collections/avlset.nim
  requiredBy: []
  timestamp: '2024-06-07 12:16:34+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/avlset/ABC236_test.nim
  - verify/collections/avlset/ABC236_test.nim
  - verify/collections/avlset/ABC217_index_test.nim
  - verify/collections/avlset/ABC217_index_test.nim
  - verify/collections/avlset/ABC217_gele_test.nim
  - verify/collections/avlset/ABC217_gele_test.nim
  - verify/collections/avlset/ABC337_test.nim
  - verify/collections/avlset/ABC337_test.nim
  - verify/collections/avlset/index_right_test.nim
  - verify/collections/avlset/index_right_test.nim
  - verify/collections/avlset/ABC217_gtlt_test.nim
  - verify/collections/avlset/ABC217_gtlt_test.nim
  - verify/collections/avlset/ABC294_test.nim
  - verify/collections/avlset/ABC294_test.nim
  - verify/collections/avlset/ABC234D_access_test.nim
  - verify/collections/avlset/ABC234D_access_test.nim
documentation_of: cplib/collections/avlset.nim
layout: document
redirect_from:
- /library/cplib/collections/avlset.nim
- /library/cplib/collections/avlset.nim.html
title: cplib/collections/avlset.nim
---
