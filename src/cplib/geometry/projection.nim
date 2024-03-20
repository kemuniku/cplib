when not declared CPLIB_GEOMETRY_PROJECTION:
    const CPLIB_GEOMETRY_PROJECTION* = 1
    import cplib/geometry/base
    proc projection*[T](l: Line[T], p: Point[T]): Point[T] =
        ##直線 l への点 p の射影
        var t = dot(p - l.s, l.vector) / norm(l.vector)
        return l.s + l.vector * t
    proc reflection*[T](l: Line[T], p: Point[T]): Point[T] =
        ##点 p の直線 l に対する反射
        p + (projection(l, p) - p) * 2
