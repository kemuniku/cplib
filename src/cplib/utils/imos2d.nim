when not declared CPLIB_UTILS_IMOS2D:
    const CPLIB_UTILS_IMOS2D* = 1
    import sequtils

    type Imos2D* = ref object
        B : seq[seq[int]]
        H : int
        W : int
    
    proc initImos2D*(H,W:int):Imos2D=
        ## H 行 W 列の長方形加算を蓄積します。
        return Imos2D(B:newseqwith(H+1,newseqwith(W+1,0)),H:H,W:W)
    
    proc rectangle_add*(self:Imos2D,il,ir,jl,jr,x:int)=
        ## 半開区間の長方形に x を加算します。O(1)。
        # i in [il,ir) j in [jl,jr)を満たすようなマスにxを加算する
        self.B[il][jl] += x
        self.B[il][jr] -= x
        self.B[ir][jl] -= x
        self.B[ir][jr] += x
    
    proc build*(self:Imos2D):seq[seq[int]]=
        ## 蓄積した加算から各マスの値を復元します。O(HW)。
        result = newseqwith(self.H,newseqwith(self.W,0))
        for i in 0..<self.H:
            var left, diagonal = 0
            for j in 0..<self.W:
                let above = (if i == 0: 0 else: result[i-1][j])
                var value = self.B[i][j]
                if i != 0:
                    value += above
                if j != 0:
                    value += left
                if i != 0 and j != 0:
                    value -= diagonal
                result[i][j] = value
                left = value
                diagonal = above
        return result
