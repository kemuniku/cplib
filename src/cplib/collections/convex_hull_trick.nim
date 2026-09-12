when not declared CPLIB_COLLECTIONS_CONVEX_HULL_TRICK:
    const CPLIB_COLLECTIONS_CONVEX_HULL_TRICK* = 1
    import cplib/math/int128
    import cplib/collections/avltreenode
    import cplib/collections/private/convex_hull_trick_impl

    type ConvexHullTrick* = object
        root: AvlTreeNode[CHTLine]

    proc initConvexHullTrick*(): ConvexHullTrick =
        ## 傾き・クエリ座標が任意の最小値CHTを初期化します。O(1)。
        ConvexHullTrick()

    proc chtSetStart(node, previous: AvlTreeNode[CHTLine]) =
        ## 直線が最小になる区間の左端を更新します。O(1)。
        if not node.isNil:
            node.key.start = if previous.isNil: -(to_Int128(1) << 65)
                             else: chtStart(previous.key, node.key)

    proc add_line*(self: var ConvexHullTrick, a, b: int) =
        ## 任意の傾きのax+bを追加します。償却O(log N)。
        let line = CHTLine(a: a, b: b)
        var (left, right) = self.root.lower_bound_node(line)
        if not right.isNil and right.key.a == a:
            if right.key.b <= b: return
            let next = right.next
            self.root = self.root.erase(right, next)
            right = next
        if not left.isNil and not right.isNil and chtRedundant(left.key, line, right.key):
            return
        while not left.isNil:
            let previous = left.prev
            if previous.isNil or not chtRedundant(previous.key, left.key, line): break
            self.root = self.root.erase(left, right)
            left = previous
        while not right.isNil:
            let next = right.next
            if next.isNil or not chtRedundant(line, right.key, next.key): break
            self.root = self.root.erase(right, next)
            right = next
        let node = AvlTreeNode[CHTLine](key: line, h: 1, len: 1)
        chtSetStart(node, left)
        chtSetStart(right, node)
        self.root = self.root.insert(node)

    proc get_min*(self: ConvexHullTrick, x: int): int =
        ## 任意の整数座標xでの最小値を返します。座標の事前登録は不要。空の場合はassert。O(log N)。
        assert not self.root.isNil, "CHT: no lines"
        var node = self.root
        var best: AvlTreeNode[CHTLine]
        let coordinate = to_Int128(x)
        while not node.isNil:
            if node.key.start <= coordinate:
                best = node
                node = node.r
            else:
                node = node.l
        chtAnswer(chtValue(best.key, x))
