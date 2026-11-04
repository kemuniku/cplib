when not declared CPLIB_TREE_EULER_TOUR_TREE:
    const CPLIB_TREE_EULER_TOUR_TREE* = 1
    import tables

    type
        ETTNode[S] = object
            child: array[2, int]
            parent, size: int
            value, prod: S
        EulerTourTree*[S] = ref object
            ## 固定頂点集合0..<N上の動的な単純無向森。代入した参照は同じ森を共有する。
            ## 頂点ごとに一つのノード、木辺ごとに単位元を持つ往復ノードを置く。
            ## 可換モノイドで成分を集約する。逆元は不要。パス・部分木集約は扱わない。
            ## mergeは純粋な結合的・可換な演算、defaultはその単位元であること。
            ## Sは値型または不変値とし、参照先やmergeの閉包を外から変更しないこと。
            ## 0 <= N <= (int.high - 1) div 3。頂点番号の検査にはassertを用いる。
            ## 以下の計算量はSのコピー・merge・単位元の生成がO(1)の場合。
            ## splay木の列操作は償却O(log N)、辺のハッシュ検索は期待O(1)。空間O(N)。
            ## 削除した往復ノードを再利用するため、更新回数には空間が依存しない。
            n, components, freeNode: int
            nodes: seq[ETTNode[S]]
            edgeNodes: Table[tuple[u, v: int], int]
            merge: proc(x, y: S): S
            default: S

    proc initEulerTourTree*[S](v: openArray[S], merge: proc(x, y: S): S,
                              default: S): EulerTourTree[S] =
        ## 頂点値vを持つ辺なしの森を作る。時間・空間O(N)。入力列は保持しない。
        assert v.len <= (int.high - 1) div 3, "頂点数が範囲外です"
        assert merge != nil, "mergeが必要です"
        result = EulerTourTree[S](n: v.len, components: v.len,
            nodes: newSeq[ETTNode[S]](v.len + 1),
            edgeNodes: initTable[tuple[u, v: int], int](), merge: merge, default: default)
        result.nodes[0].value = default
        result.nodes[0].prod = default
        for i, value in v:
            result.nodes[i + 1] = ETTNode[S](size: 1, value: value, prod: value)

    proc initEulerTourTree*[S](n: int, merge: proc(x, y: S): S,
                              default: S): EulerTourTree[S] =
        ## 全頂点の値がdefaultの辺なしの森を作る。時間・空間O(N)。
        assert 0 <= n and n <= (int.high - 1) div 3, "頂点数が範囲外です"
        var values = newSeq[S](n)
        for value in values.mitems: value = default
        initEulerTourTree(values, merge, default)

    template newEulerTourTreeWith*(vOrN, merge, default: untyped): untyped =
        ## l, rを使った可換モノイドの式からEulerTourTreeを作る。時間・空間O(N)。
        initEulerTourTree[typeof(default)](vOrN,
            proc(l{.inject.}, r{.inject.}: typeof(default)): typeof(default) = merge, default)

    proc pull[S](self: EulerTourTree[S], x: int) {.inline.} =
        ## 子と自身の頂点値から頂点数・集約を更新する。O(1)。
        let l = self.nodes[x].child[0]
        let r = self.nodes[x].child[1]
        self.nodes[x].size = self.nodes[l].size + self.nodes[r].size + int(x <= self.n)
        self.nodes[x].prod = self.merge(self.merge(self.nodes[l].prod,
            self.nodes[x].value), self.nodes[r].prod)

    proc rotate[S](self: EulerTourTree[S], x: int) {.inline.} =
        ## xを親の位置へ回転する。列全体の集約は親から引き継ぐ。O(1)。
        let p = self.nodes[x].parent
        let g = self.nodes[p].parent
        let d = int(self.nodes[p].child[1] == x)
        let b = self.nodes[x].child[d xor 1]
        if g != 0: self.nodes[g].child[int(self.nodes[g].child[1] == p)] = x
        self.nodes[x].parent = g
        self.nodes[p].child[d] = b
        if b != 0: self.nodes[b].parent = p
        self.nodes[x].child[d xor 1] = p
        self.nodes[p].parent = x
        self.nodes[x].size = self.nodes[p].size
        self.nodes[x].prod = self.nodes[p].prod
        self.pull(p)

    proc splay[S](self: EulerTourTree[S], x: int) =
        ## xを列の根にする。償却O(log N)。遅延伝播は不要。
        while self.nodes[x].parent != 0:
            let p = self.nodes[x].parent
            let g = self.nodes[p].parent
            if g != 0:
                if (self.nodes[p].child[0] == x) == (self.nodes[g].child[0] == p):
                    self.rotate(p)
                else:
                    self.rotate(x)
            self.rotate(x)

    proc join[S](self: EulerTourTree[S], a, b: int): int =
        ## 根a, bが表す列をこの順で連結する。償却O(log N)。
        if a == 0: return b
        if b == 0: return a
        var x = a
        while self.nodes[x].child[1] != 0: x = self.nodes[x].child[1]
        self.splay(x)
        self.nodes[x].child[1] = b
        self.nodes[b].parent = x
        self.pull(x)
        x

    proc reroot[S](self: EulerTourTree[S], x: int): int =
        ## 巡回列を回転し、xを先頭にする。償却O(log N)。
        self.splay(x)
        let l = self.nodes[x].child[0]
        if l == 0: return x
        self.nodes[l].parent = 0
        self.nodes[x].child[0] = 0
        self.pull(x)
        self.join(x, l)

    template checkETTVertex(self, v: untyped) =
        ## 頂点番号を検査する。
        assert 0 <= v and v < self.n, "頂点番号が範囲外です"

    proc ettEdgeKey(u, v: int): tuple[u, v: int] {.inline.} =
        ## 無向辺の端点を正規化する。O(1)。
        (min(u, v), max(u, v))

    proc len*[S](self: EulerTourTree[S]): int {.inline.} =
        ## 頂点数を返す。O(1)。
        self.n

    proc count*[S](self: EulerTourTree[S]): int {.inline.} =
        ## 成分数を返す。O(1)。
        self.components

    proc connected*[S](self: EulerTourTree[S], u, v: int): bool =
        ## 同じ成分かを返す。償却O(log N)。問い合わせも内部のsplay木を変更する。
        self.checkETTVertex(u)
        self.checkETTVertex(v)
        if u == v: return true
        self.splay(u + 1)
        self.splay(v + 1)
        self.nodes[u + 1].parent != 0

    proc size*[S](self: EulerTourTree[S], v: int): int =
        ## vを含む成分の頂点数を返す。償却O(log N)。
        self.checkETTVertex(v)
        self.splay(v + 1)
        self.nodes[v + 1].size

    proc componentProd*[S](self: EulerTourTree[S], v: int): S =
        ## vを含む成分の全頂点値を一度ずつ集約する。償却O(log N)。
        self.checkETTVertex(v)
        self.splay(v + 1)
        self.nodes[v + 1].prod

    proc `[]`*[S](self: EulerTourTree[S], v: int): S =
        ## 頂点vの値を返す。O(1)。可変参照として扱わないこと。
        self.checkETTVertex(v)
        self.nodes[v + 1].value

    proc update*[S](self: EulerTourTree[S], v: int, value: S) =
        ## 頂点vの値をvalueへ置き換える。償却O(log N)。
        self.checkETTVertex(v)
        self.splay(v + 1)
        self.nodes[v + 1].value = value
        self.pull(v + 1)

    proc `[]=`*[S](self: EulerTourTree[S], v: int, value: S) =
        ## updateの別名。償却O(log N)。
        self.update(v, value)

    proc contains*[S](self: EulerTourTree[S], u, v: int): bool =
        ## 辺(u, v)が存在するかを返す。期待O(1)。
        self.checkETTVertex(u)
        self.checkETTVertex(v)
        self.edgeNodes.hasKey(ettEdgeKey(u, v))

    proc link*[S](self: EulerTourTree[S], u, v: int): bool {.discardable.} =
        ## 異なる成分を結びtrueを返す。期待償却O(log N)。
        ## 自己ループ・重複辺・閉路を作る辺は追加せずfalse。多重辺は保持しない。
        if self.connected(u, v): return false
        let a = self.reroot(u + 1)
        let b = self.reroot(v + 1)
        var edge: int
        if self.freeNode != 0:
            edge = self.freeNode
            self.freeNode = self.nodes[edge].child[0]
        else:
            edge = self.nodes.len
            self.nodes.setLen(edge + 2)
        let back = edge + 1
        self.nodes[edge] = ETTNode[S](child: [a, b], parent: back,
            value: self.default, prod: self.default)
        self.nodes[back] = ETTNode[S](child: [edge, 0],
            value: self.default, prod: self.default)
        self.nodes[a].parent = edge
        self.nodes[b].parent = edge
        self.pull(edge)
        self.pull(back)
        self.edgeNodes[ettEdgeKey(u, v)] = edge
        dec self.components
        true

    proc cut*[S](self: EulerTourTree[S], u, v: int): bool {.discardable.} =
        ## 辺(u, v)を削除しtrueを返す。存在しなければfalse。期待償却O(log N)。
        self.checkETTVertex(u)
        self.checkETTVertex(v)
        let key = ettEdgeKey(u, v)
        let edge = self.edgeNodes.getOrDefault(key)
        if edge == 0: return false
        self.splay(edge)
        let l = self.nodes[edge].child[0]
        let r = self.nodes[edge].child[1]
        if l != 0: self.nodes[l].parent = 0
        if r != 0: self.nodes[r].parent = 0
        discard self.join(r, l)
        let back = edge + 1
        self.splay(back)
        for child in self.nodes[back].child:
            if child != 0: self.nodes[child].parent = 0
        self.nodes[edge] = ETTNode[S](child: [self.freeNode, 0],
            value: self.default, prod: self.default)
        self.nodes[back] = ETTNode[S](value: self.default, prod: self.default)
        self.freeNode = edge
        self.edgeNodes.del(key)
        inc self.components
        true

    runnableExamples:
        let forest = newEulerTourTreeWith(@[4, 1, 7], min(l, r), int.high)
        assert forest.link(0, 1)
        assert forest.link(1, 2)
        assert not forest.link(2, 0)
        assert forest.componentProd(0) == 1
        forest[1] = 9
        assert forest.componentProd(2) == 4
        assert forest.cut(2, 1)
        assert forest.size(0) == 2
        assert forest.componentProd(2) == 7
