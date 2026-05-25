when not declared CPLIB_COLLECTIONS_WAVELETMATRIX:
    const CPLIB_COLLECTIONS_WAVELETMATRIX* = 1
    import cplib/collections/bitvector
    import sequtils
    import bitops

    type WaveletMatrix* = ref object
        dat : seq[BitVector]
        H : int
        N : int
    
    proc initWaveletMatrix*(v:seq[int],H:int = -1):WaveletMatrix=
        var v = v
        var N = len(v)
        var H = H
        if H == -1:
            if N == 0:
                H = 0
            elif max(v) == 0:
                H = 1
            else:
                H = fastLog2(max(v))+1
        result = WaveletMatrix(dat:newSeqWith(H,newBitVector(N)),N:N,H:H)
        var zero = newSeqWith(N,-1)
        var one = newSeqWith(N,-1)
        var a = 0
        var b = 0
        for h in countdown(H-1,0,1):
            for i in 0..<N:
                if v[i].testBit(h):
                    one[b] = v[i]
                    b += 1
                    result.dat[h].set(i)
                else:
                    zero[a] = v[i]
                    a += 1
            for i in 0..<a:
                v[i] = zero[i]
            for i in 0..<b:
                v[a+i] = one[i]
            a = 0
            b = 0
            result.dat[h].build()
    
    proc get_child*(self:WaveletMatrix,h,l,r:int):tuple[l0,r0,l1,r1:int]=
        # 高さh+1における[l,r)に該当する部分を見ているとする。
        # その子に該当する部分を[l0,r0),[l1,r1)としたとき、(l0,r0,l1,r1)を返す。
        var c0  = self.N - self.dat[h].rank(self.N)
        result.l0 = l - self.dat[h].rank(l)
        result.r0 = r - self.dat[h].rank(r)
        result.l1 = self.dat[h].rank(l) + c0
        result.r1 = self.dat[h].rank(r) + c0

    
    proc kth_smallest*(self:WaveletMatrix,l,r,k:int):int=
        # [l,r) 内で、k番目に小さいものを出力
        var k = k
        var l = l
        var r = r
        for h in countdown(self.H-1,0,1):
            var (l0,r0,l1,r1) = self.get_child(h,l,r)
            if k < r0-l0:
                l = l0
                r = r0
            else:
                l = l1
                r = r1
                k -= r0-l0
                result += 1 shl h
    
    proc range_lowerbound*(self:WaveletMatrix,l,r,x:int):int=
        var x = x
        var l = l
        var r = r
        var now = 0
        for h in countdown(self.H-1,0,1):
            var (l0,r0,l1,r1) = self.get_child(h,l,r)
            if (now + 1 shl h) > x:
                l = l0
                r = r0
            else:
                l = l1
                r = r1
                now += 1 shl h
                result += r0-l0
    
    proc range_upperbound*(self:WaveletMatrix,l,r,x:int):int=
        var x = x
        var l = l
        var r = r
        var now = 0
        for h in countdown(self.H-1,0,1):
            var (l0,r0,l1,r1) = self.get_child(h,l,r)
            if (now + 1 shl h) > x:
                l = l0
                r = r0
            else:
                l = l1
                r = r1
                now += 1 shl h
                result += r0-l0
        result += r-l
