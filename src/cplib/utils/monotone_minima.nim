when not declared CPLIB_UTILS_MONOTONE_MINIMA:
    const CPLIB_UTILS_MONOTONE_MINIMA* = 1

    proc monotoneMinima*[COMPARE](height, width: int, compare: COMPARE): seq[int] =
        ## Returns a minimum column for every row of a totally monotone matrix.
        ##
        ## `compare(row, left, right)` must return whether the element at
        ## `left` is no greater than the element at `right`. `left < right`
        ## always holds. Ties are resolved in favour of the left column.
        ## The complexity is O(width * log(height) + height).
        doAssert height >= 0 and width >= 0
        var ans = newSeq[int](height)
        if height == 0: return ans
        if width == 0:
            for i in 0..<height: ans[i] = -1
            return ans

        proc solve(rowBegin, rowEnd, colBegin, colEnd: int) =
            if rowBegin >= rowEnd: return
            let row = (rowBegin + rowEnd) div 2
            var argmin = colBegin
            for col in colBegin + 1..<colEnd:
                if not compare(row, argmin, col):
                    argmin = col
            ans[row] = argmin
            solve(rowBegin, row, colBegin, argmin + 1)
            solve(row + 1, rowEnd, argmin, colEnd)

        solve(0, height, 0, width)
        return ans

    proc monotoneMinimaByValue*[MATRIX](height, width: int,
            matrix: MATRIX): seq[int] =
        ## Value-based convenience wrapper for `monotoneMinima`.
        monotoneMinima(height, width, proc(row, left, right: int): bool =
            matrix(row, left) <= matrix(row, right)
        )
