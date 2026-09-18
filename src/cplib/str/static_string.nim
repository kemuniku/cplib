when not declared CPLIB_STR_STATIC_STRING:
    const CPLIB_STR_STATIC_STRING* = 1
    import cplib/utils/backwards_index
    import sequtils
    import algorithm
    import cplib/str/suffix_array
    import cplib/collections/staticRMQ

    proc genericSuffixArray[T](S: seq[T]): seq[int] =
        ## char列は O(N + 256)、それ以外は座標圧縮を含め O(N log N) で接尾辞配列を作る。
        when T is char:
            return suffix_array(S)
        var idx = toSeq(0..<len(S))
        idx.sort(proc(l, r: int): int = system.cmp[T](S[l], S[r]))
        var compressed = newSeq[int](len(S))
        var upper = 0
        for i in 0..<len(S):
            if i > 0 and S[idx[i-1]] != S[idx[i]]:
                upper += 1
            compressed[idx[i]] = upper
        return suffix_array(compressed, upper)

    type StaticStringBase*[T] = ref object
        S*: seq[T]
        RMQ*: StaticRMQ[int32]
        SA*: seq[int32]
        RSA*: seq[int32]
        LCP*: seq[int32]
        size*: int32
        reversible*: bool
    type StaticString*[T] = object
        base*: StaticStringBase[T]
        l*: int32
        r*: int32
    proc initStaticStringBase*[T](S: openArray[T], reversible: bool = false): StaticStringBase[T] =
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
        if result.S.len > 0:
            result.LCP = lcp_array(result.S, result.SA.mapIt(int(it))).mapit(int32(it))
        result.RMQ = initRMQ(result.LCP)

    proc initStaticStringBase*(S: string, reversible: bool = false): StaticStringBase[char] =
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
        if staticS.len > 0:
            result.LCP = lcp_array(staticS, result.SA.mapIt(int(it))).mapit(int32(it))
        result.RMQ = initRMQ(result.LCP)

    proc toStaticString*[T](S: openArray[T], reversible: bool = false): StaticString[T] =
        var base = initStaticStringBase(S, reversible)
        return StaticString[T](base: base, l: 0, r: len(S).int32())

    proc toStaticString*(S: string, reversible: bool = false): StaticString[char] =
        var base = initStaticStringBase(S, reversible)
        return StaticString[char](base: base, l: 0, r: len(S).int32())

    proc len*[T](S: StaticString[T]): int {.inline.} = S.r - S.l

    proc `[]`*[T](S: StaticString[T], idx: Natural): T {.backwardsIndex.} =
        assert idx < len(S), "指定した値が有効な範囲内である必要があります: idx < len(S)"
        return S.base.S[S.l+idx]

    proc `[]`*[T](S: StaticString[T], slice: HSlice[int, int]): StaticString[T] =
        assert slice.a <= slice.b+1 and S.l + slice.b < S.r, "指定した区間が有効な範囲内である必要があります: slice.a <= slice.b + 1 and S.l + slice.b < S.r"
        return StaticString[T](base: S.base, l: S.l+slice.a.int32(), r: S.l+slice.b.int32()+1)


    proc `$`*[T](S: StaticString[T]): string =
        when T is char:
            result = newString(len(S))
            for i in 0..<len(S):
                result[i] = S[i]
        else:
            for i in 0..<len(S):
                if i > 0:
                    result &= " "
                result &= $S[i]

    proc lcp*[Element](S, T: StaticString[Element]): int {.inline.} =
        assert S.base == T.base, "文字列は同じ基底文字列から作成されている必要があります"
        result = min(len(S), len(T))
        if result == 0:
            return
        var l = S.base.RSA[S.l]
        var r = S.base.RSA[T.l]
        if l > r:
            swap(l, r)
        elif l == r:
            return
        result = min(result, S.base.RMQ.query(l, r))

    proc reversed*[T](S: StaticString[T]): StaticString[T] {.inline.} =
        assert S.base.reversible, "反転を使うにはreversibleを有効にして初期化する必要があります"
        result.base = S.base
        result.l = 2*S.base.size-S.r
        result.r = 2*S.base.size-S.l

    proc isPalindrome*[T](S: StaticString[T]): bool {.inline.} =
        assert S.base.reversible, "反転を使うにはreversibleを有効にして初期化する必要があります"
        return lcp(S, S.reversed) == len(S)

    proc lcs*[Element](S, T: StaticString[Element]): int {.inline.} =
        assert S.base == T.base, "文字列は同じ基底文字列から作成されている必要があります"
        assert S.base.reversible, "反転を使うにはreversibleを有効にして初期化する必要があります"
        return lcp(S.reversed, T.reversed)

    proc cmp*[Element](S, T: StaticString[Element]): int {.inline.} =
        ## 同じ基底の部分文字列をLCPと接尾辞順位で辞書順に比較する。O(1)。
        assert S.base == T.base, "文字列は同じ基底文字列から作成されている必要があります"
        let n = min(len(S), len(T))
        if n == 0 or S.l == T.l:
            return system.cmp(len(S), len(T))
        let a = S.base.RSA[S.l]
        let b = S.base.RSA[T.l]
        if S.base.RMQ.query(min(a, b), max(a, b)) >= n:
            return system.cmp(len(S), len(T))
        return (if a < b: -1 else: 1)

    proc `<`*[Element](S, T: StaticString[Element]): bool =
        return cmp(S, T) < 0

    proc `>`*[Element](S, T: StaticString[Element]): bool =
        return cmp(S, T) > 0

    proc `<=`*[Element](S, T: StaticString[Element]): bool =
        return cmp(S, T) <= 0

    proc `>=`*[Element](S, T: StaticString[Element]): bool =
        return cmp(S, T) >= 0

    proc `==`*[Element](S, T: StaticString[Element]): bool =
        return len(S) == len(T) and lcp(S, T) == len(S)

    proc sortStaticStrings*[T](strings: var openArray[StaticString[T]]) =
        ## 同じ基底の部分文字列を辞書順に安定ソートする。基底長M、要素数Nに対しO(N log(M+2))時間、追加O(N)空間。
        if strings.len == 0: return
        let base = strings[0].base
        type Key = tuple[rank, length: int32, index: int]
        var keys = newSeq[Key](strings.len)
        for i, s in strings:
            assert s.base == base, "文字列は同じ基底文字列から作成されている必要があります"
            var left = 0
            if s.len > 0:
                let rank = int(base.RSA[s.l])
                var right = rank
                while left < right:
                    let mid = (left + right) shr 1
                    if base.RMQ.query(mid, rank) >= s.len:
                        right = mid
                    else:
                        left = mid + 1
                inc left
            keys[i] = (int32(left), int32(s.len), i)
        var buffer = newSeq[Key](keys.len)
        for field in 0..1:
            for shift in countup(0, 24, 8):
                var counts: array[256, int]
                for key in keys:
                    let value = if field == 0: key.length else: key.rank
                    inc counts[(int(value) shr shift) and 255]
                var total = 0
                for i in 0..<256:
                    let count = counts[i]
                    counts[i] = total
                    total += count
                for key in keys:
                    let value = if field == 0: key.length else: key.rank
                    let digit = (int(value) shr shift) and 255
                    buffer[counts[digit]] = key
                    inc counts[digit]
                swap(keys, buffer)
        var output = newSeq[StaticString[T]](strings.len)
        for i, key in keys:
            output[i] = strings[key.index]
        for i in 0..<strings.len:
            strings[i] = output[i]

    proc initSuffixArray*[T](base: StaticStringBase[T]): seq[StaticString[T]] =
        var SA = base.SA
        if base.reversible:
            SA = genericSuffixArray(base.S[0..<base.size]).mapit(int32(it))
        result = newseq[StaticString[T]](base.size)
        for i in 0..<base.size:
            result[i].base = base
            result[i].l = SA[i]
            result[i].r = base.size

    proc initSuffixArray*[T](S: StaticString[T]): seq[StaticString[T]] =
        var SA = genericSuffixArray(S.base.S[S.l..<S.r]).mapit(int32(it))
        result = newseq[StaticString[T]](len(SA))
        for i in 0..<len(SA):
            result[i].base = S.base
            result[i].l = SA[i]+S.l
            result[i].r = S.r

    proc toStaticStrings*(strings: openArray[string], reversible: bool = false): seq[StaticString[char]] =
        var tmp = ""
        for i in 0..<len(strings):
            tmp &= strings[i]
            tmp &= '$'
        var base = initStaticStringBase(tmp, reversible)
        result = newseq[StaticString[char]](len(strings))
        var now = int32(0)
        for i in 0..<len(strings):
            result[i].base = base
            result[i].l = now
            result[i].r = now+len(strings[i]).int32()
            now += len(strings[i]).int32() + 1

    proc startsWith*[T](s, prefix: StaticString[T]): bool =
        return lcp(s, prefix) == len(prefix)


    proc suffix_lowerbound*[T](base: StaticStringBase[T], S: openArray[T]): int =
        assert not base.reversible, "この操作にはreversibleを無効にした文字列が必要です"
        proc cmp(x: int32, s: openArray[T]): int =
            for i in 0..<len(s):
                if i+x >= base.size: return -1
                if base.S[i+x] < s[i]: return -1
                if base.S[i+x] > s[i]: return 1
            return 0
        return base.SA.lowerBound(S, cmp)

    proc suffix_upperbound*[T](base: StaticStringBase[T], S: openArray[T]): int =
        assert not base.reversible, "この操作にはreversibleを無効にした文字列が必要です"
        proc cmp(x: int32, s: openArray[T]): int =
            for i in 0..<len(s):
                if i+x >= base.size: return -1
                if base.S[i+x] < s[i]: return -1
                if base.S[i+x] > s[i]: return 1
            return 0
        return base.SA.upperBound(S, cmp)

    proc count*[T](base: StaticStringBase[T], S: openArray[T]): int =
        assert not base.reversible, "この操作にはreversibleを無効にした文字列が必要です"
        return base.suffix_upperbound(S) - base.suffix_lowerbound(S)
