when not declared CPLIB_COLLECTIONS_OFFLINE_DYNAMIC_WAVELETMATRIX:
    const CPLIB_COLLECTIONS_OFFLINE_DYNAMIC_WAVELETMATRIX* = 1
    import algorithm, options, bitops
    ## 全パラメータが既知の操作列専用。位置・kは0始まり、位置/値区間は半開。
    ## M=初期長+insert/set数、S=異なる値数、L=ceil(log4(max(1,S)))。
    ## 前処理は期待O((N+Q)log(M+1)+M(L+1))、操作はO((L+1)log(M+1))。
    ## 記憶量O(M(L+1)+Q)。削除された版も固定位置として保持する。
    ## 1層2bit。Fenwickの桁0..2を隣接配置し、桁3は残りとして扱う。
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
            counts: seq[int32]
            sums: seq[OWMWideSum]
        OWMQuadLevel = object
            lowBits, highBits: seq[uint64]
            checkpoints: seq[array[3, int32]]
            offsets: array[4, int]
            counts: seq[array[3, int32]]
            sums: seq[array[3, OWMWideSum]]
        OWMNode = object
            left, right, size: int
            priority: uint64
            alive: bool
        OfflineDynamicWaveletMatrix* = ref object
            operations: seq[OfflineWMOperation]
            changes: seq[tuple[oldSlot, newSlot: int]]
            quads: seq[OWMQuadLevel]
            trees: seq[OWMFenwick]
            values, slotValues, bottomSlots: seq[int]
            n, height: int
            withSum, consumed: bool
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
        ## 有効要素のprefix個数。O(log M)。
        var i = r
        while i > 0:
            result += int(t.counts[i])
            i -= i and -i
    proc prefixSum(t: OWMFenwick, r: int): OWMWideSum {.inline.} =
        ## 有効値のprefix和。O(log M)。
        var i = r
        while i > 0:
            result = result+t.sums[i]
            i -= i and -i
    proc amount(t: OWMFenwick, l, r: int): int {.inline.} =
        ## 半開区間の有効個数。O(log M)。
        t.prefix(r)-t.prefix(l)
    proc weight(t: OWMFenwick, l, r: int): OWMWideSum {.inline.} =
        ## 半開区間の有効値の和。O(log M)。
        t.prefixSum(r)-t.prefixSum(l)
    proc locate(t: OWMFenwick, k: int): int =
        ## 0始まりのk番目の有効要素の固定位置。O(log M)。
        var step = 1
        while step < t.counts.len: step = step shl 1
        var rest = k
        while step > 0:
            let next = result+step
            if next < t.counts.len and int(t.counts[next]) <= rest:
                rest -= int(t.counts[next])
                result = next
            step = step shr 1
    proc change(t: var OWMFenwick, slot, value: int, add: bool) =
        ## 有効状態を変更。int.lowの符号反転を行わない。O(log M)。
        var i = slot+1
        while i < t.counts.len:
            if add:
                inc t.counts[i]
                if t.sums.len > 0: t.sums[i] = t.sums[i]+wide(value)
            else:
                dec t.counts[i]
                if t.sums.len > 0: t.sums[i] = t.sums[i]-wide(value)
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
        ## 桁0..2の該当laneだけ更新。桁3の個数は残りで扱う。O(log M)。
        if d == 3: return
        var i = pos+1
        let weight = wide(value)
        while i < q.counts.len:
            if add:
                inc q.counts[i][d]
                if q.sums.len > 0: q.sums[i][d] = q.sums[i][d]+weight
            else:
                dec q.counts[i][d]
                if q.sums.len > 0: q.sums[i][d] = q.sums[i][d]-weight
            i += i and -i
    proc amounts(q: OWMQuadLevel, l, r: int): array[3, int] =
        ## 一組のFenwick走査で3桁の区間個数を同時に取得。O(log M)。
        var i = r
        while i > 0:
            for d in 0..2: result[d] += int(q.counts[i][d])
            i -= i and -i
        i = l
        while i > 0:
            for d in 0..2: result[d] -= int(q.counts[i][d])
            i -= i and -i
    proc below(q: OWMQuadLevel, l, r, digitLimit: int, withSum: bool): tuple[sum: OWMWideSum, count: int] =
        ## 閾値桁未満のlaneを一組のFenwick走査で集計。O(log M)。
        if digitLimit == 0: return
        var i = r
        while i > 0:
            for d in 0..<digitLimit:
                result.count += int(q.counts[i][d])
                if withSum: result.sum = result.sum+q.sums[i][d]
            i -= i and -i
        i = l
        while i > 0:
            for d in 0..<digitLimit:
                result.count -= int(q.counts[i][d])
                if withSum: result.sum = result.sum-q.sums[i][d]
            i -= i and -i
    proc pull(nodes: var seq[OWMNode], root: int) =
        ## 前処理木の有効サイズを再計算。O(1)。
        nodes[root].size = nodes[nodes[root].left].size+nodes[nodes[root].right].size+int(nodes[root].alive)
    proc merge(nodes: var seq[OWMNode], a, b: int): int =
        ## 固定順序を保って前処理木を結合。期待O(log M)。
        if a == 0: return b
        if b == 0: return a
        if nodes[a].priority < nodes[b].priority:
            nodes[a].right = merge(nodes, nodes[a].right, b)
            nodes.pull(a)
            a
        else:
            nodes[b].left = merge(nodes, a, nodes[b].left)
            nodes.pull(b)
            b
    proc split(nodes: var seq[OWMNode], root, k: int): tuple[a, b: int] =
        ## 有効要素数kで分割。無効な版も木に保持。期待O(log M)。
        if root == 0: return (0, 0)
        let leftSize = nodes[nodes[root].left].size
        if k <= leftSize:
            let halves = split(nodes, nodes[root].left, k)
            nodes[root].left = halves.b
            nodes.pull(root)
            (halves.a, root)
        else:
            let halves = split(nodes, nodes[root].right, k-leftSize-int(nodes[root].alive))
            nodes[root].right = halves.a
            nodes.pull(root)
            (root, halves.b)
    proc remove(nodes: var seq[OWMNode], root, k: int): int =
        ## k番目を無効化し、版IDを返す。期待O(log M)。
        let leftSize = nodes[nodes[root].left].size
        if k < leftSize: result = remove(nodes, nodes[root].left, k)
        elif nodes[root].alive and k == leftSize:
            nodes[root].alive = false
            result = root
        else: result = remove(nodes, nodes[root].right, k-leftSize-int(nodes[root].alive))
        nodes.pull(root)
    proc at(nodes: seq[OWMNode], root, k: int): int =
        ## 有効なk番目の版IDを返す。末尾境界は0。期待O(log M)。
        var node = root
        var index = k
        while node != 0:
            let leftSize = nodes[nodes[node].left].size
            if index < leftSize: node = nodes[node].left
            elif nodes[node].alive and index == leftSize: return node
            else:
                index -= leftSize+int(nodes[node].alive)
                node = nodes[node].right
    proc prepareOfflineDynamicWaveletMatrix*(initial: openArray[int], operations: openArray[OfflineWMOperation]): OfflineDynamicWaveletMatrix =
        ## 全操作を前処理。runは一度だけ呼べる。初期列と操作は変更しない。
        ## 期待O((N+Q)log(M+1)+M(L+1))。M<=int32.high、値はint全域。
        assert sizeof(int) == 8
        var total = initial.len
        var withSum = false
        for op in operations:
            if op.kind in {owmInsert, owmSet}: inc total
            if op.kind >= owmSumLowerbound: withSum = true
        assert total <= int32.high.int
        result = OfflineDynamicWaveletMatrix(operations: @operations, n: initial.len, withSum: withSum)
        result.changes = newSeq[tuple[oldSlot, newSlot: int]](operations.len)
        var nodes = newSeq[OWMNode](1)
        var versionValues = newSeq[int](1)
        var root = 0
        var rng = 0x9e3779b97f4a7c15'u64
        template newVersion(value: int): int =
            block:
                rng = rng xor (rng shl 13)
                rng = rng xor (rng shr 7)
                rng = rng xor (rng shl 17)
                nodes.add OWMNode(size: 1, alive: true, priority: rng)
                versionValues.add value
                nodes.high
        for x in initial:
            let id = newVersion(x)
            root = nodes.merge(root, id)
        var length = initial.len
        for j, op in operations:
            var oldId, newId: int
            case op.kind
            of owmInsert, owmSet, owmErase:
                assert op.l >= 0 and op.l <= length
                if op.kind != owmInsert:
                    assert op.l < length
                    oldId = nodes.remove(root, op.l)
                    dec length
                if op.kind != owmErase:
                    newId = newVersion(op.x)
                    let halves = nodes.split(root, op.l)
                    root = nodes.merge(nodes.merge(halves.a, newId), halves.b)
                    inc length
            of owmAccess:
                assert 0 <= op.l and op.l < length
                oldId = nodes.at(root, op.l)
            of owmSelect, owmLen: discard
            else:
                assert 0 <= op.l and op.l <= op.r and op.r <= length
                if op.kind in {owmKthSmallest, owmKthLargest}:
                    assert 0 <= op.k and op.k < op.r-op.l
                if op.kind in {owmSumSmallest, owmSumSmallestWithCount}:
                    assert 0 <= op.k and op.k <= op.r-op.l
                if op.kind == owmRank: assert op.l == 0
                oldId = nodes.at(root, op.l)
                newId = nodes.at(root, op.r)
            result.changes[j] = (oldId, newId)
        var order: seq[int]
        var stack: seq[int]
        var node = root
        while node != 0 or stack.len > 0:
            while node != 0:
                stack.add node
                node = nodes[node].left
            node = stack.pop()
            order.add node
            node = nodes[node].right
        var slots = newSeq[int](total+1)
        result.slotValues = newSeq[int](total)
        var active = newSeq[bool](total)
        for slot, id in order:
            slots[id] = slot
            result.slotValues[slot] = versionValues[id]
            active[slot] = id <= initial.len
        for j, change in result.changes.mpairs:
            let absent = if operations[j].kind in {owmInsert, owmErase, owmSet}: -1 else: total
            change.oldSlot = if change.oldSlot == 0: absent else: slots[change.oldSlot]
            change.newSlot = if change.newSlot == 0: absent else: slots[change.newSlot]
        result.values = result.slotValues
        result.values.sort()
        var unique: seq[int]
        for x in result.values:
            if unique.len == 0 or unique[^1] != x: unique.add x
        result.values = unique
        var capacity = 1
        while capacity < unique.len:
            inc result.height
            capacity = capacity shl 1
        var keys = newSeq[int](total)
        var perm = newSeq[int](total)
        for i, x in result.slotValues:
            keys[i] = unique.lowerBound(x)
            perm[i] = i
        let levels = (result.height+1) div 2
        result.quads = newSeq[OWMQuadLevel](levels)
        result.trees = newSeq[OWMFenwick](if levels == 0: 1 else: 2)
        for level in 0..levels:
            # 最上位は現在位置復元と全体和、最下位はselectに使用する。
            if level == 0 or level == levels:
                var tree = OWMFenwick(counts: newSeq[int32](total+1))
                if level == 0 and withSum: tree.sums = newSeq[OWMWideSum](total+1)
                for i in 0..<total:
                    if active[perm[i]]:
                        tree.counts[i+1] = 1
                        if tree.sums.len > 0: tree.sums[i+1] = wide(result.slotValues[perm[i]])
                for i in 1..total:
                    let parent = i+(i and -i)
                    if parent <= total:
                        tree.counts[parent] += tree.counts[i]
                        if tree.sums.len > 0: tree.sums[parent] = tree.sums[parent]+tree.sums[i]
                result.trees[if level == 0: 0 else: 1] = move(tree)
            if level == levels: break
            let shift = 2*(levels-1-level)
            var q = OWMQuadLevel(lowBits: newSeq[uint64]((total+63) div 64),
                highBits: newSeq[uint64]((total+63) div 64),
                checkpoints: newSeq[array[3, int32]](total div 64+1),
                counts: newSeq[array[3, int32]](total+1))
            if withSum: q.sums = newSeq[array[3, OWMWideSum]](total+1)
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
                if d < 3 and active[perm[i]]:
                    q.counts[i+1][d] = 1
                    if withSum: q.sums[i+1][d] = wide(result.slotValues[perm[i]])
            for d in 1..3: q.offsets[d] = q.offsets[d-1]+counts[d-1]
            for i in 1..total:
                let parent = i+(i and -i)
                if parent <= total:
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
            result += (q.lowBits.len+q.highBits.len)*sizeof(uint64)+sizeof(q.offsets)
            result += q.checkpoints.len*sizeof(array[3, int32])+q.counts.len*sizeof(array[3, int32])
            result += q.sums.len*sizeof(array[3, OWMWideSum])
        for tree in t.trees: result += tree.counts.len*sizeof(int32)+tree.sums.len*sizeof(OWMWideSum)
    proc bitWidth*(t: OfflineDynamicWaveletMatrix): int =
        ## 圧縮後の値のビット幅。O(1)。
        t.height
    proc toggle(t: OfflineDynamicWaveletMatrix, slot: int, add: bool) =
        ## 固定位置から静的rankで全層の有効状態を更新。O((L+1)log M)。
        let value = t.slotValues[slot]
        var pos = slot
        t.trees[0].change(pos, value, add)
        for q in t.quads.mitems:
            let d = q.digit(pos)
            q.change(pos, d, value, add)
            pos = q.offsets[d]+q.rank(pos, d)
        if t.quads.len > 0: t.trees[^1].change(pos, value, add)
    proc less(t: OfflineDynamicWaveletMatrix, left, right, limit: int): tuple[sum: OWMWideSum, count: int] =
        ## 圧縮値limit未満の個数と、必要なら和。O((L+1)log M)。
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
        ## 有効要素の小さい順index番目。O((L+1)log M)。
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
    proc occurrence(t: OfflineDynamicWaveletMatrix, k, x: int): int =
        ## 値xのk番目の現在位置。未存在は-1。O(L+log M)。
        let key = t.values.lowerBound(x)
        if k < 0 or key == t.values.len or t.values[key] != x: return -1
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
        ## 各回答は元の操作番号と結果種別を持つ。全体O(Q(L+1)log(M+1))。
        assert not t.consumed
        t.consumed = true
        for j, op in t.operations:
            var answer = OfflineWMAnswer(operationIndex: j, kind: owaInteger)
            case op.kind
            of owmInsert, owmErase, owmSet:
                let change = t.changes[j]
                if change.oldSlot >= 0:
                    answer.value = t.slotValues[change.oldSlot]
                    t.toggle(change.oldSlot, false)
                    dec t.n
                if change.newSlot >= 0:
                    t.toggle(change.newSlot, true)
                    inc t.n
                if op.kind != owmErase: continue
            of owmLen: answer.value = t.n
            of owmAccess: answer.value = t.slotValues[t.changes[j].oldSlot]
            of owmSelect: answer.value = t.occurrence(op.k, op.x)
            else:
                let l = t.changes[j].oldSlot
                let r = t.changes[j].newSlot
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
                            pair.count = t.less(l, r, key+1).count-t.less(l, r, key).count
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
        ## 期待O((N+Q)log(M+1)+M(L+1)+Q(L+1)log(M+1))。
        prepareOfflineDynamicWaveletMatrix(initial, operations).run()
