when not declared CPLIB_COLLECTIONS_MERGE_SORT_TREE:
    const CPLIB_COLLECTIONS_MERGE_SORT_TREE* = 1

    type MergeSortTree*[T] = ref object
        nodes: seq[T]
        length: int

    proc build[T](self: MergeSortTree[T], leaves: openArray[T],
            merge: proc(left, right: T): T, node, lo, hi: int) =
        ## [lo, hi) を表す部分木を構築します。
        if hi - lo == 1:
            self.nodes[node] = leaves[lo]
            return
        let mid = lo + (hi - lo) div 2
        let left = node + 1
        # ノードを行きがけ順に格納し、左部分木の 2 * (mid - lo) - 1 ノードの直後に右部分木を置きます。
        let right = node + 2 * (mid - lo)
        self.build(leaves, merge, left, lo, mid)
        self.build(leaves, merge, right, mid, hi)
        self.nodes[node] = merge(self.nodes[left], self.nodes[right])

    proc initMergeSortTree*[T](leaves: openArray[T],
            merge: proc(left, right: T): T): MergeSortTree[T] =
        ## 葉の値からマージソート木を構築します。
        ## 各内部ノードで merge に左の子と右の子の値をこの順で渡します。
        ## マージが区間長に比例する場合、構築時間は O(N log N) です。
        result = MergeSortTree[T](length: leaves.len)
        if leaves.len > 0:
            result.nodes = newSeq[T](2 * leaves.len - 1)
            result.build(leaves, merge, 0, 0, leaves.len)

    proc len*[T](self: MergeSortTree[T]): int =
        ## 葉の個数を O(1) で返します。
        self.length

    proc visitRange[T](self: MergeSortTree[T], node, lo, hi, l, r: int,
            visit: proc(value: var T)) =
        ## [lo, hi) と交差する [l, r) の部分を処理します。
        if l <= lo and hi <= r:
            visit(self.nodes[node])
            return
        let mid = lo + (hi - lo) div 2
        if l < mid:
            self.visitRange(node + 1, lo, mid, l, r, visit)
        if mid < r:
            self.visitRange(node + 2 * (mid - lo), mid, hi, l, r, visit)

    proc forEachNode*[T](self: MergeSortTree[T], l, r: int,
            visit: proc(value: var T)) =
        ## 半開区間 [l, r) を構成する各ノードの値を、左から順に参照渡しで処理します。
        ## 区間分解と呼び出し回数は O(log N) です。空区間での呼び出し回数は 0 回です。
        ## 値を書き換える場合、ノード間の整合性は呼び出し側で管理してください。
        assert 0 <= l and l <= r and r <= self.length, "区間は 0 <= l <= r <= len を満たす必要があります"
        if l < r:
            self.visitRange(0, 0, self.length, l, r, visit)
