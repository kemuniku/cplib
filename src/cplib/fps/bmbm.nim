when not declared CPLIB_FPS_BMBM:
    const CPLIB_FPS_BMBM* = 1

    import cplib/fps/berlekamp_massey
    import cplib/fps/bostan_mori
    import cplib/modint/modint

    proc bmbm*[T: BarrettModint or MontgomeryModint](a: seq[T], k: int): T =
        ## 先頭の数項からBerlekamp--Massey法で漸化式を推定し、Bostan--Mori法で第k項（0-indexed）を求める。
        ## 法は素数であること。元の数列の漸化式の次数がd以下なら、先頭2d項あれば復元できる。
        ## k < a.lenならa[k]を返す。空列・全零列は零数列として扱う。
        ## 時間計算量O(a.len^2 + M(d) log(k+1))。dは推定次数、M(d)は長さdの畳み込みの計算量。
        doAssert k >= 0, "BMBM法では添字が非負である必要がある"
        if k < a.len: return a[k]
        let coefficients = berlekampMassey(a)
        if coefficients.len == 0: return init(T, 0)
        linearRecurrenceKth(a[0..<coefficients.len], coefficients, k)
