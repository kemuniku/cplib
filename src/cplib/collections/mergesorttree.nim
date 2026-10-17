when not declared CPLIB_COLLECTIONS_MERGESORTTREE:
    const CPLIB_COLLECTIONS_MERGESORTTREE* = 1
    import options
    import cplib/collections/private/mergesorttree_queries

    type MergeSortTree*[T] = ref object
        values: seq[T]
        data: seq[seq[T]]
        base: int

    proc initMergeSortTree*[T](v: openArray[T]): MergeSortTree[T] =
        ## 静的な列から時間・空間O(N log(N+1)+1)で構築します。空列にも対応します。
        ## 各区間にソート列を保持します。Tの比較は一貫した全順序にしてください。
        ## 静的版は<だけを使い、同じ順位の値を同値として数えます。
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

    proc nodeValue[T](self: MergeSortTree[T], node, i: int): T =
        ## ノード内のi番目の値をO(1)で取得します。
        self.data[node][i]

    proc lowerIndex[T](values: openArray[T], x: T, first = 0,
            pastLast = -1): int {.inline.} =
        ## 比較関数を経由せず、<だけで下限を探します。
        result = first
        var high = if pastLast < 0: values.len else: pastLast
        while result < high:
            let mid = result + (high - result) div 2
            if values[mid] < x: result = mid + 1
            else: high = mid

    proc upperIndex[T](values: openArray[T], x: T, first = 0,
            pastLast = -1): int {.inline.} =
        ## 既知の下限から<だけで上限を探します。
        result = first
        var high = if pastLast < 0: values.len else: pastLast
        while result < high:
            let mid = result + (high - result) div 2
            if x < values[mid]: high = mid
            else: result = mid + 1

    proc valueCount[T](values: openArray[T], x: T): int {.inline.} =
        ## 上下限の共通探索を共有し、出現回数をO(log N)で数えます。
        var low = 0
        var high = values.len
        while low < high:
            let mid = low + (high - low) div 2
            if values[mid] < x: low = mid + 1
            elif x < values[mid]: high = mid
            else:
                return upperIndex(values, x, mid + 1, high) -
                        lowerIndex(values, x, low, mid)

    proc nodeLower[T](self: MergeSortTree[T], node: int, x: T): int {.inline.} =
        ## ノード内のx未満の個数をO(log N)で返します。
        lowerIndex(self.data[node], x)

    proc nodeUpper[T](self: MergeSortTree[T], node: int, x: T, first = 0,
            pastLast = -1): int {.inline.} =
        ## ノード内のx以下の個数をO(log N)で返します。
        upperIndex(self.data[node], x, first, pastLast)

    proc nodeLen[T](self: MergeSortTree[T], node: int): int =
        ## ノードの要素数をO(1)で返します。
        self.data[node].len

    proc nodeCount[T](self: MergeSortTree[T], node: int, x: T): int {.inline.} =
        ## ノード内の出現回数をO(log N)で返します。
        valueCount(self.data[node], x)

    defineMergeSortTreeQueries(MergeSortTree, nodeValue, nodeCount,
            nodeLower, nodeUpper, nodeLen, true)
