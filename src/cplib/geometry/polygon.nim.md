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
  - icon: ':heavy_check_mark:'
    path: verify/geometry/convex_hull_abc286ex_test.nim
    title: verify/geometry/convex_hull_abc286ex_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/convex_hull_abc286ex_test.nim
    title: verify/geometry/convex_hull_abc286ex_test.nim
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
    \ yield item\n\n    proc initPolygon*[T](v: seq[Point[T]]): Polygon[T] =\n   \
    \     ## \u9802\u70B9\u5217 v \u306E\u591A\u89D2\u5F62\u578B\u3092\u521D\u671F\
    \u5316\n        Polygon[T](v: v)\n    proc area*(p: Polygon[int]): int =\n   \
    \     ## \u591A\u89D2\u5F62\u306E\u9762\u7A4D\u306E2\u500D\u3001\u9802\u70B9\u5217\
    \u304C\u6642\u8A08\u56DE\u308A\u306E\u5834\u5408\u8CA0\u306E\u6570\u304C\u8FD4\
    \u308B\n        for i in 0..<p.v.len: result += cross(p.v[i], p.v[(i+1) mod p.v.len])\n\
    \    proc area*[T](p: Polygon[Fraction[T]]): Fraction[T] =\n        ## \u591A\u89D2\
    \u5F62\u306E\u9762\u7A4D\u3001\u9802\u70B9\u5217\u304C\u6642\u8A08\u56DE\u308A\
    \u306E\u5834\u5408\u8CA0\u306E\u6570\u304C\u8FD4\u308B\n        result = initFraction(0)\n\
    \        for i in 0..<p.v.len: result += cross(p.v[i], p.v[(i+1) mod p.v.len])\
    \ / 2\n    proc area*(p: Polygon[float]): float =\n        ## \u591A\u89D2\u5F62\
    \u306E\u9762\u7A4D\u3001\u9802\u70B9\u5217\u304C\u6642\u8A08\u56DE\u308A\u306E\
    \u5834\u5408\u8CA0\u306E\u6570\u304C\u8FD4\u308B\n        for i in 0..<p.v.len:\
    \ result += cross(p.v[i], p.v[(i+1) mod p.v.len]) / 2.0\n\n    proc is_convex_ccw*[T](poly:\
    \ Polygon[T], strict: bool = true): bool =\n        ## \u9802\u70B9\u5217\u304C\
    \u53CD\u6642\u8A08\u56DE\u308A\u306E\u591A\u89D2\u5F62\u306B\u5BFE\u3057\u3066\
    \u3001\u51F8\u304B\u3069\u3046\u304B\u3092\u5224\u5B9A\n        for i in 0..<poly.len:\n\
    \            var ccwi = ccw(poly.v[i], poly.v[(i+1) mod poly.len], poly.v[(i+2)\
    \ mod poly.len])\n            if strict and ccwi != COUNTER_CLOCKWISE: return\
    \ false\n            if (not strict) and ccwi == CLOCKWISE: return false\n   \
    \     return true\n    proc is_convex*[T](poly: Polygon[T], strict: bool = true):\
    \ bool =\n        ## \u591A\u89D2\u5F62\u304C\u51F8\u304B\u3069\u3046\u304B\u3092\
    \u5224\u5B9A\u3001\u3061\u3087\u3046\u3069 180 \u5EA6\u306E\u5185\u89D2\u3092\u8A31\
    \u5BB9\u3059\u308B\u5834\u5408\u306F strict = false \u3092\u8A2D\u5B9A\n     \
    \   if is_convex_ccw(poly, strict): return true\n        var pn = Polygon[T](v:\
    \ poly.v.reversed)\n        return is_convex_ccw(pn, strict)\n\n    proc on_edge*[T](poly:\
    \ Polygon[T], p: Point[T]): bool =\n        ## \u70B9 p \u304C\u591A\u89D2\u5F62\
    \ poly \u306E\u8FBA\u4E0A\u306B\u3042\u308B\u304B\u3069\u3046\u304B\u3092\u5224\
    \u5B9A\n        for i in 0..<poly.len:\n            if ccw(poly.v[i], poly.v[(i+1)\
    \ mod poly.len], p) == ON_SEGMENT: return true\n        return false\n    proc\
    \ contains*[T](poly: Polygon[T], p: Point[T], strict: bool = false): bool =\n\
    \        ## \u81EA\u5DF1\u4EA4\u5DEE\u306E\u306A\u3044\u591A\u89D2\u5F62 poly\
    \ \u5185\u306B\u70B9 p \u304C\u5B58\u5728\u3059\u308B\u304B\u3092\u5224\u5B9A\u3001\
    \u8FBA\u4E0A\u306B\u3042\u308B\u5834\u5408\u3092\u542B\u3081\u306A\u3044\u5834\
    \u5408\u306F strict = true \u3092\u8A2D\u5B9A\n        if on_edge(poly, p):\n\
    \            if strict: return false\n            else: return true\n        result\
    \ = false\n        for i in 0..<poly.len:\n            var a = poly.v[i] - p\n\
    \            var b = poly.v[(i+1) mod poly.len] - p\n            if a.y > b.y:\
    \ swap(a, b)\n            if geometry_le(a.y, 0) and geometry_gt(b.y, 0) and geometry_lt(cross(a,\
    \ b), 0):\n                result = not result\n\n    proc convex_hull*[T](v:\
    \ seq[Point[T]], strict: bool = true): Polygon[T] =\n        ## \u70B9\u7FA4 v\
    \ \u306E\u51F8\u5305\n        var n = v.len\n        if n < 3: return Polygon[T](v:\
    \ v)\n        var s = v.sorted\n        var vi = s[0..1]\n        for i in 2..<n:\n\
    \            if strict:\n                while vi.len >= 2 and ccw(vi[^2], vi[^1],\
    \ s[i]) != COUNTER_CLOCKWISE: discard vi.pop\n            else:\n            \
    \    while vi.len >= 2 and ccw(vi[^2], vi[^1], s[i]) == CLOCKWISE: discard vi.pop\n\
    \            vi.add(s[i])\n        var lower_size = vi.len\n        for i in countdown(n-2,\
    \ 0):\n            if strict:\n                while vi.len > lower_size and ccw(vi[^2],\
    \ vi[^1], s[i]) != COUNTER_CLOCKWISE: discard vi.pop\n            else:\n    \
    \            while vi.len > lower_size and ccw(vi[^2], vi[^1], s[i]) == CLOCKWISE:\
    \ discard vi.pop\n            vi.add(s[i])\n        vi.delete(0)\n        return\
    \ Polygon[T](v: vi)\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  isVerificationFile: false
  path: cplib/geometry/polygon.nim
  requiredBy: []
  timestamp: '2024-03-28 19:09:38+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/CGL_3/area_int_cgl3a_test.nim
  - verify/geometry/CGL_3/area_int_cgl3a_test.nim
  - verify/geometry/CGL_3/isconvex_float_cgl3b_test.nim
  - verify/geometry/CGL_3/isconvex_float_cgl3b_test.nim
  - verify/geometry/CGL_3/isconvex_fraction_cgl3b_test.nim
  - verify/geometry/CGL_3/isconvex_fraction_cgl3b_test.nim
  - verify/geometry/CGL_3/contains_cgl3c_test.nim
  - verify/geometry/CGL_3/contains_cgl3c_test.nim
  - verify/geometry/CGL_3/area_fraction_cgl3a_test.nim
  - verify/geometry/CGL_3/area_fraction_cgl3a_test.nim
  - verify/geometry/CGL_3/area_float_cgl3a_test.nim
  - verify/geometry/CGL_3/area_float_cgl3a_test.nim
  - verify/geometry/CGL_3/isconvex_int_cgl3b_test.nim
  - verify/geometry/CGL_3/isconvex_int_cgl3b_test.nim
  - verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
  - verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
  - verify/geometry/convex_hull_abc286ex_test.nim
  - verify/geometry/convex_hull_abc286ex_test.nim
documentation_of: cplib/geometry/polygon.nim
layout: document
redirect_from:
- /library/cplib/geometry/polygon.nim
- /library/cplib/geometry/polygon.nim.html
title: cplib/geometry/polygon.nim
---
