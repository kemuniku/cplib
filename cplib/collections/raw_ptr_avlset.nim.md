---
data:
  _extendedDependsOn: []
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
    \ = 1\n    import algorithm, options, sequtils, strutils\n\n    type\n       \
    \ AvlTreeNode*[K] = ptr AvlTreeNodeObj[K]\n        AvlTreeNodeObj*[K] = object\n\
    \            l*, r*, p*: AvlTreeNode[K]\n            h*, len*: int\n         \
    \   key*: K\n\n    type AvlSortedMultiSet*[T] = object\n        root*: AvlTreeNode[T]\n\
    \n    type AVLSortedSet*[T] = object\n        root*: AvlTreeNode[T]\n\n    type\
    \ AVLSets[T] = AvlSortedMultiSet[T] or AVLSortedSet[T]\n\n    proc newNode[T](x:\
    \ T): AvlTreeNode[T] {.inline.} =\n        result = create(AvlTreeNodeObj[T])\n\
    \        result[].h = 1\n        result[].len = 1\n        result[].key = x\n\n\
    \    proc height[T](node: AvlTreeNode[T]): int {.inline.} =\n        if node.isNil:\
    \ 0 else: node[].h\n\n    proc length[T](node: AvlTreeNode[T]): int {.inline.}\
    \ =\n        if node.isNil: 0 else: node[].len\n\n    proc update[T](node: AvlTreeNode[T])\
    \ {.inline.} =\n        node[].h = max(node[].l.height, node[].r.height) + 1\n\
    \        node[].len = node[].l.length + node[].r.length + 1\n\n    proc buildBalanced[T](\n\
    \        a: openArray[T], l, r: int, parent: AvlTreeNode[T]\n    ): AvlTreeNode[T]\
    \ =\n        if l >= r: return nil\n        let m = (l + r) shr 1\n        result\
    \ = newNode(a[m])\n        result[].p = parent\n        result[].l = buildBalanced(a,\
    \ l, m, result)\n        result[].r = buildBalanced(a, m + 1, r, result)\n   \
    \     result.update()\n\n    proc setChildren[T](node, l, r: AvlTreeNode[T]) {.inline.}\
    \ =\n        node[].l = l\n        if not l.isNil: l[].p = node\n        node[].r\
    \ = r\n        if not r.isNil: r[].p = node\n        node.update()\n\n    proc\
    \ rebalance[T](node: AvlTreeNode[T]): AvlTreeNode[T] =\n        result = node\n\
    \        let l = result[].l\n        let r = result[].r\n        let lh = l.height\n\
    \        let rh = r.height\n        if lh + 1 < rh:\n            let rl = r[].l\n\
    \            let rr = r[].r\n            if rl.height <= rr.height:\n        \
    \        r[].p = result[].p\n                result.setChildren(l, rl)\n     \
    \           r.setChildren(result, rr)\n                return r\n            else:\n\
    \                rl[].p = result[].p\n                result.setChildren(l, rl[].l)\n\
    \                r.setChildren(rl[].r, rr)\n                rl.setChildren(result,\
    \ r)\n                return rl\n        elif rh + 1 < lh:\n            let ll\
    \ = l[].l\n            let lr = l[].r\n            if lr.height <= ll.height:\n\
    \                l[].p = result[].p\n                result.setChildren(lr, r)\n\
    \                l.setChildren(ll, result)\n                return l\n       \
    \     else:\n                lr[].p = result[].p\n                result.setChildren(lr[].r,\
    \ r)\n                l.setChildren(ll, lr[].l)\n                lr.setChildren(l,\
    \ result)\n                return lr\n        result.update()\n\n    proc rebalanceToRoot[T](node:\
    \ AvlTreeNode[T]): AvlTreeNode[T] =\n        var node = node\n        while not\
    \ node[].p.isNil:\n            let cp = node[].p\n            if cp[].l == node:\
    \ cp[].l = node.rebalance()\n            else: cp[].r = node.rebalance()\n   \
    \         node = cp\n        return node.rebalance()\n\n    proc lowerBoundNode[T](node:\
    \ AvlTreeNode[T], key: T): (AvlTreeNode[T], AvlTreeNode[T]) =\n        var node\
    \ = node\n        var resultL: AvlTreeNode[T] = nil\n        var resultR: AvlTreeNode[T]\
    \ = nil\n        while not node.isNil:\n            if key <= node[].key:\n  \
    \              resultR = node\n                node = node[].l\n            else:\n\
    \                resultL = node\n                node = node[].r\n        return\
    \ (resultL, resultR)\n\n    proc upperBoundNode[T](node: AvlTreeNode[T], key:\
    \ T): (AvlTreeNode[T], AvlTreeNode[T]) =\n        var node = node\n        var\
    \ resultL: AvlTreeNode[T] = nil\n        var resultR: AvlTreeNode[T] = nil\n \
    \       while not node.isNil:\n            if key < node[].key:\n            \
    \    resultR = node\n                node = node[].l\n            else:\n    \
    \            resultL = node\n                node = node[].r\n        return (resultL,\
    \ resultR)\n\n    proc index[T](node: AvlTreeNode[T]): int =\n        var node\
    \ = node\n        if node.isNil: return 0\n        result = node[].l.length\n\
    \        while not node[].p.isNil:\n            if node[].p[].r == node:\n   \
    \             result += node[].p[].l.length + 1\n            node = node[].p\n\
    \n    proc insertAfterLowerBound[T](\n        node, x, ql, qr: AvlTreeNode[T]\n\
    \    ): AvlTreeNode[T] =\n        if node.isNil: return x\n        if not ql.isNil\
    \ and ql[].r.isNil:\n            ql.setChildren(ql[].l, x)\n            return\
    \ ql.rebalanceToRoot()\n        qr.setChildren(x, qr[].r)\n        return qr.rebalanceToRoot()\n\
    \n    proc insertNode[T](node, x: AvlTreeNode[T]): AvlTreeNode[T] =\n        let\
    \ (ql, qr) = node.lowerBoundNode(x[].key)\n        return node.insertAfterLowerBound(x,\
    \ ql, qr)\n\n    proc nextNode[T](node: AvlTreeNode[T]): AvlTreeNode[T] =\n  \
    \      var node = node\n        if not node[].r.isNil:\n            node = node[].r\n\
    \            while not node[].l.isNil: node = node[].l\n            return node\n\
    \        while not node[].p.isNil and node[].p[].r == node:\n            node\
    \ = node[].p\n        return node[].p\n\n    proc eraseNode[T](node, x, nxt: AvlTreeNode[T]):\
    \ AvlTreeNode[T] =\n        let xp = x[].p\n        if x[].r.isNil:\n        \
    \    let xl = x[].l\n            if not xl.isNil: xl[].p = xp\n            if\
    \ not xp.isNil:\n                if xp[].l == x: xp[].l = xl\n               \
    \ else: xp[].r = xl\n            if xp.isNil: result = xl\n            else: result\
    \ = xp.rebalanceToRoot()\n        else:\n            let nxtp = nxt[].p\n    \
    \        let nxtr = nxt[].r\n            if not xp.isNil:\n                if\
    \ xp[].l == x: xp[].l = nxt\n                else: xp[].r = nxt\n            nxt[].p\
    \ = xp\n            nxt[].l = x[].l\n            if not nxt[].l.isNil: nxt[].l[].p\
    \ = nxt\n            if x[].r == nxt:\n                nxt.update()\n        \
    \        result = nxt.rebalanceToRoot()\n            else:\n                if\
    \ nxtp[].l == nxt: nxtp[].l = nxtr\n                else: nxtp[].r = nxtr\n  \
    \              if not nxtr.isNil: nxtr[].p = nxtp\n                nxt[].r = x[].r\n\
    \                nxt[].r[].p = nxt\n                nxt.update()\n           \
    \     result = nxtp.rebalanceToRoot()\n        x[].l = nil\n        x[].r = nil\n\
    \        x[].p = nil\n        x.update()\n\n    proc getNode[T](node: AvlTreeNode[T],\
    \ idx: int): AvlTreeNode[T] =\n        assert idx >= 0\n        if idx >= node.length:\
    \ return nil\n        result = node\n        var idx = idx\n        while result[].l.length\
    \ != idx:\n            if result[].l.length < idx:\n                idx -= result[].l.length\
    \ + 1\n                assert not result[].r.isNil\n                result = result[].r\n\
    \            else:\n                result = result[].l\n\n    proc len*[T](self:\
    \ AVLSets[T]): int =\n        self.root.length\n\n    proc lowerBound*[T](self:\
    \ AVLSets[T], x: T): int =\n        let (_, qr) = self.root.lowerBoundNode(x)\n\
    \        if qr.isNil: return self.len\n        return qr.index\n\n    proc index*[T](self:\
    \ AVLSets[T], x: T): int =\n        self.lowerBound(x)\n\n    proc upperBound*[T](self:\
    \ AVLSets[T], x: T): int =\n        let (_, qr) = self.root.upperBoundNode(x)\n\
    \        if qr.isNil: return self.len\n        return qr.index\n\n    proc index_right*[T](self:\
    \ AVLSets[T], x: T): int =\n        self.upperBound(x)\n\n    proc count*[T](self:\
    \ AVLSets[T], x: T): int =\n        self.upperBound(x) - self.lowerBound(x)\n\n\
    \    proc lt*[T](self: AVLSets[T], x: T): Option[T] =\n        let (node, _) =\
    \ self.root.lowerBoundNode(x)\n        if node.isNil: return none(T)\n       \
    \ return some(node[].key)\n\n    proc le*[T](self: AVLSets[T], x: T): Option[T]\
    \ =\n        let (node, _) = self.root.upperBoundNode(x)\n        if node.isNil:\
    \ return none(T)\n        return some(node[].key)\n\n    proc gt*[T](self: AVLSets[T],\
    \ x: T): Option[T] =\n        let (_, node) = self.root.upperBoundNode(x)\n  \
    \      if node.isNil: return none(T)\n        return some(node[].key)\n\n    proc\
    \ ge*[T](self: AVLSets[T], x: T): Option[T] =\n        let (_, node) = self.root.lowerBoundNode(x)\n\
    \        if node.isNil: return none(T)\n        return some(node[].key)\n\n  \
    \  proc contains*[T](self: AVLSets[T], x: T): bool =\n        let (_, node) =\
    \ self.root.lowerBoundNode(x)\n        return not node.isNil and node[].key ==\
    \ x\n\n    proc incl*[T](self: var AvlSortedMultiSet[T], x: T) =\n        self.root\
    \ = self.root.insertNode(newNode(x))\n\n    proc incl*[T](self: var AVLSortedSet[T],\
    \ x: T): bool {.discardable.} =\n        let (ql, qr) = self.root.lowerBoundNode(x)\n\
    \        if not qr.isNil and qr[].key == x: return false\n        self.root =\
    \ self.root.insertAfterLowerBound(newNode(x), ql, qr)\n        return true\n\n\
    \    proc excl*[T](self: var AVLSets[T], x: T): bool {.discardable.} =\n     \
    \   let (_, node) = self.root.lowerBoundNode(x)\n        if node.isNil or node[].key\
    \ != x: return false\n        self.root = self.root.eraseNode(node, node.nextNode())\n\
    \        return true\n\n    proc `[]`*[T](self: AVLSets[T], idx: int): T =\n \
    \       assert idx >= 0 and idx < self.len\n        return self.root.getNode(idx)[].key\n\
    \n    proc `[]`*[T](self: AVLSets[T], idx: BackwardsIndex): T =\n        self[self.len\
    \ - int(idx)]\n\n    proc pop*[T](self: var AVLSets[T], idx: int = -1): T =\n\
    \        var idx = idx\n        if idx < 0: idx = self.len + idx\n        assert\
    \ idx >= 0 and idx < self.len\n        let node = self.root.getNode(idx)\n   \
    \     result = node[].key\n        self.root = self.root.eraseNode(node, node.nextNode())\n\
    \n    iterator items*[T](self: AVLSets[T]): T =\n        if not self.root.isNil:\n\
    \            var stack = @[(0, self.root)]\n            while stack.len > 0:\n\
    \                let (t, node) = stack.pop()\n                if t == 0:\n   \
    \                 stack.add((1, node))\n                    if not node[].l.isNil:\
    \ stack.add((0, node[].l))\n                else:\n                    yield node[].key\n\
    \                    if not node[].r.isNil: stack.add((0, node[].r))\n\n    proc\
    \ `$`*[T](self: AVLSets[T]): string =\n        self.toSeq.join(\" \")\n\n    proc\
    \ initAvlSortedMultiSet*[T](v: openArray[T] = []): AvlSortedMultiSet[T] =\n  \
    \      if v.len == 0: return\n        var a = @v\n        a.sort()\n        result.root\
    \ = buildBalanced(a, 0, a.len, nil)\n\n    proc initAvlSortedSet*[T](v: openArray[T]\
    \ = []): AVLSortedSet[T] =\n        if v.len == 0: return\n        var a = @v\n\
    \        a.sort()\n        var n = 0\n        for item in a:\n            if n\
    \ == 0 or a[n - 1] != item:\n                a[n] = item\n                inc\
    \ n\n        a.setLen(n)\n        result.root = buildBalanced(a, 0, a.len, nil)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/raw_ptr_avlset.nim
  requiredBy: []
  timestamp: '2026-07-07 20:32:53+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/raw_ptr_avlset.nim
layout: document
redirect_from:
- /library/cplib/collections/raw_ptr_avlset.nim
- /library/cplib/collections/raw_ptr_avlset.nim.html
title: cplib/collections/raw_ptr_avlset.nim
---
