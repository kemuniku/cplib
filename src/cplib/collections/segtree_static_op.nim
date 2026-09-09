when not declared CPLIB_COLLECTIONS_SEGTREE_STATIC_OP:
    const CPLIB_COLLECTIONS_SEGTREE_STATIC_OP* = 1
    import algorithm, strutils

    type SegmentTree*[T; p: static[tuple]] = ref object
        default: T
        arr*: seq[T]
        lastnode: int
        length: int

    template mergeOp[ST: SegmentTree](self: ST or typedesc[ST], x, y: ST.T): auto =
        block:
            let value = ST.p.op(x, y)
            value

    template SegmentTreeType[T](op0: untyped): typedesc[SegmentTree] =
        proc staticMerge(x, y: T): T {.gensym, inline.} = op0(x, y)
        SegmentTree[T, (op: staticMerge)]

    proc initSegmentTreeImpl[ST: SegmentTree](
        self: typedesc[ST], v: openArray[ST.T], default: ST.T
    ): ST =
        ## 静的なマージ関数を持つセグメントツリーを生成します。
        var lastnode = 1
        while lastnode < len(v):
            lastnode *= 2
        var arr = newSeq[ST.T](2 * lastnode)
        arr.fill(default)
        result = ST(
            default: default,
            arr: arr,
            lastnode: lastnode,
            length: len(v)
        )
        # 1-indexedで作成する
        for i in 0..<len(v):
            result.arr[result.lastnode + i] = v[i]
        for i in countdown(lastnode - 1, 1):
            result.arr[i] = result.mergeOp(result.arr[2 * i], result.arr[2 * i + 1])

    proc initSegmentTreeImpl[ST: SegmentTree](
        self: typedesc[ST], n: int, default: ST.T
    ): ST =
        ## 全要素を単位元で初期化した、静的なマージ関数を持つセグメントツリーを生成します。
        var lastnode = 1
        while lastnode < n:
            lastnode *= 2
        var arr = newSeq[ST.T](2 * lastnode)
        arr.fill(default)
        result = ST(
            default: default,
            arr: arr,
            lastnode: lastnode,
            length: n
        )
        for i in countdown(lastnode - 1, 1):
            result.arr[i] = result.mergeOp(result.arr[2 * i], result.arr[2 * i + 1])

    template initSegmentTree*[T](
        v: openArray[T], merge: untyped, default: T
    ): untyped =
        SegmentTreeType[T](merge).initSegmentTreeImpl(v, default)

    template initSegmentTree*[T](n: int, merge: untyped, default: T): untyped =
        SegmentTreeType[T](merge).initSegmentTreeImpl(n, default)

    proc update*[ST: SegmentTree](self: ST, x: Natural, val: ST.T) =
        ## xの要素をvalに変更します。
        assert x < self.length
        var x = x
        x += self.lastnode
        self.arr[x] = val
        while x > 1:
            x = x shr 1
            self.arr[x] = self.mergeOp(self.arr[2 * x], self.arr[2 * x + 1])

    proc get*[ST: SegmentTree](self: ST, q_left: Natural, q_right: Natural): ST.T =
        ## 半開区間[q_left,q_right)についての演算結果を返します。
        assert q_left <= q_right and q_right <= self.length
        var q_left = q_left
        var q_right = q_right
        q_left += self.lastnode
        q_right += self.lastnode
        var (lres, rres) = (self.default, self.default)
        while q_left < q_right:
            if (q_left and 1) > 0:
                lres = self.mergeOp(lres, self.arr[q_left])
                q_left += 1
            if (q_right and 1) > 0:
                q_right -= 1
                rres = self.mergeOp(self.arr[q_right], rres)
            q_left = q_left shr 1
            q_right = q_right shr 1
        return self.mergeOp(lres, rres)

    proc get*[ST: SegmentTree](self: ST, segment: HSlice[int, int]): ST.T =
        assert segment.a <= segment.b + 1 and
            0 <= segment.a and segment.b + 1 <= self.length
        return self.get(segment.a, segment.b + 1)

    proc `[]`*[ST: SegmentTree](self: ST, segment: HSlice[int, int]): ST.T =
        self.get(segment)

    proc `[]`*[ST: SegmentTree](self: ST, index: Natural): ST.T =
        assert index < self.length
        return self.arr[index + self.lastnode]

    proc `[]=`*[ST: SegmentTree](self: ST, index: Natural, val: ST.T) =
        assert index < self.length
        self.update(index, val)

    proc get_all*[ST: SegmentTree](self: ST): ST.T =
        ## [0,len(self))区間の演算結果をO(1)で返す
        return self.arr[1]

    proc len*[ST: SegmentTree](self: ST): int =
        return self.length

    proc `$`*[ST: SegmentTree](self: ST): string =
        let s = self.arr.len div 2
        return self.arr[s..<s + self.len].join(" ")

    template newSegWith*(V, merge, default: untyped): untyped =
        block:
            type T = typeof(default)
            proc staticMerge(
                l {.inject.}, r {.inject.}: T
            ): T {.gensym, inline.} = merge
            SegmentTree[T, (op: staticMerge)].initSegmentTreeImpl(V, default)

    proc max_right*[ST: SegmentTree](
        self: ST, l: int, f: proc(value: ST.T): bool
    ): int =
        assert 0 <= l and l <= self.len
        assert f(self.default)
        if l == self.len:
            return self.len
        var l = l + self.lastnode
        var sm = self.default
        while true:
            while l mod 2 == 0:
                l = l shr 1
            if not f(self.mergeOp(sm, self.arr[l])):
                while l < self.lastnode:
                    l *= 2
                    if f(self.mergeOp(sm, self.arr[l])):
                        sm = self.mergeOp(sm, self.arr[l])
                        l += 1
                return l - self.lastnode
            sm = self.mergeOp(sm, self.arr[l])
            l += 1
            if (l and -l) == l:
                break
        return self.len

    proc min_left*[ST: SegmentTree](
        self: ST, r: int, f: proc(value: ST.T): bool
    ): int =
        assert 0 <= r and r <= self.len
        assert f(self.default)
        if r == 0:
            return 0
        var r = r + self.lastnode
        var sm = self.default
        while true:
            r -= 1
            while r > 1 and r mod 2 != 0:
                r = r shr 1
            if not f(self.mergeOp(self.arr[r], sm)):
                while r < self.lastnode:
                    r = 2 * r + 1
                    if f(self.mergeOp(self.arr[r], sm)):
                        sm = self.mergeOp(self.arr[r], sm)
                        r -= 1
                return r + 1 - self.lastnode
            sm = self.mergeOp(self.arr[r], sm)
            if (r and -r) == r:
                break
        return 0
