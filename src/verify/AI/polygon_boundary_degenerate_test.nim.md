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
    import algorithm, sequtils\nimport cplib/geometry/base\nimport cplib/geometry/polygon\n\
    import cplib/math/fractions\n\nproc boundary(v: seq[Point[int]], p: Point[int]):\
    \ bool =\n    for i, a in v:\n        let b = v[(i + 1) mod v.len]\n        let\
    \ determinant = (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x)\n      \
    \  if determinant == 0 and min(a.x, b.x) <= p.x and p.x <= max(a.x, b.x) and\n\
    \                min(a.y, b.y) <= p.y and p.y <= max(a.y, b.y):\n            return\
    \ true\n\nproc interior(v: seq[Point[int]], p: Point[int]): bool =\n    if boundary(v,\
    \ p): return false\n    var winding = 0\n    for i, a in v:\n        let b = v[(i\
    \ + 1) mod v.len]\n        let determinant = (b.x - a.x) * (p.y - a.y) - (b.y\
    \ - a.y) * (p.x - a.x)\n        if a.y <= p.y and b.y > p.y and determinant >\
    \ 0: inc winding\n        if a.y > p.y and b.y <= p.y and determinant < 0: dec\
    \ winding\n    winding != 0\n\nproc checkTyped[T](v: seq[Point[T]], p: Point[T],\
    \ edge, inside: bool, checkContains: bool) =\n    let poly = initPolygon(v)\n\
    \    doAssert poly.on_edge(p) == edge, $v & \" / \" & $p\n    if checkContains:\n\
    \        doAssert poly.contains(p) == (edge or inside), $v & \" / \" & $p\n  \
    \      doAssert poly.contains(p, true) == inside, $v & \" / \" & $p\n    doAssert\
    \ poly.v.len == v.len\n    for i in 0..<v.len:\n        doAssert poly.v[i].x ==\
    \ v[i].x and poly.v[i].y == v[i].y\n\nvar boundaryQueries, containsQueries = 0\n\
    proc check(v: seq[Point[int]], checkContains: bool) =\n    let vi32 = v.mapIt(initPoint(int32(it.x),\
    \ int32(it.y)))\n    let vi64 = v.mapIt(initPoint(int64(it.x), int64(it.y)))\n\
    \    let vf32 = v.mapIt(initPoint(float32(it.x), float32(it.y)))\n    let vf64\
    \ = v.mapIt(initPoint(float64(it.x), float64(it.y)))\n    let vr = v.mapIt(initPoint(initFraction(it.x),\
    \ initFraction(it.y)))\n    for x in -2..2:\n        for y in -2..2:\n       \
    \     let p = initPoint(x, y)\n            let edge = boundary(v, p)\n       \
    \     let inside = checkContains and interior(v, p)\n            checkTyped(v,\
    \ p, edge, inside, checkContains)\n            checkTyped(vi32, initPoint(int32(x),\
    \ int32(y)), edge, inside, checkContains)\n            checkTyped(vi64, initPoint(int64(x),\
    \ int64(y)), edge, inside, checkContains)\n            checkTyped(vf32, initPoint(float32(x),\
    \ float32(y)), edge, inside, checkContains)\n            checkTyped(vf64, initPoint(float64(x),\
    \ float64(y)), edge, inside, checkContains)\n            checkTyped(vr, initPoint(initFraction(x),\
    \ initFraction(y)), edge, inside, checkContains)\n            inc boundaryQueries\n\
    \            if checkContains: inc containsQueries\n\nvar grid: seq[Point[int]]\n\
    for x in -1..1:\n    for y in -1..1: grid.add(initPoint(x, y))\n\nproc enumerate(v:\
    \ var seq[Point[int]], remaining: int) =\n    check(v, v.len <= 3)\n    if remaining\
    \ == 0: return\n    for p in grid:\n        v.add(p)\n        enumerate(v, remaining\
    \ - 1)\n        v.setLen(v.len - 1)\nvar v: seq[Point[int]]\nenumerate(v, 4)\n\
    doAssert boundaryQueries == 184525\ndoAssert containsQueries == 20500\n\nlet shapes\
    \ = @[\n    @[initPoint(-2, -2), initPoint(2, -2), initPoint(2, 2), initPoint(-2,\
    \ 2)],\n    @[initPoint(-2, -2), initPoint(2, -2), initPoint(0, 0), initPoint(2,\
    \ 2), initPoint(-2, 2)],\n    @[initPoint(-2, -2), initPoint(2, -2), initPoint(2,\
    \ 2), initPoint(0, 2), initPoint(0, 0), initPoint(-2, 0)],\n    @[initPoint(-2,\
    \ 0), initPoint(0, 0), initPoint(2, 0)],\n    @[initPoint(0, -2), initPoint(0,\
    \ 0), initPoint(0, 2)],\n    @[initPoint(-2, -2), initPoint(0, 0), initPoint(2,\
    \ 2)],\n]\nfor shape in shapes:\n    for mask in 0..<(1 shl shape.len):\n    \
    \    var repeated: seq[Point[int]]\n        for i, p in shape:\n            repeated.add(p)\n\
    \            if (mask and (1 shl i)) != 0: repeated.add(p)\n        for closed\
    \ in [false, true]:\n            var input = repeated\n            if closed:\
    \ input.add(input[0])\n            check(input, true)\n            check(input.reversed,\
    \ true)\n            for offset in 1..<input.len:\n                check(input[offset..^1]\
    \ & input[0..<offset], true)\n\nblock:\n    let a = initPoint(0.0, 0.0)\n    let\
    \ b = initPoint(1e-12, 0.0)\n    let tiny = initPolygon([a, b])\n    doAssert\
    \ tiny.on_edge(a)\n    doAssert tiny.on_edge(b)\n    doAssert tiny.contains(a)\n\
    \    doAssert not tiny.contains(a, true)\n    doAssert not tiny.contains(initPoint(1.0,\
    \ 1.0))\n    let repeated = initPolygon([a, a])\n    doAssert repeated.on_edge(initPoint(1e-12,\
    \ 0.0))\n    doAssert not repeated.on_edge(initPoint(1.0, 0.0))\n\nblock:\n  \
    \  let r = initFraction(1, 2)\n    let p = initPoint(r, r)\n    let single = initPolygon([p,\
    \ p, p])\n    doAssert single.on_edge(p) and single.contains(p)\n    doAssert\
    \ not single.contains(p, true)\n    doAssert not single.on_edge(initPoint(initFraction(1,\
    \ 3), r))\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/math/fractions.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/polygon.nim
  - cplib/math/fractions.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/base.nim
  isVerificationFile: true
  path: verify/AI/polygon_boundary_degenerate_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:20:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/polygon_boundary_degenerate_test.nim
layout: document
redirect_from:
- /verify/verify/AI/polygon_boundary_degenerate_test.nim
- /verify/verify/AI/polygon_boundary_degenerate_test.nim.html
title: verify/AI/polygon_boundary_degenerate_test.nim
---
