when not declared CPLIB_COLLECTIONS_SEGTREE:
    const CPLIB_COLLECTIONS_SEGTREE* = 1
    import algorithm, strutils
    type SegmentTree*[T] = ref object
        default: T
        merge: proc(x: T, y: T): T
        arr*: seq[T]
        lastnode: int
        length: int
    proc initSegmentTree*[T](v: seq[T], merge: proc(x: T, y: T): T, default: T): SegmentTree[T] =
        ## セグメントツリーを生成します。
        ## vに元となるリスト、mergeに二つの区間をマージする関数、デフォルトに単位元を与えてください。
        var lastnode = 1
        while lastnode < len(v):
            lastnode*=2
        var arr = newSeq[T](2*lastnode)
        arr.fill(default)
        var self = SegmentTree[T](default: default, merge: merge, arr: arr, lastnode: lastnode, length: len(v))
        #1-indexedで作成する
        for i in 0..<len(v):
            self.arr[self.lastnode+i] = v[i]
        for i in countdown(lastnode-1, 1):
            self.arr[i] = self.merge(self.arr[2*i], self.arr[2*i+1])
        return self

    proc update*[T](self: SegmentTree[T], x: Natural, val: T) =
        ## xの要素をvalに変更します。
        assert x < self.length
        var x = x
        x += self.lastnode
        self.arr[x] = val
        while x > 1:
            x = x shr 1
            self.arr[x] = self.merge(self.arr[2*x], self.arr[2*x+1])
    proc get*[T](self: SegmentTree[T], q_left: Natural, q_right: Natural): T =
        ## 半解区間[q_left,q_right)についての演算結果を返します。
        assert q_left <= q_right and 0 <= q_left and q_right <= self.length
        var q_left = q_left
        var q_right = q_right
        q_left += self.lastnode
        q_right += self.lastnode
        var (lres, rres) = (self.default, self.default)
        while q_left < q_right:
            if (q_left and 1) > 0:
                lres = self.merge(lres, self.arr[q_left])
                q_left += 1
            if (q_right and 1) > 0:
                q_right -= 1
                rres = self.merge(self.arr[q_right], rres)
            q_left = q_left shr 1
            q_right = q_right shr 1
        return self.merge(lres, rres)
    proc get*[T](self: SegmentTree[T], segment: HSlice[int, int]): T =
        assert segment.a <= segment.b + 1 and 0 <= segment.a and segment.b+1 <= self.length
        return self.get(segment.a, segment.b+1)
    proc `[]`*[T](self: SegmentTree[T], segment: HSlice[int, int]): T = self.get(segment)
    proc `[]`*[T](self: SegmentTree[T], index: Natural): T =
        assert index < self.length
        return self.arr[index+self.lastnode]
    proc `[]=`*[T](self: SegmentTree[T], index: Natural, val: T) =
        assert index < self.length
        self.update(index, val)
    proc get_all*[T](self: SegmentTree[T]): T =
        ## [0,len(self))区間の演算結果をO(1)で返す
        return self.arr[1]
    proc len*[T](self: SegmentTree[T]): int =
        return self.length
    proc `$`*[T](self: SegmentTree[T]): string =
        var s = self.arr.len div 2
        return self.arr[s..<s+self.len].join(" ")
    template newSegWith*(V, merge, default: untyped): untyped =
        initSegmentTree(V, proc (l{.inject.}, r{.inject.}: typeof(default)): typeof(default) = merge, default)
    proc max_right*[T](self: SegmentTree[T], l: int, f: proc(l: T): bool): int =
        assert 0 <= l and l <= self.len
        assert f(self.default)
        if l == self.len: return self.len
        var l = l
        l += self.lastnode
        var sm = self.default
        while true:
            while l mod 2 == 0: l = (l shr 1)
            if not f(self.merge(sm, self.arr[l])):
                while l < self.lastnode:
                    l *= 2
                    if f(self.merge(sm, self.arr[l])):
                        sm = self.merge(sm, self.arr[l])
                        l += 1
                return l - self.lastnode
            sm = self.merge(sm, self.arr[l])
            l += 1
            if (l and -l) == l: break
        return self.len
    proc min_left*[T](self: SegmentTree[T], r: int, f: proc(l: T): bool): int =
        assert 0 <= r and r <= self.len
        assert f(self.default)
        if r == 0: return 0
        var r = r
        r += self.lastnode
        var sm = self.default
        while true:
            r -= 1
            while (r > 1 and r mod 2 != 0): r = (r shr 1)
            if not f(self.merge(self.arr[r], sm)):
                while r < self.lastnode:
                    r = 2 * r + 1
                    if f(self.merge(self.arr[r], sm)):
                        sm = self.merge(self.arr[r], sm)
                        r -= 1
                return r + 1 - self.lastnode
            if (r and -r) == r: break
        return 0
