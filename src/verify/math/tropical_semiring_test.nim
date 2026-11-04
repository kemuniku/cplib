# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/minplus
import cplib/math/maxplus
import sets, hashes

proc make[T](_: typedesc[MinPlus[T]], value: T): MinPlus[T] = initMinPlus(value)
proc make[T](_: typedesc[MaxPlus[T]], value: T): MaxPlus[T] = initMaxPlus(value)

template raises(kind, body: untyped) =
    block:
        var caught = false
        try: discard body
        except kind: caught = true
        doAssert caught

proc check[S, T]() =
    let z = S.zero
    let o = S.one
    doAssert default(S) == z
    doAssert o.val == T(0)
    doAssert z.get(T(42)) == T(42)
    doAssert not z.isFinite and o.isFinite
    raises(ValueError, z.val)
    raises(ValueError, o.pow(-1))
    doAssert z.pow(0) == o
    doAssert z.pow(1) == z
    doAssert z.pow(high(int)) == z
    doAssert o.pow(high(int)) == o
    for value in [low(T), low(T) + 1, T(-1), T(0), T(1), high(T) - 1, high(T)]:
        let x = make(S, value)
        doAssert x.isFinite and x.val == value and x.get(T(42)) == value
        doAssert x != z
        doAssert x + z == x and z + x == x
        doAssert x * z == z and z * x == z
        doAssert x * o == x and o * x == x
        doAssert x.pow(0) == o and x.pow(1) == x
        doAssert (x ^ 1) == x
        doAssert hash(x) == hash(make(S, value))
        doAssert toHashSet([x, z, x]).len == 2
        when S is MinPlus:
            doAssert x < z and z > x and x <= z and z >= x
        else:
            doAssert z < x and x > z and z <= x and x >= z
    let hi = make(S, high(T))
    let lo = make(S, low(T))
    let p = make(S, T(1))
    let n = make(S, T(-1))
    doAssert (hi * lo).val == T(-1)
    doAssert (hi * n).val == high(T) - 1
    doAssert (lo * p).val == low(T) + 1
    doAssert (make(S, T(high(T) div 2)) ^ 2).val == T(high(T) div 2 * 2)
    raises(OverflowDefect, hi * p)
    raises(OverflowDefect, p * hi)
    raises(OverflowDefect, lo * n)
    raises(OverflowDefect, n * lo)
    raises(OverflowDefect, hi.pow(2))
    raises(OverflowDefect, lo.pow(2))
    for i in -8..8:
        let a = make(S, T(i))
        for exponent in 0..8:
            doAssert a.pow(exponent).val == T(i * exponent)
        for j in -8..8:
            let b = make(S, T(j))
            when S is MinPlus: doAssert (a + b).val == T(min(i, j))
            else: doAssert (a + b).val == T(max(i, j))
            doAssert (a * b).val == T(i + j)
            doAssert a + b == b + a and a * b == b * a
            var c = a
            c += b
            doAssert c == a + b
            c = a
            c *= b
            doAssert c == a * b
            for k in -3..3:
                let c = make(S, T(k))
                doAssert (a + b) + c == a + (b + c)
                doAssert (a * b) * c == a * (b * c)
                doAssert a * (b + c) == a * b + a * c
                doAssert (a + b) * c == a * c + b * c
    doAssert z * (p + n) == z * p + z * n
    when S is MinPlus:
        doAssert z.isInfinity and z == S.infinity and $z == "inf"
    else:
        doAssert z.isNegInfinity and z == S.negInfinity and $z == "-inf"

template checkType(T: typedesc) =
    check[MinPlus[T], T]()
    check[MaxPlus[T], T]()
checkType(int8)
checkType(int16)
checkType(int32)
checkType(int64)
checkType(int)
static:
    doAssert not compiles(initMinPlus(1.0))
    doAssert not compiles(initMaxPlus(1'u))
    doAssert not compiles(initMinPlus(1) - initMinPlus(2))
    doAssert not compiles(initMaxPlus(1) / initMaxPlus(2))
echo "Hello World"
