when not declared CPLIB_COLLECTIONS_MERGESORTTREE_QUERIES:
    const CPLIB_COLLECTIONS_MERGESORTTREE_QUERIES = 1
    import options

    template defineMergeSortTreeQueries*(Tree, nodeValue, nodeCount, nodeLower, nodeUpper, nodeLen: untyped) =
        ## ソート列または順位付き多重集合を使う共通の区間検索を定義します。
        iterator rangeNodes[T](self: Tree[T], left, right: int): int =
            ## [left,right)を覆うO(log N)個のノードを列挙します。
            assert 0 <= left and left <= right and right <= self.values.len,
                "区間は0 <= l <= r <= lenを満たす必要があります"
            var l = left + self.base
            var r = right + self.base
            while l < r:
                if (l and 1) != 0:
                    yield l
                    inc l
                if (r and 1) != 0:
                    dec r
                    yield r
                l = l shr 1
                r = r shr 1

        proc len*[T](self: Tree[T]): int =
            ## 列の長さをO(1)で返します。
            self.values.len

        proc `[]`*[T](self: Tree[T], i: int): T =
            ## i番目の要素をO(1)で返します。
            assert 0 <= i and i < self.values.len, "添字は0 <= i < lenを満たす必要があります"
            self.values[i]

        proc get*[T](self: Tree[T], i: int): T =
            ## i番目の要素をO(1)で返します。
            self[i]

        proc range_lowerbound*[T](self: Tree[T], l, r: int, x: T): int =
            ## [l,r)内のx未満の要素数を最悪O(log² N)で返します。
            for node in rangeNodes(self, l, r):
                result += nodeLower(self, node, x)

        proc range_upperbound*[T](self: Tree[T], l, r: int, x: T): int =
            ## [l,r)内のx以下の要素数を最悪O(log² N)で返します。
            for node in rangeNodes(self, l, r):
                result += nodeUpper(self, node, x)

        proc count*[T](self: Tree[T], l, r: int, x: T): int =
            ## [l,r)内のxの出現回数を最悪O(log² N)で返します。
            for node in rangeNodes(self, l, r):
                result += nodeCount(self, node, x)

        proc range_freq*[T](self: Tree[T], l, r: int, low, high: T): int =
            ## [l,r)内で値が[low,high)に入る個数を最悪O(log² N)で返します。
            assert 0 <= l and l <= r and r <= self.values.len,
                "区間は0 <= l <= r <= lenを満たす必要があります"
            if not (low < high): return 0
            self.range_lowerbound(l, r, high) - self.range_lowerbound(l, r, low)

        proc prev_value*[T](self: Tree[T], l, r: int, x: T): Option[T] =
            ## [l,r)内のx未満の最大値を最悪O(log² N)で返します。なければnone(T)。
            result = none(T)
            for node in rangeNodes(self, l, r):
                let i = nodeLower(self, node, x)
                if i > 0:
                    let candidate = nodeValue(self, node, i - 1)
                    if result.isNone or result.get < candidate: result = some(candidate)

        proc next_value*[T](self: Tree[T], l, r: int, x: T): Option[T] =
            ## [l,r)内のx以上の最小値を最悪O(log² N)で返します。なければnone(T)。
            result = none(T)
            for node in rangeNodes(self, l, r):
                let i = nodeLower(self, node, x)
                if i < nodeLen(self, node):
                    let candidate = nodeValue(self, node, i)
                    if result.isNone or candidate < result.get: result = some(candidate)

        proc kth_smallest*[T](self: Tree[T], l, r, k: int): T =
            ## [l,r)内の小さい順でk番目(0-indexed)を最悪O(log³ N)で返します。
            ## 根の要素の順位を二分探索するため、Tの算術や値域の事前登録は不要です。
            assert 0 <= l and l <= r and r <= self.values.len,
                "区間は0 <= l <= r <= lenを満たす必要があります"
            assert 0 <= k and k < r - l, "順位は0 <= k < r-lを満たす必要があります"
            var a = 0
            var b = self.values.len - 1
            while a < b:
                let m = a + (b - a) div 2
                if self.range_upperbound(l, r, nodeValue(self, 1, m)) > k: b = m
                else: a = m + 1
            nodeValue(self, 1, a)

        proc kth_largest*[T](self: Tree[T], l, r, k: int): T =
            ## [l,r)内の大きい順でk番目(0-indexed)を最悪O(log³ N)で返します。
            assert 0 <= l and l <= r and r <= self.values.len,
                "区間は0 <= l <= r <= lenを満たす必要があります"
            assert 0 <= k and k < r - l, "順位は0 <= k < r-lを満たす必要があります"
            self.kth_smallest(l, r, r - l - 1 - k)
