when not declared CPLIB_COLLECTIONS_MERGESORTTREE:
    const CPLIB_COLLECTIONS_MERGESORTTREE* = 1
    import algorithm, options
    import cplib/collections/private/mergesorttree_queries

    type MergeSortTree*[T] = ref object
        values: seq[T]
        data: seq[seq[T]]
        base: int

    proc initMergeSortTree*[T](v: openArray[T]): MergeSortTree[T] =
        ## 静的な列から時間・空間O(N log(N+1)+1)で構築します。空列にも対応します。
        ## 各区間にソート列を保持します。Tの比較は一貫した全順序にしてください。
        result = MergeSortTree[T](values: @v, base: 1)
        while result.base < v.len: result.base *= 2
        result.data = newSeq[seq[T]](result.base * 2)
        for i, x in v: result.data[result.base + i] = @[x]
        for node in countdown(result.base - 1, 1):
            let left = result.data[node * 2]
            let right = result.data[node * 2 + 1]
            var merged = newSeq[T](left.len + right.len)
            var a = 0
            var b = 0
            for i in 0..<merged.len:
                if b == right.len or (a < left.len and not (right[b] < left[a])):
                    merged[i] = left[a]
                    inc a
                else:
                    merged[i] = right[b]
                    inc b
            result.data[node] = move(merged)

    proc nodeValue[T](values: seq[T], i: int): T =
        ## ノード内のi番目の値をO(1)で取得します。
        values[i]

    defineMergeSortTreeQueries(MergeSortTree, nodeValue)
