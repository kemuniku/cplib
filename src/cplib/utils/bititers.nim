when not declared CPLIB_UTILS_BITITERS:
    const CPLIB_UTILS_BITITERS* = 1
    import bitops
    iterator bitcomb*(n, r: int): int =
        ##n bit中 r bitが1であるようなbit列を列挙します。
        var x = (1 shl r)-1
        while true:
            yield x
            var t = x or (x-1)
            x = (t+1) or (((not t and - not t) - 1) shr (x.countTrailingZeroBits() + 1))
            if x >= (1 shl n):
                break

    iterator bitsubseteq*(bits: int): int =
        ##与えられた集合の部分集合を昇順で列挙します。与えられた集合も含みます。
        var i = 0
        while true:
            yield i
            if bits == i:
                break
            i = (i-bits) and bits
    iterator bitsubset*(bits: int): int =
        ##与えられた集合の部分集合を昇順で列挙します。与えられた集合は含みません。
        var i = 0
        while true:
            yield i
            i = (i-bits) and bits
            if bits == i:
                break
    iterator bitsubset_descendingeq*(bits: int): int =
        ##与えられた集合の部分集合を昇順で列挙します。与えられた集合も含みます。
        var i = bits
        while true:
            yield i
            if i == 0:
                break
            i = (i-1) and bits
    iterator bitsubset_descending*(bits: int): int =
        ##与えられた集合の部分集合を昇順で列挙します。与えられた集合は含みません。
        var i = bits
        while true:
            i = (i-1) and bits
            yield i
            if i == 0:
                break


    iterator bitsuperset*(bits, n: int): int =
        ## 与えられた集合を包含する集合を列挙します。bit数上限をnとします。
        var i = bits
        while true:
            i = (i+1) or bits
            yield i
            if i >= (1 shl n):
                break

    iterator bitsingleton*(bits: int): int =
        ##立っているbitを一つずつ取り出します。
        var i = bits and (-bits)
        while true:
            yield i
            i = i and (not bits + (i shr 1))
            if i == 0:
                break

    iterator standingbits*(bits: int): int =
        #bits & (1<<i)が0でない値になるようなiを列挙します。
        var i = bits and (-bits)
        while true:
            yield fastLog2(i)
            i = i and (not bits + (i shr 1))
            if i == 0:
                break
