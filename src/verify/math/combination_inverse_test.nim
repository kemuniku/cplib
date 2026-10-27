# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/combination
import cplib/modint/modint
import atcoder/modint as acl

proc inverseOracle(x, p: int): int =
    var a = x
    var b = p
    var u = 1
    var v = 0
    while b != 0:
        let q = a div b
        (a, b) = (b, a - q * b)
        (u, v) = (v, u - q * v)
    doAssert a == 1
    return (u mod p + p) mod p

proc check[M](p, limit: int) =
    let empty = initCombination[M](0)
    doAssert empty.ncr_inv(0, 0).val == 1
    let c = initCombination[M](limit)
    var row = @[1]
    for n in 0..limit:
        for k in 0..n:
            doAssert c.ncr(n, k).val.int == row[k]
            doAssert c.ncr_inv(n, k).val.int == inverseOracle(row[k], p)
            doAssert (c.ncr(n, k) * c.ncr_inv(n, k)).val == 1
        var next = newSeq[int](row.len + 1)
        next[0] = 1
        next[^1] = 1
        for k in 1..<row.len: next[k] = (row[k-1] + row[k]) mod p
        row = next
    for nk in [(-1, 0), (0, -1), (2, 3), (limit+1, 0), (high(int), 0)]:
        var caught = false
        try: discard c.ncr_inv(nk[0], nk[1])
        except ValueError: caught = true
        doAssert caught

type B = modint998244353_barrett
type M = modint998244353_montgomery
check[B](998244353, 160)
check[M](998244353, 160)
modint_barrett.setMod(101)
modint_montgomery.setMod(101)
check[modint_barrett](101, 100)
check[modint_montgomery](101, 100)
check[acl.modint998244353](998244353, 160)
acl.modint.setMod(101)
check[acl.modint](101, 100)
let c = initCombination[acl.modint](101)
var caught = false
try: discard c.ncr_inv(101, 0)
except ValueError: caught = true
doAssert caught
acl.modint.setMod(103)
caught = false
try: discard c.ncr_inv(0, 0)
except ValueError: caught = true
doAssert caught
acl.modint.setMod(101)
var broken = initCombination[acl.modint](10)
broken.fact_inv[5] = 0
caught = false
try: discard broken.ncr_inv(5, 2)
except ValueError: caught = true
doAssert caught
echo "Hello World"
acl.modint.setMod(1)
let modOne = initCombination[acl.modint](0)
caught = false
try: discard modOne.ncr_inv(0, 0)
except ValueError: caught = true
doAssert caught

type Minimal = object
    val: int
converter toMinimal(x: int): Minimal = Minimal(val: (x mod 101 + 101) mod 101)
proc umod(M: typedesc[Minimal]): uint32 = 101
proc `*`(a, b: Minimal): Minimal = toMinimal(a.val * b.val)
proc `*`(a: Minimal, b: int): Minimal = toMinimal(a.val * b)
proc `-`(a: Minimal): Minimal = toMinimal(-a.val)
check[Minimal](101, 100)
