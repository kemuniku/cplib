## AVX2で論理演算・シフト・ビット数の集計を高速化した動的ビット集合です。
## amd64のAVX2対応CPUとGCC/Clangが必要です。C/C++バックエンドに対応します。
## import cplib/collections/bitset_avx2 とし、initBitSetで構築します。
## -d:releaseでのコンパイルを推奨します。-mavx2の指定は不要です。
when not declared CPLIB_COLLECTIONS_BITSET_AVX2:
    const CPLIB_COLLECTIONS_BITSET_AVX2* = 1
    when not (defined(amd64) and (defined(gcc) or defined(clang))):
        {.error: "BitSetAvx2 requires amd64 and GCC/Clang".}
    import bitops

    type BitSetAvx2* {.byref.} = object
        bits: seq[uint64]
        size: int

    include cplib/collections/private/bitset_avx2_impl

    proc initBitSet*(N: int): BitSetAvx2 =
        ## Nビットの空集合を構築します。
        if N < 0:
            raise newException(ValueError, "BitSet size must be non-negative")
        result.size = N
        result.bits = newSeq[uint64]((N shr 6) + ord((N and 63) != 0))

    proc initBitSet*(v: openArray[bool], N: int): BitSetAvx2 =
        ## 真偽値配列からNビットの集合を構築し、残りを0で埋めます。
        if v.len > N:
            raise newException(ValueError, "initial value is longer than BitSet size")
        result = initBitSet(N)
        for i in 0..<v.len:
            if v[i]:
                result.bits[i shr 6] = result.bits[i shr 6] or (1'u64 shl (i and 63))

    proc initBitSet*(v: openArray[bool]): BitSetAvx2 =
        ## 真偽値配列と同じ長さの集合を構築します。
        initBitSet(v, v.len)

    proc initBitSetFromIndexes*(indexes: openArray[int], N: int): BitSetAvx2 =
        ## 指定した添字のビットを立てたNビットの集合を構築します。
        result = initBitSet(N)
        for i in indexes:
            if i < 0 or i >= N:
                raise newException(IndexDefect, "BitSet index out of bounds")
            result.bits[i shr 6] = result.bits[i shr 6] or (1'u64 shl (i and 63))

    proc len*(bitset: BitSetAvx2): int {.inline.} =
        ## ビット数を返します。
        bitset.size

    proc checkSameSize(x, y: BitSetAvx2) {.inline.} =
        ## 二つの集合のビット数が等しいことを確認します。
        if x.size != y.size:
            raise newException(ValueError, "BitSet sizes must match")

    proc checkIndex(bitset: BitSetAvx2, idx: Natural) {.inline.} =
        ## 添字が集合の範囲内であることを確認します。
        if idx >= bitset.size:
            raise newException(IndexDefect, "BitSet index out of bounds")

    proc trim(bitset: var BitSetAvx2) {.inline.} =
        ## 最後のワードの範囲外のビットを0にします。
        let remainder = bitset.size and 63
        if remainder != 0:
            bitset.bits[^1] = bitset.bits[^1] and ((1'u64 shl remainder) - 1)

    proc `&`*(x, y: BitSetAvx2): BitSetAvx2 =
        ## 共通部分を返します。
        checkSameSize(x, y)
        result = initBitSet(x.size)
        if x.bits.len > 0:
            avxAnd(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `&=`*(x: var BitSetAvx2, y: BitSetAvx2) =
        ## 自身を共通部分に更新します。
        checkSameSize(x, y)
        if x.bits.len > 0:
            avxAnd(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `|`*(x, y: BitSetAvx2): BitSetAvx2 =
        ## 和集合を返します。
        checkSameSize(x, y)
        result = initBitSet(x.size)
        if x.bits.len > 0:
            avxOr(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `|=`*(x: var BitSetAvx2, y: BitSetAvx2) =
        ## 自身を和集合に更新します。
        checkSameSize(x, y)
        if x.bits.len > 0:
            avxOr(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `^`*(x, y: BitSetAvx2): BitSetAvx2 =
        ## 対称差を返します。
        checkSameSize(x, y)
        result = initBitSet(x.size)
        if x.bits.len > 0:
            avxXor(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `^=`*(x: var BitSetAvx2, y: BitSetAvx2) =
        ## 自身を対称差に更新します。
        checkSameSize(x, y)
        if x.bits.len > 0:
            avxXor(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `<<`*(bitset: BitSetAvx2, x: int): BitSetAvx2 =
        ## 添字が大きい方向へxビットずらし、範囲外を切り捨てます。
        if x < 0:
            raise newException(ValueError, "shift count must be non-negative")
        result = initBitSet(bitset.size)
        if x < bitset.size:
            avxShl(addr result.bits[0], unsafeAddr bitset.bits[0], bitset.bits.len.csize_t, x.csize_t)
            result.trim()

    proc `>>`*(bitset: BitSetAvx2, x: int): BitSetAvx2 =
        ## 添字が小さい方向へxビットずらし、範囲外を切り捨てます。
        if x < 0:
            raise newException(ValueError, "shift count must be non-negative")
        result = initBitSet(bitset.size)
        if x < bitset.size:
            avxShr(addr result.bits[0], unsafeAddr bitset.bits[0], bitset.bits.len.csize_t, x.csize_t)

    proc `~`*(x: BitSetAvx2): BitSetAvx2 =
        ## 集合のビット数を保ったまま各ビットを反転します。
        result = initBitSet(x.size)
        if x.bits.len > 0:
            avxNot(addr result.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t)
            result.trim()

    proc popcount*(x: BitSetAvx2): int =
        ## 立っているビットの個数を返します。
        if x.bits.len > 0:
            result = avxPopcount(unsafeAddr x.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t).int

    proc andpopcount*(x, y: BitSetAvx2): int =
        ## 共通部分の要素数を、一時的な集合を作らずに返します。
        checkSameSize(x, y)
        if x.bits.len > 0:
            result = avxAndPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int

    proc orpopcount*(x, y: BitSetAvx2): int =
        ## 和集合の要素数を、一時的な集合を作らずに返します。
        checkSameSize(x, y)
        if x.bits.len > 0:
            result = avxOrPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int

    proc xorpopcount*(x, y: BitSetAvx2): int =
        ## 対称差の要素数を、一時的な集合を作らずに返します。
        checkSameSize(x, y)
        if x.bits.len > 0:
            result = avxXorPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int

    iterator items*(bitset: BitSetAvx2): int =
        ## 立っているビットの添字を昇順に列挙します。
        for wordIndex in 0..<bitset.bits.len:
            var word = bitset.bits[wordIndex]
            while word != 0:
                yield wordIndex * 64 + word.countTrailingZeroBits()
                word = word and (word - 1)

    proc lowestBit*(bitset: BitSetAvx2): int =
        ## 最小の要素を返し、空集合なら-1を返します。
        for wordIndex in 0..<bitset.bits.len:
            if bitset.bits[wordIndex] != 0:
                return wordIndex * 64 + bitset.bits[wordIndex].countTrailingZeroBits()
        -1

    proc `[]`*(bitset: BitSetAvx2, idx: Natural): bool =
        ## 指定した添字のビットが立っているかを返します。
        bitset.checkIndex(idx)
        bitset.bits[idx shr 6].testBit(idx and 63)

    proc `[]=`*(bitset: var BitSetAvx2, idx: Natural, x: bool) =
        ## 指定した添字のビットを真偽値で更新します。
        bitset.checkIndex(idx)
        if x:
            bitset.bits[idx shr 6].setBit(idx and 63)
        else:
            bitset.bits[idx shr 6].clearBit(idx and 63)

    proc `[]=`*(bitset: var BitSetAvx2, idx: Natural, x: int) =
        ## 0ならビットを落とし、1なら立てます。それ以外は何もしません。
        if x == 1:
            bitset[idx] = true
        elif x == 0:
            bitset[idx] = false

    proc `$`*(bitset: BitSetAvx2): string =
        ## 添字の大きい順にビットを並べた文字列を返します。
        result = newString(bitset.size)
        for i in 0..<bitset.size:
            result[bitset.size - i - 1] = if bitset[i]: '1' else: '0'
