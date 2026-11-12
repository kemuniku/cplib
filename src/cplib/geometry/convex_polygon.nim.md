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
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/convex_cut_test.nim
    title: verify/AI/convex_cut_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/convex_cut_test.nim
    title: verify/AI/convex_cut_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/convex_polygon_test.nim
    title: verify/AI/convex_polygon_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/convex_polygon_test.nim
    title: verify/AI/convex_polygon_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_4/convex_cut_cgl4c_test.nim
    title: verify/geometry/CGL_4/convex_cut_cgl4c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_4/convex_cut_cgl4c_test.nim
    title: verify/geometry/CGL_4/convex_cut_cgl4c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_4/diameter_cgl4b_test.nim
    title: verify/geometry/CGL_4/diameter_cgl4b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_4/diameter_cgl4b_test.nim
    title: verify/geometry/CGL_4/diameter_cgl4b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/furthest_pair_test.nim
    title: verify/geometry/furthest_pair_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/furthest_pair_test.nim
    title: verify/geometry/furthest_pair_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GEOMETRY_CONVEX_POLYGON:\n    const CPLIB_GEOMETRY_CONVEX_POLYGON*\
    \ = 1\n    import cplib/geometry/base\n    import cplib/geometry/polygon\n   \
    \ import cplib/math/fractions\n    import algorithm, options\n\n    type ConvexPolygon*[T]\
    \ = object\n        vertices: seq[Point[T]]\n    type ConvexDiameter*[T] = object\n\
    \        distance_sq*: T\n        endpoints*: array[2, Point[T]]\n\n    proc convexExactEqual[T](a,\
    \ b: Point[T]): bool =\n        ## \u5EA7\u6A19\u3092EPS\u306A\u3057\u3067\u6BD4\
    \u8F03\u3059\u308B\u3002\n        a.x == b.x and a.y == b.y\n    proc convexLexLess[T](a,\
    \ b: Point[T]): bool =\n        ## \u5EA7\u6A19\u306E\u8F9E\u66F8\u9806\u3092\
    EPS\u306A\u3057\u3067\u6BD4\u8F03\u3059\u308B\u3002\n        a.x < b.x or (a.x\
    \ == b.x and a.y < b.y)\n    proc convexTurn[T](a, b, c: Point[T]): T =\n    \
    \    ## 3\u70B9\u306E\u7B26\u53F7\u4ED8\u304D\u5916\u7A4D\u3092\u6C42\u3081\u308B\
    \u3002\n        cross(b - a, c - a)\n    proc convexSign[T](x: T): int =\n   \
    \     ## \u65E2\u5B58\u306E\u5E7E\u4F55\u6BD4\u8F03\u306B\u5F93\u3063\u3066\u7B26\
    \u53F7\u3092\u6C42\u3081\u308B\u3002\n        let zero = x - x\n        if geometry_lt(x,\
    \ zero): -1\n        elif geometry_gt(x, zero): 1\n        else: 0\n    proc convexOnSegment[T](a,\
    \ b, p: Point[T]): bool =\n        ## \u96F6\u9577\u3082\u8A31\u3059\u7DDA\u5206\
    \u4E0A\u306E\u5305\u542B\u3092\u5224\u5B9A\u3059\u308B\u3002\n        if convexExactEqual(a,\
    \ b): return p == a\n        convexSign(convexTurn(a, b, p)) == 0 and\n      \
    \      geometry_le(dot(p - a, p - b), a.x - a.x)\n\n    proc initConvexPolygon*[T](v:\
    \ openArray[Point[T]]): ConvexPolygon[T] =\n        ## \u51F8\u591A\u89D2\u5F62\
    \u306E\u5468\u56DE\u9806\u306E\u9802\u70B9\u5217\u3092O(N)\u3067\u524D\u51E6\u7406\
    \u3059\u308B\u3002\u5171\u7DDA\u5165\u529B\u3082\u8A31\u3059\u3002\n        var\
    \ points: seq[Point[T]]\n        for p in v:\n            if points.len == 0 or\
    \ not convexExactEqual(points[^1], p): points.add(p)\n        if points.len >\
    \ 1 and convexExactEqual(points[0], points[^1]):\n            discard points.pop()\n\
    \        if points.len <= 1:\n            return ConvexPolygon[T](vertices: points)\n\
    \        var lo = 0\n        var hi = 0\n        for i in 1..<points.len:\n  \
    \          if convexLexLess(points[i], points[lo]): lo = i\n            if convexLexLess(points[hi],\
    \ points[i]): hi = i\n        let zero = points[0].x - points[0].x\n        #\
    \ \u5171\u7DDA\u4E0A\u306E\u4E38\u3081\u8AA4\u5DEE\u3067\u5411\u304D\u3092\u53CD\
    \u8EE2\u3057\u306A\u3044\u3088\u3046\u3001\u5E83\u3044\u4E09\u89D2\u5F62\u306E\
    \u5916\u7A4D\u3092\u4F7F\u3046\u3002\n        var orientation = zero\n       \
    \ for i in 0..<points.len:\n            let turn = convexTurn(points[lo], points[i],\
    \ points[(i+1) mod points.len])\n            if abs(turn) > abs(orientation):\
    \ orientation = turn\n        if orientation == zero:\n            return ConvexPolygon[T](vertices:\
    \ @[points[lo], points[hi]])\n        if orientation < zero:\n            points.reverse()\n\
    \            lo = points.len - 1 - lo\n        var normalized: seq[Point[T]]\n\
    \        for i in 0..<points.len:\n            let p = points[(lo+i) mod points.len]\n\
    \            while normalized.len >= 2 and convexTurn(normalized[^2], normalized[^1],\
    \ p) <= zero:\n                discard normalized.pop()\n            normalized.add(p)\n\
    \        while normalized.len >= 3 and convexTurn(normalized[^2], normalized[^1],\
    \ normalized[0]) <= zero:\n            discard normalized.pop()\n        result.vertices\
    \ = normalized\n\n    proc initConvexPolygon*[T](poly: Polygon[T]): ConvexPolygon[T]\
    \ =\n        ## Polygon\u306E\u9802\u70B9\u5217\u3092O(N)\u3067\u30B3\u30D4\u30FC\
    \u3057\u3066\u524D\u51E6\u7406\u3059\u308B\u3002\n        initConvexPolygon(poly.v)\n\
    \    proc len*[T](poly: ConvexPolygon[T]): int =\n        ## \u6B63\u898F\u5316\
    \u5F8C\u306E\u9802\u70B9\u6570\u3092O(1)\u3067\u8FD4\u3059\u3002\n        poly.vertices.len\n\
    \    iterator items*[T](poly: ConvexPolygon[T]): Point[T] =\n        ## \u6B63\
    \u898F\u5316\u5F8C\u306E\u9802\u70B9\u3092\u53CD\u6642\u8A08\u56DE\u308A\u306B\
    \u5217\u6319\u3059\u308B\u3002\n        for p in poly.vertices: yield p\n    proc\
    \ toPolygon*[T](poly: ConvexPolygon[T]): Polygon[T] =\n        ## \u72EC\u7ACB\
    \u3057\u305F\u9802\u70B9\u5217\u3092\u6301\u3064Polygon\u3092O(N)\u3067\u8FD4\u3059\
    \u3002\n        result.v = newSeq[Point[T]](poly.len)\n        for i, p in poly.vertices:\
    \ result.v[i] = p\n\n    proc convexLocation[T](poly: ConvexPolygon[T], p: Point[T]):\
    \ int =\n        ## \u70B9\u306E\u4F4D\u7F6E\u3092\u5916\u90E8=-1\u3001\u5883\u754C\
    =0\u3001\u5185\u90E8=1\u3067O(log N)\u3067\u8FD4\u3059\u3002\n        let n =\
    \ poly.len\n        if n == 0: return -1\n        if n == 1: return (if p == poly.vertices[0]:\
    \ 0 else: -1)\n        if n == 2:\n            return (if convexOnSegment(poly.vertices[0],\
    \ poly.vertices[1], p): 0 else: -1)\n        let origin = poly.vertices[0]\n \
    \       let first = convexSign(convexTurn(origin, poly.vertices[1], p))\n    \
    \    let last = convexSign(convexTurn(origin, poly.vertices[^1], p))\n       \
    \ if first < 0 or last > 0: return -1\n        if first == 0:\n            return\
    \ (if convexOnSegment(origin, poly.vertices[1], p): 0 else: -1)\n        if last\
    \ == 0:\n            return (if convexOnSegment(origin, poly.vertices[^1], p):\
    \ 0 else: -1)\n        var lo = 1\n        var hi = n - 1\n        let zero =\
    \ origin.x - origin.x\n        while hi - lo > 1:\n            let mid = (lo +\
    \ hi) div 2\n            if convexTurn(origin, poly.vertices[mid], p) >= zero:\
    \ lo = mid\n            else: hi = mid\n        let side = convexSign(convexTurn(poly.vertices[lo],\
    \ poly.vertices[hi], p))\n        if side == 0 and not convexOnSegment(poly.vertices[lo],\
    \ poly.vertices[hi], p): return -1\n        side\n\n    proc contains*[T](poly:\
    \ ConvexPolygon[T], p: Point[T], strict: bool = false): bool =\n        ## O(log\
    \ N)\u3067\u5305\u542B\u3092\u5224\u5B9A\u3059\u308B\u3002strict=true\u3067\u306F\
    \u5883\u754C\u3092\u9664\u304D\u30012\u9802\u70B9\u4EE5\u4E0B\u306F\u5E38\u306B\
    false\u3002\n        let location = convexLocation(poly, p)\n        if strict:\
    \ location > 0\n        else: location >= 0\n    proc on_edge*[T](poly: ConvexPolygon[T],\
    \ p: Point[T]): bool =\n        ## O(log N)\u3067\u5883\u754C\u4E0A\u304B\u5224\
    \u5B9A\u3059\u308B\u30021\u9802\u70B9\u306F\u305D\u306E\u70B9\u30012\u9802\u70B9\
    \u306F\u7DDA\u5206\u3092\u5883\u754C\u3068\u3059\u308B\u3002\n        convexLocation(poly,\
    \ p) == 0\n\n    proc diameter*[T](poly: ConvexPolygon[T]): Option[ConvexDiameter[T]]\
    \ =\n        ## \u56DE\u8EE2calipers\u3067\u4E8C\u4E57\u76F4\u5F84\u3068\u7AEF\
    \u70B9\u3092O(N)\u3067\u8FD4\u3059\u3002\u7A7A\u306Fnone\u30011\u9802\u70B9\u306F\
    \u8DDD\u96E20\u3002\n        let n = poly.len\n        if n == 0: return none(ConvexDiameter[T])\n\
    \        var best = ConvexDiameter[T](distance_sq: norm(poly.vertices[0] - poly.vertices[0]),\n\
    \            endpoints: [poly.vertices[0], poly.vertices[0]])\n        template\
    \ consider(i, j: int) =\n            let distance = norm(poly.vertices[i] - poly.vertices[j])\n\
    \            if distance > best.distance_sq:\n                best = ConvexDiameter[T](distance_sq:\
    \ distance,\n                    endpoints: [poly.vertices[i], poly.vertices[j]])\n\
    \        if n == 2:\n            consider(0, 1)\n        elif n >= 3:\n      \
    \      var j = 1\n            let zero = best.distance_sq - best.distance_sq\n\
    \            for i in 0..<n:\n                let next = (i+1) mod n\n       \
    \         let edge = poly.vertices[next] - poly.vertices[i]\n                #\
    \ \u8FD1\u3044\u9762\u7A4D\u540C\u58EB\u306E\u6BD4\u8F03\u3092\u907F\u3051\u3001\
    \u9762\u7A4D\u306E\u5897\u5206\u3092\u8FBA\u540C\u58EB\u306E\u5916\u7A4D\u3067\
    \u6C42\u3081\u308B\u3002\n                while cross(edge, poly.vertices[(j+1)\
    \ mod n] - poly.vertices[j]) > zero:\n                    j = (j+1) mod n\n  \
    \              consider(i, j)\n                consider(next, j)\n           \
    \     if cross(edge, poly.vertices[(j+1) mod n] - poly.vertices[j]) == zero:\n\
    \                    consider(i, (j+1) mod n)\n                    consider(next,\
    \ (j+1) mod n)\n        some(best)\n    proc diameter*[T](poly: Polygon[T]): Option[ConvexDiameter[T]]\
    \ =\n        ## \u51F8Polygon\u3092O(N)\u3067\u524D\u51E6\u7406\u3057\u3066\u4E8C\
    \u4E57\u76F4\u5F84\u3068\u7AEF\u70B9\u3092\u8FD4\u3059\u3002\n        diameter(initConvexPolygon(poly))\n\
    \n    proc convex_cut*[T](poly: Polygon[T], line: Line[T]): Polygon[T] =\n   \
    \     ## \u51F8\u591A\u89D2\u5F62\u3092O(N)\u3067\u5207\u65AD\u3057\u3001\u6709\
    \u5411\u76F4\u7DDA\u306E\u5DE6\u5074\u3068\u5883\u754C\u3092\u8FD4\u3059\u3002\
    float/Fraction\u5C02\u7528\u3002\n        when T isnot SomeFloat and T isnot Fraction:\n\
    \            {.error: \"convex_cut\u306B\u306Ffloat\u307E\u305F\u306FFraction\u306E\
    \u5EA7\u6A19\u3092\u4F7F\u7528\u3057\u3066\u304F\u3060\u3055\u3044\".}\n     \
    \   else:\n            assert line.s != line.t, \"\u5207\u65AD\u76F4\u7DDA\u306E\
    \u59CB\u70B9\u3068\u7D42\u70B9\u306F\u7570\u306A\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n            template append(p: Point[T]) =\n           \
    \     let point = p\n                if result.v.len == 0 or result.v[^1] != point:\
    \ result.v.add(point)\n            for i in 0..<poly.len:\n                let\
    \ a = poly.v[i]\n                let b = poly.v[(i+1) mod poly.len]\n        \
    \        let ca = cross(line.vector, a - line.s)\n                let cb = cross(line.vector,\
    \ b - line.s)\n                let sa = convexSign(ca)\n                let sb\
    \ = convexSign(cb)\n                if sa >= 0: append(a)\n                if\
    \ sa * sb < 0: append(a + (b - a) * (ca / (ca - cb)))\n            if result.v.len\
    \ > 1 and result.v[0] == result.v[^1]: discard result.v.pop()\n    proc convex_cut*[T](poly:\
    \ ConvexPolygon[T], line: Line[T]): Polygon[T] =\n        ## \u524D\u51E6\u7406\
    \u6E08\u307F\u51F8\u591A\u89D2\u5F62\u3092O(N)\u3067\u5207\u65AD\u3057\u3001\u5DE6\
    \u5074\u3068\u5883\u754C\u306EPolygon\u3092\u8FD4\u3059\u3002\n        convex_cut(Polygon[T](v:\
    \ poly.vertices), line)\n"
  dependsOn:
  - cplib/geometry/ccw.nim
  - cplib/geometry/polygon.nim
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  isVerificationFile: false
  path: cplib/geometry/convex_polygon.nim
  requiredBy: []
  timestamp: '2026-11-13 04:50:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/furthest_pair_test.nim
  - verify/geometry/furthest_pair_test.nim
  - verify/geometry/CGL_4/convex_cut_cgl4c_test.nim
  - verify/geometry/CGL_4/convex_cut_cgl4c_test.nim
  - verify/geometry/CGL_4/diameter_cgl4b_test.nim
  - verify/geometry/CGL_4/diameter_cgl4b_test.nim
  - verify/AI/convex_cut_test.nim
  - verify/AI/convex_cut_test.nim
  - verify/AI/convex_polygon_test.nim
  - verify/AI/convex_polygon_test.nim
documentation_of: cplib/geometry/convex_polygon.nim
layout: document
redirect_from:
- /library/cplib/geometry/convex_polygon.nim
- /library/cplib/geometry/convex_polygon.nim.html
title: cplib/geometry/convex_polygon.nim
---
