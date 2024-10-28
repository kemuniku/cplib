when not declared CPLIB_STR_LCS:
    const CPLIB_STR_LCS* = 1
    import sequtils
    proc LCS*[T](A,B:seq[T]):int=
        var DP = newseqwith(len(B)+1,newSeqWith(len(A),0))
        for j in range(len(B)):
            var t = B[j]
            var now = 0
            for i in range(len(A)):
                if A[i] == t:
                    var tmp = DP[j][i]
                    DP[j+1][i] = now+1
                    now.max = tmp
                else:
                    DP[j+1][i] = DP[j][i]
                    now.max = DP[j][i]
        return DP[^1].max