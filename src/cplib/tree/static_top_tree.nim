## 頂点と親辺を葉とするStatic Top Tree。木の形と構築時の根は固定する。
## クラスタは上端の頂点値を含まず、下端の頂点値と枝部分を含む。
## Compressは上下のパスを連結し、Rakeは共通の上端で枝をまとめて左のパスを残す。
## 葉のIDは元の頂点番号と等しい。辺の更新は、構築時の子側の葉を更新する。
## https://maspypy.com/library-checker-point-set-tree-path-composite-sum を参考にした。
when not declared CPLIB_TREE_STATIC_TOP_TREE:
    const CPLIB_TREE_STATIC_TOP_TREE* = 1
    import cplib/tree/heavylightdecomposition

    type
        StaticTopTreeNodeKind* = enum
            sttLeaf, sttCompress, sttRake
        StaticTopTreeNode* = object
            kind*: StaticTopTreeNodeKind
            parent*, left*, right*: int
            upper*, lower*, size*: int
        StaticTopTree* = ref object
            numVertices*, root*: int
            nodes*: seq[StaticTopTreeNode]

    proc mergeRange(tree: StaticTopTree, items, prefix: seq[int], left, right: int,
                    kind: StaticTopTreeNodeKind): int =
        ## 累積頂点数で分割し、順序を保ってクラスタを結合する。
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
        let l = tree.mergeRange(items, prefix, left, mid, kind)
        let r = tree.mergeRange(items, prefix, mid, right, kind)
        let upper = tree.nodes[l].upper
        let lower = if kind == sttCompress: tree.nodes[r].lower else: tree.nodes[l].lower
        if kind == sttCompress:
            assert tree.nodes[l].lower == tree.nodes[r].upper
        else:
            assert tree.nodes[l].upper == tree.nodes[r].upper
        result = tree.nodes.len
        tree.nodes.add(StaticTopTreeNode(kind: kind, parent: -1, left: l, right: r,
            upper: upper, lower: lower, size: weight))
        tree.nodes[l].parent = result
        tree.nodes[r].parent = result

    proc mergeBalanced(tree: StaticTopTree, items: seq[int], kind: StaticTopTreeNodeKind): int =
        ## 頂点数を重みにした平衡な結合木を作る。O(K log K)
        assert items.len > 0
        if items.len == 1:
            return items[0]
        var prefix = newSeq[int](items.len + 1)
        for i, node in items:
            prefix[i + 1] = prefix[i] + tree.nodes[node].size
        return tree.mergeRange(items, prefix, 0, items.len, kind)

    proc initStaticTopTree*(hld: HeavyLightDecomposition): StaticTopTree =
        ## 非空の木のHLDから高さO(log N)の構造を作る。O(N log N)時間、O(N)空間
        let n = hld.numVertices
        assert n > 0
        let tree = StaticTopTree(numVertices: n, nodes: newSeqOfCap[StaticTopTreeNode](2 * n - 1))
        for v in 0..<n:
            tree.nodes.add(StaticTopTreeNode(kind: sttLeaf, parent: -1, left: -1, right: -1,
                upper: hld.parentOf(v), lower: v, size: 1))
        var pathRoot = newSeq[int](n)
        for i in countdown(n - 1, 0):
            let head = hld.toVtx(i)
            if hld.heavyRootOf(head) != head:
                continue
            var path = @[head]
            var v = head
            while true:
                let heavy = hld.heavyChildOf(v)
                if heavy == -1:
                    break
                var branches = @[heavy]
                for child in hld.children(v):
                    if child != heavy:
                        branches.add(pathRoot[child])
                path.add(tree.mergeBalanced(branches, sttRake))
                v = heavy
            pathRoot[head] = tree.mergeBalanced(path, sttCompress)
        tree.root = pathRoot[hld.toVtx(0)]
        assert tree.nodes.len == 2 * n - 1
        return tree

    proc initStaticTopTreeFromParent*(parent: openArray[int], root: int = 0): StaticTopTree =
        ## 親配列から構築する。parent[root]は参照しない。O(N log N)
        return initStaticTopTree(initHldFromParent(parent, root))
