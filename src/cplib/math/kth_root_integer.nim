when not declared CPLIB_MATH_KTH_ROOT_INTEGER:
    const CPLIB_MATH_KTH_ROOT_INTEGER* = 1
    import math

    proc kthRootPowerLeq(base: uint64, exponent: int, limit: uint64): bool {.inline.} =
        ## 乗算前の除算比較で、オーバーフローなく base^exponent <= limit を判定する。
        var base = base
        var exponent = exponent
        var product = 1'u64
        while exponent > 0:
            if (exponent and 1) != 0:
                if base != 0 and product > limit div base:
                    return false
                product *= base
            exponent = exponent shr 1
            if exponent > 0:
                if base != 0 and base > limit div base:
                    return false
                base *= base
        return product <= limit

    proc kthRootCorrect(a: uint64, k: int, estimate: float64, upper: uint64): uint64 =
        ## 有効範囲に丸めた近似を上下に補正し、補正が長引く場合は厳密な二分探索へ移る。
        var root = 1'u64
        if estimate >= float64(upper):
            root = upper - 1
        elif estimate >= 1.0:
            root = uint64(estimate)
        for _ in 0..<3:
            if not kthRootPowerLeq(root, k, a):
                dec root
            elif not kthRootPowerLeq(root + 1, k, a):
                return root
            else:
                inc root
        var lo = 0'u64
        var hi = upper
        while hi - lo > 1:
            let mid = lo + (hi - lo) div 2
            if kthRootPowerLeq(mid, k, a):
                lo = mid
            else:
                hi = mid
        return lo

    proc kth_root*(a: uint64, k: int): uint64 =
        ## 全 uint64 に対し r^k <= a < (r+1)^k を満たす整数 r を返す。k >= 1。
        ## 通常 O(log k)、最悪 O(log k * ceil(64/k)) 時間、追加空間 O(1)。k >= 64 は O(1)。
        ## 浮動近似の精度に依存せず厳密に補正する。C/C++ バックエンド用。
        if k < 1:
            raise newException(ValueError, "k は正である必要があります")
        if a <= 1 or k == 1:
            return a
        if k >= 64:
            return 1
        if a < (1'u64 shl k):
            return 1
        let upper = 1'u64 shl ((64 + k - 1) div k)
        let estimate = if k == 2: sqrt(float64(a)) else: pow(float64(a), 1.0 / float64(k))
        return kthRootCorrect(a, k, estimate, upper)
