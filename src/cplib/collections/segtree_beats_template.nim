when not declared CPLIB_COLLECTIONS_SEGTREE_BEATS_TEMPLATE:
    const CPLIB_COLLECTIONS_SEGTREE_BEATS_TEMPLATE* = 1
    import sequtils
    import cplib/collections/segtree_beats
    import cplib/utils/constants

    type S_rch*[T] = object
        max*: T
        max2*: T
        min*: T
        min2*: T
        sum*: T
        sz*: int
        n_min*: int
        n_max*: int
        fail*: bool
    type F_rch*[T] = object
        lb*: T
        ub*: T
        add*: T

    type RangeChminChmaxRangeSumMaxMin*[T] = object
        seg*: SegmentTreeBeats[S_rch[T], F_rch[T]]
        inf*, zero*: T
    proc init_S[T](val: T, inf: T, sz: int = 1): S_rch[T] = S_rch[T](max: val, max2: -inf, min: val, min2: inf, sum: val * T(sz), sz: sz, n_min: sz, n_max: sz, fail: false)

    proc initRangeChminChmaxRangeSumMaxMin*[T](v: seq[T], inf: T, zero: T): auto =
        proc op(l, r: S_rch[T]): S_rch[T] =
            proc second_lowest(a, b, c, d: T): T {.inline.} =
                if a == c: return min(b, d)
                if b <= c: return b
                if d <= a: return d
                return max(a, c)
            proc second_highest(a, b, c, d: T): T {.inline.} = -second_lowest(-a, -b, -c, -d)
            result.min = min(l.min, r.min)
            result.max = max(l.max, r.max)
            result.min2 = second_lowest(l.min, l.min2, r.min, r.min2)
            result.max2 = second_highest(l.max, l.max2, r.max, r.max2)
            result.sum = l.sum + r.sum
            result.sz = l.sz + r.sz
            result.n_min = l.n_min * int(l.min <= r.min) + r.n_min * int(r.min <= l.min)
            result.n_max = l.n_max * int(l.max >= r.max) + r.n_max * int(r.max >= l.max)
            result.fail = true
        proc e(): S_rch[T] = S_rch[T](max: -inf, max2: -inf, min: inf, min2: inf, sum: zero, sz: 0, n_min: 0, n_max: 0, fail: false)
        proc composition(f, g: F_rch[T]): F_rch[T] =
            result.lb = max(min(g.lb + g.add, f.ub), f.lb) - g.add
            result.ub = min(max(g.ub + g.add, f.lb), f.ub) - g.add
            result.add = f.add + g.add
        proc mapping(f: F_rch[T], x: S_rch[T]): S_rch[T] =
            var x = x
            x.fail = false
            if x.sz == 0: return e()
            if x.min == x.max or f.lb == f.ub or f.lb >= x.max or f.ub <= x.min:
                var x = init_S(min(max(x.min, f.lb), f.ub) + f.add, inf, x.sz)
                return x
            if x.min2 == x.max:
                x.max2 = max(x.min, f.lb) + f.add
                x.min = max(x.min, f.lb) + f.add
                x.min2 = min(x.max, f.ub) + f.add
                x.max = min(x.max, f.ub) + f.add
                x.sum = x.min * T(x.n_min) + x.max * T(x.n_max)
                return x
            if f.lb < x.min2 and f.ub > x.max2:
                var nxt_min = max(x.min, f.lb)
                var nxt_max = min(x.max, f.ub)
                x.sum += (nxt_min - x.min) * T(x.n_min) - (x.max - nxt_max) * T(x.n_max) + f.add * T(x.sz)
                x.min = nxt_min + f.add
                x.max = nxt_max + f.add
                x.min2 += f.add
                x.max2 += f.add
                return x
            x.fail = true
            return x
        proc id(): F_rch[T] = F_rch[T](lb: -inf, ub: inf, add: zero)
        var vn = v.mapIt(init_S(it, inf))
        var seg = initSegmentTreeBeats(vn, op, e(), mapping, composition, id())
        return RangeChminChmaxRangeSumMaxMin[T](seg: seg, inf: inf, zero: zero)
    proc initRangeChminChmaxRangeSumMaxMin*(v: seq[int]): RangeChminChmaxRangeSumMaxMin[int] = initRangeChminChmaxRangeSumMaxMin(v, INF64, 0)
    proc initRangeChminChmaxRangeSumMaxMin*(v: seq[int32]): RangeChminChmaxRangeSumMaxMin[int32] = initRangeChminChmaxRangeSumMaxMin(v, INF32, 0.int32)
    proc initRangeChminChmaxRangeSumMaxMin*(v: seq[float]): RangeChminChmaxRangeSumMaxMin[float] = initRangeChminChmaxRangeSumMaxMin(v, 1e100, 0.0)

    proc update*[T](self: var RangeChminChmaxRangeSumMaxMin[T], p: Natural, val: T) = self.seg.update(p, init_S(val, self.inf))
    proc `[]`*[T](self: var RangeChminChmaxRangeSumMaxMin[T], p: Natural or HSlice[int, int]): S_rch[T] = self.seg[p]
    proc `[]=`*[T](self: var RangeChminChmaxRangeSumMaxMin[T], p: Natural, val: T): S_rch[T] = self.update(p, val)
    proc len*[T](self: var RangeChminChmaxRangeSumMaxMin[T]): int = self.seg.len
    proc `$`*[T](self: var RangeChminChmaxRangeSumMaxMin[T]): string = $(self.seg)
    proc chmin*[T](self: var RangeChminChmaxRangeSumMaxMin[T], segment: HSlice[int, int], val: T) = self.seg.apply(segment, F_rch[T](lb: -self.inf, ub: val, add: self.zero))
    proc chmax*[T](self: var RangeChminChmaxRangeSumMaxMin[T], segment: HSlice[int, int], val: T) = self.seg.apply(segment, F_rch[T](lb: val, ub: self.inf, add: self.zero))
    proc add*[T](self: var RangeChminChmaxRangeSumMaxMin[T], segment: HSlice[int, int], val: T) = self.seg.apply(segment, F_rch[T](lb: -self.inf, ub: self.inf, add: val))

