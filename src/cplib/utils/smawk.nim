when not declared CPLIB_UTILS_SMAWK:
    const CPLIB_UTILS_SMAWK* = 1

    proc smawk*[F](height, width: int, better: F): seq[int] =
        ## 全単調行列の各行の最小列を O(height + width) 回の比較で求める。
        ## better(row, oldCol, newCol) は新しい列が真に小さいとき true。
        ## 同値なら左端を返す。幅が 0 なら各行に -1 を返す。
        assert height >= 0 and width >= 0, "高さと幅は非負である必要があります"
        var answer = newSeq[int](height)
        if width == 0:
            for r in 0..<height: answer[r] = -1
            return answer
        if height == 0: return answer
        var capacity = width
        var count = height
        while count > 0:
            capacity += min(count, width)
            count = count div 2
        var columns = newSeq[int](capacity)
        for i in 0..<width: columns[i] = i
        proc solve(first, step, count, offset, width: int) =
            ## 行を等差数列で表し、列削減に共有配列を使う。時間 O(count + width)。
            let reduced = offset + width
            var size = 0
            for p in offset..<reduced:
                let col = columns[p]
                while size > 0 and better(first + (size - 1) * step, columns[reduced + size - 1], col):
                    dec size
                if size < count:
                    columns[reduced + size] = col
                    inc size
            if count > 1:
                solve(first + step, step * 2, count div 2, reduced, size)
            var left = 0
            var i = 0
            while i < count:
                let row = first + i * step
                let right = if i + 1 < count: answer[row + step]
                            else: columns[reduced + size - 1]
                var best = columns[reduced + left]
                while columns[reduced + left] < right:
                    inc left
                    let col = columns[reduced + left]
                    if better(row, best, col): best = col
                answer[row] = best
                i += 2
        solve(0, 1, height, 0, width)
        return answer
