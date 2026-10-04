when not declared CPLIB_GEOMETRY_ARGSORT:
    const CPLIB_GEOMETRY_ARGSORT* = 1
    import algorithm, math
    import cplib/math/int128
    import cplib/geometry/base

    proc argcmp*(L, R: (int, int)): int =
        ## 正のx軸から反時計回りに比較。零ベクトルは末尾、同方向は同順位。O(1)。
        ## 各積をInt128で比較し、積の差を取らないためintの全範囲に対応する。
        let lzero = L[0] == 0 and L[1] == 0
        let rzero = R[0] == 0 and R[1] == 0
        if lzero or rzero: return cmp(lzero, rzero)
        let a = L[1] > 0 or (L[1] == 0 and L[0] > 0)
        let b = R[1] > 0 or (R[1] == 0 and R[0] > 0)
        if a != b: return cmp(b, a)
        return cmp(to_Int128(L[1]) * R[0], to_Int128(L[0]) * R[1])

    proc argcmp*(L, R: Point[int]): int =
        ## 整数Pointの偏角比較。順序・制約はtuple版と同じ。O(1)。
        argcmp((L.x, L.y), (R.x, R.y))

    proc argcmp*[T: SomeFloat](L, R: Point[T]): int =
        ## 有限座標の偏角比較。正のx軸から反時計回り、零は末尾。O(1)。
        ## EPSを使わず、半平面内でfloat64のatan2の値を比較する。
        ## 積を使わないので座標積のoverflow/underflowはない。NaN/Infは対象外。
        ## 丸められた角度が等しい点は同順位。厳密な同方向判定は保証しない。
        let lzero = L.x == 0 and L.y == 0
        let rzero = R.x == 0 and R.y == 0
        if lzero or rzero: return cmp(lzero, rzero)
        let a = L.y > 0 or (L.y == 0 and L.x > 0)
        let b = R.y > 0 or (R.y == 0 and R.x > 0)
        if a != b: return cmp(b, a)
        # 負のx軸はatan2の-piの枝、正のx軸は+0に揃える。
        let ly = if L.y == 0: (if L.x < 0: -0.0 else: 0.0) else: float64(L.y)
        let ry = if R.y == 0: (if R.x < 0: -0.0 else: 0.0) else: float64(R.y)
        return system.cmp(arctan2(ly, float64(L.x)), arctan2(ry, float64(R.x)))

    proc argsorted*(X: seq[(int, int)]): seq[(int, int)] =
        ## 偏角順のコピーを返す。安定ソート、時間O(N log N)、追加領域O(N)。
        sorted(X, argcmp)

    proc argsort*(X: var seq[(int, int)]) =
        ## 偏角順に安定ソートする。時間O(N log N)、追加領域O(N)。
        X.sort(argcmp)

    proc argsorted*[T: int or SomeFloat](X: seq[Point[T]]): seq[Point[T]] =
        ## Pointの偏角順のコピーを返す。時間O(N log N)、追加領域O(N)。
        ## 安定ソートで同順位の入力順を保持。制約はargcmpに従う。
        sorted(X, proc(L, R: Point[T]): int = argcmp(L, R))

    proc argsort*[T: int or SomeFloat](X: var seq[Point[T]]) =
        ## Pointを偏角順に安定ソートする。時間O(N log N)、追加領域O(N)。
        ## 同順位の入力順を保持。制約はargcmpに従う。
        X.sort(proc(L, R: Point[T]): int = argcmp(L, R))
