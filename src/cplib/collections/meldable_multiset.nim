when not declared CPLIB_COLLECTIONS_MELDABLE_MULTISET:
    const CPLIB_COLLECTIONS_MELDABLE_MULTISET* = 1
    import random

    type MeldableMultiSetNode[T] = ref object
        key: T
        ticket, priority: uint64
        size: int
        left, right: MeldableMultiSetNode[T]

    type MeldableMultiSet*[T] = ref object
        root: MeldableMultiSetNode[T]

    var meldableMultiSetTicket = 0'u64

    proc nodeSize[T](node: MeldableMultiSetNode[T]): int {.inline.} =
        ## 空部分木のサイズは0。O(1)。
        if node.isNil: 0 else: node.size

    proc updateSize[T](node: MeldableMultiSetNode[T]) {.inline.} =
        ## 左右の部分木から重複込みのサイズを更新する。O(1)。
        node.size = 1 + node.left.nodeSize + node.right.nodeSize

    proc requireSet[T](self: MeldableMultiSet[T]) {.inline.} =
        ## 未初期化の参照を検査する。O(1)。
        if self.isNil: raise newException(ValueError, "MeldableMultiSet must be initialized")

    proc nodeLess[T](a, b: MeldableMultiSetNode[T]): bool {.inline.} =
        ## キーの順序同値を一意な挿入番号で分ける。O(1)回の比較。
        mixin `<`
        if a.key < b.key: true
        elif b.key < a.key: false
        else: a.ticket < b.ticket

    proc higher[T](a, b: MeldableMultiSetNode[T]): bool {.inline.} =
        ## 優先度の衝突は挿入番号で分ける。O(1)。
        a.priority > b.priority or (a.priority == b.priority and a.ticket > b.ticket)

    proc splitNodes[T](root, pivot: MeldableMultiSetNode[T]): tuple[left, right: MeldableMultiSetNode[T]] =
        ## pivot未満と以上へ破壊的に分割する。期待O(log N)。
        if root.isNil: return
        if root.nodeLess(pivot):
            let parts = splitNodes(root.right, pivot)
            root.right = parts.left
            root.updateSize()
            result = (root, parts.right)
        else:
            let parts = splitNodes(root.left, pivot)
            root.left = parts.right
            root.updateSize()
            result = (parts.left, root)

    proc unionNodes[T](a, b: MeldableMultiSetNode[T]): MeldableMultiSetNode[T] =
        ## 共有節点のないtreapを併合する。m<=nで期待O(m log(n/m+1))。
        if a.isNil: return b
        if b.isNil: return a
        var a = a
        var b = b
        if b.higher(a): swap(a, b)
        let parts = splitNodes(b, a)
        a.left = unionNodes(a.left, parts.left)
        a.right = unionNodes(a.right, parts.right)
        a.updateSize()
        a

    proc joinNodes[T](a, b: MeldableMultiSetNode[T]): MeldableMultiSetNode[T] =
        ## 全a<全bのtreapを併合する。期待O(log N)。
        if a.isNil: return b
        if b.isNil: return a
        if a.higher(b):
            a.right = joinNodes(a.right, b)
            a.updateSize()
            return a
        b.left = joinNodes(a, b.left)
        b.updateSize()
        b

    proc eraseNode[T](root, target: MeldableMultiSetNode[T]): MeldableMultiSetNode[T] =
        ## 指定された一節点を削除する。期待O(log N)。
        if root == target: return joinNodes(root.left, root.right)
        if target.nodeLess(root): root.left = eraseNode(root.left, target)
        else: root.right = eraseNode(root.right, target)
        root.updateSize()
        root

    proc len*[T](self: MeldableMultiSet[T]): int =
        ## 重複込みの要素数を返す。O(1)。
        self.requireSet()
        self.root.nodeSize

    proc incl*[T](self: MeldableMultiSet[T], x: T) =
        ## 一要素を挿入する。期待O(log(N+1))、一節点を確保する。
        self.requireSet()
        if self.len == high(int) or meldableMultiSetTicket == high(uint64):
            raise newException(ValueError, "MeldableMultiSet capacity exceeded")
        inc meldableMultiSetTicket
        let node = MeldableMultiSetNode[T](key: x, ticket: meldableMultiSetTicket, priority: rand(uint64), size: 1)
        self.root = unionNodes(self.root, node)

    proc initMeldableMultiSet*[T](values: openArray[T] = []): MeldableMultiSet[T] =
        ## 独立した集合を作る。期待O(N log(N+1))、O(N)領域。
        result = MeldableMultiSet[T]()
        for x in values: result.incl(x)

    proc lowerBound*[T](self: MeldableMultiSet[T], x: T): int =
        ## x未満の要素数（重複込み）を返す。期待O(log(N+1))。
        mixin `<`
        self.requireSet()
        var node = self.root
        while not node.isNil:
            if node.key < x:
                result += node.left.nodeSize + 1
                node = node.right
            else: node = node.left

    proc upperBound*[T](self: MeldableMultiSet[T], x: T): int =
        ## x以下の要素数（重複込み）を返す。期待O(log(N+1))。
        mixin `<`
        self.requireSet()
        var node = self.root
        while not node.isNil:
            if x < node.key: node = node.left
            else:
                result += node.left.nodeSize + 1
                node = node.right

    proc count*[T](self: MeldableMultiSet[T], x: T): int =
        ## <による順序同値な要素数を返す。期待O(log(N+1))。
        self.upperBound(x) - self.lowerBound(x)

    proc contains*[T](self: MeldableMultiSet[T], x: T): bool =
        ## 順序同値な要素の存在を返す。期待O(log(N+1))。
        self.count(x) != 0

    proc excl*[T](self: MeldableMultiSet[T], x: T): bool {.discardable.} =
        ## 順序同値な一要素を削除し、存在したか返す。期待O(log(N+1))。
        mixin `<`
        self.requireSet()
        var node = self.root
        while not node.isNil:
            if x < node.key: node = node.left
            elif node.key < x: node = node.right
            else:
                self.root = eraseNode(self.root, node)
                return true

    proc kth*[T](self: MeldableMultiSet[T], k: int): T =
        ## 0始まりでk番目を返す。範囲外はIndexDefect。期待O(log(N+1))。
        self.requireSet()
        if k < 0 or k >= self.len: raise newException(IndexDefect, "MeldableMultiSet index out of range")
        var node = self.root
        var k = k
        while true:
            let leftSize = node.left.nodeSize
            if k < leftSize: node = node.left
            elif k == leftSize: return node.key
            else:
                k -= leftSize + 1
                node = node.right

    proc `[]`*[T](self: MeldableMultiSet[T], k: int): T =
        ## 0始まりでk番目を返す。期待O(log(N+1))。
        self.kth(k)

    iterator items*[T](self: MeldableMultiSet[T]): T =
        ## 重複を含め昇順に列挙する。O(N)、補助領域は期待O(log(N+1))。反復中の変更は禁止。
        self.requireSet()
        var stack: seq[MeldableMultiSetNode[T]]
        var node = self.root
        while not node.isNil or stack.len > 0:
            while not node.isNil:
                stack.add(node)
                node = node.left
            node = stack.pop()
            yield node.key
            node = node.right

    proc meld*[T](self, source: MeldableMultiSet[T]) =
        ## sourceを破壊的に併合して空にする。同一参照は何もしない。m<=nで期待O(m log(n/m+1))、空はO(1)。
        self.requireSet()
        source.requireSet()
        if self == source: return
        if source.len > high(int) - self.len: raise newException(ValueError, "MeldableMultiSet capacity exceeded")
        self.root = unionNodes(self.root, source.root)
        source.root = nil
