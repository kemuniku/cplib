when not declared CPLIB_TREE_LAZY_SUBTREE_LINK_CUT_TREE:
    const CPLIB_TREE_LAZY_SUBTREE_LINK_CUT_TREE* = 1
    import sequtils
    import cplib/tree/private/link_cut_tree_base

    type LazySubtreeLinkCutTreeNode[S, F] = object
        left, right, parent: int
        rev: bool
        value, prod, rprod, virtual, all: S
        lazy, cancel: F # 全体への累積作用と、親から受け取り済みの累積作用。
        pathLazy: F # 左右の子だけへ伝播するパスの作用。
        hasPathLazy: bool

    type LazySubtreeLinkCutTree*[S, F] = ref object
        nodes: seq[LazySubtreeLinkCutTreeNode[S, F]]
        stack: seq[int]
        merge: proc(x, y: S): S
        default: S
        mapping: proc(f: F, x: S): S
        composition: proc(f, g: F): F
        id: F
        inverse: proc(x: S): S
        inverseAction: proc(f: F): F

    proc initLazySubtreeLinkCutTree*[S, F](
        v: openArray[S], merge: proc(x, y: S): S, default: S,
        mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F,
        inverse: proc(x: S): S, inverseAction: proc(f: F): F
    ): LazySubtreeLinkCutTree[S, F] =
        ## 頂点の値vを持つ、パス・部分木への遅延更新が可能な森を作る。時間・空間O(N)。
        ## (S, merge, default, inverse)と(F, composition, id, inverseAction)は可換群とする。
        ## mappingはmergeに分配し、mapping(id, x) = x、mapping(f, default) = defaultを満たすこと。
        ## composition(f, g)はgの後にfを作用させる合成。代数的条件は利用者が保証する。
        ## mapping(composition(f, g), x) = mapping(f, mapping(g, x))も満たすこと。
        ## 各演算の計算量はmerge、mapping等がO(1)の場合。頂点数が必要ならSに含める。
        assert inverse != nil and inverseAction != nil
        result = LazySubtreeLinkCutTree[S, F](
            nodes: newSeq[LazySubtreeLinkCutTreeNode[S, F]](v.len + 1),
            merge: merge, default: default, mapping: mapping,
            composition: composition, id: id, inverse: inverse, inverseAction: inverseAction
        )
        for i in 0..v.len:
            let value = if i == 0: default else: v[i - 1]
            result.nodes[i] = LazySubtreeLinkCutTreeNode[S, F](
                value: value, prod: value, rprod: value, virtual: default, all: value,
                lazy: id, cancel: id, pathLazy: id
            )

    proc initLazySubtreeLinkCutTree*[S, F](
        n: int, merge: proc(x, y: S): S, default: S,
        mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F,
        inverse: proc(x: S): S, inverseAction: proc(f: F): F
    ): LazySubtreeLinkCutTree[S, F] =
        ## 全頂点の値がdefaultの森を作る。時間・空間O(N)。頂点数もdefaultのままなので注意。
        assert n >= 0
        initLazySubtreeLinkCutTree(newSeqWith(n, default), merge, default, mapping, composition, id, inverse, inverseAction)

    template newLazySubtreeLinkCutTreeWith*(
        vOrN, merge, default, mapping, composition, id, inverse, inverseAction: untyped
    ): untyped =
        ## mergeはl,r、mappingはf,x、compositionはf,g、inverseはx、inverseActionはfで記述する。
        block:
            type S = typeof(default)
            type F = typeof(id)
            initLazySubtreeLinkCutTree[S, F](
                vOrN, proc(l{.inject.}, r{.inject.}: S): S = merge,
                default, proc(f{.inject.}: F, x{.inject.}: S): S = mapping,
                proc(f{.inject.}, g{.inject.}: F): F = composition,
                id, proc(x{.inject.}: S): S = inverse,
                proc(f{.inject.}: F): F = inverseAction
            )

    proc applyAll[S, F](self: LazySubtreeLinkCutTree[S, F], v: int, f: F) =
        ## 補助木とそのvirtual child全体へ作用させ、累積タグも更新する。O(1)。
        if v == 0: return
        self.nodes[v].value = self.mapping(f, self.nodes[v].value)
        self.nodes[v].prod = self.mapping(f, self.nodes[v].prod)
        self.nodes[v].rprod = self.mapping(f, self.nodes[v].rprod)
        self.nodes[v].virtual = self.mapping(f, self.nodes[v].virtual)
        self.nodes[v].all = self.mapping(f, self.nodes[v].all)
        self.nodes[v].lazy = self.composition(f, self.nodes[v].lazy)

    proc applyPathNode[S, F](self: LazySubtreeLinkCutTree[S, F], v: int, f: F) =
        ## 補助木のパスだけへ作用させ、その差分で全体集約を更新する。O(1)。
        if v == 0: return
        let oldProd = self.nodes[v].prod
        self.nodes[v].value = self.mapping(f, self.nodes[v].value)
        self.nodes[v].prod = self.mapping(f, oldProd)
        self.nodes[v].rprod = self.mapping(f, self.nodes[v].rprod)
        self.nodes[v].all = self.merge(
            self.nodes[v].all, self.merge(self.inverse(oldProd), self.nodes[v].prod)
        )
        if self.nodes[v].hasPathLazy:
            self.nodes[v].pathLazy = self.composition(f, self.nodes[v].pathLazy)
        else:
            self.nodes[v].pathLazy = f
            self.nodes[v].hasPathLazy = true

    proc push[S, F](self: LazySubtreeLinkCutTree[S, F], v: int) =
        ## 親から未反映の作用を受け取り、反転とパスの作用を左右の子へ伝播する。O(1)。
        if v == 0: return
        let p = self.nodes[v].parent
        if p != 0:
            var pending = true
            when compiles(self.nodes[p].lazy == self.nodes[v].cancel):
                pending = not (self.nodes[p].lazy == self.nodes[v].cancel)
            if pending:
                self.applyAll(v, self.composition(self.nodes[p].lazy, self.inverseAction(self.nodes[v].cancel)))
                self.nodes[v].cancel = self.nodes[p].lazy
        if self.nodes[v].rev:
            for child in [self.nodes[v].left, self.nodes[v].right]:
                if child != 0:
                    swap(self.nodes[child].left, self.nodes[child].right)
                    swap(self.nodes[child].prod, self.nodes[child].rprod)
                    self.nodes[child].rev = not self.nodes[child].rev
            self.nodes[v].rev = false
        if self.nodes[v].hasPathLazy:
            self.applyPathNode(self.nodes[v].left, self.nodes[v].pathLazy)
            self.applyPathNode(self.nodes[v].right, self.nodes[v].pathLazy)
            self.nodes[v].pathLazy = self.id
            self.nodes[v].hasPathLazy = false

    proc setParent[S, F](self: LazySubtreeLinkCutTree[S, F], v, parent: int) =
        ## 旧親からの作用を反映し、新親の過去の作用を受け取らないように付け替える。O(1)。
        if v == 0: return
        self.push(v)
        self.nodes[v].parent = parent
        self.nodes[v].cancel = self.nodes[parent].lazy

    proc pull[S, F](self: LazySubtreeLinkCutTree[S, F], v: int) =
        ## 子の未反映タグを処理して、パスと部分木の情報を再計算する。O(1)。
        let l = self.nodes[v].left
        let r = self.nodes[v].right
        self.push(l)
        self.push(r)
        self.nodes[v].prod = self.merge(self.merge(self.nodes[l].prod, self.nodes[v].value), self.nodes[r].prod)
        self.nodes[v].rprod = self.merge(self.merge(self.nodes[r].rprod, self.nodes[v].value), self.nodes[l].rprod)
        self.nodes[v].all = self.merge(
            self.merge(self.nodes[l].all, self.nodes[r].all),
            self.merge(self.nodes[v].value, self.nodes[v].virtual)
        )

    proc addVirtual[S, F](self: LazySubtreeLinkCutTree[S, F], v, child: int) =
        ## preferred pathから外れる子の寄与を、作用を反映して加える。O(1)。
        if child == 0: return
        self.push(child)
        self.nodes[v].virtual = self.merge(self.nodes[v].virtual, self.nodes[child].all)

    proc removeVirtual[S, F](self: LazySubtreeLinkCutTree[S, F], v, child: int) =
        ## preferred pathに入る子の寄与を、作用を反映して取り除く。O(1)。
        if child == 0: return
        self.push(child)
        self.nodes[v].virtual = self.merge(self.nodes[v].virtual, self.inverse(self.nodes[child].all))

    declareLinkCutTreeOperations(LazySubtreeLinkCutTree)

    proc pathApply*[S, F](self: LazySubtreeLinkCutTree[S, F], u, v: int, f: F) =
        ## 同じ木のuからvへのパスへ両端込みでfを作用させる。償却O(log N)。根をuに変更する。
        ## パス外の頂点には作用しない。部分木・成分への更新と混在させられる。
        assert 0 <= u and u < self.len and 0 <= v and v < self.len
        self.makeRoot(u)
        self.accessNode(v + 1)
        self.applyPathNode(v + 1, f)

    proc componentApply*[S, F](self: LazySubtreeLinkCutTree[S, F], v: int, f: F) =
        ## vを含む木全体へfを作用させる。償却O(log N)。
        assert 0 <= v and v < self.len
        self.accessNode(v + 1)
        self.applyAll(v + 1, f)

    proc subtreeApply*[S, F](self: LazySubtreeLinkCutTree[S, F], v, parent: int, f: F) =
        ## 存在する辺(v, parent)のv側へfを作用させる。償却O(log N)。
        ## 根をparentに変更する。作用させた後に接続した頂点へは、この作用を適用しない。
        self.cut(v, parent)
        self.componentApply(v, f)
        self.link(v, parent)
