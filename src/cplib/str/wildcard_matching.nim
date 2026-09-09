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
        doAssert S.len <= (1 shl 24) - T.len + 1

        var s, t: array[3, seq[int]]
        for k in 0..<3:
            s[k] = newSeq[int](S.len)
            t[k] = newSeq[int](T.len)
        for i, c in S:
            if c != wild:
                let x = ord(c) + 1
                s[0][i] = x
                s[1][i] = x * x
                s[2][i] = x * x * x
        for i, c in T:
            if c != wild:
                let x = ord(c) + 1
                let j = T.len - 1 - i
                t[0][j] = x
                t[1][j] = x * x
                t[2][j] = x * x * x

        # Σ xy(x-y)^2 は、一致するときだけ 0 になります。
        # 整数畳み込みで剰余の衝突を避けます。上の長さ制限では中間値も int64 に収まります。
        let a = convolution_ll(s[0], t[2])
        let b = convolution_ll(s[1], t[1])
        let c = convolution_ll(s[2], t[0])
        for i in 0..<result.len:
            let j = i + T.len - 1
            result[i] = a[j] + c[j] - 2 * b[j] == 0
