when not declared CPLIB_UTILS_ROLLBACK_MO:
    const CPLIB_UTILS_ROLLBACK_MO* = 1
    import std/[algorithm, math]

    type
        RollbackMoQuery = tuple[l, r, idx: int]
        RollbackMo* = object
            ## Mo's algorithm for data structures which support rollback.
            ## Every query represents the half-open interval [l, r).
            width*: int
            N, Q: int
            queries: seq[RollbackMoQuery]

    proc initRollbackMo*(N, Q: int,
            width = max(1, int(float(N) / max(1.0, sqrt(float(Q)))))): RollbackMo =
        ## Creates a solver for an array of length `N` and at most `Q` queries.
        doAssert N >= 0
        doAssert Q >= 0
        doAssert width > 0
        result.N = N
        result.Q = Q
        result.width = width
        result.queries = newSeqOfCap[RollbackMoQuery](Q)

    proc insert*(self: var RollbackMo, l, r: int) =
        ## Adds [l, r). Answers are indexed in insertion order.
        doAssert 0 <= l and l <= r and r <= self.N
        doAssert self.queries.len < self.Q
        self.queries.add((l, r, self.queries.len))

    proc run*[ADD, SNAPSHOT, ROLLBACK, REM](self: var RollbackMo,
            add: ADD, snapshot: SNAPSHOT, rollback: ROLLBACK, rem: REM) =
        ## Runs all inserted queries.
        ##
        ## `add(i)` inserts element i into the current state. `snapshot()`
        ## returns an arbitrary state token, and `rollback(token)` restores it.
        ## `rem(queryIndex)` records the answer for the current state.
        var queries = self.queries
        let width = self.width
        queries.sort(proc(a, b: RollbackMoQuery): int =
            let ab = a.l div width
            let bb = b.l div width
            if ab != bb: cmp(ab, bb)
            else: cmp(a.r, b.r)
        )

        var first = 0
        while first < queries.len:
            let blockId = queries[first].l div self.width
            let blockEnd = min(self.N, (blockId + 1) * self.width)
            var last = first + 1
            while last < queries.len and queries[last].l div self.width == blockId:
                last.inc

            # Queries contained in the left block are handled independently.
            var pos = first
            while pos < last and queries[pos].r <= blockEnd:
                let state = snapshot()
                for i in queries[pos].l..<queries[pos].r:
                    add(i)
                rem(queries[pos].idx)
                rollback(state)
                pos.inc

            # The right part only grows. The left part is rolled back per query.
            let blockState = snapshot()
            var right = blockEnd
            while pos < last:
                while right < queries[pos].r:
                    add(right)
                    right.inc
                let state = snapshot()
                for i in countdown(blockEnd - 1, queries[pos].l):
                    add(i)
                rem(queries[pos].idx)
                rollback(state)
                pos.inc
            rollback(blockState)
            first = last
