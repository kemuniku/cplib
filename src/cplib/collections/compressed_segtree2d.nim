when not declared CPLIB_COLLECTIONS_COMPRESSED_SEGTREE2D:
    const CPLIB_COLLECTIONS_COMPRESSED_SEGTREE2D* = 1
    import algorithm

    type CompressedSegmentTree2D*[K, T] = ref object
        xs, ys: seq[K]
        offsets: seq[int]
        data: seq[T]
        base, count: int
        default: T
        merge: proc(x, y: T): T
        updateImpl: proc(self: CompressedSegmentTree2D[K, T], x, y: K, value: T)
        rangeImpl: proc(self: CompressedSegmentTree2D[K, T], xl, xr, yl, yr: K): T

    proc initCompressedSegmentTree2D*[K, T](points: openArray[(K, K)],
            merge: proc(x, y: T): T, default: T): CompressedSegmentTree2D[K, T] =
        ## 更新座標を事前登録し、全点を単位元で初期化します。時間・空間O(N log N)。
        ## mergeには可換モノイドの演算、defaultには単位元を指定してください。
        ## 重複点は一つにまとめます。構築後の座標追加はできません。
        ## Kには一貫した < と == が必要です。内側の木は葉数を2冪に丸めません。
        ## 各ノードのy座標数の総和をMとすると、座標M個・集約値2M個とO(N)の管理領域を保持します。
        var ps = @points
        ps.sort(proc(a, b: (K, K)): int =
            if a[0] < b[0]: -1
            elif b[0] < a[0]: 1
            elif a[1] < b[1]: -1
            elif b[1] < a[1]: 1
            else: 0)
        var n = 0
        for i in 0..<ps.len:
            if n == 0 or ps[n - 1] != ps[i]:
                ps[n] = ps[i]
                inc n
        ps.setLen(n)
        result = CompressedSegmentTree2D[K, T](default: default, merge: merge, count: n, base: 1)
        var ranked = newSeq[tuple[y: K, x: int]](n)
        for i, p in ps:
            if result.xs.len == 0 or result.xs[^1] != p[0]: result.xs.add(p[0])
            ranked[i] = (p[1], result.xs.len - 1)
        while result.base < result.xs.len: result.base *= 2
        ranked.sort(proc(a, b: tuple[y: K, x: int]): int =
            if a.y < b.y: -1
            elif b.y < a.y: 1
            else: 0)
        let nodes = result.base * 2
        result.offsets = newSeq[int](nodes + 1)
        var cursor = newSeq[int](nodes)
        cursor.fill(-1)
        # 必要な座標数を先に数え、座標・集約値の配列を一度だけ確保します。
        for i, p in ranked:
            var node = result.base + p.x
            while node > 0:
                if cursor[node] != -1 and ranked[cursor[node]].y == p.y: break
                inc result.offsets[node + 1]
                cursor[node] = i
                node = node shr 1
        for i in 1..nodes: result.offsets[i] += result.offsets[i - 1]
        result.ys = newSeq[K](result.offsets[nodes])
        result.data = newSeq[T](2 * result.ys.len)
        result.data.fill(default)
        cursor.fill(0)
        for p in ranked:
            var node = result.base + p.x
            while node > 0:
                let start = result.offsets[node]
                if cursor[node] > 0 and result.ys[start + cursor[node] - 1] == p.y: break
                result.ys[start + cursor[node]] = p.y
                inc cursor[node]
                node = node shr 1

    proc yIndex[K, T](self: CompressedSegmentTree2D[K, T], node: int, y: K): int {.inline.} =
        ## ノード内のyのlowerBoundをO(log N)で返します。
        let start = self.offsets[node]
        var l = start
        var r = self.offsets[node + 1]
        while l < r:
            let m = (l + r) shr 1
            if self.ys[m] < y: l = m + 1
            else: r = m
        l - start

    proc valueAt[K, T](self: CompressedSegmentTree2D[K, T], node: int, y: K): T {.inline.} =
        ## ノード内のyの値をO(log N)で返します。未登録なら単位元です。
        let start = self.offsets[node]
        let size = self.offsets[node + 1] - start
        let i = self.yIndex(node, y)
        if i < size and self.ys[start + i] == y: self.data[2 * start + size + i]
        else: self.default

    template updateBody(self, x, y, value, mergeOp: untyped): untyped =
        ## 葉から祖先へ同じyの値を再計算し、O(log² N)で上書きします。
        let xi = self.xs.lowerBound(x)
        assert xi < self.xs.len and self.xs[xi] == x, "更新する座標は事前登録してください"
        var node = self.base + xi
        var yi = self.yIndex(node, y)
        assert yi < self.offsets[node + 1] - self.offsets[node] and
            self.ys[self.offsets[node] + yi] == y, "更新する座標は事前登録してください"
        var current = value
        while true:
            let start = self.offsets[node]
            var pos = self.offsets[node + 1] - start + yi
            self.data[2 * start + pos] = current
            while pos > 1:
                pos = pos shr 1
                self.data[2 * start + pos] = mergeOp(self.data[2 * start + 2 * pos],
                    self.data[2 * start + 2 * pos + 1])
            if node == 1: break
            # 更新した子の値は既知なので、兄弟側だけを探索します。
            current = mergeOp(current, self.valueAt(node xor 1, y))
            node = node shr 1
            yi = self.yIndex(node, y)

    template rangeBody(self, xl, xr, yl, yr, mergeOp: untyped): untyped =
        ## 半開長方形内の登録点の積をO(log² N)で求めます。
        assert not (xr < xl) and not (yr < yl), "区間の左端は右端以下にしてください"
        var acc = self.default
        if xl < xr and yl < yr:
            var l = self.xs.lowerBound(xl) + self.base
            var r = self.xs.lowerBound(xr) + self.base
            template consume(node: int) =
                ## 内側の木からy区間を集約します。
                let start = self.offsets[node]
                let size = self.offsets[node + 1] - start
                var a = self.yIndex(node, yl) + size
                var b = self.yIndex(node, yr) + size
                while a < b:
                    if (a and 1) != 0:
                        acc = mergeOp(acc, self.data[2 * start + a])
                        inc a
                    if (b and 1) != 0:
                        dec b
                        acc = mergeOp(acc, self.data[2 * start + b])
                    a = a shr 1
                    b = b shr 1
            while l < r:
                if (l and 1) != 0:
                    consume(l)
                    inc l
                if (r and 1) != 0:
                    dec r
                    consume(r)
                l = l shr 1
                r = r shr 1
        acc

    proc update*[K, T](self: CompressedSegmentTree2D[K, T], x, y: K, value: T) =
        ## 登録点(x,y)をO(log² N)で上書きします。
        if self.updateImpl == nil: self.updateBody(x, y, value, self.merge)
        else: self.updateImpl(self, x, y, value)

    proc `[]=`*[K, T](self: CompressedSegmentTree2D[K, T], x, y: K, value: T) =
        ## 登録点(x,y)をO(log² N)で上書きします。
        self.update(x, y, value)

    proc `[]`*[K, T](self: CompressedSegmentTree2D[K, T], x, y: K): T =
        ## 点の値をO(log N)で返します。未登録なら単位元です。
        let xi = self.xs.lowerBound(x)
        if xi < self.xs.len and self.xs[xi] == x: self.valueAt(self.base + xi, y)
        else: self.default

    proc get*[K, T](self: CompressedSegmentTree2D[K, T], xl, xr, yl, yr: K): T =
        ## [xl,xr)×[yl,yr)の積をO(log² N)で返します。境界は未登録でも構いません。
        if self.rangeImpl == nil: self.rangeBody(xl, xr, yl, yr, self.merge)
        else: self.rangeImpl(self, xl, xr, yl, yr)

    proc get_all*[K, T](self: CompressedSegmentTree2D[K, T]): T =
        ## 全登録点の積をO(1)で返します。空なら単位元です。
        if self.count == 0: self.default
        else: self.data[2 * self.offsets[1] + 1]

    proc len*[K, T](self: CompressedSegmentTree2D[K, T]): int =
        ## 重複除去後の登録点数をO(1)で返します。
        self.count

    template newCompressedSeg2DWith*(points, merge, default: untyped): untyped =
        ## 式中のl,rで可換な演算を指定し、時間・空間O(N log N)で生成します。
        ## 更新・取得ではマージ関数を直接呼び出します。
        block:
            proc directMerge(l {.inject.}, r {.inject.}: typeof(default)): typeof(default) {.gensym.} =
                ## 指定した式で二つの値をマージします。
                merge
            let tree = initCompressedSegmentTree2D(points,
                proc(x, y: typeof(default)): typeof(default) = directMerge(x, y), default)
            type Coord = typeof(points[0][0])
            tree.updateImpl = proc(self: typeof(tree), x, y: Coord, value: typeof(default)) =
                ## マージを直接呼び出して点を更新します。
                self.updateBody(x, y, value, directMerge)
            tree.rangeImpl = proc(self: typeof(tree), xl, xr, yl, yr: Coord): typeof(default) =
                ## マージを直接呼び出して長方形の積を求めます。
                self.rangeBody(xl, xr, yl, yr, directMerge)
            tree
