## 相異なる非負整数の区間ソートと一点取得・更新を扱います。
## キーは[0,keyLimit)内で、重複は禁止です。モノイドの区間積は保持しません。
## Nを要素数、UをkeyLimitとし、構築はO(N)、空間はO(N)です。
## 構築とQ操作の合計はO((N+Q)(log(N+1)+log(U+1)))です。ソートは償却計算量です。
## 使用例::
##   import algorithm
##   import cplib/collections/range_sort_array
##   let a = initRangeSortArray([3, 1, 2], 5)
##   a.sort(0, 3)                 # [1, 2, 3]
##   a.sort(0..<2, Descending)    # [2, 1, 3]
##   a[^1] = 4                   # [2, 1, 4]
##   echo a.toSeq()
when not declared CPLIB_COLLECTIONS_RANGE_SORT_ARRAY:
    const CPLIB_COLLECTIONS_RANGE_SORT_ARRAY* = 1
    import algorithm, bitops, sets
    import cplib/utils/backwards_index

    type
        RangeSortArrayNode = object
            left, right, count: int
            key, bit: int
        RangeSortArray* = ref object
            nodes: seq[RangeSortArrayNode]
            freeNodes: seq[int]
            roots, next: seq[int]
            reversed: seq[bool]
            starts: seq[int]
            keyLimit: int
            when compileOption("assertions"):
                activeKeys: HashSet[int]

    proc len*(self: RangeSortArray): int =
        ## 要素数をO(1)で返します。
        self.roots.len

    proc newNode(self: RangeSortArray): int =
        ## 空きノードを再利用し、なければ確保します。償却O(1)。
        if self.freeNodes.len > 0:
            return self.freeNodes.pop()
        else:
            result = self.nodes.len
            self.nodes.add(RangeSortArrayNode())

    proc releaseNode(self: RangeSortArray, node: int) =
        ## ノードの値を解放して再利用候補にします。O(1)。
        self.nodes[node] = RangeSortArrayNode()
        self.freeNodes.add(node)

    proc pull(self: RangeSortArray, node: int) =
        ## 子から要素数と最小キーを更新します。O(1)。
        let left = self.nodes[node].left
        let right = self.nodes[node].right
        self.nodes[node].key = self.nodes[left].key
        self.nodes[node].count = self.nodes[left].count + self.nodes[right].count

    proc newBranch(self: RangeSortArray, left, right, bit: int): int =
        ## 指定した分岐ビットと空でない子から内部ノードを生成します。償却O(1)。
        result = self.newNode()
        self.nodes[result].left = left
        self.nodes[result].right = right
        self.nodes[result].bit = bit
        self.pull(result)

    proc singleton(self: RangeSortArray, key: int): int =
        ## キー1個の葉を生成します。償却O(1)。
        result = self.newNode()
        self.nodes[result] = RangeSortArrayNode(
            count: 1, key: key, bit: -1)

    proc splitNode(self: RangeSortArray, node, k: int): (int, int) =
        ## 小さいキーからk個と残りに破壊的分割します。O(log(U+1))。
        if k == 0: return (0, node)
        if k == self.nodes[node].count: return (node, 0)
        let left = self.nodes[node].left
        let right = self.nodes[node].right
        let leftCount = self.nodes[left].count
        if k == leftCount:
            self.releaseNode(node)
            return (left, right)
        if k < leftCount:
            let (a, b) = self.splitNode(left, k)
            self.nodes[node].left = b
            self.pull(node)
            return (a, node)
        else:
            let (a, b) = self.splitNode(right, k - leftCount)
            self.nodes[node].right = a
            self.pull(node)
            return (node, b)

    proc meld(self: RangeSortArray, a, b: int): int =
        ## 分岐のない経路を省略したキーの木を破壊的に融合します。
        let aBit = self.nodes[a].bit
        let bBit = self.nodes[b].bit
        let different = self.nodes[a].key xor self.nodes[b].key
        let bit = if different == 0: -1 else: fastLog2(uint(different))
        if bit > max(aBit, bBit):
            if self.nodes[a].key < self.nodes[b].key:
                return self.newBranch(a, b, bit)
            return self.newBranch(b, a, bit)
        if aBit < bBit:
            return self.meld(b, a)
        if aBit > bBit:
            if ((self.nodes[b].key shr aBit) and 1) == 0:
                let child = self.meld(self.nodes[a].left, b)
                self.nodes[a].left = child
            else:
                let child = self.meld(self.nodes[a].right, b)
                self.nodes[a].right = child
        else:
            let left = self.meld(self.nodes[a].left, self.nodes[b].left)
            let right = self.meld(self.nodes[a].right, self.nodes[b].right)
            self.nodes[a].left = left
            self.nodes[a].right = right
            self.releaseNode(b)
        self.pull(a)
        a

    proc blockStart(self: RangeSortArray, index: int): int {.inline.} =
        ## indexを含むブロックの始点を求めます。O(log(N+1))。
        if self.roots[index] != 0: return index
        var node = index + self.starts.len div 2
        while node > 1:
            if (node and 1) != 0 and self.starts[node - 1] != -1:
                return self.starts[node - 1]
            node = node shr 1
        -1

    proc setStart(self: RangeSortArray, index, value: int) =
        ## ブロック境界を更新し、値の変わらない祖先で打ち切ります。O(log(N+1))。
        var node = index + self.starts.len div 2
        self.starts[node] = value
        node = node shr 1
        while node > 0:
            let value = max(self.starts[node * 2], self.starts[node * 2 + 1])
            if self.starts[node] == value: break
            self.starts[node] = value
            node = node shr 1

    proc cut(self: RangeSortArray, index: int) =
        ## 配列上のindexの直前にブロック境界を作ります。O(log(N+1)+log(U+1))。
        if index == self.len or self.roots[index] != 0: return
        let start = self.blockStart(index)
        let root = self.roots[start]
        let k = index - start
        var a, b: int
        if self.reversed[start]:
            (b, a) = self.splitNode(root, self.nodes[root].count - k)
        else:
            (a, b) = self.splitNode(root, k)
        self.roots[start] = a
        self.roots[index] = b
        self.reversed[index] = self.reversed[start]
        self.next[index] = self.next[start]
        self.next[start] = index
        self.setStart(index, index)

    proc initRangeSortArray*(keys: openArray[int], keyLimit: int): RangeSortArray =
        ## 与えた並び順で構築します。O(N)時間・空間。
        ## キーは[0,keyLimit)内で相異なる必要があり、assert有効時に重複を検査します。
        assert keyLimit >= 0, "keyLimitは非負である必要があります"
        let n = keys.len
        var size = 1
        while size < n: size *= 2
        result = RangeSortArray(
            roots: newSeq[int](n), next: newSeq[int](n), reversed: newSeq[bool](n),
            keyLimit: keyLimit, starts: newSeq[int](size * 2),
            nodes: newSeqOfCap[RangeSortArrayNode](max(1, 2 * n)))
        result.nodes.add(RangeSortArrayNode())
        result.starts.fill(-1)
        when compileOption("assertions"):
            result.activeKeys = initHashSet[int]()
        for i, key in keys:
            assert 0 <= key and key < keyLimit, "キーは[0,keyLimit)内である必要があります"
            when compileOption("assertions"):
                assert key notin result.activeKeys, "キーは相異なる必要があります"
                result.activeKeys.incl(key)
            result.roots[i] = result.singleton(key)
            result.next[i] = i + 1
            result.starts[size + i] = i
        for i in countdown(size - 1, 1):
            result.starts[i] = max(result.starts[i * 2], result.starts[i * 2 + 1])

    proc locate(self: RangeSortArray, index: int): tuple[node, key: int] =
        ## 現在の位置の葉とキーを取得します。O(log(N+1)+log(U+1))。
        assert 0 <= index and index < self.len, "添字は[0,len)内である必要があります"
        let start = self.blockStart(index)
        var node = self.roots[start]
        var k = index - start
        if self.reversed[start]: k = self.nodes[node].count - 1 - k
        while self.nodes[node].count > 1:
            let left = self.nodes[node].left
            if k < self.nodes[left].count:
                node = left
            else:
                k -= self.nodes[left].count
                node = self.nodes[node].right
        (node, self.nodes[node].key)

    proc get*(self: RangeSortArray, index: int): int =
        ## 現在の位置indexのキーを返します。O(log(N+1)+log(U+1))。
        self.locate(index).key

    proc key*(self: RangeSortArray, index: int): int =
        ## 現在の位置indexのキーを返します。O(log(N+1)+log(U+1))。
        self.get(index)

    proc `[]`*(self: RangeSortArray, index: int): int {.backwardsIndex.} =
        ## 現在の位置indexのキーを返します。O(log(N+1)+log(U+1))。
        self.get(index)

    proc update*(self: RangeSortArray, index, key: int) =
        ## 現在の位置indexのキーを変更します。O(log(N+1)+log(U+1))。キーの重複は禁止です。
        assert 0 <= index and index < self.len, "添字は[0,len)内である必要があります"
        assert 0 <= key and key < self.keyLimit, "キーは[0,keyLimit)内である必要があります"
        when compileOption("assertions"):
            let oldKey = self.key(index)
            assert key == oldKey or key notin self.activeKeys, "キーは相異なる必要があります"
            self.activeKeys.excl(oldKey)
            self.activeKeys.incl(key)
        self.cut(index)
        self.cut(index + 1)
        self.nodes[self.roots[index]].key = key
        self.reversed[index] = false

    proc `[]=`*(self: RangeSortArray, index: int, key: int) {.backwardsIndex.} =
        ## 現在の位置indexのキーを変更します。O(log(N+1)+log(U+1))。
        self.update(index, key)

    proc sort*(self: RangeSortArray, l, r: int,
            order: SortOrder = Ascending) =
        ## [l,r)をキー順にソートします。償却O(log(N+1)+log(U+1))。空区間は変更しません。
        assert 0 <= l and l <= r and r <= self.len, "区間は0 <= l <= r <= lenを満たす必要があります"
        if r - l <= 1: return
        self.cut(l)
        self.cut(r)
        var root = self.roots[l]
        var start = self.next[l]
        while start < r:
            root = self.meld(root, self.roots[start])
            self.roots[start] = 0
            self.setStart(start, -1)
            start = self.next[start]
        self.roots[l] = root
        self.next[l] = r
        self.reversed[l] = order == Descending

    proc sort*(self: RangeSortArray, segment: HSlice[int, int],
            order: SortOrder = Ascending) =
        ## スライスで指定した区間をソートします。償却O(log(N+1)+log(U+1))。
        assert 0 <= segment.a and segment.a <= self.len and
            segment.a - 1 <= segment.b and segment.b < self.len, "区間が範囲外です"
        self.sort(segment.a, segment.b + 1, order)

    iterator items*(self: RangeSortArray): int =
        ## 現在の配列順にキーを列挙します。全体O(N)。列挙中の変更は禁止です。
        var start = 0
        var stack: seq[int]
        while start < self.len:
            stack.add(self.roots[start])
            while stack.len > 0:
                let node = stack.pop()
                if self.nodes[node].count == 1:
                    yield self.nodes[node].key
                elif self.reversed[start]:
                    stack.add(self.nodes[node].left)
                    stack.add(self.nodes[node].right)
                else:
                    stack.add(self.nodes[node].right)
                    stack.add(self.nodes[node].left)
            start = self.next[start]

    proc toSeq*(self: RangeSortArray): seq[int] =
        ## 現在の配列をseqとして返します。O(N)。
        result = newSeqOfCap[int](self.len)
        for key in self.items: result.add(key)
