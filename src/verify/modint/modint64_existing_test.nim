# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/modint/modint64
import cplib/modint/modint
import cplib/math/combination

declarStaticModint64(Mint64Compare, 998244353u64)
declarStaticModint64(Mint64Other, 1000000007u64)
proc compare[A, B]() =
    var state = 123456789u64
    for _ in 0..<10000:
        state = state xor (state shl 13)
        state = state xor (state shr 7)
        state = state xor (state shl 17)
        let x = cast[int64](state)
        state = state xor (state shl 13)
        state = state xor (state shr 7)
        state = state xor (state shl 17)
        let y = cast[int64](state)
        let a = A.init(x)
        let b = A.init(y)
        let oldA = B.init(x.int)
        let oldB = B.init(y.int)
        doAssert a.val == oldA.val.uint64
        doAssert b.val == oldB.val.uint64
        doAssert (a + b).val == (oldA + oldB).val.uint64
        doAssert (a - b).val == (oldA - oldB).val.uint64
        doAssert (a * b).val == (oldA * oldB).val.uint64
        doAssert a.pow(12345).val == oldA.pow(12345).val.uint64
        if b.val != 0:
            doAssert (a / b).val == (oldA / oldB).val.uint64
    let c = initCombination[A](200)
    let oldC = initCombination[B](200)
    for n in 0..200:
        for k in 0..n:
            doAssert c.ncr(n, k).val == oldC.ncr(n, k).val.uint64
compare[Mint64Compare, modint998244353_montgomery]()
compare[Mint64Compare, modint998244353_barrett]()
compare[Mint64Other, modint1000000007_montgomery]()
compare[Mint64Other, modint1000000007_barrett]()
echo "Hello World"
