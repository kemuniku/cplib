## 任意の頂点を根とする木DPを、構造を変更せずに問い合わせる。
## Forwardは上端を除き下端を含む向き、Backwardは同じ頂点集合を下端から見た向き。
## compressReverseは逆向きのパスを連結する。rakeAtRootとrakeAtEndはそれぞれ
## Backwardの始点・終点にForwardの枝を付け、Backwardのパスを維持する。
## 各演算はクラスタの結合を表し、枝の順序や合法な結合順序に依存しないものとする。
## 空クラスタの単位元や逆演算は不要。各演算がO(1)なら更新・問い合わせはO(log N)。
when not declared CPLIB_TREE_REROOTING_STATIC_TOP_TREE_DP:
    const CPLIB_TREE_REROOTING_STATIC_TOP_TREE_DP* = 1
    import cplib/tree/static_top_tree

    type RerootingStaticTopTreeDP*[Forward, Backward] = ref object
        tree*: StaticTopTree
        forward: seq[Forward]
        backward: seq[Backward]
        compress, rake: proc(l, r: Forward): Forward
        compressReverse: proc(l, r: Backward): Backward
        rakeAtRoot, rakeAtEnd: proc(l: Backward, r: Forward): Backward

    proc recalculate[Forward, Backward](self: RerootingStaticTopTreeDP[Forward, Backward], node: int) =
        ## 子の集約値から内部ノードの両方向を再計算する。O(1)回の演算
        let x = self.tree.nodes[node]
        case x.kind
        of sttCompress:
            self.forward[node] = self.compress(self.forward[x.left], self.forward[x.right])
            self.backward[node] = self.compressReverse(self.backward[x.right], self.backward[x.left])
        of sttRake:
            self.forward[node] = self.rake(self.forward[x.left], self.forward[x.right])
            self.backward[node] = self.rakeAtEnd(self.backward[x.left], self.forward[x.right])
        of sttLeaf:
            discard

    proc initRerootingStaticTopTreeDP*[Forward, Backward](tree: StaticTopTree,
            forward: openArray[Forward], backward: openArray[Backward],
            compress, rake: proc(l, r: Forward): Forward,
            compressReverse: proc(l, r: Backward): Backward,
            rakeAtRoot, rakeAtEnd: proc(l: Backward, r: Forward): Backward
            ): RerootingStaticTopTreeDP[Forward, Backward] =
        ## 頂点番号順の葉の値から両方向のDPを構築する。O(N)回の演算
        assert forward.len == tree.numVertices and backward.len == tree.numVertices
        result = RerootingStaticTopTreeDP[Forward, Backward](tree: tree,
            forward: newSeq[Forward](tree.nodes.len), backward: newSeq[Backward](tree.nodes.len),
            compress: compress, rake: rake, compressReverse: compressReverse,
            rakeAtRoot: rakeAtRoot, rakeAtEnd: rakeAtEnd)
        for v in 0..<tree.numVertices:
            result.forward[v] = forward[v]
            result.backward[v] = backward[v]
        for node in tree.numVertices..<tree.nodes.len:
            result.recalculate(node)

    proc set*[Forward, Backward](self: RerootingStaticTopTreeDP[Forward, Backward], v: int,
            forward: Forward, backward: Backward) =
        ## 頂点vと親辺を表す葉の両方向の値を更新する。O(log N)回の演算
        assert 0 <= v and v < self.tree.numVertices
        self.forward[v] = forward
        self.backward[v] = backward
        var node = self.tree.nodes[v].parent
        while node != -1:
            self.recalculate(node)
            node = self.tree.nodes[node].parent

    proc getAll*[Forward, Backward](self: RerootingStaticTopTreeDP[Forward, Backward]): Forward =
        ## 構築時の根に対する木全体の集約値を返す。O(1)
        return self.forward[self.tree.root]

    proc prod*[Forward, Backward](self: RerootingStaticTopTreeDP[Forward, Backward], v: int): Backward =
        ## 頂点vを根とする木全体の集約値を返す。O(log N)時間・作業空間
        assert 0 <= v and v < self.tree.numVertices
        var path: seq[int]
        var node = v
        while self.tree.nodes[node].parent != -1:
            path.add(node)
            node = self.tree.nodes[node].parent
        var upper: Backward
        var lower: Forward
        var hasUpper = false
        var hasLower = false
        # 上端側の外部は上端の頂点を含み、下端側の外部は下端の頂点を含まない。
        for i in countdown(path.len - 1, 0):
            let child = path[i]
            let x = self.tree.nodes[self.tree.nodes[child].parent]
            case x.kind
            of sttCompress:
                if child == x.left:
                    lower = if hasLower: self.compress(self.forward[x.right], lower)
                            else: self.forward[x.right]
                    hasLower = true
                else:
                    upper = if hasUpper: self.compressReverse(self.backward[x.left], upper)
                            else: self.backward[x.left]
                    hasUpper = true
            of sttRake:
                assert hasUpper
                if child == x.left:
                    upper = self.rakeAtRoot(upper, self.forward[x.right])
                else:
                    let rest = if hasLower: self.compress(self.forward[x.left], lower)
                               else: self.forward[x.left]
                    upper = self.rakeAtRoot(upper, rest)
                    hasLower = false
            of sttLeaf:
                assert false
        result = self.backward[v]
        if hasUpper:
            result = self.compressReverse(result, upper)
        if hasLower:
            result = self.rakeAtRoot(result, lower)
