when not declared CPLIB_COLLECTIONS_LAZYSEGTREE:
    const CPLIB_COLLECTIONS_LAZYSEGTREE* = 1
    import algorithm, sequtils, bitops, strutils
    type LazySegmentTree*[S, F] = ref object
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

    proc update*[S, F](self: var LazySegmentTree[S, F], p: Natural, val: S) =
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
    proc get_all*[S, F](self: LazySegmentTree[S, F]): S =
        ## 全要素についての演算結果をO(1)で返します。空の場合は単位元を返します。
        return self.arr[1]

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

    proc max_right*[S, F](self: var LazySegmentTree[S, F], l: int, f: proc(l: S): bool): int =
        ## f(get(l, r))を満たす最大のrをO(log N)で返します。
        ## fは区間の拡大に対して単調で、単位元に対してtrueを返す必要があります。
        assert 0 <= l and l <= self.len
        assert f(self.default)
        if l == self.len: return self.len
        var l = l + self.lastnode
        self.all_push(l)
        var sm = self.default
        while true:
            while l mod 2 == 0: l = (l shr 1)
            if not f(self.merge(sm, self.arr[l])):
                while l < self.lastnode:
                    self.push(l)
                    l *= 2
                    if f(self.merge(sm, self.arr[l])):
                        sm = self.merge(sm, self.arr[l])
                        l += 1
                return l - self.lastnode
            sm = self.merge(sm, self.arr[l])
            l += 1
            if (l and -l) == l: break
        return self.len
    proc min_left*[S, F](self: var LazySegmentTree[S, F], r: int, f: proc(l: S): bool): int =
        ## f(get(l, r))を満たす最小のlをO(log N)で返します。
        ## fは区間の拡大に対して単調で、単位元に対してtrueを返す必要があります。
        assert 0 <= r and r <= self.len
        assert f(self.default)
        if r == 0: return 0
        var r = r + self.lastnode
        self.all_push(r - 1)
        var sm = self.default
        while true:
            r -= 1
            while ((r > 1) and (r mod 2 != 0)): r = (r shr 1)
            if not f(self.merge(self.arr[r], sm)):
                while r < self.lastnode:
                    self.push(r)
                    r = 2 * r + 1
                    if f(self.merge(self.arr[r], sm)):
                        sm = self.merge(self.arr[r], sm)
                        r -= 1
                return r + 1 - self.lastnode
            sm = self.merge(self.arr[r], sm)
            if (r and -r) == r: break
        return 0
