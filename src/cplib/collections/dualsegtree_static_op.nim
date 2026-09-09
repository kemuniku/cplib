when not declared CPLIB_COLLECTIONS_DUALSEGTREE_STATIC_OP:
    const CPLIB_COLLECTIONS_DUALSEGTREE_STATIC_OP* = 1
    import bitops, sequtils, strutils

    type DualSegmentTree*[S, F; p: static[tuple]] = ref object
        data: seq[S]
        lazy: seq[F]
        hasLazy: seq[bool]
        lastnode: int
        log: int
        length: int

    template mappingOp[ST: DualSegmentTree](
        self: ST or typedesc[ST], f: ST.F, x: ST.S
    ): auto =
        block:
            let value = ST.p[0](f, x)
            value

    template compositionOp[ST: DualSegmentTree](
        self: ST or typedesc[ST], f, g: ST.F
    ): auto =
        block:
            let value = ST.p[1](f, g)
            value

    template DualSegmentTreeType[S, F](
        mapping0, composition0: untyped
    ): typedesc[DualSegmentTree] =
        proc staticMapping(f: F, x: S): S {.gensym, inline.} = mapping0(f, x)
        proc staticComposition(f, g: F): F {.gensym, inline.} = composition0(f, g)
        DualSegmentTree[S, F, (staticMapping, staticComposition)]

    when defined(release):
        {.push checks: off.}
    else:
        {.push boundChecks: off, overflowChecks: off, rangeChecks: off.}

    proc initDualSegmentTreeImpl[ST: DualSegmentTree](
        self: typedesc[ST], v: openArray[ST.S]
    ): ST =
        ## vを初期値として静的な作用関数を持つ双対セグメント木を生成します。
        let n = v.len
        var lastnode = 1
        while lastnode < n:
            lastnode *= 2
        result = ST(
            data: @v,
            lazy: newSeq[ST.F](lastnode),
            hasLazy: newSeq[bool](lastnode),
            lastnode: lastnode,
            log: countTrailingZeroBits(lastnode),
            length: n
        )

    proc initDualSegmentTreeImpl[ST: DualSegmentTree](
        self: typedesc[ST], n: int, initValue: ST.S
    ): ST =
        ## initValueで初期化した長さnの静的な作用関数を持つ双対セグメント木を生成します。
        assert n >= 0
        self.initDualSegmentTreeImpl(newSeqWith(n, initValue))

    template initDualSegmentTree*[S, F](
        v: openArray[S], mapping: untyped, composition: untyped, id: F
    ): untyped =
        ## vを初期値として静的な作用関数を持つ双対セグメント木を生成します。
        DualSegmentTreeType[S, F](mapping, composition)
            .initDualSegmentTreeImpl(v)

    template initDualSegmentTree*[S, F](
        n: int, initValue: S, mapping: untyped, composition: untyped, id: F
    ): untyped =
        ## initValueで初期化した長さnの静的な作用関数を持つ双対セグメント木を生成します。
        DualSegmentTreeType[S, F](mapping, composition)
            .initDualSegmentTreeImpl(n, initValue)

    template allApply(self, p, f: untyped) =
        ## pの要素または遅延値にfを作用させます。
        if p < self.lastnode:
            if self.hasLazy[p]:
                self.lazy[p] = self.compositionOp(f, self.lazy[p])
            else:
                self.lazy[p] = f
                self.hasLazy[p] = true
        else:
            let index = p - self.lastnode
            if index < self.length:
                self.data[index] = self.mappingOp(f, self.data[index])

    proc pushNode[ST: DualSegmentTree](self: ST, p: int) {.noinline.} =
        ## pの遅延値を子へ伝播させます。
        if self.hasLazy[p]:
            let
                f = self.lazy[p]
                left = 2 * p
                right = left + 1
            self.allApply(left, f)
            self.allApply(right, f)
            self.hasLazy[p] = false

    template push(self, p: untyped) =
        ## pの遅延値を子へ伝播させます。
        self.pushNode(p)

    template allPush(self, p: untyped) =
        ## pから葉まで遅延値を伝播させます。
        for i in countdown(self.log, 1):
            self.push(p shr i)

    proc apply*[ST: DualSegmentTree](self: ST, left, right: int, f: ST.F) =
        ## 半開区間[left, right)の各要素にfを作用させます。
        assert 0 <= left and left <= right and right <= self.length
        if left == right:
            return
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

    proc apply*[ST: DualSegmentTree](
        self: ST, segment: HSlice[int, int], f: ST.F
    ) =
        ## 閉区間segmentの各要素にfを作用させます。
        self.apply(segment.a, segment.b + 1, f)

    proc get*[ST: DualSegmentTree](self: ST, index: int): ST.S =
        ## indexの現在値を返します。
        assert 0 <= index and index < self.length
        let p = index + self.lastnode
        self.allPush(p)
        self.data[index]

    proc update*[ST: DualSegmentTree](self: ST, index: Natural, value: ST.S) =
        ## indexの値をvalueに置き換えます。
        assert index < self.length
        let p = int(index) + self.lastnode
        self.allPush(p)
        self.data[index] = value

    proc len*[ST: DualSegmentTree](self: ST): int =
        ## 要素数を返します。
        self.length

    proc `[]`*[ST: DualSegmentTree](self: ST, index: int): ST.S =
        ## indexの現在値を返します。
        self.get(index)

    proc `[]`*[ST: DualSegmentTree](self: ST, index: BackwardsIndex): ST.S =
        ## 後ろから数えたindexの現在値を返します。
        self.get(self.length - int(index))

    proc `[]=`*[ST: DualSegmentTree](self: ST, index: Natural, value: ST.S) =
        ## indexの値をvalueに置き換えます。
        self.update(index, value)

    iterator items*[ST: DualSegmentTree](self: ST): ST.S =
        for i in 0..<self.length:
            yield self.get(i)

    proc toSeq*[ST: DualSegmentTree](self: ST): seq[ST.S] =
        ## 全要素をseqとして返します。
        for x in self:
            result.add(x)

    proc `$`*[ST: DualSegmentTree](self: ST): string =
        ## 全要素を空白区切りの文字列として返します。
        self.toSeq.join(" ")

    template newDualSegWith*(v, mapping, composition, id: untyped): untyped =
        block:
            type S = typeof(v[0])
            type F = typeof(id)
            proc staticMapping(
                f {.inject.}: F, x {.inject.}: S
            ): S {.gensym, inline.} = mapping
            proc staticComposition(
                f {.inject.}, g {.inject.}: F
            ): F {.gensym, inline.} = composition
            DualSegmentTree[S, F, (staticMapping, staticComposition)]
                .initDualSegmentTreeImpl(v)

    template newDualSegWith*(n, initValue, mapping, composition, id: untyped): untyped =
        block:
            type S = typeof(initValue)
            type F = typeof(id)
            proc staticMapping(
                f {.inject.}: F, x {.inject.}: S
            ): S {.gensym, inline.} = mapping
            proc staticComposition(
                f {.inject.}, g {.inject.}: F
            ): F {.gensym, inline.} = composition
            DualSegmentTree[S, F, (staticMapping, staticComposition)]
                .initDualSegmentTreeImpl(n, initValue)

    {.pop.}
