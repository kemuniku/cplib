when not declared CPLIB_UTILS_COUNT_SUBARRAYS_WITH_SUM:
    const CPLIB_UTILS_COUNT_SUBARRAYS_WITH_SUM* = 1
    import tables

    proc count_subarrays_with_sum*[T: SomeInteger](a: openArray[T], x: T): int64 =
        ## 和がxになる空でない連続部分列の個数。期待時間O(N)、追加空間O(N)。
        ## 負数・0・空列に対応する。aとxは同じ組み込み整数型を使う。
        ## 累積和は符号付き入力ならint64、符号なし入力ならuint64で計算する。
        ## 累積和または個数が各型に収まらない場合、releaseでもOverflowDefectを送出する。
        ## prefix-xが型の範囲外なら一致する過去の累積和はないため、検索を省く。
        when T is SomeSignedInt:
            type Sum = int64
        else:
            type Sum = uint64
        let target = Sum(x)
        var prefix: Sum = 0
        var frequency = initTable[Sum, int64]()
        frequency[0] = 1
        for value in a:
            let v = Sum(value)
            when T is SomeSignedInt:
                if (v > 0 and prefix > high(Sum) - v) or
                        (v < 0 and prefix < low(Sum) - v):
                    raise newException(OverflowDefect, "累積和がint64の範囲外です")
            else:
                if prefix > high(Sum) - v:
                    raise newException(OverflowDefect, "累積和がuint64の範囲外です")
            prefix += v
            when T is SomeSignedInt:
                let searchable = not ((target > 0 and prefix < low(Sum) + target) or
                    (target < 0 and prefix > high(Sum) + target))
            else:
                let searchable = prefix >= target
            if searchable:
                let count = frequency.getOrDefault(prefix - target)
                if result > high(int64) - count:
                    raise newException(OverflowDefect, "個数がint64の範囲外です")
                result += count
            # 現在の累積和は検索後に登録し、x=0でも空区間を数えない。
            let previous = frequency.getOrDefault(prefix)
            if previous == high(int64):
                raise newException(OverflowDefect, "累積和の頻度がint64の範囲外です")
            frequency[prefix] = previous + 1
