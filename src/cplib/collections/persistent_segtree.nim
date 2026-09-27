when not declared CPLIB_COLLECTIONS_PERSISTENT_SEGTREE:
    const CPLIB_COLLECTIONS_PERSISTENT_SEGTREE* = 1
    import cplib/utils/backwards_index
    import strutils

    type
        SegmentTreeNode*[T] = ref object
            value: T
            left, right: SegmentTreeNode[T]
        PersistentSegmentTreeNode[T] = ptr PersistentSegmentTreeNodeData[T]
        PersistentSegmentTreeNodeData[T] = object
            value: T
            left, right: PersistentSegmentTreeNode[T]
        PersistentSegmentTreeArena[T] = ref object
            blocks: seq[seq[PersistentSegmentTreeNodeData[T]]]
            used: int
        PersistentSegmentTreeOwner[T] = ref object
            arena: PersistentSegmentTreeArena[T]
            parent: PersistentSegmentTreeOwner[T]
            arenas: seq[PersistentSegmentTreeArena[T]]
        PSegmentTree*[T] = ref object
            owner: PersistentSegmentTreeOwner[T]
            root: PersistentSegmentTreeNode[T]
            lastnode, length: int
            op: proc(l, r: T): T
            e: T
        PersistentSegmentTree*[T] = PSegmentTree[T]

    proc newNode[T](arena: PersistentSegmentTreeArena[T], value: T,
            left: PersistentSegmentTreeNode[T] = nil,
            right: PersistentSegmentTreeNode[T] = nil): PersistentSegmentTreeNode[T] {.inline.} =
        ## ノードをまとめて確保し、参照の移動しない領域に格納します。償却O(1)。
        const blockSize = 1024
        if arena.blocks.len == 0 or arena.used == blockSize:
            arena.blocks.add(newSeq[PersistentSegmentTreeNodeData[T]](blockSize))
            arena.used = 0
        result = addr arena.blocks[^1][arena.used]
        inc arena.used
        result.value = value
        result.left = left
        result.right = right

    proc rootOwner[T](owner: PersistentSegmentTreeOwner[T]): PersistentSegmentTreeOwner[T] =
        ## 領域の所有者を取得し、経路を圧縮します。独立した木の数をKとして償却O(alpha(K))。
        result = owner
        while result.parent != nil: result = result.parent
        var current = owner
        while current.parent != nil:
            let next = current.parent
            current.parent = result
            current = next

    proc shareOwners[T](a, b: PersistentSegmentTreeOwner[T]) =
        ## 小さい側の領域を移し、循環や長い解放チェーンを作らず共有します。
        if a == b: return
        var left = rootOwner(a)
        var right = rootOwner(b)
        if left == right: return
        if left.arenas.len < right.arenas.len: swap(left, right)
        for arena in right.arenas: left.arenas.add(arena)
        right.arenas.setLen(0)
        right.parent = left

    proc withRoot[T](self: PSegmentTree[T], root: PersistentSegmentTreeNode[T]): PSegmentTree[T] =
        ## 指定した根を共有する版をO(1)で生成します。
        PSegmentTree[T](owner: self.owner, root: root, lastnode: self.lastnode,
                       length: self.length, op: self.op, e: self.e)

    proc initPersistentSegmentTree*[T](v: openArray[T], merge: proc(l, r: T): T,
                                       default: T): PSegmentTree[T] =
        ## vから永続セグ木をO(N)で構築します。mergeは結合的で、defaultは単位元です。
        ## 各演算はO(1)とし、引数や共有する参照先を変更しないでください。
        ## 共有・統合したノード領域は、それを所有するすべての版の破棄時に解放します。
        ## 個別の古い版を破棄しても、その領域のノードは回収しません。
        let values = @v
        let arena = PersistentSegmentTreeArena[T]()
        let owner = PersistentSegmentTreeOwner[T](arena: arena, arenas: @[arena])
        var size = 1
        while size < v.len: size *= 2
        proc build(l, r: int): PersistentSegmentTreeNode[T] =
            ## 区間[l,r)の部分木をO(r-l)で構築します。
            if r - l == 1:
                return arena.newNode(if l < values.len: values[l] else: default)
            let mid = (l + r) shr 1
            let left = build(l, mid)
            let right = build(mid, r)
            arena.newNode(merge(left.value, right.value), left, right)
        PSegmentTree[T](owner: owner, root: build(0, size), lastnode: size, length: v.len, op: merge, e: default)

    proc initPersistentSegmentTree*[T](n: int, merge: proc(l, r: T): T,
                                       default: T): PSegmentTree[T] =
        ## 全要素を単位元とする長さnの永続セグ木をO(N)で構築します。
        assert n >= 0, "長さは非負である必要があります"
        var values = newSeq[T](n)
        for value in values.mitems: value = default
        initPersistentSegmentTree(values, merge, default)

    proc initSegmentTree*[T](v: openArray[T], op: proc(l, r: T): T, e: T): PSegmentTree[T] =
        ## 従来の名前で永続セグ木をO(N)で構築します。
        initPersistentSegmentTree(v, op, e)

    proc initSegmentTree*[T](n: int, op: proc(l, r: T): T, e: T): PSegmentTree[T] =
        ## 全要素を単位元とする永続セグ木をO(N)で構築します。
        initPersistentSegmentTree(n, op, e)

    proc update*[T](st: PSegmentTree[T], idx: int, value: T): PSegmentTree[T] =
        ## idxをvalueに置き換えた新しい版を、時間・追加領域O(log N)で返します。
        assert 0 <= idx and idx < st.length, "添字が範囲外です"
        proc dfs(node: PersistentSegmentTreeNode[T], l, r: int): PersistentSegmentTreeNode[T] =
            ## 更新経路のみを複製します。O(log N)。
            if r - l == 1: return st.owner.arena.newNode(value)
            let mid = (l + r) shr 1
            var left = node.left
            var right = node.right
            if idx < mid: left = dfs(left, l, mid)
            else: right = dfs(right, mid, r)
            st.owner.arena.newNode(st.op(left.value, right.value), left, right)
        st.withRoot(dfs(st.root, 0, st.lastnode))

    proc copy_range*[T](self, source: PSegmentTree[T], q_left, q_right: int): PSegmentTree[T] =
        ## 半開区間[q_left,q_right)をsourceの同じ区間で置き換えます。木の操作は時間・追加領域O(log N)。
        ## 両方の木は同じ長さ・演算・単位元で構築してください。元の版は変更しません。
        ## 独立に構築した木の部分コピーでは領域の所有権も統合します。
        ## K個の独立した木の統合に伴う領域参照の移動は全操作でO(K log K)。
        assert self.length == source.length, "木の長さが異なります"
        assert 0 <= q_left and q_left <= q_right and q_right <= self.length, "区間が範囲外です"
        if q_left == q_right or self.root == source.root: return self
        if q_left == 0 and q_right == self.length:
            result = self.withRoot(source.root)
            result.owner = source.owner
            return
        proc dfs(dest, src: PersistentSegmentTreeNode[T], l, r: int): PersistentSegmentTreeNode[T] =
            ## 境界上のノードのみ複製し、完全に含まれる部分木を共有します。全体でO(log N)。
            if dest == src or q_right <= l or r <= q_left: return dest
            if q_left <= l and r <= q_right: return src
            let mid = (l + r) shr 1
            let left = dfs(dest.left, src.left, l, mid)
            let right = dfs(dest.right, src.right, mid, r)
            if left == dest.left and right == dest.right: return dest
            return self.owner.arena.newNode(self.op(left.value, right.value), left, right)
        result = self.withRoot(dfs(self.root, source.root, 0, self.lastnode))
        shareOwners(self.owner, source.owner)

    proc copy_range*[T](self, source: PSegmentTree[T], segment: HSlice[int, int]): PSegmentTree[T] =
        ## スライスをsourceの同じ区間で置き換えた新しい版を返します。
        self.copy_range(source, segment.a, segment.b + 1)

    proc get*[T](self: PSegmentTree[T], q_left, q_right: int): T =
        ## 半開区間[q_left,q_right)の積をO(log N)で返します。
        assert 0 <= q_left and q_left <= q_right and q_right <= self.length, "区間が範囲外です"
        if q_left == q_right: return self.e
        proc dfs(node: PersistentSegmentTreeNode[T], l, r: int): T =
            ## 指定区間との共通部分の積を取得します。全体でO(log N)。
            if q_left <= l and r <= q_right: return node.value
            let mid = (l + r) shr 1
            if q_right <= mid: return dfs(node.left, l, mid)
            if mid <= q_left: return dfs(node.right, mid, r)
            self.op(dfs(node.left, l, mid), dfs(node.right, mid, r))
        dfs(self.root, 0, self.lastnode)

    proc query*[T](st: PSegmentTree[T], l, r: int): T =
        ## 従来の名前で半開区間[l,r)の積をO(log N)で返します。
        st.get(l, r)

    proc get*[T](self: PSegmentTree[T], segment: HSlice[int, int]): T =
        ## スライスの区間積をO(log N)で返します。
        self.get(segment.a, segment.b + 1)

    proc `[]`*[T](self: PSegmentTree[T], segment: HSlice[int, int]): T =
        ## スライスの区間積をO(log N)で返します。
        self.get(segment)

    proc len*[T](self: PSegmentTree[T]): int =
        ## 要素数をO(1)で返します。
        self.length

    proc `[]`*[T](self: PSegmentTree[T], index: Natural): T {.backwardsIndex.} =
        ## indexの要素をO(log N)で返します。
        assert index < self.length, "添字が範囲外です"
        var node = self.root
        var l = 0
        var r = self.lastnode
        while r - l > 1:
            let mid = (l + r) shr 1
            if index < mid:
                node = node.left
                r = mid
            else:
                node = node.right
                l = mid
        node.value

    proc `[]=`*[T](self: var PSegmentTree[T], index: Natural, val: T) {.backwardsIndex.} =
        ## 変数を更新後の版へO(log N)で差し替えます。他の変数に保存した版は変化しません。
        self = self.update(index, val)

    proc get_all*[T](self: PSegmentTree[T]): T =
        ## 全要素の積をO(1)で返します。空の場合は単位元です。
        self.root.value

    proc `$`*[T](self: PSegmentTree[T]): string =
        ## 要素を空白区切りで文字列化します。O(N + 出力長)。
        var values: seq[string]
        proc visit(node: PersistentSegmentTreeNode[T], l, r: int) =
            ## 葉を添字順に列挙します。全体でO(N)。
            if l >= self.length: return
            if r - l == 1:
                values.add($node.value)
                return
            let mid = (l + r) shr 1
            visit(node.left, l, mid)
            visit(node.right, mid, r)
        visit(self.root, 0, self.lastnode)
        values.join(" ")

    template newPersistentSegWith*(V, merge, default: untyped): untyped =
        ## lとrを用いた式を演算として永続セグ木をO(N)で構築します。
        initPersistentSegmentTree[typeof(default)](V,
            proc(l {.inject.}, r {.inject.}: typeof(default)): typeof(default) = merge, default)

    template newSegWith*(V, merge, default: untyped): untyped =
        ## 通常のセグ木と同じ名前の構築テンプレートです。O(N)。
        newPersistentSegWith(V, merge, default)

    proc max_right*[T](self: PSegmentTree[T], l: int, f: proc(l: T): bool): int =
        ## f(get(l,r))を満たす最大のrをO(log N)で返します。
        ## fは区間の拡大に対して単調で、単位元に対してtrueを返す必要があります。
        assert 0 <= l and l <= self.length, "添字が範囲外です"
        assert f(self.e), "判定関数は単位元に対してtrueを返す必要があります"
        var sm = self.e
        proc dfs(node: PersistentSegmentTreeNode[T], nl, nr: int): int =
            ## 左から区間積を伸ばし、最初に条件を満たさなくなる境界を探します。
            if nr <= l or self.length <= nl: return self.length
            if l <= nl and nr <= self.length:
                let value = self.op(sm, node.value)
                if f(value):
                    sm = value
                    return self.length
                if nr - nl == 1: return nl
            let mid = (nl + nr) shr 1
            let boundary = dfs(node.left, nl, mid)
            if boundary != self.length: return boundary
            dfs(node.right, mid, nr)
        dfs(self.root, 0, self.lastnode)

    proc min_left*[T](self: PSegmentTree[T], r: int, f: proc(l: T): bool): int =
        ## f(get(l,r))を満たす最小のlをO(log N)で返します。
        ## fは区間の拡大に対して単調で、単位元に対してtrueを返す必要があります。
        assert 0 <= r and r <= self.length, "添字が範囲外です"
        assert f(self.e), "判定関数は単位元に対してtrueを返す必要があります"
        var sm = self.e
        proc dfs(node: PersistentSegmentTreeNode[T], nl, nr: int): int =
            ## 右から区間積を伸ばし、最初に条件を満たさなくなる境界を探します。
            if r <= nl: return 0
            if nr <= r:
                let value = self.op(node.value, sm)
                if f(value):
                    sm = value
                    return 0
                if nr - nl == 1: return nr
            let mid = (nl + nr) shr 1
            let boundary = dfs(node.right, mid, nr)
            if boundary != 0: return boundary
            dfs(node.left, nl, mid)
        dfs(self.root, 0, self.lastnode)
