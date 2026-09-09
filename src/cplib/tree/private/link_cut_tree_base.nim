when not declared CPLIB_TREE_PRIVATE_LINK_CUT_TREE_BASE:
    const CPLIB_TREE_PRIVATE_LINK_CUT_TREE_BASE* = 1

    template declareLinkCutTreeOperations*(TreeType: untyped) {.dirty.} =
        ## 集約・遅延情報の更新を各型に任せ、共通のLCT操作を定義する。
        proc isAuxRoot[T: TreeType](self: T, v: int): bool {.inline.} =
            ## vが補助splay木の根かを返す。O(1)。
            let p = self.nodes[v].parent
            p == 0 or (self.nodes[p].left != v and self.nodes[p].right != v)

        proc toggle[T: TreeType](self: T, v: int) =
            ## 補助splay木のパスの向きを反転する。O(1)。
            if v == 0: return
            swap(self.nodes[v].left, self.nodes[v].right)
            swap(self.nodes[v].prod, self.nodes[v].rprod)
            self.nodes[v].rev = not self.nodes[v].rev

        proc rotate[T: TreeType](self: T, v: int) =
            ## vを親の位置へ回転し、集約と親に依存する情報を更新する。O(1)。
            let p = self.nodes[v].parent
            let g = self.nodes[p].parent
            let right = self.nodes[p].right == v
            let middle = if right: self.nodes[v].left else: self.nodes[v].right
            if not self.isAuxRoot(p):
                if self.nodes[g].left == p:
                    self.nodes[g].left = v
                else:
                    self.nodes[g].right = v
            self.setParent(middle, p)
            self.setParent(v, g)
            self.setParent(p, v)
            if right:
                self.nodes[p].right = middle
                self.nodes[v].left = p
            else:
                self.nodes[p].left = middle
                self.nodes[v].right = p
            self.pull(p)
            self.pull(v)

        proc splay[T: TreeType](self: T, v: int) =
            ## vを補助splay木の根へ移動する。償却O(log N)。
            self.stack.setLen(0)
            var x = v
            self.stack.add(x)
            while not self.isAuxRoot(x):
                x = self.nodes[x].parent
                self.stack.add(x)
            for i in countdown(self.stack.len - 1, 0):
                self.push(self.stack[i])
            while not self.isAuxRoot(v):
                let p = self.nodes[v].parent
                let g = self.nodes[p].parent
                if not self.isAuxRoot(p):
                    if (self.nodes[p].left == v) == (self.nodes[g].left == p):
                        self.rotate(p)
                    else:
                        self.rotate(v)
                self.rotate(v)

        proc accessNode[T: TreeType](self: T, v: int) =
            ## 根からvまでをpreferred pathにし、vを補助木の根にする。償却O(log N)。
            var last = 0
            var x = v
            while x != 0:
                self.splay(x)
                self.addVirtual(x, self.nodes[x].right)
                self.removeVirtual(x, last)
                self.nodes[x].right = last
                self.pull(x)
                last = x
                x = self.nodes[x].parent
            self.splay(v)

        proc len*[T: TreeType](self: T): int =
            ## 頂点数を返す。O(1)。
            self.nodes.len - 1

        proc makeRoot*[T: TreeType](self: T, v: int) =
            ## vを所属する木の根にする。償却O(log N)。
            assert 0 <= v and v < self.len
            self.accessNode(v + 1)
            self.toggle(v + 1)

        proc findRoot*[T: TreeType](self: T, v: int): int =
            ## vが所属する木の現在の根を返す。償却O(log N)。
            assert 0 <= v and v < self.len
            var x = v + 1
            self.accessNode(x)
            self.push(x)
            while self.nodes[x].left != 0:
                x = self.nodes[x].left
                self.push(x)
            self.splay(x)
            x - 1

        proc connected*[T: TreeType](self: T, u, v: int): bool =
            ## uとvが同じ木に属するかを返す。償却O(log N)。
            assert 0 <= u and u < self.len and 0 <= v and v < self.len
            u == v or self.findRoot(u) == self.findRoot(v)

        proc link*[T: TreeType](self: T, u, v: int) =
            ## 異なる木の頂点u, vを辺で結ぶ。償却O(log N)。
            ## 結合後の根は結合前のv側の根になる。
            assert 0 <= u and u < self.len and 0 <= v and v < self.len
            self.makeRoot(u)
            assert self.findRoot(v) != u, "linkする頂点は異なる木に属する必要があります"
            self.accessNode(v + 1)
            self.setParent(u + 1, v + 1)
            self.addVirtual(v + 1, u + 1)
            self.pull(v + 1)

        proc cut*[T: TreeType](self: T, u, v: int) =
            ## 存在する辺(u, v)を削除する。償却O(log N)。
            ## 切断後の二つの木の根はそれぞれuとvになる。
            assert 0 <= u and u < self.len and 0 <= v and v < self.len
            self.makeRoot(u)
            self.accessNode(v + 1)
            self.push(u + 1)
            assert self.nodes[v + 1].left == u + 1 and self.nodes[u + 1].right == 0,
                "cutする辺が存在する必要があります"
            self.setParent(u + 1, 0)
            self.nodes[v + 1].left = 0
            self.pull(v + 1)

        proc update*[T: TreeType](self: T, v: int, value: T.S) =
            ## 頂点vの値をvalueに変更する。償却O(log N)。
            assert 0 <= v and v < self.len
            self.accessNode(v + 1)
            self.nodes[v + 1].value = value
            self.pull(v + 1)

        proc `[]`*[T: TreeType](self: T, v: int): T.S =
            ## 頂点vの値を返す。償却O(log N)。
            assert 0 <= v and v < self.len
            self.accessNode(v + 1)
            self.nodes[v + 1].value

        proc `[]=`*[T: TreeType](self: T, v: int, value: T.S) =
            ## 頂点vの値をvalueに変更する。償却O(log N)。
            self.update(v, value)

        proc pathProd*[T: TreeType](self: T, u, v: int): T.S =
            ## 同じ木のuからvへのパスを両端込みで順に集約する。償却O(log N)。根をuに変更する。
            assert 0 <= u and u < self.len and 0 <= v and v < self.len
            self.makeRoot(u)
            self.accessNode(v + 1)
            self.nodes[v + 1].prod

        proc get*[T: TreeType](self: T, u, v: int): T.S =
            ## 同じ木のuからvへのパスの集約を返す。pathProdと同じ。償却O(log N)。
            self.pathProd(u, v)

        proc componentProd*[T: TreeType](self: T, v: int): T.S =
            ## vを含む木全体を集約する。可換群と逆元の指定が必要。償却O(log N)。
            assert 0 <= v and v < self.len
            assert self.inverse != nil, "部分木・成分の集約にはinverseが必要です"
            self.accessNode(v + 1)
            self.nodes[v + 1].all

        proc subtreeProd*[T: TreeType](self: T, v, parent: int): T.S =
            ## 辺(v, parent)のv側を集約する。可換群と逆元の指定が必要。償却O(log N)。根をparentに変更する。
            assert 0 <= v and v < self.len and 0 <= parent and parent < self.len
            assert self.inverse != nil, "部分木・成分の集約にはinverseが必要です"
            self.makeRoot(parent)
            self.accessNode(v + 1)
            self.push(parent + 1)
            assert self.nodes[v + 1].left == parent + 1 and self.nodes[parent + 1].right == 0,
                "parentはvの隣接頂点である必要があります"
            self.merge(self.nodes[v + 1].value, self.nodes[v + 1].virtual)
