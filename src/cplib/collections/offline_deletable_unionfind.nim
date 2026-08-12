when not declared CPLIB_COLLECTIONS_OFFLINE_DELETABLE_UNIONFIND:
    const CPLIB_COLLECTIONS_OFFLINE_DELETABLE_UNIONFIND* = 1
    import tables
    import cplib/collections/rollback_unionfind

    type
        OfflineDeletableUnionFindQueryKind* = enum
            connectivityQuery, sizeQuery, countQuery
        OfflineDeletableUnionFindOperationKind = enum
            addOperation, deleteOperation, queryOperation
        Edge = tuple[u, v: int]
        Operation = object
            case kind: OfflineDeletableUnionFindOperationKind
            of addOperation, deleteOperation:
                edge: Edge
            of queryOperation:
                queryId: int
        OfflineDeletableUnionFindQuery = object
            kind: OfflineDeletableUnionFindQueryKind
            u, v: int
        OfflineDeletableUnionFindResult* = object
            ## `value` is 0/1 for connectivity queries, the component size for
            ## size queries, and the number of components for count queries.
            kind*: OfflineDeletableUnionFindQueryKind
            value*: int
        OfflineDeletableUnionFind* = object
            n: int
            operations: seq[Operation]
            queries: seq[OfflineDeletableUnionFindQuery]
            edgeCount: Table[Edge, int]

    proc normalizedEdge(u, v: int): Edge =
        if u <= v: (u, v) else: (v, u)

    proc checkVertex(self: OfflineDeletableUnionFind, v: int) =
        assert 0 <= v and v < self.n, "vertex index is out of range"

    proc initOfflineDeletableUnionFind*(n: int): OfflineDeletableUnionFind =
        assert n >= 0, "the number of vertices must be non-negative"
        result.n = n
        result.edgeCount = initTable[Edge, int]()

    proc len*(self: OfflineDeletableUnionFind): int = self.n

    proc addEdge*(self: var OfflineDeletableUnionFind, u, v: int) =
        ## Adds one copy of the undirected edge `(u, v)`.
        self.checkVertex(u)
        self.checkVertex(v)
        let edge = normalizedEdge(u, v)
        self.operations.add(Operation(kind: addOperation, edge: edge))
        self.edgeCount[edge] = self.edgeCount.getOrDefault(edge) + 1

    proc deleteEdge*(self: var OfflineDeletableUnionFind, u, v: int) =
        ## Deletes one copy of `(u, v)`. Parallel edges are supported.
        self.checkVertex(u)
        self.checkVertex(v)
        let edge = normalizedEdge(u, v)
        assert self.edgeCount.getOrDefault(edge) > 0, "cannot delete an edge that does not exist"
        self.operations.add(Operation(kind: deleteOperation, edge: edge))
        dec self.edgeCount[edge]

    proc addConnectivityQuery*(self: var OfflineDeletableUnionFind, u, v: int): int {.discardable.} =
        self.checkVertex(u)
        self.checkVertex(v)
        result = self.queries.len
        self.queries.add(OfflineDeletableUnionFindQuery(kind: connectivityQuery, u: u, v: v))
        self.operations.add(Operation(kind: queryOperation, queryId: result))

    proc addSizeQuery*(self: var OfflineDeletableUnionFind, v: int): int {.discardable.} =
        self.checkVertex(v)
        result = self.queries.len
        self.queries.add(OfflineDeletableUnionFindQuery(kind: sizeQuery, u: v))
        self.operations.add(Operation(kind: queryOperation, queryId: result))

    proc addCountQuery*(self: var OfflineDeletableUnionFind): int {.discardable.} =
        result = self.queries.len
        self.queries.add(OfflineDeletableUnionFindQuery(kind: countQuery))
        self.operations.add(Operation(kind: queryOperation, queryId: result))

    proc solve*(self: OfflineDeletableUnionFind): seq[OfflineDeletableUnionFindResult] =
        ## Evaluates all recorded queries in chronological order.
        let q = self.operations.len
        var answers = newSeq[OfflineDeletableUnionFindResult](self.queries.len)
        if q == 0: return answers

        var seg = newSeq[seq[Edge]](q * 4)
        var starts = initTable[Edge, int]()
        var multiplicity = initTable[Edge, int]()

        proc addInterval(node, left, right, queryLeft, queryRight: int, edge: Edge) =
            if queryRight <= left or right <= queryLeft: return
            if queryLeft <= left and right <= queryRight:
                seg[node].add(edge)
                return
            let mid = (left + right) shr 1
            addInterval(node shl 1, left, mid, queryLeft, queryRight, edge)
            addInterval(node shl 1 or 1, mid, right, queryLeft, queryRight, edge)

        for time, operation in self.operations:
            case operation.kind
            of addOperation:
                let count = multiplicity.getOrDefault(operation.edge)
                if count == 0: starts[operation.edge] = time
                multiplicity[operation.edge] = count + 1
            of deleteOperation:
                let count = multiplicity.getOrDefault(operation.edge)
                assert count > 0
                if count == 1:
                    addInterval(1, 0, q, starts[operation.edge], time, operation.edge)
                    starts.del(operation.edge)
                multiplicity[operation.edge] = count - 1
            of queryOperation:
                discard
        for edge, start in starts:
            addInterval(1, 0, q, start, q, edge)

        var uf = initRollbackUnionFind(self.n)
        var componentCount = self.n
        proc dfs(node, left, right: int) =
            let state = uf.getState
            let oldComponentCount = componentCount
            for edge in seg[node]:
                if uf.unite(edge.u, edge.v): dec componentCount
            if right - left == 1:
                let operation = self.operations[left]
                if operation.kind == queryOperation:
                    let query = self.queries[operation.queryId]
                    answers[operation.queryId].kind = query.kind
                    case query.kind
                    of connectivityQuery:
                        answers[operation.queryId].value = int(uf.issame(query.u, query.v))
                    of sizeQuery:
                        answers[operation.queryId].value = uf.siz(query.u)
                    of countQuery:
                        answers[operation.queryId].value = componentCount
            else:
                let mid = (left + right) shr 1
                dfs(node shl 1, left, mid)
                dfs(node shl 1 or 1, mid, right)
            uf.rollback(state)
            componentCount = oldComponentCount
        dfs(1, 0, q)
        return answers

    proc connected*(answer: OfflineDeletableUnionFindResult): bool =
        assert answer.kind == connectivityQuery
        answer.value != 0
