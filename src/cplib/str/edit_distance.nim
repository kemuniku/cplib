when not declared CPLIB_STR_EDIT_DISTANCE:
    const CPLIB_STR_EDIT_DISTANCE* = 1

    import bitops
    import cplib/str/suffix_array

    type EditDistanceRMQ = object
        values: seq[int]
        masks: seq[uint]
        table: seq[seq[int]]
        blockSize: int

    proc initEditDistanceRMQ(values: seq[int]): EditDistanceRMQ =
        ## 長さ N の配列の RMQ を時間・空間 O(N) で構築します。
        result.values = values
        let n = values.len
        result.blockSize = max(1, fastLog2(n))
        let size = result.blockSize
        let blocks = (n + size - 1) div size
        result.masks = newSeq[uint](n)
        result.table = @[newSeq[int](blocks)]
        for b in 0..<blocks:
            let first = b * size
            let last = min(first + size, n)
            var mask = 0'u
            for i in first..<last:
                while mask != 0:
                    let top = fastLog2(mask)
                    if values[first + top] < values[i]:
                        break
                    mask = mask xor (1'u shl top)
                mask = mask or (1'u shl (i - first))
                result.masks[i] = mask
            result.table[0][b] = values[first + countTrailingZeroBits(mask)]
        # ブロック長を Θ(log N) にするため、上位表も O(N) に収まります。
        var k = 1
        while (1 shl k) <= blocks:
            let distance = 1 shl (k - 1)
            var row = newSeq[int](blocks - (1 shl k) + 1)
            for i in 0..<row.len:
                row[i] = min(result.table[k - 1][i], result.table[k - 1][i + distance])
            result.table.add(move(row))
            inc k

    proc inBlock(rmq: EditDistanceRMQ, l, r: int): int {.inline.} =
        ## 同一ブロック内の半開区間 [l, r) の最小値を O(1) で返します。
        let first = l div rmq.blockSize * rmq.blockSize
        let mask = rmq.masks[r - 1] and (high(uint) shl (l - first))
        return rmq.values[first + countTrailingZeroBits(mask)]

    proc query(rmq: EditDistanceRMQ, l, r: int): int {.inline.} =
        ## 空でない半開区間 [l, r) の最小値を O(1) で返します。
        let a = l div rmq.blockSize
        let b = (r - 1) div rmq.blockSize
        if a == b:
            return rmq.inBlock(l, r)
        result = min(rmq.inBlock(l, (a + 1) * rmq.blockSize),
            rmq.inBlock(b * rmq.blockSize, r))
        if a + 1 < b:
            let k = fastLog2(b - a - 1)
            result = min(result, min(rmq.table[k][a + 1], rmq.table[k][b - (1 shl k)]))

    proc editDistance*(s, t: string, k: int): int =
        ## 挿入・削除・置換を各コスト 1 とする編集距離を返します。k を超える場合は -1。
        ## k >= 0 が必要です。string の各バイトを 1 文字として扱います。
        ## 時間 O(|s| + |t| + k^2)、空間 O(|s| + |t| + k)。ハッシュは使いません。
        doAssert k >= 0
        let n = s.len
        let m = t.len
        if abs(n - m) > k:
            return -1
        if n == 0 or m == 0:
            return max(n, m)
        if k == 0:
            return (if s == t: 0 else: -1)

        let joined = s & t
        let sa = suffix_array(joined)
        var rank = newSeq[int](joined.len)
        for i, p in sa:
            rank[p] = i
        let rmq = initEditDistanceRMQ(lcp_array(joined, sa))

        template extend(x, y: int): int =
            ## 両文字列の末尾を越えない共通接頭辞長を O(1) で求めます。
            (if x == n or y == m: 0 else:
                min(min(n - x, m - y),
                    rmq.query(min(rank[x], rank[n + y]), max(rank[x], rank[n + y]))))

        let limit = min(k, max(n, m))
        let offset = limit + 1
        var previous = newSeq[int](2 * limit + 3)
        var current = newSeq[int](previous.len)
        for i in 0..<previous.len:
            previous[i] = -1
        previous[offset] = extend(0, 0)
        if n == m and previous[offset] == n:
            return 0

        # 対角線 d = y - x ごとに、編集回数以下で到達できる最大の x を保持します。
        for edits in 1..limit:
            for i in 0..<current.len:
                current[i] = -1
            for d in -min(edits, n)..min(edits, m):
                let idx = offset + d
                var x = previous[idx]
                if x >= 0 and x < n and x + d < m:
                    inc x
                let insertion = previous[idx - 1]
                if insertion >= 0 and insertion + d - 1 < m:
                    x = max(x, insertion)
                let deletion = previous[idx + 1]
                if deletion >= 0 and deletion < n:
                    x = max(x, deletion + 1)
                if x < 0:
                    continue
                let y = x + d
                x += extend(x, y)
                current[idx] = x
                if d == m - n and x == n:
                    return edits
            swap(previous, current)
        return -1
