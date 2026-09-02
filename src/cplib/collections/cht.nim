when not declared CPLIB_COLLECTIONS_CHT:
    const CPLIB_COLLECTIONS_CHT* = 1

    import cplib/collections/avlset

    type
        CHTOrder* = enum
            increasing, decreasing

        CHTObjective* = enum
            minimize, maximize

        CHTLine* = object
            a*, b*: int

        MonotoneAddCHT* = object
            lines: seq[CHTLine]
            xSign, ySign: int
            lastSlope: int
            hasLastSlope: bool

        MonotoneCHT* = object
            hull: MonotoneAddCHT
            queryOrder: CHTOrder
            left, right: int
            queried: bool
            lastX: int

        DynamicCHT* = object
            lines: AVLSortedSet[CHTLine]
            ySign: int

    proc `<`*(x, y: CHTLine): bool =
        (x.a, x.b) < (y.a, y.b)

    proc `<=`*(x, y: CHTLine): bool =
        (x.a, x.b) <= (y.a, y.b)

    proc eval*(line: CHTLine, x: int): int {.inline.} =
        line.a * x + line.b

    proc redundant(x, y, z: CHTLine): bool {.inline.} =
        ## Assumes x.a < y.a < z.a.  Division-free comparison of the two
        ## intersection points.  As with eval, products must fit in int.
        (y.b - z.b) * (y.a - x.a) >=
            (x.b - y.b) * (z.a - y.a)

    proc initMonotoneAddCHT*(
        slopeOrder = increasing,
        objective = minimize
    ): MonotoneAddCHT =
        ## Lines must be added in slopeOrder. Queries may be made in any order.
        ## addLine is amortized O(1), query is O(log N).
        result.ySign = (if objective == minimize: 1 else: -1)
        let transformedOrder =
            if result.ySign == 1: slopeOrder
            elif slopeOrder == increasing: decreasing
            else: increasing
        result.xSign = (if transformedOrder == increasing: 1 else: -1)

    proc len*(cht: MonotoneAddCHT): int = cht.lines.len

    proc addLine*(cht: var MonotoneAddCHT, a, b: int) =
        if cht.hasLastSlope:
            if cht.xSign * cht.ySign == 1:
                assert cht.lastSlope <= a, "slopes must be nondecreasing"
            else:
                assert cht.lastSlope >= a, "slopes must be nonincreasing"
        cht.lastSlope = a
        cht.hasLastSlope = true

        let line = CHTLine(
            a: cht.xSign * cht.ySign * a,
            b: cht.ySign * b
        )
        if cht.lines.len > 0 and cht.lines[^1].a == line.a:
            if cht.lines[^1].b <= line.b: return
            discard cht.lines.pop()
        while cht.lines.len >= 2 and
                redundant(cht.lines[^2], cht.lines[^1], line):
            discard cht.lines.pop()
        cht.lines.add(line)

    proc query*(cht: MonotoneAddCHT, x: int): int =
        assert cht.lines.len > 0, "cannot query an empty CHT"
        let x = cht.xSign * x
        var left = 0
        var right = cht.lines.len - 1
        while left < right:
            let mid = (left + right) shr 1
            if cht.lines[mid].eval(x) <= cht.lines[mid + 1].eval(x):
                right = mid
            else:
                left = mid + 1
        result = cht.ySign * cht.lines[left].eval(x)

    proc initMonotoneCHT*(
        slopeOrder = increasing,
        queryOrder = increasing,
        objective = minimize
    ): MonotoneCHT =
        ## Both slopes and query coordinates must follow their declared order.
        ## addLine and query are amortized O(1). Add all lines before querying.
        result.hull = initMonotoneAddCHT(slopeOrder, objective)
        result.queryOrder = queryOrder

    proc len*(cht: MonotoneCHT): int = cht.hull.len

    proc addLine*(cht: var MonotoneCHT, a, b: int) =
        assert not cht.queried, "add all lines before the first query"
        cht.hull.addLine(a, b)

    proc query*(cht: var MonotoneCHT, x: int): int =
        assert cht.hull.lines.len > 0, "cannot query an empty CHT"
        if cht.queried:
            if cht.queryOrder == increasing:
                assert cht.lastX <= x, "query coordinates must be nondecreasing"
            else:
                assert cht.lastX >= x, "query coordinates must be nonincreasing"
        else:
            cht.left = 0
            cht.right = cht.hull.lines.len - 1
            cht.queried = true
        cht.lastX = x

        let tx = cht.hull.xSign * x
        let transformedIncreasing =
            (cht.queryOrder == increasing) == (cht.hull.xSign == 1)
        if transformedIncreasing:
            while cht.left < cht.right and
                    cht.hull.lines[cht.right - 1].eval(tx) <=
                    cht.hull.lines[cht.right].eval(tx):
                dec cht.right
            result = cht.hull.lines[cht.right].eval(tx)
        else:
            while cht.left < cht.right and
                    cht.hull.lines[cht.left + 1].eval(tx) <=
                    cht.hull.lines[cht.left].eval(tx):
                inc cht.left
            result = cht.hull.lines[cht.left].eval(tx)
        result *= cht.hull.ySign

    proc initDynamicCHT*(objective = minimize): DynamicCHT =
        ## Lines and query coordinates may both be supplied in arbitrary order.
        ## addLine is amortized O(log N), query is O(log^2 N), using avlset.
        result.lines = initAvlSortedSet[CHTLine]()
        result.ySign = (if objective == minimize: 1 else: -1)

    proc len*(cht: DynamicCHT): int = cht.lines.len

    proc addLine*(cht: var DynamicCHT, a, b: int) =
        let line = CHTLine(a: cht.ySign * a, b: cht.ySign * b)
        var pos = cht.lines.lowerBound(CHTLine(a: line.a, b: low(int)))

        if pos < cht.lines.len and cht.lines[pos].a == line.a:
            if cht.lines[pos].b <= line.b: return
            discard cht.lines.pop(pos)

        pos = cht.lines.lowerBound(line)
        if pos > 0 and pos < cht.lines.len and
                redundant(cht.lines[pos - 1], line, cht.lines[pos]):
            return
        discard cht.lines.incl(line)
        pos = cht.lines.lowerBound(line)

        while pos >= 2 and
                redundant(cht.lines[pos - 2], cht.lines[pos - 1], cht.lines[pos]):
            discard cht.lines.pop(pos - 1)
            dec pos
        while pos + 2 < cht.lines.len and
                redundant(cht.lines[pos], cht.lines[pos + 1], cht.lines[pos + 2]):
            discard cht.lines.pop(pos + 1)

    proc query*(cht: DynamicCHT, x: int): int =
        assert cht.lines.len > 0, "cannot query an empty CHT"
        var left = 0
        var right = cht.lines.len - 1
        while left < right:
            let mid = (left + right) shr 1
            if cht.lines[mid].eval(x) <= cht.lines[mid + 1].eval(x):
                right = mid
            else:
                left = mid + 1
        result = cht.ySign * cht.lines[left].eval(x)
