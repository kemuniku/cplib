when not declared CPLIB_COLLECTIONS_WAVELETMATRIX:
    const CPLIB_COLLECTIONS_WAVELETMATRIX* = 1
    import cplib/collections/bitvector
    import sequtils
    import bitops
    import options

    # releaseでもdebug指定時は境界・オーバーフローチェックを残す。
    when defined(release) and not defined(debug):
        {.push boundChecks: off, overflowChecks: off.}

    const scanLimit = 64

    type
        WaveletLevel = object
            bits : BitVector
            zero_count : int
            zero_sum : seq[int]
        WaveletMatrix* = ref object
            dat : seq[WaveletLevel]
            H : int
            N : int
            with_sum : bool
            scan_h : int
            scan_values : seq[int]

    proc initWaveletMatrix*(v:openArray[int],H:int = -1,with_sum:bool = false):WaveletMatrix=
        ## 非負整数列から O(NH) 時間で構築する。H は全要素を表現できるビット数で、-1 なら自動設定する。
        ## 下位層の短縮用に最大 O(N) 個の int を保存する。
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
        assert 0 <= H and H <= sizeof(int) * 8, "Hはintのビット数以下の非負整数である必要があります"
        result = WaveletMatrix(dat:newSeq[WaveletLevel](H),N:N,H:H,with_sum:with_sum)
        for level in result.dat.mitems:
            level.bits = newBitVector(N)
        var width = N
        var depth = 0
        while width > scanLimit:
            width = (width shr 1) + (width and 1)
            inc depth
        result.scan_h = H-depth-1
        # 小区間になった層の並びを保存し、下位の長いrank走査を省く。
        if result.scan_h < 6:
            result.scan_h = -1
        var zero = newSeq[int](N)
        var one = newSeq[int](N)
        var a = 0
        var b = 0
        for h in countdown(H-1,0,1):
            if h == result.scan_h:
                result.scan_values = newSeq[int](N)
                for i in 0..<N:
                    result.scan_values[i] = v[i]
            let bit_mask = 1 shl h
            var word = 0'u64
            for i in 0..<N:
                let value = v[i]
                let bit = int((value and bit_mask) != 0)
                # 両側に書き、該当側の位置だけ進めて分岐を避ける。
                zero[a] = value
                one[b] = value
                a += 1-bit
                b += bit
                word = word or (uint64(bit) shl (i and 63))
                if (i and 63) == 63:
                    result.dat[h].bits.setWord(i shr 6,word)
                    word = 0
            if (N and 63) != 0:
                result.dat[h].bits.setWord(N shr 6,word)
            if with_sum:
                result.dat[h].zero_sum = newSeq[int](a+1)
                var zero_total = 0
                for i in 0..<a:
                    zero_total += zero[i]
                    result.dat[h].zero_sum[i+1] = zero_total
            result.dat[h].zero_count = a
            for i in 0..<a:
                v[i] = zero[i]
            for i in 0..<b:
                v[a+i] = one[i]
            a = 0
            b = 0
            result.dat[h].bits.build()
    
    proc get_child*(self:WaveletMatrix,h,l,r:int):tuple[l0,r0,l1,r1:int] {.inline.} =
        ## 高さ h+1 の区間 [l,r) に対応する子の区間を O(1) で返す。
        # 高さh+1における[l,r)に該当する部分を見ているとする。
        # その子に該当する部分を[l0,r0),[l1,r1)としたとき、(l0,r0,l1,r1)を返す。
        let c0 = self.dat[h].zero_count
        let l_rank = self.dat[h].bits.rank(l)
        let r_rank = self.dat[h].bits.rank(r)
        result.l0 = l - l_rank
        result.r0 = r - r_rank
        result.l1 = l_rank + c0
        result.r1 = r_rank + c0

    
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
            if l == r:
                return
            if h == self.scan_h and r-l <= scanLimit:
                for i in l..<r:
                    let value = self.scan_values[i]
                    if value < x: result += 1
                return
            var (l0,r0,l1,r1) = self.get_child(h,l,r)
            if ((x shr h) and 1) != 0:
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
            if l == r:
                return
            if h == self.scan_h and r-l <= scanLimit:
                for i in l..<r:
                    let value = self.scan_values[i]
                    if value <= x: result += 1
                return
            var (l0,r0,l1,r1) = self.get_child(h,l,r)
            if ((x shr h) and 1) != 0:
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
            if h == self.scan_h and r-l <= scanLimit:
                for i in l..<r:
                    let value = self.scan_values[i]
                    if value == x: result += 1
                return
            let (l0,r0,l1,r1) = self.get_child(h,l,r)
            if ((x shr h) and 1) != 0:
                l = l1
                r = r1
            else:
                l = l0
                r = r0
        return r-l

    proc kth_largest*(self:WaveletMatrix,l,r,k:int):int=
        ## [l,r) 内で大きい順に k 番目の値を O(H) で返す。k は 0-indexed。
        assert 0 <= k and k < r-l, "指定した値が有効な範囲内である必要があります: 0 <= k and k < r - l"
        return self.kth_smallest(l,r,r-l-1-k)

    proc sum_smallest*(self:WaveletMatrix,l,r,k:int):int=
        ## [l,r) 内の小さい方から k 個の総和を O(H) で返す。0 <= k <= r-l、構築時に with_sum=true が必要。
        assert self.with_sum, "和を取得するにはwith_sumを有効にして初期化する必要があります"
        assert 0 <= l and l <= r and r <= self.N, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.N"
        assert 0 <= k and k <= r-l, "指定した値が有効な範囲内である必要があります: 0 <= k and k <= r - l"
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
                result += self.dat[h].zero_sum[r0] - self.dat[h].zero_sum[l0]
                k -= r0-l0
                value += 1 shl h
                l = l1
                r = r1
        result += k * value

    proc sum_upperbound*(self:WaveletMatrix,l,r,x:int):int=
        ## [l,r) 内の x 以下の要素の総和を 1 回の走査で O(H) で返す。構築時に with_sum=true が必要。
        assert self.with_sum, "和を取得するにはwith_sumを有効にして初期化する必要があります"
        assert 0 <= l and l <= r and r <= self.N, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.N"
        if x < 0:
            return 0
        if self.H < sizeof(int) * 8 and (x shr self.H) != 0:
            return self.sum_smallest(l,r,r-l)
        var l = l
        var r = r
        for h in countdown(self.H-1,0,1):
            if l == r:
                return
            if h == self.scan_h and r-l <= scanLimit:
                for i in l..<r:
                    let value = self.scan_values[i]
                    if value <= x: result += value
                return
            let (l0,r0,l1,r1) = self.get_child(h,l,r)
            if ((x shr h) and 1) != 0:
                result += self.dat[h].zero_sum[r0] - self.dat[h].zero_sum[l0]
                l = l1
                r = r1
            else:
                l = l0
                r = r0
        result += (r-l) * x

    proc sum_lowerbound*(self:WaveletMatrix,l,r,x:int):int=
        ## [l,r) 内の x 未満の要素の総和を 1 回の走査で O(H) で返す。構築時に with_sum=true が必要。
        assert self.with_sum, "和を取得するにはwith_sumを有効にして初期化する必要があります"
        assert 0 <= l and l <= r and r <= self.N, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.N"
        if x <= 0:
            return 0
        return self.sum_upperbound(l,r,x-1)

    proc range_sum*(self:WaveletMatrix,l,r,low,high:int):int=
        ## [l,r) 内で値が [low,high) に入る要素の総和を O(H) で返す。low >= high なら 0。構築時に with_sum=true が必要。
        assert self.with_sum, "和を取得するにはwith_sumを有効にして初期化する必要があります"
        assert 0 <= l and l <= r and r <= self.N, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.N"
        if low >= high:
            return 0
        return self.sum_lowerbound(l,r,high) - self.sum_lowerbound(l,r,low)

    proc sum_smallest_with_count*(self:WaveletMatrix,l,r,k:int):tuple[sum,count:int]=
        ## [l,r) 内の小さい方から k 個の総和と個数を O(H) で返す。with_sum=true が必要。
        return (sum:self.sum_smallest(l,r,k),count:k)

    proc sum_upperbound_with_count*(self:WaveletMatrix,l,r,x:int):tuple[sum,count:int]=
        ## [l,r) 内の x 以下の総和と個数を同じ探索で O(H) で返す。with_sum=true が必要。
        assert self.with_sum, "和を取得するにはwith_sumを有効にして初期化する必要があります"
        assert 0 <= l and l <= r and r <= self.N, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.N"
        if x < 0:
            return
        if self.H < sizeof(int) * 8 and (x shr self.H) != 0:
            return self.sum_smallest_with_count(l,r,r-l)
        var l = l
        var r = r
        for h in countdown(self.H-1,0,1):
            if l == r:
                return
            if h == self.scan_h and r-l <= scanLimit:
                for i in l..<r:
                    let value = self.scan_values[i]
                    if value <= x:
                        result.sum += value
                        inc result.count
                return
            let (l0,r0,l1,r1) = self.get_child(h,l,r)
            if ((x shr h) and 1) != 0:
                result.sum += self.dat[h].zero_sum[r0] - self.dat[h].zero_sum[l0]
                result.count += r0-l0
                l = l1
                r = r1
            else:
                l = l0
                r = r0
        result.sum += (r-l) * x
        result.count += r-l

    proc sum_lowerbound_with_count*(self:WaveletMatrix,l,r,x:int):tuple[sum,count:int]=
        ## [l,r) 内の x 未満の総和と個数を同じ探索で O(H) で返す。with_sum=true が必要。
        assert self.with_sum, "和を取得するにはwith_sumを有効にして初期化する必要があります"
        assert 0 <= l and l <= r and r <= self.N, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.N"
        if x <= 0:
            return
        return self.sum_upperbound_with_count(l,r,x-1)

    proc range_sum_with_count*(self:WaveletMatrix,l,r,low,high:int):tuple[sum,count:int]=
        ## [l,r) 内で値が [low,high) に入る総和と個数を O(H) で返す。low >= high なら (0,0)。with_sum=true が必要。
        assert self.with_sum, "和を取得するにはwith_sumを有効にして初期化する必要があります"
        assert 0 <= l and l <= r and r <= self.N, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.N"
        if low >= high:
            return
        let upper = self.sum_lowerbound_with_count(l,r,high)
        let lower = self.sum_lowerbound_with_count(l,r,low)
        return (sum:upper.sum-lower.sum,count:upper.count-lower.count)

    when defined(release) and not defined(debug):
        {.pop.}
