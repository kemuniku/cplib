when not declared CPLIB_COLLECTIONS_SEGTREE:
    const CPLIB_COLLECTIONS_SEGTREE* = 1
    import algorithm
    type SegmentTree[T] = ref object
        default: T
        merge: proc(x: T, y: T): T
        arr: seq[T]
        lastnode: int
    proc initSegmentTree*[T](v: seq[T], merge: proc(x: T, y: T): T, default: T): SegmentTree[T] =
        ## セグメントツリーを生成します。
        ## vに元となるリスト、mergeに二つの区間をマージする関数、デフォルトに単位元を与えてください。
        var lastnode = 1
        while lastnode < len(v):
            lastnode*=2
        var arr = newSeq[T](2*lastnode)
        arr.fill(default)
        var self = SegmentTree[T](default: default, merge: merge, arr: arr, lastnode: lastnode)
        #1-indexedで作成する
        for i in 0..<len(v):
            self.arr[self.lastnode+i] = v[i]
        for i in countdown(lastnode-1, 1):
            self.arr[i] = self.merge(self.arr[2*i], self.arr[2*i+1])
        return self

    proc update*[T](self: SegmentTree[T], x: Natural, val: T) =
        ## xの要素をvalに変更します。
        var x = x
        x += self.lastnode
        self.arr[x] = val
        while x > 0:
            x = x shr 1
            self.arr[x] = self.merge(self.arr[2*x], self.arr[2*x+1])
    proc get*[T](self: SegmentTree[T], q_left: Natural, q_right: Natural): T =
        ## 半解区間[q_left,q_right)についての演算結果を返します。
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

    proc `[]`*[T](self: SegmentTree[T], index: Natural): T = self.arr[index+self.lastnode]
