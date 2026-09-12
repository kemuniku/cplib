## AVX-512/AVX2で論理演算・シフト・ビット数の集計を高速化した動的ビット集合です。
## amd64のAVX2対応CPUとGCC/Clangが必要です。C/C++バックエンドに対応します。
## AVX-512対応環境では対応する演算を自動で切り替えます。個数計算にはVPOPCNTDQが必要です。
## import cplib/collections/bitset_avx512 とし、initBitSetで構築します。
## -d:releaseでのコンパイルを推奨します。-mavx2の指定は不要です。
## 命令数はAVX-512経路の主ループの演算部分の目安で、関数全体の命令数やサイクル数ではありません。
## ロード・ストア、アドレス計算、ループ制御、CPU判定、チェック、領域確保・初期化、定数準備、端数処理は含めません。
## コンパイラによる命令の融合・展開で変わります。AVX2への切り替え時には当てはまりません。
when not declared CPLIB_COLLECTIONS_BITSET_AVX512:
    const CPLIB_COLLECTIONS_BITSET_AVX512* = 1
    when not (defined(amd64) and (defined(gcc) or defined(clang))):
        {.error: "BitSetAvx512 requires amd64 and GCC/Clang".}
    import bitops

    type BitSetAvx512* {.byref.} = object
        bits: seq[uint64]
        size: int

    include cplib/collections/private/bitset_avx512_impl

    proc initBitSet*(N: int): BitSetAvx512 =
        ## Nビットの空集合を構築します。
        when compileOption("boundChecks"):
            if N < 0:
                raise newException(ValueError, "BitSet size must be non-negative")
        result.size = N
        result.bits = newSeq[uint64]((N shr 6) + ord((N and 63) != 0))

    proc initBitSet*(v: openArray[bool], N: int): BitSetAvx512 =
        ## 真偽値配列からNビットの集合を構築し、残りを0で埋めます。
        when compileOption("boundChecks"):
            if v.len > N:
                raise newException(ValueError, "initial value is longer than BitSet size")
        result = initBitSet(N)
        for i in 0..<v.len:
            if v[i]:
                result.bits[i shr 6] = result.bits[i shr 6] or (1'u64 shl (i and 63))

    proc initBitSet*(v: openArray[bool]): BitSetAvx512 =
        ## 真偽値配列と同じ長さの集合を構築します。
        initBitSet(v, v.len)

    proc initBitSetFromString*(s: string, match: char, N: int): BitSetAvx512 =
        ## s[i] == matchの位置を1にします。添字はバイト単位で、残りは0です。O(s.len + N / 64)。
        ## UTF-8の文字単位の比較や部分文字列検索ではありません。NULを含む文字列も比較できます。
        ## AVX2経路の目安: 32バイトあたり比較＋MOVMSKの2命令。格納用の結合とゼロ埋めは別です。
        ## AVX-512BW経路の目安: 64バイトあたり比較＋マスク転送の2命令。
        when compileOption("boundChecks"):
            if s.len > N:
                raise newException(ValueError, "source string is longer than BitSet size")
        result = initBitSet(N)
        if result.bits.len > 0:
            let source = if s.len == 0: nil else: cast[pointer](unsafeAddr s[0])
            avxFromStringChar(addr result.bits[0], source, nil, ord(match).uint8, s.len.csize_t, result.bits.len.csize_t)

    proc initBitSetFromString*(s: string, match: char): BitSetAvx512 =
        ## 文字列のバイト数と同じ長さの集合を構築します。O(s.len)。
        initBitSetFromString(s, match, s.len)

    proc initBitSetFromString*(s, reference: string, N: int): BitSetAvx512 =
        ## 同じ長さの文字列を位置ごとに比較し、s[i] == reference[i]の位置を1にします。添字はバイト単位で、残りは0です。O(s.len + N / 64)。
        ## UTF-8の文字単位の比較や部分文字列検索ではありません。NULを含む文字列も比較できます。
        ## AVX2経路の目安: 32バイトあたり比較＋MOVMSKの2命令。格納用の結合とゼロ埋めは別です。
        ## AVX-512BW経路の目安: 64バイトあたり比較＋マスク転送の2命令。
        when compileOption("boundChecks"):
            if s.len > N:
                raise newException(ValueError, "source string is longer than BitSet size")
            if s.len != reference.len:
                raise newException(ValueError, "source and reference string lengths must match")
        result = initBitSet(N)
        if result.bits.len > 0:
            let source = if s.len == 0: nil else: cast[pointer](unsafeAddr s[0])
            let target = if reference.len == 0: nil else: cast[pointer](unsafeAddr reference[0])
            avxFromStringEqual(addr result.bits[0], source, target, 0.uint8, s.len.csize_t, result.bits.len.csize_t)

    proc initBitSetFromString*(s, reference: string): BitSetAvx512 =
        ## 文字列のバイト数と同じ長さの集合を構築します。O(s.len)。
        initBitSetFromString(s, reference, s.len)

    proc initBitSetFromIndexes*(indexes: openArray[int], N: int): BitSetAvx512 =
        ## 指定した添字のビットを立てたNビットの集合を構築します。
        result = initBitSet(N)
        for i in indexes:
            when compileOption("boundChecks"):
                if i < 0 or i >= N:
                    raise newException(IndexDefect, "BitSet index out of bounds")
            result.bits[i shr 6] = result.bits[i shr 6] or (1'u64 shl (i and 63))

    proc len*(bitset: BitSetAvx512): int {.inline.} =
        ## ビット数を返します。
        bitset.size

    proc checkSameSize(x, y: BitSetAvx512) {.inline.} =
        ## 二つの集合のビット数が等しいことを確認します。
        when compileOption("boundChecks"):
            if x.size != y.size:
                raise newException(ValueError, "BitSet sizes must match")

    proc checkIndex(bitset: BitSetAvx512, idx: Natural) {.inline.} =
        ## 添字が集合の範囲内であることを確認します。
        when compileOption("boundChecks"):
            if idx >= bitset.size:
                raise newException(IndexDefect, "BitSet index out of bounds")

    proc trim(bitset: var BitSetAvx512) {.inline.} =
        ## 最後のワードの範囲外のビットを0にします。
        let remainder = bitset.size and 63
        if remainder != 0:
            bitset.bits[^1] = bitset.bits[^1] and ((1'u64 shl remainder) - 1)

    proc andInto*(dst: var BitSetAvx512, x, y: BitSetAvx512) =
        ## 確保済みのdstへx & yを書き込みます。全て同じ長さが必要です。O(ビット数 / 64)。
        ## 領域確保・中間集合は不要で、dstにxやy自身を指定することもできます。
        ## AVX-512経路の目安: 512ビットあたり論理演算1命令。ロード・ストアと末尾のマスクは別です。
        when compileOption("boundChecks"):
            checkSameSize(dst, x)
            checkSameSize(x, y)
        if x.bits.len > 0:
            avxAnd(addr dst.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc orInto*(dst: var BitSetAvx512, x, y: BitSetAvx512) =
        ## 確保済みのdstへx | yを書き込みます。全て同じ長さが必要です。O(ビット数 / 64)。
        ## 領域確保・中間集合は不要で、dstにxやy自身を指定することもできます。
        ## AVX-512経路の目安: 512ビットあたり論理演算1命令。ロード・ストアと末尾のマスクは別です。
        when compileOption("boundChecks"):
            checkSameSize(dst, x)
            checkSameSize(x, y)
        if x.bits.len > 0:
            avxOr(addr dst.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc xorInto*(dst: var BitSetAvx512, x, y: BitSetAvx512) =
        ## 確保済みのdstへx ^ yを書き込みます。全て同じ長さが必要です。O(ビット数 / 64)。
        ## 領域確保・中間集合は不要で、dstにxやy自身を指定することもできます。
        ## AVX-512経路の目安: 512ビットあたり論理演算1命令。ロード・ストアと末尾のマスクは別です。
        when compileOption("boundChecks"):
            checkSameSize(dst, x)
            checkSameSize(x, y)
        if x.bits.len > 0:
            avxXor(addr dst.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc andNotInto*(dst: var BitSetAvx512, x, y: BitSetAvx512) =
        ## 確保済みのdstへx & ~yを書き込みます。全て同じ長さが必要です。O(ビット数 / 64)。
        ## 領域確保・中間集合は不要で、dstにxやy自身を指定することもできます。
        ## AVX-512経路の目安: 512ビットあたり論理演算1命令。ロード・ストアと末尾のマスクは別です。
        when compileOption("boundChecks"):
            checkSameSize(dst, x)
            checkSameSize(x, y)
        if x.bits.len > 0:
            avxAndNot(addr dst.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc xnorInto*(dst: var BitSetAvx512, x, y: BitSetAvx512) =
        ## 確保済みのdstへ~(x ^ y)を書き込みます。全て同じ長さが必要です。O(ビット数 / 64)。
        ## 領域確保・中間集合は不要で、dstにxやy自身を指定することもできます。
        ## AVX-512経路の目安: 512ビットあたり論理演算1命令。ロード・ストアと末尾のマスクは別です。
        when compileOption("boundChecks"):
            checkSameSize(dst, x)
            checkSameSize(x, y)
        if x.bits.len > 0:
            avxXnorAssign(addr dst.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t)
            dst.trim()

    proc `&`*(x, y: BitSetAvx512): BitSetAvx512 =
        ## 共通部分を返します。
        ## AVX-512経路の目安: 512ビットあたりAND 1命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        result = initBitSet(x.size)
        if x.bits.len > 0:
            avxAnd(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `&=`*(x: var BitSetAvx512, y: BitSetAvx512) =
        ## 自身を共通部分に更新します。
        ## AVX-512経路の目安: 512ビットあたりAND 1命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.bits.len > 0:
            avxAnd(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc andNotAssign*(x: var BitSetAvx512, y: BitSetAvx512) =
        ## xを差集合x & ~yに更新します。O(ビット数 / 64)。
        ## AVX-512経路の目安: 512ビットあたりANDNOT 1命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.bits.len > 0:
            avxAndNot(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    template `&=~`*(x: var BitSetAvx512, y: BitSetAvx512) =
        ## xを差集合x & ~yに更新します。O(ビット数 / 64)。
        ## AVX-512経路の目安: 512ビットあたりANDNOT 1命令。テンプレートの追加命令はありません。
        andNotAssign(x, y)

    proc selectAssign*(x: var BitSetAvx512, y, mask: BitSetAvx512) =
        ## maskが1の位置だけxをyの値に置き換えます。O(ビット数 / 64)。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ 1命令。AVX2経路は256ビットあたり3命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            checkSameSize(x, mask)
        if x.bits.len > 0:
            avxSelectAssign(addr x.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr mask.bits[0], x.bits.len.csize_t)

    proc orAndAssign*(x: var BitSetAvx512, y, z: BitSetAvx512) =
        ## xをx | (y & z)に更新します。O(ビット数 / 64)。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ 1命令。AVX2経路は256ビットあたり2命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            checkSameSize(x, z)
        if x.bits.len > 0:
            avxOrAndAssign(addr x.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr z.bits[0], x.bits.len.csize_t)

    proc andOrAssign*(x: var BitSetAvx512, y, z: BitSetAvx512) =
        ## xをx & (y | z)に更新します。O(ビット数 / 64)。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ 1命令。AVX2経路は256ビットあたり2命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            checkSameSize(x, z)
        if x.bits.len > 0:
            avxAndOrAssign(addr x.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr z.bits[0], x.bits.len.csize_t)

    proc xorAndAssign*(x: var BitSetAvx512, y, z: BitSetAvx512) =
        ## xをx ^ (y & z)に更新します。O(ビット数 / 64)。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ 1命令。AVX2経路は256ビットあたり2命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            checkSameSize(x, z)
        if x.bits.len > 0:
            avxXorAndAssign(addr x.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr z.bits[0], x.bits.len.csize_t)

    proc majority*(x, y, z: BitSetAvx512): BitSetAvx512 =
        ## 3集合のうち2集合以上に含まれる位置の集合を返します。O(ビット数 / 64)。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ 1命令。AVX2経路は256ビットあたり4命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            checkSameSize(x, z)
        result = initBitSet(x.size)
        if x.bits.len > 0:
            avxMajority(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr z.bits[0], x.bits.len.csize_t)

    proc xnor*(x, y: BitSetAvx512): BitSetAvx512 =
        ## 入力を変更せず~(x ^ y)を返し、範囲外のビットを0にします。O(ビット数 / 64)。中間集合は作りません。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ 1命令。AVX2経路は256ビットあたり2命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        result = initBitSet(x.size)
        if x.bits.len > 0:
            avxXnorAssign(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t)
            result.trim()

    proc xnorAssign*(x: var BitSetAvx512, y: BitSetAvx512) =
        ## xを~(x ^ y)に更新し、範囲外のビットを0にします。O(ビット数 / 64)。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ 1命令。AVX2経路は256ビットあたり2命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.bits.len > 0:
            avxXnorAssign(addr x.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t)
            x.trim()

    proc `|`*(x, y: BitSetAvx512): BitSetAvx512 =
        ## 和集合を返します。
        ## AVX-512経路の目安: 512ビットあたりOR 1命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        result = initBitSet(x.size)
        if x.bits.len > 0:
            avxOr(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `|=`*(x: var BitSetAvx512, y: BitSetAvx512) =
        ## 自身を和集合に更新します。
        ## AVX-512経路の目安: 512ビットあたりOR 1命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.bits.len > 0:
            avxOr(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `^`*(x, y: BitSetAvx512): BitSetAvx512 =
        ## 対称差を返します。
        ## AVX-512経路の目安: 512ビットあたりXOR 1命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        result = initBitSet(x.size)
        if x.bits.len > 0:
            avxXor(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `^=`*(x: var BitSetAvx512, y: BitSetAvx512) =
        ## 自身を対称差に更新します。
        ## AVX-512経路の目安: 512ビットあたりXOR 1命令。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.bits.len > 0:
            avxXor(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)

    proc `<<`*(bitset: BitSetAvx512, x: int): BitSetAvx512 =
        ## 添字が大きい方向へxビットずらし、範囲外を切り捨てます。
        ## AVX-512経路の目安: 出力512ビットあたりシフト2命令＋OR 1命令。64の倍数のシフトはコピーのみ。
        when compileOption("boundChecks"):
            if x < 0:
                raise newException(ValueError, "shift count must be non-negative")
        result = initBitSet(bitset.size)
        if x < bitset.size:
            avxShl(addr result.bits[0], unsafeAddr bitset.bits[0], bitset.bits.len.csize_t, x.csize_t)
            result.trim()

    proc `>>`*(bitset: BitSetAvx512, x: int): BitSetAvx512 =
        ## 添字が小さい方向へxビットずらし、範囲外を切り捨てます。
        ## AVX-512経路の目安: 出力512ビットあたりシフト2命令＋OR 1命令。64の倍数のシフトはコピーのみ。
        when compileOption("boundChecks"):
            if x < 0:
                raise newException(ValueError, "shift count must be non-negative")
        result = initBitSet(bitset.size)
        if x < bitset.size:
            avxShr(addr result.bits[0], unsafeAddr bitset.bits[0], bitset.bits.len.csize_t, x.csize_t)

    proc `~`*(x: BitSetAvx512): BitSetAvx512 =
        ## 集合のビット数を保ったまま各ビットを反転します。
        ## AVX-512経路の目安: 512ビットあたり反転 1命令（全ビット1とのXORなど）。
        result = initBitSet(x.size)
        if x.bits.len > 0:
            avxNot(addr result.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t)
            result.trim()

    proc andAssignPopcount*(x: var BitSetAvx512, y: BitSetAvx512): int =
        ## xをx & yに更新し、更新後の要素数を返します。O(ビット数 / 64)、1回の走査です。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ＋VPOPCNTQ＋累積加算の計3命令。保存・最終集約・端数処理は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.size > 0:
            result = avxAndAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr x.bits[0], x.size.csize_t).int

    proc orAssignPopcount*(x: var BitSetAvx512, y: BitSetAvx512): int =
        ## xをx | yに更新し、更新後の要素数を返します。O(ビット数 / 64)、1回の走査です。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ＋VPOPCNTQ＋累積加算の計3命令。保存・最終集約・端数処理は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.size > 0:
            result = avxOrAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr x.bits[0], x.size.csize_t).int

    proc xorAssignPopcount*(x: var BitSetAvx512, y: BitSetAvx512): int =
        ## xをx ^ yに更新し、更新後の要素数を返します。O(ビット数 / 64)、1回の走査です。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ＋VPOPCNTQ＋累積加算の計3命令。保存・最終集約・端数処理は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.size > 0:
            result = avxXorAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr x.bits[0], x.size.csize_t).int

    proc andNotAssignPopcount*(x: var BitSetAvx512, y: BitSetAvx512): int =
        ## xをx & ~yに更新し、更新後の要素数を返します。O(ビット数 / 64)、1回の走査です。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ＋VPOPCNTQ＋累積加算の計3命令。保存・最終集約・端数処理は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.size > 0:
            result = avxAndNotAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr x.bits[0], x.size.csize_t).int

    proc selectAssignPopcount*(x: var BitSetAvx512, y, mask: BitSetAvx512): int =
        ## xをmaskが1の位置だけyを採用した集合に更新し、更新後の要素数を返します。O(ビット数 / 64)、1回の走査です。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ＋VPOPCNTQ＋累積加算の計3命令。保存・最終集約・端数処理は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            checkSameSize(x, mask)
        if x.size > 0:
            result = avxSelectAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr mask.bits[0], x.size.csize_t).int

    proc orAndAssignPopcount*(x: var BitSetAvx512, y, z: BitSetAvx512): int =
        ## xをx | (y & z)に更新し、更新後の要素数を返します。O(ビット数 / 64)、1回の走査です。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ＋VPOPCNTQ＋累積加算の計3命令。保存・最終集約・端数処理は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            checkSameSize(x, z)
        if x.size > 0:
            result = avxOrAndAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr z.bits[0], x.size.csize_t).int

    proc andOrAssignPopcount*(x: var BitSetAvx512, y, z: BitSetAvx512): int =
        ## xをx & (y | z)に更新し、更新後の要素数を返します。O(ビット数 / 64)、1回の走査です。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ＋VPOPCNTQ＋累積加算の計3命令。保存・最終集約・端数処理は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            checkSameSize(x, z)
        if x.size > 0:
            result = avxAndOrAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr z.bits[0], x.size.csize_t).int

    proc xorAndAssignPopcount*(x: var BitSetAvx512, y, z: BitSetAvx512): int =
        ## xをx ^ (y & z)に更新し、更新後の要素数を返します。O(ビット数 / 64)、1回の走査です。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ＋VPOPCNTQ＋累積加算の計3命令。保存・最終集約・端数処理は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            checkSameSize(x, z)
        if x.size > 0:
            result = avxXorAndAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr z.bits[0], x.size.csize_t).int

    proc xnorAssignPopcount*(x: var BitSetAvx512, y: BitSetAvx512): int =
        ## xを~(x ^ y)に更新し、更新後の要素数を返します。O(ビット数 / 64)、1回の走査です。
        ## AVX-512経路の目安: 512ビットあたりVPTERNLOGQ＋VPOPCNTQ＋累積加算の計3命令。保存・最終集約・端数処理は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.size > 0:
            result = avxXnorAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr x.bits[0], x.size.csize_t).int

    proc popcount*(x: BitSetAvx512): int =
        ## 立っているビットの個数を返します。
        ## AVX-512経路の目安: 512ビットあたりVPOPCNTQ 1命令＋累積加算1命令。最後の8レーンの集約は別途必要です。
        if x.bits.len > 0:
            result = avxPopcount(unsafeAddr x.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t).int

    proc andpopcount*(x, y: BitSetAvx512): int =
        ## 共通部分の要素数を、一時的な集合を作らずに返します。
        ## AVX-512経路の目安: 512ビットあたりAND＋VPOPCNTQ＋累積加算の計3命令。最後の8レーンの集約は別途必要です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.bits.len > 0:
            result = avxAndPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int

    proc orpopcount*(x, y: BitSetAvx512): int =
        ## 和集合の要素数を、一時的な集合を作らずに返します。
        ## AVX-512経路の目安: 512ビットあたりOR＋VPOPCNTQ＋累積加算の計3命令。最後の8レーンの集約は別途必要です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.bits.len > 0:
            result = avxOrPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int

    proc xorpopcount*(x, y: BitSetAvx512): int =
        ## 対称差の要素数を、一時的な集合を作らずに返します。
        ## AVX-512経路の目安: 512ビットあたりXOR＋VPOPCNTQ＋累積加算の計3命令。最後の8レーンの集約は別途必要です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.bits.len > 0:
            result = avxXorPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int

    proc popcountrange*(x: BitSetAvx512, l, r: int): int =
        ## xの半開区間[l, r)の要素数を返します。0 <= l <= r <= len(x)。O(1 + (r-l) / 64)。
        ## 一時集合は作らず、両端の最大2ワードだけをマスクします。空区間は0です。
        ## AVX-512経路の目安: 中央の完全な512ビットあたり約2演算命令。両端のマスク・個数計算と最終集約は別です。
        when compileOption("boundChecks"):
            if l < 0 or l > r or r > x.size:
                raise newException(IndexDefect, "BitSet range out of bounds")
        if l < r:
            result = avxPopcountRange(unsafeAddr x.bits[0], unsafeAddr x.bits[0], l.csize_t, r.csize_t).int

    proc andpopcountrange*(x, y: BitSetAvx512, l, r: int): int =
        ## xとyの共通部分の半開区間[l, r)の要素数を返します。0 <= l <= r <= len(x)。O(1 + (r-l) / 64)。
        ## 一時集合は作らず、両端の最大2ワードだけをマスクします。空区間は0です。
        ## AVX-512経路の目安: 中央の完全な512ビットあたり約3演算命令。両端のマスク・個数計算と最終集約は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            if l < 0 or l > r or r > x.size:
                raise newException(IndexDefect, "BitSet range out of bounds")
        if l < r:
            result = avxAndpopcountRange(unsafeAddr x.bits[0], unsafeAddr y.bits[0], l.csize_t, r.csize_t).int

    proc orpopcountrange*(x, y: BitSetAvx512, l, r: int): int =
        ## xとyの和集合の半開区間[l, r)の要素数を返します。0 <= l <= r <= len(x)。O(1 + (r-l) / 64)。
        ## 一時集合は作らず、両端の最大2ワードだけをマスクします。空区間は0です。
        ## AVX-512経路の目安: 中央の完全な512ビットあたり約3演算命令。両端のマスク・個数計算と最終集約は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            if l < 0 or l > r or r > x.size:
                raise newException(IndexDefect, "BitSet range out of bounds")
        if l < r:
            result = avxOrpopcountRange(unsafeAddr x.bits[0], unsafeAddr y.bits[0], l.csize_t, r.csize_t).int

    proc xorpopcountrange*(x, y: BitSetAvx512, l, r: int): int =
        ## xとyの対称差の半開区間[l, r)の要素数を返します。0 <= l <= r <= len(x)。O(1 + (r-l) / 64)。
        ## 一時集合は作らず、両端の最大2ワードだけをマスクします。空区間は0です。
        ## AVX-512経路の目安: 中央の完全な512ビットあたり約3演算命令。両端のマスク・個数計算と最終集約は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
            if l < 0 or l > r or r > x.size:
                raise newException(IndexDefect, "BitSet range out of bounds")
        if l < r:
            result = avxXorpopcountRange(unsafeAddr x.bits[0], unsafeAddr y.bits[0], l.csize_t, r.csize_t).int

    proc intersects*(x, y: BitSetAvx512): bool =
        ## 共通要素があるかを判定します。最悪O(ビット数 / 64)。結果が確定すると終了します。
        ## AVX-512経路は512ビットあたりテスト1命令、AVX2経路は256ビットあたりVPTEST 1命令が目安です。条件判定は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        if x.bits.len > 0:
            result = avxIntersects(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t) != 0

    proc isSubsetOf*(x, y: BitSetAvx512): bool =
        ## xがyの部分集合かを判定します。最悪O(ビット数 / 64)。結果が確定すると終了します。
        ## AVX-512経路は512ビットあたりANDNOT＋テストの2命令、AVX2経路は256ビットあたりVPTEST 1命令が目安です。条件判定は別です。
        when compileOption("boundChecks"):
            checkSameSize(x, y)
        result = true
        if x.bits.len > 0:
            result = avxSubset(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t) != 0

    proc nextSetBit*(x: BitSetAvx512, start: int): int =
        ## start以上で最初の1の添字を返し、なければ-1を返します。0 <= start <= len(x)。最悪O(ビット数 / 64)。
        ## SIMD命令は使わず、64ビットワードを走査して末尾の0の個数から位置を求めます。
        when compileOption("boundChecks"):
            if start < 0 or start > x.size:
                raise newException(IndexDefect, "BitSet index out of bounds")
        result = -1
        if start < x.size:
            var wordIndex = start shr 6
            var word = x.bits[wordIndex] and ((not 0'u64) shl (start and 63))
            while true:
                if word != 0:
                    return wordIndex * 64 + word.countTrailingZeroBits()
                inc wordIndex
                if wordIndex >= x.bits.len: break
                word = x.bits[wordIndex]

    proc xnorpopcount*(x, y: BitSetAvx512): int =
        ## ビットが一致する位置の個数を、一時集合を作らずに返します。O(ビット数 / 64)。
        ## xorpopcountと同じSIMD処理に、スカラー減算1命令を加えます。
        x.size - xorpopcount(x, y)

    proc setRange*(x: var BitSetAvx512, l, r: int) =
        ## 半開区間[l, r)のビットを1に更新します。範囲外は維持します。O(1 + (r-l) / 64)。
        ## 中央の完全なブロックは全ビット1のストアで更新し、論理演算は不要です。両端のマスク処理は別です。
        when compileOption("boundChecks"):
            if l < 0 or l > r or r > x.size:
                raise newException(IndexDefect, "BitSet range out of bounds")
        if l < r:
            avxSetRange(addr x.bits[0], l.csize_t, r.csize_t)

    proc clearRange*(x: var BitSetAvx512, l, r: int) =
        ## 半開区間[l, r)のビットを0に更新します。範囲外は維持します。O(1 + (r-l) / 64)。
        ## 中央の完全なブロックはゼロのストアで更新し、論理演算は不要です。両端のマスク処理は別です。
        when compileOption("boundChecks"):
            if l < 0 or l > r or r > x.size:
                raise newException(IndexDefect, "BitSet range out of bounds")
        if l < r:
            avxClearRange(addr x.bits[0], l.csize_t, r.csize_t)

    proc flipRange*(x: var BitSetAvx512, l, r: int) =
        ## 半開区間[l, r)のビットを反転更新します。範囲外は維持します。O(1 + (r-l) / 64)。
        ## 512ビットあたり反転1命令が目安です。ロード・ストアと両端のマスク処理は別です。
        when compileOption("boundChecks"):
            if l < 0 or l > r or r > x.size:
                raise newException(IndexDefect, "BitSet range out of bounds")
        if l < r:
            avxFlipRange(addr x.bits[0], l.csize_t, r.csize_t)

    proc clear*(x: var BitSetAvx512) =
        ## 全ビットを0にします。O(ビット数 / 64)。
        x.clearRange(0, x.size)

    proc fill*(x: var BitSetAvx512) =
        ## 有効な全ビットを1にします。O(ビット数 / 64)。
        x.setRange(0, x.size)

    proc flipAll*(x: var BitSetAvx512) =
        ## 有効な全ビットを反転します。O(ビット数 / 64)。
        x.flipRange(0, x.size)

    iterator items*(bitset: BitSetAvx512): int =
        ## 立っているビットの添字を昇順に列挙します。
        for wordIndex in 0..<bitset.bits.len:
            var word = bitset.bits[wordIndex]
            while word != 0:
                yield wordIndex * 64 + word.countTrailingZeroBits()
                word = word and (word - 1)

    proc lowestBit*(bitset: BitSetAvx512): int =
        ## 最小の要素を返し、空集合なら-1を返します。
        for wordIndex in 0..<bitset.bits.len:
            if bitset.bits[wordIndex] != 0:
                return wordIndex * 64 + bitset.bits[wordIndex].countTrailingZeroBits()
        -1

    proc `[]`*(bitset: BitSetAvx512, idx: Natural): bool =
        ## 指定した添字のビットが立っているかを返します。
        ## AVX-512命令は使いません。1ワードをスカラー命令で読み出してビットを判定します。
        when compileOption("boundChecks"):
            bitset.checkIndex(idx)
        bitset.bits[idx shr 6].testBit(idx and 63)

    proc flip*(bitset: var BitSetAvx512, idx: Natural) {.inline.} =
        ## 指定した添字のビットを反転します。O(1)。
        ## AVX-512命令は使いません。1ワードをスカラー命令で更新します。
        when compileOption("boundChecks"):
            bitset.checkIndex(idx)
        bitset.bits[idx shr 6] = bitset.bits[idx shr 6] xor (1'u64 shl (idx and 63))

    proc `[]=`*(bitset: var BitSetAvx512, idx: Natural, x: bool) =
        ## 指定した添字のビットを真偽値で更新します。
        ## AVX-512命令は使いません。1ワードをスカラー命令で更新します。
        when compileOption("boundChecks"):
            bitset.checkIndex(idx)
        if x:
            bitset.bits[idx shr 6].setBit(idx and 63)
        else:
            bitset.bits[idx shr 6].clearBit(idx and 63)

    proc `[]=`*(bitset: var BitSetAvx512, idx: Natural, x: int) =
        ## 0ならビットを落とし、1なら立てます。それ以外は何もしません。
        ## AVX-512命令は使いません。1ワードをスカラー命令で更新します。
        if x == 1:
            bitset[idx] = true
        elif x == 0:
            bitset[idx] = false

    proc `$`*(bitset: BitSetAvx512): string =
        ## 添字の大きい順にビットを並べた文字列を返します。
        result = newString(bitset.size)
        for i in 0..<bitset.size:
            result[bitset.size - i - 1] = if bitset[i]: '1' else: '0'

    proc cmp*(x, y: BitSetAvx512): int =
        ## 同じ長さのビット列を添字0からfalse < trueで比較し、-1・0・1を返します。
        ## 時間O(1 + N / 64)、追加メモリO(1)。最初の相違で終了します。
        checkSameSize(x, y)
        ## 512ビットずつ比較します。AVX512F非対応時はAVX2を使います。
        if x.bits.len > 0:
            result = avxCmp(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int

    proc lexLess*(x, y: BitSetAvx512): bool {.inline.} =
        ## 添字0からfalse < trueの辞書順で小さいかを返します。時間O(1 + N / 64)、追加メモリO(1)。
        cmp(x, y) < 0

    proc `<`*(x, y: BitSetAvx512): bool {.inline.} =
        ## 添字0からfalse < trueの辞書順で小さいかを返します。時間O(1 + N / 64)、追加メモリO(1)。
        cmp(x, y) < 0

    proc `<=`*(x, y: BitSetAvx512): bool {.inline.} =
        ## 添字0からfalse < trueの辞書順で以下かを返します。時間O(1 + N / 64)、追加メモリO(1)。
        cmp(x, y) <= 0

    proc all*(x: BitSetAvx512): bool =
        ## 有効な全ビットが1かを返します。0を見つけたら終了し、長さ0ではtrueを返します。
        ## 最悪時間O(1 + N / 64)、追加メモリO(1)。
        ## 512ビットずつ判定し、AVX512F非対応時はAVX2を使います。
        if x.size > 0:
            result = avxAll(unsafeAddr x.bits[0], x.size.csize_t) != 0
        else:
            result = true

    proc any*(x: BitSetAvx512): bool =
        ## 有効なビットに1があるかを返します。1を見つけたら終了し、長さ0ではfalseを返します。
        ## 最悪時間O(1 + N / 64)、追加メモリO(1)。
        ## 512ビットずつ判定し、AVX512F非対応時はAVX2を使います。
        if x.size > 0:
            result = avxAny(unsafeAddr x.bits[0], x.size.csize_t) != 0
