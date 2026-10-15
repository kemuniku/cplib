when not declared CPLIB_COLLECTIONS_AVL_MONOID:
    const CPLIB_COLLECTIONS_AVL_MONOID* = 1
    import cplib/utils/backwards_index
    import strutils

    type AvlMonoidNode[T] = ref object
        left, right: AvlMonoidNode[T]
        height: int
        size: int
        value, prod: T

    type AvlMonoid*[T] = ref object
        root: AvlMonoidNode[T]
        length: int
        op: proc(x, y: T): T
        e: T

    proc nodeLen[T](node: AvlMonoidNode[T]): int {.inline.} =
        ## 部分木の要素数を返します。O(1)。
        if node.isNil: 0 else: node.size

    proc nodeHeight[T](node: AvlMonoidNode[T]): int {.inline.} =
        ## 部分木の高さを返します。O(1)。
        if node.isNil: 0 else: node.height

    proc nodeProd[T](node: AvlMonoidNode[T], e: T): T {.inline.} =
        ## 部分木の総積を返します。O(1)。
        if node.isNil: e else: node.prod

    proc update[T](node: AvlMonoidNode[T], op: proc(x, y: T): T, e: T) =
        ## 子の情報からノードの集約値を更新します。O(1)。
        if node.isNil: return
        node.size = 1 + node.left.nodeLen + node.right.nodeLen
        node.height = 1 + max(node.left.nodeHeight, node.right.nodeHeight)
        node.prod = op(op(node.left.nodeProd(e), node.value), node.right.nodeProd(e))

    proc newNode[T](value: T): AvlMonoidNode[T] =
        ## 一要素のノードを作ります。O(1)。
        AvlMonoidNode[T](height: 1, size: 1, value: value, prod: value)

    proc buildRange[T](v: openArray[T], l, r: int, op: proc(x, y: T): T, e: T): AvlMonoidNode[T] =
        ## 指定区間から高さの釣り合った木を構築します。O(r-l)。
        if l == r: return nil
        let mid = (l + r) shr 1
        result = newNode(v[mid])
        result.left = buildRange(v, l, mid, op, e)
        result.right = buildRange(v, mid + 1, r, op, e)
        result.update(op, e)

    proc build[T](v: openArray[T], op: proc(x, y: T): T, e: T): AvlMonoidNode[T] =
        ## 配列から AVL 木を構築します。O(N)。
        buildRange(v, 0, v.len, op, e)


    proc rotateLeft[T](node: AvlMonoidNode[T], op: proc(x, y: T): T, e: T): AvlMonoidNode[T] =
        ## 左回転し、集約値を更新します。O(1)。
        var child = move(node.right)
        node.right = move(child.left)
        child.left = node
        node.update(op, e)
        child.update(op, e)
        child

    proc rotateRight[T](node: AvlMonoidNode[T], op: proc(x, y: T): T, e: T): AvlMonoidNode[T] =
        ## 右回転し、集約値を更新します。O(1)。
        var child = move(node.left)
        node.left = move(child.right)
        child.right = node
        node.update(op, e)
        child.update(op, e)
        child

    proc rebalance[T](node: AvlMonoidNode[T], op: proc(x, y: T): T, e: T): AvlMonoidNode[T] =
        ## 部分木を AVL 条件に戻します。O(1)。
        node.update(op, e)
        if node.left.nodeHeight > node.right.nodeHeight + 1:
            if node.left.left.nodeHeight < node.left.right.nodeHeight:
                var child = move(node.left)
                node.left = child.rotateLeft(op, e)
            return node.rotateRight(op, e)
        if node.right.nodeHeight > node.left.nodeHeight + 1:
            if node.right.right.nodeHeight < node.right.left.nodeHeight:
                var child = move(node.right)
                node.right = child.rotateRight(op, e)
            return node.rotateLeft(op, e)
        node

    proc join[T](left, pivot, right: AvlMonoidNode[T], op: proc(x, y: T): T, e: T): AvlMonoidNode[T] =
        ## 要素一つを挟んで二つの木を結合します。O(|hL-hR|+1)。
        if left.nodeHeight > right.nodeHeight + 1:
            var branch = move(left.right)
            left.right = join(branch, pivot, right, op, e)
            return left.rebalance(op, e)
        if right.nodeHeight > left.nodeHeight + 1:
            var branch = move(right.left)
            right.left = join(left, pivot, branch, op, e)
            return right.rebalance(op, e)
        pivot.left = left
        pivot.right = right
        pivot.update(op, e)
        pivot

    proc popMax[T](node: AvlMonoidNode[T], op: proc(x, y: T): T, e: T): (AvlMonoidNode[T], AvlMonoidNode[T]) =
        ## 最大位置のノードを取り出します。O(log N)。
        if node.right.isNil:
            var branch = move(node.left)
            result = (branch, node)
            node.update(op, e)
        else:
            var branch = move(node.right)
            var (rest, pivot) = popMax(branch, op, e)
            node.right = rest
            result = (node.rebalance(op, e), pivot)

    proc merge[T](left, right: AvlMonoidNode[T], op: proc(x, y: T): T, e: T): AvlMonoidNode[T] =
        ## 二つの木を順序を保って結合します。O(log N)。
        if left.isNil: return right
        if right.isNil: return left
        var (rest, pivot) = popMax(left, op, e)
        join(rest, pivot, right, op, e)

    proc split[T](node: AvlMonoidNode[T], k: int, op: proc(x, y: T): T, e: T): (AvlMonoidNode[T], AvlMonoidNode[T]) =
        ## 先頭 k 要素で木を分割します。O(log N)。
        if node.isNil: return (nil, nil)
        let leftSize = node.left.nodeLen
        var leftTree = move(node.left)
        var rightTree = move(node.right)
        if k <= leftSize:
            var (left, middle) = split(leftTree, k, op, e)
            return (left, join(middle, node, rightTree, op, e))
        else:
            var (middle, right) = split(rightTree, k - leftSize - 1, op, e)
            return (join(leftTree, node, middle, op, e), right)

    proc initAvlMonoid*[T](v: openArray[T], op: proc(x, y: T): T, e: T): AvlMonoid[T] =
        ## vで初期化します。
        ## 挿入、削除、一点取得、一点更新、区間総積はすべてO(log N)です。
        AvlMonoid[T](root: build(v, op, e), length: v.len, op: op, e: e)

    proc toAvlMonoid*[T](v: openArray[T], op: proc(x, y: T): T, e: T): AvlMonoid[T] =
        ## 配列をモノイド付き列に変換します。O(N)。
        initAvlMonoid(v, op, e)

    template newAvlMonoidWith*(V, op, e: untyped): untyped =
        initAvlMonoid[typeof(e)](V, proc (l{.inject.}, r{.inject.}: typeof(e)): typeof(e) = op, e)

    proc len*[T](self: AvlMonoid[T]): int =
        ## 要素数を返します。O(1)。
        self.length

    proc split*[T](self: AvlMonoid[T], k: int): (AvlMonoid[T], AvlMonoid[T]) =
        ## 先頭 k 要素で分割し、元の列を空にします。O(log N)。
        assert 0 <= k and k <= self.length, "0 <= k <= len が必要です"
        let n = self.length
        var root = move(self.root)
        let (leftRoot, rightRoot) = split(root, k, self.op, self.e)
        self.length = 0
        result = (
            AvlMonoid[T](root: leftRoot, length: k, op: self.op, e: self.e),
            AvlMonoid[T](root: rightRoot, length: n - k, op: self.op, e: self.e)
        )

    proc merge*[T](left, right: AvlMonoid[T]): AvlMonoid[T] =
        ## 左右の列を連結し、両方の元の列を空にします。同じ演算が必要です。O(log N)。
        assert left != right, "同じ列を連結できません"
        let n = left.length + right.length
        var leftRoot = move(left.root)
        var rightRoot = move(right.root)
        result = AvlMonoid[T](root: merge(leftRoot, rightRoot, left.op, left.e), length: n, op: left.op, e: left.e)
        left.length = 0
        right.length = 0

    proc insertNode[T](self: AvlMonoid[T], root, node: AvlMonoidNode[T], k: int): AvlMonoidNode[T] =
        ## 指定位置にノードを挿入します。O(log N)。
        if root.isNil: return node
        let leftSize = root.left.nodeLen
        if k <= leftSize:
            var branch = move(root.left)
            root.left = self.insertNode(branch, node, k)
        else:
            var branch = move(root.right)
            root.right = self.insertNode(branch, node, k - leftSize - 1)
        root.rebalance(self.op, self.e)

    proc insert*[T](self: AvlMonoid[T], index: int, value: T) =
        ## index の直前に挿入する。index = len なら末尾。
        assert 0 <= index and index <= self.len, "指定した値が有効な範囲内である必要があります: 0 <= index and index <= self.len"
        let node = newNode(value)
        self.root = self.insertNode(self.root, node, index)
        inc self.length

    proc insort*[T](self: AvlMonoid[T], value: T, less: proc(x, y: T): bool): int {.discardable.} =
        ## ソート済みの列へ同値の末尾となる位置に挿入し、その位置を返します。O(log N)。
        var node = self.root
        while not node.isNil:
            if less(value, node.value):
                node = node.left
            else:
                result += node.left.nodeLen + 1
                node = node.right
        self.insert(result, value)

    proc insort*[T](self: AvlMonoid[T], value: T): int {.discardable.} =
        ## < でソート済みの列へ同値の末尾となる位置に挿入します。O(log N)。
        self.insort(value, proc(x, y: T): bool = x < y)

    proc eraseNode[T](self: AvlMonoid[T], node: AvlMonoidNode[T], k: int): AvlMonoidNode[T] =
        ## 指定位置のノードを削除します。O(log N)。
        let leftSize = node.left.nodeLen
        if k == leftSize:
            var left = move(node.left)
            var right = move(node.right)
            return merge(left, right, self.op, self.e)
        if k < leftSize:
            var branch = move(node.left)
            node.left = self.eraseNode(branch, k)
        else:
            var branch = move(node.right)
            node.right = self.eraseNode(branch, k - leftSize - 1)
        return node.rebalance(self.op, self.e)

    proc erase*[T](self: AvlMonoid[T], index: int) =
        ## 指定位置または区間の要素を削除します。木の操作はO(log N)。
        assert 0 <= index and index < self.len, "指定した値が有効な範囲内である必要があります: 0 <= index and index < self.len"
        self.root = self.eraseNode(self.root, index)
        dec self.length

    proc erase*[T](self: AvlMonoid[T], l, r: int) =
        ## 指定位置または区間の要素を削除します。木の操作はO(log N)。
        assert 0 <= l and l <= r and r <= self.len, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.len"
        if l == r: return
        let (left, rest) = split(self.root, l, self.op, self.e)
        let (_, right) = split(rest, r - l, self.op, self.e)
        self.root = merge(left, right, self.op, self.e)
        self.length -= r - l

    proc erase*[T](self: AvlMonoid[T], segment: HSlice[int, int]) =
        ## 指定位置または区間の要素を削除します。木の操作はO(log N)。
        self.erase(segment.a, segment.b + 1)

    proc get*[T](self: AvlMonoid[T], index: int): T =
        ## index番目の値を返します。
        assert 0 <= index and index < self.length, "指定した値が有効な範囲内である必要があります: 0 <= index and index < self.length"
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

    proc getNode[T](self: AvlMonoid[T], node: AvlMonoidNode[T], l, r: int): T =
        ## 部分木の指定区間の総積を返します。O(log N)。
        if l == 0 and r == node.size: return node.prod
        let mid = node.left.nodeLen
        if r <= mid: return self.getNode(node.left, l, r)
        if l > mid: return self.getNode(node.right, l - mid - 1, r - mid - 1)
        result = node.value
        if l < mid: result = self.op(self.getNode(node.left, l, mid), result)
        if r > mid + 1: result = self.op(result, self.getNode(node.right, 0, r - mid - 1))

    proc get*[T](self: AvlMonoid[T], l, r: int): T =
        ## 半開区間 [l, r) の総積を返す。
        assert 0 <= l and l <= r and r <= self.len, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.len"
        if l == r: return self.e
        self.getNode(self.root, l, r)

    proc get*[T](self: AvlMonoid[T], segment: HSlice[int, int]): T =
        ## 閉区間segmentの総積を返します。
        assert segment.a <= segment.b + 1 and 0 <= segment.a and segment.b + 1 <= self.length, "指定した区間が有効な範囲内である必要があります: segment.a <= segment.b + 1 and 0 <= segment.a and segment.b + 1 <= self.length"
        self.get(segment.a, segment.b + 1)

    proc fold*[T](self: AvlMonoid[T], l, r: int): T =
        ## 指定区間または全体の総積を返します。区間はO(log N)、全体は O(1)。
        self.get(l, r)

    proc fold*[T](self: AvlMonoid[T], segment: HSlice[int, int]): T =
        ## 指定区間または全体の総積を返します。区間はO(log N)、全体は O(1)。
        self.get(segment)

    proc fold*[T](self: AvlMonoid[T]): T =
        ## 指定区間または全体の総積を返します。区間はO(log N)、全体は O(1)。
        self.root.nodeProd(self.e)

    proc get_all*[T](self: AvlMonoid[T]): T =
        ## [0,len(self))区間の総積をO(1)で返します。
        self.root.nodeProd(self.e)

    proc updateNode[T](self: AvlMonoid[T], node: AvlMonoidNode[T], k: int, value: T) =
        ## 指定位置の値を更新し、集約値を再計算します。O(log N)。
        let leftSize = node.left.nodeLen
        if k == leftSize:
            node.value = value
        elif k < leftSize:
            self.updateNode(node.left, k, value)
        else:
            self.updateNode(node.right, k - leftSize - 1, value)
        node.update(self.op, self.e)

    proc update*[T](self: AvlMonoid[T], index: Natural, value: T) =
        ## index 番目の値を value に変更する。
        assert index < self.len, "指定した値が有効な範囲内である必要があります: index < self.len"
        self.updateNode(self.root, index, value)

    proc searchRight[T](self: AvlMonoid[T], node: AvlMonoidNode[T], start, l: int, acc: var T, f: proc(x: T): bool): int =
        ## 右方向に条件を満たす境界を探します。O(log N)。
        let finish = start + node.nodeLen
        if node.isNil or finish <= l: return finish
        if l <= start:
            let next = self.op(acc, node.prod)
            if f(next):
                acc = next
                return finish
        let mid = start + node.left.nodeLen
        result = self.searchRight(node.left, start, l, acc, f)
        if result < mid: return
        if l <= mid:
            let next = self.op(acc, node.value)
            if not f(next): return mid
            acc = next
        result = self.searchRight(node.right, mid + 1, l, acc, f)

    proc max_right*[T](self: AvlMonoid[T], l: int, f: proc(x: T): bool): int =
        ## f(get(l, r)) が真となる最大の r を返す。
        ## f(e) = true で、区間を伸ばしたとき真から偽への変化が単調であること。
        assert 0 <= l and l <= self.len, "指定した値が有効な範囲内である必要があります: 0 <= l and l <= self.len"
        assert f(self.e), "判定関数は単位元に対してtrueを返す必要があります"
        var acc = self.e
        self.searchRight(self.root, 0, l, acc, f)

    proc searchLeft[T](self: AvlMonoid[T], node: AvlMonoidNode[T], start, r: int, acc: var T, f: proc(x: T): bool): int =
        ## 左方向に条件を満たす境界を探します。O(log N)。
        if node.isNil or r <= start: return start
        if start + node.size <= r:
            let next = self.op(node.prod, acc)
            if f(next):
                acc = next
                return start
        let mid = start + node.left.nodeLen
        result = self.searchLeft(node.right, mid + 1, r, acc, f)
        if result > mid + 1: return
        if mid < r:
            let next = self.op(node.value, acc)
            if not f(next): return mid + 1
            acc = next
        result = self.searchLeft(node.left, start, r, acc, f)

    proc min_left*[T](self: AvlMonoid[T], r: int, f: proc(x: T): bool): int =
        ## f(get(l, r)) が真となる最小の l を返す。
        ## f(e) = true で、区間を伸ばしたとき真から偽への変化が単調であること。
        assert 0 <= r and r <= self.len, "指定した値が有効な範囲内である必要があります: 0 <= r and r <= self.len"
        assert f(self.e), "判定関数は単位元に対してtrueを返す必要があります"
        var acc = self.e
        self.searchLeft(self.root, 0, r, acc, f)

    proc `[]`*[T](self: AvlMonoid[T], index: int): T =
        ## 指定位置の値または区間の総積を返します。O(log N)。
        self.get(index)

    proc `[]`*[T](self: AvlMonoid[T], index: BackwardsIndex): T =
        ## 指定位置の値または区間の総積を返します。O(log N)。
        self.get(self.length - int(index))

    proc `[]`*[T](self: AvlMonoid[T], segment: HSlice[int, int]): T =
        ## 指定位置の値または区間の総積を返します。O(log N)。
        self.get(segment)

    proc `[]=`*[T](self: AvlMonoid[T], index: Natural, value: T) {.backwardsIndex.} =
        ## 指定位置の値を更新します。O(log N)。
        self.update(index, value)

    iterator items*[T](self: AvlMonoid[T]): T =
        if not self.root.isNil:
            var stack = @[(0, self.root)]
            while stack.len > 0:
                var (t, node) = stack.pop()
                if t == 0:
                    if not node.right.isNil: stack.add((0, node.right))
                    stack.add((1, node))
                    if not node.left.isNil: stack.add((0, node.left))
                else:
                    yield node.value

    proc toSeq*[T](self: AvlMonoid[T]): seq[T] =
        ## 全要素を配列として返します。O(N)。
        for x in self:
            result.add(x)

    proc `$`*[T](self: AvlMonoid[T]): string =
        ## 全要素の文字列表現を返します。O(N)。
        var s: seq[string]
        for x in self:
            s.add($x)
        return s.join(" ")
