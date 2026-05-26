when not declared CPLIB_COLLECTIONS_SEGTREE2D:
    const CPLIB_COLLECTIONS_SEGTREE2D* = 1
    import cplib/collections/segtree

    type SegmentTree2D*[T] = ref object
        default: T
        merge: proc(x: T, y: T): T
        arr*: seq[SegmentTree[T]]
        lastnode: int
        H: int
        W: int

    proc initSegmentTree2D*[T](v: seq[seq[T]], merge: proc(x: T, y: T): T, default: T): SegmentTree2D[T] =
        var H = len(v)
        var W = 0
        if H != 0:
            W = len(v[0])
        var lastnode = 1
        while lastnode < len(v):
            lastnode*=2
        var arr = newSeq[SegmentTree[T]](2*lastnode)
        for i in 0..<len(v):
            arr[i+lastnode] = initSegmentTree(v[i],merge,default)
        for i in len(v)..<lastnode:
            arr[i+lastnode] = initSegmentTree(W,merge,default)
        
        for i in countdown(lastnode-1, 1):
            var tmp = newseq[T](W)
            for j in 0..<W:
                tmp[j] = merge(arr[2*i][j],arr[2*i+1][j])
            arr[i] = initSegmentTree(tmp,merge,default)
        var self = SegmentTree2D[T](default: default, merge: merge, arr: arr, lastnode: lastnode, H:H,W:W)
        return self

    proc get*[T](self: SegmentTree2D[T], il: Natural, ir: Natural,jl: Natural, jr: Natural): T =
        ## 長方形領域 i∈[il,ir), j∈[jl,jr) についての演算結果を返します。
        assert il <= ir and 0 <= il and ir <= self.H
        assert jl <= jr and 0 <= jl and jr <= self.W
        var il = il
        var ir = ir
        il += self.lastnode
        ir += self.lastnode
        var (lres, rres) = (self.default, self.default)
        while il < ir:
            if (il and 1) > 0:
                lres = self.merge(lres, self.arr[il].get(jl,jr))
                il += 1
            if (ir and 1) > 0:
                ir -= 1
                rres = self.merge(self.arr[ir].get(jl,jr), rres)
            il = il shr 1
            ir = ir shr 1
        return self.merge(lres, rres)

    proc update*[T](self: SegmentTree2D[T], i,j: Natural, val: T) =
        ## (i, j)の要素をvalに変更します。
        assert i < self.H
        assert j < self.W
        var i = i
        i += self.lastnode
        self.arr[i][j] = val
        while i > 1:
            i = i shr 1
            self.arr[i][j] = self.merge(self.arr[2*i][j], self.arr[2*i+1][j])