when not declared CPLIB_STR_SUFFIX_ARRAY:
    const CPLIB_STR_SUFFIX_ARRAY* = 1

    import algorithm

    # 公開 API で前提条件を確認し、内部のチェックはデバッグビルドで行います。
    when defined(release):
        {.push checks: off.}

    proc saIsImpl[T; I: SomeSignedInt](s: openArray[T], upper: int): seq[I] =
        ## SA-IS で、値域が 0..upper の整数列の接尾辞配列を作成します。
        let n = s.len
        if n == 0:
            return @[]
        if n == 1:
            return @[I(0)]
        if n == 2:
            if s[0] < s[1]:
                return @[I(0), I(1)]
            return @[I(1), I(0)]

        # isS は L-type を 0、S-type を 1、LMS を 2 で表します。
        var isS = newSeq[uint8](n)
        var bucket = newSeq[I](upper + 2)
        inc bucket[s[n - 1].int + 1]
        var i = n - 2
        while i >= 0:
            let c = s[i].int
            if s[i] == s[i + 1]:
                isS[i] = isS[i + 1]
            elif s[i] < s[i + 1]:
                isS[i] = 1
            inc bucket[c + 1]
            dec i
        for c in 0..upper:
            bucket[c + 1] += bucket[c]

        var sa = newSeq[I](n)
        var buf = newSeq[I](upper + 1)

        template induce(lms: openArray[I]) =
            ## LMS 接尾辞から L-type と S-type の接尾辞を誘導します。
            var j: int
            for j in 0..<n:
                sa[j] = -1

            for j in 0..upper:
                buf[j] = bucket[j + 1]
            j = lms.len - 1
            while j >= 0:
                let d = lms[j]
                let c = s[d].int
                dec buf[c]
                sa[buf[c]] = d
                dec j

            for j in 0..upper:
                buf[j] = bucket[j]
            sa[buf[s[n - 1].int]] = I(n - 1)
            inc buf[s[n - 1].int]
            j = 0
            while j < n:
                let v = sa[j]
                # この段階の接尾辞は LMS または L-type なので、隣の文字で判定できます。
                if v >= 1 and s[v - 1] >= s[v]:
                    sa[buf[s[v - 1].int]] = v - 1
                    inc buf[s[v - 1].int]
                inc j

            for j in 0..upper:
                buf[j] = bucket[j + 1]
            j = n - 1
            while j >= 0:
                let v = sa[j]
                if v >= 1 and isS[v - 1] != 0:
                    dec buf[s[v - 1].int]
                    sa[buf[s[v - 1].int]] = v - 1
                dec j

        # LMS は隣接しないため、位置表は半分の長さで足ります。
        var lmsMap = newSeq[I]((n + 1) div 2)
        var lms = newSeqOfCap[I](n div 2)
        i = 1
        while i < n:
            if isS[i - 1] == 0 and isS[i] != 0:
                lmsMap[i shr 1] = I(lms.len)
                lms.add(I(i))
                isS[i] = 2
            inc i
        let m = lms.len

        induce(lms)

        if m > 1:
            var sortedLms = newSeqOfCap[I](m)
            for v in sa:
                if v > 0 and isS[v] == 2:
                    sortedLms.add(v)

            var recS = newSeq[I](m)
            var recUpper = 0
            recS[lmsMap[sortedLms[0] shr 1]] = 0

            i = 1
            while i < m:
                let left = sortedLms[i - 1]
                let right = sortedLms[i]
                let endLeft = if lmsMap[left shr 1] + 1 < m:
                    lms[lmsMap[left shr 1] + 1]
                else:
                    I(n)
                let endRight = if lmsMap[right shr 1] + 1 < m:
                    lms[lmsMap[right shr 1] + 1]
                else:
                    I(n)

                var same = endLeft < n and endRight < n and
                    endLeft - left == endRight - right
                if same:
                    let length = endLeft - left
                    var d = 0
                    while d < length:
                        if s[left + d] != s[right + d]:
                            same = false
                            break
                        inc d

                    # 次の LMS の先頭文字まで含めて LMS 部分文字列を比較します。
                    if same and s[endLeft] != s[endRight]:
                        same = false

                if not same:
                    inc recUpper
                recS[lmsMap[right shr 1]] = I(recUpper)
                inc i

            if recUpper + 1 < m:
                let recSa = saIsImpl[I, I](recS, recUpper)
                i = 0
                while i < m:
                    sortedLms[i] = lms[recSa[i]]
                    inc i
            induce(sortedLms)

        return move(sa)

    when defined(release):
        {.pop.}

    proc saIs[T](s: openArray[T], upper: int): seq[int] =
        ## 通常の長さでは作業配列を 32-bit にしてメモリ使用量を抑えます。
        when sizeof(int) > sizeof(int32):
            if s.len <= int32.high.int:
                let sa = saIsImpl[T, int32](s, upper)
                result = newSeq[int](sa.len)
                for i in 0..<sa.len:
                    result[i] = sa[i].int
                return
        return saIsImpl[T, int](s, upper)

    proc suffix_array*(s: openArray[int], upper: int): seq[int] =
        ## 0..upper の整数列の接尾辞配列を O(N + upper) で作成します。
        assert upper >= 0
        for value in s:
            assert 0 <= value and value <= upper
        return saIs(s, upper)

    proc suffix_array*[T](s: openArray[T]): seq[int] =
        ## 任意の比較可能な列の接尾辞配列を作成します。
        ## 値の座標圧縮にソートを使うため、SA-IS 部分を含めた計算量は O(N log N) です。
        let n = s.len
        if n == 0:
            return @[]

        var idx = newSeq[int](n)
        for i in 0..<n:
            idx[i] = i
        let values = @s
        idx.sort(proc(l, r: int): int = system.cmp(values[l], values[r]))

        var compressed = newSeq[int](n)
        var upper = 0
        for i in 0..<n:
            if i > 0 and s[idx[i - 1]] != s[idx[i]]:
                inc upper
            compressed[idx[i]] = upper
        return saIs(compressed, upper)

    proc suffix_array*(s: string): seq[int] =
        ## 8-bit 文字列の接尾辞配列を SA-IS で O(N + 256) に作成します。
        return saIs(s, 255)

    when defined(release):
        {.push checks: off.}

    proc lcpArrayImpl[T; I: SomeSignedInt](s: openArray[T], sa: openArray[int]): seq[int] =
        ## 辞書順の直前の接尾辞を使い、文字列順に LCP を計算します。
        let n = s.len
        var phi = newSeq[I](n)
        phi[sa[0]] = -1
        for i in 1..<n:
            phi[sa[i]] = I(sa[i - 1])
        var h = 0
        for i in 0..<n:
            let j = phi[i].int
            if j < 0:
                h = 0
                continue
            let limit = n - max(i, j)
            while h < limit and s[i + h] == s[j + h]:
                inc h
            phi[i] = I(h)
            if h > 0:
                dec h
        result = newSeq[int](n - 1)
        for i in 0..<n - 1:
            result[i] = phi[sa[i + 1]].int

    when defined(release):
        {.pop.}

    proc lcp_array*[T](s: openArray[T], sa: openArray[int]): seq[int] =
        ## 接尾辞配列に隣接する接尾辞同士の LCP Array を O(N) で作成します。
        let n = s.len
        assert sa.len == n
        if n <= 1:
            return @[]
        for v in sa:
            assert 0 <= v and v < n
        when sizeof(int) > sizeof(int32):
            if n <= int32.high.int:
                return lcpArrayImpl[T, int32](s, sa)
        return lcpArrayImpl[T, int](s, sa)

    proc lcp_array*(s: string, sa: openArray[int]): seq[int] =
        ## 文字列の接尾辞配列に隣接する接尾辞同士の LCP Array を作成します。
        return lcp_array[char](s, sa)
