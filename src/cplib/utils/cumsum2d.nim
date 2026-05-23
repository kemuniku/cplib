when not declared CPLIB_UTILS_GRID_CUMSUM2D:
    const CPLIB_UTILS_CUMSUM2D* = 1
    import sequtils

    type Cumsum2D* = ref object
        B : seq[seq[int]]
        H : int
        W : int
    
    proc toCumSum2D*(X:seq[seq[int]]):Cumsum2D=
        var H = len(X)
        var W = if H != 0 : len(X[0]) else: 0
        var B = newseqwith(H+1,newseqwith(W+1,0))
        for i in 1..H:
            for j in 1..W:
                B[i][j] = B[i-1][j] + B[i][j-1] - B[i-1][j-1] + X[i][j]

        result = Cumsum2D(B:B,H:H,W:W)
    
    proc query*(self:Cumsum2D,il,ir,jl,jr:int):int=
        # i in [il,ir) j in [jl,jr)を満たすようなマスの総和
        return self.B[ir][jr] - self.B[ir][jl] - self.B[il][jr] + self.B[il][jl]

