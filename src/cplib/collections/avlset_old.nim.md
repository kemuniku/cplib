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
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_AVLSET:\n    const CPLIB_COLLECTIONS_AVLSET*\
    \ = 1\n    import cplib/collections/avltreenode\n    import options, sequtils,\
    \ strutils\n\n    type AvlSortedMultiSet*[T] = object\n        root*: AvlTreeNode[T]\n\
    \n    type AVLSortedSet*[T] = object\n        root*: AvlTreeNode[T]\n\n    type\
    \ AVLSets[T] = AvlSortedMultiSet[T] or AVLSortedSet[T]\n\n    proc len*[T](self:\
    \ AVLSets[T]): int = self.root.len\n    proc lowerBound*[T](self: AVLSets[T],\
    \ x: T): int =\n        var (ql, qr) = self.root.lower_bound_node(x)\n       \
    \ if qr == get_avltree_nilnode[T](): return self.len\n        return qr.index\n\
    \    proc index*[T](self: AVLSets[T], x: T): int = self.lowerBound(x)\n    proc\
    \ upperBound*[T](self: AVLSets[T], x: T): int =\n        var (ql, qr) = self.root.upper_bound_node(x)\n\
    \        if qr == get_avltree_nilnode[T](): return self.len\n        return qr.index\n\
    \    proc index_right*[T](self: AVLSets[T], x: T): int = self.upperBound(x)\n\
    \    proc count*[T](self: AVLSets[T], x: T): int = self.upperBound(x) - self.lowerBound(x)\n\
    \    proc newnode[T](x: T): AvlTreeNode[T] =\n        var nil_node = get_avltree_nilnode[T]()\n\
    \        return AvlTreeNode[T](p: nil_node, l: nil_node, r: nil_node, len: 1,\
    \ h: 1, key: x)\n    proc lt*[T](self: AVLSets[T], x: T): Option[T] =\n      \
    \  var (node, _) = self.root.lower_bound_node(x)\n        if node == get_avltree_nilnode[T]():\
    \ return none(T)\n        return some(node.key)\n    proc le*[T](self: AVLSets[T],\
    \ x: T): Option[T] =\n        var (node, _) = self.root.upper_bound_node(x)\n\
    \        if node == get_avltree_nilnode[T](): return none(T)\n        return some(node.key)\n\
    \    proc gt*[T](self: AVLSets[T], x: T): Option[T] =\n        var (_, node) =\
    \ self.root.upper_bound_node(x)\n        if node == get_avltree_nilnode[T]():\
    \ return none(T)\n        return some(node.key)\n    proc ge*[T](self: AVLSets[T],\
    \ x: T): Option[T] =\n        var (_, node) = self.root.lower_bound_node(x)\n\
    \        if node == get_avltree_nilnode[T](): return none(T)\n        return some(node.key)\n\
    \    proc contains*[T](self: AVLSets[T], x: T): bool =\n        var (_, node)\
    \ = self.root.lower_bound_node(x)\n        return node != get_avltree_nilnode[T]()\
    \ and node.key == x\n    proc incl*[T](self: var AVLSortedMultiSet[T], x: T) =\n\
    \        var node = newnode(x)\n        self.root = self.root.insert(node)\n \
    \   proc incl*[T](self: var AVLSortedSet[T], x: T): bool {.discardable.} =\n \
    \       if self.contains(x): return false\n        var node = newnode(x)\n   \
    \     self.root = self.root.insert(node)\n        return true\n    proc excl*[T](self:\
    \ var AVLSets[T], x: T): bool {.discardable.} =\n        if x notin self: return\
    \ false\n        var (_, node) = self.root.lower_bound_node(x)\n        self.root\
    \ = self.root.erase(node, node.next)\n        return true\n    proc `[]`*[T](self:\
    \ AVLSets[T], idx: int): T =\n        assert idx < self.root.len\n        return\
    \ self.root.get(idx).key\n    proc `[]`*[T](self: AVLSets[T], idx: BackwardsIndex):\
    \ T =\n        var idx = self.len - int(idx)\n        return self[idx]\n    proc\
    \ pop*[T](self: var AVLSets[T], idx: int = -1): T =\n        var idx = idx\n \
    \       if idx < 0: idx = self.len + idx\n        assert idx < self.root.len\n\
    \        var node = self.root.get(idx)\n        result = node.key\n        self.root\
    \ = self.root.erase(node, node.next)\n    iterator items*[T](self: AVLSets[T]):\
    \ T =\n        var stack = @[(0, self.root)]\n        while stack.len > 0:\n \
    \           var (t, node) = stack.pop\n            if t == 0:\n              \
    \  stack.add((1, node))\n                if node.l != get_avltree_nilnode[T]():\
    \ stack.add((0, node.l))\n            elif t == 1:\n                yield node.key\n\
    \                if node.r != get_avltree_nilnode[T](): stack.add((0, node.r))\n\
    \    proc `$`*[T](self: AVLSets[T]): string = self.toSeq.join(\" \")\n    proc\
    \ initAvlSortedMultiSet*[T](v: seq[T] = @[]): AvlSortedMultiSet[T] =\n       \
    \ result = AvlSortedMultiSet[T](root: get_avltree_nilnode[T]())\n        for item\
    \ in v: result.incl(item)\n    proc initAvlSortedSet*[T](v: seq[T] = @[]): AvlSortedSet[T]\
    \ =\n        result = AvlSortedSet[T](root: get_avltree_nilnode[T]())\n      \
    \  for item in v: result.incl(item)\n"
  dependsOn:
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: false
  path: cplib/collections/avlset_old.nim
  requiredBy: []
  timestamp: '2025-04-27 19:08:43+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/avlset_old.nim
layout: document
redirect_from:
- /library/cplib/collections/avlset_old.nim
- /library/cplib/collections/avlset_old.nim.html
title: cplib/collections/avlset_old.nim
---
