when not declared CPLIB_COLLECTIONS_WAVELETMATRIX:
    const CPLIB_COLLECTIONS_WAVELETMATRIX* = 1
    import cplib/collections/bitvector
    import sequtils
    import bitops
    import options

    type WaveletMatrix* = ref object
        dat : seq[BitVector]
        H : int
        N : int
        with_sum : bool
        zero_sum : seq[seq[int]]
    
    proc initWaveletMatrix*(v:openArray[int],H:int = -1,with_sum:bool = false):WaveletMatrix=
        ## 非負整数列から O(NH) 時間で構築する。H は全要素を表現できるビット数で、-1 なら自動設定する。
        ## with_sum=true なら総和取得用に O(NH) 個の int を追加する。総和は int に収まる必要がある。
        var v = @v
        var N = len(v)
        var H = H
        if H == -1:
            if N == 0:
                H = 0
            elif max(v) == 0:
                H = 1
            else:
                H = fastLog2(max(v))+1
        result = WaveletMatrix(dat:newSeqWith(H,newBitVector(N)),N:N,H:H,with_sum:with_sum)
        if with_sum:
            result.zero_sum = newSeqWith(H,newSeq[int](N+1))
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
                if with_sum:
                    result.zero_sum[h][i+1] = result.zero_sum[h][i]
                    if not v[i].testBit(h):
                        result.zero_sum[h][i+1] += v[i]
            for i in 0..<a:
                v[i] = zero[i]
            for i in 0..<b:
                v[a+i] = one[i]
            a = 0
            b = 0
            result.dat[h].build()
    
    proc get_child*(self:WaveletMatrix,h,l,r:int):tuple[l0,r0,l1,r1:int]=
        ## 高さ h+1 の区間 [l,r) に対応する子の区間を O(1) で返す。
        # 高さh+1における[l,r)に該当する部分を見ているとする。
        # その子に該当する部分を[l0,r0),[l1,r1)としたとき、(l0,r0,l1,r1)を返す。
        var c0  = self.N - self.dat[h].rank(self.N)
        result.l0 = l - self.dat[h].rank(l)
        result.r0 = r - self.dat[h].rank(r)
        result.l1 = self.dat[h].rank(l) + c0
        result.r1 = self.dat[h].rank(r) + c0

    
    proc kth_smallest*(self:WaveletMatrix,l,r,k:int):int=
        ## [l,r) 内で小さい順に k 番目の値を O(H) で返す。k は 0-indexed。
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
        ## [l,r) 内の x 未満の要素数を O(H) で返す。
        if x <= 0:
            return 0
        if self.H < sizeof(int) * 8 and (x shr self.H) != 0:
            return r-l
        var l = l
        var r = r
        for h in countdown(self.H-1,0,1):
            var (l0,r0,l1,r1) = self.get_child(h,l,r)
            if x.testBit(h):
                l = l1
                r = r1
                result += r0-l0
            else:
                l = l0
                r = r0
    
    proc range_upperbound*(self:WaveletMatrix,l,r,x:int):int=
        ## [l,r) 内の x 以下の要素数を O(H) で返す。
        if x < 0:
            return 0
        if self.H < sizeof(int) * 8 and (x shr self.H) != 0:
            return r-l
        var l = l
        var r = r
        for h in countdown(self.H-1,0,1):
            var (l0,r0,l1,r1) = self.get_child(h,l,r)
            if x.testBit(h):
                l = l1
                r = r1
                result += r0-l0
            else:
                l = l0
                r = r0
        result += r-l

    proc prev_value*(self:WaveletMatrix,l,r,x:int):Option[int]=
        ## [l,r) 内の x 未満の最大値を O(H) で返す。存在しなければ none(int)。
        let c = self.range_lowerbound(l,r,x)
        if c == 0:
            return none(int)
        return some(self.kth_smallest(l,r,c-1))

    proc next_value*(self:WaveletMatrix,l,r,x:int):Option[int]=
        ## [l,r) 内の x 以上の最小値を O(H) で返す。存在しなければ none(int)。
        let c = self.range_lowerbound(l,r,x)
        if c == r-l:
            return none(int)
        return some(self.kth_smallest(l,r,c))

    proc range_freq*(self:WaveletMatrix,l,r,low,high:int):int=
        ## [l,r) 内で値が [low,high) に入る要素数を O(H) で返す。low >= high なら 0。
        if low >= high:
            return 0
        return self.range_lowerbound(l,r,high) - self.range_lowerbound(l,r,low)

    proc count*(self:WaveletMatrix,l,r,x:int):int=
        ## [l,r) 内の x の出現回数を O(H) で返す。
        if x < 0:
            return 0
        if self.H < sizeof(int) * 8 and (x shr self.H) != 0:
            return 0
        var l = l
        var r = r
        for h in countdown(self.H-1,0,1):
            if l == r:
                return 0
            let (l0,r0,l1,r1) = self.get_child(h,l,r)
            if x.testBit(h):
                l = l1
                r = r1
            else:
                l = l0
                r = r0
        return r-l

    proc kth_largest*(self:WaveletMatrix,l,r,k:int):int=
        ## [l,r) 内で大きい順に k 番目の値を O(H) で返す。k は 0-indexed。
        assert 0 <= k and k < r-l
        return self.kth_smallest(l,r,r-l-1-k)

    proc sum_smallest*(self:WaveletMatrix,l,r,k:int):int=
        ## [l,r) 内の小さい方から k 個の総和を O(H) で返す。0 <= k <= r-l、構築時に with_sum=true が必要。
        assert self.with_sum
        assert 0 <= l and l <= r and r <= self.N
        assert 0 <= k and k <= r-l
        var l = l
        var r = r
        var k = k
        var value = 0
        for h in countdown(self.H-1,0,1):
            if k == 0:
                return
            let (l0,r0,l1,r1) = self.get_child(h,l,r)
            if k < r0-l0:
                l = l0
                r = r0
            else:
                result += self.zero_sum[h][r] - self.zero_sum[h][l]
                k -= r0-l0
                value += 1 shl h
                l = l1
                r = r1
        result += k * value

    proc sum_upperbound*(self:WaveletMatrix,l,r,x:int):int=
        ## [l,r) 内の x 以下の要素の総和を 1 回の走査で O(H) で返す。構築時に with_sum=true が必要。
        assert self.with_sum
        assert 0 <= l and l <= r and r <= self.N
        if x < 0:
            return 0
        if self.H < sizeof(int) * 8 and (x shr self.H) != 0:
            return self.sum_smallest(l,r,r-l)
        var l = l
        var r = r
        for h in countdown(self.H-1,0,1):
            if l == r:
                return
            let (l0,r0,l1,r1) = self.get_child(h,l,r)
            if x.testBit(h):
                result += self.zero_sum[h][r] - self.zero_sum[h][l]
                l = l1
                r = r1
            else:
                l = l0
                r = r0
        result += (r-l) * x

    proc sum_lowerbound*(self:WaveletMatrix,l,r,x:int):int=
        ## [l,r) 内の x 未満の要素の総和を 1 回の走査で O(H) で返す。構築時に with_sum=true が必要。
        assert self.with_sum
        assert 0 <= l and l <= r and r <= self.N
        if x <= 0:
            return 0
        return self.sum_upperbound(l,r,x-1)

    proc range_sum*(self:WaveletMatrix,l,r,low,high:int):int=
        ## [l,r) 内で値が [low,high) に入る要素の総和を O(H) で返す。low >= high なら 0。構築時に with_sum=true が必要。
        assert self.with_sum
        assert 0 <= l and l <= r and r <= self.N
        if low >= high:
            return 0
        return self.sum_lowerbound(l,r,high) - self.sum_lowerbound(l,r,low)
