when not declared CPLIB_MATRIX_SEMIRING_MATRIX_OPS:
    const CPLIB_MATRIX_SEMIRING_MATRIX_OPS* = 1

    template hasMatrixIdentities*(T: typedesc): bool =
        ## 要素型がzero/oneを定義しているかコンパイル時に判定する。
        mixin zero, one
        compiles(zero(T)) and compiles(one(T))
    template matrixZero*(T: typedesc): untyped =
        ## 加法単位元を返す。zeroが未定義の既存型は従来の0を使う。
        mixin zero
        when compiles(zero(T)): zero(T)
        else: T(0)
    template matrixOne*(T: typedesc): untyped =
        ## 乗法単位元を返す。oneが未定義の既存型は従来の1を使う。
        mixin one
        when compiles(one(T)): one(T)
        else: T(1)
    proc semiringMatrixPow*[M](m: M, n: int, identity: M): M =
        ## 半環の正方行列の非負整数乗。空の0乗も単位行列。O(H^2+H^3 log(n+1))、追加領域O(H^2)。
        mixin h, w, `*=`
        if m.h != m.w or n < 0:
            raise newException(ValueError, "正方行列と非負の指数が必要です")
        result = identity
        var base = m
        var e = n
        while e > 0:
            if (e and 1) == 1: result *= base
            e = e shr 1
            if e > 0: base *= base
