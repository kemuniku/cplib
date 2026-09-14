when not declared CPLIB_UTILS_PROJECT_SELECTION:
    const CPLIB_UTILS_PROJECT_SELECTION* = 1
    import cplib/graph/maxflow

    type
        ProjectSelectionTermKind = enum
            psUnary, psPair, psAllGain, psForce, psImply
        ProjectSelectionTerm[Cost] = object
            kind: ProjectSelectionTermKind
            i, j: int
            value: bool
            costs: array[4, Cost]
            ids: seq[int]
        ProjectSelection*[Cost] = object
            n: int
            terms: seq[ProjectSelectionTerm[Cost]]
        ProjectSelectionResult*[Cost] = object
            feasible*: bool
            min_cost*: Cost
            assignment*: seq[bool]

    proc psAdd[Cost: SomeSignedInt](a, b: Cost): Cost =
        ## 加算のオーバーフローを検査する。O(1)。
        if (b > 0 and a > high(Cost) - b) or (b < 0 and a < low(Cost) - b):
            raise newException(OverflowDefect, "ProjectSelectionの加算が容量型の範囲を超えます")
        a + b

    proc psSub[Cost: SomeSignedInt](a, b: Cost): Cost =
        ## 減算のオーバーフローを検査する。O(1)。
        if (b > 0 and a < low(Cost) + b) or (b < 0 and a > high(Cost) + b):
            raise newException(OverflowDefect, "ProjectSelectionの減算が容量型の範囲を超えます")
        a - b

    proc initProjectSelection*(n: int, costType: typedesc[SomeSignedInt] = int): ProjectSelection[costType] =
        ## n個の二値変数を作る。費用－利益を最小化する。costTypeの省略時はint。O(1)。
        if n < 0:
            raise newException(ValueError, "変数の個数は非負である必要があります")
        result.n = n

    proc psCheckIndex[Cost](opt: ProjectSelection[Cost], i: int) =
        ## 元の変数の添字を検査する。O(1)。
        if i < 0 or i >= opt.n:
            raise newException(ValueError, "変数番号が範囲外です: " & $i)

    proc psCheckWeight[Cost](w: Cost) =
        ## 費用・利益の大きさを検査する。O(1)。
        if w < 0:
            raise newException(ValueError, "費用・利益の大きさは非負である必要があります")

    proc add_unary_cost*[Cost](opt: var ProjectSelection[Cost], i: int, c0, c1: Cost) =
        ## x[i]がfalse/trueのときの費用c0/c1を加算する。負値も可。償却O(1)。
        opt.psCheckIndex(i)
        opt.terms.add(ProjectSelectionTerm[Cost](kind: psUnary, i: i, costs: [c0, c1, Cost(0), Cost(0)]))

    proc add_cost*[Cost](opt: var ProjectSelection[Cost], i: int, value: bool, w: Cost) =
        ## x[i] == valueのとき費用wを加算する。負値は利益となる。償却O(1)。
        if value: opt.add_unary_cost(i, Cost(0), w)
        else: opt.add_unary_cost(i, w, Cost(0))

    proc add_gain*[Cost](opt: var ProjectSelection[Cost], i: int, value: bool, w: Cost) =
        ## x[i] == valueのとき利益wを加算する。負値は費用となる。償却O(1)。
        opt.add_cost(i, value, psSub(Cost(0), w))

    proc add_pair_cost*[Cost](opt: var ProjectSelection[Cost], i, j: int, c00, c01, c10, c11: Cost) =
        ## (x[i],x[j])の4通りの費用を加算する。劣モジュラ性が必要。償却O(1)。
        opt.psCheckIndex(i)
        opt.psCheckIndex(j)
        if i == j:
            opt.add_unary_cost(i, c00, c11)
            return
        let a = psSub(c01, c00)
        let b = psSub(c11, c10)
        if a < b:
            raise newException(ValueError, "変数 " & $i & ", " & $j &
                " のコスト表が劣モジュラ条件 c00 + c11 <= c01 + c10 を満たしません: " &
                $[c00, c01, c10, c11])
        discard psSub(a, b)
        opt.terms.add(ProjectSelectionTerm[Cost](kind: psPair, i: i, j: j, costs: [c00, c01, c10, c11]))

    proc add_cost_if_true_false*[Cost](opt: var ProjectSelection[Cost], i, j: int, w: Cost) =
        ## x[i]がtrueかつx[j]がfalseなら非負の費用wを加算する。償却O(1)。
        psCheckWeight(w)
        opt.add_pair_cost(i, j, Cost(0), Cost(0), w, Cost(0))

    proc add_cost_if_different*[Cost](opt: var ProjectSelection[Cost], i, j: int, w: Cost) =
        ## x[i] != x[j]なら非負の費用wを加算する。償却O(1)。
        psCheckWeight(w)
        opt.add_pair_cost(i, j, Cost(0), w, w, Cost(0))

    proc add_gain_if_all*[Cost](opt: var ProjectSelection[Cost], ids: openArray[int], value: bool, w: Cost) =
        ## 全変数がvalueなら非負の利益wを加算する。空集合なら常に利益。2変数以下は補助頂点不要。O(|ids|)。
        psCheckWeight(w)
        for i in ids: opt.psCheckIndex(i)
        if w == 0: return
        if ids.len == 1:
            opt.add_gain(ids[0], value, w)
        elif ids.len == 2:
            if value:
                opt.add_pair_cost(ids[0], ids[1], Cost(0), Cost(0), Cost(0), -w)
            else:
                opt.add_pair_cost(ids[0], ids[1], -w, Cost(0), Cost(0), Cost(0))
        else:
            opt.terms.add(ProjectSelectionTerm[Cost](kind: psAllGain, value: value, costs: [w, Cost(0), Cost(0), Cost(0)], ids: @ids))

    proc force*[Cost](opt: var ProjectSelection[Cost], i: int, value: bool) =
        ## x[i]をvalueに固定する。償却O(1)。
        opt.psCheckIndex(i)
        opt.terms.add(ProjectSelectionTerm[Cost](kind: psForce, i: i, value: value))

    proc imply*[Cost](opt: var ProjectSelection[Cost], i, j: int) =
        ## x[i]がtrueならx[j]もtrueとなる制約を追加する。償却O(1)。
        ## x[i]がfalseならx[j]もfalseをやりたいなら、imply(j,i)でok
        opt.psCheckIndex(i)
        opt.psCheckIndex(j)
        opt.terms.add(ProjectSelectionTerm[Cost](kind: psImply, i: i, j: j))

    proc equal*[Cost](opt: var ProjectSelection[Cost], i, j: int) =
        ## x[i] == x[j]となる制約を追加する。償却O(1)。
        opt.psCheckIndex(i)
        opt.psCheckIndex(j)
        opt.imply(i, j)
        opt.imply(j, i)

    proc solve*[Cost](opt: ProjectSelection[Cost]): ProjectSelectionResult[Cost] =
        ## 最小費用と割当を返す。矛盾時はfeasible=falseで他の値は無効。補助頂点込みでO(V^2 E)。再実行可。
        let source = opt.n
        let sink = opt.n + 1
        var vertexCount = opt.n + 2
        var edges: seq[tuple[src, dst: int, cap: Cost]]
        var hardEdges: seq[tuple[src, dst: int]]
        var offset = Cost(0)
        var total = Cost(0)
        proc edge(src, dst: int, cap: Cost) =
            ## 有限容量の辺とその総和を記録する。償却O(1)。
            if src != dst and cap > 0:
                total = psAdd(total, cap)
                edges.add((src, dst, cap))
        proc unary(i: int, c0, c1: Cost) =
            ## 単項費用を定数と非負容量に分解する。償却O(1)。
            offset = psAdd(offset, min(c0, c1))
            if c0 <= c1: edge(i, sink, psSub(c1, c0))
            else: edge(source, i, psSub(c0, c1))
        for term in opt.terms:
            let c = term.costs
            case term.kind
            of psUnary:
                unary(term.i, c[0], c[1])
            of psPair:
                offset = psAdd(offset, c[0])
                unary(term.i, Cost(0), psSub(c[3], c[1]))
                unary(term.j, Cost(0), psSub(c[1], c[0]))
                edge(term.i, term.j, psSub(psSub(c[1], c[0]), psSub(c[3], c[2])))
            of psAllGain:
                if c[0] == 0: continue
                if term.ids.len == 0:
                    offset = psSub(offset, c[0])
                else:
                    let aux = vertexCount
                    inc vertexCount
                    if term.value:
                        unary(aux, Cost(0), -c[0])
                        for i in term.ids: hardEdges.add((aux, i))
                    else:
                        unary(aux, -c[0], Cost(0))
                        for i in term.ids: hardEdges.add((i, aux))
            of psForce:
                if term.value: hardEdges.add((source, term.i))
                else: hardEdges.add((term.i, sink))
            of psImply:
                if term.i != term.j: hardEdges.add((term.i, term.j))
        var infinity = Cost(0)
        if hardEdges.len > 0:
            infinity = psAdd(total, Cost(1))
        var graph = initMaxFlow[Cost](vertexCount)
        for e in edges: graph.add_edge(e.src, e.dst, e.cap)
        for e in hardEdges: graph.add_edge(e.src, e.dst, infinity)
        let limit = if hardEdges.len > 0: infinity else: total
        let flow = graph.flow(source, sink, limit)
        if hardEdges.len > 0 and flow == infinity:
            return
        result.feasible = true
        result.min_cost = psAdd(offset, flow)
        let cut = graph.min_cut(source)
        result.assignment = newSeq[bool](opt.n)
        for i in 0..<opt.n: result.assignment[i] = cut[i]
