when not declared CPLIB_STR_ZALGORITHM:
    const CPLIB_STR_ZALGORITHM* = 1
    import sequtils
    proc zalgorithm*[T](S: openArray[T]): seq[int] =
        var N = len(S)
        result = newseqwith(N, -1)
        if N == 0:
            return
        result[0] = N
        var i = 1
        var j = 0
        while (i < N):
            while (i+j < N and S[j] == S[i+j]):
                j += 1
            result[i] = j
            if j == 0:
                i += 1
                continue
            var k = 1
            while (i+k < N and k+result[k] < j):
                result[i+k] = result[k]
                k += 1
            i += k
            j -= k
