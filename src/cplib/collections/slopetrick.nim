when not declared CPLIB_COLLECTIONS_SLOPETRICK:
    const CPLIB_COLLECTIONS_SLOPETRICK* = 1
    import tables
    import cplib/collections/avlset
    import cplib/utils/constants

    # A convex piecewise-linear function is represented by
    #   min_f + sum w * max(a-x, 0) + sum w * max(x-a, 0).
    # Unlike the usual heap implementation, an AVL tree stores each distinct
    # breakpoint only once.  `weight[a]` is the change of slope at that point.
    type WeightedBreakpoints = object
        keys: AvlSortedSet[int]
        weight: Table[int, int]

    type SlopeTrick* = ref object
        L, R: WeightedBreakpoints
        min_f: int
        l_add, r_add: int

    proc addWeight(s: var WeightedBreakpoints, x, w: int) =
        if w == 0: return
        if s.weight.hasKey(x):
            s.weight[x] += w
        else:
            s.keys.incl(x)
            s.weight[x] = w

    proc takeWeight(s: var WeightedBreakpoints, x, w: int) =
        ## Removes w units at x.  The caller guarantees 0 < w <= weight[x].
        if s.weight[x] == w:
            s.weight.del(x)
            s.keys.excl(x)
        else:
            s.weight[x] -= w

    proc pushL(f: SlopeTrick, x, w: int) =
        f.L.addWeight(x - f.l_add, w)

    proc pushR(f: SlopeTrick, x, w: int) =
        f.R.addWeight(x - f.r_add, w)

    proc L0(f: SlopeTrick): int =
        if f.L.keys.len == 0: -INF64
        else: f.L.keys[^1] + f.l_add

    proc R0(f: SlopeTrick): int =
        if f.R.keys.len == 0: INF64
        else: f.R.keys[0] + f.r_add

    proc clearL*(f: SlopeTrick) =
        f.L = WeightedBreakpoints()

    proc clearR*(f: SlopeTrick) =
        f.R = WeightedBreakpoints()

    proc min*(f: SlopeTrick): int = f.min_f

    proc add_all*(f: SlopeTrick, a: int) =
        f.min_f += a

    proc add_x_minus_a*(f: SlopeTrick, a: int, c: int = 1) =
        ## Adds c * max(x-a, 0) to f(x).  c must be nonnegative.
        ## The complexity is O((k+1) log N), where k is the number of
        ## distinct breakpoints moved from L to R.
        doAssert c >= 0
        var rest = c
        while rest > 0 and f.L.keys.len > 0:
            let raw = f.L.keys[^1]
            let x = raw + f.l_add
            if x <= a: break
            let moved = min(rest, f.L.weight[raw])
            f.L.takeWeight(raw, moved)
            f.pushL(a, moved)
            f.pushR(x, moved)
            f.min_f += (x - a) * moved
            rest -= moved
        f.pushR(a, rest)

    proc add_a_minus_x*(f: SlopeTrick, a: int, c: int = 1) =
        ## Adds c * max(a-x, 0) to f(x).  c must be nonnegative.
        ## The complexity is O((k+1) log N), where k is the number of
        ## distinct breakpoints moved from R to L.
        doAssert c >= 0
        var rest = c
        while rest > 0 and f.R.keys.len > 0:
            let raw = f.R.keys[0]
            let x = raw + f.r_add
            if x >= a: break
            let moved = min(rest, f.R.weight[raw])
            f.R.takeWeight(raw, moved)
            f.pushR(a, moved)
            f.pushL(x, moved)
            f.min_f += (a - x) * moved
            rest -= moved
        f.pushL(a, rest)

    proc add_abs*(f: SlopeTrick, a: int, c: int = 1) =
        ## Adds c * abs(x-a) to f(x).  c must be nonnegative.
        f.add_x_minus_a(a, c)
        f.add_a_minus_x(a, c)

    proc min_index*(f: SlopeTrick): int = f.L0

    proc shift*(f: SlopeTrick, a: int) =
        f.l_add += a
        f.r_add += a

    proc shift*(f: SlopeTrick, a, b: int) =
        ## Replaces f by g(x) = min(f(y) | x-b <= y <= x-a).
        doAssert a <= b
        f.l_add += a
        f.r_add += b

    proc get_value*(f: SlopeTrick, x: int): int =
        ## Returns f(x).  This takes O(N), where N is the number of distinct
        ## breakpoints (not the sum of their weights).
        result = f.min_f
        for raw in f.L.keys:
            let a = raw + f.l_add
            result += max(0, a - x) * f.L.weight[raw]
        for raw in f.R.keys:
            let a = raw + f.r_add
            result += max(0, x - a) * f.R.weight[raw]

    proc initSlopeTrick*(a: int = 0): SlopeTrick =
        SlopeTrick(min_f: a)
