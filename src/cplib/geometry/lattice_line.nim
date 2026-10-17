when not declared CPLIB_GEOMETRY_LATTICE_LINE:
    const CPLIB_GEOMETRY_LATTICE_LINE* = 1
    import hashes
    import cplib/math/int128

    ## 整数格子上の直線 di*y-dj*x=c。実平面の Line とは別の型。
    ## GCC/ClangのC++ backend、符号付きInt128で厳密に計算する。
    ## 使用例: initLatticeLine(0, 0, 2, 2) は (di,dj,c)=(1,1,0)。
    ## countLatticePoints(line, 0, 2, 0, 2) は3。
    ## intersection(line, initLatticeLine(1,-1,1)) は latticeNone。
    ## 交点 (1/2,1/2) は実平面に存在するが共通格子点ではない。
    ## 入力・結果・途中の演算が Int128 に収まらない場合は ValueError。
    ## 方向の各成分の絶対値も Int128 に収まることが必要。
    ## 最終結果が収まっても、打ち消し前の積やEuclid基点が範囲外なら拒否する。
    ## |座標|<=10^12の点・方向・矩形を用いる4引数構築では全APIが範囲内。
    ## 3引数の定数や任意のInt128入力にはこの保証を適用しない。
    ## constructor を必ず使用する。default(LatticeLine) は未初期化。
    type
        LatticePoint* = tuple[x, y: Int128]
        LatticeLine* = object
            stepX, stepY, constant: Int128
            initialized: bool
        LatticeIntersectionKind* = enum
            latticeNone, latticePoint, latticeSameLine
        LatticeIntersection* = object
            kind*: LatticeIntersectionKind
            point*: LatticePoint # latticePoint のときのみ有効
            line*: LatticeLine   # latticeSameLine のときのみ有効

    proc addOverflow(a, b: Int128, value: var Int128): bool
        {.importcpp: "__builtin_add_overflow((#), (#), &(#))", nodecl.}
    proc subOverflow(a, b: Int128, value: var Int128): bool
        {.importcpp: "__builtin_sub_overflow((#), (#), &(#))", nodecl.}
    proc mulOverflow(a, b: Int128, value: var Int128): bool
        {.importcpp: "__builtin_mul_overflow((#), (#), &(#))", nodecl.}

    proc checkedAdd(a, b: Int128): Int128 =
        ## 和を範囲検査して返す。O(1)。
        if addOverflow(a, b, result):
            raise newException(ValueError, "LatticeLine: Int128 の加算範囲外")
    proc checkedSub(a, b: Int128): Int128 =
        ## 差を範囲検査して返す。O(1)。
        if subOverflow(a, b, result):
            raise newException(ValueError, "LatticeLine: Int128 の減算範囲外")
    proc checkedMul(a, b: Int128): Int128 =
        ## 積を範囲検査して返す。O(1)。
        if mulOverflow(a, b, result):
            raise newException(ValueError, "LatticeLine: Int128 の乗算範囲外")
    proc checkedAbs(a: Int128): Int128 =
        ## 絶対値を範囲検査して返す。O(1)。
        if a < 0: checkedSub(0, a) else: a
    proc checkedDiv(a, b: Int128): Int128 =
        ## ゼロ方向以外の除算を範囲検査して返す。O(1)。
        if b == -1: checkedSub(0, a) else: a div b
    proc gcdDirection(a, b: Int128): Int128 =
        ## 非負の最大公約数を返す。O(log D)、D=max(|a|,|b|)。
        var x = checkedAbs(a)
        var y = checkedAbs(b)
        while y != 0:
            let remainder = x mod y
            x = y
            y = remainder
        x
    proc requireLine(l: LatticeLine) =
        ## 未初期化の直線を拒否する。O(1)。
        if not l.initialized:
            raise newException(ValueError, "LatticeLine: 未初期化の直線")

    proc initLatticeLineWide(di, dj, c: Int128): LatticeLine =
        ## di*y-dj*x=c を正規化する。O(log D)、追加空間O(1)。
        ## (di,dj)=(0,0)、gcd(di,dj)で割れないcは ValueError。
        ## primitive方向をdi>0またはdi=0,dj>0に揃え、cも同時に割る。
        let g = gcdDirection(di, dj)
        if g == 0:
            raise newException(ValueError, "LatticeLine: 方向は非零である必要があります")
        if c mod g != 0:
            raise newException(ValueError, "LatticeLine: 格子点を通らない係数")
        result = LatticeLine(stepX: di div g, stepY: dj div g,
                             constant: c div g, initialized: true)
        if result.stepX < 0 or (result.stepX == 0 and result.stepY < 0):
            result.stepX = checkedSub(0, result.stepX)
            result.stepY = checkedSub(0, result.stepY)
            result.constant = checkedSub(0, result.constant)

    proc initLatticeLineWide(x, y, di, dj: Int128): LatticeLine =
        ## 格子点(x,y)と非零方向から構築する。O(log D)、追加空間O(1)。
        ## 方向を先にprimitive化して不要な大きい積を避ける。
        let direction = initLatticeLineWide(di, dj, 0)
        initLatticeLineWide(direction.stepX, direction.stepY,
            checkedSub(checkedMul(y, direction.stepX), checkedMul(x,
                    direction.stepY)))

    proc latticeWide[T: SomeInteger | Int128](value: T): Int128 =
        ## 整数を演算前に拡張する。O(1)。
        when T is Int128: value
        else: to_Int128(value)
    proc initLatticeLine*[A, B, C: SomeInteger | Int128](di: A, dj: B,
            c: C): LatticeLine =
        ## di*y-dj*x=cをprimitive方向・同時に縮約したcへ正規化する。O(log D)。
        ## 方向(0,0)やgcd(di,dj)で割れないcはValueError。
        initLatticeLineWide(latticeWide(di), latticeWide(dj), latticeWide(c))
    proc initLatticeLine*[A, B, C, D: SomeInteger | Int128](x: A, y: B, di: C,
            dj: D): LatticeLine =
        ## 整数またはInt128の点と方向から構築する。O(log D)。
        initLatticeLineWide(latticeWide(x), latticeWide(y), latticeWide(di),
                latticeWide(dj))

    proc initLatticeLine*(s, t: LatticePoint): LatticeLine =
        ## 異なる2格子点を通る直線を構築する。O(log D)、追加空間O(1)。
        initLatticeLine(s.x, s.y, checkedSub(t.x, s.x), checkedSub(t.y, s.y))
    proc initLatticeLine*[T: SomeInteger](s, t: tuple[x, y: T]): LatticeLine =
        ## 整数の2格子点をInt128へ拡張して構築する。O(log D)。
        initLatticeLine((to_Int128(s.x), to_Int128(s.y)),
                        (to_Int128(t.x), to_Int128(t.y)))

    proc di*(l: LatticeLine): Int128 =
        ## 正規化されたx方向を返す。O(1)。
        requireLine(l)
        l.stepX
    proc dj*(l: LatticeLine): Int128 =
        ## 正規化されたy方向を返す。O(1)。
        requireLine(l)
        l.stepY
    proc c*(l: LatticeLine): Int128 =
        ## 正規化された定数を返す。O(1)。
        requireLine(l)
        l.constant
    proc `==`*(a, b: LatticeLine): bool =
        ## 正規形を比較する。未初期化値同士も等しい。O(1)。
        a.initialized == b.initialized and a.stepX == b.stepX and
            a.stepY == b.stepY and a.constant == b.constant
    proc hash*(l: LatticeLine): Hash =
        ## 正規形をハッシュ化する。O(1)。
        !$ (hash(l.initialized) !& hash(l.stepX) !& hash(l.stepY) !& hash(l.constant))
    proc containsWide(l: LatticeLine, x, y: Int128): bool =
        ## 格子点が直線上にあるかを厳密に判定する。O(1)。
        requireLine(l)
        checkedSub(checkedMul(l.stepX, y), checkedMul(l.stepY, x)) == l.constant
    proc contains*[A, B: SomeInteger | Int128](l: LatticeLine, x: A, y: B): bool =
        ## 整数またはInt128の格子点を判定する。O(1)。
        containsWide(l, latticeWide(x), latticeWide(y))
    proc contains*(l: LatticeLine, p: LatticePoint): bool =
        ## 格子点が直線上にあるかを厳密に判定する。O(1)。
        l.contains(p.x, p.y)

    proc contains*[T: SomeInteger](l: LatticeLine, p: tuple[x, y: T]): bool =
        ## 整数の格子点を判定する。O(1)。
        containsWide(l, latticeWide(p.x), latticeWide(p.y))

    proc intersection*(a, b: LatticeLine): LatticeIntersection =
        ## 共通格子点をnone・1点・同一直線に分類する。O(1)、追加空間O(1)。
        ## Cramerの公式の分子が行列式で割り切れなければ、実交点があってもnone。
        requireLine(a)
        requireLine(b)
        if a.stepX == b.stepX and a.stepY == b.stepY:
            if a.constant == b.constant:
                return LatticeIntersection(kind: latticeSameLine, line: a)
            return LatticeIntersection(kind: latticeNone)
        let det = checkedSub(checkedMul(a.stepX, b.stepY), checkedMul(a.stepY, b.stepX))
        let nx = checkedSub(checkedMul(a.constant, b.stepX), checkedMul(a.stepX, b.constant))
        let ny = checkedSub(checkedMul(a.constant, b.stepY), checkedMul(a.stepY, b.constant))
        # det=-1の剰余は最小値でC++の未定義動作になるため、先に除算を検査する。
        if det == -1:
            return LatticeIntersection(kind: latticePoint,
                point: (checkedDiv(nx, det), checkedDiv(ny, det)))
        if nx mod det != 0 or ny mod det != 0:
            return LatticeIntersection(kind: latticeNone)
        LatticeIntersection(kind: latticePoint, point: (nx div det, ny div det))

    proc floorDiv(a, b: Int128): Int128 =
        ## 符号付き除算を負の無限大へ丸める。O(1)。
        result = checkedDiv(a, b)
        if b == -1: return
        let r = a mod b
        if r != 0 and ((r < 0) != (b < 0)): result = checkedSub(result, 1)
    proc ceilDiv(a, b: Int128): Int128 =
        ## 符号付き除算を正の無限大へ丸める。O(1)。
        result = checkedDiv(a, b)
        if b == -1: return
        let r = a mod b
        if r != 0 and ((r < 0) == (b < 0)): result = checkedAdd(result, 1)

    proc latticeAnchor(l: LatticeLine): LatticePoint =
        ## 拡張Euclidで整数解を求める。O(log D)、追加空間O(1)。
        if l.stepX == 0: return (checkedSub(0, l.constant), to_Int128(0))
        var a = l.stepX
        var b = checkedAbs(l.stepY)
        var u = to_Int128(1)
        var v = to_Int128(0)
        var nextU = to_Int128(0)
        var nextV = to_Int128(1)
        while b != 0:
            let q = a div b
            let r = a mod b
            a = b
            b = r
            let nu = checkedSub(u, checkedMul(q, nextU))
            let nv = checkedSub(v, checkedMul(q, nextV))
            u = nextU
            v = nextV
            nextU = nu
            nextV = nv
        if l.stepY < 0: v = checkedSub(0, v)
        # u*di+v*dj=1 より (x,y)=(-v*c,u*c)。
        (checkedMul(checkedSub(0, v), l.constant), checkedMul(u, l.constant))

    proc countLatticePointsWide(l: LatticeLine, xmin, xmax, ymin,
            ymax: Int128): Int128 =
        ## 閉矩形[xmin,xmax]×[ymin,ymax]内の格子点数。O(log D)、追加空間O(1)。
        ## 逆順の境界は空矩形。答えはInt128で返す。
        ## 全整数解はanchor+t*(di,dj)。各軸のfloor/ceil区間の共通整数を数える。
        requireLine(l)
        if xmin > xmax or ymin > ymax: return 0
        let anchor = latticeAnchor(l)
        var lower, upper: Int128
        var bounded = false
        for axis in 0..1:
            let origin = (if axis == 0: anchor.x else: anchor.y)
            let step = (if axis == 0: l.stepX else: l.stepY)
            let lo = (if axis == 0: xmin else: ymin)
            let hi = (if axis == 0: xmax else: ymax)
            if step == 0:
                if origin < lo or origin > hi: return 0
                continue
            let left = ceilDiv(checkedSub((if step > 0: lo else: hi), origin), step)
            let right = floorDiv(checkedSub((if step > 0: hi else: lo), origin), step)
            if not bounded:
                lower = left
                upper = right
                bounded = true
            else:
                if left > lower: lower = left
                if right < upper: upper = right
            if lower > upper: return 0
        checkedAdd(checkedSub(upper, lower), 1)

    proc countLatticePoints*[A, B, C, D: SomeInteger | Int128](l: LatticeLine,
            xmin: A, xmax: B, ymin: C, ymax: D): Int128 =
        ## 閉矩形[xmin,xmax]×[ymin,ymax]の格子点数をInt128で返す。
        ## 逆順の境界は0。時間O(log D)、追加空間O(1)。
        countLatticePointsWide(l, latticeWide(xmin), latticeWide(xmax),
                latticeWide(ymin), latticeWide(ymax))
