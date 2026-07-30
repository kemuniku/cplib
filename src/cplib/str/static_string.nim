when not declared CPLIB_STR_STATIC_STRING:
    const CPLIB_STR_STATIC_STRING* = 1
    import sequtils
    import algorithm
    import atcoder/string
    import cplib/collections/staticRMQ

    proc genericSuffixArray[T](S:seq[T]):seq[int]=
        var idx = toSeq(0..<len(S))
        idx.sort(proc(l,r:int):int = system.cmp[T](S[l],S[r]))
        var compressed = newSeq[int](len(S))
        var upper = 0
        for i in 0..<len(S):
            if i > 0 and S[idx[i-1]] != S[idx[i]]:
                upper += 1
            compressed[idx[i]] = upper
        return suffix_array(compressed,upper)

    type StaticStringBase*[T] = ref object
        S* : seq[T]
        RMQ* : StaticRMQ[int32]
        SA* : seq[int32]
        RSA* : seq[int32]
        LCP* : seq[int32]
        size* : int32
        reversible* : bool
    type StaticString*[T] = object
        base* : StaticStringBase[T]
        l* : int32
        r* : int32
    proc initStaticStringBase*[T](S:openArray[T],reversible:bool=false):StaticStringBase[T]=
        result = StaticStringBase[T]()
        result.size = len(S).int32()
        result.reversible = reversible
        result.S = @S
        if reversible:
            var revS = @S
            revS.reverse
            result.S.add(revS)
        result.SA = genericSuffixArray(result.S).mapit(int32(it))
        result.RSA = newseq[int32](len(result.S))
        for i in 0.int32()..<len(result.S).int32():
            result.RSA[result.SA[i]] = i
        result.LCP = lcp_array(result.S,result.SA.mapIt(int(it))).mapit(int32(it))
        result.RMQ = initRMQ(result.LCP)

    proc initStaticStringBase*(S:string,reversible:bool=false):StaticStringBase[char]=
        result = StaticStringBase[char]()
        result.size = len(S).int32()
        result.reversible = reversible
        var staticS = S
        if reversible:
            var revS = S
            revS.reverse
            staticS &= revS
        result.S = @staticS
        result.SA = suffix_array(staticS).mapit(int32(it))
        result.RSA = newseq[int32](len(staticS))
        for i in 0.int32()..<len(staticS).int32():
            result.RSA[result.SA[i]] = i
        result.LCP = lcp_array(staticS,result.SA.mapIt(int(it))).mapit(int32(it))
        result.RMQ = initRMQ(result.LCP)

    proc toStaticString*[T](S:openArray[T],reversible:bool=false):StaticString[T]=
        var base = initStaticStringBase(S,reversible)
        return StaticString[T](base:base,l:0,r:len(S).int32())

    proc toStaticString*(S:string,reversible:bool=false):StaticString[char]=
        var base = initStaticStringBase(S,reversible)
        return StaticString[char](base:base,l:0,r:len(S).int32())

    proc len*[T](S:StaticString[T]): int {.inline.} = S.r - S.l

    proc `[]`*[T](S:StaticString[T],idx:Natural):T=
        assert idx < len(S)
        return S.base.S[S.l+idx]

    proc `[]`*[T](S:StaticString[T],slice:HSlice[int,int]):StaticString[T]=
        assert slice.a <= slice.b+1 and S.l + slice.b < S.r
        return StaticString[T](base:S.base,l:S.l+slice.a.int32(),r:S.l+slice.b.int32()+1)


    proc `$`*[T](S:StaticString[T]):string=
        when T is char:
            result = newString(len(S))
            for i in 0..<len(S):
                result[i] = S[i]
        else:
            for i in 0..<len(S):
                if i > 0:
                    result &= " "
                result &= $S[i]

    proc lcp*[Element](S,T:StaticString[Element]):int {.inline.}=
        assert S.base == T.base
        result = min(len(S),len(T))
        if result == 0:
            return
        var l = S.base.RSA[S.l]
        var r = S.base.RSA[T.l]
        if l > r:
            swap(l,r)
        elif l == r:
            return
        result = min(result,S.base.RMQ.query(l,r))

    proc reversed*[T](S:StaticString[T]):StaticString[T] {.inline.}=
        assert S.base.reversible
        result.base = S.base
        result.l = 2*S.base.size-S.r
        result.r = 2*S.base.size-S.l

    proc isPalindrome*[T](S:StaticString[T]):bool {.inline.}=
        assert S.base.reversible
        return lcp(S,S.reversed) == len(S)

    proc lcs*[Element](S,T:StaticString[Element]):int {.inline.}=
        assert S.base == T.base
        assert S.base.reversible
        return lcp(S.reversed,T.reversed)

    proc cmp*[Element](S,T:StaticString[Element]):int {.inline.}=
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

    proc `<`*[Element](S,T:StaticString[Element]):bool=
        return cmp(S,T) < 0

    proc `>`*[Element](S,T:StaticString[Element]):bool=
        return cmp(S,T) > 0

    proc `<=`*[Element](S,T:StaticString[Element]):bool=
        return cmp(S,T) <= 0
    
    proc `>=`*[Element](S,T:StaticString[Element]):bool=
        return cmp(S,T) >= 0

    proc `==`*[Element](S,T:StaticString[Element]):bool=
        return len(S) == len(T) and lcp(S,T) == len(S)

    proc initSuffixArray*[T](base:StaticStringBase[T]):seq[StaticString[T]]=
        var SA = base.SA
        if base.reversible:
            SA = genericSuffixArray(base.S[0..<base.size]).mapit(int32(it))
        result = newseq[StaticString[T]](base.size)
        for i in 0..<base.size:
            result[i].base = base
            result[i].l = SA[i]
            result[i].r = base.size

    proc initSuffixArray*[T](S:StaticString[T]):seq[StaticString[T]]=
        var SA = genericSuffixArray(S.base.S[S.l..<S.r]).mapit(int32(it))
        result = newseq[StaticString[T]](len(SA))
        for i in 0..<len(SA):
            result[i].base = S.base
            result[i].l = SA[i]+S.l
            result[i].r = S.r
    
    proc toStaticStrings*(strings:seq[string],reversible:bool=false):seq[StaticString[char]]=
        var tmp = ""
        for i in 0..<len(strings):
            tmp &= strings[i]
            tmp &= '$'
        var base = initStaticStringBase(tmp,reversible)
        result = newseq[StaticString[char]](len(strings))
        var now = int32(0)
        for i in 0..<len(strings):
            result[i].base = base
            result[i].l = now
            result[i].r = now+len(strings[i]).int32()
            now += len(strings[i]).int32() + 1
        
    proc startsWith*[T](s,prefix:StaticString[T]):bool=
        return lcp(s,prefix) == len(prefix)
    
    
    proc suffix_lowerbound*[T](base:StaticStringBase[T],S:openArray[T]):int=
        assert not base.reversible
        proc cmp(x:int32,s:openArray[T]):int=
            for i in 0..<len(s):
                if i+x >= base.size:return -1
                if base.S[i+x] < s[i]:return -1
                if base.S[i+x] > s[i]:return 1
            return 0
        return base.SA.lowerBound(S,cmp)

    proc suffix_upperbound*[T](base:StaticStringBase[T],S:openArray[T]):int=
        assert not base.reversible
        proc cmp(x:int32,s:openArray[T]):int=
            for i in 0..<len(s):
                if i+x >= base.size:return -1
                if base.S[i+x] < s[i]:return -1
                if base.S[i+x] > s[i]:return 1
            return 0
        return base.SA.upperBound(S,cmp)

    proc count*[T](base:StaticStringBase[T],S:openArray[T]):int=
        assert not base.reversible
        return base.suffix_upperbound(S) - base.suffix_lowerbound(S)
