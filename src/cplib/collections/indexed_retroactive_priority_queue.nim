## 操作列の位置を指定してpush/popを挿入・上書き・削除するRetroactivePriorityQueueです。
## k・indexは0始まりの現在位置です。挿入は追加順に0から採番した操作IDを返します。
## IDは削除後も再利用せず、setPush/setPopによる上書きでは変わりません。eraseByIdで削除できます。
## push/popの順番は現在の操作列で数えます。popは空へのpopを含み、pushは取り出し済みも含みます。
## Mを操作数として、更新は償却O(log(M+2))、種類別の位置検索は最悪O(log(M+2))です。
## AVL木の操作は最悪O(log(M+2))、領域拡張は償却です。節点領域は操作数の過去最大値、ID管理領域は累計挿入回数に比例します。
## lenは最後に残る要素数、operationCountは操作数です。sum/poppedSumには十分な幅の数値型を使ってください。
## 同値なら操作列で先のpushを先に取り出します。各popの返り値や途中時刻の状態は管理しません。
## 位置が変化するためQueueDeltaは返しません。デバッグはecho pqで表示できます。
##
## .. code-block:: nim
##   import cplib/collections/indexed_retroactive_priority_queue
##   let pq = initIndexedRetroactivePriorityQueue[int]()
##   pq.insertPop(0)
##   pq.insertPushBeforePop(0, 10)
##   assert pq.poppedSum == 10
##   pq.insertPopBeforePush(0)
##   assert pq.popCount == 2

when not declared CPLIB_COLLECTIONS_INDEXED_RETROACTIVE_PRIORITY_QUEUE:
    const CPLIB_COLLECTIONS_INDEXED_RETROACTIVE_PRIORITY_QUEUE* = 1
    import algorithm, options
    import cplib/collections/retroactive_priority_queue

    type
        IndexedRetroactiveOperation = enum
            irqNone, irqPush, irqPop
        IndexedRetroactiveNode[T] = object
            left, right, parent, height, size, pushes, pops, operationId: int
            value: T
            operation: IndexedRetroactiveOperation
            remains: bool
            balance, minPrefix, remaining, removed: int
        IndexedRetroactivePriorityQueue*[T] = ref object
            nodes: seq[IndexedRetroactiveNode[T]]
            free, idNodes: seq[int]
            root, count, dummyRemoved: int
            order: SortOrder
            when T is SomeNumber:
                total, pushTotal: T

    proc nodeRank[T](self: IndexedRetroactivePriorityQueue[T], id: int): int =
        ## 節点の内部位置を親リンクから求めます。O(log M)。
        var i = id
        result = self.nodes[self.nodes[i].left].size
        while self.nodes[i].parent != 0:
            let p = self.nodes[i].parent
            if self.nodes[p].right == i: result += self.nodes[self.nodes[p].left].size + 1
            i = p

    proc before[T](self: IndexedRetroactivePriorityQueue[T], a, b: int): bool =
        ## 候補と新規pushの優先順位を比較します。同値の位置比較を含めO(log M)。
        mixin `<`
        if a == 1: return false
        if b == 1: return true
        if self.nodes[a].value < self.nodes[b].value: return self.order == Ascending
        if self.nodes[b].value < self.nodes[a].value: return self.order == Descending
        self.nodeRank(a) < self.nodeRank(b)

    proc choose[T](self: IndexedRetroactivePriorityQueue[T], a, b: int,
            remaining: bool): int =
        ## 左側の候補aと右側の候補bを結合します。同値は位置の前後で解決しO(1)。
        mixin `<`
        if a == 0: return b
        if b == 0: return a
        var first: bool
        if a == 1: first = false
        elif b == 1: first = true
        elif self.nodes[a].value < self.nodes[b].value: first = self.order == Ascending
        elif self.nodes[b].value < self.nodes[a].value: first = self.order == Descending
        else: first = true
        if first == remaining: a else: b

    proc ownBalance[T](self: IndexedRetroactivePriorityQueue[T], i: int): int =
        ## 一操作の収支を返します。O(1)。
        if i == 1: self.dummyRemoved
        elif self.nodes[i].operation == irqPop: -1
        elif self.nodes[i].operation == irqPush and not self.nodes[i].remains: 1
        else: 0

    proc ownCandidate[T](self: IndexedRetroactivePriorityQueue[T], i: int,
            remaining: bool): int =
        ## 一操作の候補を返します。番兵は無限個の低優先要素を表します。O(1)。
        if i == 1:
            if remaining or self.dummyRemoved > 0: return 1
        elif self.nodes[i].operation == irqPush and self.nodes[i].remains == remaining:
            return i

    proc pull[T](self: IndexedRetroactivePriorityQueue[T], i: int) =
        ## 部分木の高さ・要素数・集約値を更新します。O(1)。
        let l = self.nodes[i].left
        let r = self.nodes[i].right
        if l != 0: self.nodes[l].parent = i
        if r != 0: self.nodes[r].parent = i
        self.nodes[i].pushes = self.nodes[l].pushes + self.nodes[r].pushes + int(self.nodes[i].operation == irqPush)
        self.nodes[i].pops = self.nodes[l].pops + self.nodes[r].pops + int(self.nodes[i].operation == irqPop)
        let mid = self.nodes[l].balance + self.ownBalance(i)
        self.nodes[i].height = max(self.nodes[l].height, self.nodes[r].height) + 1
        self.nodes[i].size = self.nodes[l].size + 1 + self.nodes[r].size
        self.nodes[i].balance = mid + self.nodes[r].balance
        self.nodes[i].minPrefix = mid
        if l != 0: self.nodes[i].minPrefix = min(self.nodes[i].minPrefix, self.nodes[l].minPrefix)
        if r != 0: self.nodes[i].minPrefix = min(self.nodes[i].minPrefix, mid + self.nodes[r].minPrefix)
        self.nodes[i].remaining = self.choose(self.choose(self.nodes[l].remaining,
            self.ownCandidate(i, true), true), self.nodes[r].remaining, true)
        self.nodes[i].removed = self.choose(self.choose(self.nodes[l].removed,
            self.ownCandidate(i, false), false), self.nodes[r].removed, false)

    proc rotateLeft[T](self: IndexedRetroactivePriorityQueue[T], i: int): int =
        ## 左回転します。O(1)。
        result = self.nodes[i].right
        self.nodes[i].right = self.nodes[result].left
        self.nodes[result].left = i
        self.pull(i)
        self.pull(result)

    proc rotateRight[T](self: IndexedRetroactivePriorityQueue[T], i: int): int =
        ## 右回転します。O(1)。
        result = self.nodes[i].left
        self.nodes[i].left = self.nodes[result].right
        self.nodes[result].right = i
        self.pull(i)
        self.pull(result)

    proc rebalance[T](self: IndexedRetroactivePriorityQueue[T], i: int): int =
        ## 集約値を更新し、AVL木の平衡を保ちます。O(1)。
        self.pull(i)
        let l = self.nodes[i].left
        let r = self.nodes[i].right
        if self.nodes[l].height > self.nodes[r].height + 1:
            if self.nodes[self.nodes[l].left].height < self.nodes[self.nodes[l].right].height:
                self.nodes[i].left = self.rotateLeft(l)
            return self.rotateRight(i)
        if self.nodes[r].height > self.nodes[l].height + 1:
            if self.nodes[self.nodes[r].right].height < self.nodes[self.nodes[r].left].height:
                self.nodes[i].right = self.rotateRight(r)
            return self.rotateLeft(i)
        i

    proc insertNode[T](self: IndexedRetroactivePriorityQueue[T], root, i, position: int): int =
        ## 内部位置positionの直前に節点を挿入します。O(log M)。
        if root == 0: return i
        let mid = self.nodes[self.nodes[root].left].size
        if position <= mid:
            self.nodes[root].left = self.insertNode(self.nodes[root].left, i, position)
        else:
            self.nodes[root].right = self.insertNode(self.nodes[root].right, i, position - mid - 1)
        self.rebalance(root)

    proc detachMin[T](self: IndexedRetroactivePriorityQueue[T], root: int,
            minimum: var int): int =
        ## 最小節点を切り離し、残りの根を返します。O(log M)。
        if self.nodes[root].left == 0:
            minimum = root
            return self.nodes[root].right
        self.nodes[root].left = self.detachMin(self.nodes[root].left, minimum)
        self.rebalance(root)

    proc deleteNode[T](self: IndexedRetroactivePriorityQueue[T], root, position: int): int =
        ## 内部位置positionの節点を削除します。O(log M)。
        let mid = self.nodes[self.nodes[root].left].size
        if position == mid:
            let l = self.nodes[root].left
            let r = self.nodes[root].right
            if l == 0: return r
            if r == 0: return l
            var successor: int
            let rest = self.detachMin(r, successor)
            self.nodes[successor].left = l
            self.nodes[successor].right = rest
            return self.rebalance(successor)
        if position < mid:
            self.nodes[root].left = self.deleteNode(self.nodes[root].left, position)
        else:
            self.nodes[root].right = self.deleteNode(self.nodes[root].right, position - mid - 1)
        self.rebalance(root)

    proc refresh[T](self: IndexedRetroactivePriorityQueue[T], id: int) =
        ## 親リンクを辿って集約値を更新します。O(log M)。
        var i = id
        while i != 0:
            self.pull(i)
            i = self.nodes[i].parent

    proc nodeAt[T](self: IndexedRetroactivePriorityQueue[T], position: int): int =
        ## 番兵を含む内部位置にある節点を返します。O(log M)。
        var i = self.root
        var k = position
        while i != 0:
            let mid = self.nodes[self.nodes[i].left].size
            if k < mid: i = self.nodes[i].left
            elif k == mid: return i
            else:
                k -= mid + 1
                i = self.nodes[i].right

    proc addEmptyNode[T](self: IndexedRetroactivePriorityQueue[T], position: int): int =
        ## 内部位置positionに一時的な空操作を挿入し、操作IDを返します。償却O(log(M+2))。
        var i: int
        if self.free.len > 0: i = self.free.pop()
        else:
            i = self.nodes.len
            self.nodes.add(default(IndexedRetroactiveNode[T]))
        result = self.idNodes.len
        self.idNodes.add(i)
        self.nodes[i].operationId = result
        self.pull(i)
        self.root = self.insertNode(self.root, i, position)
        self.nodes[self.root].parent = 0

    proc findBridge[T](self: IndexedRetroactivePriorityQueue[T], i, start,
            t, prefix: int, first: bool): int =
        ## t以上で最初、またはt以下で最後の収支0の境界を返します。O(log M)。
        if i == 0: return -1
        let finish = start + self.nodes[i].size
        if first:
            if finish < t: return -1
        elif start >= t: return -1
        if prefix + self.nodes[i].minPrefix > 0: return -1
        let l = self.nodes[i].left
        let r = self.nodes[i].right
        let mid = start + self.nodes[l].size
        let after = prefix + self.nodes[l].balance + self.ownBalance(i)
        if first:
            result = self.findBridge(l, start, t, prefix, first)
            if result >= 0: return
            if mid + 1 >= t and after == 0: return mid + 1
            result = self.findBridge(r, mid + 1, t, after, first)
        else:
            result = self.findBridge(r, mid + 1, t, after, first)
            if result >= 0: return
            if mid + 1 <= t and after == 0: return mid + 1
            result = self.findBridge(l, start, t, prefix, first)

    proc candidate[T](self: IndexedRetroactivePriorityQueue[T], i, start,
            left, right: int, remaining: bool): int =
        ## 半開区間の残存最優先または削除済み最低優先を返します。O(log M)。
        if i == 0 or right <= start or start + self.nodes[i].size <= left: return 0
        if left <= start and start + self.nodes[i].size <= right:
            return (if remaining: self.nodes[i].remaining else: self.nodes[i].removed)
        let mid = start + self.nodes[self.nodes[i].left].size
        result = self.candidate(self.nodes[i].left, start, left, right, remaining)
        if left <= mid and mid < right:
            result = self.choose(result, self.ownCandidate(i, remaining), remaining)
        result = self.choose(result,
            self.candidate(self.nodes[i].right, mid + 1, left, right, remaining), remaining)

    proc changeRemaining[T](self: IndexedRetroactivePriorityQueue[T], i: int, remains: bool) =
        ## 残存状態・総和と木の集約値を更新します。O(log M)。
        assert i != 0
        if i == 1:
            self.dummyRemoved += (if remains: -1 else: 1)
        else:
            self.nodes[i].remains = remains
            if remains:
                inc self.count
                when T is SomeNumber: self.total += self.nodes[i].value
            else:
                dec self.count
                when T is SomeNumber: self.total -= self.nodes[i].value
        self.refresh(i)

    proc eraseOperation[T](self: IndexedRetroactivePriorityQueue[T], i, rank: int) =
        ## 節点を残して操作のみ消し、最終状態を更新します。O(log M)。
        case self.nodes[i].operation
        of irqNone: return
        of irqPush:
            when T is SomeSignedInt: self.pushTotal = self.pushTotal -% self.nodes[i].value
            elif T is SomeNumber: self.pushTotal -= self.nodes[i].value
            if self.nodes[i].remains:
                self.changeRemaining(i, false)
            else:
                let bridge = self.findBridge(self.root, 0, rank + 1, 0, true)
                let x = self.candidate(self.root, 0, 0, bridge, true)
                self.changeRemaining(x, false)
        of irqPop:
            let bridge = max(0, self.findBridge(self.root, 0, rank, 0, false))
            let x = self.candidate(self.root, 0, bridge, self.nodes[self.root].size, false)
            self.changeRemaining(x, true)
        self.nodes[i].operation = irqNone
        self.nodes[i].value = default(T)
        self.nodes[i].remains = false
        self.refresh(i)

    proc initIndexedRetroactivePriorityQueue*[T](order = Ascending): IndexedRetroactivePriorityQueue[T] =
        ## 空の操作列をO(1)で生成します。Ascendingはpop min、Descendingはpop maxです。
        result = IndexedRetroactivePriorityQueue[T](root: 1, order: order,
            nodes: newSeq[IndexedRetroactiveNode[T]](2))
        result.pull(1)

    proc operationCount*[T](self: IndexedRetroactivePriorityQueue[T]): int =
        ## 操作列の長さを返します。キュー内の要素数lenとは異なります。O(1)。
        self.nodes[self.root].size - 1

    proc pushCount*[T](self: IndexedRetroactivePriorityQueue[T]): int =
        ## 操作列内のpushの個数を返します。取り出し済みのpushも含みます。O(1)。
        self.nodes[self.root].pushes

    proc popCount*[T](self: IndexedRetroactivePriorityQueue[T]): int =
        ## 操作列内のpopの個数を返します。空へのpopも含みます。O(1)。
        self.nodes[self.root].pops

    proc setPush*[T](self: IndexedRetroactivePriorityQueue[T], index: int, value: T) =
        ## 既存のindex番目の操作をpushで上書きします。O(log(M+2))。
        assert 0 <= index and index < self.operationCount, "操作位置が範囲外です"
        let rank = index + 1
        let i = self.nodeAt(rank)
        self.eraseOperation(i, rank)
        let bridge = max(0, self.findBridge(self.root, 0, rank, 0, false))
        let x = self.candidate(self.root, 0, bridge, self.nodes[self.root].size, false)
        self.nodes[i].operation = irqPush
        self.nodes[i].value = value
        when T is SomeSignedInt: self.pushTotal = self.pushTotal +% value
        elif T is SomeNumber: self.pushTotal += value
        if x == 0 or self.before(x, i):
            self.changeRemaining(i, true)
        else:
            self.nodes[i].remains = false
            self.refresh(i)
            self.changeRemaining(x, true)

    proc setPop*[T](self: IndexedRetroactivePriorityQueue[T], index: int) =
        ## 既存のindex番目の操作をpopで上書きします。O(log(M+2))。
        assert 0 <= index and index < self.operationCount, "操作位置が範囲外です"
        let rank = index + 1
        let i = self.nodeAt(rank)
        if self.nodes[i].operation == irqPop: return
        self.eraseOperation(i, rank)
        let bridge = self.findBridge(self.root, 0, rank, 0, true)
        let x = self.candidate(self.root, 0, 0, bridge, true)
        self.changeRemaining(x, false)
        self.nodes[i].operation = irqPop
        self.refresh(i)

    proc insertPush*[T](self: IndexedRetroactivePriorityQueue[T], index: int, value: T): int {.discardable.} =
        ## indexの直前にpushを挿入し、操作IDを返します。index=operationCountなら末尾です。償却O(log(M+2))。
        assert 0 <= index and index <= self.operationCount, "挿入位置が範囲外です"
        result = self.addEmptyNode(index + 1)
        self.setPush(index, value)

    proc insertPop*[T](self: IndexedRetroactivePriorityQueue[T], index: int): int {.discardable.} =
        ## indexの直前にpopを挿入し、操作IDを返します。index=operationCountなら末尾です。償却O(log(M+2))。
        assert 0 <= index and index <= self.operationCount, "挿入位置が範囲外です"
        result = self.addEmptyNode(index + 1)
        self.setPop(index)

    proc operationIndex[T](self: IndexedRetroactivePriorityQueue[T], k: int, push: bool): int =
        ## 種類別のk番目の操作の位置を求めます。O(log(M+2))。
        let count = if push: self.pushCount else: self.popCount
        assert 0 <= k and k < count, "指定した種類の操作番号が範囲外です"
        var i = self.root
        var start = 0
        var rank = k
        while i != 0:
            let l = self.nodes[i].left
            let leftCount = if push: self.nodes[l].pushes else: self.nodes[l].pops
            if rank < leftCount:
                i = l
                continue
            rank -= leftCount
            let mid = start + self.nodes[l].size
            if self.nodes[i].operation == (if push: irqPush else: irqPop):
                if rank == 0: return mid - 1
                dec rank
            start = mid + 1
            i = self.nodes[i].right

    proc pushIndex*[T](self: IndexedRetroactivePriorityQueue[T], k: int): int =
        ## 現在の操作列でk番目のpushの位置を返します。kは0始まりです。O(log(M+2))。
        self.operationIndex(k, true)

    proc popIndex*[T](self: IndexedRetroactivePriorityQueue[T], k: int): int =
        ## 現在の操作列でk番目のpopの位置を返します。空へのpopも数えます。O(log(M+2))。
        self.operationIndex(k, false)

    proc insertPushBeforePop*[T](self: IndexedRetroactivePriorityQueue[T], k: int, value: T): int {.discardable.} =
        ## 0始まりでk番目のpopの直前にpushを挿入し、操作IDを返します。償却O(log(M+2))。
        self.insertPush(self.popIndex(k), value)

    proc insertPopBeforePush*[T](self: IndexedRetroactivePriorityQueue[T], k: int): int {.discardable.} =
        ## 0始まりでk番目のpushの直前にpopを挿入し、操作IDを返します。償却O(log(M+2))。
        self.insertPop(self.pushIndex(k))

    proc erase*[T](self: IndexedRetroactivePriorityQueue[T], index: int) =
        ## index番目の操作を削除します。後続の位置は1つ前にずれます。償却O(log(M+2))。
        assert 0 <= index and index < self.operationCount, "操作位置が範囲外です"
        let rank = index + 1
        let i = self.nodeAt(rank)
        self.eraseOperation(i, rank)
        self.root = self.deleteNode(self.root, rank)
        self.nodes[self.root].parent = 0
        self.idNodes[self.nodes[i].operationId] = 0
        self.nodes[i] = default(IndexedRetroactiveNode[T])
        self.free.add(i)

    proc indexOf*[T](self: IndexedRetroactivePriorityQueue[T], id: int): int =
        ## 操作IDの現在位置を返します。削除済み・未発行IDなら-1です。O(log(M+2))。
        if id < 0 or id >= self.idNodes.len or self.idNodes[id] == 0: return -1
        self.nodeRank(self.idNodes[id]) - 1

    proc eraseById*[T](self: IndexedRetroactivePriorityQueue[T], id: int) =
        ## 操作IDで削除します。削除済み・未発行IDなら何もしません。償却O(log(M+2))。
        let index = self.indexOf(id)
        if index >= 0: self.erase(index)

    proc len*[T](self: IndexedRetroactivePriorityQueue[T]): int =
        ## 全操作実行後に残る実要素数を返します。O(1)。
        self.count

    proc sum*[T: SomeNumber](self: IndexedRetroactivePriorityQueue[T]): T =
        ## 全操作実行後に残る値の総和を返します。O(1)。
        self.total

    proc peek*[T](self: IndexedRetroactivePriorityQueue[T]): Option[T] =
        ## 最終状態の最優先要素を返します。空ならnoneです。O(1)。
        let i = self.nodes[self.root].remaining
        if i <= 1: none(T) else: some(self.nodes[i].value)

    proc isRemaining*[T](self: IndexedRetroactivePriorityQueue[T], index: int): bool =
        ## index番目の操作が最後に残るpushかを返します。O(log(M+2))。
        assert 0 <= index and index < self.operationCount, "操作位置が範囲外です"
        let i = self.nodeAt(index + 1)
        self.nodes[i].operation == irqPush and self.nodes[i].remains

    proc poppedSum*[T: SomeNumber](self: IndexedRetroactivePriorityQueue[T]): T =
        ## popされた値の総和を返します。O(1)。浮動小数点では差による桁落ちに注意してください。
        ## 整数は返り値が型に収まる必要があります。内部の全push総和は桁あふれを許容します。
        when T is SomeSignedInt: self.pushTotal -% self.total
        else: self.pushTotal - self.total

    proc debugOperations*[T](self: IndexedRetroactivePriorityQueue[T]): seq[QueueDebugEntry[int, T]] =
        ## 現在の位置をtimeとした操作一覧を返します。pop結果は未計算です。O(M)。
        var stack: seq[int]
        var i = self.root
        while i != 0 or stack.len > 0:
            while i != 0:
                stack.add(i)
                i = self.nodes[i].left
            i = stack.pop()
            if i != 1:
                var entry = QueueDebugEntry[int, T](time: result.len)
                case self.nodes[i].operation
                of irqNone: entry.kind = qdkNone
                of irqPush:
                    entry.kind = qdkPush
                    entry.value = some(self.nodes[i].value)
                of irqPop: entry.kind = qdkPop
                result.add(entry)
            i = self.nodes[i].right

    proc debugTimeline*[T](self: IndexedRetroactivePriorityQueue[T]): seq[QueueDebugEntry[int, T]] =
        ## 操作一覧に実際のpop結果を付けて返します。O(M log(M+2))時間・O(M)空間。
        result = self.debugOperations()
        replayQueueDebug(result, self.order)

    proc debugDump*[T](self: IndexedRetroactivePriorityQueue[T]): string =
        ## 操作と実際のpop結果を表示用文字列で返します。O(M log(M+2)+出力文字数)。
        formatQueueDebug(self.debugTimeline())

    proc `$`*[T](self: IndexedRetroactivePriorityQueue[T]): string =
        ## debugDumpと同じ文字列を返します。O(M log(M+2)+出力文字数)。
        self.debugDump()
