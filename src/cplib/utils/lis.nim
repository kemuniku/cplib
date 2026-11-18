when not declared CPLIB_UTILS_LIS:
    const CPLIB_UTILS_LIS* = 1
    import algorithm
    proc lisLowerBound[T](a: openArray[T], key: T): int {.inline.} =
        ## 比較関数を直接呼び、key 以上の最初の位置を二分探索します。
        var count = a.len
        while count != 0:
            let step = count shr 1
            let pos = result + step
            if cmp[T](a[pos], key) < 0:
                result = pos + 1
                count -= step + 1
            else:
                count = step

    proc lis*[T](a: openArray[T]): int =
        ## 狭義単調増加部分列の最大長を O(N log N) で求めます。
        var dp = newSeq[T]()
        for i in 0..<a.len:
            var pos = lisLowerBound(dp, a[i])
            if pos == dp.len: dp.add(a[i])
            else: dp[pos] = a[i]
        return dp.len

    proc restore_lis*[T](a: openArray[T]): seq[T] =
        ## 狭義単調増加部分列を従来と同じ順序で復元します。O(N log N)。
        var p = newSeq[int](a.len)
        var dp = newSeq[T]()
        for i in 0..<a.len:
            var pos = lisLowerBound(dp, a[i])
            if pos == dp.len: dp.add(a[i])
            else: dp[pos] = a[i]
            p[i] = pos
        result = newSeq[T]()
        var t = dp.len - 1
        for i in countdown(a.len - 1, 0):
            if p[i] == t:
                result.add(a[i])
                t -= 1
        result.reverse

    proc restore_lis_index*[T](a: openArray[T]): seq[int] =
        ## 狭義単調増加部分列の添字を復元します。O(N log N)。
        var p = newSeq[int](a.len)
        var dp = newSeq[T]()
        for i in 0..<a.len:
            var pos = lisLowerBound(dp, a[i])
            if pos == dp.len: dp.add(a[i])
            else: dp[pos] = a[i]
            p[i] = pos
        result = newSeq[int]()
        var t = dp.len - 1
        for i in countdown(a.len - 1, 0):
            if p[i] == t:
                result.add(i)
                t -= 1
        result.reverse
