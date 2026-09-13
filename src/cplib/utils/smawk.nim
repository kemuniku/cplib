when not declared CPLIB_UTILS_SMAWK:
    const CPLIB_UTILS_SMAWK* = 1

    proc smawk*[F](height, width: int, better: F): seq[int] =
        ## 全単調行列の各行の最小列を O(height + width) 回の比較で求める。
        ## better(row, oldCol, newCol) は新しい列が真に小さいとき true。
        ## 同値なら左端を返す。幅が 0 なら各行に -1 を返す。
        assert height >= 0 and width >= 0
        var answer = newSeq[int](height)
        for r in 0..<height: answer[r] = -1
        if height == 0 or width == 0: return answer
        proc solve(rows, columns: seq[int]) =
            ## 列削減と奇数行への再帰で行最小値を求める。
            if rows.len == 0: return
            var reduced = newSeqOfCap[int](min(rows.len, columns.len))
            for c in columns:
                while reduced.len > 0 and better(rows[reduced.len - 1], reduced[^1], c):
                    reduced.setLen(reduced.len - 1)
                if reduced.len < rows.len: reduced.add(c)
            var odd = newSeqOfCap[int](rows.len div 2)
            var i = 1
            while i < rows.len:
                odd.add(rows[i])
                i += 2
            solve(odd, reduced)
            var left = 0
            i = 0
            while i < rows.len:
                var right = reduced.len - 1
                if i + 1 < rows.len:
                    right = left
                    while reduced[right] != answer[rows[i + 1]]: inc right
                var best = left
                for j in left + 1..right:
                    if better(rows[i], reduced[best], reduced[j]): best = j
                answer[rows[i]] = reduced[best]
                left = right
                i += 2
        var rows = newSeq[int](height)
        var columns = newSeq[int](width)
        for i in 0..<height: rows[i] = i
        for i in 0..<width: columns[i] = i
        solve(rows, columns)
        return answer
