# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/stern_brocot_tree

proc checkSmall[T](n, x, y: T, strict, inverted: bool) =
    proc isBelow(a, b: T): bool =
        if b == 0:
            return false
        if strict:
            return a * y < x * b
        return a * y <= x * b

    let bounds = get_bounds(proc(v: SBTNode[T]): bool =
        isBelow(v.num(), v.den()) xor inverted
    , n)
    var p = T(0)
    var q = T(1)
    var r = T(1)
    var s = T(0)
    for a in 1..int(n):
        for b in 1..int(n):
            if isBelow(T(a), T(b)):
                if T(a) * q > p * T(b):
                    p = T(a)
                    q = T(b)
            elif T(a) * s < r * T(b):
                r = T(a)
                s = T(b)
    doAssert bounds.p * q == p * bounds.q
    doAssert bounds.r * s == r * bounds.s
    doAssert bounds.q * bounds.r - bounds.p * bounds.s == 1
    doAssert bounds.p <= n and bounds.q <= n
    doAssert bounds.r <= n and bounds.s <= n
    doAssert bounds.num() > n or bounds.den() > n

proc testSmall[T]() =
    for n in 1..12:
        for x in 0..16:
            for y in 1..16:
                for strict in [false, true]:
                    if strict and x == 0:
                        continue
                    for inverted in [false, true]:
                        checkSmall(T(n), T(x), T(y), strict, inverted)

testSmall[int]()
testSmall[int32]()
testSmall[int64]()

proc checkLarge(n, x, y: int) =
    var calls = 0
    let bounds = get_bounds(proc(v: SBTNode[int]): bool =
        inc calls
        v.den() != 0 and v.num() * y <= x * v.den()
    , n)
    doAssert bounds.p * y <= x * bounds.q
    doAssert bounds.r * y > x * bounds.s
    doAssert bounds.q * bounds.r - bounds.p * bounds.s == 1
    doAssert bounds.p <= n and bounds.q <= n
    doAssert bounds.r <= n and bounds.s <= n
    doAssert bounds.num() > n or bounds.den() > n
    doAssert calls <= 128

for n in [500000000, 1000000000]:
    checkLarge(n, 433494437, 701408733)
    checkLarge(n, 701408733, 433494437)
    checkLarge(n, 1, 1000000000)
    checkLarge(n, 1000000000, 1)
    checkLarge(n, 1, 2)
    checkLarge(n, 2, 1)

echo "Hello World"
