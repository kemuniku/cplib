when not declared CPLIB_MATRIX_BIT_MATRIX_OPS:
    const CPLIB_MATRIX_BIT_MATRIX_OPS* = 1
    import options
    import cplib/matrix/field_matrix_ops

    proc initBitLinearSystem*(height, width: int): seq[uint64] =
        ## 右辺を含むh行(w+1)列の作業領域を確保する。O(h*(w div 64+1))。
        assert height >= 0 and width >= 0
        let stride = (width shr 6) + 1
        assert height <= high(int) div sizeof(uint64) div stride
        newSeq[uint64](height * stride)

    proc solveBitLinearSystem*(rows: var seq[uint64], height, width: int): Option[LinearSystemSolution[bool]] =
        ## 拡大行列を64bit単位で掃き出す。r=min(h,w)、L=w div 64+1としてO(h*r*L+w^2)。
        ## 各行はLワードで右辺はwidth列目。作業領域を変更し、解なしならnoneを返す。
        assert height >= 0 and width >= 0
        let stride = (width shr 6) + 1
        assert height <= high(int) div stride and rows.len == height * stride
        var pivots: seq[int]
        if height > 0:
            let data = cast[ptr UncheckedArray[uint64]](addr rows[0])
            for col in 0..<width:
                let rank = pivots.len
                if rank == height: break
                let firstWord = col shr 6
                let mask = 1'u64 shl (col and 63)
                var pivot = rank
                while pivot < height and (data[pivot * stride + firstWord] and mask) == 0:
                    inc pivot
                if pivot == height: continue
                let pivotRow = cast[ptr UncheckedArray[uint64]](addr data[rank * stride])
                # ピボット行の前の列はすべて零なので、現在のワード以降だけ操作する。
                if pivot != rank:
                    for k in firstWord..<stride:
                        swap(pivotRow[k], data[pivot * stride + k])
                for i in 0..<height:
                    if i == rank: continue
                    let row = cast[ptr UncheckedArray[uint64]](addr data[i * stride])
                    if (row[firstWord] and mask) != 0:
                        for k in firstWord..<stride: row[k] = row[k] xor pivotRow[k]
                pivots.add(col)
            let rhsWord = width shr 6
            let rhsMask = 1'u64 shl (width and 63)
            for i in pivots.len..<height:
                if (data[i * stride + rhsWord] and rhsMask) != 0:
                    return none(LinearSystemSolution[bool])

        var solution: LinearSystemSolution[bool]
        solution.particular = newSeq[bool](width)
        var isPivot = newSeq[bool](width)
        for i, col in pivots:
            isPivot[col] = true
            solution.particular[col] = ((rows[i * stride + (width shr 6)] shr (width and 63)) and 1) != 0
        for free in 0..<width:
            if isPivot[free]: continue
            var vector = newSeq[bool](width)
            vector[free] = true
            for i, col in pivots:
                vector[col] = ((rows[i * stride + (free shr 6)] shr (free and 63)) and 1) != 0
            solution.basis.add(vector)
        some(solution)
