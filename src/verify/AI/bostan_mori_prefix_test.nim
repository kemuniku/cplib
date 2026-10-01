# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/fps/bostan_mori
import cplib/modint/modint

proc check[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =
    for size in [0, 1, 2, 7, 63, 64, 65, 129]:
        var p = newSeq[T](size)
        var q = newSeq[T](size + 3)
        for i in 0..<p.len: p[i] = init(T, i * i + 3)
        for i in 0..<q.len: q[i] = init(T, i * 7 + 2)
        let savedP = p
        let savedQ = q
        var expected = newSeq[T](140)
        for k in 0..<expected.len:
            var value = if k < p.len: p[k] else: init(T, 0)
            for i in 1..min(k, q.high): value -= q[i] * expected[k - i]
            expected[k] = value / q[0]
        for k in [0, 1, 2, 3, 7, 31, 63, 64, 65, 127, 139]:
            doAssert bostanMori(p, q, k) == expected[k]
            doAssert p == savedP and q == savedQ
        p.add(init(T, 0))
        q.add(init(T, 0))
        doAssert bostanMori(p, q, 3) == expected[3]
    let one = @[init(T, 1)]
    let geometric = @[init(T, 1), init(T, -1)]
    doAssert bostanMori(one, geometric, high(int)) == init(T, 1)
    doAssert bostanMori(one, one, high(int)) == init(T, 0)
    doAssert bostanMori(newSeq[T](), one, high(int)) == init(T, 0)
    let initial = @[init(T, 2), init(T, 3)]
    let coefficients = @[init(T, 1), init(T, 1)]
    var a = init(T, 2)
    var b = init(T, 3)
    for k in 0..100:
        doAssert linearRecurrenceKth(initial, coefficients, k) == a
        (a, b) = (b, a + b)

check(modint998244353_barrett)
check(modint998244353_montgomery)
echo "Hello World"
