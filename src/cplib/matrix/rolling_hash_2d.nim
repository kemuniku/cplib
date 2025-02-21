when not declared CPLIB_MATRIX_ROLLINGHASH2D:
    const CPLIB_MATRIX_ROLLINGHASH2D* = 1
    import random
    import sequtils
    const MASK30 = (1u shl 30) - 1
    const MASK31 = (1u shl 31) - 1
    const RH_MOD = (1u shl 61) - 1
    const POW_CALC = 500000

    randomize()

    proc calc_mod(x: uint): uint =
        result = (x shr 61) + (x and RH_MOD)
        if result >= RH_MOD:
            result -= RH_MOD

    proc mul(a, b: uint): uint =
        let
            a_upper = a shr 31
            a_lower = a and MASK31
            b_upper = b shr 31
            b_lower = b and MASK31
            mid = a_lower * b_upper + a_upper * b_lower
            mid_upper = mid shr 30
            mid_lower = mid and MASK30
        result = a_upper * b_upper * 2 + mid_upper + (mid_lower shl 31) + a_lower * b_lower


    proc inner_pow(a:uint, n: int): uint =
        var a = a
        var n = n
        result = 1
        while n > 0:
            if (n and 1) != 0:
                result = mul(result, a).calc_mod
            a = mul(a, a).calc_mod
            n = n shr 1

    let hashmatrix_basei:uint = rand(129u..(1u shl 30))
    let inv_hashmatrix_basei:uint = inner_pow(hashmatrix_basei,int(RH_MOD)-2)
    let hashmatrix_basej:uint = rand(129u..(1u shl 30))
    let inv_hashmatrix_basej:uint = inner_pow(hashmatrix_basej,int(RH_MOD)-2)
    var powsi : seq[uint] = newseq[uint](POW_CALC+1)
    var invpowsi : seq[uint] = newseq[uint](POW_CALC+1)
    var powsj : seq[uint] = newseq[uint](POW_CALC+1)
    var invpowsj : seq[uint] = newseq[uint](POW_CALC+1)
    powsi[0] = 1
    invpowsi[0] = 1
    powsj[0] = 1
    invpowsj[0] = 1
    for i in 1..POW_CALC:
        powsi[i] = (mul(powsi[i-1],hashmatrix_basei).calc_mod)
        invpowsi[i] = (mul(invpowsi[i-1],inv_hashmatrix_basei).calc_mod)
        powsj[i] = (mul(powsj[i-1],hashmatrix_basej).calc_mod)
        invpowsj[i] = (mul(invpowsj[i-1],inv_hashmatrix_basej).calc_mod)

    proc base_powi(n:int):uint=
        if n >= len(powsi):
            return inner_pow(hashmatrix_basei,n)
        else:
            return powsi[n]

    proc base_powj(n:int):uint=
        if n >= len(powsj):
            return inner_pow(hashmatrix_basej,n)
        else:
            return powsj[n]

    proc inv_base_powi(n:int):uint=
        if n >= len(powsi):
            return inner_pow(inv_hashmatrix_basei,n)
        else:
            return invpowsi[n]

    proc inv_base_powj(n:int):uint=
        if n >= len(powsj):
            return inner_pow(inv_hashmatrix_basej,n)
        else:
            return invpowsj[n]

    type HashMatrixBase[T] = ref object
        matrix : seq[seq[T]]
        hash : seq[seq[uint]]
        H : int
        W : int

    type HashMatrix[T] = object
        base : HashMatrixBase[T]
        i : int
        j : int
        H : int
        W : int

    type HashMatrixRow[T] = object
        HM : HashMatrix[T]
        i : int

    proc initHashMatrixBase[T](x:seq[seq[T]]):HashMatrixBase[T]=
        var H = len(x)
        var W : int
        if H == 0:
            W = 0
        else:
            W = len(x[0])
        var hash = newseqwith(H+1,newseqwith(W+1,0u))
        
        for i in 0..<H:
            for j in 0..<W:
                hash[i+1][j+1] = mul(mul(uint(x[i][j]),base_powi(i)).calc_mod(),base_powj(j)).calc_mod()
        for i in 0..<H:
            for j in 0..<W:
                hash[i+1][j+1] = (hash[i+1][j+1]+((hash[i][j+1] + hash[i+1][j]).calc_mod() + RH_MOD - hash[i][j]).calc_mod()).calc_mod()
        return HashMatrixBase[T](matrix:x,hash:hash,H:H,W:W)

    proc initHashMartix*[T](x:seq[seq[T]]):HashMatrix[T]=
        var base = initHashMatrixBase[T](x)
        return HashMatrix[T](base:base,i:0,j:0,H:base.H,W:base.W)

    proc get*[T](HM:HashMatrix[T],islice:HSlice[int,int],jslice:HSlice[int,int]):HashMatrix[T]=
        var i = HM.i + islice.a
        var j = HM.j + jslice.a
        var H = islice.len
        var W = jslice.len
        return HashMatrix[T](base:HM.base,i:i,j:j,H:H,W:W)

    proc gethash*[T](HM:HashMatrix[T]):uint=
        return mul((((HM.base.hash[HM.i+HM.H][HM.j+HM.W] + RH_MOD - HM.base.hash[HM.i][HM.j+HM.W]).calc_mod() + RH_MOD - HM.base.hash[HM.i+HM.H][HM.j]).calc_mod() + HM.base.hash[HM.i][HM.j]).calc_mod(),mul(inv_base_powi(HM.i),inv_base_powj(HM.j)).calc_mod()).calc_mod()

    proc `==`*[T](L,R:HashMatrix[T]):bool=
        return gethash(L) == gethash(R)
    
    proc `[]`*[T](HM:HashMatrix[T],i:int,j:int):T=
        return HM.base.matrix[HM.i+i][HM.j+j]
    
    proc `[]`*[T](HM:HashMatrix[T],i:int):HashMatrixRow[T]=
        return HashMatrixRow[T](HM:HM,i:i)
    
    proc `[]`*[T](HMR:HashMatrixRow[T],j:int):T=
        return HMR.HM.base.matrix[HMR.i+HMR.HM.i][HMR.HM.j+j]

    proc `[]`*[T](HM:HashMatrix[T],slicei,slicej:HSlice[int,int]):HashMatrix[T]=
        return get(HM,slicei,slicej)
