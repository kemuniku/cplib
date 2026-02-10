when not declared CPLIB_COLLECTIONS_STATICRMQ:
    const CPLIB_COLLECTIONS_STATICRMQ* = 1
    import sequtils,bitops
    # https://maspypy.com/library-checker-static-rmq
    type StaticRMQ*[T] = object
        table : seq[seq[T]]
        size : int
        prefix_product : seq[T]
        suffix_product : seq[T]
        V : seq[T]
    proc initRMQ*[T](V:seq[T]):StaticRMQ[T]=
        result.V = V
        if len(V) == 0:
            return StaticRMQ[T](size:0)
        const B = 16
        const sft = 4
        const mask = 0b1111
        result.size = len(V)
        result.prefix_product = newseq[T](len(V))
        result.suffix_product = newseq[T](len(V))
        for i in 0..<len(V):
            if (i and mask) == 0:
                result.prefix_product[i] = V[i]
            else:
                result.prefix_product[i] = min(result.prefix_product[i-1],V[i])
        result.suffix_product[^1] = V[^1]
        for i in countdown(len(V)-2,0,1):
            if (i and mask) == mask:
                result.suffix_product[i] = V[i]
            else:
                result.suffix_product[i] = min(result.suffix_product[i+1],V[i])
        
        var block_len = (len(V)+B-1) div B
        var b = fastLog2(block_len)
        result.table = newSeqwith(fastLog2(block_len)+1,newseq[T](block_len))
        for i in 0..<(block_len-1):
            result.table[0][i] = result.suffix_product[i shl sft]
        result.table[0][block_len-1] = result.suffix_product[^1]
        for i in 1..b:
            var j = 0
            while j+(1 shl i) <= block_len:
                if result.table[i-1][j] > result.table[i-1][j+(1 shl (i-1))]:
                    result.table[i][j] = result.table[i-1][j+(1 shl (i-1))]
                else:
                    result.table[i][j] = result.table[i-1][j] 
                j += 1
    proc query*[T](RMQ:StaticRMQ[T],l,r:int):T=
        const sft = 4
        assert l in 0..<RMQ.size 
        assert r in 1..RMQ.size
        assert l < r
        var r = r-1
        var a = l shr sft
        var b = r shr sft
        if a < b:
            if a+1 < b:
                var k = fastLog2(b-a-1)
                if RMQ.table[k][a+1] > RMQ.table[k][b-(1 shl k)]:
                    return min(RMQ.table[k][b-(1 shl k)],min(RMQ.suffix_product[l],RMQ.prefix_product[r]))
                else:
                    return min(RMQ.table[k][a+1],min(RMQ.suffix_product[l],RMQ.prefix_product[r]))
            else:
                return min(RMQ.suffix_product[l],RMQ.prefix_product[r])
        
        result = RMQ.V[l]
        for i in (l+1)..r:
            if RMQ.V[i] < result:
                result = RMQ.V[i]
        return result