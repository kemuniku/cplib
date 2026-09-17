when not declared CPLIB_GRAPH_LOWERBOUND_MAXFLOW:
    const CPLIB_GRAPH_LOWERBOUND_MAXFLOW* = 1
    import cplib/graph/maxflow

    type
        LowerBoundMaxFlowEdge*[Cap] = object
            src*, dst*: int
            lower*, upper*, flow*: Cap
        LowerBoundMaxFlow*[Cap] = object
            n: int
            edges: seq[LowerBoundMaxFlowEdge[Cap]]
            solved: bool

    proc initLowerBoundMaxFlow*[Cap: SomeSignedInt](n: int, capacityZero: Cap = 0): LowerBoundMaxFlow[Cap] =
        ## n頂点の下限流量つき最大流グラフを構築する。容量型の省略時はint。O(1)。
        ## capacityZeroは型推論用。容量型には符号つき整数を指定する。
        assert n >= 0, "nは非負である必要があります"
        result.n = n

    proc add_edge*[Cap](g: var LowerBoundMaxFlow[Cap], src, dst: int, lower, upper: Cap): int {.discardable.} =
        ## 流量の下限lower、上限upperの有向辺を追加し、辺番号を返す。償却O(1)。
        assert src in 0..<g.n and dst in 0..<g.n, "頂点番号が範囲外です"
        assert Cap(0) <= lower and lower <= upper, "0 <= lower <= upperが必要です"
        result = g.edges.len
        g.edges.add(LowerBoundMaxFlowEdge[Cap](src: src, dst: dst, lower: lower, upper: upper))
        g.solved = false

    proc flow*[Cap](g: var LowerBoundMaxFlow[Cap], src, dst: int): Cap =
        ## 下限を満たす非負のsrc-dst最大流量を返す。実現不可能なら-1。O(V^2(V+E))。
        ## 呼び出すたびに最初から計算する。負の流量のみ実現可能な場合も-1を返す。
        ## 各頂点の下限流量の収支の中間値、正の収支の総和、最大流量はCapに収まること。
        assert src in 0..<g.n and dst in 0..<g.n and src != dst, "頂点番号が範囲外か、始点と終点が同じです"
        g.solved = false
        var auxiliary = initMaxFlow[Cap](g.n + 2)
        var balance = newSeq[Cap](g.n)
        for e in g.edges:
            auxiliary.add_edge(e.src, e.dst, e.upper - e.lower)
            if e.src != e.dst:
                balance[e.src] -= e.lower
                balance[e.dst] += e.lower
        let back = auxiliary.add_edge(dst, src, high(Cap))
        var required = Cap(0)
        for v in 0..<g.n:
            if balance[v] > Cap(0):
                auxiliary.add_edge(g.n, v, balance[v])
                required += balance[v]
            elif balance[v] < Cap(0):
                auxiliary.add_edge(v, g.n + 1, -balance[v])
        if auxiliary.flow(g.n, g.n + 1, required) != required:
            return Cap(-1)
        let initial = auxiliary.get_edge(back).flow
        # 補助辺を除き、上下限の範囲内で流量を増減できる残余グラフを構築する。
        var residual = initMaxFlow[Cap](g.n)
        for i, e in g.edges:
            let extra = auxiliary.get_edge(i).flow
            residual.add_edge(e.src, e.dst, e.upper - e.lower - extra)
            residual.add_edge(e.dst, e.src, extra)
        result = initial + residual.flow(src, dst, high(Cap) - initial)
        for i in 0..<g.edges.len:
            g.edges[i].flow = g.edges[i].lower + auxiliary.get_edge(i).flow -
                residual.get_edge(2 * i + 1).flow + residual.get_edge(2 * i).flow
        g.solved = true

    proc get_edge*[Cap](g: LowerBoundMaxFlow[Cap], i: int): LowerBoundMaxFlowEdge[Cap] =
        ## flow成功後のi番目の辺の上下限と流量を返す。辺の追加後は再計算が必要。O(1)。
        assert g.solved, "先にflowで実現可能な流れを求めてください"
        g.edges[i]

    proc get_edges*[Cap](g: LowerBoundMaxFlow[Cap]): seq[LowerBoundMaxFlowEdge[Cap]] =
        ## flow成功後の全辺の上下限と流量を追加順に返す。O(E)。
        assert g.solved, "先にflowで実現可能な流れを求めてください"
        for e in g.edges:
            result.add(e)
