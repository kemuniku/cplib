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
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_4/half_plane_intersection_cgl4c_test.nim
    title: verify/geometry/CGL_4/half_plane_intersection_cgl4c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_4/half_plane_intersection_cgl4c_test.nim
    title: verify/geometry/CGL_4/half_plane_intersection_cgl4c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/half_plane_intersection_test.nim
    title: verify/geometry/half_plane_intersection_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/half_plane_intersection_test.nim
    title: verify/geometry/half_plane_intersection_test.nim
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
  code: "when not declared CPLIB_GEOMETRY_HALF_PLANE_INTERSECTION:\n    const CPLIB_GEOMETRY_HALF_PLANE_INTERSECTION*\
    \ = 1\n    import cplib/geometry/base\n    import cplib/math/fractions\n    import\
    \ algorithm, math\n\n    type\n        HalfPlaneIntersectionKind* = enum\n   \
    \         hpiEmpty, hpiBounded, hpiUnbounded\n        HalfPlaneIntersection*[T]\
    \ = object\n            kind*: HalfPlaneIntersectionKind\n            dimension*:\
    \ int\n            vertices*: seq[Point[T]]\n            constraints*: seq[Line[T]]\n\
    \        HpiFunction[T] = object\n            slope, intercept: T\n        HpiBound[T]\
    \ = object\n            infinity: int\n            value: T\n        HpiEnvelope[T]\
    \ = object\n            functions: seq[HpiFunction[T]]\n            starts: seq[HpiBound[T]]\n\
    \n    proc hpiZero[T](): T =\n        ## \u5EA7\u6A19\u578B\u306E\u96F6\u3092\u8FD4\
    \u3059\u3002\n        when T is Fraction: initFraction(typeof(default(T).num)(0))\n\
    \        else: T(0)\n\n    proc hpiChecked[T](x: T): T =\n        ## \u6709\u9650\
    \u5024\u3068\u6B63\u306E\u5206\u6BCD\u3092\u78BA\u8A8D\u3059\u308B\u3002\n   \
    \     when T is SomeFloat:\n            if classify(x) in {fcNan, fcInf, fcNegInf}:\n\
    \                raise newException(ValueError, \"\u534A\u5E73\u9762\u4EA4\u5DEE\
    \u306E\u5024\u304C\u6709\u9650\u5024\u3067\u306F\u3042\u308A\u307E\u305B\u3093\
    \")\n        else:\n            if x.den <= 0:\n                raise newException(ValueError,\
    \ \"\u534A\u5E73\u9762\u4EA4\u5DEE\u306B\u306F\u6B63\u306E\u5206\u6BCD\u306E\u6709\
    \u9650\u5206\u6570\u304C\u5FC5\u8981\u3067\u3059\")\n        x\n\n    proc hpiBound[T](x:\
    \ T): HpiBound[T] =\n        ## \u6709\u9650\u306E\u533A\u9593\u7AEF\u3092\u4F5C\
    \u308B\u3002\n        HpiBound[T](value: hpiChecked(x))\n    proc hpiCmp[T](a,\
    \ b: HpiBound[T]): int =\n        ## \u7121\u9650\u7AEF\u3092\u542B\u3080\u533A\
    \u9593\u7AEF\u3092\u6BD4\u8F03\u3059\u308B\u3002\n        if a.infinity != b.infinity:\
    \ cmp(a.infinity, b.infinity)\n        elif a.infinity != 0: 0\n        else:\
    \ cmp(a.value, b.value)\n    proc hpiMin[T](a, b: HpiBound[T]): HpiBound[T] =\n\
    \        ## \u5C0F\u3055\u3044\u533A\u9593\u7AEF\u3092\u8FD4\u3059\u3002\n   \
    \     if hpiCmp(a, b) <= 0: a else: b\n    proc hpiMax[T](a, b: HpiBound[T]):\
    \ HpiBound[T] =\n        ## \u5927\u304D\u3044\u533A\u9593\u7AEF\u3092\u8FD4\u3059\
    \u3002\n        if hpiCmp(a, b) >= 0: a else: b\n\n    proc hpiEnvelope[T](lines:\
    \ seq[HpiFunction[T]]): HpiEnvelope[T] =\n        ## \u4E00\u6B21\u95A2\u6570\u7FA4\
    \u306E\u4E0A\u5305\u7D61\u7DDA\u3092\u69CB\u7BC9\u3059\u308B\u3002O(N log N) \u6F14\
    \u7B97\u3002\n        var sorted = lines\n        sorted.sort(proc(a, b: HpiFunction[T]):\
    \ int =\n            if a.slope != b.slope: cmp(a.slope, b.slope)\n          \
    \  else: cmp(a.intercept, b.intercept))\n        for line in sorted:\n       \
    \     if result.functions.len > 0 and result.functions[^1].slope == line.slope:\n\
    \                discard result.functions.pop()\n                discard result.starts.pop()\n\
    \            var start = HpiBound[T](infinity: -1)\n            while result.functions.len\
    \ > 0:\n                let last = result.functions[^1]\n                start\
    \ = hpiBound((last.intercept - line.intercept) /\n                    (line.slope\
    \ - last.slope))\n                if hpiCmp(start, result.starts[^1]) > 0: break\n\
    \                discard result.functions.pop()\n                discard result.starts.pop()\n\
    \            if result.functions.len == 0: start = HpiBound[T](infinity: -1)\n\
    \            result.functions.add(line)\n            result.starts.add(start)\n\
    \n    proc hpiValue[T](e: HpiEnvelope[T], x: T): T =\n        ## \u5305\u7D61\u7DDA\
    \u306E\u5024\u3092\u4E8C\u5206\u63A2\u7D22\u3067\u6C42\u3081\u308B\u3002O(log\
    \ N) \u6F14\u7B97\u3002\n        var lo = 0\n        var hi = e.starts.len\n \
    \       let bound = hpiBound(x)\n        while hi - lo > 1:\n            let mid\
    \ = (lo + hi) div 2\n            if hpiCmp(e.starts[mid], bound) <= 0: lo = mid\n\
    \            else: hi = mid\n        hpiChecked(e.functions[lo].slope * x + e.functions[lo].intercept)\n\
    \n    proc half_plane_intersection*[T](lines: openArray[Line[T]]): HalfPlaneIntersection[T]\
    \ =\n        ## \u6709\u5411\u76F4\u7DDA\u306E\u5DE6\u9589\u534A\u5E73\u9762\u306E\
    \u5171\u901A\u90E8\u5206\u3002O(N log N) \u6F14\u7B97\u3001O(N) \u7A7A\u9593\u3002\
    \n        ## T \u306F\u6D6E\u52D5\u5C0F\u6570\u70B9\u578B\u307E\u305F\u306F Fraction\u3002\
    \u5206\u6570\u306E\u5206\u6BCD\u306F\u6B63\u3067\u3001\n        ## \u4E2D\u9593\
    \u6574\u6570\u6F14\u7B97\u306F\u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\u3057\
    \u306A\u3044\u3053\u3068\u3002\n        ## vertices \u306F\u6709\u9650\u306E\u6975\
    \u70B9\u306E\u307F\u3002\u9762\u306A\u3089\u4E0B\u5074\u3092 x \u6607\u9806\u3001\
    \u4E0A\u5074\u3092 x \u964D\u9806\u306B\u4E26\u3079\u3001\n        ## \u6709\u754C\
    \u306A\u3089\u53CD\u6642\u8A08\u56DE\u308A\u3002\u975E\u6709\u754C\u9818\u57DF\
    \u306E\u5168\u4F53\u306F constraints \u3067\u8868\u3059\u3002\n        ## dimension\
    \ \u306F\u7A7A=-1\u3001\u70B9=0\u3001\u7DDA\u5206\u30FB\u534A\u76F4\u7DDA\u30FB\
    \u76F4\u7DDA=1\u3001\u9762=2\u3002\n        ## \u5236\u7D04\u306A\u3057\u306F\u5168\
    \u5E73\u9762\u3002\u5165\u529B\u306F\u6709\u9650\u5EA7\u6A19\u304B\u3064\u7570\
    \u306A\u308B\u7AEF\u70B9\u3002\u975E\u6709\u9650\u5024\u306F ValueError\u3002\n\
    \        ## float \u306F EPS \u3092\u4F7F\u308F\u305A\u6BD4\u8F03\u3057\u3001\u4E38\
    \u3081\u306B\u3088\u308B\u9000\u5316\u30FB\u5E73\u884C\u30FB\u8FD1\u63A5\u306E\
    \u8AA4\u5206\u985E\u3092\u9632\u3052\u306A\u3044\u3002\n        ## \u53B3\u5BC6\
    \u306A\u9000\u5316\u5206\u985E\u304C\u5FC5\u8981\u306A\u5834\u5408\u306F Fraction\
    \ \u3092\u4F7F\u3046\u3002\u5168\u4F53\u306E GEOMETRY_EPS \u306F\u53C2\u7167\u3057\
    \u306A\u3044\u3002\n        when T isnot SomeFloat and T isnot Fraction:\n   \
    \         {.error: \"half_plane_intersection requires floating point or Fraction\
    \ coordinates\".}\n        let zero = hpiZero[T]()\n        let negativeInfinity\
    \ = HpiBound[T](infinity: -1)\n        let positiveInfinity = HpiBound[T](infinity:\
    \ 1)\n        result.kind = hpiEmpty\n        result.dimension = -1\n        result.constraints\
    \ = @lines\n        var lowerLines, negativeUpperLines: seq[HpiFunction[T]]\n\
    \        var xmin = negativeInfinity\n        var xmax = positiveInfinity\n  \
    \      for line in lines:\n            for coordinate in [line.s.x, line.s.y,\
    \ line.t.x, line.t.y]:\n                discard hpiChecked(coordinate)\n     \
    \       let dx = hpiChecked(line.t.x - line.s.x)\n            let dy = hpiChecked(line.t.y\
    \ - line.s.y)\n            if dx == zero and dy == zero:\n                raise\
    \ newException(ValueError, \"\u534A\u5E73\u9762\u306E\u7AEF\u70B9\u306F\u7570\u306A\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\")\n            if dx == zero:\n\
    \                if dy > zero: xmax = hpiMin(xmax, hpiBound(line.s.x))\n     \
    \           else: xmin = hpiMax(xmin, hpiBound(line.s.x))\n            else:\n\
    \                let slope = hpiChecked(dy / dx)\n                let intercept\
    \ = hpiChecked(hpiChecked(dx * line.s.y - dy * line.s.x) / dx)\n             \
    \   if dx > zero:\n                    lowerLines.add(HpiFunction[T](slope: slope,\
    \ intercept: intercept))\n                else:\n                    negativeUpperLines.add(HpiFunction[T](slope:\
    \ -slope, intercept: -intercept))\n        let lower = hpiEnvelope(lowerLines)\n\
    \        let upper = hpiEnvelope(negativeUpperLines)\n        if hpiCmp(xmin,\
    \ xmax) > 0: return\n        var left = xmin\n        var right = xmax\n     \
    \   var hasArea = false\n        var leftMeet, rightMeet: bool\n        if lower.functions.len\
    \ > 0 and upper.functions.len > 0:\n            left = positiveInfinity\n    \
    \        right = negativeInfinity\n            var i = 0\n            var j =\
    \ 0\n            var start = negativeInfinity\n            while true:\n     \
    \           let nextLower = if i + 1 < lower.starts.len: lower.starts[i+1] else:\
    \ positiveInfinity\n                let nextUpper = if j + 1 < upper.starts.len:\
    \ upper.starts[j+1] else: positiveInfinity\n                let finish = hpiMin(nextLower,\
    \ nextUpper)\n                var a = hpiMax(start, xmin)\n                var\
    \ b = hpiMin(finish, xmax)\n                let slope = hpiChecked(lower.functions[i].slope\
    \ + upper.functions[j].slope)\n                let intercept = hpiChecked(lower.functions[i].intercept\
    \ + upper.functions[j].intercept)\n                var root = positiveInfinity\n\
    \                if slope != zero: root = hpiBound(-intercept / slope)\n     \
    \           if slope > zero: b = hpiMin(b, root)\n                elif slope <\
    \ zero: a = hpiMax(a, root)\n                elif intercept > zero: a = positiveInfinity;\
    \ b = negativeInfinity\n                if hpiCmp(a, b) <= 0:\n              \
    \      let aMeet = (slope == zero and intercept == zero) or\n                \
    \        (slope != zero and hpiCmp(a, root) == 0)\n                    let bMeet\
    \ = (slope == zero and intercept == zero) or\n                        (slope !=\
    \ zero and hpiCmp(b, root) == 0)\n                    if hpiCmp(a, left) < 0:\
    \ leftMeet = aMeet\n                    elif hpiCmp(a, left) == 0: leftMeet =\
    \ leftMeet or aMeet\n                    if hpiCmp(b, right) > 0: rightMeet =\
    \ bMeet\n                    elif hpiCmp(b, right) == 0: rightMeet = rightMeet\
    \ or bMeet\n                    left = hpiMin(left, a)\n                    right\
    \ = hpiMax(right, b)\n                    if hpiCmp(a, b) < 0 and (slope != zero\
    \ or intercept < zero): hasArea = true\n                if finish.infinity ==\
    \ 1: break\n                if hpiCmp(nextLower, finish) == 0: inc i\n       \
    \         if hpiCmp(nextUpper, finish) == 0: inc j\n                start = finish\n\
    \            if hpiCmp(left, right) > 0: return\n        elif hpiCmp(left, right)\
    \ < 0:\n            hasArea = true\n        result.kind = if left.infinity ==\
    \ 0 and right.infinity == 0 and\n            lower.functions.len > 0 and upper.functions.len\
    \ > 0: hpiBounded else: hpiUnbounded\n        if hpiCmp(left, right) == 0:\n \
    \           if lower.functions.len > 0 and upper.functions.len > 0:\n        \
    \        result.dimension = if leftMeet or rightMeet: 0 else: 1\n            else:\
    \ result.dimension = 1\n        else:\n            result.dimension = if hasArea:\
    \ 2 else: 1\n        var bottom, top: seq[Point[T]]\n        if lower.functions.len\
    \ > 0:\n            if left.infinity == 0: bottom.add(Point[T](x: left.value,\
    \ y: hpiValue(lower, left.value)))\n            for k in 1..<lower.starts.len:\n\
    \                let x = lower.starts[k]\n                if hpiCmp(left, x) <\
    \ 0 and hpiCmp(x, right) < 0:\n                    bottom.add(Point[T](x: x.value,\
    \ y: hpiValue(lower, x.value)))\n            if right.infinity == 0 and hpiCmp(left,\
    \ right) != 0:\n                bottom.add(Point[T](x: right.value, y: hpiValue(lower,\
    \ right.value)))\n        if upper.functions.len > 0:\n            if right.infinity\
    \ == 0:\n                let y = if rightMeet: hpiValue(lower, right.value) else:\
    \ -hpiValue(upper, right.value)\n                top.add(Point[T](x: right.value,\
    \ y: y))\n            for k in countdown(upper.starts.len-1, 1):\n           \
    \     let x = upper.starts[k]\n                if hpiCmp(left, x) < 0 and hpiCmp(x,\
    \ right) < 0:\n                    top.add(Point[T](x: x.value, y: -hpiValue(upper,\
    \ x.value)))\n            if left.infinity == 0 and hpiCmp(left, right) != 0:\n\
    \                let y = if leftMeet: hpiValue(lower, left.value) else: -hpiValue(upper,\
    \ left.value)\n                top.add(Point[T](x: left.value, y: y))\n      \
    \  for chain in [bottom, top]:\n            for p in chain:\n                if\
    \ result.vertices.len == 0 or result.vertices[^1].x != p.x or result.vertices[^1].y\
    \ != p.y:\n                    result.vertices.add(p)\n        if result.vertices.len\
    \ > 1 and result.vertices[0].x == result.vertices[^1].x and\n            result.vertices[0].y\
    \ == result.vertices[^1].y:\n            discard result.vertices.pop()\n\n   \
    \ proc contains*[T](region: HalfPlaneIntersection[T], p: Point[T]): bool =\n \
    \       ## \u4FDD\u6301\u3057\u305F\u5DE6\u9589\u534A\u5E73\u9762\u3092\u3059\u3079\
    \u3066\u6E80\u305F\u3059\u304B\u3092\u5224\u5B9A\u3002O(N) \u6F14\u7B97\u3002\n\
    \        discard hpiChecked(p.x)\n        discard hpiChecked(p.y)\n        if\
    \ region.kind == hpiEmpty: return false\n        let zero = hpiZero[T]()\n   \
    \     for line in region.constraints:\n            let dx = hpiChecked(line.t.x\
    \ - line.s.x)\n            let dy = hpiChecked(line.t.y - line.s.y)\n        \
    \    let side = hpiChecked(dx * (p.y - line.s.y) - dy * (p.x - line.s.x))\n  \
    \          if side < zero: return false\n        true\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  isVerificationFile: false
  path: cplib/geometry/half_plane_intersection.nim
  requiredBy: []
  timestamp: '2026-11-16 00:30:02+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/CGL_4/half_plane_intersection_cgl4c_test.nim
  - verify/geometry/CGL_4/half_plane_intersection_cgl4c_test.nim
  - verify/geometry/half_plane_intersection_test.nim
  - verify/geometry/half_plane_intersection_test.nim
documentation_of: cplib/geometry/half_plane_intersection.nim
layout: document
redirect_from:
- /library/cplib/geometry/half_plane_intersection.nim
- /library/cplib/geometry/half_plane_intersection.nim.html
title: cplib/geometry/half_plane_intersection.nim
---
