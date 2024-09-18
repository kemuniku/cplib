when not declared CPLIB_COLLECTIONS_LAZYSEGTREE:
    const CPLIB_COLLECTIONS_LAZYSEGTREE* = 1
    import algorithm, sequtils, bitops, strutils
    type LazySegmentTree[S, F] = ref object
        default: S
        merge: proc(x: S, y: S): S
        arr*: seq[S]
        lazy*: seq[F]
        mapping: proc(f: F, x: S): S
        composition: proc(f, g: F): F
        id: F
        lastnode: int
        log: int
        length: int
    proc initLazySegmentTree*[S, F](v_or_n: int or seq[S], merge: proc(x: S, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): LazySegmentTree[S, F] =
        var v: seq[S]
        var n: int
        when v_or_n is seq[S]:
            v = v_or_n
            n = len(v)
        else:
            n = v_or_n
        var lastnode = 1
        while lastnode < n:
            lastnode*=2
        var log = countTrailingZeroBits(lastnode)
        var arr = newSeqWith(2*lastnode, default)
        var lazy = newSeqWith(lastnode, id)
        var self = LazySegmentTree[S, F](default: default, merge: merge, arr: arr, lazy: lazy, mapping: mapping, composition: composition, id: id, lastnode: lastnode, log: log, length: n)
        when v_or_n is seq[S]:
            for i in 0..<len(v):
                self.arr[self.lastnode+i] = v[i]
            for i in countdown(lastnode-1, 1):
                self.arr[i] = self.merge(self.arr[2*i], self.arr[2*i+1])
        return self

    template all_apply(self, p, f: untyped) =
        ## pの要素にlzの値を作用させる。子がある場合はlazyを更新する。
        self.arr[p] = self.mapping(f, self.arr[p])
        if p < self.lastnode: self.lazy[p] = self.composition(f, self.lazy[p])

    template push(self, p: untyped) =
        ## pの子に作用を伝播させる。
        self.all_apply(2*p, self.lazy[p])
        self.all_apply(2*p + 1, self.lazy[p])
        self.lazy[p] = self.id

    template all_push(self, p: untyped) =
        for i in countdown(self.log, 1): self.push(p shr i)

    proc update*[S, F](self: var LazySegmentTree[S, F], p: Natural, val: var S) =
        ## pの要素をvalに変更します。
        assert p < self.length
        var p = p + self.lastnode
        self.all_push(p)
        self.arr[p] = val
        for i in 1..self.log:
            self.arr[p shr i] = self.merge(self.arr[2*(p shr i)], self.arr[2*(p shr i)+1])

    proc `[]`*[S, F](self: var LazySegmentTree[S, F], p: Natural): S =
        assert p < self.length
        self.all_push(p + self.lastnode)
        return self.arr[p + self.lastnode]

    proc get*[S, F](self: var LazySegmentTree[S, F], q_left, q_right: int): S =
        ## 半解区間[q_left,q_right)についての演算結果を返します。
        assert q_left <= q_right and 0 <= q_left and q_right <= self.length
        if q_left == q_right: return self.default
        var q_left = q_left + self.lastnode
        var q_right = q_right + self.lastnode
        for i in countdown(self.log, 1):
            if i <= countTrailingZeroBits(q_left): break
            self.push(q_left shr i)
        for i in countdown(self.log, 1):
            if i <= countTrailingZeroBits(q_right): break
            self.push((q_right - 1) shr i)
        var
            lres = self.default
            rres = self.default
        while q_left < q_right:
            if (q_left and 1) > 0:
                lres = self.merge(lres, self.arr[q_left])
                q_left.inc
            if (q_right and 1) > 0:
                q_right.dec
                rres = self.merge(self.arr[q_right], rres)
            q_left = q_left shr 1
            q_right = q_right shr 1
        return self.merge(lres, rres)
    proc get*[S, F](self: var LazySegmentTree[S, F], segment: HSlice[int, int]): S =
        return self.get(segment.a, segment.b+1)
    proc `[]`*[S, F](self: var LazySegmentTree[S, F], segment: HSlice[int, int]): S = self.get(segment)
    proc `[]=`*[S, F](self: var LazySegmentTree[S, F], p: Natural, val: S) = self.update(p, val)
    proc len*[S, F](self: var LazySegmentTree[S, F]): int =
        return self.length
    proc `$`*[S, F](self: var LazySegmentTree[S, F]): string =
        # var self = self
        return (0..<self.len).toSeq.mapIt(self[it]).join(" ")
    template newLazySegWith*(v_or_n, merge, default, mapping, composition, id: untyped): untyped =
        type S = typeof(default)
        type F = typeof(id)
        initLazySegmentTree[S, F](
            v_or_n,
            proc (l{.inject.}, r{.inject.}: S): S = merge,
            default, proc (f{.inject.}: F, x{.inject.}: S): S = mapping,
            proc (f{.inject.}, g{.inject.}: F): F = composition,
            id
        )
    proc apply*[S, F](self: var LazySegmentTree[S, F], q_left, q_right: int, f: F) =
        ## 半解区間[q_left,q_right)についての演算結果を返します。
        assert q_left <= q_right and 0 <= q_left and q_right <= self.length
        if q_left == q_right: return
        var q_left = q_left + self.lastnode
        var q_right = q_right + self.lastnode
        var mx = countTrailingZeroBits(q_left) + 1
        for i in countdown(self.log, mx):
            self.push(q_left shr i)
        mx = countTrailingZeroBits(q_right) + 1
        for i in countdown(self.log, mx):
            self.push((q_right - 1) shr i)
        block:
            var q_left = q_left
            var q_right = q_right
            while q_left < q_right:
                if (q_left and 1) > 0:
                    self.all_apply(q_left, f)
                    q_left.inc
                if (q_right and 1) > 0:
                    q_right.dec
                    self.all_apply(q_right, f)
                q_left = q_left shr 1
                q_right = q_right shr 1
        var mn = countTrailingZeroBits(q_left) + 1
        for i in mn..self.log:
            var p = q_left shr i
            self.arr[p] = self.merge(self.arr[2*p], self.arr[2*p+1])
        mn = countTrailingZeroBits(q_right) + 1
        for i in mn..self.log:
            var p = ((q_right - 1) shr i)
            self.arr[p] = self.merge(self.arr[2*p], self.arr[2*p+1])
    proc apply*[S, F](self: var LazySegmentTree[S, F], segment: HSlice[int, int], f: F) =
        self.apply(segment.a, segment.b+1, f)
