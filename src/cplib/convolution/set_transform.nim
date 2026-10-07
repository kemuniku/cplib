when not declared CPLIB_CONVOLUTION_SET_TRANSFORM:
    const CPLIB_CONVOLUTION_SET_TRANSFORM* = 1

    proc subsetZetaTransform*[T](a: var seq[T]) =
        ## a[S] = Σ_{U⊆S} a[U] に変換する。O(n 2^n)時間・O(1)追加領域。
        assert a.len == 0 or (a.len and (a.len - 1)) == 0, "長さは空または2冪である必要があります"
        var bit = 1
        while bit < a.len:
            var base = 0
            while base < a.len:
                for j in 0..<bit: a[base + bit + j] += a[base + j]
                base += bit * 2
            bit = bit shl 1

    proc subsetMobiusTransform*[T](a: var seq[T]) =
        ## subsetZetaTransformの逆変換。O(n 2^n)時間・O(1)追加領域。
        assert a.len == 0 or (a.len and (a.len - 1)) == 0, "長さは空または2冪である必要があります"
        var bit = 1
        while bit < a.len:
            var base = 0
            while base < a.len:
                for j in 0..<bit: a[base + bit + j] -= a[base + j]
                base += bit * 2
            bit = bit shl 1

    proc supersetZetaTransform*[T](a: var seq[T]) =
        ## a[S] = Σ_{U⊇S} a[U] に変換する。O(n 2^n)時間・O(1)追加領域。
        assert a.len == 0 or (a.len and (a.len - 1)) == 0, "長さは空または2冪である必要があります"
        var bit = 1
        while bit < a.len:
            var base = 0
            while base < a.len:
                for j in 0..<bit: a[base + j] += a[base + bit + j]
                base += bit * 2
            bit = bit shl 1

    proc supersetMobiusTransform*[T](a: var seq[T]) =
        ## supersetZetaTransformの逆変換。O(n 2^n)時間・O(1)追加領域。
        assert a.len == 0 or (a.len and (a.len - 1)) == 0, "長さは空または2冪である必要があります"
        var bit = 1
        while bit < a.len:
            var base = 0
            while base < a.len:
                for j in 0..<bit: a[base + j] -= a[base + bit + j]
                base += bit * 2
            bit = bit shl 1
