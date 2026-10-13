when not declared CPLIB_MATH_NEAREST_EQUIV:
    const CPLIB_MATH_NEAREST_EQUIV* = 1
    proc nearest_equiv*(x, l, m: int): int =
        ## (y ≡ x mod m) かつ (y ≧ l) であるような最小の整数 y を返します。
        let modulus = if m < 0: 0'u - cast[uint](m) else: uint(m)
        proc residue(a: int): uint =
            ## 非負の剰余を符号付き整数の範囲を超えずに求めます。
            if a >= 0: return uint(a) mod modulus
            let r = (0'u - cast[uint](a)) mod modulus
            if r == 0: return 0
            return modulus - r
        let rx = residue(x)
        let rl = residue(l)
        let offset = if rx >= rl: rx - rl else: modulus - (rl - rx)
        return l + int(offset)
