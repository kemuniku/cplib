when not declared CPLIB_CONVOLUTION_CONVOLUTIONLL:
    const CPLIB_CONVOLUTION_CONVOLUTIONLL* = 1
    import sequtils, std/math
    import cplib/modint/modint
    import cplib/math/inv_gcd
    import cplib/convolution/convolution
    declarStaticMontgomeryModint(mint754974721, 754974721u32)
    declarStaticMontgomeryModint(mint167772161, 167772161u32)
    declarStaticMontgomeryModint(mint469762049, 469762049u32)

    proc convolution_ll*(f, g: seq[int]): seq[int] =
        var n = f.len
        var m = g.len
        if n == 0 or m == 0: return newSeq[int]()

        const
            M1 = 754974721u
            M2 = 167772161u
            M3 = 469762049u
            M12 = M1 * M2
            M23 = M2 * M3
            M31 = M3 * M1
            M123 = M1 * M2 * M3
            i1 = inv_gcd((M2 * M3).int, M1.int)[1].uint
            i2 = inv_gcd((M3 * M1).int, M2.int)[1].uint
            i3 = inv_gcd((M1 * M2).int, M3.int)[1].uint
        # FIXME: mapitでf1, g1を作ろうとするとなぜか壊れる……
        var f1 = newSeq[mint754974721](n)
        var g1 = newSeq[mint754974721](m)
        for i in 0..<n: f1[i] = mint754974721(f[i])
        for i in 0..<m: g1[i] = mint754974721(g[i])
        let c1 = convolution(f1, g1)
        var f2 = newSeq[mint167772161](n)
        var g2 = newSeq[mint167772161](m)
        for i in 0..<n: f2[i] = mint167772161(f[i])
        for i in 0..<m: g2[i] = mint167772161(g[i])
        let c2 = convolution(f2, g2)
        var f3 = newSeq[mint469762049](n)
        var g3 = newSeq[mint469762049](m)
        for i in 0..<n: f3[i] = mint469762049(f[i])
        for i in 0..<m: g3[i] = mint469762049(g[i])
        let c3 = convolution(f3, g3)
        var ans = newseqwith(n + m - 1, 0)
        for i in 0..<ans.len:
            var x = 0.uint
            x += (c1[i].val.uint * i1) mod M1 * M23
            x += (c2[i].val.uint * i2) mod M2 * M31
            x += (c3[i].val.uint * i3) mod M3 * M12
            var diff = c1[i].val - floorMod(x.int, M1.int)
            if diff < 0: diff += M1.int
            const offset = [0u, 0u, M123, 2u * M123, 3u * M123]
            x -= offset[diff mod 5]
            ans[i] = cast[int](x)
        return ans
