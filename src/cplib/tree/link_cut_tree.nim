when not declared CPLIB_TREE_LINK_CUT_TREE:
    const CPLIB_TREE_LINK_CUT_TREE* = 1
    import sequtils
    import cplib/tree/private/link_cut_tree_base

    type LinkCutTreeNode[S] = object
        left, right, parent: int
        rev: bool
        value, prod, rprod, virtual, all: S

    type LinkCutTree*[S] = ref object
        nodes: seq[LinkCutTreeNode[S]]
        stack: seq[int]
        merge: proc(x, y: S): S
        default: S
        inverse: proc(x: S): S

    proc initLinkCutTree*[S](
        v: openArray[S], merge: proc(x, y: S): S, default: S,
        inverse: proc(x: S): S = nil
    ): LinkCutTree[S] =
        ## 頂点の値vを持つ、辺のない森を作る。時間・空間O(N)。
        ## mergeとdefaultはモノイドをなすこと。パスは非可換でもよい。
        ## 部分木・成分を集約する場合はinverseも渡し、可換群であることを利用者が保証する。
        ## inverseを省略すると部分木情報を更新しない。各演算の計算量はmerge等がO(1)の場合。
        result = LinkCutTree[S](
            nodes: newSeq[LinkCutTreeNode[S]](v.len + 1),
            merge: merge, default: default, inverse: inverse
        )
        for i in 0..v.len:
            let value = if i == 0: default else: v[i - 1]
            result.nodes[i] = LinkCutTreeNode[S](
                value: value, prod: value, rprod: value, virtual: default, all: value
            )

    proc initLinkCutTree*[S](
        n: int, merge: proc(x, y: S): S, default: S,
        inverse: proc(x: S): S = nil
    ): LinkCutTree[S] =
        ## 全頂点の値がdefaultの、辺のない森を作る。時間・空間O(N)。
        assert n >= 0
        initLinkCutTree(newSeqWith(n, default), merge, default, inverse)

    template newLinkCutTreeWith*(vOrN, merge, default: untyped): untyped =
        ## l, rを使った式から、パス集約用のLinkCutTreeを作る。
        initLinkCutTree[typeof(default)](
            vOrN, proc(l{.inject.}, r{.inject.}: typeof(default)): typeof(default) = merge,
            default
        )

    template newLinkCutTreeWith*(vOrN, merge, default, inverse: untyped): untyped =
        ## mergeにはl, r、inverseにはxを使った式を渡す。部分木集約には可換群が必要。
        initLinkCutTree[typeof(default)](
            vOrN, proc(l{.inject.}, r{.inject.}: typeof(default)): typeof(default) = merge,
            default, proc(x{.inject.}: typeof(default)): typeof(default) = inverse
        )

    proc push[S](self: LinkCutTree[S], v: int) =
        ## 反転を左右の子へ伝播する。O(1)。
        if v == 0 or not self.nodes[v].rev: return
        for child in [self.nodes[v].left, self.nodes[v].right]:
            if child != 0:
                swap(self.nodes[child].left, self.nodes[child].right)
                swap(self.nodes[child].prod, self.nodes[child].rprod)
                self.nodes[child].rev = not self.nodes[child].rev
        self.nodes[v].rev = false

    proc setParent[S](self: LinkCutTree[S], v, parent: int) =
        ## vの補助木上の親またはpath-parentを変更する。O(1)。
        if v != 0: self.nodes[v].parent = parent

    proc pull[S](self: LinkCutTree[S], v: int) =
        ## 左右の子と頂点値からパスと部分木の情報を再計算する。O(1)。
        let l = self.nodes[v].left
        let r = self.nodes[v].right
        self.nodes[v].prod = self.merge(self.merge(self.nodes[l].prod, self.nodes[v].value), self.nodes[r].prod)
        self.nodes[v].rprod = self.merge(self.merge(self.nodes[r].rprod, self.nodes[v].value), self.nodes[l].rprod)
        if self.inverse != nil:
            self.nodes[v].all = self.merge(
                self.merge(self.nodes[l].all, self.nodes[r].all),
                self.merge(self.nodes[v].value, self.nodes[v].virtual)
            )

    proc addVirtual[S](self: LinkCutTree[S], v, child: int) =
        ## preferred pathから外れる子の寄与を加える。O(1)。
        if self.inverse != nil and child != 0:
            self.nodes[v].virtual = self.merge(self.nodes[v].virtual, self.nodes[child].all)

    proc removeVirtual[S](self: LinkCutTree[S], v, child: int) =
        ## preferred pathに入る子の寄与を取り除く。O(1)。
        if self.inverse != nil and child != 0:
            self.nodes[v].virtual = self.merge(self.nodes[v].virtual, self.inverse(self.nodes[child].all))

    declareLinkCutTreeOperations(LinkCutTree)
