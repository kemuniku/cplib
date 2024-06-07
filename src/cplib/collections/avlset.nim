when not declared CPLIB_COLLECTIONS_AVLSET:
    const CPLIB_COLLECTIONS_AVLSET* = 1
    import cplib/collections/avltreenode

    type AvlSortedMultiSet*[T] = object
        root*: AvlTreeNode[T]

    proc len*[T](self: AvlSortedMultiSet[T]): int = self.root.len
    proc lowerBound*[T](self: AvlSortedMultiSet[T], x: T): int =
        var (ql, qr) = self.root.lower_bound_node(x)
        return ql.len
    proc index*[T](self: AvlSortedMultiSet[T], x: T): int = self.lowerBound(x)
    proc upperBound*[T](self: AvlSortedMultiSet[T], x: T): int =
        var (ql, qr) = self.root.upper_bound_node(x)
        return ql.len
    proc index_right*[T](self: AvlSortedMultiSet[T], x: T): int = self.upperBound(x)
    proc count*[T](self: AvlSortedMultiSet[T], x: T): int = self.upperBound(x) - self.lowerBound(x)
    proc contains*[T](self: AvlSortedMultiSet[T], x: T): bool =
        var (_, node) = self.root.lower_bound_node(x)
        return node != get_avltree_nilnode[T]() and node.key == x
    proc newnode[T](x: T): AvlTreeNode[T] =
        var nil_node = get_avltree_nilnode[T]()
        return AvlTreeNode[T](p: nil_node, l: nil_node, r: nil_node, len: 1, h: 1, key: x)
    proc incl*[T](self: var AvlSortedMultiSet[T], x: T) =
        var node = newnode(x)
        self.root = self.root.insert(node)
    proc excl*[T](self: var AvlSortedMultiSet[T], x: T): bool {.discardable.} =
        if x notin self: return false
        var (_, node) = self.root.lower_bound_node(x)
        self.root = self.root.erase(node, node.next)
        return true
    proc `[]`*[T](self: AvlSortedMultiSet[T], idx: int): T =
        assert idx < self.root.len
        return self.root.get(idx).key
    proc pop*[T](self: var AvlSortedMultiSet[T], idx: int = -1): T =
        var idx = idx
        if idx < 0: idx = self.len - idx
        assert idx < self.root.len
        var node = self.root.get(idx)
        result = node.key
        self.root = self.root.erase(node, node.next)
    iterator items*[T](self: AvlSortedMultiSet[T]): T =
        var stack = @[(0, self.root)]
        while stack.len > 0:
            var (t, node) = stack.pop
            if t == 0:
                stack.add((1, node))
                if node.l != get_avltree_nilnode[T](): stack.add((0, node.l))
            elif t == 1:
                yield node.key
                if node.r != get_avltree_nilnode[T](): stack.add((0, node.r))
    proc initAvlSortedMultiSet*[T](v: seq[T] = @[]): AvlSortedMultiSet[T] =
        result = AvlSortedMultiSet[T](root: get_avltree_nilnode[T]())
