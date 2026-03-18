# original: https://tayu0110.hatenablog.com/entry/2023/05/06/023244
when not declared CPLIB_CONVOLUTION_NTT:
    const CPLIB_CONVOLUTION_NTT* = 1
    import options, macros, tables, bitops
    import cplib/modint/modint
    proc ntt_powmod_compiletime(a, x, p: int): int =
        var ans = 1
        var a = a
        var x = x
        while x > 0:
            if (x and 1) == 1:
                ans = (ans * a) mod p
            a = (a * a) mod p
            x = (x shr 1)
        return ans mod p

    proc ntt_primefactor_compiletime(p: int): seq[int] =
        var x = p
        var ans = newSeq[int]()
        for i in 2..p:
            if i * i > p: break
            if x mod i != 0: continue
            ans.add(i)
            while x mod i == 0:
                x = x div i
        if x != 1: ans.add(x)
        return ans

    proc ntt_primitive_root_compiletime(p: int): int =
        var pf = (p-1).ntt_primefactor_compiletime
        for a in 3..<p:
            proc check(): bool =
                for q in pf:
                    if ntt_powmod_compiletime(a, (p-1) div q, p) == 1:
                        return false
                return true
            if check():
                return a

    proc nth_root(primitive_root, nth, m: int): int = ntt_powmod_compiletime(primitive_root, (m - 1) div nth, m)
    type NttConfig = object
        sum_e, m, forth_root, forth_root_inv, primitive_root: int
        rate2, rate3, irate2, irate3: array[30, int]
    proc initNttConfig(m: int): NttConfig =
        var sum_e = 0
        var rate2, rate3, irate2, irate3: array[30, int]
        var prod = 1
        var iprod = 1
        var primitive_root = ntt_primitive_root_compiletime(m)
        while sum_e + 2 <= ((m - 1).countTrailingZeroBits - 1):
            var root = nth_root(primitive_root, 1 shl (sum_e + 2), m)
            var iroot = ntt_powmod_compiletime(root, m - 2, m)
            rate2[sum_e] = (root * iprod) mod m
            irate2[sum_e] = (iroot * prod) mod m
            prod = (prod * root) mod m
            iprod = (iprod * iroot) mod m
            sum_e += 1
        sum_e = 0
        prod = 1
        iprod = 1
        while sum_e + 3 <= ((m - 1).countTrailingZeroBits):
            var root = nth_root(primitive_root, 1 shl (sum_e + 3), m)
            var iroot = ntt_powmod_compiletime(root, m - 2, m)
            rate3[sum_e] = (root * iprod) mod m
            irate3[sum_e] = (iroot * prod) mod m
            prod = (prod * root) mod m
            iprod = (iprod * iroot) mod m
            sum_e += 1
        var forth_root = nth_root(primitive_root, 4, m)
        var forth_root_inv = ntt_powmod_compiletime(forth_root, m-2, m)
        return NttConfig(sum_e: sum_e + 2, m: m, forth_root: forth_root, forth_root_inv: forth_root_inv, primitive_root: primitive_root, rate2: rate2, rate3: rate3, irate2: irate2, irate3: irate3)

    var ntt_config_cache {.compileTime.}: Table[uint32, NimNode]
    var dynamic_ntt_config = NttConfig()
    macro get_ntt_config[M: static[uint32]](self: typedesc[StaticBarrettModint[M] or StaticMontgomeryModint[M]]): untyped =
        if M notin ntt_config_cache:
            let value = initNttConfig(int(M))
            ntt_config_cache[M] = newLit(value)
        result = ntt_config_cache[M]
    proc get_ntt_config(self: typedesc[DynamicBarrettModint or DynamicMontgomeryModint]): NttConfig =
        if dynamic_ntt_config.m != self.umod.int:
            dynamic_ntt_config = initNttConfig(self.umod.int)
        return dynamic_ntt_config

    proc ntt*[T: BarrettModint or MontgomeryModint](f: var seq[T]) =
        let n = f.len
        if n <= 1: return
        let ntt_config = get_ntt_config(T)
        assert(n.popcount == 1, "len(f) must be power of two, please add zeros")
        var width = n
        while width > 1:
            if width == 2:
                let offset = (width shr 1)
                var root = T(1)
                for top in countup(0, n-1, width):
                    for i in top..<(top+offset):
                        let (c0, c1) = (f[i], f[i+offset] * root)
                        f[i] = c0 + c1
                        f[i+offset] = c0 - c1
                    let b = top div width
                    root *= ntt_config.rate2[countTrailingZeroBits(not b)]
                width = (width shr 1)
            else:
                let offset = (width shr 2)
                var root = T(1)
                for top in countup(0, n-1, width):
                    let root2 = root * root
                    let root3 = root * root2
                    for i in top..<(top+offset):
                        let (c0, c1, c2, c3) = (f[i], f[i+offset] * root, f[i+offset*2] * root2, f[i+offset*3] * root3)
                        let c0c2 = c0 + c2
                        let c0c2n = c0 - c2
                        let c1c3 = c1 + c3
                        let c1c3nim = (c1 - c3) * ntt_config.forth_root
                        f[i] = c0c2 + c1c3
                        f[i+offset] = c0c2 - c1c3
                        f[i+offset*2] = c0c2n + c1c3nim
                        f[i+offset*3] = c0c2n - c1c3nim
                    let b = top div width
                    root *= ntt_config.rate3[countTrailingZeroBits(not b)]
                width = (width shr 2)

    proc intt*[T: BarrettModint or MontgomeryModint](f: var seq[T]) =
        let n = f.len
        if n <= 1: return
        let ntt_config = get_ntt_config(T)
        assert(n.popcount == 1, "len(f) must be power of two, please add zeros")
        var width = (if n.countTrailingZeroBits mod 2 == 1: 2 else: 4)
        while width <= n:
            if width == 2:
                let offset = (width shr 1)
                var root = T(1)
                for top in countup(0, n-1, width):
                    for i in top..<(top+offset):
                        let (c0, c1) = (f[i], f[i+offset])
                        f[i] = c0 + c1
                        f[i+offset] = (c0 - c1) * root
                    let b = top div width
                    root *= ntt_config.irate2[countTrailingZeroBits(not b)]
            else:
                let offset = (width shr 2)
                var root = T(1)
                for top in countup(0, n-1, width):
                    let root2 = root * root
                    let root3 = root * root2
                    for i in top..<(top+offset):
                        let (c0, c1, c2, c3) = (f[i], f[i+offset], f[i+offset*2], f[i+offset*3])
                        let c0c1 = c0 + c1
                        let c0c1n = c0 - c1
                        let c2c3 = c2 + c3
                        let c2c3nim = (c2 - c3) * ntt_config.forth_root_inv
                        f[i] = c0c1 + c2c3
                        f[i+offset] = (c0c1n + c2c3nim) * root
                        f[i+offset*2] = (c0c1 - c2c3) * root2
                        f[i+offset*3] = (c0c1n - c2c3nim) * root3
                    let b = top div width
                    root *= ntt_config.irate3[countTrailingZeroBits(not b)]
            width = (width shl 2)
        var ninv = T(n).inv
        for i in 0..<n: f[i] *= ninv
