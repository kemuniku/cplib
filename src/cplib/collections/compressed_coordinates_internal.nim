when not declared CPLIB_COLLECTIONS_COMPRESSED_COORDINATES_INTERNAL:
    const CPLIB_COLLECTIONS_COMPRESSED_COORDINATES_INTERNAL = 1
    import algorithm

    proc compressedCoordinateKey[K: SomeInteger](x: K): uint64 {.inline.} =
        ## 整数の大小関係を保つ符号なしキーに変換します。
        when K is SomeSignedInt:
            cast[uint64](int64(x)) xor (1u64 shl 63)
        else:
            uint64(x)

    proc sortCompressedCoordinates[K](xs: var seq[K]) =
        ## 大きな整数配列は基数ソート、それ以外は比較ソートで整列します。
        when K is SomeInteger:
            if xs.len >= 2048:
                let first = compressedCoordinateKey(xs[0])
                var differing = 0u64
                var ordered = true
                for i in 1..<xs.len:
                    differing = differing or (first xor compressedCoordinateKey(xs[i]))
                    if xs[i] < xs[i - 1]: ordered = false
                if ordered: return
                var tmp = newSeq[K](xs.len)
                var counts: array[2048, int]
                for shift in countup(0, 55, 11):
                    if ((differing shr shift) and 2047u64) == 0: continue
                    counts.fill(0)
                    for x in xs:
                        inc counts[int((compressedCoordinateKey(x) shr shift) and 2047u64)]
                    var total = 0
                    for i in 0..<counts.len:
                        let size = counts[i]
                        counts[i] = total
                        total += size
                    for x in xs:
                        let bucket = int((compressedCoordinateKey(x) shr shift) and 2047u64)
                        tmp[counts[bucket]] = x
                        inc counts[bucket]
                    swap(xs, tmp)
                return
        xs.sort()

    proc compressedCoordinateHash[K: SomeInteger](x: K): int {.inline.} =
        ## 整数の各ビットを混ぜ、添字検索用のハッシュ値を返します。
        var h = compressedCoordinateKey(x)
        h = (h xor (h shr 30)) * 0xbf58476d1ce4e5b9u64
        h = (h xor (h shr 27)) * 0x94d049bb133111ebu64
        cast[int](h xor (h shr 31))

    proc initCompressedCoordinateIndex[K](coords: openArray[K]): seq[int] =
        ## 整数座標にO(N)空間の添字索引を構築します。衝突の探索は8回までです。
        when K is SomeInteger:
            if coords.len >= 64:
                var capacity = 1
                while capacity < coords.len * 2: capacity *= 2
                result = newSeq[int](capacity)
                for i, x in coords:
                    var slot = compressedCoordinateHash(x) and (capacity - 1)
                    for probe in 0..<8:
                        if result[slot] == 0:
                            result[slot] = i + 1
                            break
                        slot = (slot + 1) and (capacity - 1)

    proc findCompressedCoordinate[K](coords: openArray[K], slots: openArray[int], x: K): int =
        ## 登録済みの添字か-1を返します。衝突が多ければ二分探索し、最悪O(log N)です。
        when K is SomeInteger:
            if slots.len > 0:
                let mask = slots.len - 1
                var slot = compressedCoordinateHash(x) and mask
                for probe in 0..<8:
                    let entry = slots[slot]
                    if entry == 0: return -1
                    if coords[entry - 1] == x: return entry - 1
                    slot = (slot + 1) and mask
        let i = coords.lowerBound(x)
        if i < coords.len and coords[i] == x: i
        else: -1
