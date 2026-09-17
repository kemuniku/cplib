when not declared CPLIB_CONVOLUTION_XOR_CONVOLUTION:
    const CPLIB_CONVOLUTION_XOR_CONVOLUTION* = 1
    import bitops
    proc FastHadamardTransForm*[T](u:var seq[T])=
        ## 長さが正の2冪の配列をアダマール変換する。O(N log N)。
        var n = len(u)
        assert n > 0 and (n and (n-1)) == 0, "配列の長さは正の2冪である必要があります"
        var i = 1
        while i<n:
            for j in 0..<(n):
                if (j and i) == 0:
                    var x = u[j]
                    var y = u[j+i]
                    u[j] = x+y
                    u[j+i] = x-y
            i = i shl 1

    proc xorConvolution*[T](u,v:seq[T]):seq[T]=
        ## 同じ正の2冪長の配列のXOR畳み込みを返す。O(N log N)。
        assert u.len == v.len, "配列の長さは一致する必要があります"
        var u = u;var v = v;
        FastHadamardTransForm(u)
        FastHadamardTransForm(v)
        for i in 0..<len(u):
            u[i] *= v[i]
        FastHadamardTransForm(u)
        when T is int:
            let k = len(u).fastLog2()
            for i in 0..<len(u):
                u[i] = u[i] shr k
            return u
        else:
            var inv = T(1)/T(len(u))
            for i in 0..<len(u):
                u[i] *= inv
            return u
