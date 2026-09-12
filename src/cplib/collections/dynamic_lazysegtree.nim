when not declared CPLIB_COLLECTIONS_DYNAMIC_LAZYSEGTREE:
    const CPLIB_COLLECTIONS_DYNAMIC_LAZYSEGTREE* = 1

    type
        DynamicLazySegmentTreeNode[S, F] = ref object
            a, b, lo, hi, height: int
            value, product: S
            tag, lazy: F
            pending: bool
            left, right: DynamicLazySegmentTreeNode[S, F]
        DynamicLazySegmentTree*[S, F] = ref object
            root: DynamicLazySegmentTreeNode[S, F]
            length, nodes: int
            merge: proc(x, y: S): S
            default: S
            mapping: proc(f: F, x: S): S
            composition: proc(f, g: F): F
            id: F
            initial: proc(l, r: int): S

    proc makeNode[S, F](self: DynamicLazySegmentTree[S, F], a, b: int,
                        tag: F): DynamicLazySegmentTreeNode[S, F] =
        ## 初期区間に作用を適用した1ノードをO(1)で確保します。
        let value = self.mapping(tag, self.initial(a, b))
        inc self.nodes
        DynamicLazySegmentTreeNode[S, F](a: a, b: b, lo: a, hi: b,
            height: 1, value: value, product: value, tag: tag, lazy: self.id)

    proc initDynamicLazySegmentTree*[S, F](n: int, merge: proc(x, y: S): S,
            default: S, mapping: proc(f: F, x: S): S,
            composition: proc(f, g: F): F, id: F,
            initial: proc(l, r: int): S): DynamicLazySegmentTree[S, F] =
        ## [0,n)をO(1)で生成します。initialは初期状態の区間積、composition(f,g)はgの後にfです。
        ## initial(l,r)は、更新を一度も行っていない配列の半開区間[l,r)の集約値を返します。
        ## 例えばS=(sum,size)のゼロ初期化なら(0,r-l)を返します。空区間の単位元(0,0)とは区別します。
        ## 区間分割や区間の一部の取得にも使い、保存済みの作用は木が適用するため、更新を反映させないでください。
        ## initial(l,r)=merge(initial(l,m),initial(m,r))、initial(l,l)=defaultを満たす必要があります。
        ## 記載の計算量はinitialを含む各コールバックがO(1)の場合です。
        assert n >= 0
        result = DynamicLazySegmentTree[S, F](length: n, merge: merge,
            default: default, mapping: mapping, composition: composition,
            id: id, initial: initial)
        if n > 0:
            result.root = result.makeNode(0, n, id)

    proc height[S, F](node: DynamicLazySegmentTreeNode[S, F]): int =
        ## 空の部分木を高さ0としてO(1)で返します。
        if node == nil: 0 else: node.height

    proc pull[S, F](self: DynamicLazySegmentTree[S, F], node: DynamicLazySegmentTreeNode[S, F]) =
        ## 子から区間積・座標範囲・高さをO(1)で再計算します。未伝播の作用は事前に伝播します。
        node.product = node.value
        node.lo = node.a
        node.hi = node.b
        if node.left != nil:
            node.product = self.merge(node.left.product, node.product)
            node.lo = node.left.lo
        if node.right != nil:
            node.product = self.merge(node.product, node.right.product)
            node.hi = node.right.hi
        node.height = max(height(node.left), height(node.right)) + 1

    proc allApply[S, F](self: DynamicLazySegmentTree[S, F],
                        node: DynamicLazySegmentTreeNode[S, F], f: F) =
        ## 部分木全体へO(1)で作用させます。tagは自身の区間の初期状態からの作用です。
        if node == nil: return
        node.value = self.mapping(f, node.value)
        node.product = self.mapping(f, node.product)
        node.tag = self.composition(f, node.tag)
        if node.pending:
            node.lazy = self.composition(f, node.lazy)
        else:
            node.lazy = f
            node.pending = true

    proc push[S, F](self: DynamicLazySegmentTree[S, F], node: DynamicLazySegmentTreeNode[S, F]) =
        ## 子へ遅延作用をO(1)で伝播します。ノードは追加しません。
        if node.pending:
            self.allApply(node.left, node.lazy)
            self.allApply(node.right, node.lazy)
            node.lazy = self.id
            node.pending = false

    proc rotateLeft[S, F](self: DynamicLazySegmentTree[S, F],
                          node: DynamicLazySegmentTreeNode[S, F]): DynamicLazySegmentTreeNode[S, F] =
        ## 遅延作用の対象を保ちながら左回転をO(1)で行います。
        self.push(node)
        result = node.right
        self.push(result)
        node.right = result.left
        result.left = node
        self.pull(node)
        self.pull(result)

    proc rotateRight[S, F](self: DynamicLazySegmentTree[S, F],
                           node: DynamicLazySegmentTreeNode[S, F]): DynamicLazySegmentTreeNode[S, F] =
        ## 遅延作用の対象を保ちながら右回転をO(1)で行います。
        self.push(node)
        result = node.left
        self.push(result)
        node.left = result.right
        result.right = node
        self.pull(node)
        self.pull(result)

    proc balance[S, F](self: DynamicLazySegmentTree[S, F],
                       node: DynamicLazySegmentTreeNode[S, F]): DynamicLazySegmentTreeNode[S, F] =
        ## 1区間の挿入後にAVL木の高さをO(1)で修復します。
        self.pull(node)
        if height(node.left) > height(node.right) + 1:
            if height(node.left.left) < height(node.left.right):
                node.left = self.rotateLeft(node.left)
            return self.rotateRight(node)
        if height(node.right) > height(node.left) + 1:
            if height(node.right.right) < height(node.right.left):
                node.right = self.rotateRight(node.right)
            return self.rotateLeft(node)
        node

    proc insertFirst[S, F](self: DynamicLazySegmentTree[S, F],
            node, added: DynamicLazySegmentTreeNode[S, F]): DynamicLazySegmentTreeNode[S, F] =
        ## 部分木の全区間より前にある区間をO(log K)で挿入します。
        if node == nil: return added
        self.push(node)
        node.left = self.insertFirst(node.left, added)
        self.balance(node)

    proc splitAt[S, F](self: DynamicLazySegmentTree[S, F],
            node: DynamicLazySegmentTreeNode[S, F], p: int): DynamicLazySegmentTreeNode[S, F] =
        ## 座標pに境界をO(log K)で作ります。既存境界なら追加せず、新規なら1ノード増えます。
        if node == nil or p == node.a or p == node.b: return node
        self.push(node)
        if p < node.a:
            node.left = self.splitAt(node.left, p)
        elif node.b < p:
            node.right = self.splitAt(node.right, p)
        else:
            let added = self.makeNode(p, node.b, node.tag)
            node.b = p
            node.value = self.mapping(node.tag, self.initial(node.a, p))
            node.right = self.insertFirst(node.right, added)
        self.balance(node)

    proc applyNode[S, F](self: DynamicLazySegmentTree[S, F],
            node: DynamicLazySegmentTreeNode[S, F], l, r: int, f: F) =
        ## 境界で分割済みの区間へO(log K)で作用させます。
        if node == nil or r <= node.lo or node.hi <= l: return
        if l <= node.lo and node.hi <= r:
            self.allApply(node, f)
            return
        self.push(node)
        self.applyNode(node.left, l, r, f)
        if l <= node.a and node.b <= r:
            node.value = self.mapping(f, node.value)
            node.tag = self.composition(f, node.tag)
        self.applyNode(node.right, l, r, f)
        self.pull(node)

    proc apply*[S, F](self: DynamicLazySegmentTree[S, F], l, r: int, f: F) =
        ## [l,r)へ最悪O(log(K+2))で作用させます。追加ノードは高々2個、Q回更新後の空間はO(Q+1)。
        assert 0 <= l and l <= r and r <= self.length
        if l == r: return
        self.root = self.splitAt(self.root, l)
        self.root = self.splitAt(self.root, r)
        self.applyNode(self.root, l, r, f)

    proc getNode[S, F](self: DynamicLazySegmentTree[S, F],
            node: DynamicLazySegmentTreeNode[S, F], l, r: int): S =
        ## 区間を分割せずに区間積をO(log K)で返します。
        if node == nil or r <= node.lo or node.hi <= l: return self.default
        if l <= node.lo and node.hi <= r: return node.product
        self.push(node)
        result = self.getNode(node.left, l, r)
        let a = max(l, node.a)
        let b = min(r, node.b)
        if a < b:
            let value = if a == node.a and b == node.b: node.value
                        else: self.mapping(node.tag, self.initial(a, b))
            result = self.merge(result, value)
        result = self.merge(result, self.getNode(node.right, l, r))

    proc get*[S, F](self: DynamicLazySegmentTree[S, F], l, r: int): S =
        ## 半開区間[l,r)の積を最悪O(log(K+2))で返します。取得ではノードを追加しません。
        assert 0 <= l and l <= r and r <= self.length
        if l == r: return self.default
        self.getNode(self.root, l, r)

    proc setNode[S, F](self: DynamicLazySegmentTree[S, F],
            node: DynamicLazySegmentTreeNode[S, F], p: int, value: S) =
        ## 長さ1に分割済みの区間をO(log K)で上書きします。
        self.push(node)
        if p < node.a:
            self.setNode(node.left, p, value)
        elif p >= node.b:
            self.setNode(node.right, p, value)
        else:
            node.value = value
            node.tag = self.id
        self.pull(node)

    proc update*[S, F](self: DynamicLazySegmentTree[S, F], p: Natural, value: S) =
        ## 1点を最悪O(log(K+2))で上書きします。追加ノードは高々2個です。
        assert p < self.length
        self.root = self.splitAt(self.root, p)
        self.root = self.splitAt(self.root, p + 1)
        self.setNode(self.root, p, value)

    proc get*[S, F](self: DynamicLazySegmentTree[S, F], segment: HSlice[int, int]): S =
        ## スライスの区間積を最悪O(log(K+2))で返します。
        assert segment.b < self.length
        self.get(segment.a, segment.b + 1)

    proc apply*[S, F](self: DynamicLazySegmentTree[S, F], segment: HSlice[int, int], f: F) =
        ## スライスの区間へ最悪O(log(K+2))で作用させます。
        assert segment.b < self.length
        self.apply(segment.a, segment.b + 1, f)

    proc `[]`*[S, F](self: DynamicLazySegmentTree[S, F], segment: HSlice[int, int]): S =
        ## スライスの区間積を最悪O(log(K+2))で返します。
        self.get(segment)

    proc `[]`*[S, F](self: DynamicLazySegmentTree[S, F], p: Natural): S =
        ## 1点を最悪O(log(K+2))で取得します。
        assert p < self.length
        self.get(p, p + 1)

    proc `[]=`*[S, F](self: DynamicLazySegmentTree[S, F], p: Natural, value: S) =
        ## 1点を最悪O(log(K+2))で上書きします。
        self.update(p, value)

    proc get_all*[S, F](self: DynamicLazySegmentTree[S, F]): S =
        ## 全区間の積をO(1)で返します。
        if self.root == nil: self.default else: self.root.product

    proc len*[S, F](self: DynamicLazySegmentTree[S, F]): int =
        ## 座標範囲の長さをO(1)で返します。
        self.length

    proc node_count*[S, F](self: DynamicLazySegmentTree[S, F]): int =
        ## 保持する区間数K（確保したノード数）をO(1)で返します。
        self.nodes

    template newDynamicLazySegWith*(n, merge, default, mapping, composition, id, initial: untyped): untyped =
        ## 演算を式で指定してO(1)で生成します。initialのl,rは初期区間の両端です。
        initDynamicLazySegmentTree[typeof(default), typeof(id)](n,
            proc(l {.inject.}, r {.inject.}: typeof(default)): typeof(default) = merge,
            default,
            proc(f {.inject.}: typeof(id), x {.inject.}: typeof(default)): typeof(default) = mapping,
            proc(f {.inject.}, g {.inject.}: typeof(id)): typeof(id) = composition,
            id, proc(l {.inject.}, r {.inject.}: int): typeof(default) = initial)
