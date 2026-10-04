# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/modint/modint64
import cplib/math/combination
import tables, sets

declarStaticModint64(Mint64, 18446744073709551557u64)
declarStaticModint64(MintSmall64, 998244353u64)
declarStaticModint64(MintTwo64, 2u64)

proc checkIntegers[T: Modint64]() =
    const p = T.umod
    template signedCases(I: typedesc) =
        for x in [low(I), high(I), I(-1), I(0), I(1)]:
            let a = T.init(x)
            doAssert a == T.parseModint64($x)
            doAssert a.val < p
    template unsignedCases(I: typedesc) =
        for x in [low(I), high(I), I(1)]:
            doAssert T.init(x).val == x.uint64 mod p
            doAssert T.init(x) == T.init($x)
    signedCases(int8)
    signedCases(int16)
    signedCases(int32)
    signedCases(int64)
    signedCases(int)
    unsignedCases(uint8)
    unsignedCases(uint16)
    unsignedCases(uint32)
    unsignedCases(uint64)
    unsignedCases(uint)
    doAssert T.init(T.init(1)) == T.init(1)
    doAssert T.mod == p and T.get_M == p and T.init(0).mod == p
    doAssert T.init(0).umod == p
    doAssert T.init(0).pow(0).val == 1
    doAssert T.init(1).pow(high(uint64)).val == 1
    doAssert T.init(-1).pow(high(uint64)).val == p - 1
    doAssert T.init(1).inv.val == 1
    for s in ["", "+", "-", " 1", "1 ", "1a", "--1", "1_0", "\x001", "١"]:
        var rejected = false
        try: discard T.init(s)
        except ValueError: rejected = true
        doAssert rejected
    for s in ["0", "+0", "-0", "00000", "+00000", "-00000"]:
        doAssert T.init(s).val == 0
    template rejects(action: untyped) =
        block:
            var rejected = false
            try: discard action
            except ValueError: rejected = true
            doAssert rejected
    rejects(T.init(0).inv)
    rejects(T.init(1) / 0)
    rejects(T.init(1) / T.init(0))
    rejects(T.init(1).pow(-1))
    rejects(T.init(1).pow(low(int64)))
    var zero = T.init(0)
    block:
        var rejected = false
        try: zero /= 0
        except ValueError: rejected = true
        doAssert rejected
    doAssert zero.val == 0
    var map = initTable[T, string]()
    map[T.init(1)] = "one"
    doAssert map[T.init(1 + p)] == "one"
    var values = initHashSet[T]()
    values.incl(T.init(0))
    values.incl(T.init(p))
    doAssert values.len == 1

checkIntegers[Mint64]()
checkIntegers[MintSmall64]()
checkIntegers[MintTwo64]()
checkIntegers[StaticModint64[9223372036854775783u64]]()
checkIntegers[StaticModint64[9223372036854775837u64]]()

const constantInverse = Mint64.init(2).inv
const constantProduct = Mint64.init(-1) * Mint64.init(-1)
const constantParse = Mint64.init("-18446744073709551615")
doAssert constantProduct.val == 1
doAssert (constantInverse * 2).val == 1
doAssert constantParse.val == Mint64.umod - 58
var a = Mint64.init(low(int64))
let b = Mint64.init(high(uint64))
doAssert a.val == 9223372036854775749u64 and b.val == 58
for x in [0u64, 1, Mint64.umod div 2, Mint64.umod - 2, Mint64.umod - 1]:
    let v = Mint64.init(x)
    doAssert (v + high(uint64)) == (high(uint64) + v)
    doAssert (v * low(int64)) == (low(int64) * v)
    doAssert (low(int64) - v) == (Mint64.init(low(int64)) - v)
    if x != 0:
        doAssert (high(uint64) / v) == (Mint64.init(high(uint64)) / v)
    a = v
    a += -1
    a -= -1
    a *= 2
    a /= 2
    doAssert a == v

proc checkCombination[T]() =
    let c = initCombination[T](100)
    doAssert c.ncr(10, 3).val == 120
    doAssert c.npr(10, 3).val == 720
    doAssert c.nhr(5, 3).val == 35
    doAssert c.ncr(0, 0).val == 1
    doAssert c.ncr(-1, 0).val == 0
    for n in 1..99:
        for k in 1..n:
            doAssert c.ncr(n, k) == c.ncr(n - 1, k) + c.ncr(n - 1, k - 1)
checkCombination[Mint64]()
checkCombination[MintSmall64]()
let twoCombination = initCombination[MintTwo64](1)
doAssert twoCombination.ncr(1, 1).val == 1

echo "Hello World"
