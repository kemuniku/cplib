when not declared CPLIB_COLLECTIONS_INTERVAL_HEAP:
    const CPLIB_COLLECTIONS_INTERVAL_HEAP* = 1

    type IntervalHeap*[T] = object
        data: seq[T]

    proc minParent(k: int): int =
        2 * ((((k div 2) + 1) div 2) - 1)

    proc minLeft(k: int): int = 2 * k + 2
    proc minRight(k: int): int = 2 * k + 4
    proc maxParent(k: int): int = minParent(k - 1) + 1
    proc maxLeft(k: int): int = minLeft(k - 1) + 1
    proc maxRight(k: int): int = minRight(k - 1) + 1

    proc siftUp[T](self: var IntervalHeap[T], k0: int, root = 0): int =
        var k = k0
        while k >= 2:
            let p = maxParent(k or 1)
            if p < root or not (self.data[p] < self.data[k]):
                break
            swap(self.data[k], self.data[p])
            k = p
        if (k and 1) == 0:
            while k >= 2:
                let p = minParent(k)
                if p < root or not (self.data[k] < self.data[p]):
                    break
                swap(self.data[k], self.data[p])
                k = p
        result = k

    proc siftDown[T](self: var IntervalHeap[T], k0: int): int =
        var k = k0
        let n = self.data.len
        if (k and 1) == 0:
            while minLeft(k) < n:
                let l = minLeft(k)
                let r = minRight(k)
                let c = if r < n and self.data[r] < self.data[l]: r else: l
                if not (self.data[c] < self.data[k]):
                    break
                swap(self.data[k], self.data[c])
                k = c
            if k + 1 < n and self.data[k + 1] < self.data[k]:
                swap(self.data[k], self.data[k + 1])
                inc k
        else:
            while maxLeft(k) < n:
                let l = maxLeft(k)
                let r = maxRight(k)
                let c = if r < n and self.data[l] < self.data[r]: r else: l
                if not (self.data[k] < self.data[c]):
                    break
                swap(self.data[k], self.data[c])
                k = c
            if self.data[k] < self.data[k - 1]:
                swap(self.data[k - 1], self.data[k])
                dec k
        result = k

    proc initIntervalHeap*[T](): IntervalHeap[T] =
        IntervalHeap[T](data: @[])

    proc push*[T](self: var IntervalHeap[T], x: T) =
        self.data.add(x)
        var k = self.data.high
        if (k and 1) != 0 and self.data[k] < self.data[k - 1]:
            swap(self.data[k - 1], self.data[k])
            dec k
        discard self.siftUp(k)

    proc toIntervalHeap*[T](a: openArray[T]): IntervalHeap[T] =
        result = initIntervalHeap[T]()
        for x in a:
            result.push(x)

    proc len*[T](self: IntervalHeap[T]): int =
        self.data.len

    proc min*[T](self: IntervalHeap[T]): T =
        assert self.data.len != 0
        self.data[0]

    proc max*[T](self: IntervalHeap[T]): T =
        assert self.data.len != 0
        self.data[min(1, self.data.high)]

    proc popMin*[T](self: var IntervalHeap[T]): T =
        assert self.data.len != 0
        result = self.data[0]
        swap(self.data[0], self.data[^1])
        self.data.setLen(self.data.len - 1)
        if self.data.len != 0:
            let k = self.siftDown(0)
            discard self.siftUp(k)

    proc popMax*[T](self: var IntervalHeap[T]): T =
        assert self.data.len != 0
        let k = min(1, self.data.high)
        result = self.data[k]
        if self.data.len <= 2:
            self.data.setLen(self.data.len - 1)
        else:
            swap(self.data[1], self.data[^1])
            self.data.setLen(self.data.len - 1)
            let moved = self.siftDown(1)
            discard self.siftUp(moved)

    proc clear*[T](self: var IntervalHeap[T]) =
        self.data.setLen(0)
