when not declared CPLIB_COLLECTIONS_OFFLINE_DYNAMIC_WAVELETMATRIX:
    const CPLIB_COLLECTIONS_OFFLINE_DYNAMIC_WAVELETMATRIX* = 1
    import algorithm, options, bitops
    ## 全パラメータが既知の操作列専用。位置・kは0始まり、位置/値区間は半開。
    ## M=初期長+insert/実際に値が変わるset数、S=異なる値数、L=ceil(log4(max(1,S)))。
    ## B=512、K=位置ブロック数、R=分割回数、I/D=insert/erase数。
    ## 前処理O(N+Q log(K+1)+(I+D)B+RK+M(8+L))。値圧縮は8bit radix。
    ## 挿入削除なしなら位置ブロック不要。値が一種類以下なら前処理O(N+Q)。
    ## 操作O((L+1)log(M/64+1))、sum問い合わせは各層で端の最大64値も走査。
    ## 記憶量はsumなしO(Q+M+ML/64)ワード、sumありはO(ML)ワードを追加。
    ## 削除された版も固定位置として保持する。1層2bit、活性状態は64位置/word。
    ## Fenwickはブロックの桁0..2だけ集計し、桁3は残りとして扱う。
    ## 静的rankは2本のbit列と64位置ごとの累積個数で求める。
    ## sum操作がある場合だけ128bit相当の和配列を確保。回答はint範囲内が必要。
    ## overflowChecks有効時は範囲外回答でOverflowDefect。無効時の範囲外結果は保証しない。
    ## 内部の大きい部分和は許容する。
    ## 例: let answers = runOfflineDynamicWaveletMatrix(@[5, 1, 5], @[
    ##   wmInsert(1, 7), wmSet(0, -3), wmKthSmallest(0, 4, 1), wmErase(2),
    ##   wmPrevValue(0, 3, 7), wmSumSmallestWithCount(0, 3, 2)])
    ## answers[0].value == 1, answers[1].value == 1,
    ## answers[2].optionalValue == some(5), answers[3].sumCount == (2, 2)。
    ## 回答に依存する後続操作は対象外。prepare/run分割時のrunは一度だけ。
    type
        OfflineWMKind* = enum
            owmInsert, owmErase, owmSet, owmAccess, owmLen, owmRank, owmCount, owmSelect, owmKthSmallest, owmKthLargest, owmRangeLowerbound, owmRangeUpperbound, owmRangeFreq, owmPrevValue, owmNextValue, owmSumLowerbound, owmSumUpperbound, owmRangeSum, owmSumSmallest, owmSumLowerboundWithCount,
                    owmSumUpperboundWithCount, owmRangeSumWithCount, owmSumSmallestWithCount
        OfflineWMOperation* = object
            kind*: OfflineWMKind
            l*, r*, k*, x*, y*: int
        OfflineWMAnswerKind* = enum
            owaInteger, owaOptional, owaSumCount
        OfflineWMAnswer* = object
            operationIndex*: int
            case kind*: OfflineWMAnswerKind
            of owaInteger: value*: int
            of owaOptional: optionalValue*: Option[int]
            of owaSumCount: sumCount*: tuple[sum, count: int]
        OWMWideSum = object
            low: uint64
            high: int64
        OWMFenwick = object
            active: seq[uint64]
            values: seq[int]
            counts: seq[int32]
            sums: seq[OWMWideSum]
        OWMQuadLevel = object
            lowBits, highBits, active: seq[uint64]
            values: seq[int]
            checkpoints: seq[array[3, int32]]
            offsets: array[4, int]
            counts: seq[array[3, int32]]
            sums: seq[array[3, OWMWideSum]]
        OWMPositions = object
            blocks: seq[seq[int]]
            order: seq[int]
            sizes: seq[int32]
            length: int
        OfflineDynamicWaveletMatrix* = ref object
            operations: seq[OfflineWMOperation]
            changes: seq[tuple[oldSlot, newSlot: int]]
            quads: seq[OWMQuadLevel]
            trees: seq[OWMFenwick]
            values, slotValues, bottomSlots: seq[int]
            n, height, answerCount: int
            withSum, consumed, constantMode: bool
    proc `==`*(a, b: OfflineWMAnswer): bool =
        ## 操作番号・結果種別・値を比較。O(1)。
        if a.operationIndex != b.operationIndex or a.kind != b.kind: return false
        case a.kind
        of owaInteger: a.value == b.value
        of owaOptional: a.optionalValue == b.optionalValue
        of owaSumCount: a.sumCount == b.sumCount
    proc wmInsert*(i, x: int): OfflineWMOperation =
        ## 現在位置iの直前へxを挿入。回答なし。操作の作成はO(1)。
        OfflineWMOperation(kind: owmInsert, l: i, x: x)
    proc wmErase*(i: int): OfflineWMOperation =
        ## 現在位置iを削除。削除値を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmErase, l: i)
    proc wmSet*(i, x: int): OfflineWMOperation =
        ## 現在位置iをxへ変更。回答なし。操作の作成はO(1)。
        OfflineWMOperation(kind: owmSet, l: i, x: x)
    proc wmAccess*(i: int): OfflineWMOperation =
        ## 現在位置iの値を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmAccess, l: i)
    proc wmLen*(): OfflineWMOperation =
        ## 現在の要素数を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmLen)
    proc wmRank*(r, x: int): OfflineWMOperation =
        ## [0,r)のxの個数を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmRank, r: r, x: x)
    proc wmCount*(l, r, x: int): OfflineWMOperation =
        ## [l,r)のxの個数を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmCount, l: l, r: r, x: x)
    proc wmSelect*(k, x: int): OfflineWMOperation =
        ## xのk番目の現在位置を回答。未存在は-1。操作の作成はO(1)。
        OfflineWMOperation(kind: owmSelect, k: k, x: x)
    proc wmKthSmallest*(l, r, k: int): OfflineWMOperation =
        ## [l,r)の小さい順k番目を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmKthSmallest, l: l, r: r, k: k)
    proc wmKthLargest*(l, r, k: int): OfflineWMOperation =
        ## [l,r)の大きい順k番目を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmKthLargest, l: l, r: r, k: k)
    proc wmRangeLowerbound*(l, r, x: int): OfflineWMOperation =
        ## [l,r)のx未満の個数を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmRangeLowerbound, l: l, r: r, x: x)
    proc wmRangeUpperbound*(l, r, x: int): OfflineWMOperation =
        ## [l,r)のx以下の個数を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmRangeUpperbound, l: l, r: r, x: x)
    proc wmRangeFreq*(l, r, low, high: int): OfflineWMOperation =
        ## [l,r)で値が[low,high)の個数を回答。low>=highなら0。操作の作成はO(1)。
        OfflineWMOperation(kind: owmRangeFreq, l: l, r: r, x: low, y: high)
    proc wmPrevValue*(l, r, x: int): OfflineWMOperation =
        ## [l,r)のx未満の最大値を回答。未存在はnone。操作の作成はO(1)。
        OfflineWMOperation(kind: owmPrevValue, l: l, r: r, x: x)
    proc wmNextValue*(l, r, x: int): OfflineWMOperation =
        ## [l,r)のx以上の最小値を回答。未存在はnone。操作の作成はO(1)。
        OfflineWMOperation(kind: owmNextValue, l: l, r: r, x: x)
    proc wmSumLowerbound*(l, r, x: int): OfflineWMOperation =
        ## [l,r)のx未満の和を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmSumLowerbound, l: l, r: r, x: x)
    proc wmSumUpperbound*(l, r, x: int): OfflineWMOperation =
        ## [l,r)のx以下の和を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmSumUpperbound, l: l, r: r, x: x)
    proc wmRangeSum*(l, r, low, high: int): OfflineWMOperation =
        ## [l,r)で値が[low,high)の和を回答。low>=highなら0。操作の作成はO(1)。
        OfflineWMOperation(kind: owmRangeSum, l: l, r: r, x: low, y: high)
    proc wmSumSmallest*(l, r, k: int): OfflineWMOperation =
        ## [l,r)の小さい方からk個の和を回答。0<=k<=r-l。操作の作成はO(1)。
        OfflineWMOperation(kind: owmSumSmallest, l: l, r: r, k: k)
    proc wmSumLowerboundWithCount*(l, r, x: int): OfflineWMOperation =
        ## x未満の和と個数を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmSumLowerboundWithCount, l: l, r: r, x: x)
    proc wmSumUpperboundWithCount*(l, r, x: int): OfflineWMOperation =
        ## x以下の和と個数を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmSumUpperboundWithCount, l: l, r: r, x: x)
    proc wmRangeSumWithCount*(l, r, low, high: int): OfflineWMOperation =
        ## 値が[low,high)の和と個数を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmRangeSumWithCount, l: l, r: r, x: low, y: high)
    proc wmSumSmallestWithCount*(l, r, k: int): OfflineWMOperation =
        ## 小さい方からk個の和と個数を回答。操作の作成はO(1)。
        OfflineWMOperation(kind: owmSumSmallestWithCount, l: l, r: r, k: k)
    proc wide(x: int): OWMWideSum {.inline.} =
        ## intを符号拡張。O(1)。
        OWMWideSum(low: cast[uint64](x), high: (if x < 0: -1'i64 else: 0'i64))
    proc `+`(a, b: OWMWideSum): OWMWideSum {.inline.} =
        ## 下位桁の桁上がりを含む正確な和。要素数上限より128bit内。O(1)。
        result.low = a.low+b.low
        result.high = a.high+b.high+int64(result.low < a.low)
    proc `-`(a, b: OWMWideSum): OWMWideSum {.inline.} =
        ## 下位桁の借りを含む正確な差。O(1)。
        result.low = a.low-b.low
        result.high = a.high-b.high-int64(a.low < b.low)
    proc repeated(x, count: int): OWMWideSum {.inline.} =
        ## intと0..int32.highの積を正確に計算。O(1)。
        let bits = cast[uint64](x)
        let lo = (bits and 0xffffffff'u64)*uint64(count)
        let hi = (bits shr 32)*uint64(count)
        result.low = lo+(hi shl 32)
        result.high = int64(hi shr 32)+int64(result.low < lo)
        if x < 0: result.high -= int64(count)
    proc checkedInt(x: OWMWideSum): int {.inline.} =
        ## 公開する和をintへ戻し、標準のoverflowChecksに従う。O(1)。
        result = cast[int](x.low)
        when compileOption("overflowChecks"):
            let sign = if result < 0: -1'i64 else: 0'i64
            if x.high != sign:
                raise newException(OverflowDefect, "offline wavelet matrix sum exceeds int range")
    proc prefix(t: OWMFenwick, r: int): int {.inline.} =
        ## 64位置ブロックの個数と端のpopcount。O(log(M/64+1))。
        var i = r shr 6
        while i > 0:
            result += int(t.counts[i])
            i -= i and -i
        let rem = r and 63
        if rem > 0: result += countSetBits(t.active[r shr 6] and ((1'u64 shl rem)-1))
    proc prefixSum(t: OWMFenwick, r: int): OWMWideSum {.inline.} =
        ## ブロック和と端の有効要素を集計。O(log(M/64+1)+64)。
        var i = r shr 6
        while i > 0:
            result = result+t.sums[i]
            i -= i and -i
        let rem = r and 63
        if rem > 0:
            let base = (r shr 6)*64
            var bits = t.active[r shr 6] and ((1'u64 shl rem)-1)
            while bits != 0:
                let bit = countTrailingZeroBits(bits)
                result = result+wide(t.values[base+bit])
                bits = bits and (bits-1)
    proc amount(t: OWMFenwick, l, r: int): int {.inline.} =
        ## 半開区間の有効個数。O(log(M/64+1))。
        t.prefix(r)-t.prefix(l)
    proc weight(t: OWMFenwick, l, r: int): OWMWideSum {.inline.} =
        ## 半開区間の正確な和。O(log(M/64+1)+64)。
        t.prefixSum(r)-t.prefixSum(l)
    proc locate(t: OWMFenwick, k: int): int =
        ## ブロックを選び、64bit内でk番目を選択。O(log(M/64+1)+64)。
        var step = 1
        while step < t.counts.len: step = step shl 1
        var rest = k
        while step > 0:
            let next = result+step
            if next < t.counts.len and int(t.counts[next]) <= rest:
                rest -= int(t.counts[next])
                result = next
            step = step shr 1
        var bits = t.active[result]
        while rest > 0:
            bits = bits and (bits-1)
            dec rest
        result = result*64+countTrailingZeroBits(bits)
    proc change(t: var OWMFenwick, slot, value: int, add: bool) =
        ## 活性bitとブロック集計を変更。O(log(M/64+1))。
        let blockIndex = slot shr 6
        let mask = 1'u64 shl (slot and 63)
        if add: t.active[blockIndex] = t.active[blockIndex] or mask
        else: t.active[blockIndex] = t.active[blockIndex] and not mask
        var i = blockIndex+1
        while i < t.counts.len:
            if add:
                inc t.counts[i]
                if t.sums.len > 0: t.sums[i] = t.sums[i]+wide(value)
            else:
                dec t.counts[i]
                if t.sums.len > 0: t.sums[i] = t.sums[i]-wide(value)
            i += i and -i
    proc replace(t: var OWMFenwick, oldPos, newPos, oldValue, newValue: int) =
        ## 同じブロックなら活性bitを交換し、個数の更新を省略する。
        if (oldPos shr 6) != (newPos shr 6):
            t.change(oldPos, oldValue, false)
            t.change(newPos, newValue, true)
            return
        let b = oldPos shr 6
        t.active[b] = (t.active[b] and not (1'u64 shl (oldPos and 63))) or (1'u64 shl (newPos and 63))
        if t.sums.len > 0:
            let delta = wide(newValue)-wide(oldValue)
            var i = b+1
            while i < t.sums.len:
                t.sums[i] = t.sums[i]+delta
                i += i and -i
    proc digit(q: OWMQuadLevel, pos: int): int {.inline.} =
        ## 固定位置の2bit桁を読む。O(1)。
        int((q.lowBits[pos shr 6] shr (pos and 63)) and 1) or
            (int((q.highBits[pos shr 6] shr (pos and 63)) and 1) shl 1)
    proc rank(q: OWMQuadLevel, pos, d: int): int {.inline.} =
        ## 64位置ごとの累積個数とpopcountで静的rankを計算。O(1)。
        let blockIndex = pos shr 6
        let checkpoint = q.checkpoints[blockIndex]
        if d < 3: result = int(checkpoint[d])
        else: result = blockIndex*64-int(checkpoint[0])-int(checkpoint[1])-int(checkpoint[2])
        let rem = pos and 63
        if rem != 0:
            let lo = q.lowBits[blockIndex]
            let hi = q.highBits[blockIndex]
            let matches = (if (d and 1) == 0: not lo else: lo) and
                (if (d and 2) == 0: not hi else: hi)
            result += countSetBits(matches and ((1'u64 shl rem)-1))
    proc change(q: var OWMQuadLevel, pos, d, value: int, add: bool) =
        ## 活性bitと該当桁のブロック集計を更新。O(log(M/64+1))。
        let blockIndex = pos shr 6
        let mask = 1'u64 shl (pos and 63)
        if add: q.active[blockIndex] = q.active[blockIndex] or mask
        else: q.active[blockIndex] = q.active[blockIndex] and not mask
        if d == 3: return
        var i = blockIndex+1
        let weight = wide(value)
        while i < q.counts.len:
            if add:
                inc q.counts[i][d]
                if q.sums.len > 0: q.sums[i][d] = q.sums[i][d]+weight
            else:
                dec q.counts[i][d]
                if q.sums.len > 0: q.sums[i][d] = q.sums[i][d]-weight
            i += i and -i
    proc replace(q: var OWMQuadLevel, oldPos, newPos, oldDigit, newDigit, oldValue, newValue: int) =
        ## ブロックと桁が共通なら個数更新を省略し、必要な和の差だけ反映。
        if (oldPos shr 6) != (newPos shr 6) or oldDigit != newDigit:
            q.change(oldPos, oldDigit, oldValue, false)
            q.change(newPos, newDigit, newValue, true)
            return
        let b = oldPos shr 6
        q.active[b] = (q.active[b] and not (1'u64 shl (oldPos and 63))) or (1'u64 shl (newPos and 63))
        if oldDigit < 3 and q.sums.len > 0:
            let delta = wide(newValue)-wide(oldValue)
            var i = b+1
            while i < q.sums.len:
                q.sums[i][oldDigit] = q.sums[i][oldDigit]+delta
                i += i and -i
    proc prefixAmounts(q: OWMQuadLevel, pos: int): array[3, int] {.inline.} =
        ## ブロック個数と端の3桁のpopcount。O(log(M/64+1))。
        var i = pos shr 6
        while i > 0:
            for d in 0..2: result[d] += int(q.counts[i][d])
            i -= i and -i
        let rem = pos and 63
        if rem > 0:
            let b = pos shr 6
            let bits = q.active[b] and ((1'u64 shl rem)-1)
            let lo = q.lowBits[b]
            let hi = q.highBits[b]
            result[0] += countSetBits(bits and not (lo or hi))
            result[1] += countSetBits(bits and lo and not hi)
            result[2] += countSetBits(bits and not lo and hi)
    proc amounts(q: OWMQuadLevel, l, r: int): array[3, int] {.inline.} =
        ## 3桁の区間個数を同時に取得。O(log(M/64+1))。
        let left = q.prefixAmounts(l)
        result = q.prefixAmounts(r)
        for d in 0..2: result[d] -= left[d]
    proc prefixBelow(q: OWMQuadLevel, pos, digitLimit: int, withSum: bool): tuple[sum: OWMWideSum, count: int] {.inline.} =
        ## 閾値桁未満をブロックと端で集計。O(log(M/64+1)+64)。
        var i = pos shr 6
        while i > 0:
            for d in 0..<digitLimit:
                result.count += int(q.counts[i][d])
                if withSum: result.sum = result.sum+q.sums[i][d]
            i -= i and -i
        let rem = pos and 63
        if rem > 0:
            let b = pos shr 6
            let digitMask = if digitLimit == 1: not (q.lowBits[b] or q.highBits[b])
                elif digitLimit == 2: not q.highBits[b]
                else: not (q.lowBits[b] and q.highBits[b])
            var bits = q.active[b] and digitMask and ((1'u64 shl rem)-1)
            result.count += countSetBits(bits)
            if withSum:
                while bits != 0:
                    let bit = countTrailingZeroBits(bits)
                    result.sum = result.sum+wide(q.values[b*64+bit])
                    bits = bits and (bits-1)
    proc below(q: OWMQuadLevel, l, r, digitLimit: int, withSum: bool): tuple[sum: OWMWideSum, count: int] =
        ## 閾値桁未満の区間個数・和。O(log(M/64+1)+64)。
        if digitLimit == 0: return
        let left = q.prefixBelow(l, digitLimit, withSum)
        result = q.prefixBelow(r, digitLimit, withSum)
        result.count -= left.count
        result.sum = result.sum-left.sum
    proc rebuild(t: var OWMPositions) =
        ## 位置ブロックのサイズ集計を再構築。O(K)。
        t.sizes = newSeq[int32](t.order.len+1)
        for i, id in t.order: t.sizes[i+1] = int32(t.blocks[id].len)
        for i in 1..t.order.len:
            let parent = i+(i and -i)
            if parent <= t.order.len: t.sizes[parent] += t.sizes[i]
    proc initPositions(n: int): OWMPositions =
        ## 512要素ずつ位置IDを並べる。O(N)。
        result.length = n
        var start = 0
        while start < n:
            let size = min(512, n-start)
            var blockData = newSeq[int](size)
            for i in 0..<size: blockData[i] = start+i+1
            result.order.add result.blocks.len
            result.blocks.add move(blockData)
            start += size
        result.rebuild()
    proc find(t: OWMPositions, k: int): tuple[index, offset: int] =
        ## 現在のk番目の位置ブロックを選ぶ。O(log K)。
        if k == t.length: return (t.order.high, t.blocks[t.order[^1]].len)
        var rest = k
        var step = 1
        while step < t.sizes.len: step = step shl 1
        while step > 0:
            let next = result.index+step
            if next < t.sizes.len and int(t.sizes[next]) <= rest:
                rest -= int(t.sizes[next])
                result.index = next
            step = step shr 1
        result.offset = rest
    proc at(t: OWMPositions, k: int): int =
        ## k番目の位置ID。末尾境界は0。O(log K)。
        if k == t.length: return 0
        let p = t.find(k)
        t.blocks[t.order[p.index]][p.offset]
    proc adjust(t: var OWMPositions, blockIndex, delta: int) =
        ## 一つの位置ブロックの長さを変更。O(log K)。
        var i = blockIndex+1
        while i < t.sizes.len:
            t.sizes[i] += int32(delta)
            i += i and -i
    proc insert(t: var OWMPositions, k, id: int): int =
        ## 位置IDを挿入し、直後の既存IDを返す。通常O(512+log K)、分割時O(K)。
        if t.order.len == 0:
            t.order.add 0
            t.blocks.add newSeq[int]()
            t.rebuild()
        let p = t.find(k)
        let blockId = t.order[p.index]
        if k < t.length: result = t.blocks[blockId][p.offset]
        t.blocks[blockId].insert(id, p.offset)
        inc t.length
        t.adjust(p.index, 1)
        if t.blocks[blockId].len > 1024:
            let half = t.blocks[blockId].len div 2
            var right = t.blocks[blockId][half..^1]
            t.blocks[blockId].setLen(half)
            t.order.insert(t.blocks.len, p.index+1)
            t.blocks.add move(right)
            t.rebuild()
    proc erase(t: var OWMPositions, k: int): int =
        ## 位置IDを削除。空ブロックは残して再構築を避ける。O(512+log K)。
        let p = t.find(k)
        let blockId = t.order[p.index]
        result = t.blocks[blockId][p.offset]
        t.blocks[blockId].delete(p.offset)
        dec t.length
        t.adjust(p.index, -1)
    proc validateOperations(n: int, operations: openArray[OfflineWMOperation]) =
        ## 値が一種類以下でも現在位置と範囲の契約を検査する。O(Q)。
        var length = n
        for op in operations:
            case op.kind
            of owmInsert:
                assert 0 <= op.l and op.l <= length
                inc length
            of owmErase:
                assert 0 <= op.l and op.l < length
                dec length
            of owmSet, owmAccess:
                assert 0 <= op.l and op.l < length
            of owmSelect, owmLen: discard
            else:
                assert 0 <= op.l and op.l <= op.r and op.r <= length
                if op.kind == owmRank: assert op.l == 0
                if op.kind in {owmKthSmallest, owmKthLargest}: assert 0 <= op.k and op.k < op.r-op.l
                if op.kind in {owmSumSmallest, owmSumSmallestWithCount}: assert 0 <= op.k and op.k <= op.r-op.l
    proc prepareOfflineDynamicWaveletMatrix*(initial: openArray[int], operations: openArray[OfflineWMOperation]): OfflineDynamicWaveletMatrix =
        ## 全操作を前処理。runは一度だけ呼べる。初期列と操作は変更しない。
        ## 位置はinsertでのみ追加し、setの値の版は同じ位置へまとめる。
        assert sizeof(int) == 8
        var total = initial.len
        var withSum = false
        var fixedPositions = true
        var constantMode = true
        var hasValue = false
        var constantValue, answerCount: int
        template observe(x: int) =
            if not hasValue:
                constantValue = x
                hasValue = true
            elif constantValue != x: constantMode = false
        for x in initial: observe(x)
        for op in operations:
            if op.kind in {owmInsert, owmSet}: observe(op.x)
            else: inc answerCount
            if op.kind in {owmInsert, owmSet}: inc total
            if op.kind >= owmSumLowerbound: withSum = true
            if op.kind in {owmInsert, owmErase}: fixedPositions = false
        assert total <= int32.high.int
        result = OfflineDynamicWaveletMatrix(operations: @operations, n: initial.len, withSum: withSum, answerCount: answerCount)
        if constantMode:
            validateOperations(initial.len, operations)
            result.constantMode = true
            if hasValue: result.values = @[constantValue]
            return
        result.changes = newSeq[tuple[oldSlot, newSlot: int]](operations.len)
        var positions: OWMPositions
        var before, after = newSeq[int](1)
        var first, last: int
        var versionValues, versionPosition, currentVersion = newSeq[int](1)
        template newVersion(pos, value: int): int =
            block:
                versionValues.add value
                versionPosition.add pos
                currentVersion[pos] = versionValues.high
                versionValues.high
        template newPosition(value: int): int =
            block:
                let id = currentVersion.len
                currentVersion.add 0
                if not fixedPositions:
                    before.add 0
                    after.add 0
                discard newVersion(id, value)
                id
        template linkBefore(id, successor: int) =
            if successor == 0:
                before[id] = last
                if last == 0: first = id
                else: after[last] = id
                last = id
            else:
                before[id] = before[successor]
                after[id] = successor
                if before[successor] == 0: first = id
                else: after[before[successor]] = id
                before[successor] = id
        for x in initial:
            let id = newPosition(x)
            if not fixedPositions: linkBefore(id, 0)
        if not fixedPositions: positions = initPositions(initial.len)
        var length = initial.len
        template position(k: int): int =
            (if fixedPositions: (if k == length: 0 else: k+1) else: positions.at(k))
        for j, op in operations:
            var oldId, newId: int
            case op.kind
            of owmInsert:
                assert 0 <= op.l and op.l <= length
                let id = newPosition(op.x)
                newId = currentVersion[id]
                let successor = positions.insert(op.l, id)
                linkBefore(id, successor)
                inc length
            of owmErase:
                assert 0 <= op.l and op.l < length
                oldId = currentVersion[positions.erase(op.l)]
                dec length
            of owmSet:
                assert 0 <= op.l and op.l < length
                let pos = position(op.l)
                if versionValues[currentVersion[pos]] != op.x:
                    oldId = currentVersion[pos]
                    newId = newVersion(pos, op.x)
            of owmAccess:
                assert 0 <= op.l and op.l < length
                oldId = currentVersion[position(op.l)]
            of owmSelect, owmLen: discard
            else:
                assert 0 <= op.l and op.l <= op.r and op.r <= length
                if op.kind in {owmKthSmallest, owmKthLargest}:
                    assert 0 <= op.k and op.k < op.r-op.l
                if op.kind in {owmSumSmallest, owmSumSmallestWithCount}:
                    assert 0 <= op.k and op.k <= op.r-op.l
                if op.kind == owmRank: assert op.l == 0
                oldId = position(op.l)
                newId = position(op.r)
            result.changes[j] = (oldId, newId)
        total = versionValues.len-1
        var order: seq[int]
        if fixedPositions:
            for id in 1..<currentVersion.len: order.add id
        else:
            var pos = first
            while pos != 0:
                order.add pos
                pos = after[pos]
        var positionSizes = newSeq[int](currentVersion.len)
        for id in 1..total: inc positionSizes[versionPosition[id]]
        var bases = newSeq[int](currentVersion.len)
        var offset = 0
        for pos in order:
            bases[pos] = offset
            offset += positionSizes[pos]
        var cursor = bases
        var slots = newSeq[int](total+1)
        result.slotValues = newSeq[int](total)
        var active = newSeq[bool](total)
        for id in 1..total:
            let pos = versionPosition[id]
            let slot = cursor[pos]
            inc cursor[pos]
            slots[id] = slot
            result.slotValues[slot] = versionValues[id]
            active[slot] = id <= initial.len
        for j, change in result.changes.mpairs:
            if operations[j].kind in {owmInsert, owmErase, owmSet, owmAccess}:
                change.oldSlot = if change.oldSlot == 0: -1 else: slots[change.oldSlot]
                change.newSlot = if change.newSlot == 0: -1 else: slots[change.newSlot]
            else:
                change.oldSlot = if change.oldSlot == 0: total else: bases[change.oldSlot]
                change.newSlot = if change.newSlot == 0: total else: bases[change.newSlot]
        reset(positions)
        reset(before)
        reset(after)
        reset(versionValues)
        reset(versionPosition)
        reset(currentVersion)
        reset(positionSizes)
        reset(bases)
        reset(cursor)
        reset(slots)
        reset(order)
        # 符号を反転して昇順keyにし、実際の値幅だけradix sortする。
        var keys = newSeq[int](total)
        var perm = newSeq[int](total)
        var sorted = newSeq[tuple[key: uint64, slot: int]](total)
        var scratch = newSeq[tuple[key: uint64, slot: int]](total)
        var minimum = uint64.high
        var maximum = 0'u64
        for x in result.slotValues:
            let key = cast[uint64](x) xor (1'u64 shl 63)
            minimum = min(minimum, key)
            maximum = max(maximum, key)
        for i, x in result.slotValues:
            sorted[i] = ((cast[uint64](x) xor (1'u64 shl 63))-minimum, i)
            perm[i] = i
        if total > 0:
            let span = maximum-minimum
            var shift = 0
            while shift < 64 and (span shr shift) != 0:
                var counts: array[256, int]
                for entry in sorted: inc counts[int((entry.key shr shift) and 255)]
                var offset = 0
                for d in 0..255:
                    let count = counts[d]
                    counts[d] = offset
                    offset += count
                for entry in sorted:
                    let d = int((entry.key shr shift) and 255)
                    scratch[counts[d]] = entry
                    inc counts[d]
                swap(sorted, scratch)
                shift += 8
        var previous = 0'u64
        for i, entry in sorted:
            if i == 0 or entry.key != previous:
                result.values.add result.slotValues[entry.slot]
                previous = entry.key
            keys[entry.slot] = result.values.len-1
        reset(sorted)
        reset(scratch)
        var capacity = 1
        while capacity < result.values.len:
            inc result.height
            capacity = capacity shl 1
        let levels = (result.height+1) div 2
        result.quads = newSeq[OWMQuadLevel](levels)
        result.trees = newSeq[OWMFenwick](if levels == 0: 1 else: 2)
        let blocks = (total+63) div 64
        for level in 0..levels:
            # 最上位は現在位置復元と全体和、最下位はselectに使用する。
            if level == 0 or level == levels:
                var tree = OWMFenwick(counts: newSeq[int32](blocks+1), active: newSeq[uint64](blocks))
                if level == 0 and withSum:
                    tree.sums = newSeq[OWMWideSum](blocks+1)
                    tree.values = newSeq[int](total)
                for i in 0..<total:
                    if tree.values.len > 0: tree.values[i] = result.slotValues[perm[i]]
                    if active[perm[i]]:
                        tree.active[i shr 6] = tree.active[i shr 6] or (1'u64 shl (i and 63))
                        inc tree.counts[(i shr 6)+1]
                        if tree.sums.len > 0: tree.sums[(i shr 6)+1] = tree.sums[(i shr 6)+1]+wide(result.slotValues[perm[i]])
                for i in 1..blocks:
                    let parent = i+(i and -i)
                    if parent <= blocks:
                        tree.counts[parent] += tree.counts[i]
                        if tree.sums.len > 0: tree.sums[parent] = tree.sums[parent]+tree.sums[i]
                result.trees[if level == 0: 0 else: 1] = move(tree)
            if level == levels: break
            let shift = 2*(levels-1-level)
            var q = OWMQuadLevel(lowBits: newSeq[uint64]((total+63) div 64),
                highBits: newSeq[uint64]((total+63) div 64),
                checkpoints: newSeq[array[3, int32]](total div 64+1),
                counts: newSeq[array[3, int32]](blocks+1), active: newSeq[uint64](blocks))
            if withSum:
                q.sums = newSeq[array[3, OWMWideSum]](blocks+1)
                q.values = newSeq[int](total)
            var counts: array[4, int]
            for i in 0..total:
                if (i and 63) == 0:
                    for d in 0..2: q.checkpoints[i shr 6][d] = int32(counts[d])
                if i == total: break
                let d = (keys[i] shr shift) and 3
                let mask = 1'u64 shl (i and 63)
                if (d and 1) != 0: q.lowBits[i shr 6] = q.lowBits[i shr 6] or mask
                if (d and 2) != 0: q.highBits[i shr 6] = q.highBits[i shr 6] or mask
                inc counts[d]
                if withSum: q.values[i] = result.slotValues[perm[i]]
                if active[perm[i]]:
                    q.active[i shr 6] = q.active[i shr 6] or mask
                    if d < 3:
                        inc q.counts[(i shr 6)+1][d]
                        if withSum: q.sums[(i shr 6)+1][d] = q.sums[(i shr 6)+1][d]+wide(result.slotValues[perm[i]])
            for d in 1..3: q.offsets[d] = q.offsets[d-1]+counts[d-1]
            for i in 1..blocks:
                let parent = i+(i and -i)
                if parent <= blocks:
                    for d in 0..2:
                        q.counts[parent][d] += q.counts[i][d]
                        if withSum: q.sums[parent][d] = q.sums[parent][d]+q.sums[i][d]
            var nextKeys, nextPerm = newSeq[int](total)
            var cursor = q.offsets
            for i in 0..<total:
                let d = (keys[i] shr shift) and 3
                let dest = cursor[d]
                inc cursor[d]
                nextKeys[dest] = keys[i]
                nextPerm[dest] = perm[i]
            result.quads[level] = move(q)
            keys = move(nextKeys)
            perm = move(nextPerm)
        result.bottomSlots = move(perm)
    proc storageBytes*(t: OfflineDynamicWaveletMatrix): int =
        ## 保持する配列の要素バイト数。seqヘッダ・容量余剰・前処理一時領域は除く。O(L)。
        result = t.operations.len*sizeof(OfflineWMOperation)+t.changes.len*sizeof(tuple[oldSlot, newSlot: int])
        result += (t.values.len+t.slotValues.len+t.bottomSlots.len)*sizeof(int)
        for q in t.quads:
            result += (q.lowBits.len+q.highBits.len+q.active.len)*sizeof(uint64)+q.values.len*sizeof(int)+sizeof(q.offsets)
            result += q.checkpoints.len*sizeof(array[3, int32])+q.counts.len*sizeof(array[3, int32])
            result += q.sums.len*sizeof(array[3, OWMWideSum])
        for tree in t.trees: result += tree.counts.len*sizeof(int32)+tree.sums.len*sizeof(OWMWideSum)+tree.active.len*sizeof(uint64)+tree.values.len*sizeof(int)
    proc bitWidth*(t: OfflineDynamicWaveletMatrix): int =
        ## 圧縮後の値のビット幅。O(1)。
        t.height
    proc toggle(t: OfflineDynamicWaveletMatrix, slot: int, add: bool) =
        ## 固定位置から静的rankで全層の有効状態を更新。O((L+1)log(M/64+1))。
        let value = t.slotValues[slot]
        var pos = slot
        t.trees[0].change(pos, value, add)
        for q in t.quads.mitems:
            let d = q.digit(pos)
            q.change(pos, d, value, add)
            pos = q.offsets[d]+q.rank(pos, d)
        if t.quads.len > 0: t.trees[^1].change(pos, value, add)
    proc replace(t: OfflineDynamicWaveletMatrix, oldSlot, newSlot: int) =
        ## setの旧新経路を同時に進め、共通ブロックの更新をまとめる。
        let oldValue = t.slotValues[oldSlot]
        let newValue = t.slotValues[newSlot]
        var oldPos = oldSlot
        var newPos = newSlot
        t.trees[0].replace(oldPos, newPos, oldValue, newValue)
        for q in t.quads.mitems:
            let oldDigit = q.digit(oldPos)
            let newDigit = q.digit(newPos)
            q.replace(oldPos, newPos, oldDigit, newDigit, oldValue, newValue)
            oldPos = q.offsets[oldDigit]+q.rank(oldPos, oldDigit)
            newPos = q.offsets[newDigit]+q.rank(newPos, newDigit)
        if t.quads.len > 0: t.trees[^1].replace(oldPos, newPos, oldValue, newValue)
    proc less(t: OfflineDynamicWaveletMatrix, left, right, limit: int): tuple[sum: OWMWideSum, count: int] =
        ## 圧縮値limit未満の個数と和。O((L+1)(log(M/64+1)+64))。
        if t.constantMode:
            if limit > 0 and t.values.len > 0:
                result.count = right-left
                if t.withSum: result.sum = repeated(t.values[0], result.count)
            return
        if limit <= 0: return
        if limit >= t.values.len:
            result.count = t.trees[0].amount(left, right)
            if t.withSum: result.sum = t.trees[0].weight(left, right)
            return
        var l = left
        var r = right
        for level in 0..<t.quads.len:
            let d = (limit shr (2*(t.quads.len-1-level))) and 3
            let contribution = t.quads[level].below(l, r, d, t.withSum)
            result.count += contribution.count
            result.sum = result.sum+contribution.sum
            l = t.quads[level].offsets[d]+t.quads[level].rank(l, d)
            r = t.quads[level].offsets[d]+t.quads[level].rank(r, d)
    proc kth(t: OfflineDynamicWaveletMatrix, left, right, index: int): int =
        ## 有効要素の小さい順index番目。O((L+1)log(M/64+1))。
        var l = left
        var r = right
        var k = index
        var key = 0
        for q in t.quads:
            let counts = q.amounts(l, r)
            var d = 0
            while d < 3 and k >= counts[d]:
                k -= counts[d]
                inc d
            key = (key shl 2) or d
            l = q.offsets[d]+q.rank(l, d)
            r = q.offsets[d]+q.rank(r, d)
        t.values[key]
    proc exactCount(t: OfflineDynamicWaveletMatrix, left, right, key: int): int =
        ## 静的rankで葉区間へ写し、活性個数を一度だけ読む。O(L+log(M/64+1))。
        if t.constantMode: return right-left
        var l = left
        var r = right
        for level in 0..<t.quads.len:
            let d = (key shr (2*(t.quads.len-1-level))) and 3
            l = t.quads[level].offsets[d]+t.quads[level].rank(l, d)
            r = t.quads[level].offsets[d]+t.quads[level].rank(r, d)
        t.trees[^1].amount(l, r)
    proc occurrence(t: OfflineDynamicWaveletMatrix, k, x: int): int =
        ## 値xのk番目の現在位置。未存在は-1。O(L+log M)。
        let key = t.values.lowerBound(x)
        if k < 0 or key == t.values.len or t.values[key] != x: return -1
        if t.constantMode: return (if k < t.n: k else: -1)
        var l = 0
        var r = t.slotValues.len
        for level in 0..<t.quads.len:
            let d = (key shr (2*(t.quads.len-1-level))) and 3
            l = t.quads[level].offsets[d]+t.quads[level].rank(l, d)
            r = t.quads[level].offsets[d]+t.quads[level].rank(r, d)
        let start = t.trees[^1].prefix(l)
        if k >= t.trees[^1].prefix(r)-start: return -1
        let pos = t.trees[^1].locate(start+k)
        t.trees[0].prefix(t.bottomSlots[pos])
    proc run*(t: OfflineDynamicWaveletMatrix): seq[OfflineWMAnswer] =
        ## 前処理済み操作を一度だけ実行。insert/set以外の回答を操作順で返す。
        ## 各回答は元の操作番号と結果種別を持つ。計算量は冒頭参照。
        assert not t.consumed
        t.consumed = true
        result = newSeqOfCap[OfflineWMAnswer](t.answerCount)
        for j, op in t.operations:
            var answer = OfflineWMAnswer(operationIndex: j, kind: owaInteger)
            case op.kind
            of owmInsert, owmErase, owmSet:
                if t.constantMode:
                    if op.kind == owmInsert: inc t.n
                    elif op.kind == owmErase:
                        answer.value = t.values[0]
                        dec t.n
                    if op.kind != owmErase: continue
                else:
                    let change = t.changes[j]
                    if change.oldSlot >= 0 and change.newSlot >= 0:
                        t.replace(change.oldSlot, change.newSlot)
                    else:
                        if change.oldSlot >= 0:
                            answer.value = t.slotValues[change.oldSlot]
                            t.toggle(change.oldSlot, false)
                            dec t.n
                        if change.newSlot >= 0:
                            t.toggle(change.newSlot, true)
                            inc t.n
                    if op.kind != owmErase: continue
            of owmLen: answer.value = t.n
            of owmAccess: answer.value = (if t.constantMode: t.values[0] else: t.slotValues[t.changes[j].oldSlot])
            of owmSelect: answer.value = t.occurrence(op.k, op.x)
            else:
                let l = if t.constantMode: op.l else: t.changes[j].oldSlot
                let r = if t.constantMode: op.r else: t.changes[j].newSlot
                case op.kind
                of owmKthSmallest: answer.value = t.kth(l, r, op.k)
                of owmKthLargest: answer.value = t.kth(l, r, op.r-op.l-1-op.k)
                of owmPrevValue, owmNextValue:
                    let count = t.less(l, r, t.values.lowerBound(op.x)).count
                    var value = none(int)
                    if op.kind == owmPrevValue and count > 0: value = some(t.kth(l, r, count-1))
                    if op.kind == owmNextValue and count < op.r-op.l: value = some(t.kth(l, r, count))
                    answer = OfflineWMAnswer(operationIndex: j, kind: owaOptional, optionalValue: value)
                else:
                    var pair: tuple[sum: OWMWideSum, count: int]
                    case op.kind
                    of owmRank, owmCount:
                        let key = t.values.lowerBound(op.x)
                        if key < t.values.len and t.values[key] == op.x:
                            pair.count = t.exactCount(l, r, key)
                    of owmRangeLowerbound, owmSumLowerbound, owmSumLowerboundWithCount:
                        pair = t.less(l, r, t.values.lowerBound(op.x))
                    of owmRangeUpperbound, owmSumUpperbound, owmSumUpperboundWithCount:
                        pair = t.less(l, r, t.values.upperBound(op.x))
                    of owmRangeFreq, owmRangeSum, owmRangeSumWithCount:
                        if op.x < op.y:
                            let lo = t.less(l, r, t.values.lowerBound(op.x))
                            let hi = t.less(l, r, t.values.lowerBound(op.y))
                            pair = (hi.sum-lo.sum, hi.count-lo.count)
                    of owmSumSmallest, owmSumSmallestWithCount:
                        if op.k > 0:
                            let x = t.kth(l, r, op.k-1)
                            pair = t.less(l, r, t.values.lowerBound(x))
                            pair.sum = pair.sum+repeated(x, op.k-pair.count)
                            pair.count = op.k
                    else: discard
                    if op.kind >= owmSumLowerboundWithCount:
                        answer = OfflineWMAnswer(operationIndex: j, kind: owaSumCount, sumCount: (checkedInt(pair.sum), pair.count))
                    elif op.kind >= owmSumLowerbound: answer.value = checkedInt(pair.sum)
                    else: answer.value = pair.count
            result.add answer
    proc runOfflineDynamicWaveletMatrix*(initial: openArray[int], operations: openArray[OfflineWMOperation]): seq[OfflineWMAnswer] =
        ## 初期列と全操作を渡し、更新後の問い合わせ結果を順に返す。
        ## 前処理と全操作をまとめて実行。計算量は冒頭参照。
        prepareOfflineDynamicWaveletMatrix(initial, operations).run()
