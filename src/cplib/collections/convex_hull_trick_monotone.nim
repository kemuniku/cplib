when not declared CPLIB_COLLECTIONS_CONVEX_HULL_TRICK_MONOTONE:
    const CPLIB_COLLECTIONS_CONVEX_HULL_TRICK_MONOTONE* = 1
    import deques
    import cplib/math/int128
    import cplib/collections/private/convex_hull_trick_impl

    type ConvexHullTrickMonotone* = object
        hull: CHTMonotoneHull
        xIncreasing: bool
        hasX: bool
        lastX: int

    proc initConvexHullTrickMonotone*(slopeIncreasing: bool = false,
                                    xIncreasing: bool = true): ConvexHullTrickMonotone =
        ## 傾き・クエリ座標が単調な最小値CHTを初期化します。O(1)。
        result.hull = initCHTMonotoneHull(slopeIncreasing)
        result.xIncreasing = xIncreasing

    proc add_line*(self: var ConvexHullTrickMonotone, a, b: int) =
        ## ax+bを追加します。傾きは指定した向きに単調である必要があります。償却O(1)。
        self.hull.chtAddLine(a, b)

    proc get_min*(self: var ConvexHullTrickMonotone, x: int): int =
        ## 指定した向きに単調な整数座標xでの最小値を返します。空の場合はassert。償却O(1)。
        assert self.hull.lines.len > 0, "CHT: no lines"
        if self.hasX:
            assert (if self.xIncreasing: self.lastX <= x else: x <= self.lastX),
                "CHT: query coordinates must be monotone"
        self.hasX = true
        self.lastX = x
        if self.xIncreasing:
            while self.hull.lines.len >= 2 and
                    chtValue(self.hull.lines[0], x) >= chtValue(self.hull.lines[1], x):
                discard self.hull.lines.popFirst()
            return chtAnswer(chtValue(self.hull.lines[0], x))
        else:
            while self.hull.lines.len >= 2 and
                    chtValue(self.hull.lines[^1], x) >= chtValue(self.hull.lines[^2], x):
                discard self.hull.lines.popLast()
            return chtAnswer(chtValue(self.hull.lines[^1], x))
