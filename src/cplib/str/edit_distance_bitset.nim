when not declared CPLIB_STR_EDIT_DISTANCE_BITSET:
    const CPLIB_STR_EDIT_DISTANCE_BITSET* = 1

    import cplib/collections/bitset_avx512

    proc editDistance_bitset*(s, t: string): int =
        ## 挿入・削除・置換を各コスト1とする編集距離をMyers法で返します。各バイトを1文字として扱います。
        ## n = max(|s|, |t|), m = min(|s|, |t|)。時間O(n * ceil(m / 64))、空間O(256 * ceil(m / 64))ワード。
        ## AVX-512F対応時の主要ループは512ビット単位で処理し、時間O(n * ceil(m / 512))相当です。
        ## 空文字列はO(1)。bitset_avx512と同じくamd64のAVX2対応CPUとGCC/Clangが必要です。
        if s.len < t.len:
            return editDistance_bitset(t, s)
        let m = t.len
        if m == 0:
            return s.len

        var matches: array[256, BitSetAvx512]
        for i, c in t:
            if matches[ord(c)].len == 0:
                matches[ord(c)] = initBitSet(m)
            matches[ord(c)][i] = true
        # DPの縦方向の差分が+1と-1になる位置をビット列で保持します。
        var positive = initBitSet(m)
        positive.fill()
        var negative = initBitSet(m)
        result = m

        for c in s:
            if matches[ord(c)].len == 0:
                matches[ord(c)] = initBitSet(m)
            template equal: untyped =
                ## 現在の文字の一致マスクをコピーせず参照します。
                matches[ord(c)]
            var positiveLast, negativeLast: bool
            fuse:
                let vertical = equal or negative
                let horizontal = (((equal and positive) + positive) xor positive) or equal
                let positiveHorizontal = not (horizontal or positive) or negative
                let negativeHorizontal = positive and horizontal
                var shiftedPositive = positiveHorizontal shl 1
                shiftedPositive[0] = true
                positive = not (vertical or shiftedPositive) or (negativeHorizontal shl 1)
                negative = shiftedPositive and vertical
                positiveLast = lastBit(positiveHorizontal)
                negativeLast = lastBit(negativeHorizontal)
            result += ord(positiveLast) - ord(negativeLast)
