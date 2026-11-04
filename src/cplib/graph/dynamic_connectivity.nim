when not declared CPLIB_GRAPH_DYNAMIC_CONNECTIVITY:
    const CPLIB_GRAPH_DYNAMIC_CONNECTIVITY* = 1
    import tables

    type
        DCNode = object
            child: array[2, int32]
            parent, size: int32
            payload, nextLevel: int32
            flags, aggregate: uint8
        DCEdge = object
            u, v, level, treeNode: int32
            prev, next: array[2, int32]
            multiplicity: int
        DynamicConnectivity* = ref object
            ## 無向多重グラフのオンライン動的連結性。頂点番号は0..<n。
            ## HDT法とsplay木によるEuler Tour Treeを用いる。
            ## 更新は償却O(log^2 N)、連結判定・成分サイズは償却O(log N)。
            ## 辺検索のハッシュ表は期待O(1)。空間O(N log N + M)、Mは同時に保持した異なる辺数の最大値。
            ## 上位レベルの頂点は必要時に生成し、削除した辺と往復ノードは再利用する。
            ## 参考: https://www.cs.princeton.edu/courses/archive/fall07/cos521/handouts/poly.pdf 第3節。
            n, components: int
            nodes: seq[DCNode]
            edges: seq[DCEdge]
            edgeIds: Table[uint64, int32]
            freeNode, freeEdge: int32

    const
        dcExact = 1'u8
        dcIncident = 2'u8
        dcVertex = 4'u8

    proc initDynamicConnectivity*(n: int, edgeCapacity: int = 0): DynamicConnectivity =
        ## n頂点・辺なしで初期化する。O(N + edgeCapacity)。辺数の見積もりを指定すると再確保を減らせる。
        assert n >= 0 and n < int32.high.int, "頂点数が範囲外です"
        assert edgeCapacity >= 0 and edgeCapacity < (int32.high.int shr 1), "辺数の見積もりが範囲外です"
        result = DynamicConnectivity(n: n, components: n,
            nodes: newSeq[DCNode](n + 1),
            edges: newSeqOfCap[DCEdge](edgeCapacity + 1),
            edgeIds: initTable[uint64, int32](max(4, edgeCapacity)))
        result.edges.add(DCEdge())
        for v in 1..n:
            result.nodes[v].size = 1
            result.nodes[v].flags = dcVertex

    when defined(release):
        # 内部の添字と成分サイズは構築時の上限で保証される。回転中の重複検査を省く。
        {.push boundChecks: off, overflowChecks: off.}

    proc pull(self: DynamicConnectivity, x: int32) {.inline.} =
        ## 子の情報から頂点数と探索用フラグを再計算する。O(1)。
        let l = self.nodes[x].child[0]
        let r = self.nodes[x].child[1]
        self.nodes[x].size = self.nodes[l].size + self.nodes[r].size +
            int32((self.nodes[x].flags and dcVertex) != 0)
        self.nodes[x].aggregate = self.nodes[l].aggregate or self.nodes[r].aggregate or
            (self.nodes[x].flags and (dcExact or dcIncident))

    proc rotate(self: DynamicConnectivity, x: int32) {.inline.} =
        ## xを親の位置へ回転する。部分木全体の集約は親から引き継ぐ。O(1)。
        let p = self.nodes[x].parent
        let g = self.nodes[p].parent
        let d = int(self.nodes[p].child[1] == x)
        let b = self.nodes[x].child[d xor 1]
        if g != 0:
            self.nodes[g].child[int(self.nodes[g].child[1] == p)] = x
        self.nodes[x].parent = g
        self.nodes[p].child[d] = b
        if b != 0: self.nodes[b].parent = p
        self.nodes[x].child[d xor 1] = p
        self.nodes[p].parent = x
        self.nodes[x].size = self.nodes[p].size
        self.nodes[x].aggregate = self.nodes[p].aggregate
        self.pull(p)

    proc splay(self: DynamicConnectivity, x: int32) =
        ## xをEuler Tour Treeの根にする。償却O(log N)。遅延伝播は不要。
        while self.nodes[x].parent != 0:
            let p = self.nodes[x].parent
            let g = self.nodes[p].parent
            if g != 0:
                if (self.nodes[p].child[0] == x) == (self.nodes[g].child[0] == p):
                    self.rotate(p)
                else:
                    self.rotate(x)
            self.rotate(x)

    when defined(release):
        {.pop.}

    proc sameTree(self: DynamicConnectivity, u, v: int32): bool {.inline.} =
        ## 二つのノードの連結性を調べる。u != vならvを根にする。償却O(log N)。
        if u == v: return true
        self.splay(u)
        self.splay(v)
        self.nodes[u].parent != 0

    proc join(self: DynamicConnectivity, a, b: int32): int32 =
        ## 根a, bが表す列をこの順で連結する。償却O(log N)。
        if a == 0: return b
        if b == 0: return a
        var x = a
        while self.nodes[x].child[1] != 0:
            x = self.nodes[x].child[1]
        self.splay(x)
        self.nodes[x].child[1] = b
        self.nodes[b].parent = x
        self.pull(x)
        x

    proc reroot(self: DynamicConnectivity, x: int32): int32 =
        ## 巡回列を回転し、xを列の先頭にする。償却O(log N)。
        self.splay(x)
        let l = self.nodes[x].child[0]
        if l == 0: return x
        self.nodes[l].parent = 0
        self.nodes[x].child[0] = 0
        self.pull(x)
        self.join(x, l)

    proc vertexAt(self: DynamicConnectivity, vertex: int32, level: int): int32 =
        ## 指定レベルの頂点ノードを取得し、未使用なら作る。O(level)、確保は償却O(1)/ノード。
        result = vertex
        for _ in 0..<level:
            var upper = self.nodes[result].nextLevel
            if upper == 0:
                assert self.nodes.len < int32.high.int, "内部ノード数が上限を超えました"
                upper = int32(self.nodes.len)
                self.nodes.add(DCNode(size: 1, flags: dcVertex))
                self.nodes[result].nextLevel = upper
            result = upper

    proc linkTree(self: DynamicConnectivity, u, v, edge, lower: int32, exact: bool): int32 =
        ## 異なる木を結び、往路ノードを返す。復路は直後の添字に置く。償却O(log N)。
        let a = self.reroot(u)
        let b = self.reroot(v)
        if self.freeNode != 0:
            result = self.freeNode
            self.freeNode = self.nodes[result].child[0]
        else:
            assert self.nodes.len < int32.high.int - 1, "内部ノード数が上限を超えました"
            result = int32(self.nodes.len)
            self.nodes.setLen(self.nodes.len + 2)
        let back = result + 1
        self.nodes[result] = DCNode(child: [a, b], parent: back,
            payload: edge, nextLevel: lower, flags: (if exact: dcExact else: 0'u8))
        self.nodes[back] = DCNode(child: [result, 0'i32])
        self.nodes[a].parent = result
        self.nodes[b].parent = result
        self.pull(result)
        self.pull(back)

    proc cutTree(self: DynamicConnectivity, edgeNode: int32) =
        ## 木辺の往復ノードを除去して二つの木へ分割し、ノードを再利用する。償却O(log N)。
        self.splay(edgeNode)
        let l = self.nodes[edgeNode].child[0]
        let r = self.nodes[edgeNode].child[1]
        if l != 0: self.nodes[l].parent = 0
        if r != 0: self.nodes[r].parent = 0
        discard self.join(r, l)
        let back = edgeNode + 1
        self.splay(back)
        for child in self.nodes[back].child:
            if child != 0: self.nodes[child].parent = 0
        self.nodes[edgeNode].child[0] = self.freeNode
        self.freeNode = edgeNode

    proc findMarked(self: DynamicConnectivity, root: var int32, flag: uint8): int32 =
        ## 集約フラグを辿って対象ノードを探し、見つかれば根にする。償却O(log N)。
        if (self.nodes[root].aggregate and flag) == 0: return 0
        result = root
        while (self.nodes[result].flags and flag) == 0:
            let l = self.nodes[result].child[0]
            if (self.nodes[l].aggregate and flag) != 0:
                result = l
            else:
                result = self.nodes[result].child[1]
        self.splay(result)
        root = result

    proc addNonTree(self: DynamicConnectivity, edge: int32, level: int) =
        ## 非木辺を両端の隣接リストへ登録する。償却O(log N)。
        for side in 0..1:
            let v = self.vertexAt(if side == 0: self.edges[edge].u else: self.edges[edge].v, level)
            let head = self.nodes[v].payload
            let half = (edge shl 1) or int32(side)
            self.edges[edge].prev[side] = 0
            self.edges[edge].next[side] = head
            if head != 0:
                self.edges[head shr 1].prev[head and 1] = half
            self.nodes[v].payload = half
            if head == 0:
                self.splay(v)
                self.nodes[v].flags = self.nodes[v].flags or dcIncident
                self.pull(v)

    proc removeNonTree(self: DynamicConnectivity, edge, u, v: int32): int32 {.discardable.} =
        ## 非木辺を外す。splayした場合は最後の根、なければ0を返す。償却O(log N)。
        for side in 0..1:
            let p = self.edges[edge].prev[side]
            let q = self.edges[edge].next[side]
            let vertex = if side == 0: u else: v
            if p == 0:
                self.nodes[vertex].payload = q
            else:
                self.edges[p shr 1].next[p and 1] = q
            if q != 0:
                self.edges[q shr 1].prev[q and 1] = p
            if self.nodes[vertex].payload == 0:
                self.splay(vertex)
                self.nodes[vertex].flags = self.nodes[vertex].flags and not dcIncident
                self.pull(vertex)
                result = vertex

    proc reconnect(self: DynamicConnectivity, u, v: int32, topLevel: int): bool =
        ## 小さい成分の辺を昇格しながら代替辺を探す。全更新を通じて償却O(log^2 N)。
        for level in countdown(topLevel, 0):
            var x = self.vertexAt(u, level)
            var y = self.vertexAt(v, level)
            self.splay(x)
            self.splay(y)
            if self.nodes[x].size > self.nodes[y].size: swap(x, y)
            var root = x
            while true:
                let node = self.findMarked(root, dcExact)
                if node == 0: break
                let edge = self.nodes[node].payload
                self.nodes[node].flags = self.nodes[node].flags and not dcExact
                self.pull(node)
                let a = self.vertexAt(self.edges[edge].u, level + 1)
                let b = self.vertexAt(self.edges[edge].v, level + 1)
                self.edges[edge].treeNode = self.linkTree(a, b, edge, node, true)
                inc self.edges[edge].level
            while true:
                let node = self.findMarked(root, dcIncident)
                if node == 0: break
                let half = self.nodes[node].payload
                let edge = half shr 1
                let side = half and 1
                let other = self.vertexAt(if side == 0: self.edges[edge].v else: self.edges[edge].u, level)
                self.splay(other)
                let internal = self.nodes[node].parent != 0
                let a = if side == 0: node else: other
                let b = if side == 0: other else: node
                let last = self.removeNonTree(edge, a, b)
                if internal:
                    root = if last != 0: last else: other
                    inc self.edges[edge].level
                    self.addNonTree(edge, level + 1)
                else:
                    var lower = 0'i32
                    for i in 0..level:
                        let p = self.vertexAt(self.edges[edge].u, i)
                        let q = self.vertexAt(self.edges[edge].v, i)
                        lower = self.linkTree(p, q, edge, lower, i == level)
                    self.edges[edge].treeNode = lower
                    return true

    proc edgeKey(u, v: int): uint64 {.inline.} =
        ## 無向辺の端点を一つのキーに正規化する。O(1)。
        (uint64(min(u, v)) shl 32) or uint64(max(u, v))

    template checkVertex(self: DynamicConnectivity, v: int) =
        ## 頂点番号を検査する。
        assert 0 <= v and v < self.n, "頂点番号が範囲外です"

    proc len*(self: DynamicConnectivity): int {.inline.} =
        ## 頂点数を返す。O(1)。
        self.n

    proc count*(self: DynamicConnectivity): int {.inline.} =
        ## 連結成分数を返す。O(1)。
        self.components

    proc connected*(self: DynamicConnectivity, u, v: int): bool =
        ## u, vが同じ連結成分に属するかを返す。償却O(log N)。
        self.checkVertex(u)
        self.checkVertex(v)
        self.sameTree(int32(u + 1), int32(v + 1))

    proc issame*(self: DynamicConnectivity, u, v: int): bool {.inline.} =
        ## connectedの別名。償却O(log N)。
        self.connected(u, v)

    proc size*(self: DynamicConnectivity, v: int): int =
        ## vの属する連結成分の頂点数を返す。償却O(log N)。
        self.checkVertex(v)
        self.splay(int32(v + 1))
        int(self.nodes[v + 1].size)

    proc siz*(self: DynamicConnectivity, v: int): int {.inline.} =
        ## sizeの別名。償却O(log N)。
        self.size(v)

    proc edgeCount*(self: DynamicConnectivity, u, v: int): int =
        ## 辺(u, v)の本数を返す。自己ループも数える。期待O(1)。
        self.checkVertex(u)
        self.checkVertex(v)
        self.edges[self.edgeIds.getOrDefault(edgeKey(u, v))].multiplicity

    proc contains*(self: DynamicConnectivity, u, v: int): bool {.inline.} =
        ## 辺(u, v)が存在するかを返す。期待O(1)。
        self.edgeCount(u, v) != 0

    proc link*(self: DynamicConnectivity, u, v: int): bool {.discardable.} =
        ## 辺を1本追加し、連結成分が結合されたときtrueを返す。償却O(log^2 N)。
        ## 多重辺・自己ループも追加できる。昇格の費用を除く追加自体は償却O(log N)。
        self.checkVertex(u)
        self.checkVertex(v)
        let key = edgeKey(u, v)
        var edge = self.edgeIds.getOrDefault(key)
        if edge != 0:
            inc self.edges[edge].multiplicity
            return false
        if self.freeEdge != 0:
            edge = self.freeEdge
            self.freeEdge = self.edges[edge].next[0]
        else:
            assert self.edges.len < (int32.high.int shr 1), "辺数が上限を超えました"
            edge = int32(self.edges.len)
            self.edges.add(DCEdge())
        let a = int32(u + 1)
        let b = int32(v + 1)
        self.edges[edge] = DCEdge(u: a, v: b, multiplicity: 1)
        self.edgeIds[key] = edge
        if u == v: return false
        if self.sameTree(a, b):
            self.addNonTree(edge, 0)
        else:
            self.edges[edge].treeNode = self.linkTree(a, b, edge, 0, true)
            dec self.components
            return true

    proc cut*(self: DynamicConnectivity, u, v: int): bool {.discardable.} =
        ## 辺を1本削除し、連結成分が分裂したときtrueを返す。償却O(log^2 N)。
        ## 存在しない辺なら何もせずfalseを返す。多重辺は1本だけ削除する。
        self.checkVertex(u)
        self.checkVertex(v)
        let key = edgeKey(u, v)
        let edge = self.edgeIds.getOrDefault(key)
        if edge == 0: return false
        if self.edges[edge].multiplicity > 1:
            dec self.edges[edge].multiplicity
            return false
        let a = self.edges[edge].u
        let b = self.edges[edge].v
        let level = int(self.edges[edge].level)
        var node = self.edges[edge].treeNode
        self.edgeIds.del(key)
        if a != b:
            if node == 0:
                self.removeNonTree(edge, self.vertexAt(a, level), self.vertexAt(b, level))
            else:
                while node != 0:
                    let lower = self.nodes[node].nextLevel
                    self.cutTree(node)
                    node = lower
                if not self.reconnect(a, b, level):
                    inc self.components
                    result = true
        self.edges[edge].multiplicity = 0
        self.edges[edge].next[0] = self.freeEdge
        self.freeEdge = edge

    runnableExamples:
        let dc = initDynamicConnectivity(4)
        assert dc.link(0, 1)
        assert dc.link(1, 2)
        assert not dc.link(2, 0)
        assert dc.size(0) == 3
        assert dc.count == 2
        assert not dc.cut(0, 1)
        assert dc.connected(0, 1)
        assert dc.cut(0, 2)
        assert not dc.connected(0, 1)
