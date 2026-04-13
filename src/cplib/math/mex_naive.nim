when not declared CPLIB_MATH_MEX_NAIVE:
    const CPLIB_MATH_MEX_NAIVE* = 1
    import sequtils
    proc mex_naive(X:seq[int]):int=
        var tmp = newseqwith(len(X),false)
        for x in X:
            if x in 0..<len(X):
                tmp[x] = true
        
        for i in 0..<len(X):
            if not tmp[i]:
                return i
        
        return len(X)