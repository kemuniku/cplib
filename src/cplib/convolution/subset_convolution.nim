when not declared CPLIB_CONVOLUTION_SUBSET_CONVOLUTION:
    const CPLIB_CONVOLUTION_SUBSET_CONVOLUTION* = 1
    import bitops
    when defined(cpp) and (defined(gcc) or defined(clang)):
        import cplib/modint/modint
        import cplib/convolution/private/subset_convolution_barrett

    proc subsetConvolution*[T](a, b: seq[T]): seq[T] =
        ## c[S] = Σ_{U⊆S} a[U] b[S xor U]。O(n² 2^n)時間・O(n 2^n)追加領域。
        ## 同じ2冪長の列を受け取り、両方が空なら空列を返す。
        assert a.len == b.len, "配列の長さは一致する必要があります"
        let size = a.len
        if size == 0: return @[]
        assert (size and (size - 1)) == 0, "配列の長さは2冪である必要があります"
        let n = fastLog2(size)
        when defined(cpp) and (defined(gcc) or defined(clang)):
            when T is StaticBarrettModint:
                when T.M > 1u32 and T.M <= (1u32 shl 30):
                    if n <= 20: return subsetConvolutionBarrett(a, b)
        let stride = n + 1
        var left = newSeq[T](size * stride)
        var right = newSeq[T](size * stride)
        var ranks = newSeq[uint8](size)
        for mask in 0..<size:
            let rank = countSetBits(mask)
            ranks[mask] = rank.uint8
            let index = mask * stride + rank
            left[index] = a[mask]
            right[index] = b[mask]
        template zetaStage(bit, section, limit: untyped) =
            var base = section
            while base < limit:
                # 既に処理した下位bitだけが変わるので、加算元のrankはこの範囲に限られる。
                let first = int(ranks[base])
                for j in 0..<bit:
                    let lo = (base + j) * stride
                    let hi = lo + bit * stride
                    # 検査済みの行先頭から、0..n内のrankのみを参照する。
                    let llo = cast[ptr UncheckedArray[T]](addr left[lo])
                    let lhi = cast[ptr UncheckedArray[T]](addr left[hi])
                    let rlo = cast[ptr UncheckedArray[T]](addr right[lo])
                    let rhi = cast[ptr UncheckedArray[T]](addr right[hi])
                    for d in first.uint32..uint32(int(ranks[base + j])):
                        lhi[d] += llo[d]
                        rhi[d] += rlo[d]
                base += bit * 2
        # 下位bitの変換をブロック内で完了させ、配列全体の往復を減らす。
        let blockBits = min(n, 10)
        let blockSize = 1 shl blockBits
        var section = 0
        while section < size:
            for h in 0..<blockBits:
                zetaStage(1 shl h, section, section + blockSize)
            section += blockSize
        for h in blockBits..<n:
            zetaStage(1 shl h, 0, size)
        for mask in 0..<size:
            let offset = mask * stride
            let rank = int(ranks[mask])
            let lrow = cast[ptr UncheckedArray[T]](addr left[offset])
            let rrow = cast[ptr UncheckedArray[T]](addr right[offset])
            # rank未満の項は以後のMobius・出力で使わず、2*rankを超える項は零。
            var d = uint32(min(n, 2 * rank))
            while true:
                var value = default(T)
                for k in d - rank.uint32..rank.uint32:
                    value += lrow[k] * rrow[d - k]
                lrow[d] = value
                if d == rank.uint32: break
                dec d
        template mobiusStage(bit, section, limit: untyped) =
            var base = section
            while base < limit:
                for j in 0..<bit:
                    let lo = (base + j) * stride
                    let hi = lo + bit * stride
                    let llo = cast[ptr UncheckedArray[T]](addr left[lo])
                    let lhi = cast[ptr UncheckedArray[T]](addr left[hi])
                    # この集合以上の出力に必要な次数だけを逆変換する。
                    let rank = int(ranks[base + j + bit])
                    for d in rank.uint32..uint32(min(n, 2 * (rank - 1))):
                        lhi[d] -= llo[d]
                base += bit * 2
        section = 0
        while section < size:
            for h in 0..<blockBits:
                mobiusStage(1 shl h, section, section + blockSize)
            section += blockSize
        for h in blockBits..<n:
            mobiusStage(1 shl h, 0, size)
        result = newSeq[T](size)
        for mask in 0..<size: result[mask] = left[mask * stride + int(ranks[mask])]
