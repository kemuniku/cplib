when not declared CPLIB_CONVOLUTION_MIN_PLUS_CONVOLUTION:
    ## c[k] = min(a[i] + b[j] | i+j=k) を返す。片方が空なら空列を返す。
    ## 凸は隣接差分が広義単調増加、凹は広義単調減少。前提の検査は行わない。
    ## すべての候補の和が T で表現可能であること。空間計算量は全 API で O(N + M)。
    const CPLIB_CONVOLUTION_MIN_PLUS_CONVOLUTION* = 1
    import cplib/utils/monotone_minima
    import cplib/utils/smawk

    proc minPlusConvolutionConvexConvex*[T](a, b: seq[T]): seq[T] =
        ## 凸数列同士の min-plus 畳み込みを O(N + M) 時間で求める。
        if a.len == 0 or b.len == 0: return @[]
        result = newSeq[T](a.len + b.len - 1)
        var i = 0
        var j = 0
        result[0] = a[0] + b[0]
        for k in 1..<result.len:
            if j + 1 == b.len or (i + 1 < a.len and a[i + 1] + b[j] < a[i] + b[j + 1]):
                inc i
            else:
                inc j
            result[k] = a[i] + b[j]

    proc convexArbitrary[T](a, b: seq[T], useSmawk: static[bool]): seq[T] =
        ## 凸な a と任意の b の畳み込みを指定された行最小値探索で求める。
        if a.len == 0 or b.len == 0: return @[]
        let h = a.len + b.len - 1
        proc better(row, oldCol, newCol: int): bool =
            ## 無効な列を比較値に変換せず、有効区間に近い列を優先する。
            if newCol > row: return false
            if oldCol > row: return true
            if oldCol < row - a.len + 1: return true
            if newCol < row - a.len + 1: return false
            return a[row - newCol] + b[newCol] < a[row - oldCol] + b[oldCol]
        when useSmawk:
            let indices = smawk(h, b.len, better)
        else:
            let indices = monotoneMinima(h, b.len, better)
        result = newSeq[T](h)
        for k in 0..<h: result[k] = a[k - indices[k]] + b[indices[k]]

    proc minPlusConvolutionConvexArbitraryMonotoneMinima*[T](a, b: seq[T]): seq[T] =
        ## 凸な a と任意の b の min-plus 畳み込み。時間 O((N + M) log(N + M))。
        convexArbitrary(a, b, false)

    proc minPlusConvolutionConvexArbitrarySmawk*[T](a, b: seq[T]): seq[T] =
        ## 凸な a と任意の b の min-plus 畳み込み。時間 O(N + M)。
        convexArbitrary(a, b, true)

    proc minPlusConvolutionConcaveConcave*[T](a, b: seq[T]): seq[T] =
        ## 凹数列同士の min-plus 畳み込みを候補区間の両端から O(N + M) 時間で求める。
        if a.len == 0 or b.len == 0: return @[]
        result = newSeq[T](a.len + b.len - 1)
        for k in 0..<result.len:
            let lo = max(0, k - b.len + 1)
            let hi = min(k, a.len - 1)
            result[k] = min(a[lo] + b[k - lo], a[hi] + b[k - hi])

    proc minPlusConvolutionConcaveArbitrary*[T](a, b: seq[T]): seq[T] =
        ## 凹な a と任意の b の min-plus 畳み込み。時間 O((N + M) log(N + M))、空間 O(N + M)。
        if a.len == 0 or b.len == 0: return @[]
        let h = a.len + b.len - 1
        var answer = newSeq[T](h)
        for k in 0..<h:
            let j = min(k, b.len - 1)
            answer[k] = a[k - j] + b[j]
        proc solve(top, bottom, left, right: int) =
            ## 有効領域と交わらない部分を除き、長方形を長辺方向に二分する。
            let t = max(top, left)
            let d = min(bottom, right + a.len - 1)
            let l = max(left, t - a.len + 1)
            let r = min(right, d)
            if t >= d or l >= r: return
            if r - 1 <= t and d - 1 < l + a.len:
                proc better(row, oldCol, newCol: int): bool =
                    ## 凹の場合は列を逆順にして全単調性を得る。
                    let x = r - 1 - oldCol
                    let y = r - 1 - newCol
                    return a[t + row - y] + b[y] < a[t + row - x] + b[x]
                let indices = smawk(d - t, r - l, better)
                for k in t..<d:
                    let j = r - 1 - indices[k - t]
                    answer[k] = min(answer[k], a[k - j] + b[j])
            elif d - t >= r - l:
                let mid = (t + d) div 2
                solve(t, mid, l, r)
                solve(mid, d, l, r)
            else:
                let mid = (l + r) div 2
                solve(t, d, l, mid)
                solve(t, d, mid, r)
        solve(0, h, 0, b.len)
        return answer
