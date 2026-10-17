when not declared CPLIB_FPS_BERLEKAMP_MASSEY:
    const CPLIB_FPS_BERLEKAMP_MASSEY* = 1

    import cplib/modint/modint

    # 長さと各段のループ範囲で添字が配列内にあることを保証する。
    {.push boundChecks: off.}
    proc berlekampMassey*[T: BarrettModint or MontgomeryModint](
            a: seq[T]): seq[T] =
        ## 与えられた数列に対する最小次数dの線形漸化式の係数cを返す。
        ## d <= n < a.lenで a[n] = sum(c[i] * a[n-i-1], i=0..<d)。
        ## 法は素数であること。時間計算量O(a.len^2)、空間計算量O(a.len)。
        ## 空列・全零列には空列を返す。末尾の零係数も次数の一部として保持する。
        ## 元の数列が次数dの漸化式に従う場合、先頭2d項あれば復元できる。
        ## 戻り値が空でなければ、a[0..<c.len]とcをlinearRecurrenceKthに渡せる。
        var connection = @[init(T, 1)]
        var previous = @[init(T, 1)]
        var order = 0
        var shift = 1
        var previousInverse = init(T, 1)
        for n in 0..<a.len:
            var discrepancy = a[n]
            for i in 1..order:
                discrepancy += connection[i] * a[n - i]
            if discrepancy.val == 0:
                inc shift
                continue

            let grows = 2 * order <= n
            # 次数が増える場合だけ更新前の独立したコピーを保持する。
            var oldConnection: seq[T]
            if grows: oldConnection = connection
            let scale = discrepancy * previousInverse
            if connection.len < previous.len + shift:
                connection.setLen(previous.len + shift)
            for i in 0..<previous.len:
                connection[i + shift] -= scale * previous[i]
            if grows:
                order = n + 1 - order
                previous = oldConnection
                previousInverse = discrepancy.inv
                shift = 1
            else:
                inc shift

        result = newSeq[T](order)
        for i in 0..<order:
            result[i] = -connection[i + 1]
    {.pop.}
