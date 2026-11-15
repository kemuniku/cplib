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
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/AI/exact_circle_oracle_driver.nim
    title: verify/AI/exact_circle_oracle_driver.nim
  - icon: ':warning:'
    path: verify/AI/exact_circle_oracle_driver.nim
    title: verify/AI/exact_circle_oracle_driver.nim
  - icon: ':warning:'
    path: verify/geometry/minimum_enclosing_circle_abc151f_test_.nim
    title: verify/geometry/minimum_enclosing_circle_abc151f_test_.nim
  - icon: ':warning:'
    path: verify/geometry/minimum_enclosing_circle_abc151f_test_.nim
    title: verify/geometry/minimum_enclosing_circle_abc151f_test_.nim
  - icon: ':warning:'
    path: verify/geometry/minimum_enclosing_circle_exact_abc151f_test_.nim
    title: verify/geometry/minimum_enclosing_circle_exact_abc151f_test_.nim
  - icon: ':warning:'
    path: verify/geometry/minimum_enclosing_circle_exact_abc151f_test_.nim
    title: verify/geometry/minimum_enclosing_circle_exact_abc151f_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/circle_generic_type_test.nim
    title: verify/AI/circle_generic_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/circle_generic_type_test.nim
    title: verify/AI/circle_generic_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/exact_circle_import_test.nim
    title: verify/AI/exact_circle_import_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/exact_circle_import_test.nim
    title: verify/AI/exact_circle_import_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/exact_circle_type_test.nim
    title: verify/AI/exact_circle_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/exact_circle_type_test.nim
    title: verify/AI/exact_circle_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/minimum_enclosing_circle_exact_test.nim
    title: verify/AI/minimum_enclosing_circle_exact_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/minimum_enclosing_circle_exact_test.nim
    title: verify/AI/minimum_enclosing_circle_exact_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/minimum_enclosing_circle_test.nim
    title: verify/AI/minimum_enclosing_circle_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/minimum_enclosing_circle_test.nim
    title: verify/AI/minimum_enclosing_circle_test.nim
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
  code: "when not declared CPLIB_GEOMETRY_MINIMUM_ENCLOSING_CIRCLE:\n    const CPLIB_GEOMETRY_MINIMUM_ENCLOSING_CIRCLE*\
    \ = 1\n    import math, random\n    import cplib/geometry/base\n    import cplib/geometry/circle\n\
    \n    ## \u5C40\u6240Rand\u306E\u56FA\u5B9Aseed\u306B\u3088\u308B\u5897\u5206\u6CD5\
    \u3002\u5165\u529B\u30FB\u30B0\u30ED\u30FC\u30D0\u30EB\u4E71\u6570\u72B6\u614B\
    \u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n    ## \u7A7A\u5165\u529B\u306F\u5236\
    \u7D04\u9055\u53CD\u3067ValueError\u3002\u5358\u70B9\u30FB\u5168\u91CD\u8907\u306F\
    \u70B9\u5186\u3001\u5171\u7DDA\u70B9\u3082\u8A31\u3059\u3002\n    ## \u975Efloat\u306F\
    Circle[T]\u3001float\u5165\u529B\u306FCircle[float]\u3092\u76F4\u63A5\u8FD4\u3059\
    \u3002\n    ## \u975Efloat\u306F\u5168\u5224\u5B9A\u3092\u6307\u5B9A\u57FA\u5E95\
    \u578B\u3067\u53B3\u5BC6\u8A08\u7B97\u3057\u3001\u81EA\u52D5BigInt\u5316\u3057\
    \u306A\u3044\u3002\u5168\u4E2D\u9593\u5024\u304C\u578B\u306B\u53CE\u307E\u308B\
    \u3053\u3068\u304C\u524D\u63D0\u3002\n    ## float\u306F\u65E2\u5B9A\u76F8\u5BFE\
    \u8A31\u5BB9\u8AA4\u5DEE1e-12\u3001\u5E73\u884C\u79FB\u52D5\u30FB\u5C3A\u5EA6\u6B63\
    \u898F\u5316\u3001\u6700\u5F8C\u306E\u534A\u5F84\u88DC\u6B63\u3092\u4F7F\u7528\
    \u3059\u308B\u3002\n    ## float\u5165\u529B\u30FB\u5DEE\u30FB\u8DDD\u96E2\u30FB\
    \u51FA\u529B\u306F\u6709\u9650\u304B\u3064float64\u3067\u8868\u73FE\u53EF\u80FD\
    \u3067\u3042\u308B\u3053\u3068\u3002\u60AA\u6761\u4EF6\u5165\u529B\u3067\u306F\
    \u7CBE\u5EA6\u3092\u5931\u3044\u3046\u308B\u3002\n    ## \u671F\u5F85O(n)\u3001\
    \u6700\u60AAO(n^3)\u7B97\u8853\u64CD\u4F5C\u3001\u8FFD\u52A0\u7A7A\u9593O(n)\u3002\
    \u591A\u500D\u9577\u6F14\u7B97\u306E\u8CBB\u7528\u306F\u6841\u6570\u306B\u4F9D\
    \u5B58\u3059\u308B\u3002\n    ## \u540C\u3058\u5165\u529B\u30FBseed\u30FBNim\u7248\
    \u3067\u518D\u73FE\u53EF\u80FD\u3002\u5883\u754C3\u70B9\u306E\u9078\u629E\u30FB\
    \u9806\u5E8F\u306Fseed\u30FB\u7248\u3067\u5909\u308F\u308A\u3046\u308B\u3002\n\
    \n    proc mecLength(p: Point[float]): float =\n        ##\u5E73\u65B9\u306E\u30AA\
    \u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\u3092\u907F\u3051\u3066\u30D9\u30AF\u30C8\
    \u30EB\u9577\u3092\u8A08\u7B97\u3059\u308B\u3002O(1)\u3002\n        if p.x !=\
    \ p.x or p.y != p.y or abs(p.x) == system.Inf or abs(p.y) == system.Inf:\n   \
    \         raise newException(ValueError, \"\u6700\u5C0F\u5305\u542B\u5186\u306E\
    \u5EA7\u6A19\u3068\u4E2D\u9593\u5024\u306F\u6709\u9650\u3067\u3042\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\")\n        let scale = max(abs(p.x), abs(p.y))\n\
    \        if scale == 0: return 0\n        result = scale * sqrt((p.x / scale)\
    \ * (p.x / scale) + (p.y / scale) * (p.y / scale))\n        if result == system.Inf:\
    \ raise newException(ValueError, \"\u6700\u5C0F\u5305\u542B\u5186\u306E\u8DDD\u96E2\
    \u306F\u6709\u9650\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \")\n\n    proc mecDiameter(a, b: Point[float]): Circle[float] =\n        ##2\u70B9\
    \u3092\u76F4\u5F84\u306E\u4E21\u7AEF\u3068\u3059\u308B\u5186\u3092\u8FD4\u3059\
    \u3002O(1)\u3002\n        let center = a + (b - a) * 0.5\n        initCircle(center,\
    \ max(mecLength(a - center), mecLength(b - center)))\n\n    proc mecThree(a, b,\
    \ c: Point[float]): Circle[float] =\n        ##3\u5883\u754C\u70B9\u306E\u5916\
    \u63A5\u5186\u3092\u8FD4\u3059\u3002\u5171\u7DDA\u6642\u306F\u6700\u9060\u70B9\
    \u5BFE\u306E\u76F4\u5F84\u5186\u3002O(1)\u3002\n        let u = b - a\n      \
    \  let v = c - a\n        let scale = max(max(abs(u.x), abs(u.y)), max(abs(v.x),\
    \ abs(v.y)))\n        if scale == 0: return initCircle(a, 0)\n        let un =\
    \ initPoint(u.x / scale, u.y / scale)\n        let vn = initPoint(v.x / scale,\
    \ v.y / scale)\n        let determinant = 2 * cross(un, vn)\n        if determinant\
    \ == 0:\n            result = mecDiameter(a, b)\n            for candidate in\
    \ [mecDiameter(a, c), mecDiameter(b, c)]:\n                if candidate.radius\
    \ > result.radius: result = candidate\n            return\n        let usq = dot(un,\
    \ un)\n        let vsq = dot(vn, vn)\n        let offset = initPoint((vn.y * usq\
    \ - un.y * vsq) / determinant * scale,\n                              (un.x *\
    \ vsq - vn.x * usq) / determinant * scale)\n        let center = a + offset\n\
    \        initCircle(center, max(mecLength(a - center), max(mecLength(b - center),\
    \ mecLength(c - center))))\n\n    proc mecFloatRun[T: SomeFloat](points: openArray[Point[T]],\
    \ seed: int64 = 0, tolerance: float = 1e-12): Circle[float] =\n        ## float\u70B9\
    \u96C6\u5408\u306E\u6700\u5C0F\u5305\u542B\u5186\u3092\u8A31\u5BB9\u8AA4\u5DEE\
    \u4ED8\u304D\u5897\u5206\u6CD5\u3067\u6C42\u3081\u308B\u3002\n        if tolerance\
    \ != tolerance or tolerance < 0 or tolerance >= 1:\n            raise newException(ValueError,\
    \ \"\u76F8\u5BFE\u8A31\u5BB9\u8AA4\u5DEE\u306F0\u4EE5\u4E0A1\u672A\u6E80\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\")\n        if points.len\
    \ == 0: raise newException(ValueError, \"\u6700\u5C0F\u5305\u542B\u5186\u306E\u5165\
    \u529B\u306F\u975E\u7A7A\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\")\n        var original = newSeq[Point[float]](points.len)\n        for\
    \ i, p in points:\n            original[i] = initPoint(float(p.x), float(p.y))\n\
    \            discard initCircle(original[i], 0)\n        let origin = original[0]\n\
    \        var scale = 0.0\n        for p in original: scale = max(scale, mecLength(p\
    \ - origin))\n        if scale == 0: return initCircle(origin, 0)\n        var\
    \ shuffled = newSeq[Point[float]](points.len)\n        for i, p in original:\n\
    \            let v = p - origin\n            shuffled[i] = initPoint(v.x / scale,\
    \ v.y / scale)\n        var rng = initRand(seed)\n        rng.shuffle(shuffled)\n\
    \        var circle = initCircle(shuffled[0], 0)\n        for i, p in shuffled:\n\
    \            if circle.contains(p, tolerance): continue\n            circle =\
    \ initCircle(p, 0)\n            for j in 0..<i:\n                let q = shuffled[j]\n\
    \                if circle.contains(q, tolerance): continue\n                circle\
    \ = mecDiameter(p, q)\n                for k in 0..<j:\n                    let\
    \ r = shuffled[k]\n                    if not circle.contains(r, tolerance): circle\
    \ = mecThree(p, q, r)\n        let center = origin + circle.center * scale\n \
    \       var radius = 0.0\n        for p in original: radius = max(radius, mecLength(p\
    \ - center))\n        initCircle(center, radius)\n\n    proc mecExactRadiusLess[T](a,\
    \ b: Circle[T]): bool =\n        ## \u53B3\u5BC6\u306A\u534A\u5F84\u4E8C\u4E57\
    \u306E\u5927\u5C0F\u3092\u6307\u5B9A\u3055\u308C\u305F\u57FA\u5E95\u578B\u306E\
    \u4EA4\u5DEE\u7A4D\u3067\u6BD4\u8F03\u3059\u308B\u3002\n        mixin `*`, `<`\n\
    \        let x = a.radius_squared_exact\n        let y = b.radius_squared_exact\n\
    \        x.num * y.den < y.num * x.den\n\n    proc mecExactThree[T](a, b, c: Point[T]):\
    \ Circle[T] =\n        ## 3\u5883\u754C\u70B9\u306E\u5916\u63A5\u5186\u3092\u8FD4\
    \u3059\u3002\u5171\u7DDA\u6642\u306F\u6700\u9060\u70B9\u5BFE\u306E\u76F4\u5F84\
    \u5186\u3092\u8FD4\u3059\u3002\n        try:\n            return initCircle(a,\
    \ b, c)\n        except ValueError:\n            result = initDiameterCircle(a,\
    \ b)\n            for candidate in [initDiameterCircle(a, c), initDiameterCircle(b,\
    \ c)]:\n                if mecExactRadiusLess(result, candidate): result = candidate\n\
    \n    proc mecExactRun[T](points: openArray[Point[T]], seed: int64): Circle[T]\
    \ =\n        ## \u6307\u5B9A\u5EA7\u6A19\u578B\u306E\u70B9\u96C6\u5408\u306E\u6700\
    \u5C0F\u5305\u542B\u5186\u3092\u5897\u5206\u6CD5\u3067\u53B3\u5BC6\u306B\u6C42\
    \u3081\u308B\u3002\n        if points.len == 0: raise newException(ValueError,\
    \ \"\u6700\u5C0F\u5305\u542B\u5186\u306E\u5165\u529B\u306F\u975E\u7A7A\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\")\n        var shuffled = newSeq[Point[T]](points.len)\n\
    \        for i, p in points: shuffled[i] = p\n        var rng = initRand(seed)\n\
    \        rng.shuffle(shuffled)\n        var circle = initCircle(shuffled[0], shuffled[0],\
    \ shuffled[0])\n        for i, p in shuffled:\n            if circle.contains(p):\
    \ continue\n            circle = initCircle(p, p, p)\n            for j in 0..<i:\n\
    \                let q = shuffled[j]\n                if circle.contains(q): continue\n\
    \                circle = initDiameterCircle(p, q)\n                for k in 0..<j:\n\
    \                    let r = shuffled[k]\n                    if not circle.contains(r):\
    \ circle = mecExactThree(p, q, r)\n        circle\n\n    proc minimum_enclosing_circle*[T](points:\
    \ openArray[Point[T]], seed: int64 = 0, tolerance: float = 1e-12): auto =\n  \
    \      ## \u70B9\u96C6\u5408\u306E\u6700\u5C0F\u5305\u542B\u5186\u3092\u76F4\u63A5\
    \u8FD4\u3059\u3002\u7A7A\u5165\u529B\u306FValueError\u3001float\u4EE5\u5916\u306E\
    \u5168\u5224\u5B9A\u306F\u53B3\u5BC6\u3002\n        when T is SomeFloat: mecFloatRun(points,\
    \ seed, tolerance)\n        else: mecExactRun(points, seed)\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/geometry/circle.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/geometry/circle_integer_impl.nim
  isVerificationFile: false
  path: cplib/geometry/minimum_enclosing_circle.nim
  requiredBy:
  - verify/geometry/minimum_enclosing_circle_abc151f_test_.nim
  - verify/geometry/minimum_enclosing_circle_abc151f_test_.nim
  - verify/geometry/minimum_enclosing_circle_exact_abc151f_test_.nim
  - verify/geometry/minimum_enclosing_circle_exact_abc151f_test_.nim
  - verify/AI/exact_circle_oracle_driver.nim
  - verify/AI/exact_circle_oracle_driver.nim
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/exact_circle_import_test.nim
  - verify/AI/exact_circle_import_test.nim
  - verify/AI/minimum_enclosing_circle_exact_test.nim
  - verify/AI/minimum_enclosing_circle_exact_test.nim
  - verify/AI/circle_generic_type_test.nim
  - verify/AI/circle_generic_type_test.nim
  - verify/AI/exact_circle_type_test.nim
  - verify/AI/exact_circle_type_test.nim
  - verify/AI/minimum_enclosing_circle_test.nim
  - verify/AI/minimum_enclosing_circle_test.nim
documentation_of: cplib/geometry/minimum_enclosing_circle.nim
layout: document
redirect_from:
- /library/cplib/geometry/minimum_enclosing_circle.nim
- /library/cplib/geometry/minimum_enclosing_circle.nim.html
title: cplib/geometry/minimum_enclosing_circle.nim
---
