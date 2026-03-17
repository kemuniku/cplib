when not declared CPLIB_MODINT_MODINT_MONTGOMERY:
    const CPLIB_MODINT_MODINT_MONTGOMERY* = 1
    import std/macros, std/tables
    type StaticMontgomeryModint*[M: static[uint32]] = object
        a: uint32
    type DynamicMontgomeryModint*[M: static[uint32]] = object
        a: uint32
    type MontgomeryModint* = StaticMontgomeryModint or DynamicMontgomeryModint

    proc get_r*(M: uint32): uint32 =
        result = M
        for _ in 0..<4: result *= 2u32 - M * result
    proc get_n2*(M: uint32): uint32 = uint32((not uint(M - 1u32)) mod uint(M))
    proc check_params(M, r: uint32) =
        assert M < (1u32 shl 30), "invalid mod >= 2^30"
        assert (M and 1u32) == 1u32, "invalid mod % 2 == 0"
        assert r * M == 1, "r * mod != 1"
    var montgomeryParamCache {.compileTime.}: Table[uint32, NimNode]
    var montgomeryCachedParam: tuple[M, r, n2: uint32]
    macro get_param*[M: static[uint32]](self: typedesc[StaticMontgomeryModint[M]]): untyped =
        if M notin montgomeryParamCache:
            let value = (M.uint32, get_r(M), get_n2(M))
            montgomeryParamCache[M] = newLit(value)
        return montgomeryParamCache[M]
    template get_param*(self: typedesc[DynamicMontgomeryModint]): tuple[M, r, n2: uint32] =
        montgomeryCachedParam
    template get_M*(T: typedesc[MontgomeryModint]): uint32 =
        when T is StaticMontgomeryModint: T.M
        else: get_param(T).M
    proc setMod*[T: static[uint32]](self: typedesc[DynamicMontgomeryModint[T]], M: SomeInteger or SomeUnsignedInt) =
        var r = get_r(M.uint32)
        var n2 = get_n2(M.uint32)
        montgomeryCachedParam = (M: M.uint32, r: get_r(M.uint32), n2: n2)
        check_params(M.uint32, r)
    template umod*[T: MontgomeryModint](self: typedesc[T] or T): uint32 =
        when self is typedesc:
            when self is StaticMontgomeryModint: self.M
            else: get_param(self).M
        else: T.umod
    template `mod`*[T: MontgomeryModint](self: typedesc[T] or T): int32 = (T.umod).int32

    proc reduce(T: typedesc[StaticMontgomeryModint], b: uint): uint32 =
        let (_, r, _) = get_param(T)
        return cast[uint32]((b + uint(cast[uint32](b) * (not (r - 1u32))) * T.M) shr 32)
    proc reduce(T: typedesc[DynamicMontgomeryModint], b: uint): uint32 =
        var p = get_param(T)
        return cast[uint32]((b + uint(cast[uint32](b) * (not (p.r - 1u32))) * p.M) shr 32)
    proc init*(T: typedesc[MontgomeryModint], a: T or SomeInteger): auto =
        when a is T: return a
        elif T is StaticMontgomeryModint:
            let (_, r, n2) = get_param(T)
            check_params(T.M, r)
            var ai = reduce(T, uint(a.int32 mod T.M.int32 + T.M.int32) * n2)
            result = StaticMontgomeryModint[T.M](a: ai)
        elif T is DynamicMontgomeryModint:
            var p = get_param(T)
            var ai = reduce(T, uint(a.int32 mod p.M.int32 + p.M.int32) * p.n2)
            result = DynamicMontgomeryModint[T.M](a: ai)

    proc `+=`*[T: MontgomeryModint](a: var T, b: T or SomeInteger) =
        a.a += init(T, b).a - T.get_M * 2u32
        if cast[int32](a.a) < 0i32: a.a += T.get_M * 2u32
    proc `-=`*[T: MontgomeryModint](a: var T, b: T or SomeInteger) =
        a.a -= init(T, b).a
        if cast[int32](a.a) < 0i32: a.a += T.get_M * 2u32
    proc val*[T: MontgomeryModint](a: T): int =
        result = reduce(T, a.a).int
        if result.uint32 >= T.get_M: result -= T.get_M.int

    proc `-`*[T: MontgomeryModint](a: T): T = init(T, 0) - a
    proc `*=`*[T: MontgomeryModint] (a: var T, b: T or SomeInteger) = a.a = reduce(T, uint(a.a) * init(T, b).a)
    proc inv*[T: MontgomeryModint](x: T): T =
        assert x.val != 0
        var x: int32 = int32(x.val)
        var y: int32 = T.mod
        var u = 1i32
        var v, t = 0i32
        while y > 0:
            t = x div y
            x -= t * y
            u -= t * v
            swap(x, y)
            swap(u, v)
        return init(T, u)
    proc `/=`*[T: MontgomeryModint](a: var T, b: T or SomeInteger) = a *= init(T, b).inv

    macro declarStaticMontgomeryModint*(name, M) =
        let converter_name = ident("to" & $`name`)
        quote do:
            type `name`* = StaticMontgomeryModint[`M`]
            converter `converter_name`*(a: int): StaticMontgomeryModint[`M`] = init(StaticMontgomeryModint[`M`], a)
    macro declarDynamicMontgomeryModint*(name, id) =
        let converter_name = ident("to" & $`name`)
        quote do:
            type `name`* = DynamicMontgomeryModint[`id`]
            converter `converter_name`*(a: int): DynamicMontgomeryModint[`id`] = init(DynamicMontgomeryModint[`id`], a)
