when not declared CPLIB_COLLECTIONS_RADIX_HEAP:
    const CPLIB_COLLECTIONS_RADIX_HEAP* = 1
    import bitops

    type RadixHeap*[K: SomeInteger, V] = object
        buckets: array[sizeof(K) * 8 + 1, seq[tuple[key: K, value: V]]]
        minima: array[sizeof(K) * 8 + 1, K]
        last: K
        size: int

    proc radixHeapKey[K: SomeInteger](key: K): uint64 {.inline.} =
        ## 整数の大小関係を保つ符号なしキーに変換する。O(1)。
        when K is SomeSignedInt:
            result = cast[uint64](int64(key)) xor (1'u64 shl (sizeof(K) * 8 - 1))
            when sizeof(K) < 8:
                result = result and (high(uint64) shr (64 - sizeof(K) * 8))
        else:
            result = uint64(key)

    proc radixHeapBucket[K: SomeInteger](key, last: K): int {.inline.} =
        ## 最後に確定したキーとの差からバケット番号を求める。O(1)。
        let difference = radixHeapKey(key) xor radixHeapKey(last)
        if difference == 0: 0
        else: 64 - countLeadingZeroBits(difference)

    proc initRadixHeap*[K: SomeInteger, V](minKey: K = low(K)): RadixHeap[K, V] =
        ## minKey 以上のキーを扱う単調最小ヒープを作る。O(B)、B はキーのビット数。
        result.last = minKey

    proc len*[K: SomeInteger, V](self: RadixHeap[K, V]): int {.inline.} =
        ## 要素数を返す。O(1)。
        self.size

    proc isEmpty*[K: SomeInteger, V](self: RadixHeap[K, V]): bool {.inline.} =
        ## 空かどうかを返す。O(1)。
        self.size == 0

    proc push*[K: SomeInteger, V](self: var RadixHeap[K, V], key: K, value: V) =
        ## 最後に top/pop で参照したキー以上の要素を追加する。償却 O(1)。同値の順序は不定。
        assert key >= self.last, "RadixHeapには最後に参照したキー以上の値が必要です"
        let b = radixHeapBucket(key, self.last)
        if self.buckets[b].len == 0 or key < self.minima[b]:
            self.minima[b] = key
        self.buckets[b].add((key, value))
        inc self.size

    proc push*[K: SomeInteger, V](self: var RadixHeap[K, V], item: tuple[key: K, value: V]) =
        ## キーと値の組を追加する。償却 O(1)。キーの制約は push(key, value) と同じ。
        self.push(item.key, item.value)

    proc prepareRadixHeap[K: SomeInteger, V](self: var RadixHeap[K, V]) =
        ## 最小バケットを再分配する。各要素の移動は挿入から削除までに高々 B 回。
        assert self.size > 0, "空のRadixHeapは参照できません"
        if self.buckets[0].len != 0: return
        var b = 1
        while self.buckets[b].len == 0: inc b
        self.last = self.minima[b]
        for item in self.buckets[b]:
            let dest = radixHeapBucket(item.key, self.last)
            if self.buckets[dest].len == 0 or item.key < self.minima[dest]:
                self.minima[dest] = item.key
            self.buckets[dest].add(item)
        self.buckets[b].setLen(0)

    proc top*[K: SomeInteger, V](self: var RadixHeap[K, V]): tuple[key: K, value: V] =
        ## 最小要素を返し、以後追加できるキーの下限を更新する。push と合わせて一要素あたり償却 O(B)。
        self.prepareRadixHeap()
        self.buckets[0][^1]

    proc `[]`*[K: SomeInteger, V](self: var RadixHeap[K, V], i: Natural): tuple[key: K, value: V] =
        ## 添字 0 で最小要素を返す。計算量とキーの制約は top と同じ。
        assert i == 0, "参照できるのは先頭要素（添字0）のみです"
        self.top()

    proc pop*[K: SomeInteger, V](self: var RadixHeap[K, V]): tuple[key: K, value: V] =
        ## 最小要素を取り除いて返す。push と合わせて一要素あたり償却 O(B)。
        self.prepareRadixHeap()
        result = self.buckets[0].pop()
        dec self.size

    proc clear*[K: SomeInteger, V](self: var RadixHeap[K, V], minKey: K = low(K)) =
        ## 全要素を削除してキーの下限をリセットする。O(N + B)。
        for bucket in self.buckets.mitems: bucket.setLen(0)
        self.last = minKey
        self.size = 0
