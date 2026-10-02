when not declared CPLIB_CONVOLUTION_SUBSET_CONVOLUTION:
    const CPLIB_CONVOLUTION_SUBSET_CONVOLUTION* = 1
    import bitops

    proc subsetConvolution*[T](a, b: seq[T]): seq[T] =
        ## c[S] = Σ_{U⊆S} a[U] b[S xor U]。O(n² 2^n)時間・O(n 2^n)追加領域。
        ## 同じ2冪長の列を受け取り、両方が空なら空列を返す。
        assert a.len == b.len, "配列の長さは一致する必要があります"
        let size = a.len
        if size == 0: return @[]
        assert (size and (size - 1)) == 0, "配列の長さは2冪である必要があります"
        let n = fastLog2(size)
        let stride = n + 1
        var left = newSeq[T](size * stride)
        var right = newSeq[T](size * stride)
        for mask in 0..<size:
            let index = mask * stride + countSetBits(mask)
            left[index] = a[mask]
            right[index] = b[mask]
        var bit = 1
        while bit < size:
            var base = 0
            while base < size:
                for j in 0..<bit:
                    let lo = (base + j) * stride
                    let hi = lo + bit * stride
                    for d in 0..n:
                        left[hi + d] += left[lo + d]
                        right[hi + d] += right[lo + d]
                base += bit * 2
            bit = bit shl 1
        for mask in 0..<size:
            let offset = mask * stride
            let rank = countSetBits(mask)
            for d in countdown(n, 0):
                var value = default(T)
                for k in max(0, d - rank)..min(d, rank):
                    value += left[offset + k] * right[offset + d - k]
                left[offset + d] = value
        bit = 1
        while bit < size:
            var base = 0
            while base < size:
                for j in 0..<bit:
                    let lo = (base + j) * stride
                    let hi = lo + bit * stride
                    for d in 0..n: left[hi + d] -= left[lo + d]
                base += bit * 2
            bit = bit shl 1
        result = newSeq[T](size)
        for mask in 0..<size: result[mask] = left[mask * stride + countSetBits(mask)]
