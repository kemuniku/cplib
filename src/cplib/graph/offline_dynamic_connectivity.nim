when not declared CPLIB_GRAPH_OFFLINE_DYNAMIC_CONNECTIVITY:
    const CPLIB_GRAPH_OFFLINE_DYNAMIC_CONNECTIVITY* = 1
    import cplib/tree/link_cut_tree

    type
        OdcEdge = object
            u, v, removedAt: int
        OdcOperationKind = enum
            odcAdd, odcRemove, odcConnected
        OdcOperation = object
            kind: OdcOperationKind
            a, b: int
        OdcWeight = tuple[deadline, edgeId: int]
        OfflineDynamicConnectivity* = ref object
            ## 無向多重グラフの操作を先読みして連結性を求める。頂点番号は0..<n。
            ## 操作の登録は償却O(1)、runは償却O((N+Q)log(N+Q+2))、領域O(N+Q)。
            ## refの代入は同じ操作列を共有する。runは操作列を変更せず、毎回独立した結果を返す。
            n, queries: int
            edges: seq[OdcEdge]
            operations: seq[OdcOperation]

    proc initOfflineDynamicConnectivity*(n: int): OfflineDynamicConnectivity =
        ## n頂点・辺なしの操作列を作る。O(1)。不正な頂点数はValueError。
        if n < 0 or n == int.high:
            raise newException(ValueError, "頂点数が範囲外です")
        OfflineDynamicConnectivity(n: n)

    proc checkVertex(self: OfflineDynamicConnectivity, v: int) =
        ## 初期化済みで、頂点番号が範囲内であることを確認する。O(1)。
        if self == nil or v < 0 or v >= self.n:
            raise newException(ValueError, "未初期化または頂点番号が範囲外です")

    proc add*(self: OfflineDynamicConnectivity, u, v: int): int =
        ## 辺の追加を登録し、この追加固有のedgeIdを返す。償却O(1)。自己ループ・多重辺も可。
        self.checkVertex(u)
        self.checkVertex(v)
        if self.edges.len >= int.high - self.n - 1:
            raise newException(ValueError, "LCTのノード数がintの範囲外です")
        result = self.edges.len
        self.edges.add(OdcEdge(u: u, v: v, removedAt: -1))
        self.operations.add(OdcOperation(kind: odcAdd, a: result))

    proc remove*(self: OfflineDynamicConnectivity, edgeId: int) =
        ## 生存中のedgeIdの削除を登録する。償却O(1)。不正ID・二重削除はValueError。
        if self == nil or edgeId < 0 or edgeId >= self.edges.len:
            raise newException(ValueError, "未初期化または辺IDが範囲外です")
        if self.edges[edgeId].removedAt != -1:
            raise newException(ValueError, "この辺は既に削除されています")
        self.edges[edgeId].removedAt = self.operations.len
        self.operations.add(OdcOperation(kind: odcRemove, a: edgeId))

    proc connected*(self: OfflineDynamicConnectivity, u, v: int): int =
        ## 連結性の質問を登録し、runの結果配列の添字を返す。償却O(1)。その場で判定しない。
        self.checkVertex(u)
        self.checkVertex(v)
        result = self.queries
        inc self.queries
        self.operations.add(OdcOperation(kind: odcConnected, a: u, b: v))

    proc odcMinimum(l, r: OdcWeight): OdcWeight =
        ## 削除時刻が早い値を返す。同時刻なら後の追加を軽く扱う。O(1)。
        if l.deadline < r.deadline or (l.deadline == r.deadline and l.edgeId > r.edgeId): l else: r

    proc run*(self: OfflineDynamicConnectivity): seq[bool] =
        ## 登録済み質問へ順に回答する。償却O((N+Q)log(N+Q+2))、追加領域O(N+Q)。
        ## 削除時刻を重みとする最大森を、辺を頂点化したLCTで保持する。
        ## 閉路への追加は最小重みの辺と交換する。削除される森辺の切断面に生存する
        ## 代替辺があれば、その削除時刻はより遅く最大性に反するので、探索は不要。
        if self == nil:
            raise newException(ValueError, "未初期化です")
        let identity: OdcWeight = (int.high, -1)
        var values = newSeq[OdcWeight](self.n + self.edges.len)
        for v in 0..<self.n: values[v] = identity
        for id, edge in self.edges:
            let deadline = if edge.removedAt == -1: self.operations.len else: edge.removedAt
            values[self.n + id] = (deadline, id)
        let forest = initLinkCutTree(values, odcMinimum, identity)
        var inForest = newSeq[bool](self.edges.len)
        result = newSeqOfCap[bool](self.queries)
        for operation in self.operations:
            case operation.kind
            of odcAdd:
                let id = operation.a
                let edge = self.edges[id]
                if edge.u == edge.v: continue
                if forest.connected(edge.u, edge.v):
                    let weakest = forest.pathProd(edge.u, edge.v)
                    if odcMinimum(weakest, values[self.n + id]) == values[self.n + id]: continue
                    let old = self.edges[weakest.edgeId]
                    forest.cut(old.u, self.n + weakest.edgeId)
                    forest.cut(old.v, self.n + weakest.edgeId)
                    inForest[weakest.edgeId] = false
                forest.link(edge.u, self.n + id)
                forest.link(edge.v, self.n + id)
                inForest[id] = true
            of odcRemove:
                let id = operation.a
                if inForest[id]:
                    let edge = self.edges[id]
                    forest.cut(edge.u, self.n + id)
                    forest.cut(edge.v, self.n + id)
                    inForest[id] = false
            of odcConnected:
                result.add(forest.connected(operation.a, operation.b))
