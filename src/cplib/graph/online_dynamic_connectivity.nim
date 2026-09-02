when not declared CPLIB_GRAPH_ONLINE_DYNAMIC_CONNECTIVITY:
    const CPLIB_GRAPH_ONLINE_DYNAMIC_CONNECTIVITY* = 1

    import sets

    type
        Edge = tuple[u, v: int]
        OnlineDynamicConnectivity* = object
            n: int
            componentCount: int
            componentId: seq[int]
            componentSizeById: seq[int]
            graph: seq[HashSet[int]]
            forest: seq[HashSet[int]]
            edges: HashSet[Edge]
            treeEdges: HashSet[Edge]

    proc normalizedEdge(u, v: int): Edge {.inline.} =
        if u < v: (u, v) else: (v, u)

    proc checkVertex(self: OnlineDynamicConnectivity, v: int) {.inline.} =
        assert 0 <= v and v < self.n, "vertex is out of range"

    proc initOnlineDynamicConnectivity*(n: int): OnlineDynamicConnectivity =
        ## `n` 頂点の空な無向グラフを作る。
        assert n >= 0
        result.n = n
        result.componentCount = n
        result.componentId = newSeq[int](n)
        result.componentSizeById = newSeq[int](n)
        result.graph = newSeq[HashSet[int]](n)
        result.forest = newSeq[HashSet[int]](n)
        for v in 0..<n:
            result.componentId[v] = v
            result.componentSizeById[v] = 1
            result.graph[v] = initHashSet[int]()
            result.forest[v] = initHashSet[int]()
        result.edges = initHashSet[Edge]()
        result.treeEdges = initHashSet[Edge]()

    proc len*(self: OnlineDynamicConnectivity): int {.inline.} = self.n
    proc count*(self: OnlineDynamicConnectivity): int {.inline.} = self.componentCount

    proc isSame*(self: OnlineDynamicConnectivity, u, v: int): bool =
        ## `u` と `v` が同じ連結成分なら true。
        self.checkVertex(u)
        self.checkVertex(v)
        self.componentId[u] == self.componentId[v]

    proc componentSize*(self: OnlineDynamicConnectivity, v: int): int =
        ## `v` を含む連結成分の頂点数。
        self.checkVertex(v)
        self.componentSizeById[self.componentId[v]]

    proc addEdge*(self: var OnlineDynamicConnectivity, u, v: int): bool {.discardable.} =
        ## 辺 `{u, v}` を追加する。既に存在する場合は false。
        self.checkVertex(u)
        self.checkVertex(v)
        let e = normalizedEdge(u, v)
        if e in self.edges: return false
        self.edges.incl(e)
        if u != v:
            self.graph[u].incl(v)
            self.graph[v].incl(u)
        if u == v or self.componentId[u] == self.componentId[v]: return true

        var fromId = self.componentId[u]
        var toId = self.componentId[v]
        if self.componentSizeById[fromId] > self.componentSizeById[toId]:
            swap(fromId, toId)
        for x in 0..<self.n:
            if self.componentId[x] == fromId:
                self.componentId[x] = toId
        self.componentSizeById[toId] += self.componentSizeById[fromId]
        self.componentSizeById[fromId] = 0
        dec self.componentCount
        self.forest[u].incl(v)
        self.forest[v].incl(u)
        self.treeEdges.incl(e)
        true

    proc collectSide(self: OnlineDynamicConnectivity, start: int): seq[int] =
        result = @[start]
        var seen = initHashSet[int]()
        seen.incl(start)
        var head = 0
        while head < result.len:
            let u = result[head]
            inc head
            for v in self.forest[u]:
                if v notin seen:
                    seen.incl(v)
                    result.add(v)

    proc removeEdge*(self: var OnlineDynamicConnectivity, u, v: int): bool {.discardable.} =
        ## 辺 `{u, v}` を削除する。存在しない場合は false。
        self.checkVertex(u)
        self.checkVertex(v)
        let e = normalizedEdge(u, v)
        if e notin self.edges: return false
        self.edges.excl(e)
        if u != v:
            self.graph[u].excl(v)
            self.graph[v].excl(u)
        if e notin self.treeEdges: return true

        self.treeEdges.excl(e)
        self.forest[u].excl(v)
        self.forest[v].excl(u)
        var side = self.collectSide(u)
        let oldId = self.componentId[u]
        if side.len * 2 > self.componentSizeById[oldId]:
            side = self.collectSide(v)

        var inSide = initHashSet[int]()
        for x in side: inSide.incl(x)
        var replacement: Edge = (-1, -1)
        block findReplacement:
            for x in side:
                for y in self.graph[x]:
                    if y notin inSide:
                        replacement = normalizedEdge(x, y)
                        break findReplacement

        if replacement.u >= 0:
            self.treeEdges.incl(replacement)
            self.forest[replacement.u].incl(replacement.v)
            self.forest[replacement.v].incl(replacement.u)
            return true

        var newId = side[0]
        if newId == oldId:
            newId = (if u in inSide: v else: u)
        for x in side: self.componentId[x] = newId
        self.componentSizeById[newId] = side.len
        self.componentSizeById[oldId] -= side.len
        inc self.componentCount
        true

    proc containsEdge*(self: OnlineDynamicConnectivity, u, v: int): bool =
        self.checkVertex(u)
        self.checkVertex(v)
        normalizedEdge(u, v) in self.edges

    proc link*(self: var OnlineDynamicConnectivity, u, v: int): bool {.inline, discardable.} =
        ## `addEdge` の別名。
        self.addEdge(u, v)

    proc cut*(self: var OnlineDynamicConnectivity, u, v: int): bool {.inline, discardable.} =
        ## `removeEdge` の別名。
        self.removeEdge(u, v)

    proc siz*(self: OnlineDynamicConnectivity, v: int): int {.inline.} =
        ## `componentSize` の別名。
        self.componentSize(v)
