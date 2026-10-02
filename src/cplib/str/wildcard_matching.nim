when not declared CPLIB_STR_WILDCARD_MATCHING:
    const CPLIB_STR_WILDCARD_MATCHING* = 1

    import cplib/convolution/convolution

    proc wildcard_match*(S, T: string, wild: char = '?'): seq[bool] =
        ## S の各開始位置で T が一致するかを、時間 O((|S|+|T|) log(|S|+|T|))、空間 O(|S|+|T|) で返します。
        ## 両文字列の wild は任意の 1 バイトに一致し、string はバイト単位で扱います。
        ## T が空なら |S|+1 個の true、|T| > |S| なら空列を返します。
        ## 64 bit 環境が必要です。0 < |T| <= |S| の場合、|S|+|T|-1 <= 2^24 が必要です。
        if T.len > S.len:
            return @[]
        result = newSeq[bool](S.len - T.len + 1)
        if T.len == 0:
            for i in 0..<result.len:
                result[i] = true
            return
        {.push assertions: on.}
        assert S.len <= (1 shl 24) - T.len + 1, "畳み込みに必要な長さS.len + T.len - 1は2^24以下である必要があります"
        {.pop.}
        for i in 0..<result.len:
            result[i] = true
        if T.len <= 60:
            for i in 0..<result.len:
                for j in 0..<T.len:
                    if S[i + j] != wild and T[j] != wild and S[i + j] != T[j]:
                        result[i] = false
                        break
            return

        var lo = 255
        var hi = 0
        var fixedS, fixedT = 0
        for c in S:
            if c != wild:
                lo = min(lo, ord(c))
                hi = max(hi, ord(c))
                inc fixedS
        for c in T:
            if c != wild:
                lo = min(lo, ord(c))
                hi = max(hi, ord(c))
                inc fixedT
        if fixedS == 0 or fixedT == 0 or lo == hi:
            return

        # Σ maskS maskT (x-y)^2 は非負で、一致するときだけ0になる。
        # 各スコアは fixedT*(hi-lo)^2 以下。1素数で足りなければ2素数で零判定する。
        # 上限は2^23*255^2 < 469762049*167772161なので、剰余の衝突はない。
        # 巡回長L >= |S|では折り返す高次項は|T|-2以下にしか届かない。
        let bound = fixedT.uint64 * (hi - lo).uint64 * (hi - lo).uint64
        let output = cast[ptr uint8](addr result[0])
        let s = cast[ptr uint8](unsafeAddr S[0])
        let t = cast[ptr uint8](unsafeAddr T[0])
        wildcardMatchingNttKernel(output, s, S.len.csize_t, t, T.len.csize_t,
            ord(wild).uint8, lo.uint32, 469762049u32)
        if bound >= 469762049u64:
            wildcardMatchingNttKernel(output, s, S.len.csize_t, t, T.len.csize_t,
                ord(wild).uint8, lo.uint32, 167772161u32)
