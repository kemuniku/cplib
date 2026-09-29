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

        var candidates = newSeqOfCap[tuple[weight: int64, u, v: int]](4 * points.len)
        for direction in 0..<4:
            sites.sort()
            var keys = newSeq[int64](sites.len)
            for i, p in sites:
                keys[i] = p.x - p.y
            keys.sort()
            var fenwick = newSeq[tuple[score: int64, id: int]](keys.len + 1)
            for item in fenwick.mitems:
                item = (low(int64), -1)
            for p in sites:
                let index = keys.lowerBound(p.x - p.y) + 1
                var best = (score: low(int64), id: -1)
                var k = index
                # y以下かつx-y以下の点のうち、x+yが最大の点を選ぶ。
                while k > 0:
                    if fenwick[k].score > best.score:
                        best = fenwick[k]
                    k -= k and -k
                let score = p.x + p.y
                if best.id >= 0:
                    candidates.add((score - best.score, min(p.id, best.id), max(p.id, best.id)))
                k = index
                while k < fenwick.len:
                    if score > fenwick[k].score:
                        fenwick[k] = (score, p.id)
                    k += k and -k
            for p in sites.mitems:
                if direction == 1:
                    p.y = -p.y
                swap(p.x, p.y)

        candidates.sort()
        let uf = initUnionFind(points.len)
        result = newSeqOfCap[(int, int)](points.len - 1)
        for edge in candidates:
            if not uf.issame(edge.u, edge.v):
                uf.unite(edge.u, edge.v)
                result.add((edge.u, edge.v))
                if uf.count == 1:
                    break

    proc manhattan_mst*[T: SomeSignedInt](points: openArray[(T, T)]): seq[(int, int)] =
        ## 座標の組からマンハッタン最小全域木を求める。制約と計算量はPoint版と同じ。
        var converted = newSeq[Point[T]](points.len)
        for i, p in points:
            converted[i] = initPoint(p)
        manhattan_mst(converted)
