when not declared CPLIB_STR_LCS:
    const CPLIB_STR_LCS* = 1
    import sequtils,algorithm
    proc LCS*[T](A,B:openArray[T]):int=
        ## 最長共通部分列の長さを O(|A||B|) 時間、O(|A|) 空間で求めます。
        if len(A) == 0 or len(B) == 0:
            return 0
        var DP = newSeq[int](len(A))
        for i in 0..<len(B):
            var t = B[i]
            var now = 0
            for j in 0..<len(A):
                let previous = DP[j]
                if A[j] == t:
                    DP[j] = now + 1
                if previous > now:
                    now = previous
        return DP.max

    proc restoreLCS*[T](A,B:openArray[T]):seq[T]=
        if len(A) == 0 or len(B) == 0:
            return newSeq[T](0)
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
