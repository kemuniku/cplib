when not declared CPLIB_GEOMETRY_CLOSEST_PAIR:
    const CPLIB_GEOMETRY_CLOSEST_PAIR* = 1
    import algorithm, math, options
    import cplib/geometry/base

    type ClosestPairResult*[T] = object
        distanceSquared*: T
        indices*: (int, int)

    proc closestPairImpl[T](inputSites: seq[tuple[x, y: T, id: int]]): Option[ClosestPairResult[T]] =
        ## 座標を通常比較で整列し、分割統治で最近点対を求める。O(N log N)時間、O(N)領域。
        var sites = inputSites
        if sites.len < 2:
            return none(ClosestPairResult[T])
        sites.sort()
        var scratch = newSeq[tuple[x, y: T, id: int]](sites.len)

        proc cmpY(a, b: tuple[x, y: T, id: int]): int =
            ## y、x、元の添字の順に、EPSを使わず比較する。
            if a.y != b.y: cmp(a.y, b.y)
            elif a.x != b.x: cmp(a.x, b.x)
            else: cmp(a.id, b.id)

        when T is SomeFloat:
            for i, p in sites:
                scratch[i] = p
            scratch.sort(cmpY)
            let dx = sites[^1].x - sites[0].x
            let dy = scratch[^1].y - scratch[0].y
            if classify(dx * dx + dy * dy) in {fcInf, fcNegInf, fcNan}:
                raise newException(ValueError, "座標範囲の対角線の二乗距離が有限である必要があります")
            for i in 1..<sites.len:
                let gapX = sites[i].x - sites[i - 1].x
                let gapY = scratch[i].y - scratch[i - 1].y
                if (gapX != 0 and gapX * gapX == 0) or (gapY != 0 and gapY * gapY == 0):
                    raise newException(ValueError, "非零の座標差の二乗が0にunderflowしてはいけません")

        for i in 1..<sites.len:
            if sites[i - 1].x == sites[i].x and sites[i - 1].y == sites[i].y:
                let a = sites[i - 1].id
                let b = sites[i].id
                return some(ClosestPairResult[T](distanceSquared: T(0), indices: (min(a, b), max(a, b))))

        var best = ClosestPairResult[T]()
        let initialDx = sites[0].x - sites[1].x
        let initialDy = sites[0].y - sites[1].y
        best.distanceSquared = initialDx * initialDx + initialDy * initialDy
        best.indices = (min(sites[0].id, sites[1].id), max(sites[0].id, sites[1].id))

        proc consider(a, b: tuple[x, y: T, id: int]) =
            ## 厳密に小さい二乗距離が見つかれば、元の添字とともに更新する。
            let dx = a.x - b.x
            let dy = a.y - b.y
            let distanceSquared = dx * dx + dy * dy
            if distanceSquared < best.distanceSquared:
                best = ClosestPairResult[T](distanceSquared: distanceSquared,
                    indices: (min(a.id, b.id), max(a.id, b.id)))

        proc solve(first, last: int) =
            ## x順の半開区間を処理し、y順にして返す。マージと帯の走査はO(M)時間。
            if last - first <= 3:
                for i in first..<last:
                    for j in i + 1..<last:
                        consider(sites[i], sites[j])
                for i in first + 1..<last:
                    var j = i
                    while j > first and cmpY(sites[j], sites[j - 1]) < 0:
                        swap(sites[j], sites[j - 1])
                        dec j
                return
            let middle = first + (last - first) div 2
            let splitX = sites[middle].x
            solve(first, middle)
            solve(middle, last)
            var left = first
            var right = middle
            for i in first..<last:
                if left < middle and (right == last or cmpY(sites[left], sites[right]) <= 0):
                    scratch[i] = sites[left]
                    inc left
                else:
                    scratch[i] = sites[right]
                    inc right
            for i in first..<last:
                sites[i] = scratch[i]
            var count = 0
            for i in first..<last:
                let p = sites[i]
                let dx = p.x - splitX
                if dx * dx >= best.distanceSquared:
                    continue
                var j = count - 1
                while j >= 0:
                    let dy = p.y - scratch[first + j].y
                    if dy * dy >= best.distanceSquared:
                        break
                    consider(p, scratch[first + j])
                    dec j
                scratch[first + count] = p
                inc count

        solve(0, sites.len)
        some(best)

    proc closest_pair*[T: SomeSignedInt](points: openArray[Point[T]]): Option[ClosestPairResult[int64]] =
        ## 最近点対の二乗距離と元の添字対(i < j)を返す。O(N log N)時間、O(N)領域。入力は変更しない。
        ## N < 2ならnone、重複点なら距離0、同距離は任意の1組。符号付き整数をint64で厳密に計算する。
        ## 各軸の最大値と最小値の差は2*10^9以下（絶対値は不問）。制約違反はValueError。
        ## 二乗距離は最大8*10^18でint64に収まり、整数をfloatへ変換しない。
        var sites = newSeq[tuple[x, y: int64, id: int]](points.len)
        var minX, maxX, minY, maxY: int64
        for i, p in points:
            let x = int64(p.x)
            let y = int64(p.y)
            sites[i] = (x, y, i)
            if i == 0:
                minX = x
                maxX = x
                minY = y
                maxY = y
            else:
                minX = min(minX, x)
                maxX = max(maxX, x)
                minY = min(minY, y)
                maxY = max(maxY, y)
        const span = 2_000_000_000'i64
        if (minX <= high(int64) - span and maxX > minX + span) or
                (minY <= high(int64) - span and maxY > minY + span):
            raise newException(ValueError, "各軸の座標幅は2*10^9以下である必要があります")
        closestPairImpl(sites)

    proc closest_pair*[T: SomeFloat](points: openArray[Point[T]]): Option[ClosestPairResult[float64]] =
        ## 最近点対の二乗距離と元の添字対(i < j)を返す。O(N log N)時間、O(N)領域。入力は変更しない。
        ## N < 2ならnone、重複点なら距離0、同距離は任意の1組。float32もfloat64で計算する。
        ## 座標と座標範囲の対角線の二乗距離は有限、非零の座標差の二乗は0へのunderflow不可。
        ## 制約違反はValueError。EPSを使わず通常の浮動小数点丸めで比較するため、厳密な実数解は保証しない。
        var sites = newSeq[tuple[x, y: float64, id: int]](points.len)
        for i, p in points:
            let x = float64(p.x)
            let y = float64(p.y)
            if classify(x) in {fcInf, fcNegInf, fcNan} or classify(y) in {fcInf, fcNegInf, fcNan}:
                raise newException(ValueError, "座標は有限である必要があります")
            sites[i] = (x, y, i)
        closestPairImpl(sites)
