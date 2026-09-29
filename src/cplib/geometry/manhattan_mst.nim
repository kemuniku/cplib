when not declared CPLIB_GEOMETRY_MANHATTAN_MST:
    const CPLIB_GEOMETRY_MANHATTAN_MST* = 1
    import algorithm
    import cplib/geometry/base
    import cplib/collections/unionfind

    proc manhattan_mst*[T: SomeSignedInt](points: openArray[Point[T]]): seq[(int, int)] =
        ## マンハッタン距離の最小全域木を、入力の頂点番号の組で返す。O(N log N)時間、O(N)領域。
        ## 座標の絶対値はhigh(int64) div 4以下。内部計算はint64で行う。
        ## 重複点も別頂点として扱い、N <= 1なら空列を返す。入力は変更しない。
        const bound = high(int64) div 4
        var sites = newSeq[tuple[y, x: int64, id: int]](points.len)
        for i, p in points:
            let x = int64(p.x)
            let y = int64(p.y)
            assert -bound <= x and x <= bound, "x座標の絶対値が大きすぎます"
            assert -bound <= y and y <= bound, "y座標の絶対値が大きすぎます"
            sites[i] = (y, x, i)
        if points.len <= 1:
            return @[]

        proc cmpSite(a, b: tuple[y, x: int64, id: int]): int =
            ## y座標、x座標の順に比較する。
            if a.y != b.y: cmp(a.y, b.y) else: cmp(a.x, b.x)

        sites.sort(cmpSite)
        let uf = initUnionFind(points.len)
        result = newSeqOfCap[(int, int)](points.len - 1)
        var uniqueCount = 0
        for p in sites:
            if uniqueCount > 0 and sites[uniqueCount - 1].x == p.x and sites[uniqueCount - 1].y == p.y:
                let u = sites[uniqueCount - 1].id
                uf.unite(u, p.id)
                result.add((min(u, p.id), max(u, p.id)))
            else:
                sites[uniqueCount] = p
                inc uniqueCount
        sites.setLen(uniqueCount)
        if uniqueCount == 1:
            return

        var ranks = newSeq[array[2, int]](points.len)
        var sizes: array[2, int]
        var keys = newSeq[tuple[value: int64, id: int]](sites.len)
        for diagonal in 0..<2:
            for i, p in sites:
                keys[i] = (if diagonal == 0: (p.x - p.y, p.id) else: (p.x + p.y, p.id))
            keys.sort(proc(a, b: tuple[value: int64, id: int]): int = cmp(a.value, b.value))
            for i, key in keys:
                if i == 0 or keys[i - 1].value != key.value:
                    inc sizes[diagonal]
                ranks[key.id][diagonal] = sizes[diagonal]

        var candidates = newSeqOfCap[tuple[weight: int64, u, v: int]](4 * sites.len)
        var fenwick = newSeq[tuple[score: int64, id: int]](max(sizes[0], sizes[1]) + 1)
        for direction in 0..<4:
            if direction mod 2 == 0:
                if direction == 2:
                    for p in sites.mitems:
                        p.x = -p.x
                        swap(p.x, p.y)
                    sites.sort(cmpSite)
            else:
                # 同じyの区間を反転すれば、xの符号反転後の整列順になる。
                var first = 0
                while first < sites.len:
                    var last = first + 1
                    while last < sites.len and sites[last].y == sites[first].y:
                        inc last
                    sites.reverse(first, last - 1)
                    first = last
                for p in sites.mitems:
                    p.x = -p.x
            let diagonal = direction mod 2
            let size = sizes[diagonal]
            for k in 0..size:
                fenwick[k] = (low(int64), -1)
            for p in sites:
                var index = ranks[p.id][diagonal]
                # x-y, -(x+y), -(x-y), -(x+y)の順に圧縮済みの順位を使う。
                if direction != 0:
                    index = size + 1 - index
                var best = (score: low(int64), id: -1)
                var k = index
                while k > 0:
                    if fenwick[k].score > best.score:
                        best = fenwick[k]
                    k -= k and -k
                let score = p.x + p.y
                if best.id >= 0:
                    candidates.add((score - best.score, p.id, best.id))
                k = index
                while k <= size:
                    # 祖先の最大値もこれ以上なので、更新不要なら打ち切れる。
                    if score <= fenwick[k].score:
                        break
                    fenwick[k] = (score, p.id)
                    k += k and -k

        candidates.sort(proc(a, b: tuple[weight: int64, u, v: int]): int = cmp(a.weight, b.weight))
        for edge in candidates:
            if not uf.issame(edge.u, edge.v):
                uf.unite(edge.u, edge.v)
                result.add((min(edge.u, edge.v), max(edge.u, edge.v)))
                if uf.count == 1:
                    break

    proc manhattan_mst*[T: SomeSignedInt](points: openArray[(T, T)]): seq[(int, int)] =
        ## 座標の組からマンハッタン最小全域木を求める。制約と計算量はPoint版と同じ。
        var converted = newSeq[Point[T]](points.len)
        for i, p in points:
            converted[i] = initPoint(p)
        manhattan_mst(converted)
