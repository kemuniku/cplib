when not declared CPLIB_GEOMETRY_ARGSORT:
    const CPLIB_GEOMETRY_ARGSORT* = 1
    import algorithm
    import cplib/math/int128
    proc argcmp*(L,R:(int,int)):int=
        # < : -
        # = : 0
        # > : +
        var a = L[1] > 0 or (L[1] == 0 and L[0] > 0)
        var b = R[1] > 0 or (R[1] == 0 and R[0] > 0)
        if a != b:
            return cmp(b,a)
        else:
            return cmp(to_Int128(L[1])*R[0],to_Int128(L[0])*R[1])

    proc argsorted*(X:seq[(int,int)]):seq[(int,int)]=
        ## 偏角ソート
        ## 0° opened
        return sorted(X,argcmp)

    proc argsort*(X:var seq[(int,int)])=
        X.sort(argcmp)
