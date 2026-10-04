when not declared CPLIB_MATH_CRT:
    const CPLIB_MATH_CRT* = 1
    import cplib/math/inv_gcd
    import cplib/math/int128

    proc crt*(r, m: openArray[int]): tuple[r, m: int] =
        ## x ≡ r[i] (mod m[i]) を解き、最小非負剰余と法の最小公倍数を返す。
        ## 法は互いに素でなくてもよい。解なしは (0, 0)、空列は (0, 1)。
        ## 長さ不一致または正でない法は ValueError。負の剰余も受け付ける。
        ## 入力順に併合し、整合する途中の最小公倍数が high(int) を超えた時点で
        ## OverflowDefect を送出する。その後の合同式の整合性は検査しない。
        ## 不正入力の検査・オーバーフロー検出は release / assertions:off でも有効。
        ## 計算量 O(r.len * log(max(m)))、補助空間 O(1)。C++ バックエンドを使用する。
        ## 参考: https://atcoder.github.io/ac-library/production/document_ja/math.html (CC0)
        if r.len != m.len:
            raise newException(ValueError, "剰余列と法列の長さが一致しません")
        for modulus in m:
            if modulus <= 0:
                raise newException(ValueError, "CRTの法は正の整数で指定してください")
        result = (0, 1)
        for i in 0..<r.len:
            var residue = r[i] mod m[i]
            if residue < 0: residue += m[i]
            let (g, inverse) = inv_gcd(result.m, m[i])
            let difference = residue - result.r
            if difference mod g != 0: return (0, 0)
            let factor = m[i] div g
            if result.m > high(int) div factor:
                raise newException(OverflowDefect, "CRTの最小公倍数がintの範囲外です")
            var step = (to_Int128(difference div g) * to_Int128(inverse)) mod to_Int128(factor)
            if step < 0: step += to_Int128(factor)
            result.r += result.m * step.to_int()
            result.m *= factor
