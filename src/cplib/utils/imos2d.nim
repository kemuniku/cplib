when not declared CPLIB_UTILS_IMOS2D:
    const CPLIB_UTILS_IMOS2D* = 1
    import sequtils

    type Imos2D* = ref object
        B : seq[seq[int]]
        H : int
        W : int
    
    proc initImos2D*(H,W:int):Imos2D=
        return Imos2D(B:newseqwith(H+1,newseqwith(W+1,0)),H:H,W:W)
    
    proc rectangle_add*(self:Imos2D,il,ir,jl,jr,x:int)=
        # i in [il,ir) j in [jl,jr)を満たすようなマスにxを加算する
        self.B[il][jl] += x
        self.B[il][jr] -= x
        self.B[ir][jl] -= x
        self.B[ir][jr] += x
    
    proc build*(self:Imos2D):seq[seq[int]]=
        result = newseqwith(self.H,newseqwith(self.W,0))
        for i in 0..<(self.H):
            for j in 0..<(self.W):
                result[i][j] = self.B[i][j]
                if i != 0:
                    result[i][j] += result[i-1][j]
                if j != 0:
                    result[i][j] += result[i][j-1]
                if i != 0 and j != 0:
                    result[i][j] -= result[i-1][j-1]
        return result


