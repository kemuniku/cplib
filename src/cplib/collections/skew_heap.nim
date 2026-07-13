when not declared CPLIB_COLLECTIONS_SKEW_HEAP:
    const CPLIB_COLLECTIONS_SKEW_HEAP* = 1

    type SkewHeapNode*[T, D] = ref object
        value*: T
        lazy: D
        left, right: SkewHeapNode[T, D]

    type SkewHeap*[T, D] = object
        root: SkewHeapNode[T, D]
        size: int

    proc apply[T, D](node: SkewHeapNode[T, D], delta: D) =
        mixin `+`
        if node.isNil: return
        node.value = node.value + delta
        node.lazy = node.lazy + delta

    proc propagate[T, D](node: SkewHeapNode[T, D]) =
        if node.isNil: return
        node.left.apply(node.lazy)
        node.right.apply(node.lazy)
        node.lazy = default(D)

    proc meldNode[T, D](a, b: SkewHeapNode[T, D]): SkewHeapNode[T, D] =
        mixin `<`
        if a.isNil: return b
        if b.isNil: return a
        var x = a
        var y = b
        if y.value < x.value: swap(x, y)
        x.propagate()
        x.right = meldNode(x.right, y)
        swap(x.left, x.right)
        x

    proc initSkewHeap*[T, D](): SkewHeap[T, D] =
        SkewHeap[T, D]()

    proc len*[T, D](heap: SkewHeap[T, D]): int = heap.size
    proc isEmpty*[T, D](heap: SkewHeap[T, D]): bool = heap.size == 0

    proc push*[T, D](heap: var SkewHeap[T, D], value: T) =
        let node = SkewHeapNode[T, D](value: value)
        heap.root = meldNode(heap.root, node)
        inc heap.size

    proc top*[T, D](heap: SkewHeap[T, D]): T =
        assert not heap.root.isNil, "top from an empty skew heap"
        heap.root.value

    proc pop*[T, D](heap: var SkewHeap[T, D]): T =
        assert not heap.root.isNil, "pop from an empty skew heap"
        result = heap.root.value
        heap.root.propagate()
        heap.root = meldNode(heap.root.left, heap.root.right)
        dec heap.size

    proc addAll*[T, D](heap: var SkewHeap[T, D], delta: D) =
        heap.root.apply(delta)

    proc meld*[T, D](heap: var SkewHeap[T, D], other: var SkewHeap[T, D]) =
        heap.root = meldNode(heap.root, other.root)
        heap.size += other.size
        other.root = nil
        other.size = 0
