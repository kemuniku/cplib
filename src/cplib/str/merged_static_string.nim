when not declared CPLIB_STR_MERGED_STATIC_STRING:
    const CPLIB_STR_MERGED_STATIC_STRING* = 1
    include cplib/str/static_string

    type MergedStaticString* = object
        S : seq[StaticString]
        lencum : seq[int]

    proc `&=`(S:var MergedStaticString,T:StaticString)=
        if S.S.len == 0:
            S.S = @[T]
            S.lencum = @[len(T)]
        else:
            S.S.add(T)
            S.lencum.add(S.lencum[^1] + len(T))


    proc initMergedStaticString*(S:seq[StaticString]):MergedStaticString=
        result.S = S
        result.lencum = newSeq[int](len(S))
        result.lencum[0] = len(S[0])
        for i in 1..<len(S):
            result.lencum[i] = result.lencum[i-1] + len(S[i])

    proc len*(S:MergedStaticString):int=
        if S.lencum.len == 0:
            return 0
        else:
            return S.lencum[^1]

    proc `[]`*(S:MergedStaticString,idx:int):char=
        var tmp = S.lencum.upperBound(idx)
        if tmp == 0:
            return S.S[0][idx]
        else:
            return S.S[tmp][idx-S.lencum[tmp-1]]

    proc `[]`*(S:MergedStaticString,slice:HSlice[int,int]):MergedStaticString=
        var tmp = 0
        for i in 0..<len(S.S):
            if tmp < slice.a:
                if slice.b < S.lencum[i]:
                    result &= S.S[i][(slice.a-tmp)..(slice.b-tmp)]
                elif slice.a < S.lencum[i]:
                    result &= S.S[i][(slice.a-tmp)..<len(S.S[i])]
            elif S.lencum[i] <= slice.b:
                result &= S.S[i]
            elif tmp <= slice.b:
                result &= S.S[i][0..(slice.b-tmp)]
            tmp = S.lencum[i]



    proc lcp*(S,T:MergedStaticString):int=
        if S.S.len == 0 or T.S.len == 0:
            return 0
        var s = S.S[0]
        var t = T.S[0]
        var si = 0
        var ti = 0
        while true:
            var tmp = lcp(s,t)
            if tmp == len(s) and tmp == len(t):
                si += 1
                ti += 1
                result += tmp
                if si == len(S.S) or ti == len(T.S):
                    return result
                s = S.S[si]
                t = T.S[ti]
            elif tmp == len(s):
                si += 1
                result += tmp
                if si == len(S.S):
                    return result
                s = S.S[si]
                t = t[tmp..<len(t)]
            elif tmp == len(t):
                ti += 1
                result += tmp
                if ti == len(T.S):
                    return result
                s = s[tmp..<len(s)]
                t = T.S[ti]
            else:
                return result + tmp

    proc cmp*(S,T:MergedStaticString):int=
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

    proc `<`*(S,T:MergedStaticString):bool=
        return cmp(S,T) < 0

    proc `>`*(S,T:MergedStaticString):bool=
        return cmp(S,T) > 0

    proc `<=`*(S,T:MergedStaticString):bool=
        return cmp(S,T) <= 0

    proc `>=`*(S,T:MergedStaticString):bool=
        return cmp(S,T) >= 0

    proc `==`*(S,T:MergedStaticString):bool=
        return len(S) == len(T) and lcp(S,T) == len(S)

    proc `$`*(S:MergedStaticString):string=
        result = ""
        for i in 0..<len(S.S):
            result &= $(S.S[i])
        return result