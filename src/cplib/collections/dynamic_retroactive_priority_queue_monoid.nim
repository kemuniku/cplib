## デバッグ: debugOperations()は操作一覧、debugTimeline()は再実行したpop結果付き一覧を返します。
## 一覧は時刻順です。echo pq または echo pq.debugDump() でpop元の時刻も含めて表示できます。
## デバッグ結果の型QueueDebugEntryと列挙値qdkNone/qdkPush/qdkPopはretroactive_priority_queueで定義します。
## 任意時刻のpush/popを編集し、最後に残るpushの値を時刻の昇順でモノイド集約します。
## Kは時刻、Tは優先度比較に使う値、Sは集約値です。非可換モノイドにも対応します。
## op・lift・値のコピーをO(1)として、更新は償却O(log(M+2))、fold・len・peekはO(1)です。
## 空間は登録操作数の過去最大値に比例します。時刻の事前登録は不要です。
## 空へのpopは無視し、同値なら早い時刻のpushを先に取り出します。
## QueueDeltaには集約前の値が入ります。過去のpopの返り値や途中時刻の状態は管理しません。
##
## .. code-block:: nim
##   import cplib/collections/dynamic_retroactive_priority_queue_monoid
##   let pq = initDynamicRetroactivePriorityQueueMonoid[int, int, int](
##     proc(a, b: int): int = max(a, b), low(int), proc(x: int): int = x)
##   pq.setPush(20, 7)
##   pq.setPush(10, 3)
##   pq.setPop(30)
##   assert pq.fold() == 7

when not declared CPLIB_COLLECTIONS_DYNAMIC_RETROACTIVE_PRIORITY_QUEUE_MONOID:
    const CPLIB_COLLECTIONS_DYNAMIC_RETROACTIVE_PRIORITY_QUEUE_MONOID* = 1
    import algorithm, options
    import cplib/collections/retroactive_priority_queue
    import cplib/collections/dynamic_retroactive_priority_queue

    type DynamicRetroactivePriorityQueueMonoid*[K, T, S] = object
        queue: DynamicRetroactivePriorityQueue[K, T, S]

    proc initDynamicRetroactivePriorityQueueMonoid*[K, T, S](op: proc(a, b: S): S,
            e: S, lift: proc(value: T): S,
            order = Ascending): DynamicRetroactivePriorityQueueMonoid[K, T, S] =
        ## 空の操作列を生成します。opは結合的、eは単位元、op・liftは副作用なしとしてください。
        ## KとTには一貫した < が必要です。Ascendingはpop min、Descendingはpop maxです。
        result.queue = initDynamicRetroactivePriorityQueue[K, T, S](op, e, lift, order)

    proc setPush*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S],
            t: K, value: T): QueueDelta[K, T] {.discardable.} =
        ## 時刻tにpushを挿入・上書きし、最終状態の差分を返します。償却O(log(M+2))。
        setPush(self.queue, t, value)

    proc setPop*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S],
            t: K): QueueDelta[K, T] {.discardable.} =
        ## 時刻tにpopを挿入・上書きし、最終状態の差分を返します。償却O(log(M+2))。
        setPop(self.queue, t)

    proc erase*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S],
            t: K): QueueDelta[K, T] {.discardable.} =
        ## 時刻tの操作を削除します。未登録なら何もしません。償却O(log(M+2))。
        erase(self.queue, t)

    proc fold*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S]): S =
        ## 残存pushの時刻順の積を返します。空なら単位元です。O(1)。
        fold(self.queue)

    proc get_all*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S]): S =
        ## foldと同じモノイド積を返します。O(1)。
        self.fold()

    proc len*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S]): int =
        ## 全操作実行後に残る実要素数を返します。O(1)。
        len(self.queue)

    proc peek*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S]): Option[T] =
        ## 最終状態の最優先要素を返します。空ならnoneです。O(1)。
        peek(self.queue)

    proc isRemaining*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S], t: K): bool =
        ## 時刻tのpushが最後に残るかを返します。未登録・popならfalseです。O(log(M+2))。
        isRemaining(self.queue, t)

    proc debugOperations*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S]): seq[QueueDebugEntry[K, T]] =
        ## 登録中の操作を時刻順で返します。集約前の値を使い、pop結果は未計算です。O(M)。
        self.queue.debugOperations()

    proc debugTimeline*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S]): seq[QueueDebugEntry[K, T]] =
        ## 登録中の全操作と実際のpop結果を返します。O(M log(M+2))時間・O(M)空間。
        self.queue.debugTimeline()

    proc debugDump*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S]): string =
        ## 操作と実際のpop結果を表示用文字列で返します。O(M log(M+2)+出力文字数)。
        formatQueueDebug(self.debugTimeline())

    proc `$`*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S]): string =
        ## debugDumpと同じ操作・pop結果を返します。O(M log(M+2)+出力文字数)。
        self.debugDump()
