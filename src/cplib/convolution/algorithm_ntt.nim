when not declared CPLIB_CONVOLUTION_ALGORITHM_NTT:
    const CPLIB_CONVOLUTION_ALGORITHM_NTT* = 1
    import cplib/convolution/convolution
    import cplib/modint/modint

    type AlgorithmNtt* = object
        handle: pointer
        size*: int

    proc create(size: csize_t, modulus: uint32): pointer {.importc: "cplib_algorithm_ntt_create".}
        ## 正逆変換表を構築する。
    proc destroy(context: pointer) {.importc: "cplib_algorithm_ntt_destroy".}
        ## 正逆変換表を解放する。
    proc forward(context: pointer, output, input: ptr uint32, length: csize_t,
        montgomery: bool) {.importc: "cplib_algorithm_ntt_forward".}
        ## 入力を変更せず周波数表現を求める。
    proc inverse(context: pointer, output, spectrum: ptr uint32,
        start, count: csize_t, montgomery: bool) {.importc: "cplib_algorithm_ntt_inverse".}
        ## スペクトルを消費して係数の区間を復元する。
    proc addProduct(context: pointer, output, left, right: ptr uint32) {.importc: "cplib_algorithm_ntt_add_product".}
        ## 周波数ごとの積を加算する。

    proc initAlgorithmNtt*(modulus: uint32, size: int): AlgorithmNtt =
        ## 64以上の2冪sizeに対応するNTT素数で作る。使用後にcloseが必要。
        assert canUseMultipointTreeNtt(modulus, size)
        AlgorithmNtt(handle: create(size.csize_t, modulus), size: size)

    proc close*(context: var AlgorithmNtt) =
        ## 所有する変換表を解放する。コンテキストのコピーは作らないこと。
        if context.handle != nil: destroy(context.handle)
        context.handle = nil

    proc spectrum*[T: BarrettModint or MontgomeryModint](context: AlgorithmNtt,
            f: openArray[T]): seq[uint32] =
        ## fのNTTをMontgomery表現の配列で返す。O(size log size)。
        assert f.len <= context.size
        result = newSeq[uint32](context.size)
        let data = if f.len == 0: nil else: cast[ptr uint32](unsafeAddr f[0])
        forward(context.handle, addr result[0], data, f.len.csize_t, T is MontgomeryModint)

    proc addSpectrumProduct*(context: AlgorithmNtt, output: var seq[uint32],
            left, right: seq[uint32]) =
        ## 同じ法・長さ・順序のスペクトルの積を加算する。O(size)。
        assert output.len == context.size and left.len == context.size and right.len == context.size
        addProduct(context.handle, addr output[0], unsafeAddr left[0], unsafeAddr right[0])

    proc spectrumProduct*(context: AlgorithmNtt, left, right: seq[uint32]): seq[uint32] =
        ## 同じコンテキストのスペクトルの積を返す。O(size)。
        result = newSeq[uint32](context.size)
        context.addSpectrumProduct(result, left, right)

    proc coefficients*[T: BarrettModint or MontgomeryModint](context: AlgorithmNtt,
            values: var seq[uint32], start, count: int, outputType: typedesc[T]): seq[T] =
        ## valuesを消費して[start,start+count)の係数を返す。O(size log size)。
        assert values.len == context.size and start >= 0 and count >= 0 and start + count <= context.size
        result = newSeq[T](count)
        if count > 0:
            inverse(context.handle, cast[ptr uint32](addr result[0]), addr values[0],
                start.csize_t, count.csize_t, T is MontgomeryModint)
