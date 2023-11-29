when not declared CPLIB_UTILS_BITITERS:
    const CPLIB_UTILS_BITITERS* = 1
    import bitops
    iterator bitcomb*(n,r:int):int=
        var x = (1 shl r)-1
        while true:
            yield x
            var t = x or (x-1)
            x = (t+1) or (((not t and - not t) - 1) shr (x.countTrailingZeroBits() + 1))
            if x >= (1 shl n):
                break