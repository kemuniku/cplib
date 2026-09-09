## AVX2で論理演算・シフト・ビット数の集計を高速化した固定長ビット集合です。
## amd64のAVX2対応CPUとGCC/Clangが必要です。C/C++バックエンドに対応します。
## initBitSet(3000) や BitSet[3000] として使います。-mavx2の指定は不要です。
when not declared CPLIB_COLLECTIONS_STATIC_BITSET_AVX2:
    const CPLIB_COLLECTIONS_STATIC_BITSET_AVX2* = 1
    when not (defined(amd64) and (defined(gcc) or defined(clang))):
        {.error: "StaticBitSetAvx2 requires amd64 and GCC/Clang".}
    import bitops
    include cplib/collections/private/bitset_avx2_impl

    func wordCount(size: int): int {.compileTime.} =
        ## 非負のビット数に必要な64ビットワード数を求めます。
        doAssert size >= 0, "BitSet size must be non-negative"
        (size shr 6) + ord((size and 63) != 0)

    type BitSet*[size: static int] {.byref.} = object
        bits: array[wordCount(size), uint64]

    proc initBitSet*(size: static int): BitSet[size] =
        ## 指定したビット数の空集合を構築します。
        discard

    proc initBitSet*(v: openArray[bool], size: static int): BitSet[size] {.noinit.} =
        ## 真偽値配列から集合を構築し、残りを0で埋めます。
        if v.len > size:
            raise newException(ValueError, "initial value is longer than BitSet size")
        static:
            doAssert sizeof(bool) == 1
        when size > 0:
            let source = if v.len == 0: nil else: cast[pointer](unsafeAddr v[0])
            avxFromBools(addr result.bits[0], source, v.len.csize_t, result.bits.len.csize_t)

    proc initBitSetFromIndexes*(indexes: openArray[int], size: static int): BitSet[size] =
        ## 指定した添字のビットを立てた集合を構築します。
        for i in indexes:
            if i < 0 or i >= size:
                raise newException(IndexDefect, "BitSet index out of bounds")
            result.bits[i shr 6] = result.bits[i shr 6] or (1'u64 shl (i and 63))

    proc len*[size](bitset: BitSet[size]): int {.inline.} =
        ## 集合のビット数を返します。
        size

    proc checkIndex[size](bitset: BitSet[size], idx: Natural) {.inline.} =
        ## 添字が集合の範囲内であることを確認します。
        if idx >= size:
            raise newException(IndexDefect, "BitSet index out of bounds")

    proc trim[size](bitset: var BitSet[size]) {.inline.} =
        ## 最後のワードの範囲外のビットを0にします。
        const remainder = size and 63
        when remainder != 0:
            bitset.bits[^1] = bitset.bits[^1] and ((1'u64 shl remainder) - 1)

    proc `&`*[size](x, y: BitSet[size]): BitSet[size] {.noinit.} =
        ## 共通部分を返します。
        when size > 0:
            avxAnd(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `&=`*[size](x: var BitSet[size], y: BitSet[size]) =
        ## 自身を共通部分に更新します。
        when size > 0:
            avxAnd(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `|`*[size](x, y: BitSet[size]): BitSet[size] {.noinit.} =
        ## 和集合を返します。
        when size > 0:
            avxOr(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `|=`*[size](x: var BitSet[size], y: BitSet[size]) =
        ## 自身を和集合に更新します。
        when size > 0:
            avxOr(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `^`*[size](x, y: BitSet[size]): BitSet[size] {.noinit.} =
        ## 対称差を返します。
        when size > 0:
            avxXor(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `^=`*[size](x: var BitSet[size], y: BitSet[size]) =
        ## 自身を対称差に更新します。
        when size > 0:
            avxXor(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `<<`*[size](bitset: BitSet[size], x: int): BitSet[size] =
        ## 添字が大きい方向へxビットずらし、範囲外を切り捨てます。
        if x < 0:
            raise newException(ValueError, "shift count must be non-negative")
        when size > 0:
            if x < size:
                avxShl(addr result.bits[0], unsafeAddr bitset.bits[0], bitset.bits.len.csize_t, x.csize_t)
                result.trim()

    proc `>>`*[size](bitset: BitSet[size], x: int): BitSet[size] =
        ## 添字が小さい方向へxビットずらし、範囲外を切り捨てます。
        if x < 0:
            raise newException(ValueError, "shift count must be non-negative")
        when size > 0:
            if x < size:
                avxShr(addr result.bits[0], unsafeAddr bitset.bits[0], bitset.bits.len.csize_t, x.csize_t)

    proc `~`*[size](x: BitSet[size]): BitSet[size] {.noinit.} =
        ## 集合のビット数を保ったまま各ビットを反転します。
        when size > 0:
            avxNot(addr result.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t)
            result.trim()

    proc popcount*[size](x: BitSet[size]): int =
        ## 立っているビットの個数を返します。
        when size > 0:
            result = avxPopcount(unsafeAddr x.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t).int

    proc andpopcount*[size](x, y: BitSet[size]): int =
        ## 共通部分の要素数を、一時的な集合を作らずに返します。
        when size > 0:
            result = avxAndPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int

    proc orpopcount*[size](x, y: BitSet[size]): int =
        ## 和集合の要素数を、一時的な集合を作らずに返します。
        when size > 0:
            result = avxOrPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int

    proc xorpopcount*[size](x, y: BitSet[size]): int =
        ## 対称差の要素数を、一時的な集合を作らずに返します。
        when size > 0:
            result = avxXorPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int

    iterator items*[size](bitset: BitSet[size]): int =
        ## 立っているビットの添字を昇順に列挙します。
        for wordIndex in 0..<bitset.bits.len:
            var word = bitset.bits[wordIndex]
            while word != 0:
                yield wordIndex * 64 + word.countTrailingZeroBits()
                word = word and (word - 1)

    proc lowestBit*[size](bitset: BitSet[size]): int =
        ## 最小の要素を返し、空集合なら-1を返します。
        for wordIndex in 0..<bitset.bits.len:
            if bitset.bits[wordIndex] != 0:
                return wordIndex * 64 + bitset.bits[wordIndex].countTrailingZeroBits()
        -1

    proc `[]`*[size](bitset: BitSet[size], idx: Natural): bool =
        ## 指定した添字のビットが立っているかを返します。
        bitset.checkIndex(idx)
        bitset.bits[idx shr 6].testBit(idx and 63)

    proc `[]=`*[size](bitset: var BitSet[size], idx: Natural, x: bool) =
        ## 指定した添字のビットを真偽値で更新します。
        bitset.checkIndex(idx)
        if x:
            bitset.bits[idx shr 6].setBit(idx and 63)
        else:
            bitset.bits[idx shr 6].clearBit(idx and 63)

    proc `[]=`*[size](bitset: var BitSet[size], idx: Natural, x: int) =
        ## 0ならビットを落とし、1なら立てます。それ以外は何もしません。
        if x == 1:
            bitset[idx] = true
        elif x == 0:
            bitset[idx] = false

    const ByteStrings = block:
        var table: array[256, array[8, char]]
        for value in 0..<256:
            for bit in 0..<8:
                table[value][bit] = char(ord('0') + ((value shr (7 - bit)) and 1))
        table

    proc `$`*[size](bitset: BitSet[size]): string =
        ## 添字の大きい順にビットを並べた文字列を返します。
        result = newString(size)
        var finish = size
        for wordIndex in 0..<bitset.bits.len:
            var word = bitset.bits[wordIndex]
            var remaining = min(64, size - wordIndex * 64)
            while remaining >= 8:
                finish -= 8
                copyMem(addr result[finish], unsafeAddr ByteStrings[int(word and 255)][0], 8)
                word = word shr 8
                remaining -= 8
            while remaining > 0:
                dec finish
                result[finish] = char(ord('0') + int(word and 1))
                word = word shr 1
                dec remaining
