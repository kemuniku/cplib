## 固定根の木DPをPathとPointの2種類のクラスタで管理する。
## vertex(v): 頂点v単体のPath、compress(p, c): 上側pと下側cのPathの連結。
## addVertex(t, v): 枝の集約Point tに頂点vを加えたPath。
## rake(x, y): Point同士の結合、addEdge(t): 完成したPathをPointに変換する。
## vertexはlightな枝を持たない頂点で呼ばれ、後で下側のPathとcompressされる場合もある。
## Nimではadd_vertex/add_edgeという綴りも使用できる。
## compressは結合的、rakeは結合的かつ可換で、合法な結合順序によらず同じ値になる必要がある。
## 頂点データはコールバックから参照し、変更後にupdate(v)を呼ぶ。空クラスタの単位元は不要。
## 各演算がO(1)なら構築O(N log N)、更新O(log N)、全体取得O(1)、空間O(N)。
when not declared CPLIB_TREE_STATIC_TOP_TREE_DP:
    const CPLIB_TREE_STATIC_TOP_TREE_DP* = 1
    import cplib/tree/static_top_tree
    import cplib/tree/heavylightdecomposition

    type
        StaticTopTreeDPOperation = enum
            dpVertex, dpCompress, dpAddVertex, dpRake, dpAddEdge
        StaticTopTreeDPNode = object
            kind: StaticTopTreeDPOperation
            parent, left, right, vertex, size: int
        StaticTopTreeDP*[Path, Point] = ref object
            tree*: StaticTopTree
            nodes: seq[StaticTopTreeDPNode]
            vertexNode: seq[int]
            root: int
            paths: seq[Path]
            points: seq[Point]
            vertex: proc(v: int): Path
            compress: proc(p, c: Path): Path
            addVertex: proc(t: Point, v: int): Path
            rake: proc(x, y: Point): Point
            addEdge: proc(t: Path): Point

    proc recalculate[Path, Point](self: StaticTopTreeDP[Path, Point], node: int) =
        ## 1個のクラスタを再計算する。O(1)回の演算
        let x = self.nodes[node]
        case x.kind
        of dpVertex:
            self.paths[node] = self.vertex(x.vertex)
        of dpCompress:
            self.paths[node] = self.compress(self.paths[x.left], self.paths[x.right])
        of dpAddVertex:
            self.paths[node] = self.addVertex(self.points[x.left], x.vertex)
        of dpRake:
            self.points[node] = self.rake(self.points[x.left], self.points[x.right])
        of dpAddEdge:
            self.points[node] = self.addEdge(self.paths[x.left])

    proc addNode[Path, Point](self: StaticTopTreeDP[Path, Point],
            kind: StaticTopTreeDPOperation, left = -1, right = -1, v = -1): int =
        ## 子より後ろにクラスタを追加する。償却O(1)
        result = self.nodes.len
        var size = if v == -1: 0 else: 1
        if left != -1:
            size += self.nodes[left].size
            self.nodes[left].parent = result
        if right != -1:
            size += self.nodes[right].size
            self.nodes[right].parent = result
        self.nodes.add(StaticTopTreeDPNode(kind: kind, parent: -1,
            left: left, right: right, vertex: v, size: size))
        if v != -1:
            self.vertexNode[v] = result

    proc mergeRange[Path, Point](self: StaticTopTreeDP[Path, Point],
            items, prefix: seq[int], left, right: int, kind: StaticTopTreeDPOperation): int =
        ## 頂点数を重みにして順序を保ちながら結合する。O(K log K)
        if right - left == 1:
            return items[left]
        let weight = prefix[right] - prefix[left]
        let target = prefix[left] + (weight + 1) div 2
        var lo = left + 1
        var hi = right - 1
        while lo < hi:
            let mid = (lo + hi) div 2
            if prefix[mid] < target:
                lo = mid + 1
            else:
                hi = mid
        var mid = lo
        if mid > left + 1 and
                abs(2 * (prefix[mid - 1] - prefix[left]) - weight) <=
                abs(2 * (prefix[mid] - prefix[left]) - weight):
            dec mid
        let l = self.mergeRange(items, prefix, left, mid, kind)
        let r = self.mergeRange(items, prefix, mid, right, kind)
        return self.addNode(kind, l, r)

    proc mergeBalanced[Path, Point](self: StaticTopTreeDP[Path, Point],
            items: seq[int], kind: StaticTopTreeDPOperation): int =
        ## 非空のクラスタ列から平衡な結合木を作る。O(K log K)
        assert items.len > 0
        var prefix = newSeq[int](items.len + 1)
        for i, node in items:
            prefix[i + 1] = prefix[i] + self.nodes[node].size
        return self.mergeRange(items, prefix, 0, items.len, kind)

    proc initStaticTopTreeDP*[Path, Point](tree: StaticTopTree,
            vertex: proc(v: int): Path,
            compress: proc(p, c: Path): Path,
            addVertex: proc(t: Point, v: int): Path,
            rake: proc(x, y: Point): Point,
            addEdge: proc(t: Path): Point): StaticTopTreeDP[Path, Point] =
        ## 固定根の構造と5関数から構築する。O(N log N)時間、O(N)回の演算
        let n = tree.numVertices
        var parent = newSeq[int](n)
        var root = -1
        for v in 0..<n:
            parent[v] = tree.nodes[v].upper
            if parent[v] == -1:
                root = v
        let hld = initHldFromParent(parent, root)
        let self = StaticTopTreeDP[Path, Point](tree: tree,
            vertexNode: newSeq[int](n), vertex: vertex, compress: compress,
            addVertex: addVertex, rake: rake, addEdge: addEdge)
        var pathRoot = newSeq[int](n)
        for i in countdown(n - 1, 0):
            let head = hld.toVtx(i)
            if hld.heavyRootOf(head) != head:
                continue
            var path: seq[int]
            var v = head
            while v != -1:
                let heavy = hld.heavyChildOf(v)
                var branches: seq[int]
                for child in hld.children(v):
                    if child != heavy:
                        branches.add(self.addNode(dpAddEdge, pathRoot[child]))
                if branches.len == 0:
                    path.add(self.addNode(dpVertex, v = v))
                else:
                    let point = self.mergeBalanced(branches, dpRake)
                    path.add(self.addNode(dpAddVertex, point, v = v))
                v = heavy
            pathRoot[head] = self.mergeBalanced(path, dpCompress)
        self.root = pathRoot[root]
        self.paths = newSeq[Path](self.nodes.len)
        self.points = newSeq[Point](self.nodes.len)
        for node in 0..<self.nodes.len:
            self.recalculate(node)
        return self

    proc update*[Path, Point](self: StaticTopTreeDP[Path, Point], v: int) =
        ## 頂点vのデータ変更を反映する。O(log N)回の演算
        assert 0 <= v and v < self.tree.numVertices
        var node = self.vertexNode[v]
        while node != -1:
            self.recalculate(node)
            node = self.nodes[node].parent

    proc getAll*[Path, Point](self: StaticTopTreeDP[Path, Point]): Path =
        ## 構築時の根に対する木全体のPathを返す。O(1)
        return self.paths[self.root]
