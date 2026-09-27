## 長方形への加算後、長方形内の総和をオフラインで求めます。
when not declared CPLIB_UTILS_STATIC_RECTANGLE_ADD_RECTANGLE_SUM:
    const CPLIB_UTILS_STATIC_RECTANGLE_ADD_RECTANGLE_SUM* = 1
    import algorithm
    # 添字は内部で構築します。-d:debugでは境界・オーバーフロー検査も行います。
    when not defined(debug):
        {.push boundChecks:off, overflowChecks:off, rangeChecks:off.}

    type RectangleSumEvent[K] = tuple[coordinate: K, index: int]

    proc sortRectangleSumEvents[K](events: var seq[RectangleSumEvent[K]]) =
        ## 整数座標は基数ソート、その他の座標は比較ソートで並べます。O(N)またはO(N log N)。
        mixin `<`
        when K is SomeInteger:
            if events.len < 2: return
            template key(coordinate: K): uint64 =
                ## 符号付き整数は符号ビットを反転し、大小関係を保ちます。
                when K is SomeSignedInt:
                    cast[uint64](int64(coordinate)) xor (1'u64 shl 63)
                else:
                    uint64(coordinate)
            let first = key(events[0].coordinate)
            var varying = 0'u64
            for event in events: varying = varying or (key(event.coordinate) xor first)
            var scratch = newSeq[RectangleSumEvent[K]](events.len)
            var shift = 0
            while shift < 64 and (varying shr shift) != 0:
                if ((varying shr shift) and 2047'u64) != 0:
                    var offsets: array[2048, int]
                    for event in events:
                        inc offsets[int((key(event.coordinate) shr shift) and 2047'u64)]
                    var total = 0
                    for i in 0..<offsets.len:
                        let count = offsets[i]
                        offsets[i] = total
                        total += count
                    for event in events:
                        let digit = int((key(event.coordinate) shr shift) and 2047'u64)
                        scratch[offsets[digit]] = event
                        inc offsets[digit]
                    swap(events, scratch)
                shift += 11
        else:
            events.sort(proc(a, b: RectangleSumEvent[K]): int =
                if a.coordinate < b.coordinate: -1
                elif b.coordinate < a.coordinate: 1
                else: 0)

    template rectangleSumSlot(i: int): int =
        ## 上位ノード同士のキャッシュ競合を避けるため、余白を挿入します。
        i + (i shr 10)

    type RectangleSumCoefficients[T] = object
        w, wx, wy, wxy: T

    proc `+=`[T](a: var RectangleSumCoefficients[T], b: RectangleSumCoefficients[T]) {.inline.} =
        ## 累積和を表す式の係数を成分ごとに加算します。O(1)。
        mixin `+=`
        a.w += b.w
        a.wx += b.wx
        a.wy += b.wy
        a.wxy += b.wxy

    proc addRectangleCoefficients[T](bit: var seq[RectangleSumCoefficients[T]], l, r, size: int,
        bottom, top: RectangleSumCoefficients[T]) {.inline.} =
        ## 区間の両端を更新し、共通の祖先では相殺しない二つの係数だけを加算します。O(log N)。
        mixin `+=`
        var l = l + 1
        var r = r + 1
        while l < r:
            bit[rectangleSumSlot(l)] += bottom
            l += l and -l
        while r < l and r <= size:
            bit[rectangleSumSlot(r)] += top
            r += r and -r
        var wy = bottom.wy
        var wxy = bottom.wxy
        wy += top.wy
        wxy += top.wxy
        while l <= size:
            bit[rectangleSumSlot(l)].wy += wy
            bit[rectangleSumSlot(l)].wxy += wxy
            l += l and -l

    proc prefixRectangleCoefficients[T](bit: seq[RectangleSumCoefficients[T]], r: int): RectangleSumCoefficients[T] {.inline.} =
        ## 圧縮後の添字区間[0,r)の係数の和を返します。O(log N)。
        var i = r
        while i > 0:
            result += bit[rectangleSumSlot(i)]
            i = i and (i - 1)

    proc rectanglePrefixValue[K, T](a: RectangleSumCoefficients[T], x, y: K): T {.inline.} =
        ## 係数から境界(x,y)までの累積和を評価します。O(1)。
        mixin `*`, `-`, `+=`
        result = (a.w * x - a.wx) * y - a.wy * x
        result += a.wxy

    proc static_rectangle_add_rectangle_sum*[K, T](
        rectangles: openArray[(K, K, K, K, T)],
        queries: openArray[(K, K, K, K)]
    ): seq[T] =
        ## 全加算後の各クエリの総和を入力順に返します。時間O((N+Q) log(N+Q))、追加空間O(N+Q)。
        ## 加算は(l,d,r,u,w)、取得は(l,d,r,u)で、範囲は[l,r)×[d,u)です。
        ## l<=r, d<=uが必要です。空入力・空長方形・負の座標にも対応します。
        ## Kは一貫した < を持つ座標型です。圧縮前の座標を用いて面積を計算します。
        ## 整数座標は基数ソートで高速化し、その他の座標は比較ソートで処理します。
        ## Tの初期値を零とし、可換な ``+=``、二項 ``-``、座標倍 ``*(T,K):T`` が必要です。
        ## 座標倍は加減算に分配可能であること。T同士の乗算や除算は不要です。
        ## 整数では答えだけでなく係数・途中の累積和もTに収まる必要があります。
        ## 実数座標では重み付き面積を返し、浮動小数点数では丸め誤差を含みます。
        runnableExamples:
            let rectangles = @[(-2, -1, 3, 4, 2'i64)]
            let queries = @[(-1, 0, 2, 2), (3, 0, 5, 2)]
            assert static_rectangle_add_rectangle_sum(rectangles, queries) == @[12'i64, 0]
        mixin `<`, `*`, `-`, `+=`
        let n = rectangles.len
        result = newSeq[T](queries.len)
        var events = newSeqOfCap[RectangleSumEvent[K]](2 * (n + queries.len))
        var updateCount = 0
        for i, rectangle in rectangles:
            let (l, d, r, u, _) = rectangle
            assert not (r < l) and not (u < d), "区間の左端は右端以下にしてください"
            if not (l < r) or not (d < u): continue
            events.add((d, 2 * i))
            events.add((u, 2 * i + 1))
            inc updateCount
        for i, query in queries:
            let (l, d, r, u) = query
            assert not (r < l) and not (u < d), "区間の左端は右端以下にしてください"
            if not (l < r) or not (d < u): continue
            events.add((d, 2 * (n + i)))
            events.add((u, 2 * (n + i) + 1))
        if updateCount == 0 or events.len == 2 * updateCount: return

        sortRectangleSumEvents(events)
        var indices = newSeq[int](2 * (n + queries.len))
        var size = 0
        var previous: K
        # クエリの境界も同時に走査し、更新点だけで圧縮した添字を求めます。
        for event in events:
            if event.index < 2 * n:
                if size == 0 or previous < event.coordinate:
                    previous = event.coordinate
                    inc size
                indices[event.index] = size - 1
            else:
                var rank = size
                if size > 0 and not (previous < event.coordinate): dec rank
                indices[event.index] = rank
        for event in events.mitems:
            let i = event.index shr 1
            let right = (event.index and 1) != 0
            if i < n:
                event.coordinate = if right: rectangles[i][2] else: rectangles[i][0]
            else:
                event.coordinate = if right: queries[i - n][2] else: queries[i - n][0]
        sortRectangleSumEvents(events)

        # 同じxの加算は累積和への寄与が零なので、同座標内の処理順は問いません。
        var bit = newSeq[RectangleSumCoefficients[T]](rectangleSumSlot(size) + 1)
        let zero = default(T)
        for event in events:
            let i = event.index shr 1
            let right = (event.index and 1) != 0
            if i < n:
                let rectangle = rectangles[i]
                let w = if right: zero - rectangle[4] else: rectangle[4]
                let wx = w * event.coordinate
                # 各頂点(a,b)の寄与w(x-a)(y-b)を四つの係数で保持します。
                let bottom = RectangleSumCoefficients[T](
                    w: w, wx: wx, wy: w * rectangle[1], wxy: wx * rectangle[1])
                let top = RectangleSumCoefficients[T](
                    w: zero - w, wx: zero - wx,
                    wy: zero - w * rectangle[3], wxy: zero - wx * rectangle[3])
                bit.addRectangleCoefficients(indices[2 * i], indices[2 * i + 1], size, bottom, top)
            else:
                let q = i - n
                let query = queries[q]
                let bottom = bit.prefixRectangleCoefficients(indices[2 * i])
                let top = bit.prefixRectangleCoefficients(indices[2 * i + 1])
                let value = rectanglePrefixValue(top, event.coordinate, query[3]) -
                    rectanglePrefixValue(bottom, event.coordinate, query[1])
                if right:
                    result[q] += value
                else:
                    result[q] = result[q] - value

    when not defined(debug):
        {.pop.}
