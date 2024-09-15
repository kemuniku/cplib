when not declared CPLIB_MATH_EULER_PHI:
    const CPLIB_MATH_EULER_PHI* = 1
    import sequtils
    proc euler_phi*(n: int): int =
        result = n
        var n = n
        for i in 2..<n:
            if i*i > n:
                break
            if n mod i == 0:
                result -= result div i
                while n mod i == 0:
                    n = n div i
        if n > 1:
            result -= result div n

    proc euler_phi_list*(n: int): seq[int] =
        result = (0..n).toSeq
        for i in 2..n:
            if result[i] == i:
                for j in countup(i, n, i):
                    result[j] = result[j] div i
                    result[j] *= (i - 1)
