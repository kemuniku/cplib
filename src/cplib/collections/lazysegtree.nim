when not declared CPLIB_COLLECTIONS_SEGTREE:
    const CPLIB_COLLECTIONS_SEGTREE* = 1
    import algorithm,sequtils,bitops
    type LazySegmentTree[S,F] = ref object
        e: S
        merge: proc(x: S, y: S): S
        arr*: seq[S]
        lazy:seq[F]
        mapping: proc(f:F,x:S): S
        composition: proc(f,g:F):F
        id:F
        lastnode: int
        length: int
    proc initLazySegmentTree*[S,F](v:seq[S],merge:proc(x: S, y: S): S,e:S,mapping:proc(f:F,x:S): S,composition: proc(f,g:F):F,id:F):LazySegmentTree[S,F]=
        var lastnode = 1
        while lastnode < len(v):
            lastnode*=2
        var arr = newSeqWith(2*lastnode,e)
        var lazy = newseqwith(2*lastnode,id)
        var self = LazySegmentTree[S,F](e:e, merge: merge, arr: arr,lazy: lazy,mapping:mapping,composition:composition,id:id, lastnode: lastnode, length: len(v))
        #1-indexedで作成する
        for i in 0..<len(v):
            self.arr[self.lastnode+i] = v[i]
        for i in countdown(lastnode-1, 1):
            self.arr[i] = self.merge(self.arr[2*i], self.arr[2*i+1])
        return self
    proc propagate*[S,F](self:LazySegmentTree[S,F],i:int)=
        var v = self.lazy[i]
        if v != self.id:
            self.lazy[i] = self.id
            if i < self.lastnode:
                self.lazy[2*i] = self.composition(v,self.lazy[2*i])
                self.lazy[2*i+1] = self.composition(v,self.lazy[2*i+1])
                self.arr[2*i] = self.mapping(v,self.arr[2*i])
                self.arr[2*i+1] = self.mapping(v,self.arr[2*i+1])
    proc eval*[S,F](self:LazySegmentTree[S,F],L,R:int)=
        var L = L
        var R = R
        L+=self.lastnode
        R+=self.lastnode
        var
            L0 = L div (L and -L)  # 奇数になるまで L を 2 で割ったもの
            R0 = R div (R and -R)  # 奇数になるまで R を 2 で割ったもの
            HL = L0.fastLog2
            HR = R0.fastLog2
        for n in countdown(HL,0,1):
            self.propagate(L0 shr n)
        
        for n in countdown(HR,0,1):
            self.propagate(R0 shr n)
        
    proc recalc*[S,F](self:LazySegmentTree[S,F],L,R:int)=
        var L = L
        var R = R
        L+=self.lastnode
        R+=self.lastnode
        var
            L0 = L div (L and -L)  # 奇数になるまで L を 2 で割ったもの
            R0 = R div (R and -R)  # 奇数になるまで R を 2 で割ったもの
        while L0 > 1:
            L0 = L0 shr 1
            self.arr[L0] = self.merge(self.arr[2*L0],self.arr[2*L0+1])
        while R0 > 1:
            R0 = R0 shr 1
            self.arr[R0] = self.merge(self.arr[2*R0],self.arr[2*R0+1])
    proc apply*[S,F](self:LazySegmentTree[S,F],q_left , q_right:int,f:F)=
        self.eval(q_left , q_right)
        var
            L = q_left
            R = q_right
            q_left = q_left
            q_right = q_right
        q_left += self.lastnode
        q_right += self.lastnode
        while q_left < q_right:
            if (q_left and 1) != 0:
                self.arr[q_left] = self.mapping(f,self.arr[q_left])
                self.lazy[q_left] = self.composition(f,self.lazy[q_left])
                q_left += 1
            if (q_right and 1) != 0:
                q_right -= 1
                self.arr[q_right] = self.mapping(f,self.arr[q_right])
                self.lazy[q_right] = self.composition(f,self.lazy[q_right])
            q_left = q_left shr 1
            q_right = q_right shr 1
        self.recalc(L,R)
    proc query*[S,F](self:LazySegmentTree[S,F],q_left,q_right:int):S=
        self.eval(q_left , q_right)
        var q_left = q_left
        var q_right = q_right
        q_left += self.lastnode
        q_right += self.lastnode
        var
            lres,rres = self.e
        while q_left < q_right:
            if (q_left and 1) != 0:
                lres = self.merge(lres,self.arr[q_left])
                q_left += 1
            if (q_right and 1) != 0:
                q_right -= 1
                rres = self.merge(self.arr[q_right],rres)
            q_left = q_left shr 1
            q_right = q_right shr 1
        return self.merge(lres,rres)
 