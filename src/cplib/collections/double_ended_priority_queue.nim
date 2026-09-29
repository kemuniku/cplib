when not declared CPLIB_COLLECTIONS_DOUBLE_ENDED_PRIORITY_QUEUE:
    const CPLIB_COLLECTIONS_DOUBLE_ENDED_PRIORITY_QUEUE* = 1
    import bitops

    type DoubleEndedPriorityQueue*[T] = object
        ## 最小値と最大値を取り出せる min-max heap。比較には `<` のみを使う。同値の順序は不定。
        data: seq[T]

    proc initDoubleEndedPriorityQueue*[T](): DoubleEndedPriorityQueue[T] =
        ## 空のキューを作る。変数の宣言だけでも空に初期化される。O(1)。
        result = default(DoubleEndedPriorityQueue[T])

    proc len*[T](heap: DoubleEndedPriorityQueue[T]): int {.inline.} =
        ## 要素数を返す。O(1)。
        heap.data.len

    proc isEmpty*[T](heap: DoubleEndedPriorityQueue[T]): bool {.inline.} =
        ## 空かどうかを返す。O(1)。
        heap.len == 0

    proc depqLess[T](a, b: T, minLevel: static bool): bool {.inline.} =
        ## 層に応じて最小側または最大側を優先して比較する。O(1)。
        mixin `<`
        when minLevel: a < b
        else: b < a

    proc depqMinLevel(index: int): bool {.inline.} =
        ## 指定した添字が最小値を優先する偶数層に属するか返す。O(1)。
        (fastLog2(index + 1) and 1) == 0

    proc bubbleUp[T](heap: var DoubleEndedPriorityQueue[T], index: int,
            minLevel: static bool) =
        ## 同種の層の祖父と比較しながら上に移動する。O(log N)。
        var pos = index
        while pos >= 3:
            let grandparent = (pos - 3) div 4
            if not depqLess(heap.data[pos], heap.data[grandparent], minLevel): break
            swap(heap.data[pos], heap.data[grandparent])
            pos = grandparent

    proc trickleDown[T](heap: var DoubleEndedPriorityQueue[T], index: int,
            minLevel: static bool) =
        ## 子と孫を比較して下に移動し、ヒープ条件を復元する。O(log N)。
        var pos = index
        while pos * 2 + 1 < heap.len:
            let firstChild = pos * 2 + 1
            let firstGrandchild = pos * 4 + 3
            var best = firstChild
            if firstChild + 1 < heap.len and
                    depqLess(heap.data[firstChild + 1], heap.data[best], minLevel):
                best = firstChild + 1
            for child in firstGrandchild..<min(firstGrandchild + 4, heap.len):
                if depqLess(heap.data[child], heap.data[best], minLevel):
                    best = child
            if not depqLess(heap.data[best], heap.data[pos], minLevel): break
            swap(heap.data[pos], heap.data[best])
            if best < firstGrandchild: break
            let parent = (best - 1) div 2
            if depqLess(heap.data[parent], heap.data[best], minLevel):
                swap(heap.data[parent], heap.data[best])
            pos = best

    proc toDoubleEndedPriorityQueue*[T](values: openArray[T]): DoubleEndedPriorityQueue[T] =
        ## 配列の要素からキューを作る。O(N)。
        result.data = @values
        for i in countdown(values.len div 2 - 1, 0):
            if depqMinLevel(i): result.trickleDown(i, true)
            else: result.trickleDown(i, false)

    proc push*[T](heap: var DoubleEndedPriorityQueue[T], item: sink T) =
        ## 要素を追加する。償却 O(log N)。
        heap.data.add(item)
        let pos = heap.len - 1
        if pos == 0: return
        let parent = (pos - 1) div 2
        if depqMinLevel(pos):
            if depqLess(heap.data[parent], heap.data[pos], true):
                swap(heap.data[parent], heap.data[pos])
                heap.bubbleUp(parent, false)
            else:
                heap.bubbleUp(pos, true)
        else:
            if depqLess(heap.data[pos], heap.data[parent], true):
                swap(heap.data[parent], heap.data[pos])
                heap.bubbleUp(parent, true)
            else:
                heap.bubbleUp(pos, false)

    proc maxIndex[T](heap: DoubleEndedPriorityQueue[T]): int {.inline.} =
        ## 空でないキューの最大要素の添字を返す。O(1)。
        if heap.len == 1: 0
        elif heap.len == 2 or depqLess(heap.data[2], heap.data[1], true): 1
        else: 2

    proc min*[T](heap: DoubleEndedPriorityQueue[T]): lent T {.inline.} =
        ## 最小値を返す。空のキューには使用不可。O(1)。
        assert heap.len > 0, "空のキューの最小値は参照できません"
        heap.data[0]

    proc max*[T](heap: DoubleEndedPriorityQueue[T]): lent T {.inline.} =
        ## 最大値を返す。空のキューには使用不可。O(1)。
        assert heap.len > 0, "空のキューの最大値は参照できません"
        heap.data[heap.maxIndex()]

    proc popMin*[T](heap: var DoubleEndedPriorityQueue[T]): T =
        ## 最小値を取り除いて返す。空のキューには使用不可。O(log N)。
        assert heap.len > 0, "空のキューからは削除できません"
        result = heap.data[0]
        let last = heap.data.pop()
        if heap.len > 0:
            heap.data[0] = last
            heap.trickleDown(0, true)

    proc popMax*[T](heap: var DoubleEndedPriorityQueue[T]): T =
        ## 最大値を取り除いて返す。空のキューには使用不可。O(log N)。
        assert heap.len > 0, "空のキューからは削除できません"
        let index = heap.maxIndex()
        result = heap.data[index]
        let last = heap.data.pop()
        if index < heap.len:
            heap.data[index] = last
            heap.trickleDown(index, false)

    proc clear*[T](heap: var DoubleEndedPriorityQueue[T]) =
        ## 全要素を削除する。要素の破棄を含めて O(N)。
        heap.data.setLen(0)
