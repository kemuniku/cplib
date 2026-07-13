when not declared CPLIB_UTILS_ROLLBACK_MO_DELETE:
    const CPLIB_UTILS_ROLLBACK_MO_DELETE* = 1
    import std/[algorithm, math]

    type
        RollbackMoDeleteQuery = tuple[l, r, idx: int]
        RollbackMoDelete* = object
            ## Rollback Mo for states which support deletion, but not insertion.
            ## Every query represents the half-open interval [l, r).
            width*: int
            N, Q: int
            queries: seq[RollbackMoDeleteQuery]

    proc initRollbackMoDelete*(N, Q: int,
            width = max(1, int(float(N) / max(1.0, sqrt(float(Q)))))): RollbackMoDelete =
        ## Creates a solver for an array of length `N` and at most `Q` queries.
        doAssert N >= 0
        doAssert Q >= 0
        doAssert width > 0
        result.N = N
        result.Q = Q
        result.width = width
        result.queries = newSeqOfCap[RollbackMoDeleteQuery](Q)

    proc insert*(self: var RollbackMoDelete, l, r: int) =
        ## Adds [l, r). Answers are indexed in insertion order.
        doAssert 0 <= l and l <= r and r <= self.N
        doAssert self.queries.len < self.Q
        self.queries.add((l, r, self.queries.len))

    proc run*[DEL, SNAPSHOT, ROLLBACK, REM](self: var RollbackMoDelete,
            del: DEL, snapshot: SNAPSHOT, rollback: ROLLBACK, rem: REM) =
        ## Runs all inserted queries. The initial state must contain [0, N).
        ##
        ## `del(i)` removes element i from the current state. `snapshot()`
        ## returns an arbitrary state token, and `rollback(token)` restores it.
        ## `rem(queryIndex)` records the answer for the current state. On return,
        ## the initial state containing every element has been restored.
        var queries = self.queries
        let width = self.width
        queries.sort(proc(a, b: RollbackMoDeleteQuery): int =
            let ab = a.l div width
            let bb = b.l div width
            if ab != bb: cmp(ab, bb)
            else: cmp(b.r, a.r)
        )

        var first = 0
        while first < queries.len:
            let blockId = queries[first].l div width
            let blockStart = blockId * width
            var last = first + 1
            while last < queries.len and queries[last].l div width == blockId:
                last.inc

            let blockState = snapshot()
            for i in 0..<blockStart:
                del(i)

            # The suffix only grows as right moves to the left. Deletions in the
            # left block are temporary and are rolled back after each query.
            var right = self.N
            for pos in first..<last:
                while right > queries[pos].r:
                    right.dec
                    del(right)
                let state = snapshot()
                for i in blockStart..<queries[pos].l:
                    del(i)
                rem(queries[pos].idx)
                rollback(state)

            rollback(blockState)
            first = last
