when not declared CPLIB_COLLECTIONS_OFFLINE_DYNAMIC_WAVELETMATRIX:
    const CPLIB_COLLECTIONS_OFFLINE_DYNAMIC_WAVELETMATRIX* = 1
    import algorithm, options
    ## 全パラメータが既知の操作列専用。位置・kは0始まり、位置/値区間は半開。
    ## M=初期長+insert/set数、S=異なる値数、L=ceil(log2(max(1,S)))。
    ## 前処理は期待O((N+Q)log(M+1)+M(L+1))、操作はO((L+1)log(M+1))。
    ## 記憶量O(M(L+1)+Q)。削除された版も固定位置として保持する。
    ## sum操作がある場合だけ和配列を確保。内部和はuint64のmod演算。
    ## 数学的な和を得るには回答がint内であること。範囲外は64bitで折り返す。
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
        OWMFenwick = object
            counts: seq[int32]
            sums: seq[uint64]
        OWMNode = object
            left, right, size: int
            priority: uint64
            alive: bool
        OfflineDynamicWaveletMatrix* = ref object
            operations: seq[OfflineWMOperation]
            changes: seq[tuple[oldSlot, newSlot: int]]
            zeros: seq[seq[int32]]
            middles: seq[int]
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
    proc prefix(t: OWMFenwick, r: int): int {.inline.} =
        ## 有効要素のprefix個数。O(log M)。
        var i = r
        while i > 0:
            result += int(t.counts[i])
            i -= i and -i
    proc prefixSum(t: OWMFenwick, r: int): uint64 {.inline.} =
        ## 有効値のprefix和。O(log M)。
        var i = r
        while i > 0:
            result += t.sums[i]
            i -= i and -i
    proc amount(t: OWMFenwick, l, r: int): int {.inline.} =
        ## 半開区間の有効個数。O(log M)。
        t.prefix(r)-t.prefix(l)
    proc weight(t: OWMFenwick, l, r: int): uint64 {.inline.} =
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
                if t.sums.len > 0: t.sums[i] += cast[uint64](value)
            else:
                dec t.counts[i]
                if t.sums.len > 0: t.sums[i] -= cast[uint64](value)
            i += i and -i
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
        result.zeros = newSeq[seq[int32]](result.height)
        result.middles = newSeq[int](result.height)
        result.trees = newSeq[OWMFenwick](result.height+1)
        for level in 0..result.height:
            var tree = OWMFenwick(counts: newSeq[int32](total+1))
            if withSum: tree.sums = newSeq[uint64](total+1)
            for i in 0..<total:
                if active[perm[i]]:
                    tree.counts[i+1] = 1
                    if withSum: tree.sums[i+1] = cast[uint64](result.slotValues[perm[i]])
            for i in 1..total:
                let parent = i+(i and -i)
                if parent <= total:
                    tree.counts[parent] += tree.counts[i]
                    if withSum: tree.sums[parent] += tree.sums[i]
            result.trees[level] = tree
            if level == result.height: break
            let bit = result.height-1-level
            var zeros = newSeq[int32](total+1)
            for i in 0..<total:
                zeros[i+1] = zeros[i]+int32((keys[i] shr bit and 1) == 0)
            let mid = int(zeros[total])
            result.zeros[level] = zeros
            result.middles[level] = mid
            var nextKeys, nextPerm = newSeq[int](total)
            for i in 0..<total:
                let dest = if (keys[i] shr bit and 1) == 0: int(zeros[i]) else: mid+i-int(zeros[i])
                nextKeys[dest] = keys[i]
                nextPerm[dest] = perm[i]
            keys = move(nextKeys)
            perm = move(nextPerm)
        result.bottomSlots = move(perm)
    proc storageBytes*(t: OfflineDynamicWaveletMatrix): int =
        ## 保持する配列の要素バイト数。seqヘッダ・容量余剰・前処理一時領域は除く。O(L)。
        result = t.operations.len*sizeof(OfflineWMOperation)+t.changes.len*sizeof(tuple[oldSlot, newSlot: int])
        result += (t.values.len+t.slotValues.len+t.bottomSlots.len+t.middles.len)*sizeof(int)
        for z in t.zeros: result += z.len*sizeof(int32)
        for tree in t.trees: result += tree.counts.len*sizeof(int32)+tree.sums.len*sizeof(int)
    proc bitWidth*(t: OfflineDynamicWaveletMatrix): int =
        ## 圧縮後の値のビット幅。O(1)。
        t.height
    proc toggle(t: OfflineDynamicWaveletMatrix, slot: int, add: bool) =
        ## 固定位置から静的rankで全層の有効状態を更新。O((L+1)log M)。
        let value = t.slotValues[slot]
        var pos = slot
        for level in 0..t.height:
            t.trees[level].change(pos, value, add)
            if level < t.height:
                let zero = int(t.zeros[level][pos])
                pos = if t.zeros[level][pos+1] != t.zeros[level][pos]: zero else: t.middles[level]+pos-zero
    proc less(t: OfflineDynamicWaveletMatrix, left, right, limit: int): tuple[sum: uint64, count: int] =
        ## 圧縮値limit未満の個数と、必要なら和。O((L+1)log M)。
        if limit <= 0: return
        if limit >= t.values.len:
            result.count = t.trees[0].amount(left, right)
            if t.withSum: result.sum = t.trees[0].weight(left, right)
            return
        var l = left
        var r = right
        for level in 0..<t.height:
            let zl = int(t.zeros[level][l])
            let zr = int(t.zeros[level][r])
            if (limit shr (t.height-1-level) and 1) != 0:
                result.count += t.trees[level+1].amount(zl, zr)
                if t.withSum: result.sum += t.trees[level+1].weight(zl, zr)
                l = t.middles[level]+l-zl
                r = t.middles[level]+r-zr
            else:
                l = zl
                r = zr
    proc kth(t: OfflineDynamicWaveletMatrix, left, right, index: int): int =
        ## 有効要素の小さい順index番目。O((L+1)log M)。
        var l = left
        var r = right
        var k = index
        var key = 0
        for level in 0..<t.height:
            let zl = int(t.zeros[level][l])
            let zr = int(t.zeros[level][r])
            let count = t.trees[level+1].amount(zl, zr)
            key = key shl 1
            if k < count:
                l = zl
                r = zr
            else:
                k -= count
                inc key
                l = t.middles[level]+l-zl
                r = t.middles[level]+r-zr
        t.values[key]
    proc occurrence(t: OfflineDynamicWaveletMatrix, k, x: int): int =
        ## 値xのk番目の現在位置。未存在は-1。O(L+log M)。
        let key = t.values.lowerBound(x)
        if k < 0 or key == t.values.len or t.values[key] != x: return -1
        var l = 0
        var r = t.slotValues.len
        for level in 0..<t.height:
            let zl = int(t.zeros[level][l])
            let zr = int(t.zeros[level][r])
            if (key shr (t.height-1-level) and 1) == 0:
                l = zl
                r = zr
            else:
                l = t.middles[level]+l-zl
                r = t.middles[level]+r-zr
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
                    var pair: tuple[sum: uint64, count: int]
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
                            pair.sum += uint64(op.k-pair.count)*cast[uint64](x)
                            pair.count = op.k
                    else: discard
                    if op.kind >= owmSumLowerboundWithCount:
                        answer = OfflineWMAnswer(operationIndex: j, kind: owaSumCount, sumCount: (cast[int](pair.sum), pair.count))
                    elif op.kind >= owmSumLowerbound: answer.value = cast[int](pair.sum)
                    else: answer.value = pair.count
            result.add answer
    proc runOfflineDynamicWaveletMatrix*(initial: openArray[int], operations: openArray[OfflineWMOperation]): seq[OfflineWMAnswer] =
        ## 初期列と全操作を渡し、更新後の問い合わせ結果を順に返す。
        ## 期待O((N+Q)log(M+1)+M(L+1)+Q(L+1)log(M+1))。
        prepareOfflineDynamicWaveletMatrix(initial, operations).run()
