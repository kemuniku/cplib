when not declared CPLIB_COLLECTIONS_MAX_HEAPQUEUE:
    const CPLIB_COLLECTIONS_MAX_HEAPQUEUE* = 1

    type MaxHeapQueue*[T] = object
        ## 最大値を先頭に持つ優先度付きキュー。要素の比較には `<` を使う。
        data: seq[T]

    proc initMaxHeapQueue*[T](): MaxHeapQueue[T] =
        ## 空のキューを作る。変数の宣言だけでも空に初期化される。O(1)。
        result = default(MaxHeapQueue[T])

    proc len*[T](heap: MaxHeapQueue[T]): int {.inline.} =
        ## 要素数を返す。O(1)。
        heap.data.len

    proc `[]`*[T](heap: MaxHeapQueue[T], i: Natural): lent T {.inline.} =
        ## 内部配列の i 番目を参照する。最大値は添字 0 で、全体は未整列。O(1)。
        heap.data[i]

    iterator items*[T](heap: MaxHeapQueue[T]): lent T {.inline.} =
        ## 内部配列の順に全要素を列挙する。列挙中の要素数変更は不可。O(N)。
        let length = heap.len
        for i in 0..<length:
            yield heap.data[i]
            assert heap.len == length, "列挙中にキューの要素数が変更されました"

    proc siftUp[T](heap: var MaxHeapQueue[T], index: int) =
        ## 指定位置の要素を上に移動し、ヒープ条件を復元する。O(log N)。
        let item = heap.data[index]
        var pos = index
        while pos > 0:
            let parent = (pos - 1) shr 1
            if not (heap.data[parent] < item): break
            heap.data[pos] = heap.data[parent]
            pos = parent
        heap.data[pos] = item

    proc siftDown[T](heap: var MaxHeapQueue[T], index: int) =
        ## 指定位置の要素を下に移動し、ヒープ条件を復元する。O(log N)。
        let item = heap.data[index]
        var pos = index
        var child = pos * 2 + 1
        while child < heap.len:
            if child + 1 < heap.len and not (heap.data[child + 1] < heap.data[child]):
                inc child
            if not (item < heap.data[child]): break
            heap.data[pos] = heap.data[child]
            pos = child
            child = pos * 2 + 1
        heap.data[pos] = item

    proc push*[T](heap: var MaxHeapQueue[T], item: sink T) =
        ## 要素を追加する。償却 O(log N)。
        heap.data.add(item)
        heap.siftUp(heap.len - 1)

    proc toMaxHeapQueue*[T](x: openArray[T]): MaxHeapQueue[T] =
        ## 配列の要素からキューを作る。O(N)。
        result.data = @x
        for i in countdown(x.len div 2 - 1, 0):
            result.siftDown(i)

    proc pop*[T](heap: var MaxHeapQueue[T]): T =
        ## 最大値を取り除いて返す。空のキューには使用不可。O(log N)。
        result = heap.data[0]
        let last = heap.data.pop()
        if heap.len > 0:
            heap.data[0] = last
            heap.siftDown(0)

    proc find*[T](heap: MaxHeapQueue[T], x: T): int =
        ## x と等しい最初の要素の添字を返す。存在しなければ -1。O(N)。
        for i in 0..<heap.len:
            if heap.data[i] == x: return i
        return -1

    proc contains*[T](heap: MaxHeapQueue[T], x: T): bool =
        ## x と等しい要素が存在するか返す。O(N)。
        heap.find(x) >= 0

    proc del*[T](heap: var MaxHeapQueue[T], index: Natural) =
        ## 指定した添字の要素を削除する。O(log N)。
        swap(heap.data[index], heap.data[^1])
        heap.data.setLen(heap.len - 1)
        if index < heap.len:
            if index > 0 and heap.data[(index - 1) shr 1] < heap.data[index]:
                heap.siftUp(index)
            else:
                heap.siftDown(index)

    proc replace*[T](heap: var MaxHeapQueue[T], item: sink T): T =
        ## 最大値を取り除いて返し、item を追加する。空には使用不可。O(log N)。
        result = heap.data[0]
        heap.data[0] = item
        heap.siftDown(0)

    proc pushpop*[T](heap: var MaxHeapQueue[T], item: sink T): T =
        ## item の追加後に最大値を取り除いて返す。空なら item を返す。O(log N)。
        result = item
        if heap.len > 0 and result < heap.data[0]:
            swap(result, heap.data[0])
            heap.siftDown(0)

    proc clear*[T](heap: var MaxHeapQueue[T]) =
        ## 全要素を削除する。要素の破棄を含めて O(N)。
        heap.data.setLen(0)

    proc `$`*[T](heap: MaxHeapQueue[T]): string =
        ## 内部配列の順に文字列化する。O(N + 出力文字列長)。
        result = "["
        for x in heap.data:
            if result.len > 1: result.add(", ")
            result.addQuoted(x)
        result.add("]")
