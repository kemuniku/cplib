when not declared CPLIB_COLLECTIONS_SEGTREE_VAR:
    const CPLIB_COLLECTIONS_SEGTREE_VAR* = 1
    import algorithm, strutils, sequtils, macros
    type SegmentTree*[T, Elem] = object
        default: T
        merge: proc(x: T, y: T): T
        arr*: seq[Elem]
        lastnode: int
        length: int
    type SegmentTreeElem[T] = object
        st: ptr SegmentTree[T, SegmentTreeElem[T]]
        v: T
        index: int
    proc initSegmentTreeElem[T](st: ptr SegmentTree[T, SegmentTreeElem[T]], v: T, index: int): SegmentTreeElem[T] = SegmentTreeElem[T](st: st, v: v, index: index)
    converter convertTo*[T](self: SegmentTreeElem[T]): T = self.v
    proc `$`*[T](self: SegmentTreeElem[T]): string = $(self.v)
    proc get*[T](self: var SegmentTree[T, SegmentTreeElem[T]], q_left: Natural, q_right: Natural): T =
        ## 半解区間[q_left,q_right)についての演算結果を返します。
        assert q_left <= q_right and 0 <= q_left and q_right <= self.length
        var q_left = q_left
        var q_right = q_right
        q_left += self.lastnode
        q_right += self.lastnode
        var (lres, rres) = (self.default, self.default)
        while q_left < q_right:
            if (q_left and 1) > 0:
                lres = self.merge(lres, self.arr[q_left].v)
                q_left += 1
            if (q_right and 1) > 0:
                q_right -= 1
                rres = self.merge(self.arr[q_right].v, rres)
            q_left = q_left shr 1
            q_right = q_right shr 1
        return self.merge(lres, rres)
    proc get*[T](self: var SegmentTree[T, SegmentTreeElem[T]], segment: HSlice[int, int]): T =
        assert segment.a <= segment.b + 1 and 0 <= segment.a and segment.b+1 <= self.length
        return self.get(segment.a, segment.b+1)
    proc `[]`*[T](self: var SegmentTree[T, SegmentTreeElem[T]], segment: HSlice[int, int]): T = self.get(segment)
    proc `[]`*[T](self: var SegmentTree[T, SegmentTreeElem[T]], index: Natural): var SegmentTreeElem[T] =
        assert index < self.length
        return self.arr[index+self.lastnode]
    proc propagete_update[T](self: var SegmentTree[T, SegmentTreeElem[T]], x: Natural) =
        var x = x
        while x > 1:
            x = x shr 1
            self.arr[x].v = self.merge(self.arr[2*x].v, self.arr[2*x+1].v)
    proc update*[T](self: var SegmentTree[T, SegmentTreeElem[T]], index: Natural, val: T) =
        ## xの要素をvalに変更します。
        assert index < self.length
        self.arr[self.lastnode+index].v = val
        self.propagete_update(index + self.lastnode)
    proc `[]=`*[T](self: var SegmentTree[T, SegmentTreeElem[T]], index: Natural, val: T) = self.update(index, val)
    proc get_all*[T](self: SegmentTree[T, SegmentTreeElem[T]]): T =
        ## [0,len(self))区間の演算結果をO(1)で返す
        return self.arr[1].v
    proc len*[T](self: SegmentTree[T, SegmentTreeElem[T]]): int =
        return self.length
    proc `$`*[T](self: SegmentTree[T, SegmentTreeElem[T]]): string =
        var s = self.arr.len div 2
        return self.arr[s..<s+self.len].mapIt(it.v).join(" ")
    macro declareOperation(op) =
        quote do:
            proc `op`*[T](self: var SegmentTreeElem[T], v: T) =
                `op`(self.v, v)
                self.st[].propagete_update(self.index)
    declareOperation(`+=`)
    declareOperation(`-=`)
    declareOperation(`*=`)
    declareOperation(`/=`)
    declareOperation(`^=`)
    declareOperation(`&=`)
    declareOperation(`|=`)
    declareOperation(`%=`)
    declareOperation(`//=`)
    declareOperation(`>>=`)
    declareOperation(`<<=`)
    declareOperation(`**=`)
    proc initSegmentTree*[T](v: seq[T], merge: proc(x, y: T): T, default: T): SegmentTree[T, SegmentTreeElem[T]] =
        ## セグメントツリーを生成します。
        ## vに元となるリスト、mergeに二つの区間をマージする関数、デフォルトに単位元を与えてください。
        var lastnode = 1
        while lastnode < len(v):
            lastnode*=2
        var arr = newSeq[SegmentTreeElem[T]](2*lastnode)
        result = SegmentTree[T, SegmentTreeElem[T]](default: default, merge: merge, arr: arr, lastnode: lastnode, length: len(v))
        #1-indexedで作成する
        for i in 0..<len(v):
            result.arr[lastnode+i] = initSegmentTreeElem(result.addr, v[i], lastnode+i)
        for i in len(v)..<lastnode:
            result.arr[lastnode+i] = initSegmentTreeElem(result.addr, default, lastnode+i)
        for i in countdown(lastnode-1, 1):
            result.arr[i] = initSegmentTreeElem(result.addr, merge(result.arr[2*i].v, result.arr[2*i+1].v), i)
    proc initSegmentTree*[T](n: int, merge: proc(x, y: T): T, default: T): SegmentTree[T, SegmentTreeElem[T]] = initSegmentTree(newSeqWith(n, default), merge, default)
    template newSegWith*(V, merge, default: untyped): untyped =
        initSegmentTree(V, proc (l{.inject.}, r{.inject.}: typeof(default)): typeof(default) = merge, default)
    proc max_right*[T](self: SegmentTree[T, SegmentTreeElem[T]], l: int, f: proc(l: T): bool): int =
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
    proc min_left*[T](self: SegmentTree[T, SegmentTreeElem[T]], r: int, f: proc(l: T): bool): int =
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
