## 整数キーによる区間ソートと、現在の配列順でのモノイドの区間積を扱います。
## キーは [0,keyLimit) 内で、現在の要素間で相異なる必要があります。
## mergeには左、右の順に結合する演算、defaultには単位元を渡します。
## Nを要素数、UをkeyLimitとし、mergeがO(1)なら構築とQ操作の合計は
## O((N+Q)(log(N+1)+log(U+1)))、空間はO(N log(U+1))です。
## ソートの計算量は償却です。不要なノードは再利用します。
## 添字は常に現在の配列上の位置で、ソート時にキーと値が一緒に移動します。
## 空区間の積はdefault、空区間のソートは何もしません。
## 使用例::
##   import algorithm
##   import cplib/collections/range_sort_segtree
##   let seg = initRangeSortSegmentTree([3, 1, 2], ["C", "A", "B"], 4,
##       proc(x, y: string): string = x & y, "")
##   seg.sort(0, 3)                 # 値の並びは A, B, C
##   seg.sort(0..<2, Descending)    # 値の並びは B, A, C
##   seg[1] = "a"                  # キー1を保って値だけ変更
##   seg.update(2, 0, "D")          # 現在の位置2のキーと値を変更
##   echo seg.get(0, 3)             # BaD
when not declared CPLIB_COLLECTIONS_RANGE_SORT_SEGTREE:
    const CPLIB_COLLECTIONS_RANGE_SORT_SEGTREE* = 1
    import algorithm, sets
    import cplib/collections/segtree
    import cplib/utils/backwards_index

    type
        RangeSortSegmentTreeNode[T] = object
            left, right, count: int
            ascending, descending: T
        RangeSortSegmentTree*[T] = ref object
            nodes: seq[RangeSortSegmentTreeNode[T]]
            freeNodes: seq[int]
            roots, next: seq[int]
            reversed: seq[bool]
            starts: SegmentTree[int]
            products: SegmentTree[T]
            keyLimit: int
            merge: proc(x, y: T): T
            default: T
            when compileOption("assertions"):
                activeKeys: HashSet[int]

    proc len*[T](self: RangeSortSegmentTree[T]): int =
        ## 要素数をO(1)で返します。
        self.roots.len

    proc newNode[T](self: RangeSortSegmentTree[T]): int =
        ## 空きノードを再利用し、なければ確保します。償却O(1)。
        if self.freeNodes.len > 0:
            return self.freeNodes.pop()
        else:
            result = self.nodes.len
            self.nodes.add(RangeSortSegmentTreeNode[T]())

    proc releaseNode[T](self: RangeSortSegmentTree[T], node: int) =
        ## ノードの値を解放して再利用候補にします。O(1)。
        self.nodes[node] = RangeSortSegmentTreeNode[T]()
        self.freeNodes.add(node)

    proc pull[T](self: RangeSortSegmentTree[T], node: int) =
        ## 子から要素数と両方向の積を更新します。O(1)。
        let left = self.nodes[node].left
        let right = self.nodes[node].right
        self.nodes[node].count = self.nodes[left].count + self.nodes[right].count
        self.nodes[node].ascending = self.merge(
            self.nodes[left].ascending, self.nodes[right].ascending)
        self.nodes[node].descending = self.merge(
            self.nodes[right].descending, self.nodes[left].descending)

    proc newBranch[T](self: RangeSortSegmentTree[T], left, right: int): int =
        ## 指定した子を持つ内部ノードを生成します。償却O(1)。
        result = self.newNode()
        self.nodes[result].left = left
        self.nodes[result].right = right
        self.pull(result)

    proc singleton[T](self: RangeSortSegmentTree[T], l, r, key: int, value: T): int =
        ## キー1個の木を生成します。O(log(U+1))。
        if r - l == 1:
            result = self.newNode()
            self.nodes[result] = RangeSortSegmentTreeNode[T](
                count: 1, ascending: value, descending: value)
        else:
            let mid = l + (r - l) div 2
            if key < mid:
                let child = self.singleton(l, mid, key, value)
                result = self.newBranch(child, 0)
            else:
                let child = self.singleton(mid, r, key, value)
                result = self.newBranch(0, child)

    proc releaseSingleton[T](self: RangeSortSegmentTree[T], root: int) =
        ## 要素数1の木を解放します。O(log(U+1))。
        var node = root
        while node != 0:
            let child = max(self.nodes[node].left, self.nodes[node].right)
            self.releaseNode(node)
            node = child

    proc splitNode[T](self: RangeSortSegmentTree[T], node, k: int): (int, int) =
        ## 小さいキーからk個と残りに破壊的分割します。O(log(U+1))。
        if k == 0: return (0, node)
        if k == self.nodes[node].count: return (node, 0)
        let left = self.nodes[node].left
        let right = self.nodes[node].right
        let leftCount = self.nodes[left].count
        if k <= leftCount:
            let (a, b) = self.splitNode(left, k)
            let other = self.newBranch(b, right)
            self.nodes[node].left = a
            self.nodes[node].right = 0
            self.pull(node)
            return (node, other)
        else:
            let (a, b) = self.splitNode(right, k - leftCount)
            let other = self.newBranch(0, b)
            self.nodes[node].right = a
            self.pull(node)
            return (node, other)

    proc meld[T](self: RangeSortSegmentTree[T], a, b: int): int =
        ## 同じキー範囲の木を破壊的に融合します。非空同士の再帰ごとに1ノード減ります。
        if a == 0: return b
        if b == 0: return a
        let left = self.meld(self.nodes[a].left, self.nodes[b].left)
        let right = self.meld(self.nodes[a].right, self.nodes[b].right)
        self.nodes[a].left = left
        self.nodes[a].right = right
        self.pull(a)
        self.releaseNode(b)
        a

    proc refresh[T](self: RangeSortSegmentTree[T], start: int) =
        ## ブロック全体の積を外側のセグ木へ反映します。O(log(N+1))。
        let root = self.roots[start]
        self.products[start] = if self.reversed[start]:
            self.nodes[root].descending
        else:
            self.nodes[root].ascending

    proc cut[T](self: RangeSortSegmentTree[T], index: int) =
        ## 配列上のindexの直前にブロック境界を作ります。O(log(N+1)+log(U+1))。
        if index == self.len or self.roots[index] != 0: return
        let start = self.starts.get(0, index + 1)
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
        self.starts[index] = index
        self.refresh(start)
        self.refresh(index)

    proc initRangeSortSegmentTree*[T](keys: openArray[int], values: openArray[T],
            keyLimit: int, merge: proc(x, y: T): T,
            default: T): RangeSortSegmentTree[T] =
        ## 与えた並び順で構築します。O(N log(U+1))時間・空間。
        ## keysとvaluesは同じ長さ、キーは[0,keyLimit)内で相異なることが必要です。
        ## キーの重複はassert有効時に検査します（ハッシュ集合操作は期待O(1)）。
        assert keys.len == values.len, "キーと値の個数は一致する必要があります"
        assert keyLimit >= 0, "keyLimitは非負である必要があります"
        let n = keys.len
        var height = 1
        var width = keyLimit
        while width > 1:
            width = (width - 1) div 2 + 1
            inc height
        result = RangeSortSegmentTree[T](
            roots: newSeq[int](n), next: newSeq[int](n), reversed: newSeq[bool](n),
            keyLimit: keyLimit, merge: merge, default: default,
            nodes: newSeqOfCap[RangeSortSegmentTreeNode[T]](1 + n * height),
            products: initSegmentTree(values, merge, default))
        result.nodes.add(RangeSortSegmentTreeNode[T](ascending: default, descending: default))
        var starts = newSeq[int](n)
        when compileOption("assertions"):
            result.activeKeys = initHashSet[int]()
        for i in 0..<n:
            assert 0 <= keys[i] and keys[i] < keyLimit, "キーは[0,keyLimit)内である必要があります"
            when compileOption("assertions"):
                assert keys[i] notin result.activeKeys, "キーは相異なる必要があります"
                result.activeKeys.incl(keys[i])
            result.roots[i] = result.singleton(0, keyLimit, keys[i], values[i])
            result.next[i] = i + 1
            starts[i] = i
        result.starts = initSegmentTree(starts, proc(x, y: int): int = max(x, y), -1)

    proc locate[T](self: RangeSortSegmentTree[T], index: int): tuple[node, key: int] =
        ## 現在の位置の葉とキーを取得します。O(log(N+1)+log(U+1))。
        assert 0 <= index and index < self.len, "添字は[0,len)内である必要があります"
        let start = self.starts.get(0, index + 1)
        var node = self.roots[start]
        var k = index - start
        if self.reversed[start]: k = self.nodes[node].count - 1 - k
        var l = 0
        var r = self.keyLimit
        while r - l > 1:
            let mid = l + (r - l) div 2
            let left = self.nodes[node].left
            if k < self.nodes[left].count:
                node = left
                r = mid
            else:
                k -= self.nodes[left].count
                node = self.nodes[node].right
                l = mid
        (node, l)

    proc `[]`*[T](self: RangeSortSegmentTree[T], index: int): T {.backwardsIndex.} =
        ## 現在の位置indexの値を取得します。O(log(N+1)+log(U+1))。
        self.nodes[self.locate(index).node].ascending

    proc key*[T](self: RangeSortSegmentTree[T], index: int): int =
        ## 現在の位置indexのキーを取得します。O(log(N+1)+log(U+1))。
        self.locate(index).key

    proc updateValue[T](self: RangeSortSegmentTree[T], node, l, r, key: int, value: T) =
        ## 指定キーの値と祖先の積を更新します。O(log(U+1))。
        if r - l == 1:
            self.nodes[node].ascending = value
            self.nodes[node].descending = value
            return
        let mid = l + (r - l) div 2
        if key < mid:
            self.updateValue(self.nodes[node].left, l, mid, key, value)
        else:
            self.updateValue(self.nodes[node].right, mid, r, key, value)
        self.pull(node)

    proc update*[T](self: RangeSortSegmentTree[T], index: int, value: T) =
        ## キーを保って値を変更します。O(log(N+1)+log(U+1))。
        let key = self.key(index)
        let start = self.starts.get(0, index + 1)
        self.updateValue(self.roots[start], 0, self.keyLimit, key, value)
        self.refresh(start)

    proc `[]=`*[T](self: RangeSortSegmentTree[T], index: int, value: T) {.backwardsIndex.} =
        ## キーを保って値を変更します。O(log(N+1)+log(U+1))。
        self.update(index, value)

    proc update*[T](self: RangeSortSegmentTree[T], index, key: int, value: T) =
        ## キーと値を変更します。O(log(N+1)+log(U+1))。他の要素とのキー重複は禁止です。
        assert 0 <= index and index < self.len, "添字は[0,len)内である必要があります"
        assert 0 <= key and key < self.keyLimit, "キーは[0,keyLimit)内である必要があります"
        when compileOption("assertions"):
            let oldKey = self.key(index)
            assert key == oldKey or key notin self.activeKeys, "キーは相異なる必要があります"
            self.activeKeys.excl(oldKey)
            self.activeKeys.incl(key)
        self.cut(index)
        self.cut(index + 1)
        self.releaseSingleton(self.roots[index])
        let root = self.singleton(0, self.keyLimit, key, value)
        self.roots[index] = root
        self.reversed[index] = false
        self.refresh(index)

    proc get*[T](self: RangeSortSegmentTree[T], l, r: int): T =
        ## 現在の並び順で[l,r)の積を返します。空区間は単位元。O(log(N+1)+log(U+1))。
        assert 0 <= l and l <= r and r <= self.len, "区間は0 <= l <= r <= lenを満たす必要があります"
        if l == r: return self.default
        self.cut(l)
        self.cut(r)
        self.products.get(l, r)

    proc get*[T](self: RangeSortSegmentTree[T], segment: HSlice[int, int]): T =
        ## スライスで指定した区間の積を返します。O(log(N+1)+log(U+1))。
        assert 0 <= segment.a and segment.a <= self.len and
            segment.a - 1 <= segment.b and segment.b < self.len, "区間が範囲外です"
        self.get(segment.a, segment.b + 1)

    proc `[]`*[T](self: RangeSortSegmentTree[T], segment: HSlice[int, int]): T =
        ## スライスで指定した区間の積を返します。O(log(N+1)+log(U+1))。
        self.get(segment)

    proc get_all*[T](self: RangeSortSegmentTree[T]): T =
        ## 全体の積をO(1)で返します。
        self.products.get_all()

    proc sort*[T](self: RangeSortSegmentTree[T], l, r: int,
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
            self.products[start] = self.default
            self.starts[start] = -1
            start = self.next[start]
        self.roots[l] = root
        self.next[l] = r
        self.reversed[l] = order == Descending
        self.refresh(l)

    proc sort*[T](self: RangeSortSegmentTree[T], segment: HSlice[int, int],
            order: SortOrder = Ascending) =
        ## スライスで指定した区間をソートします。償却O(log(N+1)+log(U+1))。
        assert 0 <= segment.a and segment.a <= self.len and
            segment.a - 1 <= segment.b and segment.b < self.len, "区間が範囲外です"
        self.sort(segment.a, segment.b + 1, order)
