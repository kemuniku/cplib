## poppedSumは現在の操作列でpopされた値の総和をO(1)で返します。sumは残存値の総和です。
## デバッグ: debugOperations()は操作一覧、debugTimeline()は再実行したpop結果付き一覧を返します。
## 一覧は時刻順です。echo pq または echo pq.debugDump() でpop元の時刻も含めて表示できます。
## デバッグ結果の型QueueDebugEntryと列挙値qdkNone/qdkPush/qdkPopはretroactive_priority_queueで定義します。
## 任意の比較可能な時刻にpush/popを挿入・上書き・削除できます。時刻の事前登録は不要です。
## Mを登録中の操作数として、更新は償却O(log(M+2))、isRemainingは最悪O(log(M+2))です。
## AVL木の処理自体は最悪O(log(M+2))ですが、節点配列の領域拡張は償却計算量です。
## len・sum・peekはO(1)。領域は登録操作数の過去最大値に比例し、削除した領域は再利用します。
## 時刻は昇順に実行します。空へのpopは無視し、同値なら早い時刻のpushを先に取り出します。
## 過去のpopの返り値や途中時刻のキューは管理しません。sumには十分な幅の型を指定してください。
##
## .. code-block:: nim
##   import options
##   import cplib/collections/dynamic_retroactive_priority_queue
##   let pq = initDynamicRetroactivePriorityQueue[int, int64]()
##   pq.setPop(100)
##   pq.setPush(30, 5)
##   pq.setPush(-10, 2)
##   assert pq.sum == 5
##   pq.erase(100)
##   assert pq.peek() == some(2'i64)

when not declared CPLIB_COLLECTIONS_DYNAMIC_RETROACTIVE_PRIORITY_QUEUE:
    const CPLIB_COLLECTIONS_DYNAMIC_RETROACTIVE_PRIORITY_QUEUE* = 1
    import algorithm, options
    import cplib/collections/retroactive_priority_queue

    type
        DynamicRetroactiveOperation = enum
            drqNone, drqPush, drqPop
        DynamicRetroactiveNode[K, T, S] = object
            left, right, height, size: int
            time: K
            value: T
            operation: DynamicRetroactiveOperation
            remains: bool
            balance, minPrefix, remaining, removed: int
            when S isnot void:
                mapped, aggregate: S
        DynamicRetroactivePriorityQueue*[K, T, S = void] = ref object
            nodes: seq[DynamicRetroactiveNode[K, T, S]]
            free: seq[int]
            root, count, dummyRemoved: int
            order: SortOrder
            when S is void:
                when T is SomeNumber:
                    total, pushTotal: T
            else:
                op: proc(a, b: S): S
                lift: proc(value: T): S
                identity: S

    proc before[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], a, b: int): bool =
        ## 要素aをbより先に取り出すかを返します。O(1)。
        mixin `<`
        if a == 1: return false
        if b == 1: return true
        if self.nodes[a].value < self.nodes[b].value: return self.order == Ascending
        if self.nodes[b].value < self.nodes[a].value: return self.order == Descending
        self.nodes[a].time < self.nodes[b].time

    proc choose[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], a, b: int,
            remaining: bool): int =
        ## 残存最優先または削除済み最低優先の候補を返します。O(1)。
        if a == 0: return b
        if b == 0: return a
        if self.before(a, b) == remaining: a else: b

    proc ownBalance[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i: int): int =
        ## 一操作の収支を返します。O(1)。
        if i == 1: self.dummyRemoved
        elif self.nodes[i].operation == drqPop: -1
        elif self.nodes[i].operation == drqPush and not self.nodes[i].remains: 1
        else: 0

    proc ownCandidate[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i: int,
            remaining: bool): int =
        ## 一操作の候補を返します。番兵は無限個の低優先要素を表します。O(1)。
        if i == 1:
            if remaining or self.dummyRemoved > 0: return 1
        elif self.nodes[i].operation == drqPush and self.nodes[i].remains == remaining:
            return i

    proc pull[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i: int) =
        ## 部分木の高さ・要素数・集約値を更新します。O(1)。
        let l = self.nodes[i].left
        let r = self.nodes[i].right
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
        when S isnot void:
            let own = if i != 1 and self.nodes[i].operation == drqPush and self.nodes[i].remains:
                self.nodes[i].mapped
            else:
                self.identity
            self.nodes[i].aggregate = self.op(self.op(self.nodes[l].aggregate, own),
                self.nodes[r].aggregate)

    proc rotateLeft[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i: int): int =
        ## 左回転します。O(1)。
        result = self.nodes[i].right
        self.nodes[i].right = self.nodes[result].left
        self.nodes[result].left = i
        self.pull(i)
        self.pull(result)

    proc rotateRight[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i: int): int =
        ## 右回転します。O(1)。
        result = self.nodes[i].left
        self.nodes[i].left = self.nodes[result].right
        self.nodes[result].right = i
        self.pull(i)
        self.pull(result)

    proc rebalance[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i: int): int =
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

    proc earlier[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], a, b: int): bool =
        ## 番兵を最小として時刻を比較します。O(1)。
        mixin `<`
        if a == 1: return b != 1
        if b == 1: return false
        self.nodes[a].time < self.nodes[b].time

    proc insertNode[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], root, i: int): int =
        ## 未登録の節点を挿入します。O(log M)。
        if root == 0: return i
        if self.earlier(i, root):
            self.nodes[root].left = self.insertNode(self.nodes[root].left, i)
        else:
            self.nodes[root].right = self.insertNode(self.nodes[root].right, i)
        self.rebalance(root)

    proc detachMin[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], root: int,
            minimum: var int): int =
        ## 最小節点を切り離し、残りの根を返します。O(log M)。
        if self.nodes[root].left == 0:
            minimum = root
            return self.nodes[root].right
        self.nodes[root].left = self.detachMin(self.nodes[root].left, minimum)
        self.rebalance(root)

    proc deleteNode[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], root, i: int): int =
        ## 節点IDを変えずに指定節点を削除します。O(log M)。
        if root == i:
            let l = self.nodes[root].left
            let r = self.nodes[root].right
            if l == 0: return r
            if r == 0: return l
            var successor: int
            let rest = self.detachMin(r, successor)
            self.nodes[successor].left = l
            self.nodes[successor].right = rest
            return self.rebalance(successor)
        if self.earlier(i, root):
            self.nodes[root].left = self.deleteNode(self.nodes[root].left, i)
        else:
            self.nodes[root].right = self.deleteNode(self.nodes[root].right, i)
        self.rebalance(root)

    proc refresh[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], root, i: int) =
        ## 指定節点から根までの集約値を更新します。O(log M)。
        if root != i:
            if self.earlier(i, root): self.refresh(self.nodes[root].left, i)
            else: self.refresh(self.nodes[root].right, i)
        self.pull(root)

    proc locate[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], t: K): tuple[id, rank: int] =
        ## 時刻に対応する節点IDと挿入位置を返します。未登録IDは0です。O(log M)。
        mixin `<`
        var i = self.root
        while i != 0:
            if i == 1 or self.nodes[i].time < t:
                result.rank += self.nodes[self.nodes[i].left].size + 1
                i = self.nodes[i].right
            elif t < self.nodes[i].time:
                i = self.nodes[i].left
            else:
                result.rank += self.nodes[self.nodes[i].left].size
                result.id = i
                return

    proc ensureNode[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], t: K): tuple[id, rank: int] =
        ## 未登録なら空操作の節点を用意します。O(log M)、領域拡張は償却O(1)。
        result = self.locate(t)
        if result.id != 0: return
        if self.free.len > 0: result.id = self.free.pop()
        else:
            result.id = self.nodes.len
            self.nodes.add(default(DynamicRetroactiveNode[K, T, S]))
        self.nodes[result.id].time = t
        self.pull(result.id)
        self.root = self.insertNode(self.root, result.id)

    proc findBridge[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i, start,
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

    proc candidate[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i, start,
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

    proc changeRemaining[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i: int,
            remains: bool, delta: var QueueDelta[K, T]) =
        ## 最終状態の差分・総和と木の集約値を更新します。O(log M)。
        mixin `<`
        assert i != 0
        if i == 1:
            self.dummyRemoved += (if remains: -1 else: 1)
        else:
            self.nodes[i].remains = remains
            let entry = (time: self.nodes[i].time, value: self.nodes[i].value)
            if remains:
                inc self.count
                when S is void:
                    when T is SomeNumber: self.total += entry.value
                delta.added.add(entry)
            else:
                dec self.count
                when S is void:
                    when T is SomeNumber: self.total -= entry.value
                var transient = -1
                for j, added in delta.added:
                    if not (added.time < entry.time) and not (entry.time < added.time): transient = j
                if transient >= 0: delta.added.delete(transient)
                else: delta.removed.add(entry)
        self.refresh(self.root, i)

    proc eraseOperation[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i, rank: int,
            delta: var QueueDelta[K, T]) =
        ## 節点を残して操作のみ消し、最終状態を更新します。O(log M)。
        case self.nodes[i].operation
        of drqNone: return
        of drqPush:
            when S is void:
                when T is SomeSignedInt: self.pushTotal = self.pushTotal -% self.nodes[i].value
                elif T is SomeNumber: self.pushTotal -= self.nodes[i].value
            if self.nodes[i].remains:
                self.changeRemaining(i, false, delta)
            else:
                let bridge = self.findBridge(self.root, 0, rank + 1, 0, true)
                let x = self.candidate(self.root, 0, 0, bridge, true)
                self.changeRemaining(x, false, delta)
        of drqPop:
            let bridge = max(0, self.findBridge(self.root, 0, rank, 0, false))
            let x = self.candidate(self.root, 0, bridge, self.nodes[self.root].size, false)
            self.changeRemaining(x, true, delta)
        self.nodes[i].operation = drqNone
        self.nodes[i].value = default(T)
        when S isnot void: self.nodes[i].mapped = default(S)
        self.nodes[i].remains = false
        self.refresh(self.root, i)

    proc initDynamicRetroactivePriorityQueue*[K, T](
            order = Ascending): DynamicRetroactivePriorityQueue[K, T] =
        ## 空の操作列をO(1)で生成します。KとTには一貫した < が必要です。
        ## Ascendingはpop min、Descendingはpop maxです。
        result = DynamicRetroactivePriorityQueue[K, T](root: 1, order: order,
            nodes: newSeq[DynamicRetroactiveNode[K, T, void]](2))
        result.pull(1)

    proc initDynamicRetroactivePriorityQueue*[K, T, S](op: proc(a, b: S): S,
            e: S, lift: proc(value: T): S,
            order = Ascending): DynamicRetroactivePriorityQueue[K, T, S] =
        ## モノイド集約付きの空の操作列を生成します。op・liftと値のコピーがO(1)ならO(1)。
        ## 残存pushを時刻順で集約します。opは結合的、eは単位元、op・liftは副作用なしとしてください。
        result = DynamicRetroactivePriorityQueue[K, T, S](root: 1, order: order,
            nodes: newSeq[DynamicRetroactiveNode[K, T, S]](2), op: op, lift: lift, identity: e)
        result.nodes[0].aggregate = e
        result.pull(1)

    proc fold*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S]): S =
        ## 残存pushの時刻順のモノイド積を返します。空なら単位元です。値のコピーがO(1)ならO(1)。
        self.nodes[self.root].aggregate

    proc setPush*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S],
            t: K, value: T): QueueDelta[K, T] {.discardable.} =
        ## 時刻tにpushを挿入・上書きし、最終状態の差分を返します。償却O(log(M+2))。
        let (i, rank) = self.ensureNode(t)
        self.eraseOperation(i, rank, result)
        let bridge = max(0, self.findBridge(self.root, 0, rank, 0, false))
        let x = self.candidate(self.root, 0, bridge, self.nodes[self.root].size, false)
        self.nodes[i].operation = drqPush
        self.nodes[i].value = value
        when S is void:
            when T is SomeSignedInt: self.pushTotal = self.pushTotal +% value
            elif T is SomeNumber: self.pushTotal += value
        when S isnot void: self.nodes[i].mapped = self.lift(value)
        if x == 0 or self.before(x, i):
            self.changeRemaining(i, true, result)
        else:
            self.nodes[i].remains = false
            self.refresh(self.root, i)
            self.changeRemaining(x, true, result)

    proc setPop*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S],
            t: K): QueueDelta[K, T] {.discardable.} =
        ## 時刻tにpopを挿入・上書きし、最終状態の差分を返します。償却O(log(M+2))。
        let (i, rank) = self.ensureNode(t)
        if self.nodes[i].operation == drqPop: return
        self.eraseOperation(i, rank, result)
        let bridge = self.findBridge(self.root, 0, rank, 0, true)
        let x = self.candidate(self.root, 0, 0, bridge, true)
        self.changeRemaining(x, false, result)
        self.nodes[i].operation = drqPop
        self.refresh(self.root, i)

    proc erase*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S],
            t: K): QueueDelta[K, T] {.discardable.} =
        ## 時刻tの操作を削除します。未登録なら何もしません。償却O(log(M+2))。
        let (i, rank) = self.locate(t)
        if i == 0: return
        self.eraseOperation(i, rank, result)
        self.root = self.deleteNode(self.root, i)
        self.nodes[i] = default(DynamicRetroactiveNode[K, T, S])
        self.free.add(i)

    proc len*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S]): int =
        ## 全操作実行後に残る実要素数を返します。O(1)。
        self.count

    proc sum*[K; T: SomeNumber](self: DynamicRetroactivePriorityQueue[K, T]): T =
        ## 全操作実行後に残る値の総和を返します。O(1)。
        self.total

    proc peek*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S]): Option[T] =
        ## 最終状態の最優先要素を返します。空ならnoneです。O(1)。
        let i = self.nodes[self.root].remaining
        if i <= 1: none(T) else: some(self.nodes[i].value)

    proc isRemaining*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], t: K): bool =
        ## 時刻tのpushが最後に残るかを返します。未登録・popならfalseです。O(log M)。
        let i = self.locate(t).id
        i != 0 and self.nodes[i].operation == drqPush and self.nodes[i].remains

    proc debugOperations*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S]): seq[QueueDebugEntry[K, T]] =
        ## 登録中の操作を時刻順で返します。番兵・削除済み時刻を除き、pop結果は未計算です。O(M)。
        var stack: seq[int]
        var i = self.root
        while i != 0 or stack.len > 0:
            while i != 0:
                stack.add(i)
                i = self.nodes[i].left
            i = stack.pop()
            if i != 1:
                var entry = QueueDebugEntry[K, T](time: self.nodes[i].time)
                case self.nodes[i].operation
                of drqNone: entry.kind = qdkNone
                of drqPush:
                    entry.kind = qdkPush
                    entry.value = some(self.nodes[i].value)
                of drqPop: entry.kind = qdkPop
                result.add(entry)
            i = self.nodes[i].right

    proc debugTimeline*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S]): seq[QueueDebugEntry[K, T]] =
        ## 登録中の全操作と実際のpop結果を時刻順で返します。O(M log(M+2))時間・O(M)空間。
        result = self.debugOperations()
        replayQueueDebug(result, self.order)

    proc debugDump*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S]): string =
        ## 操作と実際のpop結果を表示用文字列で返します。O(M log(M+2)+出力文字数)。
        formatQueueDebug(self.debugTimeline())

    proc `$`*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S]): string =
        ## debugDumpと同じ操作・pop結果を返します。O(M log(M+2)+出力文字数)。
        self.debugDump()

    proc poppedSum*[K; T: SomeNumber](self: DynamicRetroactivePriorityQueue[K, T]): T =
        ## 現在の操作列でpopされる値の総和を返します。空へのpopは0として扱います。O(1)。
        ## 整数は結果が型に収まる必要があります。内部の全push総和は桁あふれを許容します。
        ## 浮動小数点は全push総和から残存総和を引くため、桁落ちが生じる場合があります。
        when T is SomeSignedInt: self.pushTotal -% self.total
        else: self.pushTotal - self.total
