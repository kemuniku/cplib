when not declared CPLIB_TREE_CENTROID_BINARY_TREE:
    const CPLIB_TREE_CENTROID_BINARY_TREE* = 1
    import cplib/graph/graph
    import cplib/tree/centroid_decomposition
    import heapqueue

    type
        CentroidDistanceVertex* = tuple[vertex, distance: int]
        CentroidPoint* = tuple[node, index: int]
        CentroidDistanceRange* = tuple[node, first, past: int]
        CentroidBinaryNode* = tuple[parent, left, right, center, size: int]
        CentroidBinaryTree* = ref object
            initialized: bool
            count, rootNode: int
            nodes: seq[CentroidBinaryNode]
            orders: seq[seq[CentroidDistanceVertex]]
            paths: seq[seq[CentroidPoint]]

    proc checkInitialized(t: CentroidBinaryTree) =
        ## 未初期化の値を拒否する。
        if t.isNil or not t.initialized:
            raise newException(ValueError, "重心分解二分木が未初期化です")

    proc checkNode(t: CentroidBinaryTree, node: int) =
        ## ノード番号を検査する。
        t.checkInitialized()
        if node < 0 or node >= t.nodes.len:
            raise newException(ValueError, "ノード番号が範囲外です")

    proc checkVertex(t: CentroidBinaryTree, v: int) =
        ## 元の木の頂点番号を検査する。
        t.checkInitialized()
        if v < 0 or v >= t.count:
            raise newException(ValueError, "頂点番号が範囲外です")

    proc mergeOrders(a, b: openArray[CentroidDistanceVertex]): seq[CentroidDistanceVertex] =
        ## 距離順の配列を線形時間でマージする。同距離の順序は任意。
        result = newSeqOfCap[CentroidDistanceVertex](a.len + b.len)
        var i, j = 0
        while i < a.len or j < b.len:
            if j == b.len or (i < a.len and a[i].distance <= b[j].distance):
                result.add(a[i])
                inc i
            else:
                result.add(b[j])
                inc j

    proc initCentroidBinaryTree*(g: UnWeightedUnDirectedGraph or UnWeightedUnDirectedStaticGraph): CentroidBinaryTree =
        ## 無重み無向木から不変の二分マージ木を構築する。時間・領域 O(N log(N+1))。
        ## 既存の重心分解を使い、各重心で小さい二成分からマージする。
        ## 葉 0..<N は元の頂点、内部ノードは N..<2N-1。空木の根は -1。
        ## 入力を保持・変更しない。静的グラフは非空なら build が必要。
        ## 閉路・多重辺・自己辺・非連結を release でも ValueError で拒否する。
        if g.isNil: raise newException(ValueError, "グラフが未初期化です")
        let n = g.len
        if n < 0 or n > high(int) div 2:
            raise newException(ValueError, "頂点数が範囲外です")
        result = CentroidBinaryTree(initialized: true, count: n, rootNode: -1)
        if g.edge_count != max(0, n - 1):
            raise newException(ValueError, "入力は木である必要があります")
        if n == 0: return
        when g is UnWeightedUnDirectedStaticGraph:
            if g.start.len != n + 1:
                raise newException(ValueError, "静的グラフは build が必要です")
        var seen = newSeq[bool](n)
        var validation = @[(v: 0, edge: -1)]
        seen[0] = true
        var cursor = 0
        while cursor < validation.len:
            let (v, edge) = validation[cursor]
            inc cursor
            for (u, id) in g.to_and_id(v):
                if id == edge: continue
                if u < 0 or u >= n or seen[u]:
                    raise newException(ValueError, "入力は木である必要があります")
                seen[u] = true
                validation.add((u, id))
        if validation.len != n:
            raise newException(ValueError, "入力は連結な木である必要があります")

        let cd = initCentroidDecomposition(g)
        var order = @[cd.root]
        cursor = 0
        while cursor < order.len:
            let c = order[cursor]
            inc cursor
            for child in cd.children[c]: order.add(child)
        result.nodes = newSeqOfCap[CentroidBinaryNode](2 * n - 1)
        result.orders = newSeqOfCap[seq[CentroidDistanceVertex]](2 * n - 1)
        for v in 0..<n:
            result.nodes.add((parent: -1, left: -1, right: -1, center: v, size: 1))
            result.orders.add(@[(vertex: v, distance: 0)])
        var componentRoot = newSeq[int](n)
        var branchOf = newSeq[int](n)
        var queue: seq[tuple[v, parent, distance, branch: int]]
        for k in countdown(order.len - 1, 0):
            let c = order[k]
            let level = cd.depth[c]
            var branches: seq[seq[CentroidDistanceVertex]]
            queue.setLen(0)
            for u in g[c]:
                if cd.depth[u] <= level: continue
                queue.add((u, c, 1, branches.len))
                branches.add(@[])
            cursor = 0
            while cursor < queue.len:
                let (v, parent, distance, branch) = queue[cursor]
                inc cursor
                branchOf[v] = branch
                branches[branch].add((v, distance))
                for u in g[v]:
                    if u != parent and cd.depth[u] > level:
                        queue.add((u, v, distance + 1, branch))
            var heap = initHeapQueue[tuple[size, node: int]]()
            heap.push((1, c))
            for child in cd.children[c]:
                let node = componentRoot[child]
                result.orders[node] = move(branches[branchOf[child]])
                heap.push((result.nodes[node].size, node))
            while heap.len > 1:
                let a = heap.pop()
                let b = heap.pop()
                let node = result.nodes.len
                result.nodes[a.node].parent = node
                result.nodes[b.node].parent = node
                result.nodes.add((parent: -1, left: a.node, right: b.node,
                    center: c, size: a.size + b.size))
                result.orders.add(mergeOrders(result.orders[a.node], result.orders[b.node]))
                heap.push((a.size + b.size, node))
            componentRoot[c] = heap.pop().node
        result.rootNode = componentRoot[cd.root]
        result.paths = newSeq[seq[CentroidPoint]](n)
        for node in 0..<result.nodes.len:
            for index, entry in result.orders[node]:
                result.paths[entry.vertex].add((node, index))

    proc len*(t: CentroidBinaryTree): int =
        ## 元の木の頂点数を返す。O(1)。
        t.checkInitialized()
        t.count

    proc root*(t: CentroidBinaryTree): int =
        ## 二分木の根を返す。空木は -1。O(1)。
        t.checkInitialized()
        t.rootNode

    proc node_count*(t: CentroidBinaryTree): int =
        ## 二分木のノード数を返す。非空木は 2N-1。O(1)。
        t.checkInitialized()
        t.nodes.len

    proc node_info*(t: CentroidBinaryTree, node: int): CentroidBinaryNode =
        ## 親・左右の子・マージ重心・葉数を値で返す。葉の子と根の親は -1。O(1)。
        t.checkNode(node)
        t.nodes[node]

    proc distance_order*(t: CentroidBinaryTree, node: int): seq[CentroidDistanceVertex] =
        ## 親のマージ重心からの距離順配列を独立コピーで返す。根のみ自身の重心を使う。O(size)。
        t.checkNode(node)
        result = newSeq[CentroidDistanceVertex](t.orders[node].len)
        for i, entry in t.orders[node]: result[i] = entry

    proc entry_at*(t: CentroidBinaryTree, node, index: int): CentroidDistanceVertex =
        ## 距離順配列の一要素を値で返す。O(1)。
        t.checkNode(node)
        if index < 0 or index >= t.orders[node].len:
            raise newException(ValueError, "配列の添字が範囲外です")
        t.orders[node][index]

    proc point_path*(t: CentroidBinaryTree, v: int): seq[CentroidPoint] =
        ## v の全出現位置 (node,index) を葉から根の順に独立コピーで返す。O(log(N+1))。
        t.checkVertex(v)
        result = newSeq[CentroidPoint](t.paths[v].len)
        for i, entry in t.paths[v]: result[i] = entry

    proc lowerDistance(a: openArray[CentroidDistanceVertex], distance: int): int =
        ## 指定距離以上となる最初の添字を二分探索する。O(log(size+1))。
        var first = 0
        var past = a.len
        while first < past:
            let mid = first + (past - first) div 2
            if a[mid].distance < distance: first = mid + 1
            else: past = mid
        first

    proc distance_ranges*(t: CentroidBinaryTree, v, l, r: int): seq[CentroidDistanceRange] =
        ## dist(v,u) が [l,r) に属する頂点を、重複なしの (node,first,past) へ分解する。
        ## 区間数・追加領域 O(log(N+1))、二分探索込み時間 O(log²(N+1))。
        ## 空区間は返さない。負の端点も許し、l>=r は空。端点は int 全域で安全。
        t.checkVertex(v)
        let firstDistance = max(0, l)
        let pastDistance = min(t.count, r)
        if firstDistance >= pastDistance: return
        if firstDistance == 0: result.add((v, 0, 1))
        for point in t.paths[v]:
            let parent = t.nodes[point.node].parent
            if parent == -1: break
            let info = t.nodes[parent]
            let sibling = if info.left == point.node: info.right else: info.left
            let distance = t.orders[point.node][point.index].distance
            let first = lowerDistance(t.orders[sibling], firstDistance - distance)
            let past = lowerDistance(t.orders[sibling], pastDistance - distance)
            if first < past: result.add((sibling, first, past))
