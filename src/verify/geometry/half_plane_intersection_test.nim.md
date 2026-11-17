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
    path: cplib/geometry/half_plane_intersection.nim
    title: cplib/geometry/half_plane_intersection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/half_plane_intersection.nim
    title: cplib/geometry/half_plane_intersection.nim
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
    import cplib/geometry/base\nimport cplib/geometry/half_plane_intersection\nimport\
    \ cplib/math/fractions\nimport algorithm, random, math\n\ntype\n    IPoint = tuple[x,\
    \ y: int64]\n    ILine = tuple[s, t: IPoint]\n    Rational = Fraction[int64]\n\
    \    RPoint = tuple[x, y: Rational]\n\nproc toLine(l: ILine): Line[float] =\n\
    \    Line[float](s: Point[float](x: float(l.s.x), y: float(l.s.y)),\n        t:\
    \ Point[float](x: float(l.t.x), y: float(l.t.y)))\n\nproc cross(a, b: IPoint):\
    \ int64 = a.x*b.y - a.y*b.x\nproc direction(l: ILine): IPoint = (l.t.x-l.s.x,\
    \ l.t.y-l.s.y)\nproc feasible(lines: seq[ILine], p: RPoint): bool =\n    for l\
    \ in lines:\n        let d = direction(l)\n        if d.x*(p.y-l.s.y) - d.y*(p.x-l.s.x)\
    \ < 0: return false\n    true\nproc same(a, b: RPoint): bool = a.x == b.x and\
    \ a.y == b.y\nproc oracle(lines: seq[ILine]): tuple[kind: HalfPlaneIntersectionKind,\
    \ dimension: int, vertices: seq[RPoint]] =\n    var candidates: seq[RPoint] =\
    \ @[(initFraction(0'i64), initFraction(0'i64))]\n    var rays: seq[IPoint]\n \
    \   var directions: seq[IPoint] = @[(1'i64,0'i64),(-1'i64,0'i64),(0'i64,1'i64),(0'i64,-1'i64)]\n\
    \    for i, l in lines:\n        let d = direction(l)\n        directions.add(d)\n\
    \        directions.add((-d.x,-d.y))\n        let c = cross(d, l.s)\n        let\
    \ norm = d.x*d.x+d.y*d.y\n        candidates.add((initFraction(-d.y*c, norm),\
    \ initFraction(d.x*c, norm)))\n        for j in 0..<i:\n            let e = direction(lines[j])\n\
    \            let determinant = cross(d,e)\n            if determinant == 0: continue\n\
    \            let f = cross(e, lines[j].s)\n            let p: RPoint = (initFraction(c*e.x-d.x*f,\
    \ determinant),\n                initFraction(e.y*c-d.y*f, determinant))\n   \
    \         candidates.add(p)\n            if feasible(lines, p):\n            \
    \    var duplicate = false\n                for q in result.vertices:\n      \
    \              if same(p,q): duplicate = true\n                if not duplicate:\
    \ result.vertices.add(p)\n    var points: seq[RPoint]\n    for p in candidates:\n\
    \        if feasible(lines,p): points.add(p)\n    if points.len == 0:\n      \
    \  result.kind = hpiEmpty\n        result.dimension = -1\n        return\n   \
    \ for d in directions:\n        var valid = true\n        for l in lines:\n  \
    \          if cross(direction(l),d) < 0: valid = false\n        if valid: rays.add(d)\n\
    \    result.kind = if rays.len == 0: hpiBounded else: hpiUnbounded\n    var spans:\
    \ seq[RPoint]\n    for p in points: spans.add((p.x-points[0].x, p.y-points[0].y))\n\
    \    for d in rays: spans.add((initFraction(d.x), initFraction(d.y)))\n    for\
    \ a in spans:\n        if a.x == 0 and a.y == 0: continue\n        result.dimension\
    \ = max(result.dimension, 1)\n        for b in spans:\n            if a.x*b.y-a.y*b.x\
    \ != 0: result.dimension = 2\n\nproc asFloat(a: Rational): float = float(a.num)\
    \ / float(a.den)\nproc near(a, b: float): bool = abs(a-b) <= 1e-8 * max(1.0, max(abs(a),abs(b)))\n\
    proc check(lines: seq[ILine], checkFloat = true) =\n    var input: seq[Line[float]]\n\
    \    for l in lines: input.add(toLine(l))\n    let expected = oracle(lines)\n\
    \    var rationalInput: seq[Line[Rational]]\n    for l in lines:\n        rationalInput.add(Line[Rational](s:\
    \ Point[Rational](x: initFraction(l.s.x), y: initFraction(l.s.y)),\n         \
    \   t: Point[Rational](x: initFraction(l.t.x), y: initFraction(l.t.y))))\n   \
    \ let exact = half_plane_intersection(rationalInput)\n    doAssert exact.kind\
    \ == expected.kind, $lines\n    doAssert exact.dimension == expected.dimension,\
    \ $lines\n    doAssert exact.vertices.len == expected.vertices.len, $lines\n \
    \   for p in exact.vertices:\n        var found = false\n        for q in expected.vertices:\n\
    \            if p.x == q.x and p.y == q.y: found = true\n        doAssert found,\
    \ $lines\n        doAssert exact.contains(p)\n    for x in -3..3:\n        for\
    \ y in -3..3:\n            doAssert exact.contains(Point[Rational](x: initFraction(int64(x)),\
    \ y: initFraction(int64(y)))) ==\n                feasible(lines,(initFraction(int64(x)),initFraction(int64(y))))\n\
    \    var exactReversed = rationalInput\n    exactReversed.reverse()\n    let exactOther\
    \ = half_plane_intersection(exactReversed)\n    doAssert exact.kind == exactOther.kind\
    \ and exact.dimension == exactOther.dimension\n    doAssert exact.vertices.len\
    \ == exactOther.vertices.len\n    for i in 0..<exact.vertices.len:\n        doAssert\
    \ exact.vertices[i].x == exactOther.vertices[i].x\n        doAssert exact.vertices[i].y\
    \ == exactOther.vertices[i].y\n    let duplicated = half_plane_intersection(rationalInput\
    \ & rationalInput)\n    doAssert exact.kind == duplicated.kind and exact.dimension\
    \ == duplicated.dimension\n    doAssert exact.vertices.len == duplicated.vertices.len\n\
    \    for i in 0..<exact.vertices.len:\n        doAssert exact.vertices[i].x ==\
    \ duplicated.vertices[i].x\n        doAssert exact.vertices[i].y == duplicated.vertices[i].y\n\
    \    if not checkFloat: return\n    let actual = half_plane_intersection(input)\n\
    \    doAssert actual.kind == expected.kind, $lines & \" kind \" & $actual.kind\
    \ & \" != \" & $expected.kind\n    doAssert actual.dimension == expected.dimension,\
    \ $lines & \" dimension \" & $actual.dimension & \" != \" & $expected.dimension\n\
    \    doAssert actual.constraints.len == input.len\n    doAssert actual.vertices.len\
    \ == expected.vertices.len, $lines & \" vertices \" & $actual.vertices & \" expected\
    \ \" & $expected.vertices\n    for p in expected.vertices:\n        var found\
    \ = false\n        for q in actual.vertices:\n            if near(asFloat(p.x),q.x)\
    \ and near(asFloat(p.y),q.y): found = true\n        doAssert found, $lines & \"\
    \ vertex \" & $p\n    if actual.kind == hpiBounded and actual.dimension == 2:\n\
    \        var area = 0.0\n        for i in 0..<actual.vertices.len:\n         \
    \   let a = actual.vertices[i]\n            let b = actual.vertices[(i+1) mod\
    \ actual.vertices.len]\n            area += a.x*b.y-a.y*b.x\n        doAssert\
    \ area > 0\n    var reversed = input\n    reversed.reverse()\n    let other =\
    \ half_plane_intersection(reversed)\n    doAssert actual.kind == other.kind and\
    \ actual.dimension == other.dimension\n    doAssert actual.vertices.len == other.vertices.len\n\
    \    for i in 0..<actual.vertices.len:\n        doAssert actual.vertices[i].x\
    \ == other.vertices[i].x\n        doAssert actual.vertices[i].y == other.vertices[i].y\n\
    \    for x in -3..3:\n        for y in -3..3:\n            doAssert actual.contains(Point[float](x:\
    \ float(x), y: float(y))) ==\n                feasible(lines,(initFraction(int64(x)),initFraction(int64(y))))\n\
    \nproc constraint(a,b,c: int64): ILine =\n    # a*x+b*y >= c\u3002\u30C6\u30B9\
    \u30C8\u306E\u4FC2\u6570\u306F\u8EF8\u307E\u305F\u306F b=+-1\u3002\n    if b ==\
    \ 0:\n        let x = c div a\n        if a > 0: ((x,1'i64),(x,0'i64))\n     \
    \   else: ((x,0'i64),(x,1'i64))\n    else:\n        let y = c div b\n        let\
    \ dy = -a div b\n        if b > 0: ((0'i64,y),(1'i64,y+dy))\n        else: ((1'i64,y+dy),(0'i64,y))\n\
    \ncheck(@[])\ncheck(@[constraint(0,1,0)])\ncheck(@[constraint(0,1,0),constraint(0,-1,-1)])\n\
    check(@[constraint(0,1,0),constraint(0,-1,0)])\ncheck(@[constraint(0,1,1),constraint(0,-1,0)])\n\
    check(@[constraint(1,0,0),constraint(-1,0,0)])\ncheck(@[constraint(1,0,0),constraint(-1,0,0),constraint(0,1,0)])\n\
    check(@[constraint(1,0,0),constraint(-1,0,0),constraint(0,1,0),constraint(0,-1,-2)])\n\
    check(@[constraint(1,0,0),constraint(-1,0,0),constraint(0,1,0),constraint(0,-1,0)])\n\
    check(@[constraint(0,1,0),constraint(0,-1,0),constraint(1,0,0)])\ncheck(@[constraint(0,1,0),constraint(0,-1,0),constraint(1,0,0),constraint(-1,0,-2)])\n\
    check(@[constraint(-1,1,0),constraint(1,-1,0),constraint(1,0,-2),constraint(-1,0,-3)])\n\
    check(@[constraint(1,1,0),constraint(-1,1,0),constraint(0,-1,0)])\ncheck(@[constraint(1,1,1),constraint(-1,1,1),constraint(0,-1,0)])\n\
    check(@[constraint(1,0,0),constraint(-1,0,-3),constraint(0,1,0),constraint(0,-1,-2)])\n\
    check(@[constraint(0,1,0),constraint(0,1,0),constraint(0,1,1),constraint(0,1,-1)])\n\
    \nvar rng = initRand(20261002)\nfor iteration in 0..<2000:\n    var lines: seq[ILine]\n\
    \    for i in 0..<rng.rand(0..10):\n        let a = int64(rng.rand(-3..3))\n \
    \       let b = int64(rng.rand(-1..1))\n        if a == 0 and b == 0: continue\n\
    \        let c = int64(rng.rand(-4..4)) * (if b == 0: abs(a) else: 1'i64)\n  \
    \      lines.add(constraint(a,b,c))\n        if rng.rand(0..4) == 0: lines.add(lines[^1])\n\
    \    check(lines)\n\nfor iteration in 0..<2000:\n    var lines: seq[ILine]\n \
    \   for i in 0..<rng.rand(0..10):\n        let s: IPoint = (int64(rng.rand(-3..3)),int64(rng.rand(-3..3)))\n\
    \        let t: IPoint = (int64(rng.rand(-3..3)),int64(rng.rand(-3..3)))\n   \
    \     if s != t: lines.add((s,t))\n    check(lines, false)\n\nproc clip(poly:\
    \ seq[RPoint], line: ILine): seq[RPoint] =\n    let d = direction(line)\n    proc\
    \ side(p: RPoint): Rational = d.x*(p.y-line.s.y)-d.y*(p.x-line.s.x)\n    for i\
    \ in 0..<poly.len:\n        let p = poly[i]\n        let q = poly[(i+1) mod poly.len]\n\
    \        let a = side(p)\n        let b = side(q)\n        if a >= 0: result.add(p)\n\
    \        if (a < 0 and b > 0) or (a > 0 and b < 0):\n            let t = a/(a-b)\n\
    \            result.add((p.x+(q.x-p.x)*t,p.y+(q.y-p.y)*t))\n    var unique: seq[RPoint]\n\
    \    for p in result:\n        if unique.len == 0 or not same(unique[^1],p): unique.add(p)\n\
    \    if unique.len > 1 and same(unique[0],unique[^1]): discard unique.pop()\n\
    \    result = unique\n\nfor iteration in 0..<400:\n    var lines = @[constraint(1,0,-8),constraint(-1,0,-8),\n\
    \        constraint(0,1,-8),constraint(0,-1,-8)]\n    var poly: seq[RPoint] =\
    \ @[\n        (initFraction(-8'i64),initFraction(-8'i64)),\n        (initFraction(8'i64),initFraction(-8'i64)),\n\
    \        (initFraction(8'i64),initFraction(8'i64)),\n        (initFraction(-8'i64),initFraction(8'i64))]\n\
    \    for i in 0..<rng.rand(0..8):\n        let a = int64(rng.rand(-3..3))\n  \
    \      let b = int64(rng.rand(-1..1))\n        if a == 0 and b == 0: continue\n\
    \        let c = int64(rng.rand(-4..4)) * (if b == 0: abs(a) else: 1'i64)\n  \
    \      let l = constraint(a,b,c)\n        lines.add(l)\n        poly = clip(poly,l)\n\
    \    let expected = oracle(lines)\n    doAssert (poly.len == 0) == (expected.kind\
    \ == hpiEmpty)\n    for p in expected.vertices:\n        var found = false\n \
    \       for q in poly:\n            if same(p,q): found = true\n        doAssert\
    \ found\n    for p in poly: doAssert feasible(lines,p)\n    check(lines)\n\n#\
    \ \u975E\u4E8C\u9032\u5206\u6570\u306E\u5883\u754C\u3067\u3067\u304D\u308B\u4E00\
    \u70B9\u306F Fraction API \u3067\u53B3\u5BC6\u306B\u5206\u985E\u3059\u308B\u3002\
    \ncheck(@[\n    ((0'i64,0'i64),(-1'i64,2'i64)),\n    ((-2'i64,-3'i64),(0'i64,2'i64)),\n\
    \    ((-1'i64,-2'i64),(-3'i64,3'i64)),\n    ((-3'i64,1'i64),(2'i64,1'i64)),\n\
    \    ((-2'i64,-2'i64),(2'i64,-3'i64)),\n    ((2'i64,0'i64),(-3'i64,3'i64)),\n\
    \    ((2'i64,-2'i64),(3'i64,-3'i64)),\n    ((-2'i64,0'i64),(-2'i64,3'i64))], false)\n\
    \nlet square32 = half_plane_intersection(@[\n    Line[float32](s: Point[float32](x:\
    \ 0,y: 0),t: Point[float32](x: 1,y: 0)),\n    Line[float32](s: Point[float32](x:\
    \ 1,y: 0),t: Point[float32](x: 1,y: 1)),\n    Line[float32](s: Point[float32](x:\
    \ 1,y: 1),t: Point[float32](x: 0,y: 1)),\n    Line[float32](s: Point[float32](x:\
    \ 0,y: 1),t: Point[float32](x: 0,y: 0))])\ndoAssert square32.kind == hpiBounded\
    \ and square32.dimension == 2\ndoAssert square32.vertices.len == 4\n\nlet oneThird\
    \ = initFraction(1'i64,3'i64)\nlet twoThirds = initFraction(2'i64,3'i64)\nlet\
    \ fractionalSquare = @[\n    Point[Rational](x: oneThird,y: oneThird),\n    Point[Rational](x:\
    \ twoThirds,y: oneThird),\n    Point[Rational](x: twoThirds,y: twoThirds),\n \
    \   Point[Rational](x: oneThird,y: twoThirds)]\nvar fractionalLines: seq[Line[Rational]]\n\
    for i in 0..<4:\n    fractionalLines.add(Line[Rational](s: fractionalSquare[i],t:\
    \ fractionalSquare[(i+1) mod 4]))\nlet fractionalResult = half_plane_intersection(fractionalLines)\n\
    doAssert fractionalResult.kind == hpiBounded and fractionalResult.dimension ==\
    \ 2\ndoAssert fractionalResult.vertices.len == 4\nfor p in fractionalResult.vertices:\n\
    \    doAssert (p.x == oneThird or p.x == twoThirds) and (p.y == oneThird or p.y\
    \ == twoThirds)\n    doAssert fractionalResult.contains(p)\nfor badFraction in\
    \ [Fraction[int64](num: 1,den: 0),Fraction[int64](num: 1,den: -1)]:\n    var raised\
    \ = false\n    try:\n        discard half_plane_intersection(@[Line[Rational](\n\
    \            s: Point[Rational](x: badFraction,y: oneThird),t: fractionalSquare[1])])\n\
    \    except ValueError: raised = true\n    doAssert raised\n\nlet tiny = 1e-12\n\
    let narrow = half_plane_intersection(@[\n    Line[float](s: Point[float](x: 0,\
    \ y: 0), t: Point[float](x: 1, y: 0)),\n    Line[float](s: Point[float](x: 1,\
    \ y: tiny), t: Point[float](x: 0, y: tiny))])\ndoAssert narrow.kind == hpiUnbounded\
    \ and narrow.dimension == 2\nlet nearParallel = half_plane_intersection(@[\n \
    \   Line[float](s: Point[float](x: 0, y: 0), t: Point[float](x: 1, y: 0)),\n \
    \   Line[float](s: Point[float](x: 1, y: 1-tiny), t: Point[float](x: 0, y: 1))])\n\
    doAssert nearParallel.kind == hpiUnbounded and nearParallel.dimension == 2\ndoAssert\
    \ nearParallel.vertices.len == 1 and nearParallel.vertices[0].x > 1e11\n\nfor\
    \ bad in @[\n    Line[float](s: Point[float](x: 0,y: 0), t: Point[float](x: 0,y:\
    \ 0)),\n    Line[float](s: Point[float](x: NaN,y: 0), t: Point[float](x: 1,y:\
    \ 1)),\n    Line[float](s: Point[float](x: 0,y: 0), t: Point[float](x: system.Inf,y:\
    \ 1)),\n    Line[float](s: Point[float](x: -1e308,y: 0), t: Point[float](x: 1e308,y:\
    \ 1)),\n    Line[float](s: Point[float](x: 0,y: 0), t: Point[float](x: 1e-308,y:\
    \ 1e308))]:\n    var raised = false\n    try: discard half_plane_intersection(@[bad])\n\
    \    except ValueError: raised = true\n    doAssert raised\n\nvar large: seq[Line[float]]\n\
    for i in 0..<20000:\n    large.add(toLine(constraint(0,1,int64(i))))\nlet largeResult\
    \ = half_plane_intersection(large)\ndoAssert largeResult.kind == hpiUnbounded\
    \ and largeResult.dimension == 2\n\nvar staircase: seq[Line[float]]\nfor i in\
    \ 0..<20000:\n    let k = float(i)\n    staircase.add(Line[float](s: Point[float](x:\
    \ 0,y: -k*k),\n        t: Point[float](x: 1,y: k-k*k)))\nlet stairs = half_plane_intersection(staircase)\n\
    doAssert stairs.kind == hpiUnbounded and stairs.dimension == 2\ndoAssert stairs.vertices.len\
    \ == 19999\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/half_plane_intersection.nim
  - cplib/geometry/half_plane_intersection.nim
  isVerificationFile: true
  path: verify/geometry/half_plane_intersection_test.nim
  requiredBy: []
  timestamp: '2026-11-16 00:30:02+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/half_plane_intersection_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/half_plane_intersection_test.nim
- /verify/verify/geometry/half_plane_intersection_test.nim.html
title: verify/geometry/half_plane_intersection_test.nim
---
