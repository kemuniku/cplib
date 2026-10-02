when not declared CPLIB_CONVOLUTION_BITWISE_OR_CONVOLUTION:
    const CPLIB_CONVOLUTION_BITWISE_OR_CONVOLUTION* = 1
    import cplib/convolution/set_transform

    proc bitwiseOrConvolution*[T](a, b: seq[T]): seq[T] =
        ## c[S] = Σ_{U or V = S} a[U] b[V]。O(n 2^n)時間・O(2^n)追加領域。
        assert a.len == b.len, "配列の長さは一致する必要があります"
        result = a
        var right = b
        subsetZetaTransform(result)
        subsetZetaTransform(right)
        for i in 0..<a.len: result[i] *= right[i]
        subsetMobiusTransform(result)
