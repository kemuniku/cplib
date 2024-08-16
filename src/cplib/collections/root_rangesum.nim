when not declared CPLIB_COLLECTIONS_ROOTRANGESUM:
    const CPLIB_COLLECTIONS_ROOTRANGESUM* = 1
    import algorithm, strutils,sequtils
    type RootRangeSum*[T] = ref object
        blocksize : int
        length : int
        arr : seq[T]
        blockvalue : seq[T]
        e : T
    proc initrangesum*[T](v:seq[T],bsize:int = v.len.float.sqrt.int(),e:T=0):RootRangeSum[T]=
        var b = newseqwith((len(v)+bsize-1) div bsize,e)
        result = RootRangeSum[T](blocksize:bsize,length:len(v),arr:v,blockvalue:b,e:e)
        for i in 0..<(len(v)):
            result.blockvalue[i div bsize] = result.blockvalue[i div bsize] + v[i]

    proc update*[T](self: RootRangeSum[T], idx: Natural, val: T) =
        ## idxの要素をvalに変更します。
        assert idx < self.length
        self.blockvalue[idx div self.blocksize] = self.blockvalue[idx div self.blocksize] + val - self.arr[idx]
        self.arr[idx] = val
    proc get*[T](self: RootRangeSum[T], q_left: Natural, q_right: Natural): T =
        ## 半解区間[q_left,q_right)についての演算結果を返します。
        result = self.e
        let bidx_left = (q_left div self.blocksize)
        let bidx_right = (q_right div self.blocksize)
        assert q_left <= q_right and 0 <= q_left and q_right <= self.length
        if  bidx_left == bidx_right:
            for i in q_left..<q_right:
                result = result + self.arr[i]
            return result

        for i in q_left..<(bidx_left+1)*self.blocksize:
            result = result + self.arr[i]
        for bidx in (bidx_left+1)..<(bidx_right):
            result = result + self.blockvalue[bidx]
        for i in (bidx_right*self.blocksize)..<q_right:
            result = result + self.arr[i]
    proc get*[T](self: RootRangeSum[T], segment: HSlice[int, int]): T =
        assert segment.a <= segment.b + 1 and 0 <= segment.a and segment.b+1 <= self.length
        return self.get(segment.a, segment.b+1)
    proc `[]`*[T](self: RootRangeSum[T], segment: HSlice[int, int]): T = self.get(segment)
    proc `[]`*[T](self: RootRangeSum[T], index: Natural): T =
        assert index < self.length
        return self.arr[index]
    proc `[]=`*[T](self: RootRangeSum[T], index: Natural, val: T) =
        assert index < self.length
        self.update(index, val)
    proc len*[T](self: RootRangeSum[T]): int =
        return self.length
    proc `$`*[T](self: RootRangeSum[T]): string =
        var s = self.arr.len div 2
        return $self.arr
    proc max_right*[T](self: RootRangeSum[T], l: int, f: proc(l: T): bool): int =
        assert 0 <= l and l <= self.len
        assert f(self.e)
        if l == self.len: return self.len
        var sm = self.e
        let bidx_left = (l div self.blocksize)
        for i in l..<(bidx_left+1)*self.blocksize:
            if not f(sm + self.arr[i]):
                return i
            else:
                sm = sm + self.arr[i]
        for bi in (bidx_left+1)..<len(self.blockvalue):
            if not f(sm + self.blockvalue[bi]):
                for i in bi*self.blocksize..<(bi+1)*self.blocksize:
                    if i notin 0..<len(self.arr):
                        return i
                    if not f(sm + self.arr[i]):
                        return i
                    else:
                        sm = sm + self.arr[i]
            else:
                sm = sm + self.blockvalue[bi]
        return len(self.arr)
    proc min_left*[T](self: RootRangeSum[T], r: int, f: proc(l: T): bool): int =
        assert 0 <= r and r <= self.len
        assert f(self.default)
        if r == 0: return 0
        var sm = self.e
        let bidx_right = (r div self.blocksize)
        for i in countdown(r,(bidx_right)*self.blocksize):
            if not f(sm + self.arr[i]):
                return i+1
            else:
                sm = sm + self.arr[i]
        for bi in countdown((bidx_right-1),0):
            if not f(sm + self.blockvalue[bi]):
                for i in countdown((bi)*self.blocksize+1,bi*self.blocksize):
                    if i notin 0..<len(self.arr):
                        return i+1
                    if not f(sm + self.arr[i]):
                        return i+1
                    else:
                        sm = sm + self.arr[i]
            else:
                sm = sm + self.blockvalue[bi]
        return 0