## 過去のpush/popを編集し、全操作の実行後のキューを管理します。
## 各更新は最悪O(log N)、len・sum・peek・isRemainingはO(1)、構築と空間はO(N)です。
## sumはSomeNumberに対応し、値と同じ型で加減算するため、十分な幅の型を指定してください。
## 更新が返すQueueDeltaは無視できます。任意型の集計はこの差分から更新できます。
## 過去の各popの返り値や、途中の時刻におけるキューの状態は管理しません。
##
## .. code-block:: nim
##   import options
##   import cplib/collections/retroactive_priority_queue
##   var pq = initRetroactivePriorityQueue[int64](3)
##   pq.setPush(0, 5)
##   pq.setPop(2)
##   pq.setPush(1, 2)
##   assert pq.sum == 5
##   assert pq.peek() == some(5'i64)
##   pq.erase(2)
##   assert pq.sum == 7

when not declared CPLIB_COLLECTIONS_RETROACTIVE_PRIORITY_QUEUE:
    const CPLIB_COLLECTIONS_RETROACTIVE_PRIORITY_QUEUE* = 1
    import algorithm, options

    type
        QueueDelta*[K, T] = object
            ## 最終状態の差分です。removedを削除してからaddedを追加してください。
            ## 同じ時刻の値の上書きでは、変更前と変更後の値をそれぞれ含みます。
            added*, removed*: seq[tuple[time: K, value: T]]
        RetroactiveOperation = enum
            rqNone, rqPush, rqPop
        RetroactiveNode = object
            # 削除済みpushを+1、popを-1、残存pushを0とした非空接頭辞の最小和です。
            # 全体の累積和は常に非負で、0の境界では将来消える要素がキュー内にありません。
            balance, minPrefix: int
            remaining, removed: int
        RetroactivePriorityQueue*[T] = ref object
            capacity, size, count, dummyRemoved: int
            order: SortOrder
            operations: seq[RetroactiveOperation]
            values: seq[T]
            remaining: seq[bool]
            tree: seq[RetroactiveNode]
            when T is SomeNumber:
                total: T

    proc before[T](self: RetroactivePriorityQueue[T], a, b: int): bool {.inline.} =
        ## 要素aがbより先に取り出されるかを返します。O(1)。
        mixin `<`
        if a == 0: return false
        if b == 0: return true
        if self.values[a] < self.values[b]: return self.order == Ascending
        if self.values[b] < self.values[a]: return self.order == Descending
        a < b

    proc choose[T](self: RetroactivePriorityQueue[T], a, b: int,
            remaining: bool): int {.inline.} =
        ## 残存要素の最優先、または削除済み要素の最低優先を選びます。O(1)。
        if a < 0: return b
        if b < 0: return a
        if self.before(a, b) == remaining: a else: b

    proc pull[T](self: RetroactivePriorityQueue[T], i: int) {.inline.} =
        ## 子の集約値から節点を更新します。O(1)。
        let a = self.tree[i * 2]
        let b = self.tree[i * 2 + 1]
        self.tree[i] = RetroactiveNode(
            balance: a.balance + b.balance,
            minPrefix: min(a.minPrefix, a.balance + b.minPrefix),
            remaining: self.choose(a.remaining, b.remaining, true),
            removed: self.choose(a.removed, b.removed, false))

    proc refresh[T](self: RetroactivePriorityQueue[T], t: int) =
        ## 時刻tの状態をセグメント木に反映します。O(log N)。
        var node = RetroactiveNode(remaining: -1, removed: -1)
        if t == 0:
            node.balance = self.dummyRemoved
            if self.dummyRemoved < self.capacity: node.remaining = 0
            if self.dummyRemoved > 0: node.removed = 0
        elif self.operations[t] == rqPush:
            if self.remaining[t]: node.remaining = t
            else:
                node.removed = t
                node.balance = 1
        elif self.operations[t] == rqPop:
            node.balance = -1
        node.minPrefix = node.balance
        var i = self.size + t
        self.tree[i] = node
        while i > 1:
            i = i shr 1
            self.pull(i)

    proc initRetroactivePriorityQueue*[T](n: int,
            order = Ascending): RetroactivePriorityQueue[T] =
        ## 時刻0..<nがすべて空操作のキューをO(n)時間・空間で生成します。
        ## Ascendingはpop min、Descendingはpop maxです。空へのpopは無視します。
        ## Tには一貫した < が必要です。同値なら早い時刻のpushを先に取り出します。
        assert n >= 0, "時刻数は非負にしてください"
        var size = 1
        while size < n + 1: size *= 2
        result = RetroactivePriorityQueue[T](capacity: n, size: size, order: order,
            operations: newSeq[RetroactiveOperation](n + 1), values: newSeq[T](n + 1),
            remaining: newSeq[bool](n + 1), tree: newSeq[RetroactiveNode](size * 2))
        for node in result.tree.mitems:
            node.remaining = -1
            node.removed = -1
        # 全実要素より優先度が低いn個の番兵を時刻0にまとめ、空へのpopを吸収します。
        result.refresh(0)

    proc findBridge[T](self: RetroactivePriorityQueue[T], node, l, r,
            t, prefix: int, first: bool): int =
        ## 時刻tの前後で累積和が0になる最寄りの境界を探索します。O(log N)。
        if first:
            if r < t: return -1
        elif l >= t:
            return -1
        if prefix + self.tree[node].minPrefix > 0: return -1
        if r - l == 1: return r
        let m = (l + r) shr 1
        let rightPrefix = prefix + self.tree[node * 2].balance
        if first:
            result = self.findBridge(node * 2, l, m, t, prefix, first)
            if result < 0:
                result = self.findBridge(node * 2 + 1, m, r, t, rightPrefix, first)
        else:
            result = self.findBridge(node * 2 + 1, m, r, t, rightPrefix, first)
            if result < 0:
                result = self.findBridge(node * 2, l, m, t, prefix, first)

    proc previousBridge[T](self: RetroactivePriorityQueue[T], t: int): int =
        ## t以下で累積和が0になる最後の境界を返します。O(log N)。
        max(0, self.findBridge(1, 0, self.size, t, 0, false))

    proc nextBridge[T](self: RetroactivePriorityQueue[T], t: int): int =
        ## t以上で累積和が0になる最初の境界を返します。O(log N)。
        self.findBridge(1, 0, self.size, t, 0, true)

    proc candidate[T](self: RetroactivePriorityQueue[T], left, right: int,
            remaining: bool): int =
        ## 半開区間の残存最優先要素または削除済み最低優先要素を返します。O(log N)。
        var l = left + self.size
        var r = right + self.size
        result = -1
        while l < r:
            if (l and 1) != 0:
                let x = if remaining: self.tree[l].remaining else: self.tree[l].removed
                result = self.choose(result, x, remaining)
                inc l
            if (r and 1) != 0:
                dec r
                let x = if remaining: self.tree[r].remaining else: self.tree[r].removed
                result = self.choose(result, x, remaining)
            l = l shr 1
            r = r shr 1

    proc changeRemaining[T](self: RetroactivePriorityQueue[T], t: int,
            remains: bool, delta: var QueueDelta[int, T]) =
        ## 最終状態への出入りを差分・総和・探索木に反映します。O(log N)。
        if t == 0:
            self.dummyRemoved += (if remains: -1 else: 1)
        else:
            self.remaining[t] = remains
            let entry = (time: t - 1, value: self.values[t])
            if remains:
                inc self.count
                when T is SomeNumber: self.total += self.values[t]
                delta.added.add(entry)
            else:
                dec self.count
                when T is SomeNumber: self.total -= self.values[t]
                var transient = -1
                for i, added in delta.added:
                    if added.time == entry.time: transient = i
                if transient >= 0: delta.added.delete(transient)
                else: delta.removed.add(entry)
        self.refresh(t)

    proc eraseOperation[T](self: RetroactivePriorityQueue[T], t: int,
            delta: var QueueDelta[int, T]) =
        ## 内部時刻tの操作を削除し、最終状態を更新します。O(log N)。
        case self.operations[t]
        of rqNone:
            return
        of rqPush:
            if self.remaining[t]:
                self.changeRemaining(t, false, delta)
            else:
                let bridge = self.nextBridge(t + 1)
                let x = self.candidate(0, bridge, true)
                self.changeRemaining(x, false, delta)
        of rqPop:
            let bridge = self.previousBridge(t)
            let x = self.candidate(bridge, self.capacity + 1, false)
            self.changeRemaining(x, true, delta)
        self.operations[t] = rqNone
        self.values[t] = default(T)
        self.refresh(t)

    proc erase*[T](self: RetroactivePriorityQueue[T], t: int): QueueDelta[int, T] {.discardable.} =
        ## 時刻tの操作を何もしない操作に変更し、最終状態の差分を返します。O(log N)。
        assert 0 <= t and t < self.capacity, "時刻が範囲外です"
        self.eraseOperation(t + 1, result)

    proc setPush*[T](self: RetroactivePriorityQueue[T], t: int,
            value: T): QueueDelta[int, T] {.discardable.} =
        ## 時刻tの操作をpush(value)で上書きし、最終状態の差分を返します。O(log N)。
        assert 0 <= t and t < self.capacity, "時刻が範囲外です"
        let i = t + 1
        self.eraseOperation(i, result)
        let bridge = self.previousBridge(i)
        let x = self.candidate(bridge, self.capacity + 1, false)
        self.operations[i] = rqPush
        self.values[i] = value
        if x < 0 or self.before(x, i):
            self.changeRemaining(i, true, result)
        else:
            self.remaining[i] = false
            self.refresh(i)
            self.changeRemaining(x, true, result)

    proc setPop*[T](self: RetroactivePriorityQueue[T], t: int): QueueDelta[int, T] {.discardable.} =
        ## 時刻tの操作をpopで上書きし、最終状態の差分を返します。O(log N)。
        assert 0 <= t and t < self.capacity, "時刻が範囲外です"
        let i = t + 1
        if self.operations[i] == rqPop: return
        self.eraseOperation(i, result)
        let bridge = self.nextBridge(i)
        let x = self.candidate(0, bridge, true)
        self.changeRemaining(x, false, result)
        self.operations[i] = rqPop
        self.refresh(i)

    proc len*[T](self: RetroactivePriorityQueue[T]): int =
        ## 全操作の実行後に残る実要素数を返します。O(1)。
        self.count

    proc sum*[T: SomeNumber](self: RetroactivePriorityQueue[T]): T =
        ## 全操作の実行後に残る値の総和をT型で返します。O(1)。
        self.total

    proc peek*[T](self: RetroactivePriorityQueue[T]): Option[T] =
        ## 最終状態の最優先要素を返します。空ならnoneです。O(1)。
        let i = self.tree[1].remaining
        if i <= 0: none(T)
        else: some(self.values[i])

    proc isRemaining*[T](self: RetroactivePriorityQueue[T], t: int): bool =
        ## 時刻tでpushした要素が最後に残るかを返します。push以外はfalseです。O(1)。
        assert 0 <= t and t < self.capacity, "時刻が範囲外です"
        self.operations[t + 1] == rqPush and self.remaining[t + 1]
