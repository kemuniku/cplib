when not declared CPLIB_GEOMETRY_PROJECTION:
    const CPLIB_GEOMETRY_PROJECTION* = 1
    include cplib/geometry/base
    proc projection*[T](l: Line[T], p: Point[T]): Point[T] =
        var t = dot(p - l.s, l.vector) / norm(l.vector)
        return l.s + l.vector * t
    proc reflection*[T](l: Line[T], p: Point[T]): Point[T] = p + (projection(l, p) - p) * 2
