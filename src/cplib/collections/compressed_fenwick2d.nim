## 更新座標を事前登録する2次元Fenwick treeです。取得範囲は半開区間です。
## Tの初期値を加法単位元とし、+=と減算による可換群を扱います。
when not declared CPLIB_COLLECTIONS_COMPRESSED_FENWICK2D:
    const CPLIB_COLLECTIONS_COMPRESSED_FENWICK2D* = 1
    import algorithm

    type CompressedFenwick2D*[K, T] = ref object
        xs, ys, pointYs: seq[K]
        offsets, pointOffsets: seq[int]
        data, pointValues: seq[T]

    proc initCompressedFenwick2DImpl[K, T, P](points: openArray[P]): CompressedFenwick2D[K, T] =
        ## 座標の圧縮と必要に応じた初期値の一括構築をO(N log N)で行います。
        mixin `+=`
        var ps = @points
        ps.sort(proc(a, b: P): int =
            if a[0] < b[0]: -1
            elif b[0] < a[0]: 1
            elif a[1] < b[1]: -1
            elif b[1] < a[1]: 1
            else: 0)
        var count = 0
        for i in 0..<ps.len:
            if count == 0 or ps[count - 1][0] != ps[i][0] or ps[count - 1][1] != ps[i][1]:
                ps[count] = ps[i]
                inc count
            else:
                when compiles(ps[i][2]): ps[count - 1][2] += ps[i][2]
        ps.setLen(count)
        result = CompressedFenwick2D[K, T](pointYs: newSeq[K](count), pointValues: newSeq[T](count))
        var ranked = newSeq[tuple[y: K, x: int]](count)
        for i, p in ps:
            if result.xs.len == 0 or result.xs[^1] != p[0]:
                result.xs.add(p[0])
                result.pointOffsets.add(i)
            result.pointYs[i] = p[1]
            when compiles(p[2]): result.pointValues[i] = p[2]
            ranked[i] = (p[1], result.xs.len)
        result.pointOffsets.add(count)
        let n = result.xs.len
        ranked.sort(proc(a, b: tuple[y: K, x: int]): int =
            if a.y < b.y: -1
            elif b.y < a.y: 1
            else: 0)
        result.offsets = newSeq[int](n + 2)
        var cursor = newSeq[int](n + 1)
        cursor.fill(-1)
        # 必要な座標数を数えてから、内側の配列を一度だけ確保します。
        for i, p in ranked:
            var node = p.x
            while node <= n:
                if cursor[node] != -1 and ranked[cursor[node]].y == p.y: break
                inc result.offsets[node + 1]
                cursor[node] = i
                node += node and -node
        for i in 1..n + 1: result.offsets[i] += result.offsets[i - 1]
        result.ys = newSeq[K](result.offsets[n + 1])
        result.data = newSeq[T](result.ys.len)
        cursor.fill(0)
        when compiles(ps[0][2]):
            var pointCursor = newSeq[int](n)
        for p in ranked:
            var node = p.x
            when compiles(ps[0][2]):
                let xi = p.x - 1
                let value = result.pointValues[result.pointOffsets[xi] + pointCursor[xi]]
                inc pointCursor[xi]
            while node <= n:
                let start = result.offsets[node]
                if cursor[node] > 0 and result.ys[start + cursor[node] - 1] == p.y:
                    when compiles(ps[0][2]): result.data[start + cursor[node] - 1] += value
                    else: break
                else:
                    let index = start + cursor[node]
                    result.ys[index] = p.y
                    when compiles(ps[0][2]): result.data[index] += value
                    inc cursor[node]
                node += node and -node
        when compiles(ps[0][2]):
            for node in 1..n:
                let start = result.offsets[node]
                let size = result.offsets[node + 1] - start
                for i in 0..<size:
                    let parent = i or (i + 1)
                    if parent < size: result.data[start + parent] += result.data[start + i]

    proc initCompressedFenwick2D*[K, T](points: openArray[(K, K)]): CompressedFenwick2D[K, T] =
        ## 更新点を事前登録し、全点を零で初期化します。時間・空間O(N log N)。
        ## 重複点は一つにまとめます。Kには一貫した < と == が必要です。
        ## 内側の座標数の総和をMとすると、座標・値を各M個と、登録点の索引・値をO(N)個保持します。
        initCompressedFenwick2DImpl[K, T, (K, K)](points)

    proc initCompressedFenwick2D*[K](points: seq[(K, K)]): CompressedFenwick2D[K, int] =
        ## seqから座標型を推論し、和をintで保持する木を時間・空間O(N log N)で構築します。
        initCompressedFenwick2D[K, int](points.toOpenArray(0, points.len - 1))

    proc initCompressedFenwick2D*[K; N: static[int]](points: array[N, (K, K)]): CompressedFenwick2D[K, int] =
        ## arrayから座標型を推論し、和をintで保持する木を時間・空間O(N log N)で構築します。
        initCompressedFenwick2D[K, int](points.toOpenArray(0, points.len - 1))

    proc initCompressedFenwick2D*[K, T](points: openArray[(K, K, T)]): CompressedFenwick2D[K, T] =
        ## (x,y,w)の列から時間・空間O(N log N)で一括構築します。同じ座標の重みは加算します。
        ## 座標型Kと和の型Tは引数から推論します。重みが零の点も登録します。
        initCompressedFenwick2DImpl[K, T, (K, K, T)](points)

    proc lowerIndex[K](coords: seq[K], start, finish: int, y: K): int {.inline.} =
        ## 座標列の指定区間でlowerBoundを求め、区間内の添字をO(log N)で返します。
        var l = start
        var r = finish
        while l < r:
            let m = (l + r) shr 1
            if coords[m] < y: l = m + 1
            else: r = m
        l - start

    proc yIndex[K, T](self: CompressedFenwick2D[K, T], node: int, y: K): int {.inline.} =
        ## ノード内のyのlowerBoundをO(log N)で返します。
        lowerIndex(self.ys, self.offsets[node], self.offsets[node + 1], y)

    proc pointIndex[K, T](self: CompressedFenwick2D[K, T], xi: int, y: K): int {.inline.} =
        ## xの添字とyに対応する登録点の添字をO(log N)で返します。未登録なら-1です。
        let start = self.pointOffsets[xi]
        let finish = self.pointOffsets[xi + 1]
        let i = start + lowerIndex(self.pointYs, start, finish, y)
        if i < finish and self.pointYs[i] == y: i
        else: -1

    proc addImpl[K, T](self: CompressedFenwick2D[K, T], xi: int, y: K, delta: T) =
        ## xの添字が既知の登録点をO(log² N)で加算します。
        mixin `+=`
        var node = xi + 1
        while node <= self.xs.len:
            let start = self.offsets[node]
            let size = self.offsets[node + 1] - start
            var i = self.yIndex(node, y)
            while i < size:
                self.data[start + i] += delta
                i = i or (i + 1)
            node += node and -node

    proc add*[K, T](self: CompressedFenwick2D[K, T], x, y: K, delta: T) =
        ## 登録点(x,y)にdeltaをO(log² N)で加算します。未登録点は更新できません。
        mixin `+=`
        let xi = self.xs.lowerBound(x)
        assert xi < self.xs.len and self.xs[xi] == x, "更新する座標は事前登録してください"
        let pi = self.pointIndex(xi, y)
        assert pi >= 0, "更新する座標は事前登録してください"
        self.pointValues[pi] += delta
        self.addImpl(xi, y, delta)

    proc innerSum[K, T](self: CompressedFenwick2D[K, T], node, l, r: int): T {.inline.} =
        ## 内側の添字区間[l,r)の和をO(log N)で返します。共通の祖先は走査しません。
        mixin `+=`, `-`
        let start = self.offsets[node]
        var l = l
        var r = r
        var left: T
        while r > l:
            result += self.data[start + r - 1]
            r = r and (r - 1)
        while l > r:
            left += self.data[start + l - 1]
            l = l and (l - 1)
        result = result - left

    proc prefix*[K, T](self: CompressedFenwick2D[K, T], xUpper, yUpper: K): T =
        ## x<xUpperかつy<yUpperを満たす登録点の和をO(log² N)で返します。
        mixin `+=`
        var node = self.xs.lowerBound(xUpper)
        while node > 0:
            result += self.innerSum(node, 0, self.yIndex(node, yUpper))
            node = node and (node - 1)

    proc getLess*[K, T](self: CompressedFenwick2D[K, T], xl, xr, yUpper: K): T =
        ## xl<=x<xrかつy<yUpperを満たす登録点の和をO(log² N)で返します。
        mixin `+=`, `-`
        assert not (xr < xl), "区間の左端は右端以下にしてください"
        var l = self.xs.lowerBound(xl)
        var r = self.xs.lowerBound(xr)
        var left: T
        while r > l:
            result += self.innerSum(r, 0, self.yIndex(r, yUpper))
            r = r and (r - 1)
        while l > r:
            left += self.innerSum(l, 0, self.yIndex(l, yUpper))
            l = l and (l - 1)
        result = result - left

    proc get*[K, T](self: CompressedFenwick2D[K, T], xl, xr, yl, yr: K): T =
        ## [xl,xr)×[yl,yr)の和をO(log² N)で返します。境界は未登録でも構いません。
        ## x方向・y方向とも共通の祖先の走査を省きます。
        mixin `+=`, `-`
        assert not (xr < xl) and not (yr < yl), "区間の左端は右端以下にしてください"
        if not (yl < yr): return
        var l = self.xs.lowerBound(xl)
        var r = self.xs.lowerBound(xr)
        var left: T
        while r > l:
            result += self.innerSum(r, self.yIndex(r, yl), self.yIndex(r, yr))
            r = r and (r - 1)
        while l > r:
            left += self.innerSum(l, self.yIndex(l, yl), self.yIndex(l, yr))
            l = l and (l - 1)
        result = result - left

    proc `[]`*[K, T](self: CompressedFenwick2D[K, T], x, y: K): T =
        ## 点の値をO(log N)で返します。未登録なら零です。
        let xi = self.xs.lowerBound(x)
        if xi == self.xs.len or self.xs[xi] != x: return
        let pi = self.pointIndex(xi, y)
        if pi >= 0: result = self.pointValues[pi]

    proc `[]=`*[K, T](self: CompressedFenwick2D[K, T], x, y: K, value: T) =
        ## 登録点(x,y)をO(log² N)で上書きします。
        mixin `-`
        let xi = self.xs.lowerBound(x)
        assert xi < self.xs.len and self.xs[xi] == x, "更新する座標は事前登録してください"
        let pi = self.pointIndex(xi, y)
        assert pi >= 0, "更新する座標は事前登録してください"
        let delta = value - self.pointValues[pi]
        self.pointValues[pi] = value
        self.addImpl(xi, y, delta)

    proc get_all*[K, T](self: CompressedFenwick2D[K, T]): T =
        ## 全登録点の和をO(log² N)で返します。
        mixin `+=`
        var node = self.xs.len
        while node > 0:
            result += self.innerSum(node, 0, self.offsets[node + 1] - self.offsets[node])
            node = node and (node - 1)

    proc len*[K, T](self: CompressedFenwick2D[K, T]): int {.inline.} =
        ## 重複除去後の登録点数をO(1)で返します。
        self.pointYs.len
