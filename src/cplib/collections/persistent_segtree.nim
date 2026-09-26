when not declared CPLIB_COLLECTIONS_PERSISTENT_SEGTREE:
    const CPLIB_COLLECTIONS_PERSISTENT_SEGTREE* = 1
    import cplib/utils/backwards_index
    import strutils

    type
        SegmentTreeNode*[T] = ref object
            value: T
            left, right: SegmentTreeNode[T]
        PSegmentTree*[T] = ref object
            root: SegmentTreeNode[T]
            lastnode, length: int
            op: proc(l, r: T): T
            e: T
        PersistentSegmentTree*[T] = PSegmentTree[T]

    proc initPersistentSegmentTree*[T](v: openArray[T], merge: proc(l, r: T): T,
                                       default: T): PSegmentTree[T] =
        ## vから永続セグ木をO(N)で構築します。mergeは結合的で、defaultは単位元です。
        ## 各演算はO(1)とし、引数や共有する参照先を変更しないでください。
        let values = @v
        var size = 1
        while size < v.len: size *= 2
        proc build(l, r: int): SegmentTreeNode[T] =
            ## 区間[l,r)の部分木をO(r-l)で構築します。
            if r - l == 1:
                return SegmentTreeNode[T](value: (if l < values.len: values[l] else: default))
            let mid = (l + r) shr 1
            let left = build(l, mid)
            let right = build(mid, r)
            SegmentTreeNode[T](value: merge(left.value, right.value), left: left, right: right)
        PSegmentTree[T](root: build(0, size), lastnode: size, length: v.len, op: merge, e: default)

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
        proc dfs(node: SegmentTreeNode[T], l, r: int): SegmentTreeNode[T] =
            ## 更新経路のみを複製します。O(log N)。
            if r - l == 1: return SegmentTreeNode[T](value: value)
            let mid = (l + r) shr 1
            var left = node.left
            var right = node.right
            if idx < mid: left = dfs(left, l, mid)
            else: right = dfs(right, mid, r)
            SegmentTreeNode[T](value: st.op(left.value, right.value), left: left, right: right)
        PSegmentTree[T](root: dfs(st.root, 0, st.lastnode), lastnode: st.lastnode,
                        length: st.length, op: st.op, e: st.e)

    proc get*[T](self: PSegmentTree[T], q_left, q_right: int): T =
        ## 半開区間[q_left,q_right)の積をO(log N)で返します。
        assert 0 <= q_left and q_left <= q_right and q_right <= self.length, "区間が範囲外です"
        if q_left == q_right: return self.e
        proc dfs(node: SegmentTreeNode[T], l, r: int): T =
            ## 指定区間との共通部分の積を取得します。全体でO(log N)。
            if q_right <= l or r <= q_left: return self.e
            if q_left <= l and r <= q_right: return node.value
            let mid = (l + r) shr 1
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
        self.get(index, index + 1)

    proc `[]=`*[T](self: var PSegmentTree[T], index: Natural, val: T) {.backwardsIndex.} =
        ## 変数を更新後の版へO(log N)で差し替えます。他の変数に保存した版は変化しません。
        self = self.update(index, val)

    proc get_all*[T](self: PSegmentTree[T]): T =
        ## 全要素の積をO(1)で返します。空の場合は単位元です。
        self.root.value

    proc `$`*[T](self: PSegmentTree[T]): string =
        ## 要素を空白区切りで文字列化します。O(N + 出力長)。
        var values: seq[string]
        proc visit(node: SegmentTreeNode[T], l, r: int) =
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
        proc dfs(node: SegmentTreeNode[T], nl, nr: int): int =
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
        proc dfs(node: SegmentTreeNode[T], nl, nr: int): int =
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
