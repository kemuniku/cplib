when not declared CPLIB_COLLECTIONS_DYNAMIC_SEGTREE:
    const CPLIB_COLLECTIONS_DYNAMIC_SEGTREE* = 1

    type
        DynamicSegmentTreeNode[T] = ref object
            index: int
            value, product: T
            left, right: DynamicSegmentTreeNode[T]
        DynamicSegmentTree*[T] = ref object
            root: DynamicSegmentTreeNode[T]
            length, nodes: int
            merge: proc(x: T, y: T): T
            default: T

    proc initDynamicSegmentTree*[T](n: int, merge: proc(x: T, y: T): T,
                                   default: T): DynamicSegmentTree[T] =
        ## [0,n)を単位元で初期化します。O(1)時間・空間。mergeにはモノイドの演算を渡します。
        assert n >= 0
        DynamicSegmentTree[T](length: n, merge: merge, default: default)

    proc len*[T](self: DynamicSegmentTree[T]): int =
        ## 座標範囲の長さをO(1)で返します。
        self.length

    proc node_count*[T](self: DynamicSegmentTree[T]): int =
        ## 一度でも更新した異なる座標の数（確保したノード数）をO(1)で返します。
        self.nodes

    proc product[T](self: DynamicSegmentTree[T], node: DynamicSegmentTreeNode[T]): T =
        ## 空の部分木を単位元として、部分木の集約値をO(1)で返します。
        if node == nil: self.default else: node.product

    proc updateNode[T](self: DynamicSegmentTree[T], node: var DynamicSegmentTreeNode[T],
                       l, r, index: int, value: T) =
        ## 座標順と二分区間を保って挿入・上書きします。O(log N)時間、追加ノードは高々1個。
        if node == nil:
            node = DynamicSegmentTreeNode[T](index: index, value: value, product: value)
            inc self.nodes
            return
        if node.index == index:
            node.value = value
        else:
            let mid = l + (r - l) div 2
            var index = index
            var value = value
            if index < mid:
                if node.index < index:
                    swap(node.index, index)
                    swap(node.value, value)
                self.updateNode(node.left, l, mid, index, value)
            else:
                if index < node.index:
                    swap(node.index, index)
                    swap(node.value, value)
                self.updateNode(node.right, mid, r, index, value)
        node.product = self.merge(self.merge(self.product(node.left), node.value),
                                  self.product(node.right))

    proc update*[T](self: DynamicSegmentTree[T], index: Natural, value: T) =
        ## 1点をO(log N)で上書きします。Q回更新後の空間はO(Q)、同じ座標の再更新では増えません。
        assert index < self.length
        self.updateNode(self.root, 0, self.length, index, value)

    proc getNode[T](self: DynamicSegmentTree[T], node: DynamicSegmentTreeNode[T],
                    l, r, ql, qr: int): T =
        ## 二分区間で枝刈りし、座標順の区間積をO(log N)で返します。
        if node == nil or qr <= l or r <= ql:
            return self.default
        if ql <= l and r <= qr:
            return node.product
        let mid = l + (r - l) div 2
        result = self.getNode(node.left, l, mid, ql, qr)
        if ql <= node.index and node.index < qr:
            result = self.merge(result, node.value)
        result = self.merge(result, self.getNode(node.right, mid, r, ql, qr))

    proc get*[T](self: DynamicSegmentTree[T], q_left, q_right: Natural): T =
        ## 半開区間[q_left,q_right)の積をO(log N)で返します。ノードは確保しません。
        assert q_left <= q_right and q_right <= self.length
        if q_left == q_right:
            return self.default
        self.getNode(self.root, 0, self.length, q_left, q_right)

    proc get*[T](self: DynamicSegmentTree[T], segment: HSlice[int, int]): T =
        ## スライスで指定した区間の積をO(log N)で返します。
        assert 0 <= segment.a and segment.b < self.length
        self.get(segment.a, segment.b + 1)

    proc `[]`*[T](self: DynamicSegmentTree[T], segment: HSlice[int, int]): T =
        ## スライスで指定した区間の積をO(log N)で返します。
        self.get(segment)

    proc `[]`*[T](self: DynamicSegmentTree[T], index: Natural): T =
        ## 1点の値をO(log N)で返します。未更新の座標では単位元を返します。
        assert index < self.length
        var node = self.root
        while node != nil:
            if node.index == index:
                return node.value
            if index < node.index:
                node = node.left
            else:
                node = node.right
        self.default

    proc `[]=`*[T](self: DynamicSegmentTree[T], index: Natural, value: T) =
        ## 1点をO(log N)で上書きします。
        self.update(index, value)

    proc get_all*[T](self: DynamicSegmentTree[T]): T =
        ## 全区間の積をO(1)で返します。
        self.product(self.root)

    template newDynamicSegWith*(n, merge, default: untyped): untyped =
        ## lとrを使った式を演算として、動的セグメント木をO(1)で生成します。
        initDynamicSegmentTree[typeof(default)](n,
            proc(l {.inject.}, r {.inject.}: typeof(default)): typeof(default) = merge,
            default)
