# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/geometry/base
import cplib/geometry/polygon
import cplib/math/fractions
import algorithm

proc checkArea[T]() =
    let triangle = initPolygon([
        initPoint(initFraction(T(0)), initFraction(T(0))),
        initPoint(initFraction(T(1)), initFraction(T(0))),
        initPoint(initFraction(T(0)), initFraction(T(1)))])
    doAssert triangle.area == initFraction(T(1), T(2))
    doAssert initPolygon(triangle.v.reversed).area == initFraction(T(-1), T(2))
    let concave = initPolygon([
        initPoint(initFraction(T(0)), initFraction(T(0))),
        initPoint(initFraction(T(3)), initFraction(T(0))),
        initPoint(initFraction(T(3)), initFraction(T(1))),
        initPoint(initFraction(T(1)), initFraction(T(1))),
        initPoint(initFraction(T(1)), initFraction(T(3))),
        initPoint(initFraction(T(0)), initFraction(T(3)))])
    doAssert concave.area == initFraction(T(5))
    for a in 0..<9:
        for b in 0..<9:
            for c in 0..<9:
                if a == b or b == c or c == a: continue
                let ax = a div 3 - 1
                let ay = a mod 3 - 1
                let bx = b div 3 - 1
                let by = b mod 3 - 1
                let cx = c div 3 - 1
                let cy = c mod 3 - 1
                let determinant = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax)
                for denominator in 1..2:
                    let polygon = initPolygon([
                        initPoint(initFraction(T(ax), T(denominator)), initFraction(T(ay), T(denominator))),
                        initPoint(initFraction(T(bx), T(denominator)), initFraction(T(by), T(denominator))),
                        initPoint(initFraction(T(cx), T(denominator)), initFraction(T(cy), T(denominator)))])
                    doAssert polygon.area == initFraction(T(determinant), T(2 * denominator * denominator))

checkArea[int]()
checkArea[int32]()
checkArea[int64]()
echo "Hello World"
