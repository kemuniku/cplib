## デバッグ: debugOperations()は操作一覧、debugTimeline()は再実行したpop結果付き一覧を返します。
## 一覧は時刻順です。echo pq または echo pq.debugDump() でpop元の時刻も含めて表示できます。
## デバッグ結果の型QueueDebugEntryと列挙値qdkNone/qdkPush/qdkPopはretroactive_priority_queueで定義します。
## 任意の比較可能な時刻を事前登録して使うRetroactivePriorityQueueです。
## 時刻は昇順に並べて重複除去します。未登録時刻への更新はassertで拒否します。
## 操作の上書き、空へのpop、同値の優先順位は固定長版と同じです。
## QueueDeltaのtimeには圧縮前の時刻が入ります。
##
## .. code-block:: nim
##   import algorithm
##   import cplib/collections/compressed_retroactive_priority_queue
##   type Time = tuple[day, id: int]
##   var pq = initCompressedRetroactivePriorityQueue[Time, int64](
##     @[(0, 0), (0, 1), (0, 2)], order = Descending)
##   pq.setPush((0, 0), 10)
##   pq.setPush((0, 1), 20)
##   pq.setPop((0, 2))
##   assert pq.sum == 10

when not declared CPLIB_COLLECTIONS_COMPRESSED_RETROACTIVE_PRIORITY_QUEUE:
    const CPLIB_COLLECTIONS_COMPRESSED_RETROACTIVE_PRIORITY_QUEUE* = 1
    import algorithm, options
    import cplib/collections/retroactive_priority_queue
    include cplib/collections/compressed_coordinates_internal

    type CompressedRetroactivePriorityQueue*[K, T] = ref object
        coords: seq[K]
        indexSlots: seq[int]
        queue: RetroactivePriorityQueue[T]

    proc initCompressedRetroactivePriorityQueue*[K, T](times: openArray[K],
            order = Ascending): CompressedRetroactivePriorityQueue[K, T] =
        ## 時刻をソート・重複除去してO(N log N)時間・O(N)空間で生成します。
        ## 操作は時刻の昇順です。構築後の時刻追加はできません。Kには < と == が必要です。
        var coords = @times
        sortCompressedCoordinates(coords)
        var count = 0
        for i in 0..<coords.len:
            if count == 0 or coords[count - 1] != coords[i]:
                if count != i: coords[count] = coords[i]
                inc count
        coords.setLen(count)
        result = CompressedRetroactivePriorityQueue[K, T](coords: coords,
            indexSlots: initCompressedCoordinateIndex(coords),
            queue: initRetroactivePriorityQueue[T](count, order))

    proc coordinateIndex[K, T](self: CompressedRetroactivePriorityQueue[K, T], t: K): int =
        ## 登録済み時刻の添字を返します。未登録ならassertです。O(log N)。
        result = findCompressedCoordinate(self.coords, self.indexSlots, t)
        assert result >= 0, "更新する時刻は事前登録してください"

    proc convertDelta[K, T](self: CompressedRetroactivePriorityQueue[K, T],
            delta: QueueDelta[int, T]): QueueDelta[K, T] =
        ## 差分の添字を元の時刻に戻します。O(1)。
        for entry in delta.added:
            result.added.add((self.coords[entry.time], entry.value))
        for entry in delta.removed:
            result.removed.add((self.coords[entry.time], entry.value))

    proc setPush*[K, T](self: CompressedRetroactivePriorityQueue[K, T],
            t: K, value: T): QueueDelta[K, T] {.discardable.} =
        ## 時刻tの操作をpush(value)で上書きし、最終状態の差分を返します。O(log N)。
        self.convertDelta(self.queue.setPush(self.coordinateIndex(t), value))

    proc setPop*[K, T](self: CompressedRetroactivePriorityQueue[K, T],
            t: K): QueueDelta[K, T] {.discardable.} =
        ## 時刻tの操作をpopで上書きし、最終状態の差分を返します。O(log N)。
        self.convertDelta(self.queue.setPop(self.coordinateIndex(t)))

    proc erase*[K, T](self: CompressedRetroactivePriorityQueue[K, T],
            t: K): QueueDelta[K, T] {.discardable.} =
        ## 時刻tの操作を何もしない操作に変更し、最終状態の差分を返します。O(log N)。
        self.convertDelta(self.queue.erase(self.coordinateIndex(t)))

    proc len*[K, T](self: CompressedRetroactivePriorityQueue[K, T]): int =
        ## 全操作の実行後に残る要素数を返します。O(1)。
        self.queue.len

    proc sum*[K; T: SomeNumber](self: CompressedRetroactivePriorityQueue[K, T]): T =
        ## 全操作の実行後に残る値の総和をT型で返します。O(1)。
        self.queue.sum

    proc peek*[K, T](self: CompressedRetroactivePriorityQueue[K, T]): Option[T] =
        ## 最終状態の最優先要素を返します。空ならnoneです。O(1)。
        self.queue.peek()

    proc isRemaining*[K, T](self: CompressedRetroactivePriorityQueue[K, T], t: K): bool =
        ## 時刻tのpushが最後に残るかを返します。未登録時刻はfalseです。O(log N)。
        let i = findCompressedCoordinate(self.coords, self.indexSlots, t)
        i >= 0 and self.queue.isRemaining(i)

    proc debugOperations*[K, T](self: CompressedRetroactivePriorityQueue[K, T]): seq[QueueDebugEntry[K, T]] =
        ## 事前登録した全時刻の操作を昇順で返します。空操作も含み、pop結果は未計算です。O(N)。
        for entry in self.queue.debugOperations():
            result.add(QueueDebugEntry[K, T](time: self.coords[entry.time],
                kind: entry.kind, value: entry.value))

    proc debugTimeline*[K, T](self: CompressedRetroactivePriorityQueue[K, T]): seq[QueueDebugEntry[K, T]] =
        ## 全操作と実際のpop結果を元の時刻で返します。O(N log(N+2))時間・O(N)空間。
        for entry in self.queue.debugTimeline():
            var converted = QueueDebugEntry[K, T](time: self.coords[entry.time],
                kind: entry.kind, value: entry.value)
            if entry.popped.isSome:
                let popped = entry.popped.get
                converted.popped = some((time: self.coords[popped.time], value: popped.value))
            result.add(converted)

    proc debugDump*[K, T](self: CompressedRetroactivePriorityQueue[K, T]): string =
        ## 操作と実際のpop結果を表示用文字列で返します。O(N log(N+2)+出力文字数)。
        formatQueueDebug(self.debugTimeline())

    proc `$`*[K, T](self: CompressedRetroactivePriorityQueue[K, T]): string =
        ## debugDumpと同じ操作・pop結果を返します。O(N log(N+2)+出力文字数)。
        self.debugDump()

    proc poppedSum*[K; T: SomeNumber](self: CompressedRetroactivePriorityQueue[K, T]): T =
        ## 現在の操作列でpopされる値の総和を返します。空へのpopは0として扱います。O(1)。
        self.queue.poppedSum
