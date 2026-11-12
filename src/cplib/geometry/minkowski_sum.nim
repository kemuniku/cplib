when not declared CPLIB_GEOMETRY_MINKOWSKI_SUM:
    const CPLIB_GEOMETRY_MINKOWSKI_SUM* = 1
    import cplib/geometry/base
    import cplib/geometry/polygon
    import cplib/geometry/convex_polygon
    import cplib/math/fractions

    proc minkowskiStart[T](v: seq[Point[T]]): int =
        ## 偏角順の辺列が始まる最下点（同じ高さなら最左点）をO(N)で探す。
        for i in 1..<v.len:
            if v[i].y < v[result].y or
                    (v[i].y == v[result].y and v[i].x < v[result].x):
                result = i
    proc minkowskiHalf[T](p: Point[T]): int =
        ## EPSなしで偏角の半平面を返す。正のx軸から反時計回りに0、1とする。
        let zero = p.x - p.x
        if p.y > zero or (p.y == zero and p.x > zero): 0
        else: 1
    proc minkowskiDirectionCmp[T](a, b: Point[T]): int =
        ## 零でない辺の偏角をEPSなしで比較し、同方向なら0を返す。
        let ha = minkowskiHalf(a)
        let hb = minkowskiHalf(b)
        if ha != hb: return (if ha < hb: -1 else: 1)
        let c = cross(a, b)
        let zero = c - c
        if c > zero: -1
        elif c < zero: 1
        else: 0

    proc minkowski_sum*[T](a, b: ConvexPolygon[T]): ConvexPolygon[T] =
        ## 凸多角形のMinkowski和を辺の線形マージでO(N+M)で返す。空・点・線分も許す。
        when T is Fraction:
            when typeof(default(T).num) isnot SomeSignedInt:
                {.error: "minkowski_sumのFractionには符号付き整数型を使用してください".}
        elif T isnot SomeSignedInt and T isnot SomeFloat:
            {.error: "minkowski_sumには符号付き整数、float、有限Fractionを使用してください".}
        if a.len == 0 or b.len == 0: return initConvexPolygon(newSeq[Point[T]]())
        let av = a.toPolygon.v
        let bv = b.toPolygon.v
        var vertices: seq[Point[T]]
        if av.len == 1 or bv.len == 1:
            if av.len == 1:
                for p in bv: vertices.add(av[0] + p)
            else:
                for p in av: vertices.add(p + bv[0])
            return initConvexPolygon(vertices)
        let ai = minkowskiStart(av)
        let bi = minkowskiStart(bv)
        var i, j = 0
        while i < av.len or j < bv.len:
            let p = av[(ai+i) mod av.len]
            let q = bv[(bi+j) mod bv.len]
            vertices.add(p + q)
            if i == av.len: inc j
            elif j == bv.len: inc i
            else:
                let ap = av[(ai+i+1) mod av.len] - p
                let bp = bv[(bi+j+1) mod bv.len] - q
                let direction = minkowskiDirectionCmp(ap, bp)
                if direction <= 0: inc i
                if direction >= 0: inc j
        initConvexPolygon(vertices)

    proc minkowski_sum*[T](a, b: Polygon[T]): ConvexPolygon[T] =
        ## 周回順の凸Polygon同士のMinkowski和を入力非破壊でO(N+M)で返す。
        minkowski_sum(initConvexPolygon(a), initConvexPolygon(b))
    proc minkowski_sum*[T](a, b: openArray[Point[T]]): ConvexPolygon[T] =
        ## CW/CCWの凸頂点列同士を正規化し、Minkowski和をO(N+M)で返す。
        minkowski_sum(initConvexPolygon(a), initConvexPolygon(b))
