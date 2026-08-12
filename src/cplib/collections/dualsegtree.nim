when not declared CPLIB_COLLECTIONS_DUALSEGTREE:
    const CPLIB_COLLECTIONS_DUALSEGTREE* = 1
    import bitops, sequtils, strutils

    type DualSegmentTree*[S, F] = ref object
        data: seq[S]
        lazy: seq[F]
        mapping: proc(f: F, x: S): S
        composition: proc(f, g: F): F
        id: F
        lastnode: int
        log: int
        length: int

    proc initDualSegmentTree*[S, F](
        v: openArray[S],
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): DualSegmentTree[S, F] =
        var lastnode = 1
        while lastnode < v.len:
            lastnode *= 2
        result = DualSegmentTree[S, F](
            data: @v,
            lazy: newSeqWith(lastnode, id),
            mapping: mapping,
            composition: composition,
            id: id,
            lastnode: lastnode,
            log: countTrailingZeroBits(lastnode),
            length: v.len
        )

    proc initDualSegmentTree*[S, F](
        n: int,
        initValue: S,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): DualSegmentTree[S, F] =
        assert n >= 0
        initDualSegmentTree(newSeqWith(n, initValue), mapping, composition, id)

    template newDualSegWith*(v, mapping, composition, id: untyped): untyped =
        type S = typeof(v[0])
        type F = typeof(id)
        initDualSegmentTree[S, F](
            v,
            proc (f{.inject.}: F, x{.inject.}: S): S = mapping,
            proc (f{.inject.}, g{.inject.}: F): F = composition,
            id
        )

    template newDualSegWith*(n, initValue, mapping, composition, id: untyped): untyped =
        type S = typeof(initValue)
        type F = typeof(id)
        initDualSegmentTree[S, F](
            n,
            initValue,
            proc (f{.inject.}: F, x{.inject.}: S): S = mapping,
            proc (f{.inject.}, g{.inject.}: F): F = composition,
            id
        )

    proc allApply[S, F](self: DualSegmentTree[S, F], p: int, f: F) {.inline.} =
        if p < self.lastnode:
            self.lazy[p] = self.composition(f, self.lazy[p])
        else:
            let index = p - self.lastnode
            if index < self.length:
                self.data[index] = self.mapping(f, self.data[index])

    proc push[S, F](self: DualSegmentTree[S, F], p: int) {.inline.} =
        self.allApply(2 * p, self.lazy[p])
        self.allApply(2 * p + 1, self.lazy[p])
        self.lazy[p] = self.id

    proc apply*[S, F](self: DualSegmentTree[S, F], left, right: int, f: F) =
        ## 半開区間 [left, right) の各要素に f を作用させます。
        assert 0 <= left and left <= right and right <= self.length
        if left == right: return
        var l = left + self.lastnode
        var r = right + self.lastnode
        for i in countdown(self.log, 1):
            if ((l shr i) shl i) != l:
                self.push(l shr i)
            if ((r shr i) shl i) != r:
                self.push((r - 1) shr i)
        while l < r:
            if (l and 1) != 0:
                self.allApply(l, f)
                l.inc
            if (r and 1) != 0:
                r.dec
                self.allApply(r, f)
            l = l shr 1
            r = r shr 1

    proc apply*[S, F](self: DualSegmentTree[S, F], segment: HSlice[int, int], f: F) =
        self.apply(segment.a, segment.b + 1, f)

    proc get*[S, F](self: DualSegmentTree[S, F], index: int): S =
        ## index の現在値を返します。
        assert 0 <= index and index < self.length
        let p = index + self.lastnode
        for i in countdown(self.log, 1):
            self.push(p shr i)
        self.data[index]

    proc update*[S, F](self: DualSegmentTree[S, F], index: Natural, value: S) =
        ## index の値を value に置き換えます。
        assert index < self.length
        let p = int(index) + self.lastnode
        for i in countdown(self.log, 1):
            self.push(p shr i)
        self.data[index] = value

    proc len*[S, F](self: DualSegmentTree[S, F]): int =
        self.length

    proc `[]`*[S, F](self: DualSegmentTree[S, F], index: int): S =
        self.get(index)

    proc `[]`*[S, F](self: DualSegmentTree[S, F], index: BackwardsIndex): S =
        self.get(self.length - int(index))

    proc `[]=`*[S, F](self: DualSegmentTree[S, F], index: Natural, value: S) =
        self.update(index, value)

    iterator items*[S, F](self: DualSegmentTree[S, F]): S =
        for i in 0..<self.length:
            yield self.get(i)

    proc toSeq*[S, F](self: DualSegmentTree[S, F]): seq[S] =
        for x in self:
            result.add(x)

    proc `$`*[S, F](self: DualSegmentTree[S, F]): string =
        self.toSeq.join(" ")
