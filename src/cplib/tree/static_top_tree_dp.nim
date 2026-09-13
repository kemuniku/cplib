## 固定根の木DPを管理する。各演算がO(1)なら更新はO(log N)、全体取得はO(1)。
## compress(上, 下)はパスの連結、rake(本体, 枝)は本体のパスを残す枝の結合。
## 枝の順序に依存せず、合法な結合順序を変えても同じクラスタの値になるDPを対象とする。
## 葉vには頂点vと親辺の情報を与え、構築時の根の親辺は問題に応じた恒等的な辺とする。
when not declared CPLIB_TREE_STATIC_TOP_TREE_DP:
    const CPLIB_TREE_STATIC_TOP_TREE_DP* = 1
    import cplib/tree/static_top_tree

    type StaticTopTreeDP*[Forward] = ref object
        tree*: StaticTopTree
        values: seq[Forward]
        compress, rake: proc(l, r: Forward): Forward

    proc recalculate[Forward](self: StaticTopTreeDP[Forward], node: int) =
        ## 子の集約値から内部ノードを再計算する。O(1)回の演算
        let x = self.tree.nodes[node]
        case x.kind
        of sttCompress:
            self.values[node] = self.compress(self.values[x.left], self.values[x.right])
        of sttRake:
            self.values[node] = self.rake(self.values[x.left], self.values[x.right])
        of sttLeaf:
            discard

    proc initStaticTopTreeDP*[Forward](tree: StaticTopTree, values: openArray[Forward],
            compress, rake: proc(l, r: Forward): Forward): StaticTopTreeDP[Forward] =
        ## 頂点番号順の葉の値から固定根DPを構築する。O(N)回の演算
        assert values.len == tree.numVertices
        result = StaticTopTreeDP[Forward](tree: tree, values: newSeq[Forward](tree.nodes.len),
            compress: compress, rake: rake)
        for v in 0..<values.len:
            result.values[v] = values[v]
        for node in values.len..<tree.nodes.len:
            result.recalculate(node)

    proc set*[Forward](self: StaticTopTreeDP[Forward], v: int, value: Forward) =
        ## 頂点vと親辺を表す葉の値を更新する。O(log N)回の演算
        assert 0 <= v and v < self.tree.numVertices
        self.values[v] = value
        var node = self.tree.nodes[v].parent
        while node != -1:
            self.recalculate(node)
            node = self.tree.nodes[node].parent

    proc getAll*[Forward](self: StaticTopTreeDP[Forward]): Forward =
        ## 構築時の根に対する木全体の集約値を返す。O(1)
        return self.values[self.tree.root]
