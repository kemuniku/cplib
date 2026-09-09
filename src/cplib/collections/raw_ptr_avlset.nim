when not declared CPLIB_COLLECTIONS_AVLSET:
    const CPLIB_COLLECTIONS_AVLSET* = 1
    import algorithm, options, sequtils, strutils

    type
        AvlTreeNode*[K] = ptr AvlTreeNodeObj[K]
        AvlTreeNodeObj*[K] = object
            l*, r*, p*: AvlTreeNode[K]
            h*, len*: int
            key*: K

    type AvlSortedMultiSet*[T] = object
        root*: AvlTreeNode[T]

    type AVLSortedSet*[T] = object
        root*: AvlTreeNode[T]

    type AVLSets[T] = AvlSortedMultiSet[T] or AVLSortedSet[T]

    proc newNode[T](x: T): AvlTreeNode[T] {.inline.} =
        result = create(AvlTreeNodeObj[T])
        result[].h = 1
        result[].len = 1
        result[].key = x

    proc height[T](node: AvlTreeNode[T]): int {.inline.} =
        if node.isNil: 0 else: node[].h

    proc length[T](node: AvlTreeNode[T]): int {.inline.} =
        if node.isNil: 0 else: node[].len

    proc update[T](node: AvlTreeNode[T]) {.inline.} =
        node[].h = max(node[].l.height, node[].r.height) + 1
        node[].len = node[].l.length + node[].r.length + 1

    proc buildBalanced[T](
        a: openArray[T], l, r: int, parent: AvlTreeNode[T]
    ): AvlTreeNode[T] =
        if l >= r: return nil
        let m = (l + r) shr 1
        result = newNode(a[m])
        result[].p = parent
        result[].l = buildBalanced(a, l, m, result)
        result[].r = buildBalanced(a, m + 1, r, result)
        result.update()

    proc setChildren[T](node, l, r: AvlTreeNode[T]) {.inline.} =
        node[].l = l
        if not l.isNil: l[].p = node
        node[].r = r
        if not r.isNil: r[].p = node
        node.update()

    proc rebalance[T](node: AvlTreeNode[T]): AvlTreeNode[T] =
        result = node
        let l = result[].l
        let r = result[].r
        let lh = l.height
        let rh = r.height
        if lh + 1 < rh:
            let rl = r[].l
            let rr = r[].r
            if rl.height <= rr.height:
                r[].p = result[].p
                result.setChildren(l, rl)
                r.setChildren(result, rr)
                return r
            else:
                rl[].p = result[].p
                result.setChildren(l, rl[].l)
                r.setChildren(rl[].r, rr)
                rl.setChildren(result, r)
                return rl
        elif rh + 1 < lh:
            let ll = l[].l
            let lr = l[].r
            if lr.height <= ll.height:
                l[].p = result[].p
                result.setChildren(lr, r)
                l.setChildren(ll, result)
                return l
            else:
                lr[].p = result[].p
                result.setChildren(lr[].r, r)
                l.setChildren(ll, lr[].l)
                lr.setChildren(l, result)
                return lr
        result.update()

    proc rebalanceToRoot[T](node: AvlTreeNode[T]): AvlTreeNode[T] =
        var node = node
        while not node[].p.isNil:
            let cp = node[].p
            if cp[].l == node: cp[].l = node.rebalance()
            else: cp[].r = node.rebalance()
            node = cp
        return node.rebalance()

    proc lowerBoundNode[T](node: AvlTreeNode[T], key: T): (AvlTreeNode[T], AvlTreeNode[T]) =
        var node = node
        var resultL: AvlTreeNode[T] = nil
        var resultR: AvlTreeNode[T] = nil
        while not node.isNil:
            if key <= node[].key:
                resultR = node
                node = node[].l
            else:
                resultL = node
                node = node[].r
        return (resultL, resultR)

    proc upperBoundNode[T](node: AvlTreeNode[T], key: T): (AvlTreeNode[T], AvlTreeNode[T]) =
        var node = node
        var resultL: AvlTreeNode[T] = nil
        var resultR: AvlTreeNode[T] = nil
        while not node.isNil:
            if key < node[].key:
                resultR = node
                node = node[].l
            else:
                resultL = node
                node = node[].r
        return (resultL, resultR)

    proc index[T](node: AvlTreeNode[T]): int =
        var node = node
        if node.isNil: return 0
        result = node[].l.length
        while not node[].p.isNil:
            if node[].p[].r == node:
                result += node[].p[].l.length + 1
            node = node[].p

    proc insertAfterLowerBound[T](
        node, x, ql, qr: AvlTreeNode[T]
    ): AvlTreeNode[T] =
        if node.isNil: return x
        if not ql.isNil and ql[].r.isNil:
            ql.setChildren(ql[].l, x)
            return ql.rebalanceToRoot()
        qr.setChildren(x, qr[].r)
        return qr.rebalanceToRoot()

    proc insertNode[T](node, x: AvlTreeNode[T]): AvlTreeNode[T] =
        let (ql, qr) = node.lowerBoundNode(x[].key)
        return node.insertAfterLowerBound(x, ql, qr)

    proc nextNode[T](node: AvlTreeNode[T]): AvlTreeNode[T] =
        var node = node
        if not node[].r.isNil:
            node = node[].r
            while not node[].l.isNil: node = node[].l
            return node
        while not node[].p.isNil and node[].p[].r == node:
            node = node[].p
        return node[].p

    proc eraseNode[T](node, x, nxt: AvlTreeNode[T]): AvlTreeNode[T] =
        let xp = x[].p
        if x[].r.isNil:
            let xl = x[].l
            if not xl.isNil: xl[].p = xp
            if not xp.isNil:
                if xp[].l == x: xp[].l = xl
                else: xp[].r = xl
            if xp.isNil: result = xl
            else: result = xp.rebalanceToRoot()
        else:
            let nxtp = nxt[].p
            let nxtr = nxt[].r
            if not xp.isNil:
                if xp[].l == x: xp[].l = nxt
                else: xp[].r = nxt
            nxt[].p = xp
            nxt[].l = x[].l
            if not nxt[].l.isNil: nxt[].l[].p = nxt
            if x[].r == nxt:
                nxt.update()
                result = nxt.rebalanceToRoot()
            else:
                if nxtp[].l == nxt: nxtp[].l = nxtr
                else: nxtp[].r = nxtr
                if not nxtr.isNil: nxtr[].p = nxtp
                nxt[].r = x[].r
                nxt[].r[].p = nxt
                nxt.update()
                result = nxtp.rebalanceToRoot()
        x[].l = nil
        x[].r = nil
        x[].p = nil
        x.update()

    proc getNode[T](node: AvlTreeNode[T], idx: int): AvlTreeNode[T] =
        assert idx >= 0
        if idx >= node.length: return nil
        result = node
        var idx = idx
        while result[].l.length != idx:
            if result[].l.length < idx:
                idx -= result[].l.length + 1
                assert not result[].r.isNil
                result = result[].r
            else:
                result = result[].l

    proc len*[T](self: AVLSets[T]): int =
        self.root.length

    proc lowerBound*[T](self: AVLSets[T], x: T): int =
        let (_, qr) = self.root.lowerBoundNode(x)
        if qr.isNil: return self.len
        return qr.index

    proc index*[T](self: AVLSets[T], x: T): int =
        self.lowerBound(x)

    proc upperBound*[T](self: AVLSets[T], x: T): int =
        let (_, qr) = self.root.upperBoundNode(x)
        if qr.isNil: return self.len
        return qr.index

    proc index_right*[T](self: AVLSets[T], x: T): int =
        self.upperBound(x)

    proc count*[T](self: AVLSets[T], x: T): int =
        self.upperBound(x) - self.lowerBound(x)

    proc lt*[T](self: AVLSets[T], x: T): Option[T] =
        let (node, _) = self.root.lowerBoundNode(x)
        if node.isNil: return none(T)
        return some(node[].key)

    proc le*[T](self: AVLSets[T], x: T): Option[T] =
        let (node, _) = self.root.upperBoundNode(x)
        if node.isNil: return none(T)
        return some(node[].key)

    proc gt*[T](self: AVLSets[T], x: T): Option[T] =
        let (_, node) = self.root.upperBoundNode(x)
        if node.isNil: return none(T)
        return some(node[].key)

    proc ge*[T](self: AVLSets[T], x: T): Option[T] =
        let (_, node) = self.root.lowerBoundNode(x)
        if node.isNil: return none(T)
        return some(node[].key)

    proc contains*[T](self: AVLSets[T], x: T): bool =
        let (_, node) = self.root.lowerBoundNode(x)
        return not node.isNil and node[].key == x

    proc incl*[T](self: var AvlSortedMultiSet[T], x: T) =
        self.root = self.root.insertNode(newNode(x))

    proc incl*[T](self: var AVLSortedSet[T], x: T): bool {.discardable.} =
        let (ql, qr) = self.root.lowerBoundNode(x)
        if not qr.isNil and qr[].key == x: return false
        self.root = self.root.insertAfterLowerBound(newNode(x), ql, qr)
        return true

    proc excl*[T](self: var AVLSets[T], x: T): bool {.discardable.} =
        let (_, node) = self.root.lowerBoundNode(x)
        if node.isNil or node[].key != x: return false
        self.root = self.root.eraseNode(node, node.nextNode())
        return true

    proc `[]`*[T](self: AVLSets[T], idx: int): T =
        assert idx >= 0 and idx < self.len
        return self.root.getNode(idx)[].key

    proc `[]`*[T](self: AVLSets[T], idx: BackwardsIndex): T =
        self[self.len - int(idx)]

    proc pop*[T](self: var AVLSets[T], idx: int = -1): T =
        var idx = idx
        if idx < 0: idx = self.len + idx
        assert idx >= 0 and idx < self.len
        let node = self.root.getNode(idx)
        result = node[].key
        self.root = self.root.eraseNode(node, node.nextNode())

    iterator items*[T](self: AVLSets[T]): T =
        if not self.root.isNil:
            var stack = @[(0, self.root)]
            while stack.len > 0:
                let (t, node) = stack.pop()
                if t == 0:
                    stack.add((1, node))
                    if not node[].l.isNil: stack.add((0, node[].l))
                else:
                    yield node[].key
                    if not node[].r.isNil: stack.add((0, node[].r))

    proc `$`*[T](self: AVLSets[T]): string =
        self.toSeq.join(" ")

    proc initAvlSortedMultiSet*[T](v: openArray[T] = []): AvlSortedMultiSet[T] =
        if v.len == 0: return
        var a = @v
        a.sort()
        result.root = buildBalanced(a, 0, a.len, nil)

    proc initAvlSortedSet*[T](v: openArray[T] = []): AVLSortedSet[T] =
        if v.len == 0: return
        var a = @v
        a.sort()
        var n = 0
        for item in a:
            if n == 0 or a[n - 1] != item:
                a[n] = item
                inc n
        a.setLen(n)
        result.root = buildBalanced(a, 0, a.len, nil)
