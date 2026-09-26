when not declared CPLIB_COLLECTIONS_PERSISTENT_LAZYSEGTREE:
    const CPLIB_COLLECTIONS_PERSISTENT_LAZYSEGTREE* = 1
    import cplib/utils/backwards_index
    import strutils

    type
        PersistentLazySegmentTreeNode[S, F] = ref object
            value: S
            lazy: F
            pending: bool
            left, right: PersistentLazySegmentTreeNode[S, F]
        PersistentLazySegmentTree*[S, F] = ref object
            root: PersistentLazySegmentTreeNode[S, F]
            lastnode, length: int
            merge: proc(l, r: S): S
            default: S
            mapping: proc(f: F, x: S): S
            composition: proc(f, g: F): F
            id: F
        PLazySegmentTree*[S, F] = PersistentLazySegmentTree[S, F]

    proc initPersistentLazySegmentTree*[S, F](v: openArray[S], merge: proc(l, r: S): S,
            default: S, mapping: proc(f: F, x: S): S,
            composition: proc(f, g: F): F, id: F): PersistentLazySegmentTree[S, F] =
        ## vから永続遅延セグ木をO(N)で構築します。composition(f,g)はgの後にfを作用させます。
        ## mergeは結合的でdefaultは単位元、mappingはmergeと両立し、idは恒等作用とします。
        ## 各演算はO(1)とし、引数や共有する参照先を変更しないでください。
        let values = @v
        var size = 1
        while size < v.len: size *= 2
        proc build(l, r: int): PersistentLazySegmentTreeNode[S, F] =
            ## 区間[l,r)の部分木をO(r-l)で構築します。
            if r - l == 1:
                return PersistentLazySegmentTreeNode[S, F](
                    value: (if l < values.len: values[l] else: default), lazy: id)
            let mid = (l + r) shr 1
            let left = build(l, mid)
            let right = build(mid, r)
            PersistentLazySegmentTreeNode[S, F](value: merge(left.value, right.value),
                lazy: id, left: left, right: right)
        PersistentLazySegmentTree[S, F](root: build(0, size), lastnode: size, length: v.len,
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
        PersistentLazySegmentTree[S, F](root: root, lastnode: self.lastnode, length: self.length,
            merge: self.merge, default: self.default, mapping: self.mapping,
            composition: self.composition, id: self.id)

    proc applied[S, F](self: PersistentLazySegmentTree[S, F],
            node: PersistentLazySegmentTreeNode[S, F], f: F): PersistentLazySegmentTreeNode[S, F] =
        ## ノードを複製して作用を適用します。時間・追加領域O(1)。
        result = PersistentLazySegmentTreeNode[S, F](value: self.mapping(f, node.value),
            lazy: self.id, left: node.left, right: node.right)
        if node.left != nil:
            result.lazy = self.composition(f, node.lazy)
            result.pending = true

    proc children[S, F](self: PersistentLazySegmentTree[S, F],
            node: PersistentLazySegmentTreeNode[S, F]): tuple[left, right: PersistentLazySegmentTreeNode[S, F]] =
        ## 遅延作用を反映した子を取得します。伝播時のみ複製し、時間・追加領域O(1)。
        if node.pending:
            (self.applied(node.left, node.lazy), self.applied(node.right, node.lazy))
        else:
            (node.left, node.right)

    proc update*[S, F](self: PersistentLazySegmentTree[S, F], p: Natural,
                        val: S): PersistentLazySegmentTree[S, F] =
        ## pをvalに置き換えた新しい版を、時間・追加領域O(log N)で返します。
        assert p < self.length, "添字が範囲外です"
        proc dfs(node: PersistentLazySegmentTreeNode[S, F], l, r: int): PersistentLazySegmentTreeNode[S, F] =
            ## 更新経路を複製し、遅延作用を反映して一点を置き換えます。O(log N)。
            if r - l == 1: return PersistentLazySegmentTreeNode[S, F](value: val, lazy: self.id)
            let mid = (l + r) shr 1
            var (left, right) = self.children(node)
            if p < mid: left = dfs(left, l, mid)
            else: right = dfs(right, mid, r)
            PersistentLazySegmentTreeNode[S, F](value: self.merge(left.value, right.value),
                lazy: self.id, left: left, right: right)
        self.withRoot(dfs(self.root, 0, self.lastnode))

    proc apply*[S, F](self: PersistentLazySegmentTree[S, F], q_left, q_right: int,
                       f: F): PersistentLazySegmentTree[S, F] =
        ## 半開区間[q_left,q_right)にfを作用させた新しい版を、時間・追加領域O(log N)で返します。
        assert 0 <= q_left and q_left <= q_right and q_right <= self.length, "区間が範囲外です"
        if q_left == q_right: return self
        proc dfs(node: PersistentLazySegmentTreeNode[S, F], l, r: int): PersistentLazySegmentTreeNode[S, F] =
            ## 更新範囲と交差するノードを複製します。全体でO(log N)。
            if q_right <= l or r <= q_left: return node
            if q_left <= l and r <= q_right: return self.applied(node, f)
            let mid = (l + r) shr 1
            let children = self.children(node)
            let left = dfs(children.left, l, mid)
            let right = dfs(children.right, mid, r)
            PersistentLazySegmentTreeNode[S, F](value: self.merge(left.value, right.value),
                lazy: self.id, left: left, right: right)
        self.withRoot(dfs(self.root, 0, self.lastnode))

    proc apply*[S, F](self: PersistentLazySegmentTree[S, F], segment: HSlice[int, int],
                       f: F): PersistentLazySegmentTree[S, F] =
        ## スライスにfを作用させた新しい版を、時間・追加領域O(log N)で返します。
        self.apply(segment.a, segment.b + 1, f)

    proc get*[S, F](self: PersistentLazySegmentTree[S, F], q_left, q_right: int): S =
        ## 半開区間[q_left,q_right)の積をO(log N)で返します。ノードは変更・複製しません。
        assert 0 <= q_left and q_left <= q_right and q_right <= self.length, "区間が範囲外です"
        if q_left == q_right: return self.default
        proc dfs(node: PersistentLazySegmentTreeNode[S, F], l, r: int, carry: F): S =
            ## 祖先の未伝播作用を引き継いで区間積を取得します。全体でO(log N)。
            if q_right <= l or r <= q_left: return self.default
            if q_left <= l and r <= q_right: return self.mapping(carry, node.value)
            let mid = (l + r) shr 1
            let next = self.composition(carry, node.lazy)
            self.merge(dfs(node.left, l, mid, next), dfs(node.right, mid, r, next))
        dfs(self.root, 0, self.lastnode, self.id)

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
