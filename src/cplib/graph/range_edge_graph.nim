when not declared CPLIB_RANGE_EDGE_GRAPH:
    const CPLIB_RANGE_EDGE_GRAPH* = 1
    import cplib/graph/graph
    type
        RangeEdgeGraphNode = object
            l, r: int
            left, right: int
            inId, outId: int

        Range_Edge_Graph*[T] = ref object
            G*: WeightedDirectedGraph[T]
            n*: int
            baseLen*: int
            zero: T
            root: int
            nodes: seq[RangeEdgeGraphNode]

    proc graph*[T](G: Range_Edge_Graph[T]): WeightedDirectedGraph[T] = G.G
    proc len*[T](G: Range_Edge_Graph[T]): int = G.G.len
    proc original_len*[T](G: Range_Edge_Graph[T]): int = G.n
    proc base_len*[T](G: Range_Edge_Graph[T]): int = G.baseLen

    proc initWeightedRangeGraph*[T](N: int, zero: T): Range_Edge_Graph[T] =
        # 元頂点を in/out セグ木の葉として共有し、内部ノードだけを追加する。
        assert N >= 0
        let baseLen = if N == 0: 0 else: 3 * N - 2
        result = Range_Edge_Graph[T](
            G: initWeightedDirectedGraph(baseLen, T),
            n: N,
            baseLen: baseLen,
            zero: zero,
            root: -1,
            nodes: @[]
        )
        if N == 0: return

        var nextId = N
        let self = result
        proc build(l, r: int): int =
            let idx = self.nodes.len
            self.nodes.add(RangeEdgeGraphNode(
                l: l, r: r,
                left: -1, right: -1,
                inId: l, outId: l
            ))
            if r - l == 1:
                return idx

            let inId = nextId
            inc nextId
            let outId = nextId
            inc nextId
            self.nodes[idx].inId = inId
            self.nodes[idx].outId = outId

            let m = (l + r) shr 1
            let left = build(l, m)
            let right = build(m, r)
            self.nodes[idx].left = left
            self.nodes[idx].right = right

            self.G.add_edge(inId, self.nodes[left].inId, zero)
            self.G.add_edge(inId, self.nodes[right].inId, zero)
            self.G.add_edge(self.nodes[left].outId, outId, zero)
            self.G.add_edge(self.nodes[right].outId, outId, zero)
            return idx

        result.root = build(0, N)
        assert nextId == baseLen

    proc initWeightedRangeGraph*(N: int): Range_Edge_Graph[int] =
        initWeightedRangeGraph(N, 0)

    proc initWeightedRangeGraph*[T](N: int, edgetype: typedesc[T]): Range_Edge_Graph[T] =
        var zero: T
        initWeightedRangeGraph(N, zero)

    proc validateRange[T](G: Range_Edge_Graph[T], l, r: int) =
        assert 0 <= l and l <= r and r <= G.n

    proc validatePoint[T](G: Range_Edge_Graph[T], v: int) =
        assert 0 <= v and v < G.n

    proc connectRangeToVertex[T](G: Range_Edge_Graph[T], idx, l, r, to: int, cost: T) =
        let node = G.nodes[idx]
        if r <= node.l or node.r <= l:
            return
        if l <= node.l and node.r <= r:
            G.G.add_edge(node.outId, to, cost)
            return
        G.connectRangeToVertex(node.left, l, r, to, cost)
        G.connectRangeToVertex(node.right, l, r, to, cost)

    proc connectVertexToRange[T](G: Range_Edge_Graph[T], src, idx, l, r: int, cost: T) =
        let node = G.nodes[idx]
        if r <= node.l or node.r <= l:
            return
        if l <= node.l and node.r <= r:
            G.G.add_edge(src, node.inId, cost)
            return
        G.connectVertexToRange(src, node.left, l, r, cost)
        G.connectVertexToRange(src, node.right, l, r, cost)

    proc add_range_to_range_edge*[T](G: Range_Edge_Graph[T], from_l, from_r, to_l, to_r: int, cost: T) =
        G.validateRange(from_l, from_r)
        G.validateRange(to_l, to_r)
        if from_l == from_r or to_l == to_r:
            return

        let fromNode = G.G.len
        let toNode = G.G.len + 1
        G.G.len += 2
        G.G.edges.add(newSeq[(int32, T)]())
        G.G.edges.add(newSeq[(int32, T)]())
        G.connectRangeToVertex(G.root, from_l, from_r, fromNode, G.zero)
        G.G.add_edge(fromNode, toNode, cost)
        G.connectVertexToRange(toNode, G.root, to_l, to_r, G.zero)

    proc add_edge*[T](G: Range_Edge_Graph[T], from_l, from_r, to_l, to_r: int, cost: T) =
        G.add_range_to_range_edge(from_l, from_r, to_l, to_r, cost)

    proc add_point_to_range_edge*[T](G: Range_Edge_Graph[T], src, to_l, to_r: int, cost: T) =
        G.validatePoint(src)
        G.validateRange(to_l, to_r)
        if to_l == to_r:
            return
        G.connectVertexToRange(src, G.root, to_l, to_r, cost)

    proc add_range_to_point_edge*[T](G: Range_Edge_Graph[T], from_l, from_r, to: int, cost: T) =
        G.validateRange(from_l, from_r)
        G.validatePoint(to)
        if from_l == from_r:
            return
        G.connectRangeToVertex(G.root, from_l, from_r, to, cost)

    proc add_point_to_point_edge*[T](G: Range_Edge_Graph[T], src, to: int, cost: T) =
        G.validatePoint(src)
        G.validatePoint(to)
        G.G.add_edge(src, to, cost)

    proc add_edge*[T](G: Range_Edge_Graph[T], src, to: int, cost: T) =
        G.add_point_to_point_edge(src, to, cost)
