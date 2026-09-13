when not declared CPLIB_CONVOLUTION_BITWISE_AND_CONVOLUTION:
    const CPLIB_CONVOLUTION_BITWISE_AND_CONVOLUTION* = 1

    proc bitwiseAndConvolution*[T](a, b: seq[T]): seq[T] =
        ## c[k] = Σ_{i and j = k} a[i] * b[j] をO(N log N)時間・O(N)追加領域で求める。
        ## 入力は同じ長さの2冪の列とし、両方が空の場合は空列を返す。
        assert a.len == b.len, "畳み込む配列の長さは等しい必要があります"
        let n = a.len
        if n == 0:
            return @[]
        assert (n and (n - 1)) == 0, "配列の長さは2の冪である必要があります"
        result = a
        var right = b
        var bit = 1
        while bit < n:
            for mask in 0..<n:
                if (mask and bit) == 0:
                    result[mask] += result[mask or bit]
                    right[mask] += right[mask or bit]
            bit = bit shl 1
        for mask in 0..<n:
            result[mask] *= right[mask]
        bit = 1
        while bit < n:
            for mask in 0..<n:
                if (mask and bit) == 0:
                    result[mask] -= result[mask or bit]
            bit = bit shl 1
