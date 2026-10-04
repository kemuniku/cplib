when not declared CPLIB_STR_RUN_ENUMERATE:
    const CPLIB_STR_RUN_ENUMERATE* = 1
    import algorithm
    import sequtils

    proc run_zalgorithm[T](s: openArray[T], prefixLen, count: int, z: var seq[int]) =
        ## 先頭prefixLen要素とのLCPを、必要なcount要素分だけ計算する。
        z.setLen(count)
        z[0] = prefixLen
        var i = 1
        var j = 0
        while i < count:
            while j < prefixLen and i + j < s.len and s[j] == s[i + j]:
                inc j
            z[i] = j
            if j == 0:
                inc i
                continue
            var k = 1
            while i + k < count and k + z[k] < j:
                z[i + k] = z[k]
                inc k
            i += k
            j -= k

    proc run_cmp(a, b: (int, int, int)): int =
        ## 三つ組を辞書順で比較する。
        if a[0] != b[0]:
            return cmp(a[0], b[0])
        if a[1] != b[1]:
            return cmp(a[1], b[1])
        return cmp(a[2], b[2])

    proc run_enumerate_impl[T](a: seq[T]): seq[(int, int, int)] =
        ## 分割統治で極大な繰り返し区間を列挙する。
        let n = a.len
        if n <= 1:
            return
        var raw = newSeq[(int, int, int)]()

        # 子の処理後に使うため、全ノードで作業領域を共有できる。
        var sl = newSeqOfCap[T](n + (n + 1) div 2)
        var zsl = newSeqOfCap[int](n)
        var zsr = newSeqOfCap[int](n)

        proc add_run(l, r, p: int) =
            ## 同一区間の連続候補は最小周期だけを残す。
            if raw.len > 0 and raw[^1][0] == l and raw[^1][1] == r:
                raw[^1][2] = min(raw[^1][2], p)
            else:
                raw.add((l, r, p))

        proc dfs(l, r: int) =
            ## 中点をまたぐ候補を左右のLCPから求める。
            if r - l <= 1:
                return
            if r - l == 2:
                if a[l] == a[l + 1] and
                        (l == 0 or a[l - 1] != a[l]) and
                        (r == n or a[r] != a[l]):
                    add_run(l, r, 1)
                return
            let m = (l + r) shr 1
            dfs(l, m)
            dfs(m, r)

            sl.setLen(0)
            for i in countdown(m - 1, l):
                sl.add(a[i])
            for i in countdown(r - 1, l):
                sl.add(a[i])

            # LCPは左右の区間長で切り詰められ、参照する添字はr-l未満。
            run_zalgorithm(sl, m - l, r - l, zsl)
            sl.setLen(0)
            for i in m..<r:
                sl.add(a[i])
            for i in l..<r:
                sl.add(a[i])
            run_zalgorithm(sl, r - m, r - l, zsr)

            for p in 1..(m - l):
                let
                    ml = max(l, m - p - zsl[p])
                    mr = min(r, m + zsr[r - l - p])
                if mr - ml >= 2 * p and
                        (ml == 0 or a[ml - 1] != a[ml + p - 1]) and
                        (mr == n or a[mr] != a[mr - p]):
                    add_run(ml, mr, p)

            for p in 1..(r - m):
                let
                    ml = max(l, m - zsl[r - l - p])
                    mr = min(r, m + p + zsr[p])
                if mr - ml >= 2 * p and
                        (ml == 0 or a[ml - 1] != a[ml + p - 1]) and
                        (mr == n or a[mr] != a[mr - p]):
                    add_run(ml, mr, p)

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
        ## runを(最小周期, l, r)の辞書順で列挙する。区間は[l, r)。O(n log^2 n)。
        return run_enumerate_impl(s.toSeq)

    proc run_enumerate*(s: string): seq[(int, int, int)] =
        ## runを(最小周期, l, r)の辞書順で列挙する。区間は[l, r)。O(n log^2 n)。
        return run_enumerate_impl(s.toSeq)

    proc RunEnumerate*[T](s: openArray[T]): seq[(int, int, int)] =
        ## run_enumerateと同じ結果を返す。
        return run_enumerate(s)

    proc RunEnumerate*(s: string): seq[(int, int, int)] =
        ## run_enumerateと同じ結果を返す。
        return run_enumerate(s)
