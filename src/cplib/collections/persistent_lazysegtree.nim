when not declared CPLIB_COLLECTIONS_PERSISTENT_LAZYSEGTREE:
    const CPLIB_COLLECTIONS_PERSISTENT_LAZYSEGTREE* = 1
    import cplib/utils/backwards_index
    import strutils

    type
        PersistentLazySegmentTreeNode[S, F] = ptr PersistentLazySegmentTreeNodeData[S, F]
        PersistentLazySegmentTreeNodeData[S, F] = object
            value: S
            lazy: F
            pending: bool
            left, right: PersistentLazySegmentTreeNode[S, F]
        PersistentLazySegmentTreeArena[S, F] = ref object
            blocks: seq[seq[PersistentLazySegmentTreeNodeData[S, F]]]
            used: int
        PersistentLazySegmentTreeOwner[S, F] = ref object
            arena: PersistentLazySegmentTreeArena[S, F]
            parent: PersistentLazySegmentTreeOwner[S, F]
            arenas: seq[PersistentLazySegmentTreeArena[S, F]]
        PersistentLazySegmentTree*[S, F] = ref object
            owner: PersistentLazySegmentTreeOwner[S, F]
            root: PersistentLazySegmentTreeNode[S, F]
            lastnode, length: int
            merge: proc(l, r: S): S
            default: S
            mapping: proc(f: F, x: S): S
            composition: proc(f, g: F): F
            id: F
        PLazySegmentTree*[S, F] = PersistentLazySegmentTree[S, F]

    proc newNode[S, F](arena: PersistentLazySegmentTreeArena[S, F], value: S,
            lazy: F, left: PersistentLazySegmentTreeNode[S, F] = nil,
            right: PersistentLazySegmentTreeNode[S, F] = nil): PersistentLazySegmentTreeNode[S, F] {.inline.} =
        ## ノードをまとめて確保し、参照の移動しない領域に格納します。償却O(1)。
        const blockSize = 1024
        if arena.blocks.len == 0 or arena.used == blockSize:
            arena.blocks.add(newSeq[PersistentLazySegmentTreeNodeData[S, F]](blockSize))
            arena.used = 0
        result = addr arena.blocks[^1][arena.used]
        inc arena.used
        result.value = value
        result.lazy = lazy
        result.left = left
        result.right = right

    proc rootOwner[S, F](owner: PersistentLazySegmentTreeOwner[S, F]): PersistentLazySegmentTreeOwner[S, F] =
        ## 領域の所有者を取得し、経路を圧縮します。独立した木の数をKとして償却O(alpha(K))。
        result = owner
        while result.parent != nil: result = result.parent
        var current = owner
        while current.parent != nil:
            let next = current.parent
            current.parent = result
            current = next

    proc shareOwners[S, F](a, b: PersistentLazySegmentTreeOwner[S, F]) =
        ## 小さい側の領域を移し、循環や長い解放チェーンを作らず共有します。
        if a == b: return
        var left = rootOwner(a)
        var right = rootOwner(b)
        if left == right: return
        if left.arenas.len < right.arenas.len: swap(left, right)
        for arena in right.arenas: left.arenas.add(arena)
        right.arenas.setLen(0)
        right.parent = left

    proc initPersistentLazySegmentTree*[S, F](v: openArray[S], merge: proc(l, r: S): S,
            default: S, mapping: proc(f: F, x: S): S,
            composition: proc(f, g: F): F, id: F): PersistentLazySegmentTree[S, F] =
        ## vから永続遅延セグ木をO(N)で構築します。composition(f,g)はgの後にfを作用させます。
        ## mergeは結合的でdefaultは単位元、mappingはmergeと両立し、idは恒等作用とします。
        ## 各演算はO(1)とし、引数や共有する参照先を変更しないでください。
        ## 共有・統合したノード領域は、それを所有するすべての版の破棄時に解放します。
        ## 個別の古い版を破棄しても、その領域のノードは回収しません。
        let values = @v
        let arena = PersistentLazySegmentTreeArena[S, F]()
        let owner = PersistentLazySegmentTreeOwner[S, F](arena: arena, arenas: @[arena])
        var size = 1
        while size < v.len: size *= 2
        proc build(l, r: int): PersistentLazySegmentTreeNode[S, F] =
            ## 区間[l,r)の部分木をO(r-l)で構築します。
            if r - l == 1:
                return arena.newNode((if l < values.len: values[l] else: default), id)
            let mid = (l + r) shr 1
            let left = build(l, mid)
            let right = build(mid, r)
            arena.newNode(merge(left.value, right.value), id, left, right)
        PersistentLazySegmentTree[S, F](owner: owner, root: build(0, size), lastnode: size, length: v.len,
            merge: merge, default: default, mapping: mapping, composition: composition, id: id)

    proc initPersistentLazySegmentTree*[S, F](n: int, merge: proc(l, r: S): S,
            default: S, mapping: proc(f: F, x: S): S,
            composition: proc(f, g: F): F, id: F): PersistentLazySegmentTree[S, F] =
        ## 全要素を単位元とする長さnの永続遅延セグ木をO(N)で構築します。
        assert n >= 0, "長さは非負である必要があります"
        var values = newSeq[S](n)
        for value in values.mitems: value = default
        initPersistentLazySegmentTree(values, merge, default, mapping, composition, id)

    proc initLazySegmentTree*[S, F](v: openArray[S], merge: proc(l, r: S): S,
            default: S, mapping: proc(f: F, x: S): S,
            composition: proc(f, g: F): F, id: F): PersistentLazySegmentTree[S, F] =
        ## 通常の遅延セグ木と同じ名前で永続版をO(N)で構築します。
        initPersistentLazySegmentTree(v, merge, default, mapping, composition, id)

    proc initLazySegmentTree*[S, F](n: int, merge: proc(l, r: S): S,
            default: S, mapping: proc(f: F, x: S): S,
            composition: proc(f, g: F): F, id: F): PersistentLazySegmentTree[S, F] =
        ## 全要素を単位元とする永続遅延セグ木をO(N)で構築します。
        initPersistentLazySegmentTree(n, merge, default, mapping, composition, id)

    proc withRoot[S, F](self: PersistentLazySegmentTree[S, F],
            root: PersistentLazySegmentTreeNode[S, F]): PersistentLazySegmentTree[S, F] =
        ## 指定した根を持つ版をO(1)で生成します。
        PersistentLazySegmentTree[S, F](owner: self.owner, root: root, lastnode: self.lastnode, length: self.length,
            merge: self.merge, default: self.default, mapping: self.mapping,
            composition: self.composition, id: self.id)

    proc applied[S, F](self: PersistentLazySegmentTree[S, F],
            node: PersistentLazySegmentTreeNode[S, F], f: F): PersistentLazySegmentTreeNode[S, F] =
        ## ノードを複製して作用を適用します。時間・追加領域O(1)。
        result = self.owner.arena.newNode(self.mapping(f, node.value), self.id, node.left, node.right)
        if node.left != nil:
            result.lazy = if node.pending: self.composition(f, node.lazy) else: f
            result.pending = true

    proc carried[S, F](self: PersistentLazySegmentTree[S, F],
            node: PersistentLazySegmentTreeNode[S, F], carry: F,
            pending: bool): PersistentLazySegmentTreeNode[S, F] {.inline.} =
        ## 祖先の作用がある場合だけノードを複製します。O(1)。
        if pending: self.applied(node, carry)
        else: node

    proc descend[S, F](self: PersistentLazySegmentTree[S, F],
            node: PersistentLazySegmentTreeNode[S, F], carry: F,
            pending: bool): tuple[value: F, pending: bool] {.inline.} =
        ## 祖先と現在のノードの遅延作用を合成します。O(1)。
        if not node.pending: (carry, pending)
        elif not pending: (node.lazy, true)
        else: (self.composition(carry, node.lazy), true)

    proc update*[S, F](self: PersistentLazySegmentTree[S, F], p: Natural,
                        val: S): PersistentLazySegmentTree[S, F] =
        ## pをvalに置き換えた新しい版を、時間・追加領域O(log N)で返します。
        assert p < self.length, "添字が範囲外です"
        proc dfs(node: PersistentLazySegmentTreeNode[S, F], l, r: int,
                 carry: F, pending: bool): PersistentLazySegmentTreeNode[S, F] =
            ## 遅延作用を引数で渡し、結果に必要なノードのみ複製します。O(log N)。
            if r - l == 1: return self.owner.arena.newNode(val, self.id)
            let mid = (l + r) shr 1
            let next = self.descend(node, carry, pending)
            var left, right: PersistentLazySegmentTreeNode[S, F]
            if p < mid:
                left = dfs(node.left, l, mid, next.value, next.pending)
                right = self.carried(node.right, next.value, next.pending)
            else:
                left = self.carried(node.left, next.value, next.pending)
                right = dfs(node.right, mid, r, next.value, next.pending)
            self.owner.arena.newNode(self.merge(left.value, right.value), self.id, left, right)
        self.withRoot(dfs(self.root, 0, self.lastnode, self.id, false))

    proc apply*[S, F](self: PersistentLazySegmentTree[S, F], q_left, q_right: int,
                       f: F): PersistentLazySegmentTree[S, F] =
        ## 半開区間[q_left,q_right)にfを作用させた新しい版を、時間・追加領域O(log N)で返します。
        assert 0 <= q_left and q_left <= q_right and q_right <= self.length, "区間が範囲外です"
        if q_left == q_right: return self
        proc dfs(node: PersistentLazySegmentTreeNode[S, F], l, r: int,
                 carry: F, pending: bool): PersistentLazySegmentTreeNode[S, F] =
            ## 途中の伝播用ノードを生成せず、更新結果を構築します。全体でO(log N)。
            if q_right <= l or r <= q_left: return self.carried(node, carry, pending)
            if q_left <= l and r <= q_right:
                return self.applied(node, if pending: self.composition(f, carry) else: f)
            let mid = (l + r) shr 1
            let next = self.descend(node, carry, pending)
            let left = dfs(node.left, l, mid, next.value, next.pending)
            let right = dfs(node.right, mid, r, next.value, next.pending)
            self.owner.arena.newNode(self.merge(left.value, right.value), self.id, left, right)
        self.withRoot(dfs(self.root, 0, self.lastnode, self.id, false))

    proc apply*[S, F](self: PersistentLazySegmentTree[S, F], segment: HSlice[int, int],
                       f: F): PersistentLazySegmentTree[S, F] =
        ## スライスにfを作用させた新しい版を、時間・追加領域O(log N)で返します。
        self.apply(segment.a, segment.b + 1, f)

    proc copy_range*[S, F](self, source: PersistentLazySegmentTree[S, F],
                            q_left, q_right: int): PersistentLazySegmentTree[S, F] =
        ## 半開区間[q_left,q_right)をsourceの同じ区間で置き換えます。木の操作は時間・追加領域O(log N)。
        ## 両方の木は同じ長さ・演算・単位元で構築してください。元の版は変更しません。
        ## 独立に構築した木の部分コピーでは領域の所有権も統合します。
        ## K個の独立した木の統合に伴う領域参照の移動は全操作でO(K log K)。
        assert self.length == source.length, "木の長さが異なります"
        assert 0 <= q_left and q_left <= q_right and q_right <= self.length, "区間が範囲外です"
        if q_left == q_right: return self
        if q_left == 0 and q_right == self.length:
            result = self.withRoot(source.root)
            result.owner = source.owner
            return
        if self.root == source.root: return self
        proc dfs(dest, src: PersistentLazySegmentTreeNode[S, F],
                 l, r: int, destCarry, srcCarry: F,
                 destPending, srcPending: bool): PersistentLazySegmentTreeNode[S, F] =
            ## 採用する部分木だけに遅延作用を反映します。全体でO(log N)。
            if q_right <= l or r <= q_left: return self.carried(dest, destCarry, destPending)
            if q_left <= l and r <= q_right: return source.carried(src, srcCarry, srcPending)
            let mid = (l + r) shr 1
            let dc = self.descend(dest, destCarry, destPending)
            let sc = source.descend(src, srcCarry, srcPending)
            let left = dfs(dest.left, src.left, l, mid, dc.value, sc.value, dc.pending, sc.pending)
            let right = dfs(dest.right, src.right, mid, r, dc.value, sc.value, dc.pending, sc.pending)
            self.owner.arena.newNode(self.merge(left.value, right.value), self.id, left, right)
        result = self.withRoot(dfs(self.root, source.root, 0, self.lastnode, self.id, source.id, false, false))
        shareOwners(self.owner, source.owner)

    proc copy_range*[S, F](self, source: PersistentLazySegmentTree[S, F],
                            segment: HSlice[int, int]): PersistentLazySegmentTree[S, F] =
        ## スライスをsourceの同じ区間で置き換えた新しい版を、時間・追加領域O(log N)で返します。
        self.copy_range(source, segment.a, segment.b + 1)

    proc get*[S, F](self: PersistentLazySegmentTree[S, F], q_left, q_right: int): S =
        ## 半開区間[q_left,q_right)の積をO(log N)で返します。ノードは変更・複製しません。
        assert 0 <= q_left and q_left <= q_right and q_right <= self.length, "区間が範囲外です"
        if q_left == q_right: return self.default
        proc dfs(node: PersistentLazySegmentTreeNode[S, F], l, r: int): S =
            ## 交差する子だけを探索し、区間積に遅延作用を一度反映します。全体でO(log N)。
            if q_left <= l and r <= q_right: return node.value
            let mid = (l + r) shr 1
            if q_right <= mid: result = dfs(node.left, l, mid)
            elif mid <= q_left: result = dfs(node.right, mid, r)
            else: result = self.merge(dfs(node.left, l, mid), dfs(node.right, mid, r))
            if node.pending: result = self.mapping(node.lazy, result)
        dfs(self.root, 0, self.lastnode)

    proc query*[S, F](self: PersistentLazySegmentTree[S, F], l, r: int): S =
        ## 半開区間[l,r)の積をO(log N)で返します。
        self.get(l, r)

    proc get*[S, F](self: PersistentLazySegmentTree[S, F], segment: HSlice[int, int]): S =
        ## スライスの区間積をO(log N)で返します。
        self.get(segment.a, segment.b + 1)

    proc `[]`*[S, F](self: PersistentLazySegmentTree[S, F], segment: HSlice[int, int]): S =
        ## スライスの区間積をO(log N)で返します。
        self.get(segment)

    proc len*[S, F](self: PersistentLazySegmentTree[S, F]): int =
        ## 要素数をO(1)で返します。
        self.length

    proc `[]`*[S, F](self: PersistentLazySegmentTree[S, F], p: Natural): S {.backwardsIndex.} =
        ## pの要素をO(log N)で返します。
        assert p < self.length, "添字が範囲外です"
        self.get(p, p + 1)

    proc `[]=`*[S, F](self: var PersistentLazySegmentTree[S, F], p: Natural, val: S) {.backwardsIndex.} =
        ## 変数を更新後の版へO(log N)で差し替えます。他の変数に保存した版は変化しません。
        self = self.update(p, val)

    proc get_all*[S, F](self: PersistentLazySegmentTree[S, F]): S =
        ## 全要素の積をO(1)で返します。空の場合は単位元です。
        self.root.value

    proc `$`*[S, F](self: PersistentLazySegmentTree[S, F]): string =
        ## 要素を空白区切りで文字列化します。O(N + 出力長)。
        var values: seq[string]
        proc visit(node: PersistentLazySegmentTreeNode[S, F], l, r: int, carry: F) =
            ## 祖先の未伝播作用を反映して葉を列挙します。全体でO(N)。
            if l >= self.length: return
            if r - l == 1:
                values.add($self.mapping(carry, node.value))
                return
            let mid = (l + r) shr 1
            let next = self.composition(carry, node.lazy)
            visit(node.left, l, mid, next)
            visit(node.right, mid, r, next)
        visit(self.root, 0, self.lastnode, self.id)
        values.join(" ")

    template newPersistentLazySegWith*(v_or_n, merge, default, mapping, composition, id: untyped): untyped =
        ## l,rおよびf,xおよびf,gの式を各演算として永続遅延セグ木をO(N)で構築します。
        block:
            type S = typeof(default)
            type F = typeof(id)
            initPersistentLazySegmentTree[S, F](v_or_n,
                proc(l {.inject.}, r {.inject.}: S): S = merge,
                default, proc(f {.inject.}: F, x {.inject.}: S): S = mapping,
                proc(f {.inject.}, g {.inject.}: F): F = composition, id)

    template newLazySegWith*(v_or_n, merge, default, mapping, composition, id: untyped): untyped =
        ## 通常の遅延セグ木と同じ名前の構築テンプレートです。O(N)。
        newPersistentLazySegWith(v_or_n, merge, default, mapping, composition, id)

    proc max_right*[S, F](self: PersistentLazySegmentTree[S, F], l: int,
                          f: proc(l: S): bool): int =
        ## f(get(l,r))を満たす最大のrをO(log N)で返します。ノードは変更・複製しません。
        ## fは区間の拡大に対して単調で、単位元に対してtrueを返す必要があります。
        assert 0 <= l and l <= self.length, "添字が範囲外です"
        assert f(self.default), "判定関数は単位元に対してtrueを返す必要があります"
        var sm = self.default
        proc dfs(node: PersistentLazySegmentTreeNode[S, F], nl, nr: int, carry: F): int =
            ## 祖先の作用を反映し、左から条件を満たす区間を伸ばします。
            if nr <= l or self.length <= nl: return self.length
            if l <= nl and nr <= self.length:
                let value = self.merge(sm, self.mapping(carry, node.value))
                if f(value):
                    sm = value
                    return self.length
                if nr - nl == 1: return nl
            let mid = (nl + nr) shr 1
            let next = self.composition(carry, node.lazy)
            let boundary = dfs(node.left, nl, mid, next)
            if boundary != self.length: return boundary
            dfs(node.right, mid, nr, next)
        dfs(self.root, 0, self.lastnode, self.id)

    proc min_left*[S, F](self: PersistentLazySegmentTree[S, F], r: int,
                         f: proc(l: S): bool): int =
        ## f(get(l,r))を満たす最小のlをO(log N)で返します。ノードは変更・複製しません。
        ## fは区間の拡大に対して単調で、単位元に対してtrueを返す必要があります。
        assert 0 <= r and r <= self.length, "添字が範囲外です"
        assert f(self.default), "判定関数は単位元に対してtrueを返す必要があります"
        var sm = self.default
        proc dfs(node: PersistentLazySegmentTreeNode[S, F], nl, nr: int, carry: F): int =
            ## 祖先の作用を反映し、右から条件を満たす区間を伸ばします。
            if r <= nl: return 0
            if nr <= r:
                let value = self.merge(self.mapping(carry, node.value), sm)
                if f(value):
                    sm = value
                    return 0
                if nr - nl == 1: return nr
            let mid = (nl + nr) shr 1
            let next = self.composition(carry, node.lazy)
            let boundary = dfs(node.right, mid, nr, next)
            if boundary != 0: return boundary
            dfs(node.left, nl, mid, next)
        dfs(self.root, 0, self.lastnode, self.id)
