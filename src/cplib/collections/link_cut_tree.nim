when not declared CPLIB_COLLECTIONS_LINK_CUT_TREE:
    const CPLIB_COLLECTIONS_LINK_CUT_TREE* = 1

    type
        LinkCutTreeNode[T] = ref object
            left, right, parent: LinkCutTreeNode[T]
            index: int
            rev: bool
            value, prod, rprod: T

        LinkCutTree*[T] = object
            nodes: seq[LinkCutTreeNode[T]]
            op: proc(x, y: T): T
            e: T

    proc isRoot[T](x: LinkCutTreeNode[T]): bool {.inline.} =
        x.parent.isNil or (x.parent.left != x and x.parent.right != x)

    proc toggle[T](x: LinkCutTreeNode[T]) {.inline.} =
        if x.isNil: return
        swap(x.left, x.right)
        swap(x.prod, x.rprod)
        x.rev = not x.rev

    proc push[T](x: LinkCutTreeNode[T]) {.inline.} =
        if x.rev:
            x.left.toggle
            x.right.toggle
            x.rev = false

    proc pull[T](self: LinkCutTree[T], x: LinkCutTreeNode[T]) {.inline.} =
        let lp = if x.left.isNil: self.e else: x.left.prod
        let rp = if x.right.isNil: self.e else: x.right.prod
        let lrp = if x.left.isNil: self.e else: x.left.rprod
        let rrp = if x.right.isNil: self.e else: x.right.rprod
        x.prod = self.op(self.op(lp, x.value), rp)
        x.rprod = self.op(self.op(rrp, x.value), lrp)

    proc rotate[T](self: LinkCutTree[T], x: LinkCutTreeNode[T]) =
        let p = x.parent
        let g = p.parent
        if p.left == x:
            p.left = x.right
            if not x.right.isNil: x.right.parent = p
            x.right = p
        else:
            p.right = x.left
            if not x.left.isNil: x.left.parent = p
            x.left = p
        p.parent = x
        x.parent = g
        if not g.isNil:
            if g.left == p: g.left = x
            elif g.right == p: g.right = x
        self.pull(p)
        self.pull(x)

    proc splay[T](self: LinkCutTree[T], x: LinkCutTreeNode[T]) =
        var path: seq[LinkCutTreeNode[T]]
        var y = x
        path.add(y)
        while not y.isRoot:
            y = y.parent
            path.add(y)
        for i in countdown(path.high, 0): path[i].push
        while not x.isRoot:
            let p = x.parent
            if not p.isRoot:
                if (p.left == x) == (p.parent.left == p): self.rotate(p)
                else: self.rotate(x)
            self.rotate(x)

    proc accessNode[T](self: LinkCutTree[T], x: LinkCutTreeNode[T]): LinkCutTreeNode[T] =
        var last: LinkCutTreeNode[T] = nil
        var y = x
        while not y.isNil:
            self.splay(y)
            y.right = last
            self.pull(y)
            last = y
            y = y.parent
        self.splay(x)
        result = last

    proc initLinkCutTree*[T](values: openArray[T], op: proc(x, y: T): T,
                             e: T): LinkCutTree[T] =
        ## `values`を頂点値とする、辺を持たないLink-Cut Treeを作ります。
        ## `op`は結合的で、`e`はその単位元である必要があります。
        result.op = op
        result.e = e
        result.nodes = newSeq[LinkCutTreeNode[T]](values.len)
        for i, value in values:
            result.nodes[i] = LinkCutTreeNode[T](index: i, value: value, prod: value, rprod: value)

    template newLinkCutTreeWith*(values, op, e: untyped): untyped =
        initLinkCutTree[typeof(e)](values,
            proc(l{.inject.}, r{.inject.}: typeof(e)): typeof(e) = op, e)

    proc len*[T](self: LinkCutTree[T]): int {.inline.} = self.nodes.len

    proc checkVertex[T](self: LinkCutTree[T], v: int) {.inline.} =
        assert 0 <= v and v < self.len

    proc access*[T](self: LinkCutTree[T], v: int) =
        ## vから現在の根までのパスをpreferred pathにします。
        self.checkVertex(v)
        discard self.accessNode(self.nodes[v])

    proc makeRoot*[T](self: LinkCutTree[T], v: int) =
        ## vを、それが属する木の根にします。償却O(log N)です。
        self.checkVertex(v)
        discard self.accessNode(self.nodes[v])
        self.nodes[v].toggle

    proc evert*[T](self: LinkCutTree[T], v: int) {.inline.} = self.makeRoot(v)

    proc root*[T](self: LinkCutTree[T], v: int): int =
        ## vが属する木の現在の根を返します。
        self.checkVertex(v)
        var x = self.nodes[v]
        discard self.accessNode(x)
        x.push
        while not x.left.isNil:
            x = x.left
            x.push
        self.splay(x)
        result = x.index

    proc connected*[T](self: LinkCutTree[T], u, v: int): bool =
        ## uとvが同じ木に属するかを返します。償却O(log N)です。
        self.checkVertex(u)
        self.checkVertex(v)
        if u == v: return true
        result = self.root(u) == self.root(v)

    proc link*[T](self: LinkCutTree[T], u, v: int): bool {.discardable.} =
        ## 異なる木に属するuとvの間に辺を張ります。既に連結ならfalseです。
        self.checkVertex(u)
        self.checkVertex(v)
        self.makeRoot(u)
        if self.root(v) == u: return false
        self.nodes[u].parent = self.nodes[v]
        result = true

    proc cut*[T](self: LinkCutTree[T], u, v: int): bool {.discardable.} =
        ## u-vが辺なら削除します。辺でなければfalseです。
        self.checkVertex(u)
        self.checkVertex(v)
        self.makeRoot(u)
        discard self.accessNode(self.nodes[v])
        let x = self.nodes[u]
        let y = self.nodes[v]
        if y.left != x or not x.right.isNil: return false
        y.left = nil
        x.parent = nil
        self.pull(y)
        result = true

    proc fold*[T](self: LinkCutTree[T], u, v: int): T =
        ## uからvまで（両端を含む）の頂点値の積を返します。
        ## uとvは連結でなければなりません。償却O(log N)です。
        self.checkVertex(u)
        self.checkVertex(v)
        self.makeRoot(u)
        assert self.root(v) == u, "fold endpoints must be connected"
        discard self.accessNode(self.nodes[v])
        result = self.nodes[v].prod

    proc pathProd*[T](self: LinkCutTree[T], u, v: int): T {.inline.} =
        self.fold(u, v)

    proc `[]`*[T](self: LinkCutTree[T], v: int): T =
        self.checkVertex(v)
        discard self.accessNode(self.nodes[v])
        result = self.nodes[v].value

    proc `[]=`*[T](self: LinkCutTree[T], v: int, value: T) =
        ## 頂点vの値をvalueに更新します。償却O(log N)です。
        self.checkVertex(v)
        let x = self.nodes[v]
        discard self.accessNode(x)
        x.value = value
        self.pull(x)

    proc update*[T](self: LinkCutTree[T], v: int, value: T) {.inline.} =
        self[v] = value
