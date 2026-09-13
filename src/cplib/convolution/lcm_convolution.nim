when not declared CPLIB_CONVOLUTION_LCM_CONVOLUTION:
    const CPLIB_CONVOLUTION_LCM_CONVOLUTION* = 1

    proc lcmConvolution*[T](a, b: seq[T]): seq[T] =
        ## c[k] = Σ_{lcm(i, j) = k} a[i] * b[j] をO(N log log N)時間・O(N)追加領域で求める。
        ## 入力は同じ長さとし、返り値も同じ長さ。範囲外のLCMは省き、lcm(0, i) = 0とする。
        assert a.len == b.len
        let n = a.len
        if n == 0:
            return @[]
        result = a
        var right = b
        var composite = newSeq[bool](n)
        var primes: seq[int]
        for p in 2..<n:
            if composite[p]:
                continue
            primes.add(p)
            for i in 1..(n - 1) div p:
                composite[i * p] = true
                result[i * p] += result[i]
                right[i * p] += right[i]
        for i in 0..<n:
            result[i] *= right[i]
        for p in primes:
            for i in countdown((n - 1) div p, 1):
                result[i * p] -= result[i]
        for i in 1..<n:
            result[0] += a[0] * b[i] + a[i] * b[0]
