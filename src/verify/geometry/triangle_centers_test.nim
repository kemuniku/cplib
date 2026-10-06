# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, options, random
import cplib/geometry/base
import cplib/geometry/triangle_centers

type P = Point[float64]

proc close(x, y: float64, tolerance = 2e-9) =
    doAssert x == x and abs(x) != system.Inf
    doAssert abs(x-y) <= tolerance * max(1.0, max(abs(x), abs(y))), $x &
            " != " & $y

proc close(p, q: P, tolerance = 2e-9) =
    close(p.x, q.x, tolerance)
    close(p.y, q.y, tolerance)

proc solve(matrix: array[3, array[4, float64]]): array[3, float64] =
    var a = matrix
    for column in 0..2:
        var pivot = column
        for row in column+1..2:
            if abs(a[row][column]) > abs(a[pivot][column]): pivot = row
        doAssert a[pivot][column] != 0.0
        swap(a[pivot], a[column])
        let divisor = a[column][column]
        for j in column..3: a[column][j] /= divisor
        for row in 0..2:
            if row == column: continue
            let factor = a[row][column]
            for j in column..3: a[row][j] -= factor * a[column][j]
    for i in 0..2: result[i] = a[i][3]

proc distanceCenter(points: array[3, P], ex = -1): P =
    var equations: array[3, array[4, float64]]
    let orientation = if cross(points[1]-points[0], points[2]-points[0]) >
            0.0: 1.0 else: -1.0
    for i in 0..2:
        let j = (i+1) mod 3
        let delta = points[j]-points[i]
        let length = hypot(delta.x, delta.y)
        let nx = -orientation * delta.y / length
        let ny = orientation * delta.x / length
        let radiusSign = if (i+2) mod 3 == ex: -1.0 else: 1.0
        equations[i] = [nx, ny, -radiusSign, nx*points[i].x + ny*points[i].y]
    let answer = solve(equations)
    initPoint(answer[0], answer[1])

proc verify(points: array[3, Point[int]]) =
    let a = points[0]
    let b = points[1]
    let c = points[2]
    let integerArea = (b.x-a.x)*(c.y-a.y) - (b.y-a.y)*(c.x-a.x)
    var p: array[3, P]
    for i in 0..2: p[i] = initPoint(float64(points[i].x), float64(points[i].y))
    close(centroid(a, b, c), initPoint(float64(a.x+b.x+c.x)/3.0, float64(
            a.y+b.y+c.y)/3.0))
    doAssert is_degenerate_triangle(a, b, c) == (integerArea == 0)
    if integerArea == 0:
        doAssert circumcenter(a, b, c).isNone
        doAssert orthocenter(a, b, c).isNone
        doAssert incenter(a, b, c).isNone
        doAssert excenters(a, b, c).isNone
        return
    let u = b-a
    let v = c-a
    let uu = u.x*u.x + u.y*u.y
    let vv = v.x*v.x + v.y*v.y
    let exactO = initPoint(float64(a.x) + float64(uu*v.y-vv*u.y)/float64(2*integerArea),
                           float64(a.y) + float64(vv*u.x-uu*v.x)/float64(2*integerArea))
    let o = circumcenter(a, b, c).get
    close(o, exactO)
    let w = c-b
    let altitude = solve([[float64(w.x), float64(w.y), 0.0, float64(w.x*a.x+w.y*a.y)],
                          [float64(v.x), float64(v.y), 0.0, float64(
                                  v.x*b.x+v.y*b.y)],
                          [0.0, 0.0, 1.0, 0.0]])
    close(orthocenter(a, b, c).get, initPoint(altitude[0], altitude[1]))
    close(incenter(a, b, c).get, distanceCenter(p))
    let ex = excenters(a, b, c).get
    for i in 0..2: close(ex[i], distanceCenter(p, i), 1e-8)
    for i in 0..2:
        close(hypot(o.x-p[i].x, o.y-p[i].y), hypot(o.x-p[0].x, o.y-p[0].y))
    for order in [[0, 1, 2], [0, 2, 1], [1, 0, 2], [1, 2, 0], [2, 0, 1], [2, 1, 0]]:
        close(centroid(p[order[0]], p[order[1]], p[order[2]]), centroid(p[0], p[
                1], p[2]))
        close(circumcenter(p[order[0]], p[order[1]], p[order[2]]).get, o)
        close(orthocenter(p[order[0]], p[order[1]], p[order[2]]).get,
                orthocenter(a, b, c).get)
        close(incenter(p[order[0]], p[order[1]], p[order[2]]).get, incenter(a,
                b, c).get)
        let permuted = excenters(p[order[0]], p[order[1]], p[order[2]]).get
        for i in 0..2: close(permuted[i], ex[order[i]])

for ax in -1..1:
    for ay in -1..1:
        for bx in -1..1:
            for by in -1..1:
                for cx in -1..1:
                    for cy in -1..1:
                        verify([initPoint(ax, ay), initPoint(bx, by), initPoint(
                                cx, cy)])
var rng = initRand(275)
for trial in 0..<2500:
    var points: array[3, Point[int]]
    for i in 0..2: points[i] = initPoint(rng.rand(-100..100), rng.rand(-100..100))
    verify(points)

let right = [initPoint(0.0, 0.0), initPoint(4.0, 0.0), initPoint(0.0, 3.0)]
close(centroid(right[0], right[1], right[2]), initPoint(4.0/3.0, 1.0))
close(circumcenter(right[0], right[1], right[2]).get, initPoint(2.0, 1.5))
close(orthocenter(right[0], right[1], right[2]).get, right[0])
close(incenter(right[0], right[1], right[2]).get, initPoint(1.0, 1.0))
let rightEx = excenters(right[0], right[1], right[2]).get
close(rightEx[0], initPoint(6.0, 6.0))
close(rightEx[1], initPoint(-2.0, 2.0))
close(rightEx[2], initPoint(3.0, -3.0))

for scale in [1e-150, 1e-50, 1.0, 1e50, 1e150]:
    for sign in [-1.0, 1.0]:
        let a = right[0]*scale*sign
        let b = right[1]*scale*sign
        let c = right[2]*scale*sign
        doAssert not is_degenerate_triangle(a, b, c)
        close(centroid(a, b, c)/scale, centroid(right[0], right[1], right[2])*sign)
        close(circumcenter(a, b, c).get/scale, initPoint(2.0, 1.5)*sign)
        close(orthocenter(a, b, c).get/scale, initPoint(0.0, 0.0))
        close(incenter(a, b, c).get/scale, initPoint(1.0, 1.0)*sign)
        for i in 0..2: close(excenters(a, b, c).get[i]/scale, rightEx[i]*sign)

for offset in [initPoint(1e12, -1e12), initPoint(-1e15, 1e15)]:
    let a = right[0]+offset
    let b = right[1]+offset
    let c = right[2]+offset
    close(centroid(a, b, c)-offset, centroid(right[0], right[1], right[2]), 0.15)
    close(circumcenter(a, b, c).get-offset, initPoint(2.0, 1.5), 1e-12)
    close(orthocenter(a, b, c).get-offset, right[0], 1e-12)
    close(incenter(a, b, c).get-offset, initPoint(1.0, 1.0), 1e-12)
    for i in 0..2: close(excenters(a, b, c).get[i]-offset, rightEx[i], 1e-12)

block:
    let a = initPoint(0.0, 0.0)
    let b = initPoint(1.0, 0.0)
    for height in [0.0, 5e-13, 1e-12, 2e-12, 1e-8]:
        let c = initPoint(0.5, height)
        doAssert is_degenerate_triangle(a, b, c) == (height <= 1e-12)
        doAssert circumcenter(a, b, c).isNone == (height <= 1e-12)
        doAssert orthocenter(a, b, c).isNone == (height <= 1e-12)
        doAssert incenter(a, b, c).isNone == (height <= 1e-12)
        doAssert excenters(a, b, c).isNone == (height <= 1e-12)
        if height > 0.0:
            doAssert not is_degenerate_triangle(a, b, c, 0.0)
            let o = circumcenter(a, b, c, 0.0).get
            close(o.x, 0.5)
            close(o.y, (height*height-0.25)/(2.0*height))
            let ex = excenters(a, b, c, 0.0).get
            close(ex[2].x, 0.5)
            close(ex[2].y, -(hypot(0.5, height)+0.5)/(2.0*height), 1e-8)
    doAssert is_degenerate_triangle(a, b, initPoint(0.0, 1.0), 1.0)
    doAssert not is_degenerate_triangle(a, b, initPoint(0.0, 1.0), 0.49)
    doAssert is_degenerate_triangle(a, b, initPoint(0.0, 1.0), 0.5)

block:
    let p = [initPoint(0'f32, 0'f32), initPoint(4'f32, 0'f32), initPoint(0'f32, 3'f32)]
    close(circumcenter(p[0], p[1], p[2]).get, initPoint(2.0, 1.5))
    close(incenter(p[0], p[1], p[2]).get, initPoint(1.0, 1.0))
    close(orthocenter(p[0], p[1], p[2]).get, right[0])
    close(centroid(p[0], p[1], p[2]), centroid(right[0], right[1], right[2]))
    for i in 0..2: close(excenters(p[0], p[1], p[2]).get[i], rightEx[i])
    let q = [initPoint(0'u64, 0'u64), initPoint(4'u64, 0'u64), initPoint(0'u64, 3'u64)]
    close(circumcenter(q[0], q[1], q[2]).get, initPoint(2.0, 1.5))
    close(incenter(q[0], q[1], q[2]).get, initPoint(1.0, 1.0))
    close(orthocenter(q[0], q[1], q[2]).get, right[0])
    close(centroid(q[0], q[1], q[2]), centroid(right[0], right[1], right[2]))
    for i in 0..2: close(excenters(q[0], q[1], q[2]).get[i], rightEx[i])
    let large = 1'i64 shl 60
    let a = initPoint(large, large)
    let b = initPoint(large+1024, large)
    let c = initPoint(large, large+1024)
    close(circumcenter(a, b, c).get-initPoint(float64(large), float64(large)),
            initPoint(512.0, 512.0), 1e-12)
    doAssert is_degenerate_triangle(a, initPoint(large+1, large), initPoint(
            large, large+1))
    doAssert not is_degenerate_triangle(initPoint(low(int64), 0'i64), initPoint(
            high(int64), 0'i64), initPoint(0'i64, high(int64)))

block:
    let maximum = 1.7976931348623157e308
    let a = initPoint(maximum, maximum)
    close(centroid(a, a, a), a, 0.0)
    close(centroid(a, -a, initPoint(0.0, 0.0)), initPoint(0.0, 0.0), 0.0)
    let tiny = initPoint(0.0, 0.0)
    let b = initPoint(1e308, 0.0)
    let c = initPoint(0.5e308, 2e296)
    doAssert not is_degenerate_triangle(tiny, b, c)
    doAssert circumcenter(tiny, b, c).isNone
    doAssert orthocenter(tiny, b, c).isNone
    doAssert excenters(tiny, b, c).isNone
    doAssert incenter(tiny, b, c).isSome
    doAssert is_degenerate_triangle(tiny, initPoint(1e300, 0.0), initPoint(0.0, 1e-300))

for bad in [NaN, system.Inf, -system.Inf]:
    let a = initPoint(bad, 0.0)
    let b = initPoint(1.0, 0.0)
    let c = initPoint(0.0, 1.0)
    for operation in 0..5:
        var raised = false
        try:
            case operation
            of 0: discard centroid(a, b, c)
            of 1: discard is_degenerate_triangle(a, b, c)
            of 2: discard circumcenter(a, b, c)
            of 3: discard orthocenter(a, b, c)
            of 4: discard incenter(a, b, c)
            else: discard excenters(a, b, c)
        except ValueError: raised = true
        doAssert raised
for tolerance in [-1.0, 1.01, NaN, system.Inf, -system.Inf]:
    for operation in 0..4:
        var raised = false
        try:
            case operation
            of 0: discard is_degenerate_triangle(right[0], right[1], right[2], tolerance)
            of 1: discard circumcenter(right[0], right[1], right[2], tolerance)
            of 2: discard orthocenter(right[0], right[1], right[2], tolerance)
            of 3: discard incenter(right[0], right[1], right[2], tolerance)
            else: discard excenters(right[0], right[1], right[2], tolerance)
        except ValueError: raised = true
        doAssert raised
for operation in 0..4:
    var raised = false
    try:
        let a = initPoint(-1.7e308, 0.0)
        let b = initPoint(1.7e308, 0.0)
        let c = initPoint(0.0, 1.0)
        case operation
        of 0: discard is_degenerate_triangle(a, b, c)
        of 1: discard circumcenter(a, b, c)
        of 2: discard orthocenter(a, b, c)
        of 3: discard incenter(a, b, c)
        else: discard excenters(a, b, c)
    except ValueError: raised = true
    doAssert raised

let savedEPS = GEOMETRY_EPS
for eps in [0.0, 1.0, 1e100]:
    GEOMETRY_EPS = eps
    close(incenter(right[0], right[1], right[2]).get, initPoint(1.0, 1.0))
    close(circumcenter(right[0], right[1], right[2]).get, initPoint(2.0, 1.5))
    doAssert not is_degenerate_triangle(right[0], right[1], right[2])
GEOMETRY_EPS = savedEPS



block:
    let oracleCases = [
        ([0.0, 0.0, 4e-150, 0.0, 0.0, 3e-150], [initPoint(1.3333333333333333e-150, 1e-150), initPoint(2e-150, 1.5e-150), initPoint(1e-150, 1e-150), initPoint(0.0, 2e-249), initPoint(6e-150, 6e-150), initPoint(-2e-150, 2e-150), initPoint(3e-150, -3e-150)]),
        ([0.0, 0.0, 1e-150, 0.0, 2.5e-151, 2e-162], [initPoint(4.1666666666666664e-151, 6.666666666666666e-163), initPoint(5e-151, -4.6875e-140), initPoint(2.5e-151, 1e-162), initPoint(2.5e-151, 9.375e-140), initPoint(1e-150, 4e-162), initPoint(-5.333333333333332e-174, 1.3333333333333333e-162), initPoint(7.5e-151, -1.875e-139)]),
        ([0.0, 0.0, 1e-150, 0.0, 5e-151, 1e-158], [initPoint(5e-151, 3.3333333333333334e-159), initPoint(5e-151, -1.2499999999999994e-143), initPoint(5e-151, 5e-159), initPoint(5e-151, 2.4999999999999996e-143), initPoint(1.0000000000000001e-150, 1e-158), initPoint(-1e-166, 1e-158), initPoint(5e-151, -5e-143)]),
        ([0.0, 0.0, 1e-150, 0.0, 7.5e-151, 9.999999999999999e-157], [initPoint(5.833333333333334e-151, 3.333333333333333e-157), initPoint(5e-151, -9.37499999995e-146), initPoint(7.499999999993334e-151, 4.999999999993333e-157), initPoint(7.5e-151, 1.875e-145), initPoint(1.0000000000013333e-150, 6.666666666672592e-157), initPoint(-1.333333333329185e-162, 1.9999999999946667e-156), initPoint(2.5000000000066663e-151, -3.750000000011667e-145)]),
        ([0.0, 0.0, 1e-158, 0.0, 2.9999999999999998e-151, 1e-150], [initPoint(1.0000000333333333e-151, 3.3333333333333334e-151), initPoint(5e-159, 5.449999985e-151), initPoint(6.436739405863235e-159, 4.789131409760525e-159), initPoint(2.9999999999999998e-151, -8.999999699999999e-152), initPoint(1.0440306544543156e-150, 7.767908073838586e-151), initPoint(-1.0440306444543157e-150, 1.4032091866161415e-150), initPoint(3.563260594136766e-159, -4.789131455632085e-159)]),
        ([0.0, 0.0, 4e-50, 0.0, 0.0, 3e-50], [initPoint(1.3333333333333333e-50, 1e-50), initPoint(2e-50, 1.5e-50), initPoint(1e-50, 1e-50), initPoint(0.0, 1e-149), initPoint(6e-50, 6e-50), initPoint(-2e-50, 2e-50), initPoint(3e-50, -3e-50)]),
        ([0.0, 0.0, 1e-50, 0.0, 2.5e-51, 2e-62], [initPoint(4.1666666666666666e-51, 6.666666666666667e-63), initPoint(5e-51, -4.6875e-40), initPoint(2.5e-51, 1e-62), initPoint(2.5e-51, 9.375e-40), initPoint(1e-50, 4e-62), initPoint(-5.333333333333334e-74, 1.3333333333333334e-62), initPoint(7.5e-51, -1.875e-39)]),
        ([0.0, 0.0, 1e-50, 0.0, 5e-51, 1e-58], [initPoint(5e-51, 3.3333333333333333e-59), initPoint(5e-51, -1.2499999999999994e-43), initPoint(5e-51, 4.999999999999999e-59), initPoint(5e-51, 2.5e-43), initPoint(1.0000000000000001e-50, 1e-58), initPoint(-1e-66, 1e-58), initPoint(5e-51, -5e-43)]),
        ([0.0, 0.0, 1e-50, 0.0, 7.5e-51, 9.999999999999999e-57], [initPoint(5.833333333333333e-51, 3.333333333333333e-57), initPoint(5e-51, -9.374999999950002e-46), initPoint(7.499999999993333e-51, 4.999999999993333e-57), initPoint(7.5e-51, 1.8750000000000005e-45), initPoint(1.0000000000013333e-50, 6.666666666672593e-57), initPoint(-1.3333333333291848e-62, 1.9999999999946663e-56), initPoint(2.500000000006667e-51, -3.750000000011667e-45)]),
        ([0.0, 0.0, 1e-58, 0.0, 3e-51, 1e-50], [initPoint(1.0000000333333333e-51, 3.333333333333333e-51), initPoint(5e-59, 5.449999985e-51), initPoint(6.436739405863234e-59, 4.789131409760525e-59), initPoint(3e-51, -8.9999997e-52), initPoint(1.0440306544543156e-50, 7.767908073838586e-51), initPoint(-1.0440306444543156e-50, 1.4032091866161414e-50), initPoint(3.563260594136766e-59, -4.7891314556320845e-59)]),
        ([0.0, 0.0, 4.0, 0.0, 0.0, 3.0], [initPoint(1.3333333333333333, 1.0), initPoint(2.0, 1.5), initPoint(1.0, 1.0), initPoint(0.0, 0.0), initPoint(6.0, 6.0), initPoint(-2.0, 2.0), initPoint(3.0, -3.0)]),
        ([0.0, 0.0, 1.0, 0.0, 0.25, 2e-12], [initPoint(0.4166666666666667, 6.666666666666667e-13), initPoint(0.5, -46875000000.0), initPoint(0.25, 1e-12), initPoint(0.25, 93750000000.0), initPoint(1.0, 4e-12), initPoint(-5.333333333333333e-24, 1.3333333333333334e-12), initPoint(0.75, -187500000000.0)]),
        ([0.0, 0.0, 1.0, 0.0, 0.5, 1e-08], [initPoint(0.5, 3.3333333333333334e-09), initPoint(0.5, -12499999.999999994), initPoint(0.5, 4.999999999999999e-09), initPoint(0.5, 25000000.0), initPoint(1.0, 1e-08), initPoint(-1e-16, 1e-08), initPoint(0.5, -50000000.00000001)]),
        ([0.0, 0.0, 1.0, 0.0, 0.75, 1e-06], [initPoint(0.5833333333333334, 3.333333333333333e-07), initPoint(0.5, -93749.99999950001), initPoint(0.7499999999993333, 4.999999999993334e-07), initPoint(0.75, 187500.0), initPoint(1.0000000000013334, 6.666666666672592e-07), initPoint(-1.3333333333291852e-12, 1.9999999999946666e-06), initPoint(0.2500000000006667, -375000.00000116666)]),
        ([0.0, 0.0, 1e-08, 0.0, 0.3, 1.0], [initPoint(0.10000000333333332, 0.3333333333333333), initPoint(5e-09, 0.5449999985), initPoint(6.4367394058632345e-09, 4.789131409760525e-09), initPoint(0.3, -0.089999997), initPoint(1.0440306544543156, 0.7767908073838586), initPoint(-1.0440306444543157, 1.4032091866161414), initPoint(3.5632605941367657e-09, -4.789131455632085e-09)]),
        ([0.0, 0.0, 4e+50, 0.0, 0.0, 3.0000000000000002e+50], [initPoint(1.3333333333333335e+50, 1e+50), initPoint(2e+50, 1.5000000000000001e+50), initPoint(1e+50, 1e+50), initPoint(0.0, 0.0), initPoint(6.0000000000000005e+50, 6.0000000000000005e+50), initPoint(-2e+50, 2e+50), initPoint(3.0000000000000002e+50, -3.0000000000000002e+50)]),
        ([0.0, 0.0, 1e+50, 0.0, 2.5e+49, 2e+38], [initPoint(4.166666666666667e+49, 6.6666666666666665e+37), initPoint(5e+49, -4.687500000000001e+60), initPoint(2.5e+49, 1e+38), initPoint(2.5e+49, 9.375000000000001e+60), initPoint(1e+50, 4e+38), initPoint(-5.333333333333333e+26, 1.3333333333333333e+38), initPoint(7.500000000000001e+49, -1.8750000000000003e+61)]),
        ([0.0, 0.0, 1e+50, 0.0, 5e+49, 1e+42], [initPoint(5e+49, 3.3333333333333336e+41), initPoint(5e+49, -1.2499999999999996e+57), initPoint(5e+49, 4.9999999999999995e+41), initPoint(5e+49, 2.5000000000000002e+57), initPoint(1e+50, 1e+42), initPoint(-1e+34, 1e+42), initPoint(5e+49, -5.000000000000001e+57)]),
        ([0.0, 0.0, 1e+50, 0.0, 7.500000000000001e+49, 1e+44], [initPoint(5.833333333333333e+49, 3.3333333333333336e+43), initPoint(5e+49, -9.37499999995e+54), initPoint(7.499999999993334e+49, 4.999999999993333e+43), initPoint(7.500000000000001e+49, 1.875e+55), initPoint(1.0000000000013335e+50, 6.666666666672594e+43), initPoint(-1.3333333333291854e+38, 1.999999999994667e+44), initPoint(2.500000000006667e+49, -3.750000000011667e+55)]),
        ([0.0, 0.0, 1e+42, 0.0, 3e+49, 1e+50], [initPoint(1.0000000333333334e+49, 3.333333333333334e+49), initPoint(5e+41, 5.449999985000001e+49), initPoint(6.436739405863235e+41, 4.789131409760525e+41), initPoint(3e+49, -8.9999997e+48), initPoint(1.0440306544543157e+50, 7.767908073838587e+49), initPoint(-1.0440306444543158e+50, 1.4032091866161416e+50), initPoint(3.563260594136766e+41, -4.789131455632085e+41)]),
        ([0.0, 0.0, 4e+150, 0.0, 0.0, 2.9999999999999998e+150], [initPoint(1.3333333333333332e+150, 1e+150), initPoint(2e+150, 1.4999999999999999e+150), initPoint(1e+150, 1e+150), initPoint(0.0, 0.0), initPoint(5.9999999999999995e+150, 5.9999999999999995e+150), initPoint(-2e+150, 2e+150), initPoint(3e+150, -3e+150)]),
        ([0.0, 0.0, 1e+150, 0.0, 2.5e+149, 2e+138], [initPoint(4.166666666666667e+149, 6.666666666666667e+137), initPoint(5e+149, -4.6875e+160), initPoint(2.5e+149, 1e+138), initPoint(2.5e+149, 9.375e+160), initPoint(1e+150, 4e+138), initPoint(-5.333333333333334e+126, 1.3333333333333334e+138), initPoint(7.499999999999999e+149, -1.875e+161)]),
        ([0.0, 0.0, 1e+150, 0.0, 5e+149, 1e+142], [initPoint(5e+149, 3.333333333333333e+141), initPoint(5e+149, -1.2499999999999993e+157), initPoint(5e+149, 4.9999999999999996e+141), initPoint(5e+149, 2.5e+157), initPoint(1.0000000000000002e+150, 1e+142), initPoint(-1e+134, 1e+142), initPoint(5e+149, -5e+157)]),
        ([0.0, 0.0, 1e+150, 0.0, 7.499999999999999e+149, 9.999999999999999e+143], [initPoint(5.833333333333333e+149, 3.333333333333333e+143), initPoint(5e+149, -9.374999999950002e+154), initPoint(7.4999999999933325e+149, 4.999999999993333e+143), initPoint(7.499999999999999e+149, 1.8750000000000004e+155), initPoint(1.0000000000013334e+150, 6.666666666672592e+143), initPoint(-1.3333333333291846e+138, 1.999999999994666e+144), initPoint(2.500000000006667e+149, -3.7500000000116674e+155)]),
        ([0.0, 0.0, 1e+142, 0.0, 3e+149, 1e+150], [initPoint(1.0000000333333333e+149, 3.333333333333333e+149), initPoint(5e+141, 5.449999985e+149), initPoint(6.436739405863234e+141, 4.7891314097605253e+141), initPoint(3e+149, -8.9999997e+148), initPoint(1.0440306544543156e+150, 7.7679080738385855e+149), initPoint(-1.0440306444543156e+150, 1.4032091866161415e+150), initPoint(3.563260594136766e+141, -4.789131455632085e+141)]),
        ([11.5, 21.5, -1.25, 10.5, -6.25, -4.75], [initPoint(1.3333333333333333, 9.083333333333334), initPoint(24.415676826535186, -6.359648139847602), initPoint(0.6148575634372313, 9.25707308083604), initPoint(-44.83135365307037, 39.96929627969521), initPoint(-10.14259835491153, -2.8422400344510246), initPoint(99.09278610997552, -56.378432136191336), initPoint(8.097661987639517, 24.52500653041591)]),
        ([999999999996.25, 1000000000015.0, 999999999983.25, 1000000000014.5, 999999999997.5, 999999999997.75], [initPoint(999999999992.3334, 1000000000009.0834), initPoint(999999999990.0911, 1000000000005.8834), initPoint(999999999992.2616, 1000000000010.5435), initPoint(999999999996.818, 1000000000015.4832), initPoint(999999999971.1608, 999999999986.9652), initPoint(1000000000009.867, 1000000000002.8137), initPoint(999999999987.0747, 1000000000023.2113)]),
        ([1000000000000003.0, 1000000000000011.5, 1000000000000010.8, 1000000000000002.5, 1000000000000005.8, 1000000000000019.8], [initPoint(1000000000000006.5, 1000000000000011.2), initPoint(1000000000000013.4, 1000000000000012.6), initPoint(1000000000000005.6, 1000000000000012.0), initPoint(999999999999992.8, 1000000000000008.5), initPoint(1000000000000041.2, 1000000000000019.0), initPoint(1000000000000001.4, 1000000000000019.9), initPoint(1000000000000005.4, 999999999999999.6)]),
        ([999999999988.0, 1000000000014.25, 1000000000016.25, 1000000000019.25, 1000000000011.5, 999999999977.75], [initPoint(1000000000005.25, 1000000000003.75), initPoint(1000000000005.179, 999999999999.4954), initPoint(1000000000004.6904, 1000000000006.9602), initPoint(1000000000005.3922, 1000000000012.2593), initPoint(1000000000050.6646, 999999999986.8802), initPoint(999999999967.5867, 999999999967.5127), initPoint(999999999997.774, 1000000000036.6282)]),
        ([-1000000000000002.5, -1000000000000012.8, -1000000000000005.0, -1000000000000011.0, -999999999999982.2, -1000000000000002.8], [initPoint(-999999999999996.6, -1000000000000008.9), initPoint(-999999999999995.9, -1000000000000000.6), initPoint(-1000000000000002.4, -1000000000000011.4), initPoint(-999999999999998.0, -1000000000000025.2), initPoint(-999999999999998.8, -999999999999964.0), initPoint(-999999999999977.1, -1000000000000014.6), initPoint(-1000000000000005.2, -1000000000000012.5)]),
        ([1000000000000024.2, 999999999999985.5, 1000000000000017.2, 1000000000000005.8, 1000000000000019.2, 1000000000000003.8], [initPoint(1000000000000020.2, 999999999999998.4), initPoint(1000000000000003.0, 999999999999989.5), initPoint(1000000000000018.8, 1000000000000003.4), initPoint(1000000000000054.8, 1000000000000016.0), initPoint(1000000000000017.9, 1000000000000006.1), initPoint(1000000000000029.0, 999999999999987.0), initPoint(999999999999946.4, 999999999999961.4)]),
        ([999999999998.0, 1000000000006.75, 999999999980.75, 999999999990.25, 999999999987.5, 1000000000002.75], [initPoint(999999999988.75, 999999999999.9166), initPoint(999999999998.9407, 999999999988.4995), initPoint(999999999988.9868, 1000000000001.0542), initPoint(999999999968.3687, 1000000000022.7509), initPoint(999999999976.7345, 999999999993.3113), initPoint(999999999995.883, 1000000000010.0999), initPoint(1000000000034.1582, 999999999949.5328)]),
        ([1000000000000008.0, 999999999999982.5, 999999999999999.5, 999999999999982.5, 999999999999985.8, 1000000000000013.2], [initPoint(999999999999997.8, 999999999999992.8), initPoint(1000000000000003.8, 1000000000000002.9), initPoint(1000000000000001.6, 999999999999985.8), initPoint(999999999999985.8, 999999999999972.5), initPoint(999999999999967.9, 1000000000000003.0), initPoint(1000000000000039.6, 1000000000000044.2), initPoint(1000000000000005.9, 999999999999978.4)]),
        ([-999999999997.5, -1000000000004.5, -1000000000013.25, -1000000000024.5, -1000000000010.75, -1000000000011.0], [initPoint(-1000000000007.1666, -1000000000013.3334), initPoint(-999999999997.9423, -1000000000020.3533), initPoint(-1000000000008.0618, -1000000000013.0391), initPoint(-1000000000025.6155, -999999999999.2935), initPoint(-1000000000019.0115, -1000000000021.8918), initPoint(-1000000000001.7926, -999999999999.1906), initPoint(-999999999962.9033, -1000000000047.2916)]),
        ([-19.0, -8.0, -19.75, 11.75, 1.0, 5.25], [initPoint(-12.583333333333334, 3.0), initPoint(-11.35489658897978, 2.1795608890260842), initPoint(-13.239768443778694, 3.2321089243251544), initPoint(-15.040206822040439, 4.6408782219478315), initPoint(-1.8588512364727061, 25.424220557949223), initPoint(4.592146214117067, -20.09890555879817), initPoint(-34.91311288978479, 0.1608196326281312)]),
        ([-999999999982.0, -1000000000009.0, -1000000000010.75, -1000000000024.0, -999999999990.25, -999999999997.75], [initPoint(-999999999994.3334, -1000000000010.25), initPoint(-999999999998.4913, -1000000000012.4436), initPoint(-999999999990.3907, -1000000000007.048), initPoint(-999999999986.0173, -1000000000005.8627), initPoint(-1000000000033.1476, -999999999997.1007), initPoint(-999999999979.4209, -999999999997.914), initPoint(-999999999991.0062, -1000000000047.712)]),
        ([3.0, -11.0, 15.25, -19.25, 0.25, -7.25], [initPoint(6.166666666666667, -12.5), initPoint(24.427419354838708, 7.596774193548387), initPoint(3.423283506566958, -10.559414587630991), initPoint(-30.35483870967742, -52.693548387096776), initPoint(80.87933743766774, 70.06269076792438), initPoint(-0.32720148602710514, -7.80345859730645), initPoint(13.734257961147238, -21.312720808793387)]),
        ([-999999999999986.0, -1000000000000017.8, -1000000000000005.8, -999999999999999.0, -1000000000000002.2, -1000000000000003.0], [initPoint(-999999999999998.0, -1000000000000006.6), initPoint(-999999999999914.6, -999999999999922.9), initPoint(-1000000000000002.1, -1000000000000002.9), initPoint(-1000000000000164.8, -1000000000000174.1), initPoint(-1000000000000006.0, -999999999999999.2), initPoint(-999999999999986.9, -1000000000000018.6), initPoint(-999999999999663.8, -999999999999670.6)]),
        ([-1000000000024.75, -1000000000014.0, -999999999988.5, -1000000000017.0, -1000000000017.0, -999999999986.0], [initPoint(-1000000000010.0834, -1000000000005.6666), initPoint(-1000000000005.6901, -1000000000004.203), initPoint(-1000000000012.3351, -1000000000005.3396), initPoint(-1000000000018.8699, -1000000000008.5941), initPoint(-999999999967.4923, -999999999974.0582), initPoint(-1000000000040.3528, -999999999991.6329), initPoint(-1000000000002.5801, -1000000000045.7811)]),
        ([-999999999999992.8, -1000000000000024.0, -999999999999985.0, -999999999999992.0, -999999999999988.0, -999999999999980.2], [initPoint(-999999999999988.6, -999999999999998.8), initPoint(-1000000000000031.6, -999999999999997.6), initPoint(-999999999999987.1, -999999999999992.0), initPoint(-999999999999902.5, -1000000000000001.0), initPoint(-999999999999985.1, -999999999999980.0), initPoint(-1000000000000169.5, -999999999999993.1), initPoint(-999999999999984.8, -1000000000000025.4)]),
        ([999999999999999.8, 1000000000000011.0, 1000000000000021.0, 999999999999994.2, 1000000000000011.0, 999999999999984.5], [initPoint(1000000000000010.6, 999999999999996.6), initPoint(1000000000000007.1, 999999999999998.5), initPoint(1000000000000012.9, 999999999999993.9), initPoint(1000000000000017.5, 999999999999992.8), initPoint(1000000000000021.6, 999999999999982.4), initPoint(999999999999974.6, 999999999999991.8), initPoint(1000000000000019.4, 1000000000000026.0)]),
        ([-999999999989.25, -999999999981.5, -999999999993.25, -1000000000016.75, -999999999988.0, -999999999990.0], [initPoint(-999999999990.1666, -999999999996.0834), initPoint(-1000000000041.1052, -999999999993.4677), initPoint(-999999999989.1101, -999999999989.9735), initPoint(-999999999888.2897, -1000000000001.3147), initPoint(-999999999988.6562, -1000000000017.4602), initPoint(-999999999987.7963, -999999999981.476), initPoint(-1000000000198.8582, -999999999984.9609)]),
        ([-10.0, 13.5, -14.75, 17.25, -18.25, -17.25], [initPoint(-14.333333333333334, 4.5), initPoint(-23.91896186440678, 0.7526483050847458), initPoint(-12.772024053161928, 12.580785164895325), initPoint(4.83792372881356, 11.994703389830509), initPoint(-72.62137837826023, -7.2655124544611915), initPoint(1.3929710694196875, -20.857136803403503), initPoint(-11.675416095624643, 18.552457313308356)]),
        ([1000000000007.75, 999999999992.25, 1000000000017.5, 999999999998.25, 1000000000014.0, 999999999976.0], [initPoint(1000000000013.0834, 999999999988.8334), initPoint(1000000000017.8259, 999999999986.7985), initPoint(1000000000012.4463, 999999999990.6625), initPoint(1000000000003.5981, 999999999992.9031), initPoint(1000000000045.8397, 999999999979.374), initPoint(1000000000001.8206, 999999999974.7094), initPoint(1000000000011.1974, 1000000000002.448)]),
        ([999999999999995.0, 999999999999975.0, 999999999999994.2, 1000000000000004.0, 1000000000000021.8, 999999999999975.8], [initPoint(1000000000000003.6, 999999999999984.9), initPoint(1000000000000008.0, 999999999999989.9), initPoint(1000000000000003.0, 999999999999983.4), initPoint(999999999999995.0, 999999999999975.0), initPoint(1000000000000041.2, 1000000000000023.8), initPoint(1000000000000014.1, 999999999999956.9), initPoint(999999999999973.6, 999999999999995.2)]),
        ([1000000000022.25, 1000000000019.25, 1000000000010.25, 999999999988.5, 1000000000019.5, 999999999989.75], [initPoint(1000000000017.3334, 999999999999.1666), initPoint(1000000000012.6942, 1000000000005.2626), initPoint(1000000000016.0487, 999999999993.0614), initPoint(1000000000026.6116, 999999999986.9747), initPoint(1000000000013.8768, 999999999983.8893), initPoint(1000000000043.0732, 1000000000014.3192), initPoint(999999999977.7781, 1000000000029.7806)]),
        ([-21.5, -19.0, -24.25, -11.5, -14.5, -13.25], [initPoint(-20.083333333333332, -14.583333333333334), initPoint(-19.680809698078683, -14.078796889295518), initPoint(-20.349619359320748, -14.775082736818144), initPoint(-20.888380603842634, -15.592406221408966), initPoint(-17.158198999574015, -3.0541909770241062), initPoint(-12.351445633138573, -21.491012054970508), initPoint(-28.863974800281394, -16.994901788369308)]),
        ([1000000000000008.0, 1000000000000025.0, 1000000000000001.8, 1000000000000019.8, 1000000000000008.5, 999999999999998.5], [initPoint(1000000000000006.1, 1000000000000014.4), initPoint(1000000000000013.8, 1000000000000011.9), initPoint(1000000000000005.1, 1000000000000018.8), initPoint(999999999999990.9, 1000000000000019.5), initPoint(999999999999995.0, 999999999999996.2), initPoint(1000000000000050.9, 1000000000000005.5), initPoint(1000000000000003.9, 1000000000000026.9)]),
        ([-24.75, 10.25, 10.0, -19.75, 6.5, 21.75], [initPoint(-2.75, 4.083333333333333), initPoint(-3.248142002430588, 0.030277180517902215), initPoint(-3.304636619337152, 6.3525748327209985), initPoint(-1.753715995138824, 12.189445638964196), initPoint(44.2538906347391, -2.2905895543136046), initPoint(-19.635486344063548, 38.39232452434612), initPoint(-34.30633568106076, -42.33320108068191)]),
        ([999999999999983.2, 999999999999978.0, 1000000000000017.5, 1000000000000009.5, 999999999999986.5, 999999999999999.0], [initPoint(999999999999995.8, 999999999999995.5), initPoint(1000000000000008.6, 999999999999984.9), initPoint(999999999999992.0, 999999999999994.4), initPoint(999999999999970.1, 1000000000000016.9), initPoint(1000000000000008.4, 1000000000000025.0), initPoint(999999999999973.2, 999999999999983.2), initPoint(1000000000000060.6, 999999999999936.6)]),
        ([-999999999992.5, -999999999995.5, -1000000000005.0, -1000000000003.5, -1000000000021.25, -1000000000009.5], [initPoint(-1000000000006.25, -1000000000002.8334), initPoint(-1000000000038.8363, -999999999936.8651), initPoint(-1000000000005.384, -1000000000002.7278), initPoint(-999999999941.0773, -1000000000134.7699), initPoint(-1000000000020.5171, -1000000000011.217), initPoint(-1000000000137.7266, -999999999736.6211), initPoint(-999999999991.7178, -999999999996.8944)]),
        ([-3.0, 0.25, 21.5, 5.0, -3.5, 8.0], [initPoint(5.0, 4.416666666666667), initPoint(8.80835500650195, 4.902958387516255), initPoint(0.07057832178895045, 4.227426413580362), initPoint(-2.6167100130039014, 3.4440832249674904), initPoint(20.570517780015695, 30.781707768125024), initPoint(-7.7852362515417655, 3.9442085586936493), initPoint(22.37756017574492, -19.341509190334015)]),
        ([1000000000000011.8, 999999999999986.0, 999999999999998.0, 999999999999980.5, 1000000000000010.0, 1000000000000011.8], [initPoint(1000000000000006.6, 999999999999992.8), initPoint(999999999999999.0, 999999999999998.1), initPoint(1000000000000006.6, 999999999999989.2), initPoint(1000000000000021.9, 999999999999982.1), initPoint(999999999999958.5, 1000000000000019.5), initPoint(1000000000000026.4, 1000000000000009.2), initPoint(1000000000000004.4, 999999999999974.2)]),
        ([-20.0, -2.25, -14.25, 5.5, 2.25, -14.0], [initPoint(-10.666666666666666, -3.5833333333333335), initPoint(-7.498046875, -5.517578125), initPoint(-14.045403238031051, -0.8977560290841704), initPoint(-17.00390625, 0.28515625), initPoint(18.77813554937563, 6.556221830991122), initPoint(-13.019099671165907, -32.99034522450156), initPoint(-21.70582014017867, 5.26156692259461)]),
        ([1000000000000007.5, 1000000000000016.2, 1000000000000024.5, 1000000000000013.8, 999999999999995.0, 999999999999997.2], [initPoint(1000000000000009.0, 1000000000000009.1), initPoint(1000000000000013.6, 999999999999998.6), initPoint(1000000000000009.9, 1000000000000011.0), initPoint(999999999999999.9, 1000000000000030.0), initPoint(1000000000000035.5, 999999999999953.6), initPoint(999999999999986.2, 1000000000000006.8), initPoint(1000000000000022.8, 1000000000000023.1)]),
        ([-1000000000009.0, -999999999980.75, -999999999986.5, -1000000000003.5, -1000000000004.25, -999999999989.5], [initPoint(-999999999999.9166, -999999999991.25), initPoint(-999999999971.2617, -999999999965.9277), initPoint(-1000000000003.1759, -999999999988.5951), initPoint(-1000000000057.2266, -1000000000041.8944), initPoint(-999999999989.5651, -1000000000006.9292), initPoint(-1000000000010.6133, -999999999981.9476), initPoint(-999999999881.6926, -999999999886.2393)]),
        ([-999999999979.25, -999999999998.25, -999999999975.25, -999999999980.5, -1000000000009.0, -999999999991.5], [initPoint(-999999999987.8334, -999999999990.0834), initPoint(-999999999992.117, -999999999986.0247), initPoint(-999999999984.2296, -999999999990.3604), initPoint(-999999999979.2661, -999999999998.2006), initPoint(-1000000000011.0043, -999999999947.9391), initPoint(-1000000000007.8586, -1000000000016.3066), initPoint(-999999999965.3752, -999999999989.4928)]),
        ([1000000000000004.2, 1000000000000007.2, 1000000000000009.8, 999999999999997.2, 999999999999983.0, 999999999999998.8], [initPoint(999999999999999.0, 1000000000000001.1), initPoint(999999999999996.2, 999999999999996.4), initPoint(1000000000000002.4, 1000000000000001.9), initPoint(1000000000000004.4, 1000000000000010.5), initPoint(999999999999988.8, 999999999999963.9), initPoint(999999999999980.2, 1000000000000015.9), initPoint(1000000000000013.9, 1000000000000003.8)]),
        ([15.0, 16.5, 20.5, 22.25, 22.75, 3.25], [initPoint(19.416666666666668, 14.0), initPoint(24.340007982969663, 13.071514103246408), initPoint(18.442327498471972, 16.095517034477908), initPoint(9.56998403406067, 15.856971793507185), initPoint(49.99838363212075, 12.387593494144912), initPoint(13.061316644067382, 0.0009540677620892072), initPoint(15.858004157218554, 23.80199181660072)]),
        ([1000000000000008.5, 999999999999984.2, 999999999999994.8, 1000000000000006.0, 999999999999991.8, 1000000000000023.0], [initPoint(999999999999998.4, 1000000000000004.4), initPoint(1000000000000047.4, 1000000000000024.0), initPoint(999999999999996.6, 1000000000000006.8), initPoint(999999999999900.2, 999999999999965.1), initPoint(999999999999988.5, 1000000000000022.0), initPoint(1000000000000200.2, 1000000000000085.5), initPoint(1000000000000004.1, 999999999999981.9)])
    ]
    for item in oracleCases:
        let a = initPoint(item[0][0],item[0][1])
        let b = initPoint(item[0][2],item[0][3])
        let c = initPoint(item[0][4],item[0][5])
        let ex = excenters(a,b,c,0.0).get
        let actual = [centroid(a,b,c),circumcenter(a,b,c,0.0).get,incenter(a,b,c,0.0).get,orthocenter(a,b,c,0.0).get,ex[0],ex[1],ex[2]]
        for i in 0..6:
            let expected = item[1][i]
            var magnitude = max(max(abs(expected.x),abs(expected.y)),1e-300)
            for coordinate in item[0]: magnitude = max(magnitude, abs(coordinate))
            doAssert abs(actual[i].x-expected.x) <= 2e-8*magnitude
            doAssert abs(actual[i].y-expected.y) <= 2e-8*magnitude

echo "Hello World"
