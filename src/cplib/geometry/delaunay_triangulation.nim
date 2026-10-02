when not declared CPLIB_GEOMETRY_DELAUNAY_TRIANGULATION:
    const CPLIB_GEOMETRY_DELAUNAY_TRIANGULATION* = 1
    import algorithm
    import cplib/geometry/base
    import cplib/math/int128

    type
        DelaunayQuadEdge = object
            next: array[4, int]
            vertex: array[2, int]
        DelaunayTriangulation* = object
            ## 辺・三角形の頂点番号は元入力の添字。重複座標は最小添字の代表点へ集約する。
            ## representative[i]は入力iの代表添字。辺は無向で各1本、向きと列の順序は未規定。
            ## 三角形は反時計回りで各1枚、先頭は3頂点中の最小添字。列の順序は未規定。
            representative*: seq[int]
            edges*: seq[(int, int)]
            triangles*: seq[(int, int, int)]

    proc delaunay_triangulation*[T: SomeSignedInt](points: openArray[Point[T]]): DelaunayTriangulation =
        ## Delaunay分割の辺と三角形を返す。O(N log N)時間、O(N)領域。入力は変更しない。
        ## 座標は絶対値10^9以下の符号付き整数。整数による厳密判定にInt128を使うためC++が必要。
        ## 範囲外では中間積がオーバーフローしうる。浮動小数点座標には対応しない。
        ## 代表点が0・1個なら辺なし、全点共線なら座標順の隣接辺のみ。いずれも三角形なし。
        ## 共円点では空円条件を満たす分割の一つを返し、円周上の点は許す。外部面は返さない。
        var sortedPoints = newSeq[tuple[x, y: int64, id: int]](points.len)
        for i, p in points:
            let x = int64(p.x)
            let y = int64(p.y)
            assert -1_000_000_000'i64 <= x and x <= 1_000_000_000'i64,
                "x座標の絶対値は10^9以下である必要があります"
            assert -1_000_000_000'i64 <= y and y <= 1_000_000_000'i64,
                "y座標の絶対値は10^9以下である必要があります"
            sortedPoints[i] = (x, y, i)
        sortedPoints.sort()
        result.representative = newSeq[int](points.len)
        var sites = newSeqOfCap[tuple[x, y: int64, id: int]](points.len)
        for p in sortedPoints:
            if sites.len == 0 or sites[^1].x != p.x or sites[^1].y != p.y:
                sites.add(p)
            result.representative[p.id] = sites[^1].id
        if sites.len <= 1:
            return

        var edges = newSeqOfCap[DelaunayQuadEdge](3 * sites.len)
        var unused: seq[int]

        proc rotate(e: int): int =
            ## 辺を双対側へ90度回転する。
            (e and not 3) or ((e + 1) and 3)

        proc onext(e: int): int =
            ## 同じ始点を持つ次の反時計回りの辺を返す。
            edges[e shr 2].next[e and 3]

        proc origin(e: int): int =
            ## 有向辺の始点を返す。
            edges[e shr 2].vertex[(e shr 1) and 1]

        proc destination(e: int): int =
            ## 有向辺の終点を返す。
            origin(e xor 2)

        proc oprev(e: int): int =
            ## 同じ始点を持つ次の時計回りの辺を返す。
            rotate(onext(rotate(e)))

        proc lnext(e: int): int =
            ## 左側の面の境界に沿って次の辺を返す。
            rotate(onext(rotate(e) xor 2))

        proc splice(a, b: int) =
            ## 2辺の始点周りの接続と双対側の接続を交換する。
            let alpha = rotate(onext(a))
            let beta = rotate(onext(b))
            swap(edges[a shr 2].next[a and 3], edges[b shr 2].next[b and 3])
            swap(edges[alpha shr 2].next[alpha and 3], edges[beta shr 2].next[beta and 3])

        proc makeEdge(u, v: int): int =
            ## 孤立した辺を作る。削除済み領域を再利用して領域をO(N)に保つ。
            var index: int
            if unused.len > 0:
                index = unused.pop()
            else:
                index = edges.len
                edges.add(DelaunayQuadEdge())
            result = index shl 2
            edges[index] = DelaunayQuadEdge(
                next: [result, result + 3, result + 2, result + 1], vertex: [u, v])

        proc connect(a, b: int): int =
            ## aの終点からbの始点へ、共通の面を分割する辺を追加する。
            result = makeEdge(destination(a), origin(b))
            splice(result, lnext(a))
            splice(result xor 2, b)

        proc removeEdge(e: int) =
            ## 辺を両端の接続から外して領域を回収する。
            splice(e, oprev(e))
            splice(e xor 2, oprev(e xor 2))
            edges[e shr 2].vertex[0] = -1
            unused.add(e shr 2)

        proc orientation(a, b, c: int): int64 =
            ## 3点の向きを外積で求める。正なら反時計回り。
            (sites[b].x - sites[a].x) * (sites[c].y - sites[a].y) -
                (sites[b].y - sites[a].y) * (sites[c].x - sites[a].x)

        proc leftOf(p, e: int): bool =
            ## 点が有向辺の左側にあるかを判定する。
            orientation(origin(e), destination(e), p) > 0

        proc rightOf(p, e: int): bool =
            ## 点が有向辺の右側にあるかを判定する。
            orientation(origin(e), destination(e), p) < 0

        proc inCircle(a, b, c, d: int): bool =
            ## 反時計回りの3点の外接円の内部にdがあるかを厳密に判定する。
            let ax = sites[a].x - sites[d].x
            let ay = sites[a].y - sites[d].y
            let bx = sites[b].x - sites[d].x
            let by = sites[b].y - sites[d].y
            let cx = sites[c].x - sites[d].x
            let cy = sites[c].y - sites[d].y
            let det = to_Int128(ax * ax + ay * ay) * to_Int128(bx * cy - by * cx) -
                to_Int128(bx * bx + by * by) * to_Int128(ax * cy - ay * cx) +
                to_Int128(cx * cx + cy * cy) * to_Int128(ax * by - ay * bx)
            det > 0

        proc triangulate(first, last: int): (int, int) =
            ## 半開区間をDelaunay分割し、左右端の凸包辺を返す。O(M log M)時間。
            if last - first <= 3:
                let a = makeEdge(first, first + 1)
                if last - first == 2:
                    return (a, a xor 2)
                let b = makeEdge(first + 1, first + 2)
                splice(a xor 2, b)
                let turn = orientation(first, first + 1, first + 2)
                if turn == 0:
                    return (a, b xor 2)
                let c = connect(b, a)
                if turn > 0:
                    return (a, b xor 2)
                return (c xor 2, c)

            let middle = (first + last) shr 1
            var (leftOuter, leftInner) = triangulate(first, middle)
            var (rightInner, rightOuter) = triangulate(middle, last)
            while true:
                if leftOf(origin(rightInner), leftInner):
                    leftInner = lnext(leftInner)
                elif rightOf(origin(leftInner), rightInner):
                    rightInner = onext(rightInner xor 2)
                else:
                    break
            var baseEdge = connect(rightInner xor 2, leftInner)
            if origin(leftInner) == origin(leftOuter):
                leftOuter = baseEdge xor 2
            if origin(rightInner) == origin(rightOuter):
                rightOuter = baseEdge

            while true:
                var left = onext(baseEdge xor 2)
                if rightOf(destination(left), baseEdge):
                    while inCircle(destination(baseEdge), origin(baseEdge),
                            destination(left), destination(onext(left))):
                        let next = onext(left)
                        removeEdge(left)
                        left = next
                var right = oprev(baseEdge)
                if rightOf(destination(right), baseEdge):
                    while inCircle(destination(baseEdge), origin(baseEdge),
                            destination(right), destination(oprev(right))):
                        let next = oprev(right)
                        removeEdge(right)
                        right = next
                let leftValid = rightOf(destination(left), baseEdge)
                let rightValid = rightOf(destination(right), baseEdge)
                if not leftValid and not rightValid:
                    break
                if not leftValid or (rightValid and inCircle(destination(left),
                        origin(left), origin(right), destination(right))):
                    baseEdge = connect(right, baseEdge xor 2)
                else:
                    baseEdge = connect(baseEdge xor 2, left xor 2)
            (leftOuter, rightOuter)

        discard triangulate(0, sites.len)
        var visited = newSeq[bool](4 * edges.len)
        for i, edge in edges:
            if edge.vertex[0] < 0:
                continue
            result.edges.add((sites[edge.vertex[0]].id, sites[edge.vertex[1]].id))
            for side in [0, 2]:
                let first = (i shl 2) + side
                if visited[first]:
                    continue
                var boundary: seq[int]
                var e = first
                while not visited[e]:
                    visited[e] = true
                    boundary.add(origin(e))
                    e = lnext(e)
                if boundary.len == 3 and orientation(boundary[0], boundary[1], boundary[2]) > 0:
                    var a = sites[boundary[0]].id
                    var b = sites[boundary[1]].id
                    var c = sites[boundary[2]].id
                    if b < a and b < c:
                        (a, b, c) = (b, c, a)
                    elif c < a and c < b:
                        (a, b, c) = (c, a, b)
                    result.triangles.add((a, b, c))

    proc delaunay_triangulation*[T: SomeSignedInt](points: openArray[(T, T)]): DelaunayTriangulation =
        ## 座標の組からDelaunay分割を求める。制約・出力契約・計算量はPoint版と同じ。
        var converted = newSeq[Point[T]](points.len)
        for i, p in points:
            converted[i] = initPoint(p)
        delaunay_triangulation(converted)
