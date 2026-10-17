when not declared CPLIB_GEOMETRY_HALF_PLANE_INTERSECTION:
    const CPLIB_GEOMETRY_HALF_PLANE_INTERSECTION* = 1
    import cplib/geometry/base
    import cplib/math/fractions
    import algorithm, math

    type
        HalfPlaneIntersectionKind* = enum
            hpiEmpty, hpiBounded, hpiUnbounded
        HalfPlaneIntersection*[T] = object
            kind*: HalfPlaneIntersectionKind
            dimension*: int
            vertices*: seq[Point[T]]
            constraints*: seq[Line[T]]
        HpiFunction[T] = object
            slope, intercept: T
        HpiBound[T] = object
            infinity: int
            value: T
        HpiEnvelope[T] = object
            functions: seq[HpiFunction[T]]
            starts: seq[HpiBound[T]]

    proc hpiZero[T](): T =
        ## 座標型の零を返す。
        when T is Fraction: initFraction(typeof(default(T).num)(0))
        else: T(0)

    proc hpiChecked[T](x: T): T =
        ## 有限値と正の分母を確認する。
        when T is SomeFloat:
            if classify(x) in {fcNan, fcInf, fcNegInf}:
                raise newException(ValueError, "半平面交差の値が有限値ではありません")
        else:
            if x.den <= 0:
                raise newException(ValueError, "半平面交差には正の分母の有限分数が必要です")
        x

    proc hpiBound[T](x: T): HpiBound[T] =
        ## 有限の区間端を作る。
        HpiBound[T](value: hpiChecked(x))
    proc hpiCmp[T](a, b: HpiBound[T]): int =
        ## 無限端を含む区間端を比較する。
        if a.infinity != b.infinity: cmp(a.infinity, b.infinity)
        elif a.infinity != 0: 0
        else: cmp(a.value, b.value)
    proc hpiMin[T](a, b: HpiBound[T]): HpiBound[T] =
        ## 小さい区間端を返す。
        if hpiCmp(a, b) <= 0: a else: b
    proc hpiMax[T](a, b: HpiBound[T]): HpiBound[T] =
        ## 大きい区間端を返す。
        if hpiCmp(a, b) >= 0: a else: b

    proc hpiEnvelope[T](lines: seq[HpiFunction[T]]): HpiEnvelope[T] =
        ## 一次関数群の上包絡線を構築する。O(N log N) 演算。
        var sorted = lines
        sorted.sort(proc(a, b: HpiFunction[T]): int =
            if a.slope != b.slope: cmp(a.slope, b.slope)
            else: cmp(a.intercept, b.intercept))
        for line in sorted:
            if result.functions.len > 0 and result.functions[^1].slope == line.slope:
                discard result.functions.pop()
                discard result.starts.pop()
            var start = HpiBound[T](infinity: -1)
            while result.functions.len > 0:
                let last = result.functions[^1]
                start = hpiBound((last.intercept - line.intercept) /
                    (line.slope - last.slope))
                if hpiCmp(start, result.starts[^1]) > 0: break
                discard result.functions.pop()
                discard result.starts.pop()
            if result.functions.len == 0: start = HpiBound[T](infinity: -1)
            result.functions.add(line)
            result.starts.add(start)

    proc hpiValue[T](e: HpiEnvelope[T], x: T): T =
        ## 包絡線の値を二分探索で求める。O(log N) 演算。
        var lo = 0
        var hi = e.starts.len
        let bound = hpiBound(x)
        while hi - lo > 1:
            let mid = (lo + hi) div 2
            if hpiCmp(e.starts[mid], bound) <= 0: lo = mid
            else: hi = mid
        hpiChecked(e.functions[lo].slope * x + e.functions[lo].intercept)

    proc half_plane_intersection*[T](lines: openArray[Line[T]]): HalfPlaneIntersection[T] =
        ## 有向直線の左閉半平面の共通部分。O(N log N) 演算、O(N) 空間。
        ## T は浮動小数点型または Fraction。分数の分母は正で、
        ## 中間整数演算はオーバーフローしないこと。
        ## vertices は有限の極点のみ。面なら下側を x 昇順、上側を x 降順に並べ、
        ## 有界なら反時計回り。非有界領域の全体は constraints で表す。
        ## dimension は空=-1、点=0、線分・半直線・直線=1、面=2。
        ## 制約なしは全平面。入力は有限座標かつ異なる端点。非有限値は ValueError。
        ## float は EPS を使わず比較し、丸めによる退化・平行・近接の誤分類を防げない。
        ## 厳密な退化分類が必要な場合は Fraction を使う。全体の GEOMETRY_EPS は参照しない。
        when T isnot SomeFloat and T isnot Fraction:
            {.error: "half_plane_intersection requires floating point or Fraction coordinates".}
        let zero = hpiZero[T]()
        let negativeInfinity = HpiBound[T](infinity: -1)
        let positiveInfinity = HpiBound[T](infinity: 1)
        result.kind = hpiEmpty
        result.dimension = -1
        result.constraints = @lines
        var lowerLines, negativeUpperLines: seq[HpiFunction[T]]
        var xmin = negativeInfinity
        var xmax = positiveInfinity
        for line in lines:
            for coordinate in [line.s.x, line.s.y, line.t.x, line.t.y]:
                discard hpiChecked(coordinate)
            let dx = hpiChecked(line.t.x - line.s.x)
            let dy = hpiChecked(line.t.y - line.s.y)
            if dx == zero and dy == zero:
                raise newException(ValueError, "半平面の端点は異なる必要があります")
            if dx == zero:
                if dy > zero: xmax = hpiMin(xmax, hpiBound(line.s.x))
                else: xmin = hpiMax(xmin, hpiBound(line.s.x))
            else:
                let slope = hpiChecked(dy / dx)
                let intercept = hpiChecked(hpiChecked(dx * line.s.y - dy * line.s.x) / dx)
                if dx > zero:
                    lowerLines.add(HpiFunction[T](slope: slope, intercept: intercept))
                else:
                    negativeUpperLines.add(HpiFunction[T](slope: -slope, intercept: -intercept))
        let lower = hpiEnvelope(lowerLines)
        let upper = hpiEnvelope(negativeUpperLines)
        if hpiCmp(xmin, xmax) > 0: return
        var left = xmin
        var right = xmax
        var hasArea = false
        var leftMeet, rightMeet: bool
        if lower.functions.len > 0 and upper.functions.len > 0:
            left = positiveInfinity
            right = negativeInfinity
            var i = 0
            var j = 0
            var start = negativeInfinity
            while true:
                let nextLower = if i + 1 < lower.starts.len: lower.starts[i+1] else: positiveInfinity
                let nextUpper = if j + 1 < upper.starts.len: upper.starts[j+1] else: positiveInfinity
                let finish = hpiMin(nextLower, nextUpper)
                var a = hpiMax(start, xmin)
                var b = hpiMin(finish, xmax)
                let slope = hpiChecked(lower.functions[i].slope + upper.functions[j].slope)
                let intercept = hpiChecked(lower.functions[i].intercept + upper.functions[j].intercept)
                var root = positiveInfinity
                if slope != zero: root = hpiBound(-intercept / slope)
                if slope > zero: b = hpiMin(b, root)
                elif slope < zero: a = hpiMax(a, root)
                elif intercept > zero: a = positiveInfinity; b = negativeInfinity
                if hpiCmp(a, b) <= 0:
                    let aMeet = (slope == zero and intercept == zero) or
                        (slope != zero and hpiCmp(a, root) == 0)
                    let bMeet = (slope == zero and intercept == zero) or
                        (slope != zero and hpiCmp(b, root) == 0)
                    if hpiCmp(a, left) < 0: leftMeet = aMeet
                    elif hpiCmp(a, left) == 0: leftMeet = leftMeet or aMeet
                    if hpiCmp(b, right) > 0: rightMeet = bMeet
                    elif hpiCmp(b, right) == 0: rightMeet = rightMeet or bMeet
                    left = hpiMin(left, a)
                    right = hpiMax(right, b)
                    if hpiCmp(a, b) < 0 and (slope != zero or intercept < zero): hasArea = true
                if finish.infinity == 1: break
                if hpiCmp(nextLower, finish) == 0: inc i
                if hpiCmp(nextUpper, finish) == 0: inc j
                start = finish
            if hpiCmp(left, right) > 0: return
        elif hpiCmp(left, right) < 0:
            hasArea = true
        result.kind = if left.infinity == 0 and right.infinity == 0 and
            lower.functions.len > 0 and upper.functions.len > 0: hpiBounded else: hpiUnbounded
        if hpiCmp(left, right) == 0:
            if lower.functions.len > 0 and upper.functions.len > 0:
                result.dimension = if leftMeet or rightMeet: 0 else: 1
            else: result.dimension = 1
        else:
            result.dimension = if hasArea: 2 else: 1
        var bottom, top: seq[Point[T]]
        if lower.functions.len > 0:
            if left.infinity == 0: bottom.add(Point[T](x: left.value, y: hpiValue(lower, left.value)))
            for k in 1..<lower.starts.len:
                let x = lower.starts[k]
                if hpiCmp(left, x) < 0 and hpiCmp(x, right) < 0:
                    bottom.add(Point[T](x: x.value, y: hpiValue(lower, x.value)))
            if right.infinity == 0 and hpiCmp(left, right) != 0:
                bottom.add(Point[T](x: right.value, y: hpiValue(lower, right.value)))
        if upper.functions.len > 0:
            if right.infinity == 0:
                let y = if rightMeet: hpiValue(lower, right.value) else: -hpiValue(upper, right.value)
                top.add(Point[T](x: right.value, y: y))
            for k in countdown(upper.starts.len-1, 1):
                let x = upper.starts[k]
                if hpiCmp(left, x) < 0 and hpiCmp(x, right) < 0:
                    top.add(Point[T](x: x.value, y: -hpiValue(upper, x.value)))
            if left.infinity == 0 and hpiCmp(left, right) != 0:
                let y = if leftMeet: hpiValue(lower, left.value) else: -hpiValue(upper, left.value)
                top.add(Point[T](x: left.value, y: y))
        for chain in [bottom, top]:
            for p in chain:
                if result.vertices.len == 0 or result.vertices[^1].x != p.x or result.vertices[^1].y != p.y:
                    result.vertices.add(p)
        if result.vertices.len > 1 and result.vertices[0].x == result.vertices[^1].x and
            result.vertices[0].y == result.vertices[^1].y:
            discard result.vertices.pop()

    proc contains*[T](region: HalfPlaneIntersection[T], p: Point[T]): bool =
        ## 保持した左閉半平面をすべて満たすかを判定。O(N) 演算。
        discard hpiChecked(p.x)
        discard hpiChecked(p.y)
        if region.kind == hpiEmpty: return false
        let zero = hpiZero[T]()
        for line in region.constraints:
            let dx = hpiChecked(line.t.x - line.s.x)
            let dy = hpiChecked(line.t.y - line.s.y)
            let side = hpiChecked(dx * (p.y - line.s.y) - dy * (p.x - line.s.x))
            if side < zero: return false
        true
