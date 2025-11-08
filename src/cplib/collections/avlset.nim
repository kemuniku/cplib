when not declared CPLIB_COLLECTIONS_AVLSET:
    const CPLIB_COLLECTIONS_AVLSET* = 1
    import cplib/collections/avltreenode
    import options, sequtils, strutils

    type AvlSortedMultiSet*[T] = object
        root*: AvlTreeNode[T]

    type AVLSortedSet*[T] = object
        root*: AvlTreeNode[T]

    type AVLSets[T] = AvlSortedMultiSet[T] or AVLSortedSet[T]

    proc len*[T](self: AVLSets[T]): int = (if self.root.isNil: 0 else: self.root.len)
    proc lowerBound*[T](self: AVLSets[T], x: T): int =
        var (ql, qr) = self.root.lower_bound_node(x)
        if qr.isNil: return self.len
        return qr.index
    proc index*[T](self: AVLSets[T], x: T): int = self.lowerBound(x)
    proc upperBound*[T](self: AVLSets[T], x: T): int =
        var (ql, qr) = self.root.upper_bound_node(x)
        if qr.isNil: return self.len
        return qr.index
    proc index_right*[T](self: AVLSets[T], x: T): int = self.upperBound(x)
    proc count*[T](self: AVLSets[T], x: T): int = self.upperBound(x) - self.lowerBound(x)
    proc newnode[T](x: T): AvlTreeNode[T] =
        return AvlTreeNode[T](len: 1, h: 1, key: x)
    proc lt*[T](self: AVLSets[T], x: T): Option[T] =
        var (node, _) = self.root.lower_bound_node(x)
        if node.isNil: return none(T)
        return some(node.key)
    proc le*[T](self: AVLSets[T], x: T): Option[T] =
        var (node, _) = self.root.upper_bound_node(x)
        if node.isNil: return none(T)
        return some(node.key)
    proc gt*[T](self: AVLSets[T], x: T): Option[T] =
        var (_, node) = self.root.upper_bound_node(x)
        if node.isNil: return none(T)
        return some(node.key)
    proc ge*[T](self: AVLSets[T], x: T): Option[T] =
        var (_, node) = self.root.lower_bound_node(x)
        if node.isNil: return none(T)
        return some(node.key)
    proc contains*[T](self: AVLSets[T], x: T): bool =
        var (_, node) = self.root.lower_bound_node(x)
        return not node.isNil and node.key == x
    proc incl*[T](self: var AVLSortedMultiSet[T], x: T) =
        var node = newnode(x)
        self.root = self.root.insert(node)
    proc incl*[T](self: var AVLSortedSet[T], x: T): bool {.discardable.} =
        if self.contains(x): return false
        var node = newnode(x)
        self.root = self.root.insert(node)
        return true
    proc excl*[T](self: var AVLSets[T], x: T): bool {.discardable.} =
        if x notin self: return false
        var (_, node) = self.root.lower_bound_node(x)
        self.root = self.root.erase(node, node.next)
        return true
    proc `[]`*[T](self: AVLSets[T], idx: int): T =
        assert idx < self.root.len
        return self.root.get(idx).key
    proc `[]`*[T](self: AVLSets[T], idx: BackwardsIndex): T =
        var idx = self.len - int(idx)
        return self[idx]
    proc pop*[T](self: var AVLSets[T], idx: int = -1): T =
        var idx = idx
        if idx < 0: idx = self.len + idx
        assert idx < self.root.len
        var node = self.root.get(idx)
        result = node.key
        self.root = self.root.erase(node, node.next)
    iterator items*[T](self: AVLSets[T]): T =
        if not self.root.isNil:
            var stack = @[(0, self.root)]
            while stack.len > 0:
                var (t, node) = stack.pop
                if t == 0:
                    stack.add((1, node))
                    if not node.l.isNil: stack.add((0, node.l))
                elif t == 1:
                    yield node.key
                    if not node.r.isNil: stack.add((0, node.r))
    proc `$`*[T](self: AVLSets[T]): string = self.toSeq.join(" ")
    proc initAvlSortedMultiSet*[T](v: seq[T] = @[]): AvlSortedMultiSet[T] =
        result = AvlSortedMultiSet[T]()
        for item in v: result.incl(item)
    proc initAvlSortedSet*[T](v: seq[T] = @[]): AvlSortedSet[T] =
        result = AvlSortedSet[T]()
        for item in v: result.incl(item)
