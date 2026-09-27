# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/modint/modint

proc normalized(x, m: int): int =
    let r = x mod m
    if r < 0: r + m else: r

proc checkIntegerInit[T: MontgomeryModint]() =
    let modulus = T.umod.uint64
    template checkSigned(I: typedesc) =
        for value in [low(I), high(I), I(-1), I(0), I(1)]:
            doAssert T.init(value).val == normalized(value.int, modulus.int)
    template checkUnsigned(I: typedesc) =
        for value in [low(I), high(I), I(1)]:
            doAssert T.init(value).val == (value.uint64 mod modulus).int
    checkSigned(int8)
    checkSigned(int16)
    checkSigned(int32)
    checkSigned(int64)
    checkSigned(int)
    checkUnsigned(uint8)
    checkUnsigned(uint16)
    checkUnsigned(uint32)
    checkUnsigned(uint64)
    checkUnsigned(uint)
    for value in [modulus - 1, modulus, modulus + 1]:
        doAssert T.init(value).val == (value mod modulus).int

proc checkDivision[T]() =
    let modulus = T.umod.int
    for value in [low(int), high(int), -modulus, -1, 0, 1, modulus - 1, modulus]:
        let expected = normalized(value, modulus)
        var a = T.init(value)
        a /= 2
        doAssert (a * 2).val == expected
        a = T.init(value)
        a /= -2
        doAssert (a * -2).val == expected
        a = T.init(value)
        const denominator = 1 shl 1
        a /= denominator
        doAssert (a * denominator).val == expected
        a = T.init(value)
        var runtimeDenominator = 2
        a /= runtimeDenominator
        doAssert (a * runtimeDenominator).val == expected
        a = T.init(value)
        a /= 2i32
        doAssert (a * 2).val == expected
        a = T.init(value)
        a /= T.init(2)
        doAssert (a * 2).val == expected

proc checkArithmetic[T]() =
    let modulus = T.umod.int
    for value in [low(int), high(int), -modulus - 1, -modulus, -1,
                  0, 1, modulus - 1, modulus, modulus + 1]:
        doAssert T.init(value).val == normalized(value, modulus)
    when T is MontgomeryModint:
        checkIntegerInit[T]()
    when T is StaticBarrettModint:
        for value in [0u, T.umod.uint - 1, T.umod.uint,
                      (T.umod.uint - 1) * (T.umod.uint - 1), high(uint)]:
            doAssert rem(T, value) == uint32(value mod T.umod.uint)
    template checkPair(x, y: int) =
        block:
            var a = T.init(x)
            let b = T.init(y)
            doAssert (a + b).val == normalized(x + y, modulus)
            doAssert (a - b).val == normalized(x - y, modulus)
            doAssert (a * b).val == normalized(x * y, modulus)
            a += T.init(modulus - 1)
            a += T.init(1)
            doAssert a.val == x
            doAssert (a * b).val == normalized(x * y, modulus)
    for x in [0, 1 mod modulus, modulus div 2, modulus - 1]:
        for y in [0, 1 mod modulus, modulus div 2, modulus - 1]:
            checkPair(x, y)
    var state = 90123456789u64
    for i in 0..<5000:
        state = state xor (state shl 13)
        state = state xor (state shr 7)
        state = state xor (state shl 17)
        let x = (state mod modulus.uint64).int
        state = state xor (state shl 13)
        state = state xor (state shr 7)
        state = state xor (state shl 17)
        let y = (state mod modulus.uint64).int
        checkPair(x, y)
    when T is StaticMontgomeryModint or T is StaticBarrettModint:
        when T.umod > 1 and T.umod mod 2 == 1:
            checkDivision[T]()
    else:
        if modulus > 1 and modulus mod 2 == 1:
            checkDivision[T]()

checkArithmetic[StaticMontgomeryModint[1u32]]()
checkArithmetic[StaticMontgomeryModint[17u32]]()
checkArithmetic[StaticMontgomeryModint[21u32]]()
checkArithmetic[StaticMontgomeryModint[998244353u32]]()
checkArithmetic[StaticMontgomeryModint[1000000007u32]]()
checkArithmetic[StaticMontgomeryModint[1073741823u32]]()
checkArithmetic[StaticBarrettModint[1u32]]()
checkArithmetic[StaticBarrettModint[2u32]]()
checkArithmetic[StaticBarrettModint[17u32]]()
checkArithmetic[StaticBarrettModint[21u32]]()
checkArithmetic[StaticBarrettModint[998244353u32]]()
checkArithmetic[StaticBarrettModint[1000000007u32]]()
checkArithmetic[StaticBarrettModint[2147483647u32]]()

for modulus in [1, 3, 17, 21, 998244353, 1000000007, 1073741823]:
    modint_montgomery.setMod(modulus)
    checkArithmetic[modint_montgomery]()
for modulus in [1, 2, 17, 21, 998244353, 1000000007, 2147483647]:
    modint_barrett.setMod(modulus)
    checkArithmetic[modint_barrett]()

echo "Hello World"
