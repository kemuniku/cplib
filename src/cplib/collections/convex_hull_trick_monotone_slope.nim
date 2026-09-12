when not declared CPLIB_COLLECTIONS_CONVEX_HULL_TRICK_MONOTONE_SLOPE:
    const CPLIB_COLLECTIONS_CONVEX_HULL_TRICK_MONOTONE_SLOPE* = 1
    import deques
    import cplib/math/int128
    import cplib/collections/private/convex_hull_trick_impl

    type ConvexHullTrickMonotoneSlope* = object
        hull: CHTMonotoneHull

    proc initConvexHullTrickMonotoneSlope*(slopeIncreasing: bool = false): ConvexHullTrickMonotoneSlope =
        ## 傾きが単調な最小値CHTを初期化します。既定は広義単調減少。O(1)。
        result.hull = initCHTMonotoneHull(slopeIncreasing)

    proc add_line*(self: var ConvexHullTrickMonotoneSlope, a, b: int) =
        ## ax+bを追加します。傾きは指定した向きに単調である必要があります。償却O(1)。
        self.hull.chtAddLine(a, b)

    proc get_min*(self: ConvexHullTrickMonotoneSlope, x: int): int =
        ## 任意の整数座標xでの最小値を返します。空の場合はassert。O(log N)。
        assert self.hull.lines.len > 0, "CHT: no lines"
        var l = 0
        var r = self.hull.lines.len - 1
        while l < r:
            let m = l + (r - l) div 2
            if chtValue(self.hull.lines[m], x) >= chtValue(self.hull.lines[m + 1], x):
                l = m + 1
            else:
                r = m
        chtAnswer(chtValue(self.hull.lines[l], x))
