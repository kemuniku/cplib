when not declared CPLIB_STR_RUN_ENUMERATE:
    const CPLIB_STR_RUN_ENUMERATE* = 1
    import std/algorithm
    import std/sequtils
    import cplib/str/zalgorithm

    proc run_cmp(a, b: (int, int, int)): int =
        if a[0] != b[0]:
            return cmp(a[0], b[0])
        if a[1] != b[1]:
            return cmp(a[1], b[1])
        return cmp(a[2], b[2])

    proc run_enumerate_impl[T](a: seq[T]): seq[(int, int, int)] =
        let n = a.len
        var raw = newSeq[(int, int, int)]()

        proc dfs(l, r: int) =
            if r - l <= 1:
                return
            let m = (l + r) shr 1
            dfs(l, m)
            dfs(m, r)

            var sl = newSeq[T]()
            for i in countdown(m - 1, l):
                sl.add(a[i])
            for i in countdown(r - 1, l):
                sl.add(a[i])

            var sr = newSeq[T]()
            for i in m..<r:
                sr.add(a[i])
            for i in l..<r:
                sr.add(a[i])

            let zsl = zalgorithm(sl)
            let zsr = zalgorithm(sr)

            for p in 1..(m - l):
                let
                    ml = max(l, m - p - zsl[p])
                    mr = min(r, m + zsr[r - l - p])
                if mr - ml >= 2 * p and
                        (ml == 0 or a[ml - 1] != a[ml + p - 1]) and
                        (mr == n or a[mr] != a[mr - p]):
                    raw.add((ml, mr, p))

            for p in 1..(r - m):
                let
                    ml = max(l, m - zsl[r - l - p])
                    mr = min(r, m + p + zsr[p])
                if mr - ml >= 2 * p and
                        (ml == 0 or a[ml - 1] != a[ml + p - 1]) and
                        (mr == n or a[mr] != a[mr - p]):
                    raw.add((ml, mr, p))

        dfs(0, n)

        raw.sort(run_cmp)
        var prev_l = -1
        var prev_r = -1
        for (l, r, p) in raw:
            if l == prev_l and r == prev_r:
                continue
            result.add((p, l, r))
            prev_l = l
            prev_r = r
        result.sort(run_cmp)

    proc run_enumerate*[T](s: openArray[T]): seq[(int, int, int)] =
        ## Enumerates runs as (period, l, r), where the interval is [l, r).
        return run_enumerate_impl(s.toSeq)

    proc run_enumerate*(s: string): seq[(int, int, int)] =
        ## Enumerates runs as (period, l, r), where the interval is [l, r).
        return run_enumerate_impl(s.toSeq)

    proc RunEnumerate*[T](s: openArray[T]): seq[(int, int, int)] =
        return run_enumerate(s)

    proc RunEnumerate*(s: string): seq[(int, int, int)] =
        return run_enumerate(s)
