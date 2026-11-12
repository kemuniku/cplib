---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/convex_polygon.nim
    title: cplib/geometry/convex_polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/convex_polygon.nim
    title: cplib/geometry/convex_polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import cplib/geometry/base\nimport cplib/geometry/polygon\nimport cplib/geometry/convex_polygon\n\
    import cplib/math/fractions\nimport algorithm, random, sequtils\n\ntype F = Fraction[int]\n\
    type FP = Point[F]\nproc point(x,y: int): FP = initPoint(initFraction(x),initFraction(y))\n\
    proc turn(a,b,c: FP): F = cross(b-a,c-a)\nproc eq(a,b: FP): bool = a.x == b.x\
    \ and a.y == b.y\nproc equalSeq(a,b: seq[FP]): bool =\n    if a.len != b.len:\
    \ return false\n    for i in 0..<a.len:\n        if not eq(a[i],b[i]): return\
    \ false\n    true\nproc hull(points: seq[FP]): seq[FP] =\n    var points = points\n\
    \    points.sort(proc(a,b: FP): int =\n        if a.x < b.x or (a.x == b.x and\
    \ a.y < b.y): -1\n        elif eq(a,b): 0\n        else: 1)\n    var unique: seq[FP]\n\
    \    for p in points:\n        if unique.len == 0 or not eq(unique[^1],p): unique.add(p)\n\
    \    if unique.len < 2: return unique\n    var lower,upper: seq[FP]\n    for p\
    \ in unique:\n        while lower.len >= 2 and turn(lower[^2],lower[^1],p) <=\
    \ 0: discard lower.pop()\n        lower.add(p)\n    for i in countdown(unique.high,0):\n\
    \        let p = unique[i]\n        while upper.len >= 2 and turn(upper[^2],upper[^1],p)\
    \ <= 0: discard upper.pop()\n        upper.add(p)\n    lower.setLen(lower.len-1)\n\
    \    upper.setLen(upper.len-1)\n    lower & upper\nproc areaTwice(v: seq[FP]):\
    \ F =\n    result = initFraction(0)\n    for i in 0..<v.len:\n        result +=\
    \ cross(v[i],v[(i+1) mod v.len])\n        result.reduce()\nproc oracle(v: seq[FP],\
    \ line: Line[F]): seq[FP] =\n    var candidates: seq[FP]\n    let a = line.t.y-line.s.y\n\
    \    let b = line.s.x-line.t.x\n    let c = a*line.s.x+b*line.s.y\n    for i,p\
    \ in v:\n        let q = v[(i+1) mod v.len]\n        let sp = turn(line.s,line.t,p)\n\
    \        let sq = turn(line.s,line.t,q)\n        if sp >= 0: candidates.add(p)\n\
    \        if (sp < 0 and sq > 0) or (sp > 0 and sq < 0):\n            let d = q.y-p.y\n\
    \            let e = p.x-q.x\n            let f = d*p.x+e*p.y\n            let\
    \ determinant = a*e-b*d\n            var x = (c*e-b*f)/determinant\n         \
    \   var y = (a*f-c*d)/determinant\n            x.reduce(); y.reduce()\n      \
    \      candidates.add(initPoint(x,y))\n    hull(candidates)\nproc floating(v:\
    \ seq[FP]): seq[Point[float]] =\n    for p in v: result.add(initPoint(p.x.toFloat,p.y.toFloat))\n\
    proc floatInside(v: seq[Point[float]], p: Point[float]): bool =\n    if v.len\
    \ == 0: return false\n    if v.len == 1: return norm(v[0]-p) < 1e-16\n    if v.len\
    \ == 2:\n        return abs(cross(v[1]-v[0],p-v[0])) < 1e-8 and dot(p-v[0],p-v[1])\
    \ <= 1e-8\n    for i in 0..<v.len:\n        if cross(v[(i+1) mod v.len]-v[i],p-v[i])\
    \ < -1e-8: return false\n    true\nproc check(v: seq[FP], line: Line[F]) =\n \
    \   let before = v\n    let clipped = convex_cut(initPolygon(v),line)\n    doAssert\
    \ equalSeq(v,before)\n    let expected = oracle(v,line)\n    doAssert equalSeq(hull(clipped.v),expected)\n\
    \    for p in clipped:\n        doAssert turn(line.s,line.t,p) >= 0\n        doAssert\
    \ initConvexPolygon(v).contains(p)\n    doAssert abs(areaTwice(clipped.v)) ==\
    \ abs(areaTwice(expected))\n    let complement = convex_cut(initPolygon(v),initLine(line.t,line.s))\n\
    \    doAssert abs(areaTwice(clipped.v))+abs(areaTwice(complement.v)) == abs(areaTwice(v))\n\
    \    if v.len >= 3 and areaTwice(v) != 0 and areaTwice(clipped.v) != 0:\n    \
    \    doAssert (areaTwice(v) > 0) == (areaTwice(clipped.v) > 0)\n    doAssert equalSeq(hull(convex_cut(clipped,line).v),expected)\n\
    \    doAssert equalSeq(hull(convex_cut(initConvexPolygon(v),line).v),expected)\n\
    \    let fv = floating(v)\n    let fl = initLine(initPoint(line.s.x.toFloat,line.s.y.toFloat),initPoint(line.t.x.toFloat,line.t.y.toFloat))\n\
    \    let actual = convex_cut(initPolygon(fv),fl)\n    let fnormal = initConvexPolygon(actual).toSeq\n\
    \    let enormal = floating(expected)\n    for p in fnormal:\n        doAssert\
    \ floatInside(enormal,p)\n        doAssert cross(fl.vector,p-fl.s) >= -1e-8\n\
    \    for p in enormal: doAssert floatInside(fnormal,p)\n    doAssert abs(abs(actual.area)*2.0-abs(areaTwice(expected)).toFloat)\
    \ < 1e-8\n\nvar grid: seq[FP]\nfor x in 0..2:\n    for y in 0..2: grid.add(point(x,y))\n\
    var lines: seq[Line[F]]\nfor x in -1..3:\n    lines.add(initLine(point(x,-2),point(x,4)))\n\
    \    lines.add(initLine(point(-2,x),point(4,x)))\nfor i in -2..4: lines.add(initLine(point(-2,-2+i),point(4,4+i)))\n\
    lines.add(initLine(point(-2,4),point(4,-2)))\nfor mask in 0..<(1 shl grid.len):\n\
    \    var points: seq[FP]\n    for i in 0..<grid.len:\n        if (mask and (1\
    \ shl i)) != 0: points.add(grid[i])\n    let v = hull(points)\n    for line in\
    \ lines:\n        check(v,line)\n        check(v.reversed,line)\n        check(v,initLine(line.t,line.s))\n\
    \nvar rng = initRand(573291)\nfor trial in 0..<200:\n    var points: seq[FP]\n\
    \    for i in 0..<rng.rand(1..12): points.add(point(rng.rand(-3..3),rng.rand(-3..3)))\n\
    \    let v = hull(points)\n    var a = point(rng.rand(-4..4),rng.rand(-4..4))\n\
    \    var b = point(rng.rand(-4..4),rng.rand(-4..4))\n    if eq(a,b): b = point(5,5)\n\
    \    check(v,initLine(a,b))\n    if v.len > 0: check(v[1..^1] & @[v[0]],initLine(a,b))\n\
    \nlet square = @[point(0,0),point(1,0),point(2,0),point(2,2),point(0,2),point(0,0)]\n\
    for line in lines: check(square,line)\nfor v in [@[point(1,1),point(1,1),point(1,1)],@[point(2,0),point(0,0),point(1,0),point(2,0)]]:\n\
    \    for line in lines: check(v,line)\nblock:\n    let triangle = @[point(0,0),point(3,0),point(0,3)]\n\
    \    let line = initLine(point(0,1),point(2,0))\n    let expected = @[point(0,1),point(2,0),point(3,0),point(0,3)]\n\
    \    doAssert equalSeq(hull(convex_cut(initPolygon(triangle),line).v),hull(expected))\n\
    block:\n    let z = initFraction(0'i32)\n    let one = initFraction(1'i32)\n \
    \   let two = initFraction(2'i32)\n    let poly = initPolygon(@[initPoint(z,z),initPoint(two,z),initPoint(z,two)])\n\
    \    let clipped = convex_cut(poly,initLine(initPoint(one,z),initPoint(one,two)))\n\
    \    doAssert clipped.len == 4\n    for p in clipped: doAssert p.x <= one\nblock:\n\
    \    let poly = initPolygon(@[initPoint(0'f32,0'f32),initPoint(2'f32,0'f32),initPoint(0'f32,2'f32)])\n\
    \    doAssert convex_cut(poly,initLine(initPoint(1'f32,0'f32),initPoint(1'f32,2'f32))).len\
    \ == 4\nblock:\n    let z = initFraction(0'i64)\n    let one = initFraction(1'i64)\n\
    \    let poly = initPolygon(@[initPoint(z,z),initPoint(one,z)])\n    doAssert\
    \ convex_cut(poly,initLine(initPoint(z,z),initPoint(z,one))).len == 1\n\necho\
    \ \"Hello World\"\n"
  dependsOn:
  - cplib/geometry/convex_polygon.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/convex_polygon.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/polygon.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/AI/convex_cut_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:50:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/convex_cut_test.nim
layout: document
redirect_from:
- /verify/verify/AI/convex_cut_test.nim
- /verify/verify/AI/convex_cut_test.nim.html
title: verify/AI/convex_cut_test.nim
---
