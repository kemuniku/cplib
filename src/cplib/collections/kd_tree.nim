## 静的点集合のkd-treeです。範囲は各軸とも閉区間で、返す番号は入力時の0-based indexです。
## 最近傍の距離二乗は座標型Tで計算します。差・積・和がTの範囲内に収まる必要があります。
## 浮動小数点の最近傍はTで丸めた距離二乗に基づきます。中間値も有限であることが前提です。
## 浮動小数点の座標・問い合わせは有限値のみ。比較にGEOMETRY_EPSは使いません。
when not declared CPLIB_COLLECTIONS_KD_TREE:
    const CPLIB_COLLECTIONS_KD_TREE* = 1
    import math
    import cplib/geometry/base

    type KDTree*[K: static[int]; T: SomeNumber] = object
        points: seq[array[K, T]]
        order, minIndex: seq[int]
        lower, upper: seq[array[K, T]]

    proc checkKDPoint[K: static[int]; T: SomeNumber](p: array[K, T]) =
        ## 浮動小数点の非有限座標をO(K)で拒否します。
        when T is SomeFloat:
            for x in p:
                if classify(x) in {fcNan, fcInf, fcNegInf}:
                    raise newException(ValueError, "kd-treeの座標は有限値にしてください")

    proc axisLess[K: static[int]; T: SomeNumber](self: KDTree[K, T]; a, b, axis: int): bool =
        ## 分割軸の座標、元indexの順でO(1)比較します。
        let x = self.points[a][axis]
        let y = self.points[b][axis]
        x < y or (x == y and a < b)

    proc selectKDMedian[K: static[int]; T: SomeNumber](self: var KDTree[K, T]; first, last, target, axis: int) =
        ## median of mediansで[first,last)のtarget番目を最悪O(last-first)で選択します。
        var l = first
        var r = last
        while r - l > 1:
            var medians = l
            var start = l
            while start < r:
                let finish = start + min(5, r - start)
                for i in start + 1..<finish:
                    var j = i
                    while j > start and self.axisLess(self.order[j], self.order[j - 1], axis):
                        swap(self.order[j], self.order[j - 1])
                        dec j
                swap(self.order[medians], self.order[start + (finish - start) div 2])
                inc medians
                start = finish
            let middle = l + (medians - l) div 2
            self.selectKDMedian(l, medians, middle, axis)
            let pivot = self.order[middle]
            var a = l
            var i = l
            var b = r
            while i < b:
                if self.axisLess(self.order[i], pivot, axis):
                    swap(self.order[a], self.order[i])
                    inc a
                    inc i
                elif self.axisLess(pivot, self.order[i], axis):
                    dec b
                    swap(self.order[i], self.order[b])
                else:
                    inc i
            if target < a: r = a
            elif target >= b: l = b
            else: return

    proc buildKDTree[K: static[int]; T: SomeNumber](self: var KDTree[K, T]; l, r, depth: int) =
        ## 点数中央値で平衡化し、部分木のbounding boxと最小indexを構築します。
        if l >= r: return
        let m = l + (r - l) div 2
        self.selectKDMedian(l, r, m, depth mod K)
        self.buildKDTree(l, m, depth + 1)
        self.buildKDTree(m + 1, r, depth + 1)
        self.lower[m] = self.points[self.order[m]]
        self.upper[m] = self.lower[m]
        self.minIndex[m] = self.order[m]
        for child in [l + (m - l) div 2, m + 1 + (r - m - 1) div 2]:
            if child == m or child == r: continue
            self.minIndex[m] = min(self.minIndex[m], self.minIndex[child])
            for axis in 0..<K:
                self.lower[m][axis] = min(self.lower[m][axis], self.lower[child][axis])
                self.upper[m][axis] = max(self.upper[m][axis], self.upper[child][axis])

    proc initKDTree*[K: static[int]; T: SomeNumber](points: openArray[array[K, T]]): KDTree[K, T] =
        ## 入力を複製して構築します。最悪時間O(N log N + KN)、空間O(KN)、Kは正です。
        static: assert K > 0, "kd-treeの次元は正にしてください"
        result.points = @points
        result.order = newSeq[int](points.len)
        result.minIndex = newSeq[int](points.len)
        result.lower = newSeq[array[K, T]](points.len)
        result.upper = newSeq[array[K, T]](points.len)
        for i, p in points:
            checkKDPoint(p)
            result.order[i] = i
        result.buildKDTree(0, points.len, 0)

    proc initKDTree*[T: SomeNumber](points: openArray[Point[T]]): KDTree[2, T] =
        ## 既存の2D Point列を複製して構築します。時間O(N log N)、空間O(N)。
        var coordinates = newSeq[array[2, T]](points.len)
        for i, p in points: coordinates[i] = [p.x, p.y]
        initKDTree(coordinates)

    proc len*[K: static[int]; T: SomeNumber](self: KDTree[K, T]): int =
        ## 重複を含む入力点数をO(1)で返します。default(KDTree)も空の木です。
        self.points.len

    proc rangeKDTree[K: static[int]; T: SomeNumber; Collect: static[bool]](self: KDTree[K, T]; l, r: int; lower, upper: array[K, T]; output: var seq[int]): int =
        ## boxを使って枝刈りし、包含された部分木は一括で数えます。
        if l >= r: return
        let m = l + (r - l) div 2
        var contained = true
        for axis in 0..<K:
            if self.upper[m][axis] < lower[axis] or upper[axis] < self.lower[m][axis]: return
            if self.lower[m][axis] < lower[axis] or upper[axis] < self.upper[m][axis]: contained = false
        if contained:
            when Collect:
                for i in l..<r: output.add(self.order[i])
            return r - l
        var inside = true
        let p = self.points[self.order[m]]
        for axis in 0..<K:
            if p[axis] < lower[axis] or upper[axis] < p[axis]: inside = false
        if inside:
            inc result
            when Collect: output.add(self.order[m])
        result += rangeKDTree[K, T, Collect](self, l, m, lower, upper, output)
        result += rangeKDTree[K, T, Collect](self, m + 1, r, lower, upper, output)

    proc validKDRange[K: static[int]; T: SomeNumber](lower, upper: array[K, T]): bool =
        ## 端点を検証し、逆転した閉区間ならfalseをO(K)で返します。
        checkKDPoint(lower)
        checkKDPoint(upper)
        for axis in 0..<K:
            if upper[axis] < lower[axis]: return false
        true

    proc rangeSearch*[K: static[int]; T: SomeNumber](self: KDTree[K, T]; lower, upper: array[K, T]): seq[int] =
        ## 閉区間の直積内にある元indexを列挙します。順序未規定、最悪O(KN + M)。
        if validKDRange(lower, upper):
            discard rangeKDTree[K, T, true](self, 0, self.len, lower, upper, result)

    proc rangeCount*[K: static[int]; T: SomeNumber](self: KDTree[K, T]; lower, upper: array[K, T]): int =
        ## 閉区間の直積内の点数を返します。重複も数え、最悪O(KN)。
        var unused: seq[int]
        if validKDRange(lower, upper):
            result = rangeKDTree[K, T, false](self, 0, self.len, lower, upper, unused)

    proc rangeSearch*[T: SomeNumber](self: KDTree[2, T]; lower, upper: Point[T]): seq[int] =
        ## 2D Pointで閉矩形を指定し、元indexを列挙します。最悪O(N + M)。
        self.rangeSearch([lower.x, lower.y], [upper.x, upper.y])

    proc rangeCount*[T: SomeNumber](self: KDTree[2, T]; lower, upper: Point[T]): int =
        ## 2D Pointで指定した閉矩形の点数を返します。最悪O(N)。
        self.rangeCount([lower.x, lower.y], [upper.x, upper.y])

    proc kdDistanceSquared[K: static[int]; T: SomeNumber](a, b: array[K, T]): T =
        ## ユークリッド距離二乗をTでO(K)計算します。全中間値がTに収まることが前提です。
        for axis in 0..<K:
            let d = if a[axis] < b[axis]: b[axis] - a[axis] else: a[axis] - b[axis]
            result += d * d

    proc kdBoxDistance[K: static[int]; T: SomeNumber](self: KDTree[K, T]; node: int; p: array[K, T]): T =
        ## 点からboxまでの距離二乗の下界をTでO(K)計算します。
        for axis in 0..<K:
            var d: T
            if p[axis] < self.lower[node][axis]: d = self.lower[node][axis] - p[axis]
            elif self.upper[node][axis] < p[axis]: d = p[axis] - self.upper[node][axis]
            result += d * d

    proc nearestKDTree[K: static[int]; T: SomeNumber](self: KDTree[K, T]; l, r: int; p: array[K, T]; best: var int; distance: var T) =
        ## boxの距離下界と最小indexで枝刈りし、距離の近い部分木から探索します。
        if l >= r: return
        let m = l + (r - l) div 2
        let bound = self.kdBoxDistance(m, p)
        if best >= 0 and (distance < bound or (distance == bound and best <= self.minIndex[m])): return
        let index = self.order[m]
        let d = kdDistanceSquared(p, self.points[index])
        if best < 0 or d < distance or (d == distance and index < best):
            best = index
            distance = d
        let left = l + (m - l) div 2
        let right = m + 1 + (r - m - 1) div 2
        if left != m and right != r and self.kdBoxDistance(right, p) < self.kdBoxDistance(left, p):
            self.nearestKDTree(m + 1, r, p, best, distance)
            self.nearestKDTree(l, m, p, best, distance)
        else:
            self.nearestKDTree(l, m, p, best, distance)
            self.nearestKDTree(m + 1, r, p, best, distance)

    proc nearestNeighbor*[K: static[int]; T: SomeNumber](self: KDTree[K, T]; p: array[K, T]): int =
        ## 最近傍の元indexを返します。同距離は最小index、空なら-1。最悪O(KN)。
        checkKDPoint(p)
        result = -1
        var distance: T
        self.nearestKDTree(0, self.len, p, result, distance)

    proc nearestNeighbor*[T: SomeNumber](self: KDTree[2, T]; p: Point[T]): int =
        ## 2D Pointの最近傍の元indexを返します。同距離は最小index、空なら-1。最悪O(N)。
        self.nearestNeighbor([p.x, p.y])
