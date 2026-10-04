when not declared CPLIB_GEOMETRY_EUCLIDEAN_MST:
    const CPLIB_GEOMETRY_EUCLIDEAN_MST* = 1
    import algorithm
    import cplib/geometry/base
    import cplib/collections/unionfind
    import cplib/geometry/delaunay_triangulation

    proc euclidean_mst*[T: SomeSignedInt](points: openArray[Point[T]]): seq[(int, int)] =
        ## 平面上の点のユークリッド最小全域木を、入力の頂点番号の組で返す。O(N log N)時間、O(N)領域。
        ## 座標は絶対値10^9以下の符号付き整数。重複点も別頂点として扱い、N <= 1なら空列を返す。
        ## 幾何判定は整数で厳密に行う。Int128を使うためC++バックエンドが必要。
        var sortedPoints = newSeq[tuple[x, y: int64, id: int]](points.len)
        for i, p in points:
            let x = int64(p.x)
            let y = int64(p.y)
            assert -1_000_000_000'i64 <= x and x <= 1_000_000_000'i64,
                "x座標の絶対値は10^9以下である必要があります"
            assert -1_000_000_000'i64 <= y and y <= 1_000_000_000'i64,
                "y座標の絶対値は10^9以下である必要があります"
            sortedPoints[i] = (x, y, i)
        if points.len <= 1:
            return @[]
        sortedPoints.sort()
        result = newSeqOfCap[(int, int)](points.len - 1)
        var sites = newSeqOfCap[tuple[x, y: int64, id: int]](points.len)
        for p in sortedPoints:
            if sites.len > 0 and sites[^1].x == p.x and sites[^1].y == p.y:
                result.add((sites[^1].id, p.id))
            else:
                sites.add(p)
        if sites.len == 1:
            return

        var sitePoints = newSeq[Point[int64]](sites.len)
        for i, site in sites:
            sitePoints[i] = initPoint(site.x, site.y)
        let mesh = delaunay_triangulation(sitePoints)
        var candidates = newSeqOfCap[tuple[weight: int64, u, v: int]](mesh.edges.len)
        for (u, v) in mesh.edges:
            let dx = sites[u].x - sites[v].x
            let dy = sites[u].y - sites[v].y
            candidates.add((dx * dx + dy * dy, u, v))
        candidates.sort()
        let uf = initUnionFind(sites.len)
        for edge in candidates:
            if not uf.issame(edge.u, edge.v):
                uf.unite(edge.u, edge.v)
                let u = sites[edge.u].id
                let v = sites[edge.v].id
                result.add((min(u, v), max(u, v)))
                if uf.count == 1:
                    break

    proc euclidean_mst*[T: SomeSignedInt](points: openArray[(T, T)]): seq[(int, int)] =
        ## 座標の組からユークリッド最小全域木を求める。制約と計算量はPoint版と同じ。
        var converted = newSeq[Point[T]](points.len)
        for i, p in points:
            converted[i] = initPoint(p)
        euclidean_mst(converted)
