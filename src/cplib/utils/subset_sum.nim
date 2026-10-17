when not declared CPLIB_UTILS_SUBSET_SUM:
    const CPLIB_UTILS_SUBSET_SUM* = 1

    proc solve_subset_sum*(a: openArray[int], target: int): bool =
        ## 非負整数列aの各要素を高々1回選び、和をtargetにできるか判定する。
        ## N = a.len、D = target以下の正の要素の最大値として時間O(N(D+1))、追加領域O(D)。
        ## 空集合を許す。負のtargetはfalse、負の要素はValueError。入力は変更しない。
        ## DPの2配列の合計バイト数をintで表せない場合もValueError。
        var largest = 0
        var smallest = high(int)
        var available = 0
        for value in a:
            if value < 0:
                raise newException(ValueError, "部分和の要素は非負である必要があります")
            if value > 0 and value <= target:
                largest = max(largest, value)
                smallest = min(smallest, value)
                available += min(value, target - available)
        if target <= 0:
            return target == 0
        if available < target:
            return false
        if smallest == largest:
            return target mod largest == 0

        var prefixSum = 0
        var split = a.len
        for i, value in a:
            if value == 0 or value > target:
                continue
            if value > target - prefixSum:
                split = i
                break
            prefixSum += value
            if prefixSum == target:
                return true

        if largest > (high(int) div sizeof(int)) div 4:
            raise newException(ValueError, "部分和のDP配列がintで表せるサイズを超えています")
        let width = 2 * largest
        var dp = newSeq[int](width)
        var next = newSeq[int](width)
        for j in 0..<width:
            dp[j] = -1
        # 添字jは和target-largest+j。値はまだ取り除けるprefixの上限（排他的）。
        dp[largest - (target - prefixSum)] = split
        for i in split..<a.len:
            let value = a[i]
            if value == 0 or value > target:
                continue
            for j in 0..<width:
                next[j] = dp[j]
            for j in 0..<largest:
                next[j + value] = max(next[j + value], dp[j])
            for j in countdown(width - 1, largest + 1):
                # 以前の行で処理済みの除去を繰り返さず、上限の増加分だけ処理する。
                for k in countdown(next[j] - 1, max(0, dp[j])):
                    if a[k] > 0 and a[k] <= target:
                        next[j - a[k]] = max(next[j - a[k]], k)
            swap(dp, next)
            if dp[largest] >= 0:
                return true
        return false
