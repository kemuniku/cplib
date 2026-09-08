when not declared CPLIB_STR_SUFFIX_ARRAY:
    const CPLIB_STR_SUFFIX_ARRAY* = 1

    import algorithm, sequtils

    # LMS 部分文字列の比較で、長い等値区間だけを AVX2 で比較します。
    when defined(cpp) and defined(amd64) and (defined(gcc) or defined(clang)):
        {.emit: """
        #ifndef CPLIB_STR_SUFFIX_ARRAY_AVX2_HPP
        #define CPLIB_STR_SUFFIX_ARRAY_AVX2_HPP

        #include <immintrin.h>
        #include <stddef.h>
        #include <stdint.h>

        #if defined(__GNUC__) || defined(__clang__)
        #define CPLIB_SA_AVX2 __attribute__((target("avx2")))
        #else
        #define CPLIB_SA_AVX2
        #endif

        static inline bool cplib_sa_avx2_available() {
        #if defined(__GNUC__) || defined(__clang__)
            return __builtin_cpu_supports("avx2");
        #else
            return false;
        #endif
        }

        CPLIB_SA_AVX2 static inline bool cplib_sa_equal_avx2(
                const void *raw_s, size_t l, size_t r, size_t length) {
            const int64_t *s = reinterpret_cast<const int64_t *>(raw_s);
            size_t i = 0;
            for (; i + 4 <= length; i += 4) {
                const __m256i left = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i *>(s + l + i));
                const __m256i right = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i *>(s + r + i));
                const __m256i equal = _mm256_cmpeq_epi64(left, right);
                if (_mm256_movemask_epi8(equal) != -1) return false;
            }
            for (; i < length; ++i) {
                if (s[l + i] != s[r + i]) return false;
            }
            return true;
        }

        #undef CPLIB_SA_AVX2
        #endif
        """.}

        proc saAvx2Available(): bool
            {.importc: "cplib_sa_avx2_available", nodecl.}
        proc saEqualAvx2(s: ptr int, l, r, length: csize_t): bool
            {.importc: "cplib_sa_equal_avx2", nodecl.}

    proc saIs(s: seq[int], upper: int): seq[int] =
        ## SA-IS で、値域が 0..upper の整数列の接尾辞配列を作成します。
        let n = s.len
        if n == 0:
            return @[]
        if n == 1:
            return @[0]
        if n == 2:
            if s[0] < s[1]:
                return @[0, 1]
            return @[1, 0]

        # isS[i] は i 番目が S-type であることを表します。
        var isS = newSeq[uint8](n)
        var i = n - 2
        while i >= 0:
            if s[i] == s[i + 1]:
                isS[i] = isS[i + 1]
            elif s[i] < s[i + 1]:
                isS[i] = 1
            dec i

        # sumS は各バケットの S-type 側の開始位置、sumL は L-type 側の開始位置です。
        var sumL = newSeq[int](upper + 1)
        var sumS = newSeq[int](upper + 1)
        i = 0
        while i < n:
            if isS[i] == 0:
                inc sumS[s[i]]
            else:
                inc sumL[s[i] + 1]
            inc i
        i = 0
        while i <= upper:
            sumS[i] += sumL[i]
            if i < upper:
                sumL[i + 1] += sumS[i]
            inc i

        var sa = newSeq[int](n)
        var buf = newSeq[int](upper + 1)

        proc induce(lms: openArray[int]) =
            ## LMS 接尾辞から L-type と S-type の接尾辞を誘導します。
            var j: int
            for j in 0..<n:
                sa[j] = -1

            for j in 0..upper:
                buf[j] = sumS[j]
            for d in lms:
                if d != n:
                    sa[buf[s[d]]] = d
                    inc buf[s[d]]

            for j in 0..upper:
                buf[j] = sumL[j]
            sa[buf[s[n - 1]]] = n - 1
            inc buf[s[n - 1]]
            j = 0
            while j < n:
                let v = sa[j]
                if v >= 1 and isS[v - 1] == 0:
                    sa[buf[s[v - 1]]] = v - 1
                    inc buf[s[v - 1]]
                inc j

            for j in 0..upper:
                buf[j] = sumL[j]
            j = n - 1
            while j >= 0:
                let v = sa[j]
                if v >= 1 and isS[v - 1] != 0:
                    dec buf[s[v - 1] + 1]
                    sa[buf[s[v - 1] + 1]] = v - 1
                dec j

        var lmsMap = newSeqWith(n + 1, -1)
        var m = 0
        i = 1
        while i < n:
            if isS[i - 1] == 0 and isS[i] != 0:
                lmsMap[i] = m
                inc m
            inc i

        var lms = newSeqOfCap[int](m)
        i = 1
        while i < n:
            if isS[i - 1] == 0 and isS[i] != 0:
                lms.add(i)
            inc i

        induce(lms)

        if m != 0:
            var sortedLms = newSeqOfCap[int](m)
            for v in sa:
                if v >= 0 and lmsMap[v] != -1:
                    sortedLms.add(v)

            var recS = newSeq[int](m)
            var recUpper = 0
            recS[lmsMap[sortedLms[0]]] = 0

            when defined(cpp) and defined(amd64) and (defined(gcc) or defined(clang)):
                let useAvx2 = saAvx2Available()

            i = 1
            while i < m:
                let left = sortedLms[i - 1]
                let right = sortedLms[i]
                let endLeft = if lmsMap[left] + 1 < m:
                    lms[lmsMap[left] + 1]
                else:
                    n
                let endRight = if lmsMap[right] + 1 < m:
                    lms[lmsMap[right] + 1]
                else:
                    n

                var same = endLeft - left == endRight - right
                if same:
                    let length = endLeft - left
                    when defined(cpp) and defined(amd64) and (defined(gcc) or defined(clang)):
                        if useAvx2:
                            same = saEqualAvx2(unsafeAddr s[0], left.csize_t,
                                right.csize_t, length.csize_t)
                        else:
                            var d = 0
                            while d < length:
                                if s[left + d] != s[right + d]:
                                    same = false
                                    break
                                inc d
                    else:
                        var d = 0
                        while d < length:
                            if s[left + d] != s[right + d]:
                                same = false
                                break
                            inc d

                    # 次の LMS の先頭文字まで含めて LMS 部分文字列を比較します。
                    if same and endLeft < n and s[endLeft] != s[endRight]:
                        same = false

                if not same:
                    inc recUpper
                recS[lmsMap[right]] = recUpper
                inc i

            let recSa = saIs(recS, recUpper)
            i = 0
            while i < m:
                sortedLms[i] = lms[recSa[i]]
                inc i
            induce(sortedLms)

        return sa

    proc suffix_array*(s: openArray[int], upper: int): seq[int] =
        ## 0..upper の整数列の接尾辞配列を O(N + upper) で作成します。
        assert upper >= 0
        for value in s:
            assert 0 <= value and value <= upper
        return saIs(@s, upper)

    proc suffix_array*[T](s: openArray[T]): seq[int] =
        ## 任意の比較可能な列の接尾辞配列を作成します。
        ## 値の座標圧縮にソートを使うため、SA-IS 部分を含めた計算量は O(N log N) です。
        let n = s.len
        if n == 0:
            return @[]

        var idx = newSeq[int](n)
        for i in 0..<n:
            idx[i] = i
        idx.sort(proc(l, r: int): int = system.cmp(s[l], s[r]))

        var compressed = newSeq[int](n)
        var upper = 0
        for i in 0..<n:
            if i > 0 and s[idx[i - 1]] != s[idx[i]]:
                inc upper
            compressed[idx[i]] = upper
        return saIs(compressed, upper)

    proc suffix_array*(s: string): seq[int] =
        ## 8-bit 文字列の接尾辞配列を SA-IS で O(N + 256) に作成します。
        var values = newSeq[int](s.len)
        for i in 0..<s.len:
            values[i] = ord(s[i])
        return saIs(values, 255)
