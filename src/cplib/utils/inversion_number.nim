when not declared CPLIB_UTILS_INVERSION_NUMBER:
    const CPLIB_UTILS_INVERSION_NUMBER* = 1
    import algorithm, sequtils
    proc inversion_number*(a: openArray[int]): int =
        ## 列aの転倒数をO(N log N)時間、O(N)領域で返す。
        runnableExamples:
            var a = @[2, 1, 5, 3, 4]
            assert inversion_number(a) == 3, "計算結果が期待値と一致しません: inversion_number(a) == 3"
        let c = a.sorted.deduplicate(true)
        var bit = newSeq[int](c.len + 1)
        var ans = 0
        for i in 0..<a.len:
            let pos = c.lowerbound(a[i]) + 1
            var p = pos
            var prefix = 0
            while p > 0:
                prefix += bit[p]
                p -= p and -p
            ans += i - prefix
            p = pos
            while p < bit.len:
                inc bit[p]
                p += p and -p
        return ans
