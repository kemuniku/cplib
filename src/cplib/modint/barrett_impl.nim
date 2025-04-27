when not declared CPLIB_MODINT_MODINT_BARRETT:
    const CPLIB_MODINT_MODINT_BARRETT* = 1
    import std/macros
    type StaticBarrettModint*[M: static[uint32]] = object
        a: uint32
    type DynamicBarrettModint*[M: static[uint32]] = object
        a: uint32
    type BarrettModint* = StaticBarrettModint or DynamicBarrettModint

    proc get_im*(M: uint32): uint = cast[uint](-1) div M + 1
    func get_param*[M: static[uint32]](self: typedesc[DynamicBarrettModint[M]]): ptr[tuple[M, im: uint]] =
        {.cast(noSideEffect).}:
            #FIXME: nim 2.0 で global の動作が怪しいので、変更したい
            var p {.global.}: tuple[M, im: uint] = (998244353u, get_im(998244353u32))
            return p.addr
    template get_M*(T: typedesc[BarrettModint]): uint =
        when T is StaticBarrettModint: T.M.uint
        else: (get_param(T))[].M.uint
    proc setMod*[T: static[uint32]](self: typedesc[DynamicBarrettModint[T]], M: SomeInteger or SomeUnsignedInt) =
        (get_param(self))[] = (M: M.uint, im: get_im(M.uint32))

    template umod*[T: BarrettModint](self: typedesc[T] or T): uint32 =
        when self is typedesc:
            when self is StaticBarrettModint: self.M
            else: cast[uint32](((get_param(self))[]).M)
        else: T.umod
    template `mod`*[T: BarrettModint](self: typedesc[T] or T): int32 = (T.umod).int32
    {.emit: """
    #include <cstdio>
    inline unsigned long long calc_mul(const unsigned long long &a, const unsigned long long &b) {
        return (unsigned long long)(((__uint128_t)(a) * b) >> 64);
    }
    """.}
    proc calc_mul*(a, b: culonglong): culonglong {.importcpp: "calc_mul(#, #)", nodecl, inline.}
    proc rem*(T: typedesc[BarrettModint], a: uint): uint32 =
        when T is StaticBarrettModint:
            const im = get_im(T.M)
            const M = get_M(T)
            var x = (calc_mul(cast[culonglong](a), cast[culonglong](im))).uint
            var r = a - x * M
            if M <= r: r += M
            return cast[uint32](r)
        else:
            var p = get_param(T)[]
            var x = (calc_mul(cast[culonglong](a), cast[culonglong](p.im))).uint
            var r = a - x * p.M
            if p.M <= r: r += p.M
            return cast[uint32](r)
    proc init*(T: typedesc[BarrettModint], a: T or SomeInteger): auto =
        when a is T: return a
        else:
            if a in 0..<T.mod.int: return T(a: a.uint32)
            var a = a mod T.mod.int
            if a < 0: a += T.mod.int
            return T(a: a.uint32)

    proc `-`*[T: BarrettModint](a: T): T = T(a: T.umod - a.a)
    proc `+=`*[T: BarrettModint](a: var T, b: T or SomeInteger) =
        a.a += init(T, b).a
        if a.a >= T.umod: a.a -= T.umod
    proc `-=`*[T: BarrettModint](a: var T, b: T or SomeInteger) =
        a.a -= init(T, b).a
        if a.a >= T.umod: a.a += T.umod
    proc `*=`*[T: BarrettModint] (a: var T, b: T or SomeInteger) =
        a.a = rem(T, (a.a).uint * (init(T, b).a).uint)
    proc inv*[T: BarrettModint](x: T): T =
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
    proc `/=`*[T: BarrettModint](a: var T, b: T or SomeInteger) = a *= init(T, b).inv
    proc val*(a: BarrettModint): int = a.a.int
    macro declarStaticBarrettModint*(name, M) =
        let converter_name = ident("to" & $`name`)
        quote do:
            type `name`* = StaticBarrettModint[`M`]
            converter `converter_name`*(a: int): StaticBarrettModint[`M`] = init(StaticBarrettModint[`M`], a)
    macro declarDynamicBarrettModint*(name, id) =
        let converter_name = ident("to" & $`name`)
        quote do:
            type `name`* = DynamicBarrettModint[`id`]
            converter `converter_name`*(a: int): DynamicBarrettModint[`id`] = init(DynamicBarrettModint[`id`], a)
