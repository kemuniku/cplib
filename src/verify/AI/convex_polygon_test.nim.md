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
    import cplib/math/fractions\nimport algorithm, options, random, sequtils\n\ntype\
    \ IP = Point[int]\nproc turn[T](a, b, c: Point[T]): T = cross(b-a, c-a)\nproc\
    \ equalSeq[T](a, b: seq[Point[T]]): bool =\n    if a.len != b.len: return false\n\
    \    for i in 0..<a.len:\n        if a[i].x != b[i].x or a[i].y != b[i].y: return\
    \ false\n    true\nproc less[T](a, b: Point[T]): bool = a.x < b.x or (a.x == b.x\
    \ and a.y < b.y)\nproc equal[T](a, b: Point[T]): bool = a.x == b.x and a.y ==\
    \ b.y\nproc hull[T](points: seq[Point[T]]): seq[Point[T]] =\n    var sorted =\
    \ points\n    sorted.sort(proc(a, b: Point[T]): int = (if less(a,b): -1 elif less(b,a):\
    \ 1 else: 0))\n    var unique: seq[Point[T]]\n    for p in sorted:\n        if\
    \ unique.len == 0 or not equal(unique[^1],p): unique.add(p)\n    if unique.len\
    \ < 2: return unique\n    let zero = unique[0].x - unique[0].x\n    var lower,\
    \ upper: seq[Point[T]]\n    for p in unique:\n        while lower.len >= 2 and\
    \ turn(lower[^2], lower[^1], p) <= zero: discard lower.pop()\n        lower.add(p)\n\
    \    for i in countdown(unique.high, 0):\n        let p = unique[i]\n        while\
    \ upper.len >= 2 and turn(upper[^2], upper[^1], p) <= zero: discard upper.pop()\n\
    \        upper.add(p)\n    lower.setLen(lower.len-1)\n    upper.setLen(upper.len-1)\n\
    \    lower & upper\nproc linear[T](vertices: seq[Point[T]], p: Point[T]): int\
    \ =\n    if vertices.len == 0: return -1\n    if vertices.len == 1: return (if\
    \ equal(vertices[0],p): 0 else: -1)\n    let zero = p.x - p.x\n    if vertices.len\
    \ == 2:\n        return (if turn(vertices[0],vertices[1],p) == zero and dot(p-vertices[0],p-vertices[1])\
    \ <= zero: 0 else: -1)\n    var boundary = false\n    for i in 0..<vertices.len:\n\
    \        let c = turn(vertices[i],vertices[(i+1) mod vertices.len],p)\n      \
    \  if c < zero: return -1\n        if c == zero: boundary = true\n    if boundary:\
    \ 0 else: 1\nproc check[T](vertices, queries: seq[Point[T]]) =\n    let before\
    \ = vertices\n    let cp = initConvexPolygon(initPolygon(vertices))\n    doAssert\
    \ equalSeq(vertices, before)\n    let normalized = cp.toSeq\n    doAssert equalSeq(normalized,\
    \ hull(vertices))\n    var copied = cp.toPolygon\n    if copied.len > 0: copied.v[0]\
    \ = initPoint(copied.v[0].x + copied.v[0].x, copied.v[0].y + copied.v[0].y)\n\
    \    doAssert equalSeq(cp.toSeq, normalized)\n    for p in queries:\n        let\
    \ loc = linear(normalized, p)\n        doAssert cp.contains(p) == (loc >= 0)\n\
    \        doAssert cp.contains(p, true) == (loc > 0)\n        doAssert cp.on_edge(p)\
    \ == (loc == 0)\n    let answer = cp.diameter\n    doAssert answer.isSome == (vertices.len\
    \ > 0)\n    doAssert initPolygon(vertices).diameter.isSome == answer.isSome\n\
    \    if answer.isSome:\n        let d = answer.get\n        var naive = norm(vertices[0]-vertices[0])\n\
    \        for a in vertices:\n            for b in vertices:\n                naive\
    \ = max(naive, norm(a-b))\n        doAssert d.distance_sq == naive\n        doAssert\
    \ norm(d.endpoints[0]-d.endpoints[1]) == naive\n        doAssert d.endpoints[0]\
    \ in vertices and d.endpoints[1] in vertices\nproc variants[T](vertices, queries:\
    \ seq[Point[T]]) =\n    if vertices.len == 0: check(vertices, queries)\n    for\
    \ reverse in [false, true]:\n        for offset in 0..<max(1,vertices.len):\n\
    \            var v = vertices\n            if reverse: v.reverse()\n         \
    \   if v.len > 0: v = v[offset..^1] & v[0..<offset]\n            check(v, queries)\n\
    \            var duplicates: seq[Point[T]]\n            for p in v: duplicates.add(p);\
    \ duplicates.add(p)\n            if v.len > 0: duplicates.add(v[0])\n        \
    \    check(duplicates, queries)\nproc rational(v: seq[IP]): seq[Point[Fraction[int]]]\
    \ =\n    for p in v: result.add(initPoint(initFraction(p.x),initFraction(p.y)))\n\
    proc floating(v: seq[IP]): seq[Point[float]] =\n    for p in v: result.add(initPoint(float(p.x),float(p.y)))\n\
    \nvar grid, queries: seq[IP]\nfor x in 0..2:\n    for y in 0..2: grid.add(initPoint(x*2,y*2))\n\
    for x in -1..5:\n    for y in -1..5: queries.add(initPoint(x,y))\nfor mask in\
    \ 0..<(1 shl grid.len):\n    var points: seq[IP]\n    for i in 0..<grid.len:\n\
    \        if (mask and (1 shl i)) != 0: points.add(grid[i])\n    let h = hull(points)\n\
    \    variants(h, queries)\n    check(floating(h),floating(queries))\n    check(rational(h),rational(queries))\n\
    \    var weak: seq[IP]\n    for i, p in h:\n        weak.add(p)\n        if h.len\
    \ >= 2:\n            let q = h[(i+1) mod h.len]\n            weak.add(initPoint((p.x+q.x)\
    \ div 2,(p.y+q.y) div 2))\n    if h.len >= 3: variants(weak,queries)\n\nvar rng\
    \ = initRand(903247)\nfor trial in 0..<300:\n    var points: seq[IP]\n    for\
    \ i in 0..<rng.rand(1..30): points.add(initPoint(rng.rand(-20..20),rng.rand(-20..20)))\n\
    \    let h = hull(points)\n    var q = h\n    for i in 0..<50: q.add(initPoint(rng.rand(-25..25),rng.rand(-25..25)))\n\
    \    check(h,q)\n    check(h.reversed,q)\n    check(floating(h),floating(q))\n\
    \    check(rational(h),rational(q))\n\nvariants(@[initPoint(3,0),initPoint(-1,0),initPoint(1,0),initPoint(3,0)],queries)\n\
    variants(@[initPoint(1,1),initPoint(1,1),initPoint(1,1)],queries)\nfor scale in\
    \ [1'i32, 2'i32]:\n    let f = initFraction(scale)\n    let z = initFraction(0'i32)\n\
    \    check(@[initPoint(z,z),initPoint(f,z),initPoint(z,f)],@[initPoint(z,z),initPoint(f,f)])\n\
    check(@[initPoint(0'f32,0'f32),initPoint(2'f32,0'f32),initPoint(0'f32,2'f32)],\n\
    \    @[initPoint(0'f32,0'f32),initPoint(0.5'f32,0.5'f32)])\ncheck(@[initPoint(0'i64,0'i64),initPoint(2'i64,0'i64),initPoint(0'i64,2'i64)],\n\
    \    @[initPoint(0'i64,0'i64),initPoint(1'i64,1'i64)])\ncheck(@[initPoint(initFraction(0'i64),initFraction(0'i64))],\n\
    \    @[initPoint(initFraction(0'i64),initFraction(1'i64))])\n\nblock:\n    var\
    \ v: seq[IP]\n    for i in 0..<20000: v.add(initPoint(i,0))\n    let cp = initConvexPolygon(v)\n\
    \    doAssert cp.len == 2\n    for i in 0..<20000: doAssert cp.contains(initPoint(i,0))\n\
    \    v[0] = initPoint(-100,-100)\n    doAssert cp.toSeq[0] == initPoint(0,0)\n\
    block:\n    var parabola: seq[IP]\n    for i in -400..400: parabola.add(initPoint(i,i*i))\n\
    \    let cp = initConvexPolygon(parabola)\n    doAssert cp.len == parabola.len\n\
    \    for i in -400..400:\n        doAssert cp.on_edge(initPoint(i,i*i))\n    \
    \    doAssert not cp.contains(initPoint(i,i*i),true)\n    for i in 0..<10000:\
    \ doAssert cp.contains(initPoint(0,100))\n\nblock:\n    let z = initFraction(0)\n\
    \    let one = initFraction(1)\n    let third = initFraction(1,3)\n    let half\
    \ = initFraction(1,2)\n    variants(@[initPoint(z,z),initPoint(one,z),initPoint(one,one),initPoint(z,one)],\n\
    \        @[initPoint(third,third),initPoint(half,z),initPoint(one,third),initPoint(one+third,half)])\n\
    block:\n    let cp = initConvexPolygon(@[initPoint(0.0,0.0),initPoint(1.0,0.0),initPoint(1.0,1.0),initPoint(0.0,1.0)])\n\
    \    let near = initPoint(0.5,-GEOMETRY_EPS/4.0)\n    doAssert cp.on_edge(near)\n\
    \    doAssert cp.contains(near)\n    doAssert not cp.contains(near,true)\n   \
    \ doAssert not cp.contains(initPoint(0.5,-GEOMETRY_EPS*4.0))\n\nproc checkFloatingDiameter[T:\
    \ SomeFloat](vertices: seq[Point[T]], expected: T) =\n    let tolerance = (when\
    \ T is float32: T(1e-5) else: T(1e-12))\n    for reversed in [false, true]:\n\
    \        for offset in [0, 1, vertices.len div 3, vertices.high]:\n          \
    \  var v = vertices[offset..^1] & vertices[0..<offset]\n            if reversed:\
    \ v.reverse()\n            v.add(v[0])\n            let cp = initConvexPolygon(v)\n\
    \            let d = cp.diameter.get\n            doAssert abs(d.distance_sq -\
    \ expected) <= tolerance * expected\n            doAssert norm(d.endpoints[0]\
    \ - d.endpoints[1]) == d.distance_sq\n            let normalized = cp.toSeq\n\
    \            for i in 0..<normalized.len:\n                doAssert turn(normalized[i],\
    \ normalized[(i+1) mod normalized.len],\n                    normalized[(i+2)\
    \ mod normalized.len]) > T(0)\n\nproc checkSubdividedPolygon[T: SomeFloat](corners:\
    \ seq[Point[T]], divisions: int) =\n    var vertices: seq[Point[T]]\n    for i,\
    \ a in corners:\n        let b = corners[(i+1) mod corners.len]\n        for j\
    \ in 0..<divisions:\n            vertices.add(a + (b-a) * (T(j) / T(divisions)))\n\
    \    var expected = T(0)\n    for a in corners:\n        for b in corners: expected\
    \ = max(expected, norm(a-b))\n    checkFloatingDiameter(vertices, expected)\n\n\
    for divisions in [7, 30, 200, 1000]:\n    let diamond = @[initPoint(0.0,-10.0),\
    \ initPoint(10.0,0.0),\n        initPoint(0.0,10.0), initPoint(-10.0,0.0)]\n \
    \   checkSubdividedPolygon(diamond, divisions)\n    checkSubdividedPolygon(diamond.mapIt(initPoint(it.x\
    \ * 1e-12, it.y * 1e-12)), divisions)\n    checkSubdividedPolygon(diamond.mapIt(initPoint(float32(it.x),\
    \ float32(it.y))), divisions)\n    checkSubdividedPolygon(@[initPoint(0.0,0.0),\
    \ initPoint(40.0,10.0),\n        initPoint(40.0,40.0), initPoint(0.0,30.0)], divisions)\n\
    \nstatic:\n    doAssert not compiles(convex_cut(initPolygon(@[initPoint(0,0)]),initLine(initPoint(0,0),initPoint(1,0))))\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/geometry/ccw.nim
  - cplib/geometry/convex_polygon.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/convex_polygon.nim
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  isVerificationFile: true
  path: verify/AI/convex_polygon_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:50:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/convex_polygon_test.nim
layout: document
redirect_from:
- /verify/verify/AI/convex_polygon_test.nim
- /verify/verify/AI/convex_polygon_test.nim.html
title: verify/AI/convex_polygon_test.nim
---
