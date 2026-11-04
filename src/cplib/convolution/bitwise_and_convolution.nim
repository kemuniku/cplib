when not declared CPLIB_CONVOLUTION_BITWISE_AND_CONVOLUTION:
    const CPLIB_CONVOLUTION_BITWISE_AND_CONVOLUTION* = 1

    # 長さと各段のループ範囲で添字が配列内にあることを保証する。
    {.push boundChecks: off.}
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
            var base = 0
            while base < n:
                for offset in 0..<bit:
                    let mask = base + offset
                    result[mask] += result[mask + bit]
                    right[mask] += right[mask + bit]
                base += bit shl 1
            bit = bit shl 1
        for mask in 0..<n:
            result[mask] *= right[mask]
        bit = 1
        while bit < n:
            var base = 0
            while base < n:
                for offset in 0..<bit:
                    let mask = base + offset
                    result[mask] -= result[mask + bit]
                base += bit shl 1
            bit = bit shl 1
    {.pop.}
