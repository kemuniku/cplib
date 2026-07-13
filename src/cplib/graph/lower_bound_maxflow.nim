when not declared CPLIB_GRAPH_LOWERBOUNDMAXFLOW:
    const CPLIB_GRAPH_LOWERBOUNDMAXFLOW* = 1

    import atcoder/maxflow

    type
        LowerBoundMFEdge*[Cap] = object
            src*, dst*: int
            lower*, upper*, flow*: Cap

        LowerBoundMaxFlow*[Cap] = object
            n: int
            graph: MFGraph[Cap]
            balance: seq[Cap]
            lower: seq[Cap]
            solved: bool

    proc init_lower_bound_maxflow*[Cap](n: int): LowerBoundMaxFlow[Cap] =
        assert n >= 0
        result.n = n
        result.graph = init_mf_graph[Cap](n + 2)
        result.balance = newSeq[Cap](n)

    proc add_edge*[Cap](self: var LowerBoundMaxFlow[Cap], src, dst: int,
            lower, upper: Cap): int {.discardable.} =
        ## Adds an edge whose flow must be in [lower, upper].
        assert not self.solved
        assert src in 0..<self.n
        assert dst in 0..<self.n
        assert Cap(0) <= lower and lower <= upper
        result = self.graph.add_edge(src, dst, upper - lower)
        self.lower.add(lower)
        self.balance[src] -= lower
        self.balance[dst] += lower

    proc flow*[Cap](self: var LowerBoundMaxFlow[Cap], s, t: int):
            tuple[feasible: bool, value: Cap] =
        ## Finds a maximum s-t flow satisfying every lower and upper bound.
        ## This procedure may be called only once for each graph.
        assert not self.solved
        assert s in 0..<self.n
        assert t in 0..<self.n
        assert s != t
        self.solved = true

        let auxiliaryEdge = self.graph.add_edge(t, s, Cap.high)
        var demandEdges: seq[int]
        var required = Cap(0)
        let superSource = self.n
        let superSink = self.n + 1
        for v in 0..<self.n:
            if self.balance[v] > Cap(0):
                demandEdges.add(self.graph.add_edge(superSource, v, self.balance[v]))
                required += self.balance[v]
            elif self.balance[v] < Cap(0):
                demandEdges.add(self.graph.add_edge(v, superSink, -self.balance[v]))

        if self.graph.flow(superSource, superSink) != required:
            return (false, Cap(0))

        let baseFlow = self.graph.get_edge(auxiliaryEdge).flow
        for edgeId in demandEdges:
            self.graph.change_edge(edgeId, Cap(0), Cap(0))
        self.graph.change_edge(auxiliaryEdge, Cap(0), Cap(0))
        result = (true, baseFlow + self.graph.flow(s, t))

    proc get_edge*[Cap](self: LowerBoundMaxFlow[Cap], i: int):
            LowerBoundMFEdge[Cap] =
        ## Returns an original edge. `flow` is valid after a feasible flow call.
        assert i in 0..<self.lower.len
        let edge = self.graph.get_edge(i)
        result = LowerBoundMFEdge[Cap](src: edge.src, dst: edge.dst,
            lower: self.lower[i], upper: self.lower[i] + edge.cap,
            flow: self.lower[i] + edge.flow)

    proc edges*[Cap](self: LowerBoundMaxFlow[Cap]): seq[LowerBoundMFEdge[Cap]] =
        result = newSeqOfCap[LowerBoundMFEdge[Cap]](self.lower.len)
        for i in 0..<self.lower.len:
            result.add(self.get_edge(i))
