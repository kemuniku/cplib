when not declared CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_VECTOR:
    const CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_VECTOR* = 1
    import bitops
    import cplib/collections/dynamic_bplus_kernels
    import cplib/collections/dynamic_quaternary_kernels
    ## 2bit桁を詰めた葉と4種類の累積個数を持つB+木。64bit int、N<=int32.high。
    ## Bは偶数4..32、葉はWワード(1..512)、容量C=32W桁。内部ノードの最小占有率は1/2。
    ## 葉の最小占有率は通常1/2、bit-planeでは再分割との往復を避けるため1/4。
    ## h=O(log_B(N/C+1)+1)。問い合わせO(Bh+W)、更新の木操作O((B+W)h)。
    ## seqプール再確保時は全ノードを移すので更新は償却。空きノードは再利用し、縮小しない。
    ## QuadVector[B,W]は既存flag設定を保つ。P=0はprefixなし、Flagsの下位6bitは既存最適化。
    ## Flagsの64はbit-plane表現。Wは偶数、Pは偶数2..128。P=2で専用更新kernelを使う。
    ## FastQuadVectorはB32/W256、bit-plane、既定64桁prefix、AVX2/AVX-512による移動・prefix更新を使う。
    ## autoはAVX2まで。AVX-512はkernel=bpkAvx512で選択する。非対応ISAの明示指定時はscalar。
    ## quadFastPrefixWordsは通常型の設定と独立。SIMD非対応時やscalar指定時も利用できる。
    ## 公開assertとoverflow/range検査は保持し、trustedは私有helperの添字・variant検査だけを省く。
    const quadPrefixWords* {.intdefine.} = 4
    const quadFastPrefixWords* {.intdefine.} = 2
    static: assert quadPrefixWords >= 1 and quadPrefixWords <= 128
    static: assert quadFastPrefixWords >= 2 and quadFastPrefixWords <= 128 and quadFastPrefixWords mod 2 == 0
    const
        quadRankBit = 1
        quadUpdateBit = 2
        quadFindBit = 4
        quadPointersBit = 8
        quadLeafCountsBit = 16
        quadTrustedBit = 32
        quadPlaneBit = 64
        quadAllFlags = 63
        quadDefaultPrefix = (when defined(quadLeafPrefix): quadPrefixWords else: 0)
        quadDefaultFlags = (when defined(quadOptimized): quadAllFlags else:
            int(defined(quadFastRank))*quadRankBit +
            int(defined(quadFusedPrefixUpdate))*quadUpdateBit +
            int(defined(quadFastFind))*quadFindBit +
            int(defined(quadNodePointers))*quadPointersBit +
            int(defined(quadDirectLeafCounts))*quadLeafCountsBit +
            int(defined(quadTrustedInternals))*quadTrustedBit)
    type
        QuadRankDigit = tuple[rank, digit: int]
        QuadPacked[W, P, Flags: static int] = object
            when (Flags and quadPlaneBit) != 0:
                low, high: array[W div 2+1, uint64]
            else:
                words: array[W+1, uint64]
            n: int
            counts: array[4, int]
            when P > 0:
                prefixes: array[W div P+2, array[4, uint16]]
        QuadNode[B, W, P, Flags: static int] = object
            used: int
            size: int32
            totals: array[4, int32]
            case leaf: bool
            of true: bits: QuadPacked[W, P, Flags]
            of false:
                child: array[B+1, int32]
                sizes: array[B+1, int32]
                counts: array[4, array[B+1, int32]]
        QuadVector*[B, W: static int; P: static int = quadDefaultPrefix; Flags: static int = quadDefaultFlags] = ref object
            nodes: seq[QuadNode[B, W, P, Flags]]
            free: seq[int]
            root: int
            kernel: BPlusKernel
            uniform: int
        FastQuadVector* = QuadVector[32, 256, quadFastPrefixWords, quadAllFlags or quadPlaneBit]
    template quadRankFor(Flags: static int; a: ptr uint64; p, d, mode: cint): untyped =
        ## 型の設定に従い通常版または短いrank向けのkernelを選ぶ。
        when (Flags and quadRankBit) != 0: quadRankFastRaw(a, p, d, mode)
        else: quadRankBaseRaw(a, p, d, mode)
    template quadRanksFor(Flags: static int; a: ptr uint64; p: cint; counts: ptr cint): untyped =
        ## 型の設定に従い全4桁rankのkernelを選ぶ。
        when (Flags and quadRankBit) != 0: quadRanksFastRaw(a, p, counts)
        else: quadRanksBaseRaw(a, p, counts)
    proc quadFind[B, Flags: static int](p: ptr int32; n, x: int; k: BPlusKernel): int {.inline.} =
        ## 累積配列の探索を選択した実装へ渡す。
        when B == 32 and (Flags and quadFindBit) != 0:
            int(quadPrefixFind32Raw(p, cint(n), cint(x), cint(ord(k)+1)))
        elif (Flags and quadFindBit) != 0:
            int(quadPrefixFindRaw(p, cint(n), cint(x), cint(ord(k)+1)))
        else:
            prefixFind(p, n, x, k)
    proc quadMask(n: int): uint64 {.inline.} =
        ## 下位n bitを返す。0<=n<64。
        (1'u64 shl n)-1
    template quadLeafMinimum(W, Flags: static int): int =
        ## bit-plane葉は結合直後の再分割を避けるため最小占有率を1/4とする。
        when (Flags and quadPlaneBit) != 0: W*8
        else: W*16
    proc matches(word: uint64; d: int): uint64 {.inline.} =
        ## dと等しい2bit桁の下位bitだけを立てる。
        let x = word xor (0x5555555555555555'u64*uint64(d))
        not (x or (x shr 1)) and 0x5555555555555555'u64
    proc rebuildPrefixes[W, P, Flags](a: var QuadPacked[W, P, Flags]; word = 0) =
        ## 変更されたワード群から後の累積個数を再計算する。
        when (Flags and quadPlaneBit) != 0:
            var counts: array[4, int]
            for i in 0..<(a.n+63) div 64:
                if i mod (P div 2) == 0:
                    for d in 0..3: a.prefixes[i div (P div 2)][d] = uint16(counts[d])
                let low = a.low[i]
                let high = a.high[i]
                let one = countSetBits(low and not high)
                let two = countSetBits(not low and high)
                let three = countSetBits(low and high)
                counts[0] += min(64, a.n-i*64)-one-two-three
                counts[1] += one
                counts[2] += two
                counts[3] += three
            a.counts = counts
            for d in 0..3: a.prefixes[(a.n+32*P-1) div (32*P)][d] = uint16(counts[d])
        elif P > 0:
            quadPrefixesRaw(addr a.words[0], cint(a.n), cint(word div P), cint(P), addr a.prefixes[0][0])
    template declarePackedRank(name: untyped) =
        proc name[W, P, Flags](a: QuadPacked[W, P, Flags]; p, d: int; k: BPlusKernel): int {.inline.} =
            ## 2bit桁dのprefix rankをO(W)で返す。kは解決済み。
            when (Flags and quadPlaneBit) == 0 or P != 2:
                if a.counts[d] == 0: return 0
                if a.counts[d] == a.n: return p
            when (Flags and quadPlaneBit) != 0 and P == 2:
                let w = p shr 6
                let low = a.low[w] xor (0'u64-uint64((d and 1) == 0))
                let high = a.high[w] xor (0'u64-uint64((d and 2) == 0))
                int(a.prefixes[w][d])+countSetBits(low and high and quadMask(p and 63))
            elif (Flags and quadPlaneBit) != 0:
                if p == a.n: return a.counts[d]
                let group = p div (32*P)
                result = int(a.prefixes[group][d])
                for i in group*(P div 2)..(p shr 6):
                    var low = a.low[i]
                    var high = a.high[i]
                    if (d and 1) == 0: low = not low
                    if (d and 2) == 0: high = not high
                    let mask = if i == p shr 6: quadMask(p and 63) else: uint64.high
                    result += countSetBits(low and high and mask)
            elif P > 0:
                let group = p div (32*P)
                int(a.prefixes[group][d])+int(quadRankFor(Flags, unsafeAddr a.words[group*P], cint(p mod (32*P)), cint(d), cint(ord(k)+1)))
            else:
                int(quadRankFor(Flags, unsafeAddr a.words[0], cint(p), cint(d), cint(ord(k)+1)))
    declarePackedRank(packedRankChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declarePackedRank(packedRankTrusted)
    {.pop.}
    proc packedRank[W, P, Flags](a: QuadPacked[W, P, Flags]; p, d: int; k: BPlusKernel): int {.inline.} =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: packedRankTrusted(a, p, d, k)
        else: packedRankChecked(a, p, d, k)
    template declarePackedRanks(name: untyped) =
        proc name[W, P, Flags](a: QuadPacked[W, P, Flags]; p: int): array[4, int] {.inline.} =
            ## 全4桁のprefix rankを同じword走査で返す。prefix有効時は末尾群だけ走査。
            when (Flags and quadPlaneBit) == 0:
                for d in 0..3:
                    if a.counts[d] == a.n:
                        result[d] = p
                        return
            when (Flags and quadPlaneBit) != 0 and P == 2:
                let w = p shr 6
                let mask = quadMask(p and 63)
                let low = a.low[w] and mask
                let high = a.high[w] and mask
                result[1] = int(a.prefixes[w][1])+countSetBits(low and not high)
                result[2] = int(a.prefixes[w][2])+countSetBits(not low and high)
                result[3] = int(a.prefixes[w][3])+countSetBits(low and high)
                result[0] = p-result[1]-result[2]-result[3]
            elif (Flags and quadPlaneBit) != 0:
                if p == a.n: return a.counts
                let group = p div (32*P)
                for d in 1..3: result[d] = int(a.prefixes[group][d])
                for i in group*(P div 2)..(p shr 6):
                    let mask = if i == p shr 6: quadMask(p and 63) else: uint64.high
                    let low = a.low[i] and mask
                    let high = a.high[i] and mask
                    result[1] += countSetBits(low and not high)
                    result[2] += countSetBits(not low and high)
                    result[3] += countSetBits(low and high)
                result[0] = p-result[1]-result[2]-result[3]
            else:
                var counts: array[4, cint]
                when P > 0:
                    let group = p div (32*P)
                    quadRanksFor(Flags, unsafeAddr a.words[group*P], cint(p mod (32*P)), addr counts[0])
                    for d in 0..3: result[d] = int(a.prefixes[group][d])+int(counts[d])
                else:
                    quadRanksFor(Flags, unsafeAddr a.words[0], cint(p), addr counts[0])
                    for d in 0..3: result[d] = int(counts[d])
    declarePackedRanks(packedRanksChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declarePackedRanks(packedRanksTrusted)
    {.pop.}
    template packedRanks[W, P, Flags](a: QuadPacked[W, P, Flags]; p: int): untyped =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: packedRanksTrusted(a, p)
        else: packedRanksChecked(a, p)
    template declarePackedRanksPair(name: untyped) =
        proc name[W, P, Flags](a: QuadPacked[W, P, Flags]; l, r: int): tuple[left, right: array[4, int]] {.inline.} =
            ## 同じ群なら一度の走査で両端を取得する。
            when (Flags and quadPlaneBit) == 0:
                for d in 0..3:
                    if a.counts[d] == a.n:
                        result.left[d] = l
                        result.right[d] = r
                        return
            var x, y: array[4, cint]
            when (Flags and quadPlaneBit) != 0:
                return (a.packedRanks(l), a.packedRanks(r))
            elif P > 0:
                let group = l div (32*P)
                if group != r div (32*P): return (a.packedRanks(l), a.packedRanks(r))
                quadRanksPairRaw(unsafeAddr a.words[group*P], cint(l mod (32*P)), cint(r mod (32*P)), addr x[0], addr y[0])
                for d in 0..3:
                    result.left[d] = int(a.prefixes[group][d])+int(x[d])
                    result.right[d] = int(a.prefixes[group][d])+int(y[d])
            else:
                quadRanksPairRaw(unsafeAddr a.words[0], cint(l), cint(r), addr x[0], addr y[0])
                for d in 0..3:
                    result.left[d] = int(x[d])
                    result.right[d] = int(y[d])
    declarePackedRanksPair(packedRanksPairChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declarePackedRanksPair(packedRanksPairTrusted)
    {.pop.}
    proc packedRanksPair[W, P, Flags](a: QuadPacked[W, P, Flags]; l, r: int): tuple[left, right: array[4, int]] {.inline.} =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: packedRanksPairTrusted(a, l, r)
        else: packedRanksPairChecked(a, l, r)
    template declarePackedAccess(name: untyped) =
        proc name[W, P, Flags](a: QuadPacked[W, P, Flags]; p: int): int {.inline.} =
            ## p番目の2bit桁をO(1)で返す。
            when (Flags and quadPlaneBit) != 0:
                int((a.low[p shr 6] shr (p and 63)) and 1) or
                    (int((a.high[p shr 6] shr (p and 63)) and 1) shl 1)
            else:
                int((a.words[p shr 5] shr (2*(p and 31))) and 3)
    declarePackedAccess(packedAccessChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declarePackedAccess(packedAccessTrusted)
    {.pop.}
    proc packedAccess[W, P, Flags](a: QuadPacked[W, P, Flags]; p: int): int {.inline.} =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: packedAccessTrusted(a, p)
        else: packedAccessChecked(a, p)
    template declareFinishPrefixes(name: untyped) =
        proc name[W, P, Flags](a: var QuadPacked[W, P, Flags]) =
            ## 末尾prefixを更新する。64桁bit-planeでは実際に参照する境界だけ保存する。
            when (Flags and quadPlaneBit) != 0 and P == 2:
                if (a.n and 63) == 0:
                    for d in 0..3: a.prefixes[a.n shr 6][d] = uint16(a.counts[d])
            elif P > 0:
                let last = (a.n+32*P-1) div (32*P)
                for d in 0..3: a.prefixes[last][d] = uint16(a.counts[d])
    declareFinishPrefixes(finishPrefixesChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declareFinishPrefixes(finishPrefixesTrusted)
    {.pop.}
    proc finishPrefixes[W, P, Flags](a: var QuadPacked[W, P, Flags]) {.inline.} =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: finishPrefixesTrusted(a)
        else: finishPrefixesChecked(a)
    proc updatePackedPrefix(counts: var array[4, uint16]; oldDigit, newDigit: int) {.inline.} =
        ## 4個の累積値を一括で更新する。減算側は正、加算後はuint16の範囲内。
        var packed: uint64
        copyMem(addr packed, addr counts[0], sizeof(packed))
        when cpuEndian == littleEndian:
            packed = packed + (1'u64 shl (16*newDigit)) - (1'u64 shl (16*oldDigit))
        else:
            packed = packed + (1'u64 shl (16*(3-newDigit))) - (1'u64 shl (16*(3-oldDigit)))
        copyMem(addr counts[0], addr packed, sizeof(packed))
    template declarePackedInsert(name: untyped) =
        proc name[W, P, Flags](a: var QuadPacked[W, P, Flags]; p, d: int; k: BPlusKernel) =
            ## 群境界から押し出される1桁だけを引き、prefixを差分更新する。
            when P > 0 and not ((Flags and quadPlaneBit) != 0 and P == 2):
                for j in p div (32*P)+1..(a.n+1) div (32*P):
                    let boundary = j*32*P
                    if boundary <= a.n:
                        updatePackedPrefix(a.prefixes[j], a.packedAccess(boundary-1), d)
                    else:
                        for x in 0..3: a.prefixes[j][x] = uint16(a.counts[x]+int(x == d))
            when (Flags and quadPlaneBit) != 0 and P == 2:
                quadPlaneInsertRaw(addr a.low[0], addr a.high[0], addr a.prefixes[0][0],
                    cint(a.n), cint(p), cint(d), cint(ord(k)+1))
            elif (Flags and quadPlaneBit) != 0:
                let w = p shr 6
                for i in countdown(a.n shr 6, w+1):
                    a.low[i] = (a.low[i] shl 1) or (a.low[i-1] shr 63)
                    a.high[i] = (a.high[i] shl 1) or (a.high[i-1] shr 63)
                let mask = quadMask(p and 63)
                a.low[w] = (a.low[w] and mask) or ((a.low[w] and not mask) shl 1) or (uint64(d and 1) shl (p and 63))
                a.high[w] = (a.high[w] and mask) or ((a.high[w] and not mask) shl 1) or (uint64(d shr 1) shl (p and 63))
            else:
                quadInsertRaw(addr a.words[0], cint(a.n), cint(p), cint(d), cint(ord(k)+1))
            inc a.n
            inc a.counts[d]
            a.finishPrefixes()
    declarePackedInsert(packedInsertChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declarePackedInsert(packedInsertTrusted)
    {.pop.}
    proc packedInsert[W, P, Flags](a: var QuadPacked[W, P, Flags]; p, d: int; k: BPlusKernel) {.inline.} =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: packedInsertTrusted(a, p, d, k)
        else: packedInsertChecked(a, p, d, k)
    template declarePackedErase(name: untyped) =
        proc name[W, P, Flags](a: var QuadPacked[W, P, Flags]; p: int; k: BPlusKernel): int =
            ## 群境界へ入る1桁だけを足し、prefixを差分更新する。
            result = a.packedAccess(p)
            when P > 0 and not ((Flags and quadPlaneBit) != 0 and P == 2):
                for j in p div (32*P)+1..(a.n-1) div (32*P):
                    updatePackedPrefix(a.prefixes[j], result, a.packedAccess(j*32*P))
            when (Flags and quadPlaneBit) != 0 and P == 2:
                quadPlaneEraseRaw(addr a.low[0], addr a.high[0], addr a.prefixes[0][0],
                    cint(a.n), cint(p), cint(result), cint(ord(k)+1))
            elif (Flags and quadPlaneBit) != 0:
                let w = p shr 6
                let mask = quadMask(p and 63)
                a.low[w] = (a.low[w] and mask) or (((a.low[w] shr 1) or (a.low[w+1] shl 63)) and not mask)
                a.high[w] = (a.high[w] and mask) or (((a.high[w] shr 1) or (a.high[w+1] shl 63)) and not mask)
                for i in w+1..((a.n-1) shr 6):
                    a.low[i] = (a.low[i] shr 1) or (a.low[i+1] shl 63)
                    a.high[i] = (a.high[i] shr 1) or (a.high[i+1] shl 63)
            else:
                quadEraseRaw(addr a.words[0], cint(a.n), cint(p), cint(ord(k)+1))
            dec a.n
            dec a.counts[result]
            a.finishPrefixes()
    declarePackedErase(packedEraseChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declarePackedErase(packedEraseTrusted)
    {.pop.}
    proc packedErase[W, P, Flags](a: var QuadPacked[W, P, Flags]; p: int; k: BPlusKernel): int {.inline.} =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: packedEraseTrusted(a, p, k)
        else: packedEraseChecked(a, p, k)
    proc packedSlice[W, P, Flags](a: QuadPacked[W, P, Flags]; first, length: int; k: BPlusKernel): QuadPacked[W, P, Flags] =
        ## 桁区間をワード単位で取り出す。O(W)。
        result.n = length
        when (Flags and quadPlaneBit) != 0:
            for i in 0..<(length+63) div 64:
                let q = (first shr 6)+i
                let shift = first and 63
                result.low[i] = a.low[q] shr shift
                result.high[i] = a.high[q] shr shift
                if shift != 0 and q+1 < a.low.len:
                    result.low[i] = result.low[i] or (a.low[q+1] shl (64-shift))
                    result.high[i] = result.high[i] or (a.high[q+1] shl (64-shift))
            if (length and 63) != 0:
                result.low[length shr 6] = result.low[length shr 6] and quadMask(length and 63)
                result.high[length shr 6] = result.high[length shr 6] and quadMask(length and 63)
        else:
            for i in 0..<(length+31) div 32:
                let p = 2*first+i*64
                let q = p shr 6
                let shift = p and 63
                result.words[i] = a.words[q] shr shift
                if shift != 0 and q+1 < a.words.len: result.words[i] = result.words[i] or (a.words[q+1] shl (64-shift))
            if (length and 31) != 0: result.words[length shr 5] = result.words[length shr 5] and quadMask(2*(length and 31))
        result.rebuildPrefixes()
        result.counts = result.packedRanks(length)
    proc packedJoin[W, P, Flags](a, b: QuadPacked[W, P, Flags]; k: BPlusKernel): QuadPacked[W, P, Flags] =
        ## 合計32W+1桁以下の2列をO(W)で連結する。
        result = a
        when (Flags and quadPlaneBit) != 0:
            for i in 0..<(b.n+63) div 64:
                let q = (a.n shr 6)+i
                let shift = a.n and 63
                result.low[q] = result.low[q] or (b.low[i] shl shift)
                result.high[q] = result.high[q] or (b.high[i] shl shift)
                if shift != 0 and q+1 < result.low.len:
                    result.low[q+1] = b.low[i] shr (64-shift)
                    result.high[q+1] = b.high[i] shr (64-shift)
        else:
            for i in 0..<(b.n+31) div 32:
                let p = 2*a.n+i*64
                let q = p shr 6
                let shift = p and 63
                result.words[q] = result.words[q] or (b.words[i] shl shift)
                if shift != 0 and q+1 < result.words.len: result.words[q+1] = b.words[i] shr (64-shift)
        result.n = a.n+b.n
        for d in 0..3: result.counts[d] = a.counts[d]+b.counts[d]
        result.rebuildPrefixes(a.n shr 5)
    proc allocNode[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; leaf: bool): int =
        ## プールの空きノードを再利用する。償却 O(1)。
        if t.free.len > 0:
            result = t.free.pop()

        else:
            result = t.nodes.len
            t.nodes.add(default(QuadNode[B, W, P, Flags]))
        if leaf: t.nodes[result] = QuadNode[B, W, P, Flags](leaf: true)
        else: t.nodes[result] = QuadNode[B, W, P, Flags](leaf: false)

    proc rebuild[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v: int) =
        ## 子から長さと4桁の累積個数を再構築する。O(B)。
        if t.nodes[v].leaf:
            t.nodes[v].size = int32(t.nodes[v].bits.n)
            for d in 0..3: t.nodes[v].totals[d] = int32(t.nodes[v].bits.counts[d])
        else:
            var n: int32
            var counts: array[4, int32]
            for i in 0..<t.nodes[v].used:
                let c = t.nodes[v].child[i]
                n+=t.nodes[c].size
                t.nodes[v].sizes[i] = n
                for d in 0..3:
                    counts[d]+=t.nodes[c].totals[d]
                    t.nodes[v].counts[d][i] = counts[d]
            t.nodes[v].size = n
            t.nodes[v].totals = counts
    proc refreshUniform[B, W, P, Flags](t: QuadVector[B, W, P, Flags]) {.inline.} =
        ## 全要素が同じ桁かを根の個数からO(1)で更新する。空列は-1。
        t.uniform = -1
        let node = addr t.nodes[t.root]
        if node.size == 0: return
        for d in 0..3:
            if node.totals[d] == node.size:
                t.uniform = d
                return
    proc initQuadVector*[B, W, P, Flags](T: typedesc[QuadVector[B, W, P, Flags]]; values: openArray[int];
            kernel: BPlusKernel = bpkAuto): T =
        ## O(N) で構築する。B は偶数 4..32、W は 1..512（葉は 32W桁、64W bit）。N <= int32.high。
        ## auto は B>=16,W>=16 で AVX2 が使える場合だけ AVX2、それ以外は scalar。
        static:
            assert B >= 4 and B <= 32 and B mod 2 == 0
            assert W >= 1 and W <= 512
            assert P >= 0 and P <= 128
            assert Flags >= 0 and (Flags and not (quadAllFlags or quadPlaneBit)) == 0
            when (Flags and quadPlaneBit) != 0:
                assert W mod 2 == 0 and P >= 2 and P mod 2 == 0
        assert values.len <= int32.high.int
        let selected = if kernel == bpkAuto and B >= 16 and W >= 16 and kernelAvailable(bpkAvx2): bpkAvx2 else: resolveKernel(kernel)
        result = T(kernel: selected)
        var initialUniform = -1
        when (Flags and quadPlaneBit) != 0:
            if values.len > 0:
                initialUniform = values[0]
                assert 0 <= initialUniform and initialUniform < 4
                for d in values:
                    if d != initialUniform:
                        initialUniform = -1
                        break
        var layer: seq[int]
        let count = max(1, (values.len+W*32-1) div (W*32))
        var p = 0
        for j in 0..<count:
            let v = result.allocNode(true)
            let n = values.len div count + int(j < values.len mod count)
            result.nodes[v].bits.n = n
            when (Flags and quadPlaneBit) != 0:
                if initialUniform >= 0:
                    for i in 0..<(n+63) div 64:
                        let mask = if n-i*64 >= 64: uint64.high else: quadMask(n-i*64)
                        if (initialUniform and 1) != 0: result.nodes[v].bits.low[i] = mask
                        if (initialUniform and 2) != 0: result.nodes[v].bits.high[i] = mask
                else:
                    for i in 0..<n:
                        let d = values[p+i]
                        assert 0 <= d and d < 4
                        result.nodes[v].bits.low[i shr 6] = result.nodes[v].bits.low[i shr 6] or (uint64(d and 1) shl (i and 63))
                        result.nodes[v].bits.high[i shr 6] = result.nodes[v].bits.high[i shr 6] or (uint64(d shr 1) shl (i and 63))
            else:
                for i in 0..<n:
                    let d = values[p+i]
                    assert 0 <= d and d < 4
                    result.nodes[v].bits.words[i shr 5] = result.nodes[v].bits.words[i shr 5] or (uint64(d) shl (2*(i and 31)))
                    inc result.nodes[v].bits.counts[d]
            p += n
            result.nodes[v].bits.rebuildPrefixes()
            result.rebuild(v)
            layer.add(v)
        while layer.len > 1:
            var next: seq[int]
            let groups = (layer.len+B-1) div B
            var p = 0
            for j in 0..<groups:
                let v = result.allocNode(false)
                let n = layer.len div groups + int(j < layer.len mod groups)
                result.nodes[v].used = n
                for i in 0..<n: result.nodes[v].child[i] = int32(layer[p+i])
                p += n
                result.rebuild(v)
                next.add(v)
            layer = move(next)
        result.root = layer[0]
        result.refreshUniform()
    proc uniformDigit*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]): int {.inline.} =
        ## 全要素が同じならその桁をO(1)で返す。空列・混在時は-1。
        t.uniform
    proc activeKernel*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]): BPlusKernel =
        ## 実際のISAを返す。
        t.kernel
    proc len*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]): int =
        ## 桁数をO(1)で返す。
        int(t.nodes[t.root].size)
    proc total*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; d: int): int =
        ## 桁dの個数をO(1)で返す。
        assert 0 <= d and d < 4
        int(t.nodes[t.root].totals[d])
    proc storageBytes*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]): int =
        ## pool論理長。余剰capacityとallocator領域を含まない。
        t.nodes.len*sizeof(QuadNode[B, W, P, Flags])+t.free.len*sizeof(int)
    proc rankAccessNode[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p: int): tuple[rank, digit: int] {.inline.}
    template declareRankAccessNode(name: untyped) =
        proc name[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p: int): QuadRankDigit =
            ## 値が分かってから帰り道でその桁のprefixを加算する。
            when (Flags and quadPointersBit) != 0:
                var node = addr t.nodes[v]
            template currentNode(): untyped =
                when (Flags and quadPointersBit) != 0: node[]
                else: t.nodes[v]
            if currentNode().leaf:
                result.digit = currentNode().bits.packedAccess(p)
                result.rank = currentNode().bits.packedRank(p, result.digit, t.kernel)
                return
            let j = quadFind[B, Flags](addr currentNode().sizes[0], currentNode().used, p, t.kernel)
            let offset = if j == 0: 0 else: int(currentNode().sizes[j-1])
            result = t.rankAccessNode(currentNode().child[j], p-offset)
            if j > 0: result.rank+=int(currentNode().counts[result.digit][j-1])
    declareRankAccessNode(rankAccessNodeChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declareRankAccessNode(rankAccessNodeTrusted)
    {.pop.}
    proc rankAccessNode[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p: int): tuple[rank, digit: int] =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: rankAccessNodeTrusted(t, v, p)
        else: rankAccessNodeChecked(t, v, p)
    proc rankAccess*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; p: int): tuple[rank, digit: int] =
        ## pの桁とその桁の[0,p)個数を返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p < t.len
        if t.uniform >= 0: return (p, t.uniform)
        t.rankAccessNode(t.root, p)
    proc replaceRankNode[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p, digit: int): tuple[oldDigit, oldRank, newRank: int] {.inline.}
    template declareReplaceRankNode(name: untyped) =
        proc name[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p, digit: int): tuple[oldDigit, oldRank, newRank: int] =
            ## 1回の降下で桁を置換し、旧桁と新旧rankを帰り道で累積する。
            when (Flags and quadPointersBit) != 0:
                var node = addr t.nodes[v]
            template currentNode(): untyped =
                when (Flags and quadPointersBit) != 0: node[]
                else: t.nodes[v]
            if currentNode().leaf:
                result.oldDigit = currentNode().bits.packedAccess(p)
                if result.oldDigit == digit:
                    result.oldRank = currentNode().bits.packedRank(p, digit, t.kernel)
                    result.newRank = result.oldRank
                    return
                let counts = currentNode().bits.packedRanks(p)
                result.oldRank = counts[result.oldDigit]
                result.newRank = counts[digit]
                when (Flags and quadPlaneBit) != 0:
                    let changed = result.oldDigit xor digit
                    currentNode().bits.low[p shr 6] = currentNode().bits.low[p shr 6] xor (uint64(changed and 1) shl (p and 63))
                    currentNode().bits.high[p shr 6] = currentNode().bits.high[p shr 6] xor (uint64(changed shr 1) shl (p and 63))
                else:
                    currentNode().bits.words[p shr 5] = currentNode().bits.words[p shr 5] xor (uint64(result.oldDigit xor digit) shl (2*(p and 31)))
                dec currentNode().bits.counts[result.oldDigit]
                inc currentNode().bits.counts[digit]
                when P > 0:
                    const rounding = (when (Flags and quadPlaneBit) != 0 and P == 2: 0 else: 32*P-1)
                    for j in p div (32*P)+1..(currentNode().bits.n+rounding) div (32*P):
                        updatePackedPrefix(currentNode().bits.prefixes[j], result.oldDigit, digit)
                dec currentNode().totals[result.oldDigit]
                inc currentNode().totals[digit]
                return
            let j = quadFind[B, Flags](addr currentNode().sizes[0], currentNode().used, p, t.kernel)
            let offset = if j == 0: 0 else: int(currentNode().sizes[j-1])
            result = t.replaceRankNode(currentNode().child[j], p-offset, digit)
            if j > 0:
                result.oldRank+=int(currentNode().counts[result.oldDigit][j-1])
                result.newRank+=int(currentNode().counts[digit][j-1])
            if result.oldDigit != digit:
                prefixAdd(addr currentNode().counts[result.oldDigit][j], currentNode().used-j, -1, t.kernel)
                prefixAdd(addr currentNode().counts[digit][j], currentNode().used-j, 1, t.kernel)
                dec currentNode().totals[result.oldDigit]
                inc currentNode().totals[digit]
    declareReplaceRankNode(replaceRankNodeChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declareReplaceRankNode(replaceRankNodeTrusted)
    {.pop.}
    proc replaceRankNode[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p, digit: int): tuple[oldDigit, oldRank, newRank: int] =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: replaceRankNodeTrusted(t, v, p, digit)
        else: replaceRankNodeChecked(t, v, p, digit)
    proc replaceRank*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; p, digit: int): tuple[oldDigit, oldRank, newRank: int] {.discardable.} =
        ## pをdigitへ置換し、旧桁と新旧桁の[0,p)rankを返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p < t.len and 0 <= digit and digit < 4
        if t.nodes[t.root].totals[digit] == t.nodes[t.root].size:
            return (digit, p, p)
        result = t.replaceRankNode(t.root, p, digit)
        if result.oldDigit != digit:
            t.uniform = if t.nodes[t.root].totals[digit] == t.nodes[t.root].size: digit else: -1
    proc `[]`*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; p: int): int =
        ## p番目の桁を返す。
        t.rankAccess(p).digit
    template declareRankFrom(name: untyped) =
        proc name[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; start, p, d: int): int =
            ## 部分木から桁dのprefix rankを求める。
            var v = start
            when (Flags and quadPointersBit) != 0:
                var node = addr t.nodes[v]
            template currentNode(): untyped =
                when (Flags and quadPointersBit) != 0: node[]
                else: t.nodes[v]
            var p = p
            if p == 0: return 0
            if p == int(currentNode().size): return int(currentNode().totals[d])
            while not currentNode().leaf:
                let j = quadFind[B, Flags](addr currentNode().sizes[0], currentNode().used, p, t.kernel)
                if j > 0:
                    p-=int(currentNode().sizes[j-1])
                    result+=int(currentNode().counts[d][j-1])
                v = currentNode().child[j]
                when (Flags and quadPointersBit) != 0: node = addr t.nodes[v]
            result+=currentNode().bits.packedRank(p, d, t.kernel)
    declareRankFrom(rankFromChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declareRankFrom(rankFromTrusted)
    {.pop.}
    proc rankFrom[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; start, p, d: int): int {.inline.} =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: rankFromTrusted(t, start, p, d)
        else: rankFromChecked(t, start, p, d)
    proc rank*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; p, d: int): int =
        ## 桁dの[0,p)個数を返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p <= t.len and 0 <= d and d < 4
        if t.uniform >= 0: return (if t.uniform == d: p else: 0)
        t.rankFrom(t.root, p, d)
    template declareRanksFrom(name: untyped) =
        proc name[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; start, p: int): array[4, int] =
            ## 4桁のprefix rankを共有経路で返す。O(B log_B(N/W)+W)。
            var p = p
            var v = start
            when (Flags and quadPointersBit) != 0:
                var node = addr t.nodes[v]
            template currentNode(): untyped =
                when (Flags and quadPointersBit) != 0: node[]
                else: t.nodes[v]
            if p == 0: return
            if p == int(currentNode().size):
                for d in 0..3: result[d] = int(currentNode().totals[d])
                return
            while not currentNode().leaf:
                let j = quadFind[B, Flags](addr currentNode().sizes[0], currentNode().used, p, t.kernel)
                if j > 0:
                    p-=int(currentNode().sizes[j-1])
                    for d in 0..3: result[d]+=int(currentNode().counts[d][j-1])
                v = currentNode().child[j]
                when (Flags and quadPointersBit) != 0: node = addr t.nodes[v]
            let counts = currentNode().bits.packedRanks(p)
            for d in 0..3: result[d]+=counts[d]
    declareRanksFrom(ranksFromChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declareRanksFrom(ranksFromTrusted)
    {.pop.}
    proc ranksFrom[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; start, p: int): array[4, int] {.inline.} =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: ranksFromTrusted(t, start, p)
        else: ranksFromChecked(t, start, p)
    proc ranks*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; p: int): array[4, int] =
        ## 4桁のprefix rankを共有経路で返す。O(B log_B(N/W)+W)。
        assert 0 <= p and p <= t.len
        if t.uniform >= 0:
            result[t.uniform] = p
            return
        result = t.ranksFrom(t.root, p)
    proc ranksPair*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; l, r: int): tuple[left, right: array[4, int]] =
        ## 全4桁の両端rankで木の経路と葉のprefix走査を共有する。O(B log_B(N/W)+W)。
        assert 0 <= l and l <= r and r <= t.len
        if t.uniform >= 0:
            result.left[t.uniform] = l
            result.right[t.uniform] = r
            return
        var v = t.root
        when (Flags and quadPointersBit) != 0:
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when (Flags and quadPointersBit) != 0: node[]
            else: t.nodes[v]
        var l = l
        var r = r
        var before: array[4, int]
        while true:
            if l == r:
                let a = t.ranksFrom(v, l)
                for d in 0..3:
                    result.left[d] = before[d]+a[d]
                    result.right[d] = result.left[d]
                return
            if l == 0:
                let b = t.ranksFrom(v, r)
                result.left = before
                for d in 0..3: result.right[d] = before[d]+b[d]
                return
            if r == int(currentNode().size):
                let a = t.ranksFrom(v, l)
                for d in 0..3:
                    result.left[d] = before[d]+a[d]
                    result.right[d] = before[d]+int(currentNode().totals[d])
                return
            if currentNode().leaf:
                let a = currentNode().bits.packedRanksPair(l, r)
                for d in 0..3:
                    result.left[d] = before[d]+a.left[d]
                    result.right[d] = before[d]+a.right[d]
                return
            let a = quadFind[B, Flags](addr currentNode().sizes[0], currentNode().used, l, t.kernel)
            let b = if r <= int(currentNode().sizes[a]): a else: quadFind[B, Flags](addr currentNode().sizes[0], currentNode().used, r-1, t.kernel)
            let offset = if a == 0: 0 else: int(currentNode().sizes[a-1])
            if a != b:
                let offsetB = int(currentNode().sizes[b-1])
                let left = t.ranksFrom(currentNode().child[a], l-offset)
                let right = t.ranksFrom(currentNode().child[b], r-offsetB)
                for d in 0..3:
                    let count = if a == 0: 0 else: int(currentNode().counts[d][a-1])
                    result.left[d] = before[d]+count+left[d]
                    result.right[d] = before[d]+int(currentNode().counts[d][b-1])+right[d]
                return
            if a > 0:
                for d in 0..3: before[d]+=int(currentNode().counts[d][a-1])
            l-=offset
            r-=offset
            v = currentNode().child[a]
            when (Flags and quadPointersBit) != 0: node = addr t.nodes[v]
    proc rankPair*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; l, r, d: int): tuple[left, right: int] =
        ## 同じ桁の両端rankで共有経路を一度だけ辿る。O(B log_B(N/W)+W)。
        assert 0 <= l and l <= r and r <= t.len and 0 <= d and d < 4
        if t.uniform >= 0: return (if t.uniform == d: (l, r) else: (0, 0))
        var v = t.root
        when (Flags and quadPointersBit) != 0:
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when (Flags and quadPointersBit) != 0: node[]
            else: t.nodes[v]
        var l = l
        var r = r
        var before = 0
        while true:
            if l == r:
                let a = before+t.rankFrom(v, l, d)
                return (a, a)
            if l == 0: return (before, before+t.rankFrom(v, r, d))
            if r == int(currentNode().size): return (before+t.rankFrom(v, l, d), before+int(currentNode().totals[d]))
            if currentNode().leaf: break
            let a = quadFind[B, Flags](addr currentNode().sizes[0], currentNode().used, l, t.kernel)
            let b = if r <= int(currentNode().sizes[a]): a else: quadFind[B, Flags](addr currentNode().sizes[0], currentNode().used, r-1, t.kernel)
            let offset = if a == 0: 0 else: int(currentNode().sizes[a-1])
            let count = if a == 0: 0 else: int(currentNode().counts[d][a-1])
            if a != b:
                let offsetB = if b == 0: 0 else: int(currentNode().sizes[b-1])
                let countB = if b == 0: 0 else: int(currentNode().counts[d][b-1])
                return (before+count+t.rankFrom(currentNode().child[a], l-offset, d), before+countB+t.rankFrom(currentNode().child[b], r-offsetB, d))
            before+=count
            l-=offset
            r-=offset
            v = currentNode().child[a]
            when (Flags and quadPointersBit) != 0: node = addr t.nodes[v]
        result.left = before+currentNode().bits.packedRank(l, d, t.kernel)
        result.right = before+currentNode().bits.packedRank(r, d, t.kernel)
    template declareAddSizeCount(name: untyped) =
        proc name[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, j, digit, delta: int) {.inline.} =
            ## 長さと一種類の累積個数をまとめて更新する。
            when (Flags and quadUpdateBit) != 0:
                quadPrefixAddPairRaw(addr t.nodes[v].sizes[j], addr t.nodes[v].counts[digit][j], cint(t.nodes[v].used-j), cint(delta), cint(ord(t.kernel)+1))
            else:
                prefixAdd(addr t.nodes[v].sizes[j], t.nodes[v].used-j, delta, t.kernel)
                prefixAdd(addr t.nodes[v].counts[digit][j], t.nodes[v].used-j, delta, t.kernel)
    declareAddSizeCount(addSizeCountChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declareAddSizeCount(addSizeCountTrusted)
    {.pop.}
    proc addSizeCount[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, j, digit, delta: int) {.inline.} =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: addSizeCountTrusted(t, v, j, digit, delta)
        else: addSizeCountChecked(t, v, j, digit, delta)
    proc insertNode[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p: int; digit: int;
            before: var int): int {.inline.}
    template declareInsertNode(name: untyped) =
        proc name[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p: int; digit: int;
                before: var int): int =
            ## 挿入し、分割した場合は右ノードを返す。分割なしは -1。
            when (Flags and quadPointersBit) != 0:
                var node = addr t.nodes[v]
            template currentNode(): untyped =
                when (Flags and quadPointersBit) != 0: node[]
                else: t.nodes[v]
            result = -1
            if currentNode().leaf:
                before += currentNode().bits.packedRank(p, digit, t.kernel)
                currentNode().bits.packedInsert(p, digit, t.kernel)
                if currentNode().bits.n > W*32:
                    let right = t.allocNode(true)
                    when (Flags and quadPointersBit) != 0: node = addr t.nodes[v]
                    t.nodes[right].bits = currentNode().bits.packedSlice(W*16, W*16+1, t.kernel)
                    currentNode().bits = currentNode().bits.packedSlice(0, W*16, t.kernel)
                    t.rebuild(right)
                    result = right
                when (Flags and quadLeafCountsBit) != 0:
                    if result < 0:
                        inc currentNode().size
                        inc currentNode().totals[digit]
                    else: t.rebuild(v)
                else: t.rebuild(v)
                return
            let j = min(currentNode().used-1, quadFind[B, Flags](addr currentNode().sizes[0], currentNode().used, p, t.kernel))
            let offset = if j == 0: 0 else: int(currentNode().sizes[j-1])
            if j > 0: before += int(currentNode().counts[digit][j-1])
            let right = t.insertNode(currentNode().child[j], p-offset, digit, before)
            when (Flags and quadPointersBit) != 0: node = addr t.nodes[v]
            if right < 0:
                t.addSizeCount(v, j, digit, 1)
                inc currentNode().size
                inc currentNode().totals[digit]
                return
            for i in countdown(currentNode().used, j+2): currentNode().child[i] = currentNode().child[i-1]
            currentNode().child[j+1] = int32(right)
            inc currentNode().used
            if currentNode().used > B:
                let r = t.allocNode(false)
                when (Flags and quadPointersBit) != 0: node = addr t.nodes[v]
                t.nodes[r].used = B+1-B div 2
                for i in 0..<t.nodes[r].used: t.nodes[r].child[i] = currentNode().child[B div 2+i]
                currentNode().used = B div 2
                t.rebuild(r)
                result = r
            t.rebuild(v)
    declareInsertNode(insertNodeChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declareInsertNode(insertNodeTrusted)
    {.pop.}
    proc insertNode[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p: int; digit: int;
            before: var int): int =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: insertNodeTrusted(t, v, p, digit, before)
        else: insertNodeChecked(t, v, p, digit, before)
    proc insert*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; p: int; digit: int): int {.discardable.} =
        ## p に挿入し挿入前の rank(p) を返す。木内 O((B+W)(log_B(N/W)+1))、プール拡張は償却。
        ## 削除後もプールを再利用するため、メモリは過去最大長に比例する。
        assert 0 <= p and p <= t.len and t.len < int32.high.int and 0 <= digit and digit < 4
        let r = t.insertNode(t.root, p, digit, result)
        if r >= 0:
            let v = t.allocNode(false)
            t.nodes[v].used = 2
            t.nodes[v].child[0] = int32(t.root)
            t.nodes[v].child[1] = int32(r)
            t.rebuild(v)
            t.root = v
        t.uniform = if t.nodes[t.root].totals[digit] == t.nodes[t.root].size: digit else: -1

    proc underfull[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v: int): bool =
        ## 根以外の最小占有率を割ったか判定する。
        if t.nodes[v].leaf: t.nodes[v].bits.n < quadLeafMinimum(W, Flags) else: t.nodes[v].used < B div 2

    proc balancePair[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; parent, j: int) =
        ## 隣接する子を結合または均等再配分する。O(B+W)。
        let a = t.nodes[parent].child[j]
        let b = t.nodes[parent].child[j+1]
        var merged = false
        if t.nodes[a].leaf:
            let n = t.nodes[a].bits.n + t.nodes[b].bits.n
            if n <= W*32:
                t.nodes[a].bits = packedJoin(t.nodes[a].bits, t.nodes[b].bits, t.kernel)
                merged = true
            else:
                let target = n div 2
                if t.nodes[a].bits.n < target:
                    let take = target-t.nodes[a].bits.n
                    let prefix = t.nodes[b].bits.packedSlice(0, take, t.kernel)
                    t.nodes[a].bits = packedJoin(t.nodes[a].bits, prefix, t.kernel)
                    t.nodes[b].bits = t.nodes[b].bits.packedSlice(take, n-target, t.kernel)
                else:
                    let suffix = t.nodes[a].bits.packedSlice(target, t.nodes[a].bits.n-target, t.kernel)
                    t.nodes[b].bits = packedJoin(suffix, t.nodes[b].bits, t.kernel)
                    t.nodes[a].bits = t.nodes[a].bits.packedSlice(0, target, t.kernel)
        else:
            var children: array[B*2, int]
            let na = t.nodes[a].used
            let n = na+t.nodes[b].used
            for i in 0..<na: children[i] = t.nodes[a].child[i]
            for i in 0..<t.nodes[b].used: children[na+i] = t.nodes[b].child[i]
            let target = if n <= B: n else: n div 2
            t.nodes[a].used = target
            for i in 0..<target: t.nodes[a].child[i] = int32(children[i])
            t.nodes[b].used = n-target
            for i in 0..<n-target: t.nodes[b].child[i] = int32(children[target+i])
            merged = n <= B
        t.rebuild(a)
        if merged:
            t.free.add(b)
            for i in j+1..<t.nodes[parent].used-1: t.nodes[parent].child[i] = t.nodes[parent].child[i+1]
            dec t.nodes[parent].used
        else:
            t.rebuild(b)
        t.rebuild(parent)

    proc eraseNode[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p: int): tuple[rank, digit: int] {.inline.}
    template declareEraseNode(name: untyped) =
        proc name[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p: int): QuadRankDigit =
            ## 削除前の rank と桁を返し、帰りがけに占有率を回復する。
            when (Flags and quadPointersBit) != 0:
                var node = addr t.nodes[v]
            template currentNode(): untyped =
                when (Flags and quadPointersBit) != 0: node[]
                else: t.nodes[v]
            if currentNode().leaf:
                result.digit = currentNode().bits.packedAccess(p)
                result.rank = currentNode().bits.packedRank(p, result.digit, t.kernel)
                discard currentNode().bits.packedErase(p, t.kernel)
                when (Flags and quadLeafCountsBit) != 0:
                    dec currentNode().size
                    dec currentNode().totals[result.digit]
                else: t.rebuild(v)
                return
            let j = quadFind[B, Flags](addr currentNode().sizes[0], currentNode().used, p, t.kernel)
            let offset = if j == 0: 0 else: int(currentNode().sizes[j-1])
            let child = currentNode().child[j]
            result = t.eraseNode(child, p-offset)
            if j > 0: result.rank+=int(currentNode().counts[result.digit][j-1])
            if t.underfull(child) and currentNode().used > 1:
                t.balancePair(v, min(j, currentNode().used-2))
            else:
                t.addSizeCount(v, j, result.digit, -1)
                dec currentNode().size
                dec currentNode().totals[result.digit]
    declareEraseNode(eraseNodeChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declareEraseNode(eraseNodeTrusted)
    {.pop.}
    proc eraseNode[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, p: int): tuple[rank, digit: int] =
        ## 型のtrusted設定に従い私有処理だけの検査を選ぶ。
        when (Flags and quadTrustedBit) != 0: eraseNodeTrusted(t, v, p)
        else: eraseNodeChecked(t, v, p)
    proc erase*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; p: int): tuple[rank, digit: int] {.discardable.} =
        ## p を削除し、削除前の rank と桁を返す。木操作O((B+W)(log_B(N/W)+1))、プール管理は償却。
        assert 0 <= p and p < t.len
        result = t.eraseNode(t.root, p)
        if not t.nodes[t.root].leaf and t.nodes[t.root].used == 1:
            let old = t.root
            t.root = t.nodes[old].child[0]
            t.free.add(old)
        t.refreshUniform()

    proc addMoveRange[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; v, first, last, digit, delta: int) {.inline.} =
        ## 移動で長さと同じ桁の個数が変わる子区間だけをO(B)で更新する。
        if first == last: return
        when (Flags and quadUpdateBit) != 0:
            quadPrefixAddPairRaw(addr t.nodes[v].sizes[first], addr t.nodes[v].counts[digit][first],
                cint(last-first), cint(delta), cint(ord(t.kernel)+1))
        else:
            prefixAdd(addr t.nodes[v].sizes[first], last-first, delta, t.kernel)
            prefixAdd(addr t.nodes[v].counts[digit][first], last-first, delta, t.kernel)
    template declareMoveRank(name: untyped) =
        proc name[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; source, destination, digit: int): tuple[oldDigit, oldRank, newRank: int] =
            ## 共通祖先の増減を相殺し、旧rankは確定した桁だけ帰路で数える。再平衡時はerase/insert。
            # N<=int32.high、最小分岐数2なので経路は32枠で足りる。
            var leftPath {.noinit.}, rightPath {.noinit.}: array[32, int]
            var leftSlots {.noinit.}, rightSlots {.noinit.}: array[32, int]
            var leftDepth, rightDepth: int
            var a = t.root
            var b = t.root
            var p = source
            var q = destination+int(source < destination)
            while not t.nodes[a].leaf:
                let node = addr t.nodes[a]
                let j = quadFind[B, Flags](addr node.sizes[0], node.used, p, t.kernel)
                leftPath[leftDepth] = a
                leftSlots[leftDepth] = j
                inc leftDepth
                if j > 0:
                    p-=int(node.sizes[j-1])
                a = node.child[j]
            while not t.nodes[b].leaf:
                let node = addr t.nodes[b]
                let j = min(node.used-1, quadFind[B, Flags](addr node.sizes[0], node.used, q, t.kernel))
                rightPath[rightDepth] = b
                rightSlots[rightDepth] = j
                inc rightDepth
                if j > 0:
                    q-=int(node.sizes[j-1])
                    result.newRank+=int(node.counts[digit][j-1])
                b = node.child[j]
            if a != b and (t.nodes[a].bits.n <= quadLeafMinimum(W, Flags) or t.nodes[b].bits.n == W*32):
                let removed = t.erase(source)
                return (removed.digit, removed.rank, t.insert(destination, digit))
            let left = addr t.nodes[a]
            let right = addr t.nodes[b]
            result.oldDigit = left.bits.packedAccess(p)
            result.oldRank = left.bits.packedRank(p, result.oldDigit, t.kernel)
            result.newRank+=right.bits.packedRank(q, digit, t.kernel)-int(source < destination and result.oldDigit == digit)
            discard left.bits.packedErase(p, t.kernel)
            right.bits.packedInsert(q-int(a == b and source < destination), digit, t.kernel)
            dec left.size
            dec left.totals[result.oldDigit]
            inc right.size
            inc right.totals[digit]
            var common = 0
            while common < leftDepth and common < rightDepth and leftPath[common] == rightPath[common]:
                let v = leftPath[common]
                let node = addr t.nodes[v]
                let l = leftSlots[common]
                let r = rightSlots[common]
                if l > 0: result.oldRank+=int(node.counts[result.oldDigit][l-1])
                let delta = if l < r: -1 else: 1
                if result.oldDigit == digit:
                    t.addMoveRange(v, min(l, r), max(l, r), digit, delta)
                else:
                    if l != r: prefixAdd(addr node.sizes[min(l, r)], abs(l-r), delta, t.kernel)
                    prefixAdd(addr node.counts[result.oldDigit][l], node.used-l, -1, t.kernel)
                    prefixAdd(addr node.counts[digit][r], node.used-r, 1, t.kernel)
                    dec node.totals[result.oldDigit]
                    inc node.totals[digit]
                inc common
            for i in common..<leftDepth:
                let v = leftPath[i]
                let j = leftSlots[i]
                if j > 0: result.oldRank+=int(t.nodes[v].counts[result.oldDigit][j-1])
                t.addSizeCount(v, leftSlots[i], result.oldDigit, -1)
                dec t.nodes[v].size
                dec t.nodes[v].totals[result.oldDigit]
            for i in common..<rightDepth:
                let v = rightPath[i]
                t.addSizeCount(v, rightSlots[i], digit, 1)
                inc t.nodes[v].size
                inc t.nodes[v].totals[digit]
            t.uniform = if t.nodes[t.root].totals[digit] == t.nodes[t.root].size: digit else: -1
    declareMoveRank(moveRankChecked)
    {.push boundChecks: off, fieldChecks: off.}
    declareMoveRank(moveRankTrusted)
    {.pop.}
    proc moveRank*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; source, destination, digit: int): tuple[oldDigit, oldRank, newRank: int] {.discardable.} =
        ## sourceを削除し、削除後のdestinationへdigitを挿入する。旧rankと挿入前rankを返す。償却O((B+W)h)。
        assert 0 <= source and source < t.len and 0 <= destination and destination < t.len
        assert 0 <= digit and digit < 4
        if t.uniform == digit: return (digit, source, destination)
        if source == destination: return t.replaceRank(source, digit)
        when (Flags and quadTrustedBit) != 0: moveRankTrusted(t, source, destination, digit)
        else: moveRankChecked(t, source, destination, digit)

    proc select*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]; d, k: int): int =
        ## 桁dのk番目の位置。存在しなければ-1。O(B log_B(N/W)+W)。
        assert 0 <= d and d < 4
        if k < 0 or k >= t.total(d): return -1
        if t.uniform >= 0: return k
        var k = k
        var v = t.root
        when (Flags and quadPointersBit) != 0:
            var node = addr t.nodes[v]
        template currentNode(): untyped =
            when (Flags and quadPointersBit) != 0: node[]
            else: t.nodes[v]
        while not currentNode().leaf:
            let j = quadFind[B, Flags](addr currentNode().counts[d][0], currentNode().used, k, t.kernel)
            if j > 0:
                result+=int(currentNode().sizes[j-1])
                k-=int(currentNode().counts[d][j-1])
            v = currentNode().child[j]
            when (Flags and quadPointersBit) != 0: node = addr t.nodes[v]
        const stride = (when (Flags and quadPlaneBit) != 0: 64 else: 32)
        for j in 0..<(currentNode().bits.n+stride-1) div stride:
            when (Flags and quadPlaneBit) != 0:
                var low = currentNode().bits.low[j]
                var high = currentNode().bits.high[j]
                if (d and 1) == 0: low = not low
                if (d and 2) == 0: high = not high
                var word = low and high
            else:
                var word = matches(currentNode().bits.words[j], d)
            let remaining = currentNode().bits.n-j*stride
            if remaining < stride: word = word and quadMask(remaining*(64 div stride))
            let count = popcount(word)
            if k < count:
                while k > 0:
                    word = word and (word-1)
                    dec k
                return result+j*stride+countTrailingZeroBits(word) div (64 div stride)
            k-=count
    proc validate*[B, W, P, Flags](t: QuadVector[B, W, P, Flags]) =
        ## 占有率・累積数・高さ・未使用bit・poolを検査する。O(N)。
        var seen = newSeq[bool](t.nodes.len)
        proc visit(v: int; root: bool): int =
            assert not seen[v]
            seen[v] = true
            if t.nodes[v].leaf:
                let a = t.nodes[v].bits
                assert a.n <= W*32 and (root or a.n >= quadLeafMinimum(W, Flags))
                var actual: array[4, cint]
                when (Flags and quadPlaneBit) != 0:
                    for i in 0..<a.n:
                        if i mod (32*P) == 0:
                            for d in 0..3: assert int(a.prefixes[i div (32*P)][d]) == int(actual[d])
                        inc actual[a.packedAccess(i)]
                else:
                    quadRanksRaw(unsafeAddr a.words[0], cint(a.n), addr actual[0])
                for d in 0..3: assert a.counts[d] == int(actual[d])
                when (Flags and quadPlaneBit) != 0:
                    if P != 2 or a.n mod (32*P) == 0:
                        for d in 0..3: assert int(a.prefixes[(a.n+32*P-1) div (32*P)][d]) == int(actual[d])
                elif P > 0:
                    for blockIndex in 0..a.n div (32*P):
                        var expected: array[4, cint]
                        quadRanksRaw(unsafeAddr a.words[0], cint(blockIndex*32*P), addr expected[0])
                        for d in 0..3: assert int(a.prefixes[blockIndex][d]) == int(expected[d])
                assert t.nodes[v].size == int32(a.n)
                for d in 0..3: assert t.nodes[v].totals[d] == int32(a.counts[d])
                const capacity = (when (Flags and quadPlaneBit) != 0: (W div 2+1)*64 else: (W+1)*32)
                for i in a.n..<capacity: assert a.packedAccess(i) == 0
                return 0
            let n = t.nodes[v].used
            assert n <= B and n >= (if root: 2 else: B div 2)
            var size: int32
            var counts: array[4, int32]
            var height = -1
            for i in 0..<n:
                let child = t.nodes[v].child[i]
                let h = visit(child, false)
                if height < 0: height = h
                assert h == height
                size+=t.nodes[child].size
                assert t.nodes[v].sizes[i] == size
                for d in 0..3:
                    counts[d]+=t.nodes[child].totals[d]
                    assert t.nodes[v].counts[d][i] == counts[d]
            assert t.nodes[v].size == size and t.nodes[v].totals == counts
            return height+1
        discard visit(t.root, true)
        var uniform = -1
        if t.len > 0:
            for d in 0..3:
                if t.total(d) == t.len: uniform = d
        assert t.uniform == uniform
        for v in t.free:
            assert not seen[v]
            seen[v] = true
        for x in seen: assert x
