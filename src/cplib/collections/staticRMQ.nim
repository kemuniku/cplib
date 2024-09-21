when not declared CPLIB_COLLECTIONS_STATICRMQ:
    const CPLIB_COLLECTIONS_STATICRMQ* = 1
    import sequtils,bitops
    type StaticRMQ*[T] = object
        table : seq[seq[T]]
        size : int
    proc initRMQ*[T](V:seq[T]):StaticRMQ[T]=
        if len(V) == 0:
            return StaticRMQ[T](size:0)
        result.size = len(V)
        var b = fastLog2(len(V))
        result.table = newSeqwith(fastLog2(len(V))+1,newseq[T](len(V)))
        for i in 0..<len(V):
            result.table[0][i] = V[i]
        for i in 1..b:
            var j = 0
            while j+(1 shl i) <= len(V):
                if result.table[i-1][j] > result.table[i-1][j+(1 shl (i-1))]:
                    result.table[i][j] = result.table[i-1][j+(1 shl (i-1))]
                else:
                    result.table[i][j] = result.table[i-1][j] 
                j += 1
    proc query*[T](RMQ:StaticRMQ[T],l,r:int):T=
        assert l in 0..<RMQ.size 
        assert r in 1..RMQ.size
        assert l < r
        var k = fastLog2(r-l)
        if RMQ.table[k][l] > RMQ.table[k][r-(1 shl k)]:
            return RMQ.table[k][r-(1 shl k)]
        else:
            return RMQ.table[k][l]
