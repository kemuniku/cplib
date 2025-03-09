import bitops
proc FastHadamardTransForm*[T](u:var seq[T])=
    var n = len(u)
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
    var u = u;var v = v;
    FastHadamardTransForm(u)
    FastHadamardTransForm(v)
    for i in 0..<len(u):
        u[i] *= v[i]
    FastHadamardTransForm(u)
    when T is int:
        var k = (len(u)-1).fastLog2() + 1
        assert len(u) == (1 shl k)
        for i in 0..<len(u):
            u[i] = u[i] shr k
        return u
    else:
        var inv = T(1)/T(len(u))
        for i in 0..<len(u):
            u[i] *= inv
        return u
