when not declared CPLIB_STR_ZALGORITHM:
    const CPLIB_STR_ZALGORITHM* = 1
    import sequtils
    proc zalgorithm*[T](S: seq[T]): seq[int] =
        var N = len(S)
        result = newseqwith(N,-1)
        result[0] = S.len();
        var i = 1
        var j = 0
        while (i < S.len()):
            while (i+j < S.len() and S[j] == S[i+j]):
                j += 1
            result[i] = j
            if j == 0:
                i += 1
                continue
            var k = 1
            while (i+k < S.len() and k+result[k] < j):
                result[i+k] = result[k]
                k += 1
            i += k
            j -= k

    proc zalgorithm*(S: string): seq[int] =
        var a = S.toSeq()
        return zalgorithm(a)