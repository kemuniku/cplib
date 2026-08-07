when not declared CPLIB_STR_FIXEDLENGTH_MERGED_STATIC_STRING:
    const CPLIB_STR_FIXEDLENGTH_MERGED_STATIC_STRING* = 1
    import cplib/str/static_string
    import cplib/collections/staticRMQ

    type FixedLengthMergedStaticString*[T;N:static[int]] = object
        ## N is the number of concatenated ranges.
        base : StaticStringBase[T]
        L : array[N,int32]
        R : array[N,int32]

    proc setRange[T;N:static[int]](S:var FixedLengthMergedStaticString[T,N],i:int,base:StaticStringBase[T],l,r:int32) {.inline.}=
        assert l <= r
        assert i in 0..<N
        if i == 0:
            S.base = base
        else:
            assert S.base == base
        S.L[i] = l
        S.R[i] = r

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

    proc `&`*[T](S,U:StaticString[T]):FixedLengthMergedStaticString[T,2]=
        assert S.base == U.base
        result.setRange(0,S.base,S.l,S.r)
        result.setRange(1,U.base,U.l,U.r)

    template `&`*[T;N:static[int]](S:FixedLengthMergedStaticString[T,N],U:StaticString[T]):untyped=
        block:
            let left = S
            let right = U
            var merged: FixedLengthMergedStaticString[T,N+1]
            when N > 0:
                assert left.base == right.base
                merged.base = left.base
                for i in 0..<N:
                    merged.L[i] = left.L[i]
                    merged.R[i] = left.R[i]
            else:
                merged.base = right.base
            merged.L[N] = right.l
            merged.R[N] = right.r
            merged

    proc initFixedLengthMergedStaticString*[T;N:static[int]](S:array[N,StaticString[T]]):FixedLengthMergedStaticString[T,N]=
        for i,value in S:
            result.setRange(i,value.base,value.l,value.r)

    proc initFixedLengthMergedStaticString*[T;N:static[int]](S:StaticString[T],ranges:array[N,(int,int)]):FixedLengthMergedStaticString[T,N]=
        for i,interval in ranges:
            let (l,r) = interval
            assert 0 <= l and l <= r and r <= len(S)
            result.setRange(i,S.base,S.l+l.int32(),S.l+r.int32())

    template `&`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):untyped=
        block:
            let left = S
            let right = U
            var merged: FixedLengthMergedStaticString[T,N+M]
            when N > 0 and M > 0:
                assert left.base == right.base
            when N > 0:
                merged.base = left.base
                for i in 0..<N:
                    merged.L[i] = left.L[i]
                    merged.R[i] = left.R[i]
            elif M > 0:
                merged.base = right.base
            for i in 0..<M:
                merged.L[N+i] = right.L[i]
                merged.R[N+i] = right.R[i]
            merged

    proc len*[T;N:static[int]](S:FixedLengthMergedStaticString[T,N]):int=
        ## O(N), where N is the number of concatenated ranges.
        for i in 0..<N:
            result += int(S.R[i]-S.L[i])

    proc `[]`*[T;N:static[int]](S:FixedLengthMergedStaticString[T,N],idx:int):T=
        assert idx in 0..<len(S)
        var relativeIndex = idx
        for i in 0..<N:
            let chunkLength = int(S.R[i]-S.L[i])
            if relativeIndex < chunkLength:
                return S.base.S[S.L[i]+relativeIndex]
            relativeIndex -= chunkLength
        assert false
        return default(T)

    proc `[]`*[T;N:static[int]](S:FixedLengthMergedStaticString[T,N],slice:HSlice[int,int]):FixedLengthMergedStaticString[T,N]=
        assert 0 <= slice.a and slice.a <= slice.b+1 and slice.b < len(S)
        result.base = S.base
        var previousLength = 0
        for i in 0..<N:
            let currentLength = previousLength+int(S.R[i]-S.L[i])
            let left = max(previousLength,slice.a)
            let right = min(currentLength,slice.b+1)
            if left < right:
                result.L[i] = S.L[i]+(left-previousLength).int32()
                result.R[i] = S.L[i]+(right-previousLength).int32()
            else:
                result.L[i] = S.L[i]
                result.R[i] = S.L[i]
            previousLength = currentLength

    proc lcp*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):int=
        if N == 0 or M == 0:
            return 0
        assert S.base == U.base
        var si = 0
        var ui = 0
        var sl = S.L[0]
        var sr = S.R[0]
        var ul = U.L[0]
        var ur = U.R[0]
        while true:
            let slen = int(sr-sl)
            let ulen = int(ur-ul)
            let tmp = lcpRange(S.base,sl,sr,ul,ur)
            if tmp == slen and tmp == ulen:
                si += 1
                ui += 1
                result += tmp
                if si == N or ui == M:
                    return result
                sl = S.L[si]
                sr = S.R[si]
                ul = U.L[ui]
                ur = U.R[ui]
            elif tmp == slen:
                si += 1
                result += tmp
                if si == N:
                    return result
                sl = S.L[si]
                sr = S.R[si]
                ul += tmp.int32()
            elif tmp == ulen:
                ui += 1
                result += tmp
                if ui == M:
                    return result
                sl += tmp.int32()
                ul = U.L[ui]
                ur = U.R[ui]
            else:
                return result+tmp

    proc cmp*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):int=
        var si = 0
        var ui = 0
        var sl = when N > 0: S.L[0] else: 0'i32
        var ul = when M > 0: U.L[0] else: 0'i32
        while true:
            while si < N and sl == S.R[si]:
                si += 1
                if si < N:
                    sl = S.L[si]
            while ui < M and ul == U.R[ui]:
                ui += 1
                if ui < M:
                    ul = U.L[ui]
            if si == N:
                if ui == M:
                    return 0
                return -1
            if ui == M:
                return 1
            assert S.base == U.base
            let limit = min(int(S.R[si]-sl),int(U.R[ui]-ul))
            let commonPrefix = lcpRange(S.base,sl,S.R[si],ul,U.R[ui])
            if commonPrefix < limit:
                if S.base.S[sl+commonPrefix.int32()] < U.base.S[ul+commonPrefix.int32()]:
                    return -1
                return 1
            sl += commonPrefix.int32()
            ul += commonPrefix.int32()

    proc `<`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):bool=
        return cmp(S,U) < 0

    proc `>`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):bool=
        return cmp(S,U) > 0

    proc `<=`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):bool=
        return cmp(S,U) <= 0

    proc `>=`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):bool=
        return cmp(S,U) >= 0

    proc `==`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):bool=
        return len(S) == len(U) and lcp(S,U) == len(S)

    proc `$`*[T;N:static[int]](S:FixedLengthMergedStaticString[T,N]):string=
        when T is char:
            for i in 0..<N:
                for j in S.L[i]..<S.R[i]:
                    result.add(S.base.S[j])
        else:
            var first = true
            for i in 0..<N:
                for j in S.L[i]..<S.R[i]:
                    if not first:
                        result &= " "
                    first = false
                    result &= $S.base.S[j]
