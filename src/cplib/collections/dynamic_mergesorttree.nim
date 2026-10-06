when not declared CPLIB_COLLECTIONS_DYNAMIC_MERGESORTTREE:
    const CPLIB_COLLECTIONS_DYNAMIC_MERGESORTTREE* = 1
    import algorithm, options
    import cplib/collections/private/mergesorttree_queries

    type MergeSortTreeNode[T] = object
        left, right, parent, height, size: int
        key: T

    type DynamicMergeSortTree*[T] = ref object
        values: seq[T]
        data: seq[int]
        nodes: seq[MergeSortTreeNode[T]]
        base, height: int

    proc updateNode[T](self: DynamicMergeSortTree[T], node: int) {.inline.} =
        ## ノードの高さと部分木サイズをO(1)で更新します。
        let l = self.nodes[node].left
        let r = self.nodes[node].right
        self.nodes[node].height = max(self.nodes[l].height, self.nodes[r].height) + 1
        self.nodes[node].size = self.nodes[l].size + self.nodes[r].size + 1

    proc setChildren[T](self: DynamicMergeSortTree[T], node, l, r: int) {.inline.} =
        ## 子と親の添字を設定し、ノードの情報をO(1)で更新します。
        self.nodes[node].left = l
        self.nodes[node].right = r
        if l != 0: self.nodes[l].parent = node
        if r != 0: self.nodes[r].parent = node
        self.updateNode(node)

    proc rebalance[T](self: DynamicMergeSortTree[T], node: int): int {.inline.} =
        ## 既存AVLと同じ回転で部分木をO(1)で再平衡します。
        let l = self.nodes[node].left
        let r = self.nodes[node].right
        let lh = self.nodes[l].height
        let rh = self.nodes[r].height
        let parent = self.nodes[node].parent
        if lh + 1 < rh:
            let rl = self.nodes[r].left
            let rr = self.nodes[r].right
            if self.nodes[rl].height <= self.nodes[rr].height:
                self.nodes[r].parent = parent
                self.setChildren(node, l, rl)
                self.setChildren(r, node, rr)
                return r
            self.nodes[rl].parent = parent
            self.setChildren(node, l, self.nodes[rl].left)
            self.setChildren(r, self.nodes[rl].right, rr)
            self.setChildren(rl, node, r)
            return rl
        if rh + 1 < lh:
            let ll = self.nodes[l].left
            let lr = self.nodes[l].right
            if self.nodes[lr].height <= self.nodes[ll].height:
                self.nodes[l].parent = parent
                self.setChildren(node, lr, r)
                self.setChildren(l, ll, node)
                return l
            self.nodes[lr].parent = parent
            self.setChildren(node, self.nodes[lr].right, r)
            self.setChildren(l, ll, self.nodes[lr].left)
            self.setChildren(lr, l, node)
            return lr
        self.updateNode(node)
        node

    proc rebalanceToRoot[T](self: DynamicMergeSortTree[T], start, delta: int): int {.inline.} =
        ## 高さが変わらなくなればサイズだけ更新し、最悪O(log N)で根まで進みます。
        var node = start
        var heightChanged = true
        while self.nodes[node].parent != 0:
            let parent = self.nodes[node].parent
            if heightChanged:
                let oldHeight = self.nodes[node].height
                let balanced = self.rebalance(node)
                if self.nodes[parent].left == node: self.nodes[parent].left = balanced
                else: self.nodes[parent].right = balanced
                heightChanged = self.nodes[balanced].height != oldHeight
            else:
                self.nodes[node].size += delta
            node = parent
        if heightChanged: return self.rebalance(node)
        self.nodes[node].size += delta
        node

    proc insertNode[T](self: DynamicMergeSortTree[T], root, item: int): int {.inline.} =
        ## 切り離されたノードを最悪O(log N)で挿入します。同値は左へ進みます。
        if root == 0: return item
        var node = root
        while true:
            if not (self.nodes[node].key < self.nodes[item].key):
                if self.nodes[node].left == 0:
                    self.nodes[node].left = item
                    break
                node = self.nodes[node].left
            else:
                if self.nodes[node].right == 0:
                    self.nodes[node].right = item
                    break
                node = self.nodes[node].right
        self.nodes[item].parent = node
        self.rebalanceToRoot(node, 1)

    proc eraseNode[T](self: DynamicMergeSortTree[T], item: int): int {.inline.} =
        ## 指定した1ノードを最悪O(log N)で切り離します。キーは移し替えません。
        let parent = self.nodes[item].parent
        let l = self.nodes[item].left
        let r = self.nodes[item].right
        if r == 0:
            if l != 0: self.nodes[l].parent = parent
            if parent == 0: result = l
            else:
                if self.nodes[parent].left == item: self.nodes[parent].left = l
                else: self.nodes[parent].right = l
                result = self.rebalanceToRoot(parent, -1)
        else:
            var next = r
            while self.nodes[next].left != 0: next = self.nodes[next].left
            let nextParent = self.nodes[next].parent
            let nextRight = self.nodes[next].right
            if parent != 0:
                if self.nodes[parent].left == item: self.nodes[parent].left = next
                else: self.nodes[parent].right = next
            self.nodes[next].height = self.nodes[item].height
            self.nodes[next].size = self.nodes[item].size
            self.nodes[next].parent = parent
            self.nodes[next].left = l
            if l != 0: self.nodes[l].parent = next
            if r == next:
                result = self.rebalanceToRoot(next, -1)
            else:
                if self.nodes[nextParent].left == next: self.nodes[nextParent].left = nextRight
                else: self.nodes[nextParent].right = nextRight
                if nextRight != 0: self.nodes[nextRight].parent = nextParent
                self.nodes[next].right = r
                self.nodes[r].parent = next
                result = self.rebalanceToRoot(nextParent, -1)
        self.nodes[item].left = 0
        self.nodes[item].right = 0
        self.nodes[item].parent = 0
        self.nodes[item].height = 1
        self.nodes[item].size = 1

    proc boundRank[T](self: DynamicMergeSortTree[T], root: int, x: T,
            upper: static[bool]): int {.inline.} =
        ## 部分木サイズを加算し、境界の順位を最悪O(log N)で求めます。
        var node = root
        while node != 0:
            if (if upper: not (x < self.nodes[node].key) else: self.nodes[node].key < x):
                result += self.nodes[self.nodes[node].left].size + 1
                node = self.nodes[node].right
            else: node = self.nodes[node].left

    proc nodeLower[T](self: DynamicMergeSortTree[T], node: int, x: T): int {.inline.} =
        ## ノード内のx未満の個数を最悪O(log N)で返します。
        self.boundRank(self.data[node], x, false)

    proc nodeUpper[T](self: DynamicMergeSortTree[T], node: int, x: T): int {.inline.} =
        ## ノード内のx以下の個数を最悪O(log N)で返します。
        self.boundRank(self.data[node], x, true)

    proc nodeLen[T](self: DynamicMergeSortTree[T], node: int): int {.inline.} =
        ## ノードの要素数をO(1)で返します。
        self.nodes[self.data[node]].size

    proc nodeCount[T](self: DynamicMergeSortTree[T], segment: int, x: T): int {.inline.} =
        ## ノード内の出現回数を最悪O(log N)で返します。不在なら探索は1回です。
        var node = self.data[segment]
        while node != 0:
            if x < self.nodes[node].key: node = self.nodes[node].left
            elif self.nodes[node].key < x: node = self.nodes[node].right
            else:
                let l = self.nodes[node].left
                return self.nodes[l].size - self.boundRank(l, x, false) + 1 +
                        self.boundRank(self.nodes[node].right, x, true)

    proc nodeValue[T](self: DynamicMergeSortTree[T], segment, i: int): T {.inline.} =
        ## ノード内のi番目の値を最悪O(log N)で返します。
        var node = self.data[segment]
        var index = i
        while true:
            let leftSize = self.nodes[self.nodes[node].left].size
            if index < leftSize: node = self.nodes[node].left
            elif index == leftSize: return self.nodes[node].key
            else:
                index -= leftSize + 1
                node = self.nodes[node].right

    proc buildNodes[T](self: DynamicMergeSortTree[T], order: openArray[int],
            l, r, level: int, parent: int): int =
        ## ソート済みの位置列からAVLと位置別ノード添字を線形時間で構築します。
        if l == r: return 0
        let m = l + (r - l) div 2
        let i = order[m]
        result = level * self.values.len + i + 1
        self.nodes[result].key = self.values[i]
        self.nodes[result].parent = parent
        let left = self.buildNodes(order, l, m, level, result)
        let right = self.buildNodes(order, m + 1, r, level, result)
        self.setChildren(result, left, right)

    proc buildSegments[T](self: DynamicMergeSortTree[T], order: openArray[int],
            node, left, right, level: int) =
        ## ソート順を保って位置で分割し、各区間のAVLを構築します。
        if order.len == 0: return
        self.data[node] = self.buildNodes(order, 0, order.len, level, 0)
        if level == 0: return
        let mid = left + (right - left) div 2
        var lower = newSeqOfCap[int](min(mid, self.values.len) - left)
        var upper = newSeqOfCap[int](max(0, min(right, self.values.len) - mid))
        for i in order:
            if i < mid: lower.add(i)
            else: upper.add(i)
        self.buildSegments(lower, node * 2, left, mid, level - 1)
        self.buildSegments(upper, node * 2 + 1, mid, right, level - 1)

    proc initDynamicMergeSortTree*[T](v: openArray[T]): DynamicMergeSortTree[T] =
        ## 固定長の列から最悪O(N log(N+1)+1)時間・空間で構築します。
        ## 各区間に添字で管理するAVL多重集合を保持し、更新値の事前登録は不要です。
        ## 親子は整数添字で表し、各位置のノードを更新時に探索せず再利用します。
        ## Tには全順序として一貫した < と == が必要です。
        result = DynamicMergeSortTree[T](values: @v, base: 1, height: 1)
        while result.base < v.len:
            result.base *= 2
            inc result.height
        result.data = newSeq[int](result.base * 2)
        result.nodes = newSeq[MergeSortTreeNode[T]](v.len * result.height + 1)
        var order = newSeq[int](v.len)
        for i in 0..<v.len: order[i] = i
        let values = result.values
        order.sort(proc(a, b: int): int =
            if values[a] < values[b]: -1
            elif values[b] < values[a]: 1
            else: 0)
        result.buildSegments(order, 1, 0, result.base, result.height - 1)

    defineMergeSortTreeQueries(DynamicMergeSortTree, nodeValue, nodeCount,
            nodeLower, nodeUpper, nodeLen)

    proc update*[T](self: DynamicMergeSortTree[T], i: int, value: T) =
        ## i番目を最悪O(log² N)で代入します。各祖先で旧値を1個だけ削除します。
        assert 0 <= i and i < self.values.len, "添字は0 <= i < lenを満たす必要があります"
        if self.values[i] == value: return
        var segment = self.base + i
        var item = i + 1
        while segment > 0:
            if self.nodeLen(segment) == 1:
                self.nodes[item].key = value
            else:
                self.data[segment] = self.eraseNode(item)
                self.nodes[item].key = value
                self.data[segment] = self.insertNode(self.data[segment], item)
            segment = segment shr 1
            item += self.values.len
        self.values[i] = value

    proc `[]=`*[T](self: DynamicMergeSortTree[T], i: int, value: T) =
        ## i番目を最悪O(log² N)で代入します。列の長さは変わりません。
        self.update(i, value)
