when not declared CPLIB_STR_LCS:
    const CPLIB_STR_LCS* = 1
    import sequtils,algorithm
    proc LCS*[T](A,B:seq[T]):int=
        var DP = newseqwith(len(B)+1,newSeqWith(len(A),0))
        for i in 0..<(len(B)):
            var t = B[i]
            var now = 0
            for j in 0..<(len(A)):
                if A[j] == t:
                    var tmp = DP[i][j]
                    DP[i+1][j] = now+1
                    if tmp > now:
                        now = tmp
                else:
                    DP[i+1][j] = DP[i][j]
                    if DP[i][j] > now:
                        now = DP[i][j]
        return DP[^1].max
    
    proc restoreLCS*[T](A,B:seq[T]):seq[T]=
        var DP = newseqwith(len(B)+1,newSeqWith(len(A),0))
        for i in 0..<(len(B)):
            var t = B[i]
            var now = 0
            for j in 0..<(len(A)):
                if A[j] == t:
                    var tmp = DP[i][j]
                    DP[i+1][j] = now+1
                    if tmp > now:
                        now = tmp
                else:
                    DP[i+1][j] = DP[i][j]
                    if DP[i][j] > now:
                        now = DP[i][j]
        var ans : seq[T]
        var now = DP[^1].maxindex()
        for i in countdown(len(B),1):
            if DP[i-1][now] == DP[i][now]:
                continue
            else:
                for j in countdown(now-1,0):
                    if DP[i-1][j] == DP[i][now]-1:
                        now = j
                        break
                ans.add(B[i-1])
        return ans.reversed()