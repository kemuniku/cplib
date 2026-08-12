when not declared CPLIB_MATH_KTH_ROOT_INTEGER:
    const CPLIB_MATH_KTH_ROOT_INTEGER* = 1

    proc power_leq(base: uint64, exponent: int, limit: uint64): bool =
        ## Returns whether `base ^ exponent <= limit` without overflowing uint64.
        var
            base = base
            exponent = exponent
            product = 1'u64
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

    proc kth_root_integer*(a: uint64, k: int): uint64 =
        ## Returns floor(a^(1/k)).
        ##
        ## `a` may use the entire uint64 range. `k` must be positive.
        doAssert k >= 1
        if a == 0 or k == 1:
            return a

        var
            bit_length = 0
            value = a
        while value != 0:
            bit_length += 1
            value = value shr 1

        if k >= bit_length:
            return 1

        # The answer is smaller than 2^ceil(bit_length / k). Since k >= 2
        # here, the shift is at most 32 and is representable by uint64.
        let root_bits = (bit_length + k - 1) div k
        var
            ok = 1'u64 shl (root_bits - 1)
            ng = 1'u64 shl root_bits
        while ng - ok > 1:
            let mid = ok + (ng - ok) div 2
            if power_leq(mid, k, a):
                ok = mid
            else:
                ng = mid
        return ok
