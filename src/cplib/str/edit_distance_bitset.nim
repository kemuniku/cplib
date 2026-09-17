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
        var vertical = initBitSet(m)
        var horizontal = initBitSet(m)
        var positiveHorizontal = initBitSet(m)
        var negativeHorizontal = initBitSet(m)
        result = m

        for c in s:
            if matches[ord(c)].len == 0:
                matches[ord(c)] = initBitSet(m)
            template equal: untyped =
                ## 現在の文字の一致マスクをコピーせず参照します。
                matches[ord(c)]
            vertical.orInto(equal, negative)
            horizontal.andInto(equal, positive)
            horizontal.addInto(horizontal, positive)
            horizontal ^= positive
            horizontal |= equal
            positiveHorizontal.orInto(horizontal, positive)
            positiveHorizontal.flipAll()
            positiveHorizontal |= negative
            negativeHorizontal.andInto(positive, horizontal)
            result += ord(positiveHorizontal[m - 1]) - ord(negativeHorizontal[m - 1])

            positiveHorizontal = positiveHorizontal << 1
            positiveHorizontal[0] = true
            negativeHorizontal = negativeHorizontal << 1
            positive.orInto(vertical, positiveHorizontal)
            positive.flipAll()
            positive |= negativeHorizontal
            negative.andInto(positiveHorizontal, vertical)

    proc editDistnce_bitset*(s, t: string): int {.inline.} =
        ## editDistance_bitsetの別名として編集距離を返します。
        editDistance_bitset(s, t)
