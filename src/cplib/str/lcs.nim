when not declared CPLIB_STR_LCS:
    const CPLIB_STR_LCS* = 1
    import sequtils,algorithm
    proc LCS*[T](A,B:openArray[T]):int=
        if len(A) == 0 or len(B) == 0:
            return 0
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

    proc restoreLCSImpl[T; I: SomeSignedInt](A,B:openArray[T]):seq[T]=
        ## 指定した整数幅の DP 表で従来と同じ部分列を復元します。
        if len(A) == 0 or len(B) == 0:
            return newSeq[T](0)
        var DP = newseqwith(len(B)+1,newSeq[I](len(A)))
        for i in 0..<(len(B)):
            var t = B[i]
            var now: I = 0
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

    proc restoreLCS*[T](A,B:openArray[T]):seq[T]=
        ## 最長共通部分列を復元します。O(|A||B|) 時間・空間。
        if len(A) == 0 or len(B) == 0:
            return newSeq[T](0)
        if min(len(A), len(B)) <= int32.high.int:
            return restoreLCSImpl[T, int32](A, B)
        return restoreLCSImpl[T, int](A, B)
