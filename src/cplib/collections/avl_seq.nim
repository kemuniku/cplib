when not declared CPLIB_COLLECTIONS_AVL_SEQ:
    const CPLIB_COLLECTIONS_AVL_SEQ* = 1
    import cplib/utils/backwards_index
    import strutils

    type AvlSeqNode[T] = ref object
        left, right: AvlSeqNode[T]
        height: int
        size: int
        value: T

    type AvlSeq*[T] = ref object
        root: AvlSeqNode[T]
        length: int

    proc nodeLen[T](node: AvlSeqNode[T]): int {.inline.} =
        ## 部分木の要素数を返します。O(1)。
        if node.isNil: 0 else: node.size

    proc nodeHeight[T](node: AvlSeqNode[T]): int {.inline.} =
        ## 部分木の高さを返します。O(1)。
        if node.isNil: 0 else: node.height

    proc update[T](node: AvlSeqNode[T]) =
        ## 子の情報から要素数と高さを更新します。O(1)。
        node.size = 1 + node.left.nodeLen + node.right.nodeLen
        node.height = 1 + max(node.left.nodeHeight, node.right.nodeHeight)

    proc newNode[T](value: T): AvlSeqNode[T] =
        ## 一要素のノードを作ります。O(1)。
        AvlSeqNode[T](height: 1, size: 1, value: value)

    proc buildRange[T](v: openArray[T], l, r: int): AvlSeqNode[T] =
        ## 指定区間から高さの釣り合った木を構築します。O(r-l)。
        if l == r: return nil
        let mid = (l + r) shr 1
        result = newNode(v[mid])
        result.left = buildRange(v, l, mid)
        result.right = buildRange(v, mid + 1, r)
        result.update

    proc rotateLeft[T](node: AvlSeqNode[T]): AvlSeqNode[T] =
        ## 左回転して要素数と高さを更新します。O(1)。
        var child = move(node.right)
        node.right = move(child.left)
        child.left = node
        node.update
        child.update
        child

    proc rotateRight[T](node: AvlSeqNode[T]): AvlSeqNode[T] =
        ## 右回転して要素数と高さを更新します。O(1)。
        var child = move(node.left)
        node.left = move(child.right)
        child.right = node
        node.update
        child.update
        child

    proc rebalance[T](node: AvlSeqNode[T]): AvlSeqNode[T] =
        ## 部分木を AVL 条件に戻します。O(1)。
        node.update
        if node.left.nodeHeight > node.right.nodeHeight + 1:
            if node.left.left.nodeHeight < node.left.right.nodeHeight:
                var child = move(node.left)
                node.left = child.rotateLeft
            return node.rotateRight
        if node.right.nodeHeight > node.left.nodeHeight + 1:
            if node.right.right.nodeHeight < node.right.left.nodeHeight:
                var child = move(node.right)
                node.right = child.rotateRight
            return node.rotateLeft
        node

    proc join[T](left, pivot, right: AvlSeqNode[T]): AvlSeqNode[T] =
        ## 一要素を挟んで二つの木を結合します。O(|hL-hR|+1)。
        if left.nodeHeight > right.nodeHeight + 1:
            var branch = move(left.right)
            left.right = join(branch, pivot, right)
            return left.rebalance
        if right.nodeHeight > left.nodeHeight + 1:
            var branch = move(right.left)
            right.left = join(left, pivot, branch)
            return right.rebalance
        pivot.left = left
        pivot.right = right
        pivot.update
        pivot

    proc popMax[T](node: AvlSeqNode[T]): (AvlSeqNode[T], AvlSeqNode[T]) =
        ## 最大位置のノードを取り出します。O(log N)。
        if node.right.isNil:
            var branch = move(node.left)
            result = (branch, node)
            node.update
        else:
            var branch = move(node.right)
            var (rest, pivot) = popMax(branch)
            node.right = rest
            result = (node.rebalance, pivot)

    proc merge[T](left, right: AvlSeqNode[T]): AvlSeqNode[T] =
        ## 二つの木を順序を保って連結します。O(log N)。
        if left.isNil: return right
        if right.isNil: return left
        var (rest, pivot) = popMax(left)
        join(rest, pivot, right)

    proc split[T](node: AvlSeqNode[T], k: int): (AvlSeqNode[T], AvlSeqNode[T]) =
        ## 先頭 k 要素で木を分割します。O(log N)。
        if node.isNil: return (nil, nil)
        let leftSize = node.left.nodeLen
        var leftTree = move(node.left)
        var rightTree = move(node.right)
        if k <= leftSize:
            var (left, middle) = split(leftTree, k)
            return (left, join(middle, node, rightTree))
        else:
            var (middle, right) = split(rightTree, k - leftSize - 1)
            return (join(leftTree, node, middle), right)

    proc initAvlSeq*[T](v: openArray[T]): AvlSeq[T] =
        ## 配列から AVL 列を構築します。O(N)。
        AvlSeq[T](root: buildRange(v, 0, v.len), length: v.len)

    proc toAvlSeq*[T](v: openArray[T]): AvlSeq[T] =
        ## 配列を AVL 列に変換します。O(N)。
        initAvlSeq(v)

    proc len*[T](self: AvlSeq[T]): int =
        ## 要素数を返します。O(1)。
        self.length

    proc split*[T](self: AvlSeq[T], k: int): (AvlSeq[T], AvlSeq[T]) =
        ## 先頭 k 要素で分割し、元の列を空にします。O(log N)。
        assert 0 <= k and k <= self.length, "0 <= k <= len が必要です"
        let n = self.length
        var root = move(self.root)
        let (leftRoot, rightRoot) = split(root, k)
        self.length = 0
        result = (AvlSeq[T](root: leftRoot, length: k), AvlSeq[T](root: rightRoot, length: n - k))

    proc merge*[T](left, right: AvlSeq[T]): AvlSeq[T] =
        ## 左右の列を連結し、両方の元の列を空にします。O(log N)。
        assert left != right, "同じ列を連結できません"
        let n = left.length + right.length
        var leftRoot = move(left.root)
        var rightRoot = move(right.root)
        result = AvlSeq[T](root: merge(leftRoot, rightRoot), length: n)
        left.length = 0
        right.length = 0

    proc insertNode[T](root, node: AvlSeqNode[T], k: int): AvlSeqNode[T] =
        ## 指定位置にノードを挿入します。O(log N)。
        if root.isNil: return node
        let leftSize = root.left.nodeLen
        if k <= leftSize:
            var branch = move(root.left)
            root.left = insertNode(branch, node, k)
        else:
            var branch = move(root.right)
            root.right = insertNode(branch, node, k - leftSize - 1)
        root.rebalance

    proc insert*[T](self: AvlSeq[T], index: int, value: T) =
        ## index の直前に挿入します。末尾には len を指定します。O(log N)。
        assert 0 <= index and index <= self.length, "0 <= index <= len が必要です"
        var root = move(self.root)
        self.root = insertNode(root, newNode(value), index)
        inc self.length

    proc insort*[T](self: AvlSeq[T], value: T, less: proc(x, y: T): bool): int {.discardable.} =
        ## ソート済みの列へ同値の末尾となる位置に挿入し、その位置を返します。O(log N)。
        var node = self.root
        while not node.isNil:
            if less(value, node.value):
                node = node.left
            else:
                result += node.left.nodeLen + 1
                node = node.right
        self.insert(result, value)

    proc insort*[T](self: AvlSeq[T], value: T): int {.discardable.} =
        ## < でソート済みの列へ同値の末尾となる位置に挿入します。O(log N)。
        self.insort(value, proc(x, y: T): bool = x < y)

    proc eraseNode[T](node: AvlSeqNode[T], k: int): AvlSeqNode[T] =
        ## 指定位置のノードを削除します。O(log N)。
        let leftSize = node.left.nodeLen
        if k == leftSize:
            var left = move(node.left)
            var right = move(node.right)
            return merge(left, right)
        if k < leftSize:
            var branch = move(node.left)
            node.left = eraseNode(branch, k)
        else:
            var branch = move(node.right)
            node.right = eraseNode(branch, k - leftSize - 1)
        node.rebalance

    proc erase*[T](self: AvlSeq[T], index: int) =
        ## 指定位置の要素を削除します。O(log N)。
        assert 0 <= index and index < self.length, "0 <= index < len が必要です"
        var root = move(self.root)
        self.root = eraseNode(root, index)
        dec self.length

    proc erase*[T](self: AvlSeq[T], l, r: int) =
        ## 半開区間 [l, r) を削除します。木の操作は O(log N)。
        assert 0 <= l and l <= r and r <= self.length, "0 <= l <= r <= len が必要です"
        if l == r: return
        var root = move(self.root)
        let (left, rest) = split(root, l)
        let (_, right) = split(rest, r - l)
        self.root = merge(left, right)
        self.length -= r - l

    proc erase*[T](self: AvlSeq[T], segment: HSlice[int, int]) =
        ## 閉区間の要素を削除します。木の操作は O(log N)。
        self.erase(segment.a, segment.b + 1)

    proc get*[T](self: AvlSeq[T], index: int): T =
        ## 指定位置の値を返します。O(log N)。
        assert 0 <= index and index < self.length, "0 <= index < len が必要です"
        var node = self.root
        var k = index
        while true:
            let leftSize = node.left.nodeLen
            if k < leftSize:
                node = node.left
            elif k == leftSize:
                return node.value
            else:
                k -= leftSize + 1
                node = node.right

    proc update*[T](self: AvlSeq[T], index: Natural, value: T) =
        ## 指定位置の値を変更します。O(log N)。
        assert index < self.length, "index < len が必要です"
        var node = self.root
        var k = int(index)
        while true:
            let leftSize = node.left.nodeLen
            if k < leftSize:
                node = node.left
            elif k == leftSize:
                node.value = value
                return
            else:
                k -= leftSize + 1
                node = node.right

    proc `[]`*[T](self: AvlSeq[T], index: int): T =
        ## 指定位置の値を返します。O(log N)。
        self.get(index)

    proc `[]`*[T](self: AvlSeq[T], index: BackwardsIndex): T =
        ## 末尾から指定した位置の値を返します。O(log N)。
        self.get(self.length - int(index))

    proc `[]=`*[T](self: AvlSeq[T], index: Natural, value: T) {.backwardsIndex.} =
        ## 指定位置の値を変更します。O(log N)。
        self.update(index, value)

    iterator items*[T](self: AvlSeq[T]): T =
        ## 全要素を順番に走査します。O(N)。
        if not self.root.isNil:
            var stack = @[(0, self.root)]
            while stack.len > 0:
                let (state, node) = stack.pop()
                if state == 0:
                    if not node.right.isNil: stack.add((0, node.right))
                    stack.add((1, node))
                    if not node.left.isNil: stack.add((0, node.left))
                else:
                    yield node.value

    proc toSeq*[T](self: AvlSeq[T]): seq[T] =
        ## 全要素を配列として返します。O(N)。
        for x in self:
            result.add(x)

    proc `$`*[T](self: AvlSeq[T]): string =
        ## 全要素の文字列表現を返します。O(N)。
        var parts: seq[string]
        for x in self:
            parts.add($x)
        parts.join(" ")
