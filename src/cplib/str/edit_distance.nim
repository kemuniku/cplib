when not declared CPLIB_STR_EDIT_DISTANCE:
    const CPLIB_STR_EDIT_DISTANCE* = 1

    import atcoder/string
    import cplib/collections/staticRMQ

    proc editDistance*(S, T: openArray[char]): int =
        ## Returns the Levenshtein distance between `S` and `T`.
        ##
        ## Insertion, deletion, and substitution all have cost one.
        ## If the answer is `k`, the time complexity is
        ## O(S.len + T.len + k^2), and the memory complexity is
        ## O(S.len + T.len + k).
        let n = S.len
        let m = T.len

        # The zero between the strings is a separator; characters are shifted
        # by one, so it cannot occur in either string.
        var joined = newSeq[int](n + 1 + m)
        for i in 0..<n:
            joined[i] = S[i].int + 1
        for i in 0..<m:
            joined[n + 1 + i] = T[i].int + 1

        let sa = suffix_array(joined, 256)
        let lcpArray = lcp_array(joined, sa)
        let rmq = initRMQ(lcpArray)
        var rank = newSeq[int](joined.len)
        for i, p in sa:
            rank[p] = i

        proc lcp(i, j: int): int =
            if i == n or j == m:
                return 0
            var ri = rank[i]
            var rj = rank[n + 1 + j]
            if ri > rj:
                swap(ri, rj)
            result = min(min(n - i, m - j), rmq.query(ri, rj))

        const unreachable = int.low div 4
        let offset = max(n, m) + 1
        var previous = newSeq[int](2 * offset + 1)
        var current = newSeq[int](2 * offset + 1)
        for i in 0..<previous.len:
            previous[i] = unreachable
            current[i] = unreachable

        previous[offset] = lcp(0, 0)
        if previous[offset] == n and n == m:
            return 0

        for d in 1..max(n, m):
            for diagonal in -d..d:
                var furthest = unreachable

                # Delete S[x]: (x, y) -> (x + 1, y).
                let deletionSource = previous[offset + diagonal - 1]
                if deletionSource != unreachable:
                    let y = deletionSource - (diagonal - 1)
                    if deletionSource < n and y >= 0 and y <= m:
                        furthest = max(furthest, deletionSource + 1)

                # Substitute S[x] with T[y]: (x, y) -> (x + 1, y + 1).
                let substitutionSource = previous[offset + diagonal]
                if substitutionSource != unreachable:
                    let y = substitutionSource - diagonal
                    if substitutionSource < n and y >= 0 and y < m:
                        furthest = max(furthest, substitutionSource + 1)

                # Insert T[y]: (x, y) -> (x, y + 1).
                let insertionSource = previous[offset + diagonal + 1]
                if insertionSource != unreachable:
                    let y = insertionSource - (diagonal + 1)
                    if insertionSource >= 0 and insertionSource <= n and y < m:
                        furthest = max(furthest, insertionSource)

                if furthest != unreachable:
                    let y = furthest - diagonal
                    if y >= 0 and y <= m:
                        furthest += lcp(furthest, y)
                        current[offset + diagonal] = furthest
                        if diagonal == n - m and furthest == n:
                            return d

            swap(previous, current)
            for diagonal in -d..d:
                current[offset + diagonal] = unreachable

        # The loop always reaches the endpoint after at most max(n, m) edits.
        doAssert false
        return -1
