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

    proc concaveSmawk[T](a, b: seq[T], first, step, count, offset, width: int,
                         columns, indices: var seq[int]) =
        ## 行を等差数列で表し、共有バッファ内で列を削減する。時間 O(count + width)。
        let reduced = offset + width
        var size = 0
        for p in offset..<reduced:
            let col = columns[p]
            while size > 0:
                let row = first + (size - 1) * step
                let old = columns[reduced + size - 1]
                if not (a[row - col] + b[col] < a[row - old] + b[old]): break
                dec size
            if size < count:
                columns[reduced + size] = col
                inc size
        if count > 1:
            concaveSmawk(a, b, first + step, step * 2, count div 2,
                         reduced, size, columns, indices)
        var left = 0
        var i = 0
        while i < count:
            let row = first + i * step
            var right = size - 1
            if i + 1 < count:
                right = left
                while columns[reduced + right] != indices[row + step]: inc right
            var best = columns[reduced + left]
            var value = a[row - best] + b[best]
            for p in left + 1..right:
                let col = columns[reduced + p]
                let candidate = a[row - col] + b[col]
                if candidate < value:
                    best = col
                    value = candidate
            indices[row] = best
            left = right
            i += 2

    proc concaveDivide[T](a, b: seq[T], top, bottom, left, right: int,
                          answer: var seq[T], columns, indices: var seq[int]) =
        ## 有効領域を長方形に分割し、作業配列を再利用して最小値を更新する。
        let t = max(top, left)
        let d = min(bottom, right + a.len - 1)
        let l = max(left, t - a.len + 1)
        let r = min(right, d)
        if t >= d or l >= r: return
        if d - t <= 1024 div (r - l):
            for row in t..<d:
                var value = answer[row]
                for col in max(l, row - a.len + 1)..<min(r, row + 1):
                    value = min(value, a[row - col] + b[col])
                answer[row] = value
        elif r - 1 <= t and d - 1 < l + a.len:
            for p in 0..<r - l: columns[p] = r - 1 - p
            concaveSmawk(a, b, t, 1, d - t, 0, r - l, columns, indices)
            for row in t..<d:
                let col = indices[row]
                answer[row] = min(answer[row], a[row - col] + b[col])
        elif d - t >= r - l:
            let mid = (t + d) div 2
            concaveDivide(a, b, t, mid, l, r, answer, columns, indices)
            concaveDivide(a, b, mid, d, l, r, answer, columns, indices)
        else:
            let mid = (l + r) div 2
            concaveDivide(a, b, t, d, l, mid, answer, columns, indices)
            concaveDivide(a, b, t, d, mid, r, answer, columns, indices)

    proc minPlusConvolutionConcaveArbitrary*[T](a, b: seq[T]): seq[T] =
        ## 凹な a と任意の b の min-plus 畳み込み。時間 O((N + M) log(N + M))、空間 O(N + M)。
        if a.len == 0 or b.len == 0: return @[]
        let h = a.len + b.len - 1
        result = newSeq[T](h)
        for k in 0..<h:
            let j = min(k, b.len - 1)
            result[k] = a[k - j] + b[j]
        if a.len == 1 or b.len == 1: return
        # 列削減後の長さは行数以下で、再帰ごとに行数が半減する。
        var columns = newSeq[int](b.len + 2 * h)
        var indices = newSeq[int](h)
        concaveDivide(a, b, 0, h, 0, b.len, result, columns, indices)
