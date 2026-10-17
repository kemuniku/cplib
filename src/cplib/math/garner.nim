when not declared CPLIB_MATH_GARNER:
    const CPLIB_MATH_GARNER* = 1
    import cplib/math/inv_gcd
    import cplib/math/int128

    proc garner*(residues, moduli: openArray[int], targetMod: int): int =
        ## 互いに素な法の最小非負CRT解を targetMod で割った剰余を返す。
        ## 入力法と targetMod は正。入力法同士だけが互いに素であればよい。
        ## 負の剰余・法1・空列に対応し、不正入力は ValueError。
        ## 時間 O(k² + k log M)、補助空間 O(k)。法の積は構築しない。
        ## Int128 を使用するため C++ バックエンドが必要。
        if residues.len != moduli.len:
            raise newException(ValueError, "剰余列と法列の長さが一致しません")
        if targetMod <= 0:
            raise newException(ValueError, "復元先の法は正の整数で指定してください")
        for modulus in moduli:
            if modulus <= 0:
                raise newException(ValueError, "Garnerの入力法は正の整数で指定してください")

        let k = moduli.len
        var constants = newSeq[int](k + 1)
        var coefficients = newSeq[int](k + 1)
        for i in 0..<k: coefficients[i] = 1 mod moduli[i]
        coefficients[k] = 1 mod targetMod
        for i in 0..<k:
            let modulus = moduli[i]
            let (g, inverse) = inv_gcd(coefficients[i], modulus)
            if g != 1:
                raise newException(ValueError, "Garnerの入力法は互いに素である必要があります")
            var residue = residues[i] mod modulus
            if residue < 0: residue += modulus
            var digit = ((to_Int128(residue - constants[i]) *
                to_Int128(inverse)) mod to_Int128(modulus)).to_int()
            if digit < 0: digit += modulus
            for j in i + 1..k:
                let nextMod = if j == k: targetMod else: moduli[j]
                constants[j] = ((to_Int128(constants[j]) +
                    to_Int128(coefficients[j]) * to_Int128(digit)) mod
                    to_Int128(nextMod)).to_int()
                coefficients[j] = ((to_Int128(coefficients[j]) *
                    to_Int128(modulus)) mod to_Int128(nextMod)).to_int()
        return constants[k]
