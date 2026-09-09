when not declared CPLIB_COLLECTIONS_LAZYSEGTREE_STATIC_OP:
    const CPLIB_COLLECTIONS_LAZYSEGTREE_STATIC_OP* = 1
    import algorithm, sequtils, bitops, strutils

    type LazySegmentTree*[S, F; p: static[tuple]] = ref object
        default: S
        arr*: seq[S]
        lazy*: seq[F]
        hasLazy: seq[bool]
        lastnode: int
        log: int
        length: int

    template mergeOp[ST: LazySegmentTree](
        self: ST or typedesc[ST], x, y: ST.S
    ): auto =
        block:
            let value = ST.p[0](x, y)
            value

    template mappingOp[ST: LazySegmentTree](
        self: ST or typedesc[ST], f: ST.F, x: ST.S
    ): auto =
        block:
            let value = ST.p[1](f, x)
            value

    template compositionOp[ST: LazySegmentTree](
        self: ST or typedesc[ST], f, g: ST.F
    ): auto =
        block:
            let value = ST.p[2](f, g)
            value

    template LazySegmentTreeType[S, F](
        op0, mapping0, composition0: untyped
    ): typedesc[LazySegmentTree] =
        proc staticMerge(x, y: S): S {.gensym, inline.} = op0(x, y)
        proc staticMapping(f: F, x: S): S {.gensym, inline.} = mapping0(f, x)
        proc staticComposition(f, g: F): F {.gensym, inline.} = composition0(f, g)
        LazySegmentTree[S, F, (staticMerge, staticMapping, staticComposition)]

    when defined(release):
        {.push checks: off.}
    else:
        {.push boundChecks: off, overflowChecks: off, rangeChecks: off.}

    proc initLazySegmentTreeImpl[ST: LazySegmentTree](
        self: typedesc[ST], v: seq[ST.S], default: ST.S, id: ST.F
    ): ST =
        let n = len(v)
        var lastnode = 1
        while lastnode < n:
            lastnode *= 2
        let log = countTrailingZeroBits(lastnode)
        var arr = newSeq[ST.S](2 * lastnode)
        var zero: ST.S
        when compiles(default == zero):
            if default != zero:
                for i in 0..<arr.len:
                    arr[i] = default
        else:
            for i in 0..<arr.len:
                arr[i] = default
        let lazy = newSeq[ST.F](lastnode)
        let hasLazy = newSeq[bool](lastnode)
        result = ST(
            default: default,
            arr: arr,
            lazy: lazy,
            hasLazy: hasLazy,
            lastnode: lastnode,
            log: log,
            length: n
        )
        for i in 0..<len(v):
            result.arr[result.lastnode + i] = v[i]
        for i in countdown(lastnode - 1, 1):
            result.arr[i] = result.mergeOp(result.arr[2 * i], result.arr[2 * i + 1])

    proc initLazySegmentTreeImpl[ST: LazySegmentTree](
        self: typedesc[ST], n: int, default: ST.S, id: ST.F
    ): ST =
        var lastnode = 1
        while lastnode < n:
            lastnode *= 2
        let log = countTrailingZeroBits(lastnode)
        var arr = newSeq[ST.S](2 * lastnode)
        var zero: ST.S
        when compiles(default == zero):
            if default != zero:
                for i in 0..<arr.len:
                    arr[i] = default
        else:
            for i in 0..<arr.len:
                arr[i] = default
        let lazy = newSeq[ST.F](lastnode)
        let hasLazy = newSeq[bool](lastnode)
        result = ST(
            default: default,
            arr: arr,
            lazy: lazy,
            hasLazy: hasLazy,
            lastnode: lastnode,
            log: log,
            length: n
        )

    template initLazySegmentTree*[S, F](
        v_or_n: seq[S] or int,
        merge: untyped,
        default: S,
        mapping: untyped,
        composition: untyped,
        id: F
    ): untyped =
        LazySegmentTreeType[S, F](merge, mapping, composition)
            .initLazySegmentTreeImpl(v_or_n, default, id)

    template all_apply(self, p, f: untyped) =
        ## pの要素にfの値を作用させる。子がある場合はlazyを更新する。
        self.arr[p] = self.mappingOp(f, self.arr[p])
        if p < self.lastnode:
            if self.hasLazy[p]:
                self.lazy[p] = self.compositionOp(f, self.lazy[p])
            else:
                self.lazy[p] = f
                self.hasLazy[p] = true

    proc pushNode[ST: LazySegmentTree](self: ST, p: int) {.noinline.} =
        ## pの子に作用を伝播させる。
        if self.hasLazy[p]:
            let
                f = self.lazy[p]
                left = 2 * p
                right = left + 1
            self.arr[left] = self.mappingOp(f, self.arr[left])
            self.arr[right] = self.mappingOp(f, self.arr[right])
            if left < self.lastnode:
                if self.hasLazy[left]:
                    self.lazy[left] = self.compositionOp(f, self.lazy[left])
                else:
                    self.lazy[left] = f
                    self.hasLazy[left] = true
                if self.hasLazy[right]:
                    self.lazy[right] = self.compositionOp(f, self.lazy[right])
                else:
                    self.lazy[right] = f
                    self.hasLazy[right] = true
            self.hasLazy[p] = false

    template push(self, p: untyped) =
        self.pushNode(p)

    proc pushBoundaries[ST: LazySegmentTree](
        self: ST, q_left, q_right: int
    ) {.noinline.} =
        let
            leftZeros = countTrailingZeroBits(q_left)
            rightZeros = countTrailingZeroBits(q_right)
        for i in countdown(self.log, 1):
            var leftNode = 0
            if i > leftZeros:
                leftNode = q_left shr i
                self.pushNode(leftNode)
            if i > rightZeros:
                let rightNode = (q_right - 1) shr i
                if rightNode != leftNode:
                    self.pushNode(rightNode)

    proc pullBoundaries[ST: LazySegmentTree](
        self: ST, q_left, q_right: int
    ) {.noinline.} =
        let
            leftMin = countTrailingZeroBits(q_left) + 1
            rightMin = countTrailingZeroBits(q_right) + 1
            firstLevel = min(leftMin, rightMin)
        for i in firstLevel..self.log:
            var leftNode = 0
            if i >= leftMin:
                leftNode = q_left shr i
                self.arr[leftNode] = self.mergeOp(
                    self.arr[2 * leftNode], self.arr[2 * leftNode + 1]
                )
            if i >= rightMin:
                let rightNode = (q_right - 1) shr i
                if rightNode != leftNode:
                    self.arr[rightNode] = self.mergeOp(
                        self.arr[2 * rightNode], self.arr[2 * rightNode + 1]
                    )

    template all_push(self, p: untyped) =
        for i in countdown(self.log, 1):
            self.push(p shr i)

    proc update*[ST: LazySegmentTree](self: var ST, p: Natural, val: ST.S) =
        ## pの要素をvalに変更します。
        assert p < self.length
        let p = p + self.lastnode
        self.all_push(p)
        self.arr[p] = val
        for i in 1..self.log:
            let node = p shr i
            self.arr[node] = self.mergeOp(self.arr[2 * node], self.arr[2 * node + 1])

    proc `[]`*[ST: LazySegmentTree](self: var ST, p: Natural): ST.S =
        assert p < self.length
        self.all_push(p + self.lastnode)
        return self.arr[p + self.lastnode]

    proc get*[ST: LazySegmentTree](self: var ST, q_left, q_right: int): ST.S =
        ## 半開区間[q_left,q_right)についての演算結果を返します。
        assert q_left <= q_right and 0 <= q_left and q_right <= self.length
        if q_left == q_right:
            return self.default
        var q_left = q_left + self.lastnode
        var q_right = q_right + self.lastnode
        self.pushBoundaries(q_left, q_right)
        var
            lres = self.default
            rres = self.default
        while q_left < q_right:
            if (q_left and 1) > 0:
                lres = self.mergeOp(lres, self.arr[q_left])
                q_left.inc
            if (q_right and 1) > 0:
                q_right.dec
                rres = self.mergeOp(self.arr[q_right], rres)
            q_left = q_left shr 1
            q_right = q_right shr 1
        return self.mergeOp(lres, rres)

    proc get*[ST: LazySegmentTree](
        self: var ST, segment: HSlice[int, int]
    ): ST.S =
        return self.get(segment.a, segment.b + 1)

    proc `[]`*[ST: LazySegmentTree](
        self: var ST, segment: HSlice[int, int]
    ): ST.S =
        self.get(segment)

    proc `[]=`*[ST: LazySegmentTree](self: var ST, p: Natural, val: ST.S) =
        self.update(p, val)

    proc len*[ST: LazySegmentTree](self: var ST): int =
        return self.length

    proc `$`*[ST: LazySegmentTree](self: var ST): string =
        return (0..<self.len).toSeq.mapIt(self[it]).join(" ")

    template newLazySegWith*(
        v_or_n, merge, default, mapping, composition, id: untyped
    ): untyped =
        block:
            type S = typeof(default)
            type F = typeof(id)
            proc staticMerge(
                l {.inject.}, r {.inject.}: S
            ): S {.gensym, inline.} = merge
            proc staticMapping(
                f {.inject.}: F, x {.inject.}: S
            ): S {.gensym, inline.} = mapping
            proc staticComposition(
                f {.inject.}, g {.inject.}: F
            ): F {.gensym, inline.} = composition
            LazySegmentTree[S, F, (staticMerge, staticMapping, staticComposition)]
                .initLazySegmentTreeImpl(v_or_n, default, id)

    proc apply*[ST: LazySegmentTree](
        self: var ST, q_left, q_right: int, f: ST.F
    ) =
        ## 半開区間[q_left,q_right)にfを作用させます。
        assert q_left <= q_right and 0 <= q_left and q_right <= self.length
        if q_left == q_right:
            return
        var q_left = q_left + self.lastnode
        var q_right = q_right + self.lastnode
        self.pushBoundaries(q_left, q_right)
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
        self.pullBoundaries(q_left, q_right)

    proc apply*[ST: LazySegmentTree](
        self: var ST, segment: HSlice[int, int], f: ST.F
    ) =
        self.apply(segment.a, segment.b + 1, f)

    {.pop.}
