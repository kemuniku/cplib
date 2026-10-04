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
        var processed = 0
        while bit < size:
            var base = 0
            while base < size:
                # 既に処理した下位bitだけが変わるので、加算元のrankはこの範囲に限られる。
                let first = countSetBits(base)
                for j in 0..<bit:
                    let lo = (base + j) * stride
                    let hi = lo + bit * stride
                    # 検査済みの行先頭から、0..n内のrankのみを参照する。
                    let llo = cast[ptr UncheckedArray[T]](addr left[lo])
                    let lhi = cast[ptr UncheckedArray[T]](addr left[hi])
                    let rlo = cast[ptr UncheckedArray[T]](addr right[lo])
                    let rhi = cast[ptr UncheckedArray[T]](addr right[hi])
                    for d in first..first + processed:
                        lhi[d] += llo[d]
                        rhi[d] += rlo[d]
                base += bit * 2
            bit = bit shl 1
            inc processed
        for mask in 0..<size:
            let offset = mask * stride
            let rank = countSetBits(mask)
            let lrow = cast[ptr UncheckedArray[T]](addr left[offset])
            let rrow = cast[ptr UncheckedArray[T]](addr right[offset])
            # rank未満の項は以後のMobius・出力で使わず、2*rankを超える項は零。
            for d in countdown(min(n, 2 * rank), rank):
                var value = default(T)
                for k in d - rank..rank:
                    value += lrow[k] * rrow[d - k]
                lrow[d] = value
        bit = 1
        while bit < size:
            var base = 0
            while base < size:
                for j in 0..<bit:
                    let lo = (base + j) * stride
                    let hi = lo + bit * stride
                    let llo = cast[ptr UncheckedArray[T]](addr left[lo])
                    let lhi = cast[ptr UncheckedArray[T]](addr left[hi])
                    # この集合以上の出力に必要な次数だけを逆変換する。
                    for d in countSetBits(base + j + bit)..n:
                        lhi[d] -= llo[d]
                base += bit * 2
            bit = bit shl 1
        result = newSeq[T](size)
        for mask in 0..<size: result[mask] = left[mask * stride + countSetBits(mask)]
