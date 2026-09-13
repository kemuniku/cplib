when not declared CPLIB_UTILS_MONOTONE_MINIMA:
    const CPLIB_UTILS_MONOTONE_MINIMA* = 1

    proc monotoneMinima*[F](height, width: int, better: F): seq[int] =
        ## 左端最小列が広義単調増加する行列を O(height + width * log(height + 1)) 回の比較で探索する。
        ## better(row, oldCol, newCol) は新しい列が真に小さいとき true。幅 0 なら -1。
        assert height >= 0 and width >= 0, "高さと幅は非負である必要があります"
        var answer = newSeq[int](height)
        for r in 0..<height: answer[r] = -1
        if height == 0 or width == 0: return answer
        proc solve(top, bottom, left, right: int) =
            ## 中央行を探索し、最小列で上下の探索範囲を制限する。
            if top >= bottom: return
            let row = (top + bottom) div 2
            var best = left
            for col in left + 1..right:
                if better(row, best, col): best = col
            answer[row] = best
            solve(top, row, left, best)
            solve(row + 1, bottom, best, right)
        solve(0, height, 0, width - 1)
        return answer
