when not declared CPLIB_STR_MERGED_STATIC_STRING:
    const CPLIB_STR_MERGED_STATIC_STRING* = 1
    import cplib/str/static_string
    import cplib/collections/staticRMQ
    import algorithm

    type MergedStaticString*[T] = object
        base : StaticStringBase[T]
        L : seq[int32]
        R : seq[int32]
        lencum : seq[int]

    proc addRange[T](S:var MergedStaticString[T],base:StaticStringBase[T],l,r:int32) {.inline.}=
        assert l <= r
        if S.L.len == 0:
            S.base = base
        else:
            assert S.base == base
        S.L.add(l)
        S.R.add(r)
        let previousLength = if S.lencum.len == 0: 0 else: S.lencum[^1]
        S.lencum.add(previousLength+int(r-l))

    proc lcpRange[T](base:StaticStringBase[T],sl,sr,tl,tr:int32):int {.inline.}=
        result = min(int(sr-sl),int(tr-tl))
        if result == 0:
            return
        var l = base.RSA[sl]
        var r = base.RSA[tl]
        if l > r:
            swap(l,r)
        elif l == r:
            return
        result = min(result,base.RMQ.query(l,r))
    
    proc `&`*[Element](S,T:StaticString[Element]):MergedStaticString[Element]=
        assert S.base == T.base
        result.base = S.base
        result.L = @[S.l,T.l]
        result.R = @[S.r,T.r]
        result.lencum = @[len(S),len(S)+len(T)]
    proc `&=`*[T](S:var MergedStaticString[T],value:StaticString[T])=
        S.addRange(value.base,value.l,value.r)
    proc `&`*[T](S:MergedStaticString[T],value:StaticString[T]):MergedStaticString[T]=
        result = S
        result &= value
    


    proc initMergedStaticString*[T](S:openArray[StaticString[T]]):MergedStaticString[T]=
        if len(S) > 0:
            result.base = S[0].base
        result.L = newSeq[int32](len(S))
        result.R = newSeq[int32](len(S))
        result.lencum = newSeq[int](len(S))
        if len(S) == 0:
            return
        result.L[0] = S[0].l
        result.R[0] = S[0].r
        result.lencum[0] = len(S[0])
        for i in 1..<len(S):
            assert result.base == S[i].base
            result.L[i] = S[i].l
            result.R[i] = S[i].r
            result.lencum[i] = result.lencum[i-1] + len(S[i])

    proc initMergedStaticString*[T](S:StaticString[T],ranges:seq[(int,int)]):MergedStaticString[T]=
        result.base = S.base
        result.L = newSeq[int32](len(ranges))
        result.R = newSeq[int32](len(ranges))
        result.lencum = newSeq[int](len(ranges))
        var totalLength = 0
        for i,(l,r) in ranges:
            assert 0 <= l and l <= r and r <= len(S)
            result.L[i] = S.l+l.int32()
            result.R[i] = S.l+r.int32()
            totalLength += r-l
            result.lencum[i] = totalLength

    proc len*[T](S:MergedStaticString[T]):int=
        if S.lencum.len == 0:
            return 0
        else:
            return S.lencum[^1]

    proc `[]`*[T](S:MergedStaticString[T],idx:int):T=
        var tmp = S.lencum.upperBound(idx)
        if tmp == 0:
            return S.base.S[S.L[0]+idx]
        else:
            return S.base.S[S.L[tmp]+idx-S.lencum[tmp-1]]

    proc `[]`*[T](S:MergedStaticString[T],slice:HSlice[int,int]):MergedStaticString[T]=
        var tmp = 0
        for i in 0..<len(S.L):
            if tmp < slice.a:
                if slice.b < S.lencum[i]:
                    result.addRange(S.base,S.L[i]+(slice.a-tmp).int32(),S.L[i]+(slice.b-tmp+1).int32())
                elif slice.a < S.lencum[i]:
                    result.addRange(S.base,S.L[i]+(slice.a-tmp).int32(),S.R[i])
            elif S.lencum[i] <= slice.b:
                result.addRange(S.base,S.L[i],S.R[i])
            elif tmp <= slice.b:
                result.addRange(S.base,S.L[i],S.L[i]+(slice.b-tmp+1).int32())
            tmp = S.lencum[i]



    proc lcp*[Element](S,T:MergedStaticString[Element]):int=
        if S.L.len == 0 or T.L.len == 0:
            return 0
        assert S.base == T.base
        var si = 0
        var ti = 0
        var sl = S.L[0]
        var sr = S.R[0]
        var tl = T.L[0]
        var tr = T.R[0]
        while true:
            let slen = int(sr-sl)
            let tlen = int(tr-tl)
            let tmp = lcpRange(S.base,sl,sr,tl,tr)
            if tmp == slen and tmp == tlen:
                si += 1
                ti += 1
                result += tmp
                if si == len(S.L) or ti == len(T.L):
                    return result
                sl = S.L[si]
                sr = S.R[si]
                tl = T.L[ti]
                tr = T.R[ti]
            elif tmp == slen:
                si += 1
                result += tmp
                if si == len(S.L):
                    return result
                sl = S.L[si]
                sr = S.R[si]
                tl += tmp.int32()
            elif tmp == tlen:
                ti += 1
                result += tmp
                if ti == len(T.L):
                    return result
                sl += tmp.int32()
                tl = T.L[ti]
                tr = T.R[ti]
            else:
                return result + tmp

    proc cmp*[Element](S,T:MergedStaticString[Element]):int=
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

    proc `<`*[Element](S,T:MergedStaticString[Element]):bool=
        return cmp(S,T) < 0

    proc `>`*[Element](S,T:MergedStaticString[Element]):bool=
        return cmp(S,T) > 0

    proc `<=`*[Element](S,T:MergedStaticString[Element]):bool=
        return cmp(S,T) <= 0

    proc `>=`*[Element](S,T:MergedStaticString[Element]):bool=
        return cmp(S,T) >= 0

    proc `==`*[Element](S,T:MergedStaticString[Element]):bool=
        return len(S) == len(T) and lcp(S,T) == len(S)

    proc `$`*[T](S:MergedStaticString[T]):string=
        when T is char:
            for i in 0..<len(S.L):
                for j in S.L[i]..<S.R[i]:
                    result.add(S.base.S[j])
        else:
            var first = true
            for i in 0..<len(S.L):
                for j in S.L[i]..<S.R[i]:
                    if not first:
                        result &= " "
                    first = false
                    result &= $S.base.S[j]
