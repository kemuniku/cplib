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
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/area_float_cgl3a_test.nim
    title: verify/geometry/CGL_3/area_float_cgl3a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/area_float_cgl3a_test.nim
    title: verify/geometry/CGL_3/area_float_cgl3a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/area_fraction_cgl3a_test.nim
    title: verify/geometry/CGL_3/area_fraction_cgl3a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/area_fraction_cgl3a_test.nim
    title: verify/geometry/CGL_3/area_fraction_cgl3a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/area_int_cgl3a_test.nim
    title: verify/geometry/CGL_3/area_int_cgl3a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/area_int_cgl3a_test.nim
    title: verify/geometry/CGL_3/area_int_cgl3a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/contains_cgl3c_test.nim
    title: verify/geometry/CGL_3/contains_cgl3c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/contains_cgl3c_test.nim
    title: verify/geometry/CGL_3/contains_cgl3c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/isconvex_float_cgl3b_test.nim
    title: verify/geometry/CGL_3/isconvex_float_cgl3b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/isconvex_float_cgl3b_test.nim
    title: verify/geometry/CGL_3/isconvex_float_cgl3b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/isconvex_fraction_cgl3b_test.nim
    title: verify/geometry/CGL_3/isconvex_fraction_cgl3b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/isconvex_fraction_cgl3b_test.nim
    title: verify/geometry/CGL_3/isconvex_fraction_cgl3b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/isconvex_int_cgl3b_test.nim
    title: verify/geometry/CGL_3/isconvex_int_cgl3b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_3/isconvex_int_cgl3b_test.nim
    title: verify/geometry/CGL_3/isconvex_int_cgl3b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
    title: verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
    title: verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GEOMETRY_POLYGON:\n    const CPLIB_GEOMETRY_POLYGON*\
    \ = 1\n    import cplib/geometry/base\n    import cplib/geometry/ccw\n    import\
    \ cplib/math/fractions\n    import algorithm\n    type Polygon*[T] = object\n\
    \        v*: seq[Point[T]]\n    proc len*[T](poly: Polygon[T]): int = poly.v.len\n\
    \    iterator items*[T](poly: Polygon[T]): Point[T] =\n        for item in poly.v:\
    \ yield item\n\n    proc initPolygon*[T](v: seq[Point[T]]): Polygon[T] = Polygon[T](v:\
    \ v)\n    proc area*(p: Polygon[int]): int =\n        for i in 0..<p.v.len: result\
    \ += cross(p.v[i], p.v[(i+1) mod p.v.len])\n    proc area*[T](p: Polygon[Fraction[T]]):\
    \ Fraction[T] =\n        result = initFraction(0)\n        for i in 0..<p.v.len:\
    \ result += cross(p.v[i], p.v[(i+1) mod p.v.len]) / 2\n    proc area*(p: Polygon[float]):\
    \ float =\n        for i in 0..<p.v.len: result += cross(p.v[i], p.v[(i+1) mod\
    \ p.v.len]) / 2.0\n\n    proc is_convex_ccw*[T](poly: Polygon[T], strict: bool\
    \ = true): bool =\n        for i in 0..<poly.len:\n            var ccwi = ccw(poly.v[i],\
    \ poly.v[(i+1) mod poly.len], poly.v[(i+2) mod poly.len])\n            if strict\
    \ and ccwi != COUNTER_CLOCKWISE: return false\n            if (not strict) and\
    \ ccwi == CLOCKWISE: return false\n        return true\n    proc is_convex*[T](poly:\
    \ Polygon[T], strict: bool = true): bool =\n        if is_convex_ccw(poly, strict):\
    \ return true\n        var pn = Polygon[T](v: poly.v.reversed)\n        return\
    \ is_convex_ccw(pn, strict)\n\n    proc on_edge*[T](poly: Polygon[T], p: Point[T]):\
    \ bool =\n        for i in 0..<poly.len:\n            if ccw(poly.v[i], poly.v[(i+1)\
    \ mod poly.len], p) == ON_SEGMENT: return true\n        return false\n    proc\
    \ contains*[T](poly: Polygon[T], p: Point[T], strict: bool = false): bool =\n\
    \        if on_edge(poly, p):\n            if strict: return false\n         \
    \   else: return true\n        result = false\n        for i in 0..<poly.len:\n\
    \            var a = poly.v[i] - p\n            var b = poly.v[(i+1) mod poly.len]\
    \ - p\n            if a.y > b.y: swap(a, b)\n            if geometry_le(a.y, 0)\
    \ and geometry_gt(b.y, 0) and geometry_lt(cross(a, b), 0):\n                result\
    \ = not result\n\n    # proc contains*[T](poly: Polygon[T], p: Point[T]): bool\
    \ = contains(poly, p, false)\n\n    proc convex_hull*[T](poly: Polygon[T], strict:\
    \ bool = true): Polygon[T] =\n        var n = poly.v.len\n        if n < 3: return\
    \ poly\n        var s = poly.v.sorted\n        var v = s[0..1]\n        for i\
    \ in 2..<n:\n            if strict:\n                while v.len >= 2 and ccw(v[^2],\
    \ v[^1], s[i]) != COUNTER_CLOCKWISE: discard v.pop\n            else:\n      \
    \          while v.len >= 2 and ccw(v[^2], v[^1], s[i]) == CLOCKWISE: discard\
    \ v.pop\n            v.add(s[i])\n        var lower_size = v.len\n        for\
    \ i in countdown(n-2, 0):\n            if strict:\n                while v.len\
    \ > lower_size and ccw(v[^2], v[^1], s[i]) != COUNTER_CLOCKWISE: discard v.pop\n\
    \            else:\n                while v.len > lower_size and ccw(v[^2], v[^1],\
    \ s[i]) == CLOCKWISE: discard v.pop\n            v.add(s[i])\n        v.delete(0)\n\
    \        return Polygon[T](v: v)\n"
  dependsOn:
  - cplib/geometry/ccw.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/ccw.nim
  - cplib/math/fractions.nim
  isVerificationFile: false
  path: cplib/geometry/polygon.nim
  requiredBy: []
  timestamp: '2024-03-20 03:35:18+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
  - verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
  - verify/geometry/CGL_3/isconvex_float_cgl3b_test.nim
  - verify/geometry/CGL_3/isconvex_float_cgl3b_test.nim
  - verify/geometry/CGL_3/area_int_cgl3a_test.nim
  - verify/geometry/CGL_3/area_int_cgl3a_test.nim
  - verify/geometry/CGL_3/isconvex_int_cgl3b_test.nim
  - verify/geometry/CGL_3/isconvex_int_cgl3b_test.nim
  - verify/geometry/CGL_3/area_float_cgl3a_test.nim
  - verify/geometry/CGL_3/area_float_cgl3a_test.nim
  - verify/geometry/CGL_3/contains_cgl3c_test.nim
  - verify/geometry/CGL_3/contains_cgl3c_test.nim
  - verify/geometry/CGL_3/isconvex_fraction_cgl3b_test.nim
  - verify/geometry/CGL_3/isconvex_fraction_cgl3b_test.nim
  - verify/geometry/CGL_3/area_fraction_cgl3a_test.nim
  - verify/geometry/CGL_3/area_fraction_cgl3a_test.nim
documentation_of: cplib/geometry/polygon.nim
layout: document
redirect_from:
- /library/cplib/geometry/polygon.nim
- /library/cplib/geometry/polygon.nim.html
title: cplib/geometry/polygon.nim
---
