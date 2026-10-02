# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/geometry/base
import cplib/math/fractions

proc checkFractions[T]() =
    for ai in -3..3:
        for bi in -3..3:
            if ai == 0 and bi == 0: continue
            for ci in -3..3:
                let a = initFraction(T(ai), T(2))
                let b = initFraction(T(bi), T(3))
                let c = initFraction(T(ci), T(5))
                let line = initLine(a, b, c)
                doAssert line.s != line.t
                for p in [line.s, line.t]:
                    doAssert a * p.x + b * p.y + c == T(0)
                if bi == 0:
                    doAssert line.s.y == T(0)
                    doAssert line.t.y == T(1)
                    doAssert line.s.y.den == T(1)
                    doAssert line.t.y.den == T(1)
                else:
                    doAssert line.s.x == T(0)
                    doAssert line.t.x == T(1)
                    doAssert line.s.x.den == T(1)
                    doAssert line.t.x.den == T(1)

proc checkFloat[T: SomeFloat]() =
    for ai in -3..3:
        for bi in -3..3:
            if ai == 0 and bi == 0: continue
            for ci in -3..3:
                let a = T(ai)
                let b = T(bi)
                let c = T(ci)
                let line = initLine(a, b, c)
                doAssert line.s != line.t
                for p in [line.s, line.t]:
                    doAssert abs(a * p.x + b * p.y + c) < T(1e-5)

checkFractions[int]()
checkFractions[int32]()
checkFractions[int64]()
checkFloat[float64]()
checkFloat[float32]()
echo "Hello World"
