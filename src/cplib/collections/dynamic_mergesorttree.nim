when not declared CPLIB_COLLECTIONS_DYNAMIC_MERGESORTTREE:
    const CPLIB_COLLECTIONS_DYNAMIC_MERGESORTTREE* = 1
    import options
    import cplib/collections/avlset
    import cplib/collections/private/mergesorttree_queries

    type DynamicMergeSortTree*[T] = ref object
        values: seq[T]
        data: seq[AvlSortedMultiSet[T]]
        base: int

    proc initDynamicMergeSortTree*[T](v: openArray[T]): DynamicMergeSortTree[T] =
        ## 固定長の列から最悪O(N log²(N+1)+1)時間・O(N log(N+1)+1)空間で構築します。
        ## 各区間にAVL多重集合を保持し、更新値の事前登録は不要です。
        ## Tには全順序として一貫した <、<=、== が必要です。
        result = DynamicMergeSortTree[T](values: @v, base: 1)
        while result.base < v.len: result.base *= 2
        result.data = newSeq[AvlSortedMultiSet[T]](result.base * 2)
        for i, x in v:
            var node = result.base + i
            while node > 0:
                result.data[node].incl(x)
                node = node shr 1

    proc nodeValue[T](values: AvlSortedMultiSet[T], i: int): T =
        ## ノード内のi番目の値を最悪O(log N)で取得します。
        values[i]

    defineMergeSortTreeQueries(DynamicMergeSortTree, nodeValue)

    proc update*[T](self: DynamicMergeSortTree[T], i: int, value: T) =
        ## i番目を最悪O(log² N)で代入します。各祖先で旧値を1個だけ削除します。
        assert 0 <= i and i < self.values.len, "添字は0 <= i < lenを満たす必要があります"
        let old = self.values[i]
        if old == value: return
        var node = self.base + i
        while node > 0:
            self.data[node].excl(old)
            self.data[node].incl(value)
            node = node shr 1
        self.values[i] = value

    proc `[]=`*[T](self: DynamicMergeSortTree[T], i: int, value: T) =
        ## i番目を最悪O(log² N)で代入します。列の長さは変わりません。
        self.update(i, value)
