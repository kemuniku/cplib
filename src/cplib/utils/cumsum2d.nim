when not declared CPLIB_UTILS_CUMSUM2D:
    const CPLIB_UTILS_CUMSUM2D* = 1
    import sequtils

    type Cumsum2D* = ref object
        B : seq[seq[int]]
        H : int
        W : int
    
    proc toCumSum2D*(X:openArray[seq[int]]):Cumsum2D=
        ## 行列Xの二次元累積和をO(HW)時間・領域で構築する。
        var H = len(X)
        var W = if H != 0 : len(X[0]) else: 0
        var B = newseqwith(H+1,newseqwith(W+1,0))
        for i in 1..H:
            var left, diagonal = 0
            for j in 1..W:
                let above = B[i-1][j]
                left = above + left - diagonal + X[i-1][j-1]
                B[i][j] = left
                diagonal = above

        result = Cumsum2D(B:B,H:H,W:W)
    
    proc query*(self:Cumsum2D,il,ir,jl,jr:int):int=
        # i in [il,ir) j in [jl,jr)を満たすようなマスの総和
        return self.B[ir][jr] - self.B[ir][jl] - self.B[il][jr] + self.B[il][jl]
