when not declared CPLIB_COLLECTIONS_AVL_LAZYSEGTREE:
    const CPLIB_COLLECTIONS_AVL_LAZYSEGTREE* = 1
    import cplib/utils/backwards_index
    import sequtils, strutils

    type AvlLazySegmentTreeNode[S, F] = ref object
        left, right: AvlLazySegmentTreeNode[S, F]
        height: int
        size: int
        value, prod: S
        lazy: F
        hasLazy: bool

    type AvlLazySegmentTree*[S, F] = ref object
        root: AvlLazySegmentTreeNode[S, F]
        length: int
        merge: proc(x, y: S): S
        default: S
        mapping: proc(f: F, x: S): S
        composition: proc(f, g: F): F
        id: F

    proc nodeLen[S, F](node: AvlLazySegmentTreeNode[S, F]): int {.inline.} =
        ## 部分木の要素数を返します。O(1)。
        if node.isNil: 0 else: node.size

    proc nodeHeight[S, F](node: AvlLazySegmentTreeNode[S, F]): int {.inline.} =
        ## 部分木の高さを返します。O(1)。
        if node.isNil: 0 else: node.height

    proc nodeProd[S, F](node: AvlLazySegmentTreeNode[S, F], default: S): S {.inline.} =
        ## 部分木の総積を返します。O(1)。
        if node.isNil: default else: node.prod

    proc update[S, F](node: AvlLazySegmentTreeNode[S, F], merge: proc(x, y: S): S, default: S) =
        ## 子の情報からノードの集約値を更新します。O(1)。
        if node.isNil: return
        node.size = 1 + node.left.nodeLen + node.right.nodeLen
        node.height = 1 + max(node.left.nodeHeight, node.right.nodeHeight)
        node.prod = merge(merge(node.left.nodeProd(default), node.value), node.right.nodeProd(default))

    proc allApply[S, F](
        node: AvlLazySegmentTreeNode[S, F],
        f: F,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F
    ) =
        ## 部分木全体に作用を記録します。O(1)。
        if node.isNil: return
        node.value = mapping(f, node.value)
        node.prod = mapping(f, node.prod)
        if node.hasLazy:
            node.lazy = composition(f, node.lazy)
        else:
            node.lazy = f
            node.hasLazy = true

    proc push[S, F](
        node: AvlLazySegmentTreeNode[S, F],
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ) =
        ## 記録した作用を子へ伝播します。O(1)。
        if node.isNil or not node.hasLazy: return
        node.left.allApply(node.lazy, mapping, composition)
        node.right.allApply(node.lazy, mapping, composition)
        node.lazy = id
        node.hasLazy = false

    proc newNode[S, F](value: S, id: F): AvlLazySegmentTreeNode[S, F] =
        ## 一要素のノードを作ります。O(1)。
        AvlLazySegmentTreeNode[S, F](height: 1, size: 1, value: value, prod: value, lazy: id)

    proc buildRange[S, F](v: openArray[S], l, r: int, merge: proc(x, y: S): S, default: S, id: F): AvlLazySegmentTreeNode[S, F] =
        ## 指定区間から高さの釣り合った木を構築します。O(r-l)。
        if l == r: return nil
        let mid = (l + r) shr 1
        result = newNode(v[mid], id)
        result.left = buildRange(v, l, mid, merge, default, id)
        result.right = buildRange(v, mid + 1, r, merge, default, id)
        result.update(merge, default)

    proc build[S, F](v: openArray[S], merge: proc(x, y: S): S, default: S, id: F): AvlLazySegmentTreeNode[S, F] =
        ## 配列から AVL 木を構築します。O(N)。
        buildRange(v, 0, v.len, merge, default, id)


    proc rotateLeft[S, F](node: AvlLazySegmentTreeNode[S, F], merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlLazySegmentTreeNode[S, F] =
        ## 左回転し、集約値を更新します。O(1)。
        node.push(mapping, composition, id)
        var child = move(node.right)
        child.push(mapping, composition, id)
        node.right = move(child.left)
        child.left = node
        node.update(merge, default)
        child.update(merge, default)
        child

    proc rotateRight[S, F](node: AvlLazySegmentTreeNode[S, F], merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlLazySegmentTreeNode[S, F] =
        ## 右回転し、集約値を更新します。O(1)。
        node.push(mapping, composition, id)
        var child = move(node.left)
        child.push(mapping, composition, id)
        node.left = move(child.right)
        child.right = node
        node.update(merge, default)
        child.update(merge, default)
        child

    proc rebalance[S, F](node: AvlLazySegmentTreeNode[S, F], merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlLazySegmentTreeNode[S, F] =
        ## 部分木を AVL 条件に戻します。O(1)。
        node.push(mapping, composition, id)
        node.update(merge, default)
        if node.left.nodeHeight > node.right.nodeHeight + 1:
            if node.left.left.nodeHeight < node.left.right.nodeHeight:
                var child = move(node.left)
                node.left = child.rotateLeft(merge, default, mapping, composition, id)
            return node.rotateRight(merge, default, mapping, composition, id)
        if node.right.nodeHeight > node.left.nodeHeight + 1:
            if node.right.right.nodeHeight < node.right.left.nodeHeight:
                var child = move(node.right)
                node.right = child.rotateRight(merge, default, mapping, composition, id)
            return node.rotateLeft(merge, default, mapping, composition, id)
        node

    proc join[S, F](left, pivot, right: AvlLazySegmentTreeNode[S, F], merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlLazySegmentTreeNode[S, F] =
        ## 要素一つを挟んで二つの木を結合します。O(|hL-hR|+1)。
        if left.nodeHeight > right.nodeHeight + 1:
            left.push(mapping, composition, id)
            var branch = move(left.right)
            left.right = join(branch, pivot, right, merge, default, mapping, composition, id)
            return left.rebalance(merge, default, mapping, composition, id)
        if right.nodeHeight > left.nodeHeight + 1:
            right.push(mapping, composition, id)
            var branch = move(right.left)
            right.left = join(left, pivot, branch, merge, default, mapping, composition, id)
            return right.rebalance(merge, default, mapping, composition, id)
        pivot.push(mapping, composition, id)
        pivot.left = left
        pivot.right = right
        pivot.update(merge, default)
        pivot

    proc popMax[S, F](node: AvlLazySegmentTreeNode[S, F], merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): (AvlLazySegmentTreeNode[S, F], AvlLazySegmentTreeNode[S, F]) =
        ## 最大位置のノードを取り出します。O(log N)。
        node.push(mapping, composition, id)
        if node.right.isNil:
            var branch = move(node.left)
            result = (branch, node)
            node.update(merge, default)
        else:
            var branch = move(node.right)
            var (rest, pivot) = popMax(branch, merge, default, mapping, composition, id)
            node.right = rest
            result = (node.rebalance(merge, default, mapping, composition, id), pivot)

    proc mergeNode[S, F](left, right: AvlLazySegmentTreeNode[S, F], merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlLazySegmentTreeNode[S, F] =
        ## 二つの木を順序を保って結合します。O(log N)。
        if left.isNil: return right
        if right.isNil: return left
        var (rest, pivot) = popMax(left, merge, default, mapping, composition, id)
        join(rest, pivot, right, merge, default, mapping, composition, id)

    proc split[S, F](node: AvlLazySegmentTreeNode[S, F], k: int, merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): (AvlLazySegmentTreeNode[S, F], AvlLazySegmentTreeNode[S, F]) =
        ## 先頭 k 要素で木を分割します。O(log N)。
        if node.isNil: return (nil, nil)
        node.push(mapping, composition, id)
        let leftSize = node.left.nodeLen
        var leftTree = move(node.left)
        var rightTree = move(node.right)
        if k <= leftSize:
            var (left, middle) = split(leftTree, k, merge, default, mapping, composition, id)
            return (left, join(middle, node, rightTree, merge, default, mapping, composition, id))
        else:
            var (middle, right) = split(rightTree, k - leftSize - 1, merge, default, mapping, composition, id)
            return (join(leftTree, node, middle, merge, default, mapping, composition, id), right)

    proc initAvlLazySegmentTree*[S, F](
        v: openArray[S],
        merge: proc(x, y: S): S,
        default: S,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): AvlLazySegmentTree[S, F] =
        ## モノイドと遅延作用を持つ列を構築します。O(N)。
        AvlLazySegmentTree[S, F](
            root: build(v, merge, default, id),
            length: v.len,
            merge: merge,
            default: default,
            mapping: mapping,
            composition: composition,
            id: id
        )


    proc initAvlLazySegmentTree*[S, F](
        n: int,
        merge: proc(x, y: S): S,
        default: S,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): AvlLazySegmentTree[S, F] =
        ## モノイドと遅延作用を持つ列を構築します。O(N)。
        initAvlLazySegmentTree(newSeqWith(n, default), merge, default, mapping, composition, id)

    template newAvlLazySegWith*(vOrN, merge, default, mapping, composition, id: untyped): untyped =
        type S = typeof(default)
        type F = typeof(id)
        initAvlLazySegmentTree[S, F](
            vOrN,
            proc (l{.inject.}, r{.inject.}: S): S = merge,
            default, proc (f{.inject.}: F, x{.inject.}: S): S = mapping,
            proc (f{.inject.}, g{.inject.}: F): F = composition,
            id
        )

    proc len*[S, F](self: AvlLazySegmentTree[S, F]): int =
        ## 要素数を返します。O(1)。
        self.length

    proc mergeRoot[S, F](
        self: AvlLazySegmentTree[S, F],
        left, right: AvlLazySegmentTreeNode[S, F]
    ): AvlLazySegmentTreeNode[S, F] =
        ## 二つの木を順序を保って結合します。O(log N)。
        mergeNode(left, right, self.merge, self.default, self.mapping, self.composition, self.id)

    proc splitRoot[S, F](
        self: AvlLazySegmentTree[S, F],
        node: AvlLazySegmentTreeNode[S, F],
        k: int
    ): (AvlLazySegmentTreeNode[S, F], AvlLazySegmentTreeNode[S, F]) =
        ## 先頭 k 要素で木を分割します。O(log N)。
        split(node, k, self.merge, self.default, self.mapping, self.composition, self.id)

    proc split*[S, F](self: AvlLazySegmentTree[S, F], k: int): (AvlLazySegmentTree[S, F], AvlLazySegmentTree[S, F]) =
        ## 先頭 k 要素で分割し、元の列を空にします。O(log N)。
        assert 0 <= k and k <= self.length, "0 <= k <= len が必要です"
        let n = self.length
        var root = move(self.root)
        let (leftRoot, rightRoot) = self.splitRoot(root, k)
        self.length = 0
        result = (
            AvlLazySegmentTree[S, F](root: leftRoot, length: k, merge: self.merge, default: self.default, mapping: self.mapping, composition: self.composition, id: self.id),
            AvlLazySegmentTree[S, F](root: rightRoot, length: n - k, merge: self.merge, default: self.default, mapping: self.mapping, composition: self.composition, id: self.id)
        )

    proc merge*[S, F](left, right: AvlLazySegmentTree[S, F]): AvlLazySegmentTree[S, F] =
        ## 左右の列を連結し、両方の元の列を空にします。同じ演算が必要です。O(log N)。
        assert left != right, "同じ列を連結できません"
        let n = left.length + right.length
        var leftRoot = move(left.root)
        var rightRoot = move(right.root)
        result = AvlLazySegmentTree[S, F](root: left.mergeRoot(leftRoot, rightRoot), length: n, merge: left.merge, default: left.default, mapping: left.mapping, composition: left.composition, id: left.id)
        left.length = 0
        right.length = 0


    proc insertNode[S, F](self: AvlLazySegmentTree[S, F], root, node: AvlLazySegmentTreeNode[S, F], k: int): AvlLazySegmentTreeNode[S, F] =
        ## 指定位置にノードを挿入します。O(log N)。
        if root.isNil: return node
        root.push(self.mapping, self.composition, self.id)
        let leftSize = root.left.nodeLen
        if k <= leftSize:
            var branch = move(root.left)
            root.left = self.insertNode(branch, node, k)
        else:
            var branch = move(root.right)
            root.right = self.insertNode(branch, node, k - leftSize - 1)
        root.rebalance(self.merge, self.default, self.mapping, self.composition, self.id)

    proc eraseNode[S, F](self: AvlLazySegmentTree[S, F], root: AvlLazySegmentTreeNode[S, F], k: int): AvlLazySegmentTreeNode[S, F] =
        ## 指定位置のノードを削除します。O(log N)。
        root.push(self.mapping, self.composition, self.id)
        let leftSize = root.left.nodeLen
        if k == leftSize:
            var left = move(root.left)
            var right = move(root.right)
            return self.mergeRoot(left, right)
        if k < leftSize:
            var branch = move(root.left)
            root.left = self.eraseNode(branch, k)
        else:
            var branch = move(root.right)
            root.right = self.eraseNode(branch, k - leftSize - 1)
        root.rebalance(self.merge, self.default, self.mapping, self.composition, self.id)

    proc insert*[S, F](self: AvlLazySegmentTree[S, F], index: int, value: S) =
        ## index の直前に value を挿入する。末尾には index = len を指定する。
        ## O(log N)。挿入前の区間更新は新しい要素には作用しない。
        assert 0 <= index and index <= self.length, "指定した値が有効な範囲内である必要があります: 0 <= index and index <= self.length"
        let node = newNode(value, self.id)
        var root = move(self.root)
        self.root = self.insertNode(root, node, index)
        inc self.length

    proc insort*[S, F](self: AvlLazySegmentTree[S, F], value: S, less: proc(x, y: S): bool): int {.discardable.} =
        ## ソート済みの列へ同値の末尾となる位置に挿入し、その位置を返します。O(log N)。
        var node = self.root
        while not node.isNil:
            node.push(self.mapping, self.composition, self.id)
            if less(value, node.value):
                node = node.left
            else:
                result += node.left.nodeLen + 1
                node = node.right
        self.insert(result, value)

    proc insort*[S, F](self: AvlLazySegmentTree[S, F], value: S): int {.discardable.} =
        ## < でソート済みの列へ同値の末尾となる位置に挿入します。O(log N)。
        self.insort(value, proc(x, y: S): bool = x < y)

    proc erase*[S, F](self: AvlLazySegmentTree[S, F], l, r: int) =
        ## 半開区間 [l, r) を削除する。木の操作はO(log N)。
        ## 削除した K 個のノードの解放には別途 O(K) かかりうる。
        assert 0 <= l and l <= r and r <= self.length, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.length"
        if l == r: return
        var (left, middleRight) = self.splitRoot(self.root, l)
        var (_, right) = self.splitRoot(middleRight, r - l)
        self.root = self.mergeRoot(left, right)
        self.length -= r - l

    proc erase*[S, F](self: AvlLazySegmentTree[S, F], index: int) =
        ## index 番目の要素を削除する。O(log N)。
        assert 0 <= index and index < self.length, "指定した値が有効な範囲内である必要があります: 0 <= index and index < self.length"
        var root = move(self.root)
        self.root = self.eraseNode(root, index)
        dec self.length

    proc erase*[S, F](self: AvlLazySegmentTree[S, F], segment: HSlice[int, int]) =
        ## 指定位置または区間の要素を削除します。木の操作はO(log N)。
        self.erase(segment.a, segment.b + 1)

    proc apply*[S, F](self: AvlLazySegmentTree[S, F], l, r: int, f: F) =
        ## 指定位置または区間に作用を適用します。O(log N)。
        assert 0 <= l and l <= r and r <= self.length, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.length"
        var (left, middleRight) = self.splitRoot(self.root, l)
        var (middle, right) = self.splitRoot(middleRight, r - l)
        middle.allApply(f, self.mapping, self.composition)
        self.root = self.mergeRoot(left, self.mergeRoot(middle, right))

    proc applyNode[S, F](self: AvlLazySegmentTree[S, F], node: AvlLazySegmentTreeNode[S, F], k: int, f: F) =
        ## 指定位置に作用を適用して総積を更新します。O(log N)。
        node.push(self.mapping, self.composition, self.id)
        let leftSize = node.left.nodeLen
        if k < leftSize:
            self.applyNode(node.left, k, f)
        elif k == leftSize:
            node.value = self.mapping(f, node.value)
        else:
            self.applyNode(node.right, k - leftSize - 1, f)
        node.update(self.merge, self.default)

    proc apply*[S, F](self: AvlLazySegmentTree[S, F], index: int, f: F) =
        ## 指定位置または区間に作用を適用します。O(log N)。
        assert 0 <= index and index < self.length, "指定した値が有効な範囲内である必要があります: 0 <= index and index < self.length"
        self.applyNode(self.root, index, f)

    proc apply*[S, F](self: AvlLazySegmentTree[S, F], segment: HSlice[int, int], f: F) =
        ## 指定位置または区間に作用を適用します。O(log N)。
        self.apply(segment.a, segment.b + 1, f)

    proc get*[S, F](self: AvlLazySegmentTree[S, F], l, r: int): S =
        ## 指定位置の値または区間の総積を返します。O(log N)。
        assert 0 <= l and l <= r and r <= self.length, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.length"
        var (left, middleRight) = self.splitRoot(self.root, l)
        var (middle, right) = self.splitRoot(middleRight, r - l)
        result = middle.nodeProd(self.default)
        self.root = self.mergeRoot(left, self.mergeRoot(middle, right))

    proc get*[S, F](self: AvlLazySegmentTree[S, F], segment: HSlice[int, int]): S =
        ## 指定位置の値または区間の総積を返します。O(log N)。
        self.get(segment.a, segment.b + 1)

    proc fold*[S, F](self: AvlLazySegmentTree[S, F], l, r: int): S =
        ## 指定区間または全体の総積を返します。区間はO(log N)、全体は O(1)。
        self.get(l, r)

    proc fold*[S, F](self: AvlLazySegmentTree[S, F], segment: HSlice[int, int]): S =
        ## 指定区間または全体の総積を返します。区間はO(log N)、全体は O(1)。
        self.get(segment)

    proc fold*[S, F](self: AvlLazySegmentTree[S, F]): S =
        ## 指定区間または全体の総積を返します。区間はO(log N)、全体は O(1)。
        self.root.nodeProd(self.default)

    proc get_all*[S, F](self: AvlLazySegmentTree[S, F]): S =
        ## 全要素の総積を返します。O(1)。
        self.root.nodeProd(self.default)

    proc max_right*[S, F](self: AvlLazySegmentTree[S, F], l: int, f: proc(x: S): bool): int =
        ## f(get(l, r)) が真となる最大の r。O(log N)。
        ## f(default) = true で、区間を伸ばしたとき真から偽への変化が単調であること。
        assert 0 <= l and l <= self.length, "指定した値が有効な範囲内である必要があります: 0 <= l and l <= self.length"
        assert f(self.default), "判定関数は単位元に対してtrueを返す必要があります"
        var (left, right) = self.splitRoot(self.root, l)
        var node = right
        var acc = self.default
        result = l
        while not node.isNil:
            node.push(self.mapping, self.composition, self.id)
            let next = self.merge(acc, node.left.nodeProd(self.default))
            if not f(next):
                node = node.left
            else:
                acc = next
                result += node.left.nodeLen
                let withValue = self.merge(acc, node.value)
                if not f(withValue): break
                acc = withValue
                inc result
                node = node.right
        self.root = self.mergeRoot(left, right)

    proc min_left*[S, F](self: AvlLazySegmentTree[S, F], r: int, f: proc(x: S): bool): int =
        ## f(get(l, r)) が真となる最小の l。O(log N)。
        ## f(default) = true で、区間を伸ばしたとき真から偽への変化が単調であること。
        assert 0 <= r and r <= self.length, "指定した値が有効な範囲内である必要があります: 0 <= r and r <= self.length"
        assert f(self.default), "判定関数は単位元に対してtrueを返す必要があります"
        var (left, right) = self.splitRoot(self.root, r)
        var node = left
        var acc = self.default
        result = r
        while not node.isNil:
            node.push(self.mapping, self.composition, self.id)
            let next = self.merge(node.right.nodeProd(self.default), acc)
            if not f(next):
                node = node.right
            else:
                acc = next
                result -= node.right.nodeLen
                let withValue = self.merge(node.value, acc)
                if not f(withValue): break
                acc = withValue
                dec result
                node = node.left
        self.root = self.mergeRoot(left, right)

    proc get*[S, F](self: AvlLazySegmentTree[S, F], index: int): S =
        ## 指定位置の値または区間の総積を返します。O(log N)。
        assert 0 <= index and index < self.length, "指定した値が有効な範囲内である必要があります: 0 <= index and index < self.length"
        var node = self.root
        var k = index
        while true:
            node.push(self.mapping, self.composition, self.id)
            let leftSize = node.left.nodeLen
            if k < leftSize:
                node = node.left
            elif k == leftSize:
                return node.value
            else:
                k -= leftSize + 1
                node = node.right

    proc updateNode[S, F](self: AvlLazySegmentTree[S, F], node: AvlLazySegmentTreeNode[S, F], k: int, value: S) =
        ## 指定位置の値を置き換えて総積を更新します。O(log N)。
        node.push(self.mapping, self.composition, self.id)
        let leftSize = node.left.nodeLen
        if k < leftSize:
            self.updateNode(node.left, k, value)
        elif k == leftSize:
            node.value = value
        else:
            self.updateNode(node.right, k - leftSize - 1, value)
        node.update(self.merge, self.default)

    proc update*[S, F](self: AvlLazySegmentTree[S, F], index: Natural, value: S) =
        ## 指定位置の値を置き換えます。O(log N)。
        assert index < self.length, "指定した値が有効な範囲内である必要があります: index < self.length"
        self.updateNode(self.root, int(index), value)

    proc `[]`*[S, F](self: AvlLazySegmentTree[S, F], index: int): S =
        ## 指定位置の値または区間の総積を返します。O(log N)。
        self.get(index)

    proc `[]`*[S, F](self: AvlLazySegmentTree[S, F], index: BackwardsIndex): S =
        ## 指定位置の値または区間の総積を返します。O(log N)。
        self.get(self.length - int(index))

    proc `[]`*[S, F](self: AvlLazySegmentTree[S, F], segment: HSlice[int, int]): S =
        ## 指定位置の値または区間の総積を返します。O(log N)。
        self.get(segment)

    proc `[]=`*[S, F](self: AvlLazySegmentTree[S, F], index: Natural, value: S) {.backwardsIndex.} =
        ## 指定位置の値を更新します。O(log N)。
        self.update(index, value)

    iterator items*[S, F](self: AvlLazySegmentTree[S, F]): S =
        if not self.root.isNil:
            var stack = @[(0, self.root)]
            while stack.len > 0:
                var (t, node) = stack.pop()
                node.push(self.mapping, self.composition, self.id)
                if t == 0:
                    if not node.right.isNil: stack.add((0, node.right))
                    stack.add((1, node))
                    if not node.left.isNil: stack.add((0, node.left))
                else:
                    yield node.value

    proc toSeq*[S, F](self: AvlLazySegmentTree[S, F]): seq[S] =
        ## 全要素を配列として返します。O(N)。
        for x in self:
            result.add(x)

    proc `$`*[S, F](self: AvlLazySegmentTree[S, F]): string =
        ## 全要素の文字列表現を返します。O(N)。
        var s: seq[string]
        for x in self:
            s.add($x)
        return s.join(" ")
