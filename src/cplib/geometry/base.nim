when not declared CPLIB_GEOMETRY_BASE:
    const CPLIB_GEOMETRY_BASE* = 1
    import hashes, strformat
    type Point*[T] = object
        x*, y*: T
    var GEOMETRY_EPS* = 1e-10

    proc initPoint*[T](p: (T, T)): Point[T] =
        ##点を (p[0], p[1]) で初期化
        Point[T](x: p[0], y: p[1])
    proc initPoint*[T](x, y: T): Point[T] =
        ##点を (x, y) で初期化
        Point[T](x: x, y: y)

    proc `+`*[T](p: Point[T]): Point[T] = p
    proc `-`*[T](p: Point[T]): Point[T] = Point[T](x: -p.x, y: -p.y)
    proc `+=`*[T](p: var Point[T], q: Point[T]) = (p.x += q.x; p.y += q.y)
    proc `-=`*[T](p: var Point[T], q: Point[T]) = (p.x -= q.x; p.y -= q.y)
    proc `*=`*[S](p: var Point[SomeFloat], x: S) = (p.x *= float(x); p.y *= float(x))
    proc `*=`*[T, S](p: var Point[T], x: S) = (p.x *= x; p.y *= x)
    proc `/=`*[S](p: var Point[SomeFloat], x: S) = (p.x /= float(x); p.y /= float(x))
    proc `/=`*[T, S](p: var Point[T], x: S) = (p.x /= x; p.y /= x)
    proc dot*[T](p, q: Point[T]): T =
        ##2点p,qの内積 (p.x * q.x + p.y * q.y)
        p.x * q.x + p.y * q.y
    proc cross*[T](p, q: Point[T]): T =
        ##2点p,qの外積 (p.x * q.y - p.y * q.x)
        p.x * q.y - p.y * q.x
    proc `*`*[T](p, q: Point[T]): T = dot(p, q)
    proc `@`*[T](p, q: Point[T]): T = cross(p, q)
    proc norm*[T](p: Point[T]): T =
        ##pのノルム (p.x * p.x + p.y * p.y)
        dot(p, p)
    proc `$`*[T](p: Point[T]): string = &"({p.x}, {p.y})"

    proc geometry_eq*[T, S](x: T, y: S): bool = x == y
    proc geometry_eq*(x, y: SomeFloat): bool = (abs(x - y) < GEOMETRY_EPS * x) or (abs(x - y) < GEOMETRY_EPS)
    proc geometry_eq*(x: int, y: SomeFloat): bool = geometry_eq(float(x), y)
    proc geometry_eq*(x: SomeFloat, y: int): bool = geometry_eq(x, float(y))
    proc geometry_neq*[T, S](x: T, y: S): bool = not geometry_eq(x, y)
    proc geometry_ge*[T, S](x: T, y: S): bool = geometry_eq(x, y) or (x > y)
    proc geometry_ge*(x: int, y: SomeFloat): bool = geometry_ge(float(x), y)
    proc geometry_ge*(x: SomeFloat, y: int): bool = geometry_ge(x, float(y))
    proc geometry_le*[T, S](x: T, y: S): bool = geometry_eq(x, y) or (x < y)
    proc geometry_le*(x: int, y: SomeFloat): bool = geometry_eq(float(x), y)
    proc geometry_le*(x: SomeFloat, y: int): bool = geometry_eq(x, float(y))
    proc geometry_gt*[T, S](x: T, y: S): bool = not geometry_le(x, y)
    proc geometry_lt*[T, S](x: T, y: S): bool = not geometry_ge(x, y)
    proc `<`*[T](p, q: Point[T]): bool =
        if geometry_eq(p.x, q.x): return geometry_lt(p.y, q.y)
        return geometry_lt(p.x, q.x)
    proc `>`*[T](p, q: Point[T]): bool =
        if geometry_eq(p.x, q.x): return geometry_gt(p.y, q.y)
        return geometry_gt(p.x, q.x)
    proc `==`*[T](p, q: Point[T]): bool = geometry_eq(p.x, q.x) and geometry_eq(p.y, q.y)
    proc cmp*[T](p, q: Point[T]): int = (if p < q: -1 elif p == q: 0 else: 1)


    proc `+`*[T](p: Point[T], q: Point[T]): Point[T] = (result = p; result += q)
    proc `-`*[T](p: Point[T], q: Point[T]): Point[T] = (result = p; result -= q)
    proc `*`*[T, S](p: Point[T], x: S): Point[T] = (result = p; result *= x)
    proc `*`*[T, S](x: S, p: Point[T]): Point[T] = p * x
    proc `/`*[T, S](p: Point[T], x: S): Point[T] = (result = p; result /= x)
    proc `<=`*[T](p, q: Point[T]): bool = not (p > q)
    proc `>=`*[T](p, q: Point[T]): bool = not (p < q)

    proc hash*[T](p: Point[T]): Hash =
        result = result !& hash(p.x)
        result = result !& hash(p.y)

    type Line*[T] = object
        s*, t*: Point[T]

    proc initLine*[T](s, t: Point[T]): Line[T] =
        ##2点 (s, t) を通る直線の初期化
        (assert s != t; return Line[T](s: s, t: t))
    proc initLine*[T](a, b, c: int): Line[int] = assert false, "(a,b,c) initialization can't be used for Line[int], please use float or Fraction"
    proc initLine*[T](a, b, c: T): Line[T] =
        ##直線 ax + by + c = 0 の初期化、int 型に対しては使用不可
        assert geometry_neq(a, T(0)) or geometry_neq(b, T(0))
        if geometry_eq(b, T(0)):
            var s = Point[T](x: -c / a, y: T(0))
            var t = Point[T](x: -c / a, y: T(1))
            return Line[T](s: s, t: t)
        else:
            var s = Point[T](x: T(0), y: -c / b)
            var t = Point[T](x: T(1), y: (-a-c) / b)
            return Line[T](s: s, t: t)
    proc vector*[T](l: Line[T]): Point[T] =
        ##直線の接ベクトル（直線の方向のベクトル）
        l.t - l.s
    proc `$`*[T](l: Line[T]): string = &"({l.s}, {l.t})"


    type Segment*[T] = object
        s*, t*: Point[T]
    proc initSegment*[T](s, t: Point[T]): Segment[T] =
        ##2点 (s, t) を結ぶ線分の初期化
        (assert s != t; return Segment[T](s: s, t: t))
    converter toLine*[T](s: Segment[T]): Line[T] = initLine(s.s, s.t)

