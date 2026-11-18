when not declared CPLIB_MATH_IKTH_ROOT:
    const CPLIB_MATH_IKTH_ROOT* = 1

    proc ikthRoot*[T: SomeInteger](n: T, k: int): T =
        ## 非負整数nのk乗根を切り捨てた値（x^k <= nとなる最大の整数x）を返す。
        ## int/int8/int16/int32/int64およびuint/uint8/uint16/uint32/uint64に対応する。
        ## n < 0またはk <= 0の場合はValueErrorを送出する。
        ## 固定幅整数の除算をO(1)として時間O(1 + log(n + 1))、追加領域O(1)。
        ## n <= 1、k = 1の場合はO(1)。浮動小数点演算は使わない。
        runnableExamples:
            assert ikthRoot(26, 3) == 2
            assert ikthRoot(27, 3) == 3
            assert ikthRoot(28, 3) == 3
            assert ikthRoot(0, 7) == 0
            assert ikthRoot(high(uint64), 2) == 4_294_967_295'u64
        if k <= 0:
            raise newException(ValueError, "ikthRoot: k must be positive")
        when T is SomeSignedInt:
            if n < 0:
                raise newException(ValueError, "ikthRoot: n must be nonnegative")
        if n <= 1 or k == 1:
            return n
        let value = uint64(n)
        var bits = 0
        var remaining = value
        while remaining != 0:
            inc bits
            remaining = remaining shr 1
        if k >= bits:
            return T(1)
        # n < 2^bitsより、上端のk乗は必ずnを超える。
        var lo = 1'u64
        var hi = 1'u64 shl ((bits + k - 1) div k)
        while hi - lo > 1:
            let mid = lo + ((hi - lo) shr 1)
            var quotient = value
            var fits = true
            # 逐次除算でfloor(n / mid^k) >= 1を判定する。
            for _ in 0..<k:
                if quotient < mid:
                    fits = false
                    break
                quotient = quotient div mid
            if fits:
                lo = mid
            else:
                hi = mid
        return T(lo)
