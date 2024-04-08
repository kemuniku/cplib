when not declared CPLIB_UTILS_LIS:
    const COMPETITIVE_UTILS_LIS* = 1
    import algorithm
    proc lis*[T](a: openArray[T]): int =
        var dp = newSeq[T]()
        for i in 0..<a.len:
            var pos = dp.lowerBound(a[i])
            if pos == dp.len: dp.add(a[i])
            else: dp[pos] = a[i]
        return dp.len

    proc restore_lis*[T](a: openArray[T]): seq[T] =
        var p = newSeq[int](a.len)
        var dp = newSeq[T]()
        for i in 0..<a.len:
            var pos = dp.lowerBound(a[i])
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
