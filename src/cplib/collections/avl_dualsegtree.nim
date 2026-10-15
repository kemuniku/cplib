when not declared CPLIB_COLLECTIONS_AVL_DUALSEGTREE:
    const CPLIB_COLLECTIONS_AVL_DUALSEGTREE* = 1
    import cplib/utils/backwards_index
    import sequtils, strutils

    type AvlDualSegmentTreeNode[S, F] = ref object
        left, right: AvlDualSegmentTreeNode[S, F]
        height: int
        size: int
        value: S
        lazy: F
        hasLazy: bool

    type AvlDualSegmentTree*[S, F] = ref object
        root: AvlDualSegmentTreeNode[S, F]
        length: int
        mapping: proc(f: F, x: S): S
        composition: proc(f, g: F): F
        id: F

    proc nodeLen[S, F](node: AvlDualSegmentTreeNode[S, F]): int {.inline.} =
        ## 部分木の要素数を返します。O(1)。
        if node.isNil: 0 else: node.size

    proc nodeHeight[S, F](node: AvlDualSegmentTreeNode[S, F]): int {.inline.} =
        ## 部分木の高さを返します。O(1)。
        if node.isNil: 0 else: node.height

    proc update[S, F](node: AvlDualSegmentTreeNode[S, F]) =
        ## 子の情報からノードの要素数と高さを更新します。O(1)。
        if node.isNil: return
        node.size = 1 + node.left.nodeLen + node.right.nodeLen
        node.height = 1 + max(node.left.nodeHeight, node.right.nodeHeight)

    proc allApply[S, F](
        node: AvlDualSegmentTreeNode[S, F],
        f: F,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F
    ) =
        ## 部分木全体に作用を記録します。O(1)。
        if node.isNil: return
        node.value = mapping(f, node.value)
        if node.hasLazy:
            node.lazy = composition(f, node.lazy)
        else:
            node.lazy = f
            node.hasLazy = true

    proc push[S, F](
        node: AvlDualSegmentTreeNode[S, F],
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

    proc newNode[S, F](value: S, id: F): AvlDualSegmentTreeNode[S, F] =
        ## 一要素のノードを作ります。O(1)。
        AvlDualSegmentTreeNode[S, F](height: 1, size: 1, value: value, lazy: id)

    proc buildRange[S, F](v: openArray[S], l, r: int, id: F): AvlDualSegmentTreeNode[S, F] =
        ## 指定区間から高さの釣り合った木を構築します。O(r-l)。
        if l == r: return nil
        let mid = (l + r) shr 1
        result = newNode(v[mid], id)
        result.left = buildRange(v, l, mid, id)
        result.right = buildRange(v, mid + 1, r, id)
        result.update

    proc build[S, F](v: openArray[S], id: F): AvlDualSegmentTreeNode[S, F] =
        ## 配列から AVL 木を構築します。O(N)。
        buildRange(v, 0, v.len, id)


    proc rotateLeft[S, F](node: AvlDualSegmentTreeNode[S, F], mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlDualSegmentTreeNode[S, F] =
        ## 左回転し、集約値を更新します。O(1)。
        node.push(mapping, composition, id)
        var child = move(node.right)
        child.push(mapping, composition, id)
        node.right = move(child.left)
        child.left = node
        node.update
        child.update
        child

    proc rotateRight[S, F](node: AvlDualSegmentTreeNode[S, F], mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlDualSegmentTreeNode[S, F] =
        ## 右回転し、集約値を更新します。O(1)。
        node.push(mapping, composition, id)
        var child = move(node.left)
        child.push(mapping, composition, id)
        node.left = move(child.right)
        child.right = node
        node.update
        child.update
        child

    proc rebalance[S, F](node: AvlDualSegmentTreeNode[S, F], mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlDualSegmentTreeNode[S, F] =
        ## 部分木を AVL 条件に戻します。O(1)。
        node.push(mapping, composition, id)
        node.update
        if node.left.nodeHeight > node.right.nodeHeight + 1:
            if node.left.left.nodeHeight < node.left.right.nodeHeight:
                var child = move(node.left)
                node.left = child.rotateLeft(mapping, composition, id)
            return node.rotateRight(mapping, composition, id)
        if node.right.nodeHeight > node.left.nodeHeight + 1:
            if node.right.right.nodeHeight < node.right.left.nodeHeight:
                var child = move(node.right)
                node.right = child.rotateRight(mapping, composition, id)
            return node.rotateLeft(mapping, composition, id)
        node

    proc join[S, F](left, pivot, right: AvlDualSegmentTreeNode[S, F], mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlDualSegmentTreeNode[S, F] =
        ## 要素一つを挟んで二つの木を結合します。O(|hL-hR|+1)。
        if left.nodeHeight > right.nodeHeight + 1:
            left.push(mapping, composition, id)
            var branch = move(left.right)
            left.right = join(branch, pivot, right, mapping, composition, id)
            return left.rebalance(mapping, composition, id)
        if right.nodeHeight > left.nodeHeight + 1:
            right.push(mapping, composition, id)
            var branch = move(right.left)
            right.left = join(left, pivot, branch, mapping, composition, id)
            return right.rebalance(mapping, composition, id)
        pivot.push(mapping, composition, id)
        pivot.left = left
        pivot.right = right
        pivot.update
        pivot

    proc popMax[S, F](node: AvlDualSegmentTreeNode[S, F], mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): (AvlDualSegmentTreeNode[S, F], AvlDualSegmentTreeNode[S, F]) =
        ## 最大位置のノードを取り出します。O(log N)。
        node.push(mapping, composition, id)
        if node.right.isNil:
            var branch = move(node.left)
            result = (branch, node)
            node.update
        else:
            var branch = move(node.right)
            var (rest, pivot) = popMax(branch, mapping, composition, id)
            node.right = rest
            result = (node.rebalance(mapping, composition, id), pivot)

    proc mergeNode[S, F](left, right: AvlDualSegmentTreeNode[S, F], mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlDualSegmentTreeNode[S, F] =
        ## 二つの木を順序を保って結合します。O(log N)。
        if left.isNil: return right
        if right.isNil: return left
        var (rest, pivot) = popMax(left, mapping, composition, id)
        join(rest, pivot, right, mapping, composition, id)

    proc split[S, F](node: AvlDualSegmentTreeNode[S, F], k: int, mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): (AvlDualSegmentTreeNode[S, F], AvlDualSegmentTreeNode[S, F]) =
        ## 先頭 k 要素で木を分割します。O(log N)。
        if node.isNil: return (nil, nil)
        node.push(mapping, composition, id)
        let leftSize = node.left.nodeLen
        var leftTree = move(node.left)
        var rightTree = move(node.right)
        if k <= leftSize:
            var (left, middle) = split(leftTree, k, mapping, composition, id)
            return (left, join(middle, node, rightTree, mapping, composition, id))
        else:
            var (middle, right) = split(rightTree, k - leftSize - 1, mapping, composition, id)
            return (join(leftTree, node, middle, mapping, composition, id), right)

    proc initAvlDualSegmentTree*[S, F](
        v: openArray[S],
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): AvlDualSegmentTree[S, F] =
        ## 区間作用を持つ列を構築します。O(N)。
        AvlDualSegmentTree[S, F](root: build(v, id), length: v.len, mapping: mapping, composition: composition, id: id)


    proc initAvlDualSegmentTree*[S, F](
        n: int,
        initValue: S,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): AvlDualSegmentTree[S, F] =
        ## 区間作用を持つ列を構築します。O(N)。
        initAvlDualSegmentTree(newSeqWith(n, initValue), mapping, composition, id)

    template newAvlDualSegWith*(v, mapping, composition, id: untyped): untyped =
        type S = typeof(v[0])
        type F = typeof(id)
        initAvlDualSegmentTree[S, F](
            v,
            proc (f{.inject.}: F, x{.inject.}: S): S = mapping,
            proc (f{.inject.}, g{.inject.}: F): F = composition,
            id
        )

    template newAvlDualSegWith*(n, initValue, mapping, composition, id: untyped): untyped =
        type S = typeof(initValue)
        type F = typeof(id)
        initAvlDualSegmentTree[S, F](
            n,
            initValue,
            proc (f{.inject.}: F, x{.inject.}: S): S = mapping,
            proc (f{.inject.}, g{.inject.}: F): F = composition,
            id
        )

    proc len*[S, F](self: AvlDualSegmentTree[S, F]): int =
        ## 要素数を返します。O(1)。
        self.length

    proc mergeRoot[S, F](
        self: AvlDualSegmentTree[S, F],
        left, right: AvlDualSegmentTreeNode[S, F]
    ): AvlDualSegmentTreeNode[S, F] =
        ## 二つの木を順序を保って結合します。O(log N)。
        mergeNode(left, right, self.mapping, self.composition, self.id)

    proc splitRoot[S, F](
        self: AvlDualSegmentTree[S, F],
        node: AvlDualSegmentTreeNode[S, F],
        k: int
    ): (AvlDualSegmentTreeNode[S, F], AvlDualSegmentTreeNode[S, F]) =
        ## 先頭 k 要素で木を分割します。O(log N)。
        split(node, k, self.mapping, self.composition, self.id)

    proc split*[S, F](self: AvlDualSegmentTree[S, F], k: int): (AvlDualSegmentTree[S, F], AvlDualSegmentTree[S, F]) =
        ## 先頭 k 要素で分割し、元の列を空にします。O(log N)。
        assert 0 <= k and k <= self.length, "0 <= k <= len が必要です"
        let n = self.length
        var root = move(self.root)
        let (leftRoot, rightRoot) = self.splitRoot(root, k)
        self.length = 0
        result = (
            AvlDualSegmentTree[S, F](root: leftRoot, length: k, mapping: self.mapping, composition: self.composition, id: self.id),
            AvlDualSegmentTree[S, F](root: rightRoot, length: n - k, mapping: self.mapping, composition: self.composition, id: self.id)
        )

    proc merge*[S, F](left, right: AvlDualSegmentTree[S, F]): AvlDualSegmentTree[S, F] =
        ## 左右の列を連結し、両方の元の列を空にします。同じ演算が必要です。O(log N)。
        assert left != right, "同じ列を連結できません"
        let n = left.length + right.length
        var leftRoot = move(left.root)
        var rightRoot = move(right.root)
        result = AvlDualSegmentTree[S, F](root: left.mergeRoot(leftRoot, rightRoot), length: n, mapping: left.mapping, composition: left.composition, id: left.id)
        left.length = 0
        right.length = 0


    proc insertNode[S, F](self: AvlDualSegmentTree[S, F], root, node: AvlDualSegmentTreeNode[S, F], k: int): AvlDualSegmentTreeNode[S, F] =
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
        root.rebalance(self.mapping, self.composition, self.id)

    proc eraseNode[S, F](self: AvlDualSegmentTree[S, F], root: AvlDualSegmentTreeNode[S, F], k: int): AvlDualSegmentTreeNode[S, F] =
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
        root.rebalance(self.mapping, self.composition, self.id)

    proc insert*[S, F](self: AvlDualSegmentTree[S, F], index: int, value: S) =
        ## index の直前に value を挿入する。末尾には index = len を指定する。
        ## O(log N)。挿入前の区間更新は新しい要素には作用しない。
        assert 0 <= index and index <= self.length, "指定した値が有効な範囲内である必要があります: 0 <= index and index <= self.length"
        let node = newNode(value, self.id)
        var root = move(self.root)
        self.root = self.insertNode(root, node, index)
        inc self.length

    proc insort*[S, F](self: AvlDualSegmentTree[S, F], value: S, less: proc(x, y: S): bool): int {.discardable.} =
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

    proc insort*[S, F](self: AvlDualSegmentTree[S, F], value: S): int {.discardable.} =
        ## < でソート済みの列へ同値の末尾となる位置に挿入します。O(log N)。
        self.insort(value, proc(x, y: S): bool = x < y)

    proc erase*[S, F](self: AvlDualSegmentTree[S, F], l, r: int) =
        ## 半開区間 [l, r) を削除する。木の操作はO(log N)。
        ## 削除した K 個のノードの解放には別途 O(K) かかりうる。
        assert 0 <= l and l <= r and r <= self.length, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.length"
        if l == r: return
        var (left, middleRight) = self.splitRoot(self.root, l)
        var (_, right) = self.splitRoot(middleRight, r - l)
        self.root = self.mergeRoot(left, right)
        self.length -= r - l

    proc erase*[S, F](self: AvlDualSegmentTree[S, F], index: int) =
        ## index 番目の要素を削除する。O(log N)。
        assert 0 <= index and index < self.length, "指定した値が有効な範囲内である必要があります: 0 <= index and index < self.length"
        var root = move(self.root)
        self.root = self.eraseNode(root, index)
        dec self.length

    proc erase*[S, F](self: AvlDualSegmentTree[S, F], segment: HSlice[int, int]) =
        ## 指定位置または区間の要素を削除します。木の操作はO(log N)。
        self.erase(segment.a, segment.b + 1)

    proc apply*[S, F](self: AvlDualSegmentTree[S, F], l, r: int, f: F) =
        ## 指定位置または区間に作用を適用します。O(log N)。
        assert 0 <= l and l <= r and r <= self.length, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.length"
        var (left, middleRight) = self.splitRoot(self.root, l)
        var (middle, right) = self.splitRoot(middleRight, r - l)
        middle.allApply(f, self.mapping, self.composition)
        self.root = self.mergeRoot(left, self.mergeRoot(middle, right))

    proc apply*[S, F](self: AvlDualSegmentTree[S, F], index: int, f: F) =
        ## 指定位置または区間に作用を適用します。O(log N)。
        assert 0 <= index and index < self.length, "指定した値が有効な範囲内である必要があります: 0 <= index and index < self.length"
        var node = self.root
        var k = index
        while true:
            node.push(self.mapping, self.composition, self.id)
            let leftSize = node.left.nodeLen
            if k < leftSize:
                node = node.left
            elif k == leftSize:
                node.value = self.mapping(f, node.value)
                return
            else:
                k -= leftSize + 1
                node = node.right

    proc apply*[S, F](self: AvlDualSegmentTree[S, F], segment: HSlice[int, int], f: F) =
        ## 指定位置または区間に作用を適用します。O(log N)。
        self.apply(segment.a, segment.b + 1, f)

    proc get*[S, F](self: AvlDualSegmentTree[S, F], index: int): S =
        ## 指定位置の値を返します。O(log N)。
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

    proc update*[S, F](self: AvlDualSegmentTree[S, F], index: Natural, value: S) =
        ## 指定位置の値を置き換えます。O(log N)。
        assert index < self.length, "指定した値が有効な範囲内である必要があります: index < self.length"
        var node = self.root
        var k = int(index)
        while true:
            node.push(self.mapping, self.composition, self.id)
            let leftSize = node.left.nodeLen
            if k < leftSize:
                node = node.left
            elif k == leftSize:
                node.value = value
                return
            else:
                k -= leftSize + 1
                node = node.right

    proc `[]`*[S, F](self: AvlDualSegmentTree[S, F], index: int): S =
        ## 指定位置の値を返します。O(log N)。
        self.get(index)

    proc `[]`*[S, F](self: AvlDualSegmentTree[S, F], index: BackwardsIndex): S =
        ## 末尾から指定した位置の値を返します。O(log N)。
        self.get(self.length - int(index))

    proc `[]=`*[S, F](self: AvlDualSegmentTree[S, F], index: Natural, value: S) {.backwardsIndex.} =
        ## 指定位置の値を更新します。O(log N)。
        self.update(index, value)

    iterator items*[S, F](self: AvlDualSegmentTree[S, F]): S =
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

    proc toSeq*[S, F](self: AvlDualSegmentTree[S, F]): seq[S] =
        ## 全要素を配列として返します。O(N)。
        for x in self:
            result.add(x)

    proc `$`*[S, F](self: AvlDualSegmentTree[S, F]): string =
        ## 全要素の文字列表現を返します。O(N)。
        var s: seq[string]
        for x in self:
            s.add($x)
        return s.join(" ")
