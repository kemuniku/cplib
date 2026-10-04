when not declared CPLIB_COLLECTIONS_LAZY_LEFTIST_HEAP:
    const CPLIB_COLLECTIONS_LAZY_LEFTIST_HEAP* = 1

    type LazyLeftistHeapNode[K, V] = object
        key, lazy: K
        left, right, rank: int
        value: V

    type LazyLeftistHeapPool*[K, V] = object
        nodes: seq[LazyLeftistHeapNode[K, V]]
        zero: K

    proc initLazyLeftistHeapPool*[K, V](capacity: int = 0, zero: K = default(K)): LazyLeftistHeapPool[K, V] {.inline.} =
        ## 複数の最小ヒープを保持するプールを作る。空の根は -1、zero は加法の単位元。O(capacity) 領域。
        result.zero = zero
        result.nodes = newSeqOfCap[LazyLeftistHeapNode[K, V]](capacity)

    proc singleton*[K, V](self: var LazyLeftistHeapPool[K, V], key: K, value: V): int {.inline.} =
        ## 一要素のヒープの根を返す。同値はプールへの挿入順。償却 O(1)。
        result = self.nodes.len
        self.nodes.add(LazyLeftistHeapNode[K, V](key: key, lazy: self.zero,
            left: -1, right: -1, rank: 1, value: value))

    proc addAll*[K, V](self: var LazyLeftistHeapPool[K, V], root: int, delta: K) {.inline.} =
        ## 全キーへ delta を加える。空なら何もしない。加算は順序を保ち、オーバーフローしないこと。O(1)。
        mixin `+=`
        if root != -1:
            self.nodes[root].key += delta
            self.nodes[root].lazy += delta

    proc propagate[K, V](self: var LazyLeftistHeapPool[K, V], root: int) {.inline.} =
        ## 根の遅延加算を子へ伝える。O(1)。
        self.addAll(self.nodes[root].left, self.nodes[root].lazy)
        self.addAll(self.nodes[root].right, self.nodes[root].lazy)
        self.nodes[root].lazy = self.zero

    proc meld*[K, V](self: var LazyLeftistHeapPool[K, V], a, b: int): int =
        ## 同じプールの互いに素なヒープを破壊的に併合し、新しい根を返す。O(log N)、再帰深さ O(log N)。
        mixin `<`, `==`
        if a == -1: return b
        if b == -1: return a
        var a = a
        var b = b
        if self.nodes[b].key < self.nodes[a].key or
                (self.nodes[a].key == self.nodes[b].key and b < a):
            swap(a, b)
        self.propagate(a)
        self.nodes[a].right = self.meld(self.nodes[a].right, b)
        let lrank = if self.nodes[a].left == -1: 0 else: self.nodes[self.nodes[a].left].rank
        let rrank = if self.nodes[a].right == -1: 0 else: self.nodes[self.nodes[a].right].rank
        if lrank < rrank: swap(self.nodes[a].left, self.nodes[a].right)
        self.nodes[a].rank = (if self.nodes[a].right == -1: 0 else: self.nodes[self.nodes[a].right].rank) + 1
        a

    proc top*[K, V](self: LazyLeftistHeapPool[K, V], root: int): tuple[key: K, value: V] {.inline.} =
        ## 空でないヒープの最小要素を返す。O(1)。
        assert root != -1, "空のLazyLeftistHeapは参照できません"
        (self.nodes[root].key, self.nodes[root].value)

    proc pop*[K, V](self: var LazyLeftistHeapPool[K, V], root: int): int {.inline.} =
        ## 空でないヒープの最小要素を削除し、新しい根を返す。古い根は再利用不可。O(log N)。
        assert root != -1, "空のLazyLeftistHeapは削除できません"
        self.propagate(root)
        self.meld(self.nodes[root].left, self.nodes[root].right)
