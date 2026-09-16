# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/math/modfast
import cplib/math/powmod
import cplib/modint/modint

type TestMint = DynamicBarrettModint[20260914u32]

proc checkAll(p: int) =
    TestMint.setMod(p)
    let table = initModFast[TestMint]()
    doAssert table.p == p
    var x = 1
    for e in 0..<p - 1:
        doAssert table.log(x) == e
        doAssert table.powRoot(e).val == x
        doAssert x * table.inv(x).val mod p == 1
        doAssert table.pow(x, -1).val == table.inv(x).val
        if p < 100:
            for k in 0..2 * p:
                doAssert table.pow(x, k).val == powmod(x, k, p)
        x = x * table.root.val mod p
    doAssert table.pow(0, 0).val == 1
    doAssert table.pow(0, p - 1).val == 0
    doAssert table.powRoot(-1).val * table.root.val mod p == 1

for p in [2, 3, 5, 7, 11, 17, 31, 61, 67, 97, 127, 257, 509, 1021,
          4093, 65537, 100003]:
    checkAll(p)

var rng = initRand(123456789)
for p in [998244353, 1000000007, 1000000009, 1073741789]:
    TestMint.setMod(p)
    let table = initModFast[TestMint]()
    var width = 1
    while width * width * width < p: width *= 2
    var boundary = width
    while boundary < p:
        for x in max(1, boundary - 1)..min(p - 1, boundary + 1):
            doAssert table.powRoot(table.log(x)).val == x
        boundary += width
    for i in 0..<20000:
        let x = if i < 1024: i + 1 elif i < 2048: p - (i - 1023) else: rng.rand(1..p - 1)
        let e = rng.rand(high(int))
        let logarithm = table.log(x)
        doAssert logarithm >= 0 and logarithm < p - 1
        doAssert powmod(table.root.val, logarithm, p) == x
        doAssert table.powRoot(e).val == powmod(table.root.val, e, p)
        doAssert table.inv(x).val == powmod(x, p - 2, p)
        doAssert table.pow(x, e).val == powmod(x, e, p)
        doAssert table.pow(x, -e).val == powmod(table.inv(x).val, e, p)
    for e in [low(int), high(int), -p, -1, 0, 1, p - 1, p]:
        let reduced = ((e mod (p - 1)) + p - 1) mod (p - 1)
        doAssert table.powRoot(e).val == powmod(table.root.val, reduced, p)
        doAssert table.pow(2, e).val == powmod(2, reduced, p)

proc checkMint[T: BarrettModint or MontgomeryModint]() =
    let table: ModFast[T] = initModFast[T]()
    static:
        doAssert typeof(table.root) is T
        doAssert typeof(table.inv(1)) is T
        doAssert typeof(table.pow(1, 0)) is T
        doAssert typeof(table.powRoot(0)) is T
        doAssert typeof(table.log(init(T, 1))) is int
    let p = T.umod.int
    for i in 1..1000:
        let x = init(T, i mod (p - 1) + 1)
        let e = i * 123456789
        doAssert table.inv(x).val == powmod(x.val, p - 2, p)
        doAssert table.pow(x, e).val == powmod(x.val, e, p)
        doAssert table.powRoot(table.log(x)).val == x.val
    doAssert table.pow(init(T, 0), 0).val == 1
    doAssert table.inv(init(T, -1)).val == p - 1

checkMint[StaticBarrettModint[2u32]]()
checkMint[StaticMontgomeryModint[3u32]]()
checkMint[modint998244353_barrett]()
checkMint[modint998244353_montgomery]()
checkMint[modint1000000007_barrett]()
checkMint[modint1000000007_montgomery]()
type DynamicMint = DynamicMontgomeryModint[20260914u32]
DynamicMint.setMod(1000000007)
checkMint[DynamicMint]()

when compileOption("assertions"):
    TestMint.setMod(17)
    let old = initModFast[TestMint]()
    TestMint.setMod(19)
    var rejected = false
    try:
        discard old.inv(init(TestMint, 2))
    except AssertionDefect:
        rejected = true
    doAssert rejected

echo "Hello World"
