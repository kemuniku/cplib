when not declared CPLIB_STR_STATIC_STRING:
    const CPLIB_STR_STATIC_STRING* = 1
    import cplib/collections/staticRMQ
    import atcoder/string
    import sequtils

    type StaticStringBase* = ref object
        S* : string
        RMQ* : StaticRMQ[int]
        SA* : seq[int]
        RSA* : seq[int]
        LCP* : seq[int]
        size* : int
    type StaticString* = object
        base* : StaticStringBase
        l* : int
        r* : int

    proc toStaticString*(S:string):StaticString=
        var base = StaticStringBase()
        base.S = S
        base.SA = suffix_array(S)
        base.RSA = newseq[int](len(S))
        for i in 0..<len(S):
            base.RSA[base.SA[i]] = i
        base.LCP = lcp_array(S,base.SA)
        base.RMQ = initRMQ(base.LCP)
        base.size = len(S)
        return StaticString(base:base,l:0,r:len(S))


    proc `[]`*(S:StaticString,idx:Natural):char=
        assert S.l+idx < S.base.size
        return S.base.S[S.l+idx]

    proc `[]`*(S:StaticString,slice:HSlice[int,int]):StaticString=
        assert slice.a <= slice.b
        return StaticString(base:S.base,l:S.l+slice.a,r:S.l+slice.b+1)


    proc `$`*(S:StaticString):string=S.base.S[S.l..<S.r]

    proc len*(S:StaticString):int = S.r-S.l

    proc lcp*(S,T:StaticString):int=
        assert S.base == T.base
        var l = S.base.RSA[S.l]
        var r = S.base.RSA[T.l]
        if l > r:
            swap(l,r)
        elif l == r:
            return min(len(S),len(T))
        return min(min(len(S),len(T)),S.base.RMQ.query(l,r))

    proc cmp*(S,T:StaticString):int=
        var lcp = lcp(S,T)
        if min(len(S),len(T)) == lcp:
            if len(S) == len(T):
                return 0
            elif len(S) < len(T):
                return -1
            else:
                return 1
        else:
            if S[lcp] < T[lcp]:
                return -1
            else:
                return 1

    proc `<`*(S,T:StaticString):bool=
        return cmp(S,T) < 0

    proc `==`*(S,T:StaticString):bool=
        return len(S) == len(T) and lcp(S,T) == len(S)