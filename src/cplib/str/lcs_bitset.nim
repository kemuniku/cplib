when not declared CPLIB_STR_LCS_BITSET:
    const CPLIB_STR_LCS_BITSET* = 1

    import tables
    import cplib/collections/bitset_avx512

    proc lcsBitsetDP[T](A, B: openArray[T], backwards: static bool = false): BitSetAvx512 =
        ## B方向のDP差分を計算します。backwardsでは両入力をコピーせず逆順に走査します。
        let m = B.len
        let words = (m shr 6) + ord((m and 63) != 0)
        var state = initBitSet(m)
        var combined = initBitSet(m)
        var difference = initBitSet(m)
        var matched = initBitSet(m)

        template advance(mask: BitSetAvx512) =
            ## DPの隣接差分を更新します。x - ((state << 1) | 1) = x + ~(state << 1)を使います。
            combined.orInto(state, mask)
            difference = state << 1
            difference.flipAll()
            difference.addInto(combined, difference)
            state.andNotInto(combined, difference)

        template aValue(i: int): untyped =
            ## 走査方向に応じたAの要素を参照します。
            when backwards: A[A.len - 1 - i]
            else: A[i]

        template bValue(i: int): untyped =
            ## 走査方向に応じたBの要素を参照します。
            when backwards: B[m - 1 - i]
            else: B[i]

        when T is SomeInteger or T is char or T is bool or T is enum or T is string:
            var ids = initTable[T, int]()
            var positions: seq[seq[int]]
            for i in 0..<m:
                template value: untyped = bValue(i)
                let id = ids.getOrDefault(value, -1)
                if id < 0:
                    ids[value] = positions.len
                    positions.add(@[i])
                else:
                    positions[id].add(i)
            var masks = newSeq[BitSetAvx512](positions.len)
            for id, indexes in positions:
                # 頻出要素だけをビット列にし、要素の種類が多い場合も追加空間をO(m)に抑えます。
                if indexes.len > words:
                    masks[id] = initBitSetFromIndexes(indexes, m)
            for k in 0..<A.len:
                template value: untyped = aValue(k)
                let id = ids.getOrDefault(value, -1)
                if id >= 0:
                    if masks[id].len != 0:
                        advance(masks[id])
                    else:
                        matched.clear()
                        for i in positions[id]:
                            matched[i] = true
                        advance(matched)
        else:
            # 独自の == を持つ型にも、ハッシュや順序比較を要求せず対応します。
            for k in 0..<A.len:
                template value: untyped = aValue(k)
                matched.clear()
                for i in 0..<m:
                    if bValue(i) == value:
                        matched[i] = true
                advance(matched)
        move(state)

    proc LCS*[T](A, B: openArray[T]): int =
        ## 既存のLCSと同じく、最長共通部分列の長さを返します。stringはバイト単位で比較します。
        ## n = max(A.len, B.len), m = min(A.len, B.len), w = ceil(m / 64)。追加空間O(m)。
        ## 整数・char・bool・enum・stringは期待時間O(m + n*w)。要素のハッシュ・比較はO(1)とします。
        ## その他の型は == のみを使って一致位置を求め、時間O(n*m)。空入力はO(1)です。
        ## amd64のAVX2対応CPUとGCC/Clangが必要です。対応環境ではビット演算にAVX-512も使います。
        if A.len < B.len:
            return LCS(B, A)
        if B.len == 0:
            return 0
        lcsBitsetDP(A, B).popcount()

    proc lcsBitsetSplit[T](A, B: openArray[T], middle: int): int =
        ## 前半・後半のLCS長の和を最大にするBの分割位置を求め、作業領域を呼び出し元へ持ち越しません。
        let forward = lcsBitsetDP(A.toOpenArray(0, middle - 1), B)
        let backward = lcsBitsetDP(A.toOpenArray(middle, A.high), B, true)
        var left = 0
        var right = backward.popcount()
        var best = right
        for j in 0..<B.len:
            left += ord(forward[j])
            right -= ord(backward[B.len - 1 - j])
            if left + right > best:
                best = left + right
                result = j + 1

    proc restoreLCSInto[T](A, B: openArray[T], output: var seq[T]) =
        ## Hirschberg法で左右の部分列を順に追記します。入力の区間はコピーせず参照します。
        if A.len < B.len:
            restoreLCSInto(B, A, output)
            return
        if B.len == 0:
            return
        if B.len == 1:
            for value in A:
                if value == B[0]:
                    output.add(B[0])
                    break
            return
        let middle = A.len div 2
        let split = lcsBitsetSplit(A, B, middle)
        if split > 0:
            restoreLCSInto(A.toOpenArray(0, middle - 1), B.toOpenArray(0, split - 1), output)
        if split < B.len:
            restoreLCSInto(A.toOpenArray(middle, A.high), B.toOpenArray(split, B.high), output)

    proc restoreLCS*[T](A, B: openArray[T]): seq[T] =
        ## 最長共通部分列を一つ復元します。複数解がある場合の選び方は既存版と異なることがあります。
        ## n = max(A.len, B.len), m = min(A.len, B.len)。出力を含む追加空間O(n + m)。
        ## 整数・char・bool・enum・stringは期待時間O(n*m/64 + (n+m)*log(n+m))、その他の型はO(n*m)。
        ## ハッシュ・比較はO(1)とします。空入力はO(1)です。
        restoreLCSInto(A, B, result)
