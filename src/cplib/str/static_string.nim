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
    proc initStaticStringBase(S:string):StaticStringBase=
        result = StaticStringBase()
        result.S = S
        result.SA = suffix_array(S)
        result.RSA = newseq[int](len(S))
        for i in 0..<len(S):
            result.RSA[result.SA[i]] = i
        result.LCP = lcp_array(S,result.SA)
        result.RMQ = initRMQ(result.LCP)
        result.size = len(S)
    proc toStaticString*(S:string):StaticString=
        var base = initStaticStringBase(S)
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

    proc initSuffixArray*(base:StaticStringBase):seq[StaticSTring]=
        result = newseq[StaticString](base.size)
        for i in 0..<base.size:
            result[i].base = base
            result[i].l = base.SA[i]
            result[i].r = base.size

    proc initSuffixArray*(S:StaticString):seq[StaticString]=
        var SA = suffix_array(S.base.S[S.l..<S.r])
        result = newseq[StaticString](len(SA))
        for i in 0..<len(SA):
            result[i].base = S.base
            result[i].l = SA[i]+S.l
            result[i].r = S.r
    
    proc toStaticStrings*(strings:seq[string]):seq[StaticString]=
        var tmp = ""
        for i in 0..<len(strings):
            tmp &= strings[i]
            tmp &= '$'
        var base = initStaticStringBase(tmp)
        result = newseq[StaticString](len(strings))
        var now = 0
        for i in 0..<len(strings):
            result[i].base = base
            result[i].l = now
            result[i].r = now+len(strings[i])
            now += len(strings[i]) + 1