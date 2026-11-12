---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/closest_pair_test.nim
    title: verify/AI/closest_pair_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/closest_pair_test.nim
    title: verify/AI/closest_pair_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_5/closest_pair_cgl5a_test.nim
    title: verify/geometry/CGL_5/closest_pair_cgl5a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_5/closest_pair_cgl5a_test.nim
    title: verify/geometry/CGL_5/closest_pair_cgl5a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/closest_pair_test.nim
    title: verify/geometry/closest_pair_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/closest_pair_test.nim
    title: verify/geometry/closest_pair_test.nim
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
  code: "when not declared CPLIB_GEOMETRY_CLOSEST_PAIR:\n    const CPLIB_GEOMETRY_CLOSEST_PAIR*\
    \ = 1\n    import algorithm, math, options\n    import cplib/geometry/base\n\n\
    \    type ClosestPairResult*[T] = object\n        distanceSquared*: T\n      \
    \  indices*: (int, int)\n\n    proc closestPairImpl[T](inputSites: seq[tuple[x,\
    \ y: T, id: int]]): Option[ClosestPairResult[T]] =\n        ## \u5EA7\u6A19\u3092\
    \u901A\u5E38\u6BD4\u8F03\u3067\u6574\u5217\u3057\u3001\u5206\u5272\u7D71\u6CBB\
    \u3067\u6700\u8FD1\u70B9\u5BFE\u3092\u6C42\u3081\u308B\u3002O(N log N)\u6642\u9593\
    \u3001O(N)\u9818\u57DF\u3002\n        var sites = inputSites\n        if sites.len\
    \ < 2:\n            return none(ClosestPairResult[T])\n        sites.sort()\n\
    \        var scratch = newSeq[tuple[x, y: T, id: int]](sites.len)\n\n        proc\
    \ cmpY(a, b: tuple[x, y: T, id: int]): int =\n            ## y\u3001x\u3001\u5143\
    \u306E\u6DFB\u5B57\u306E\u9806\u306B\u3001EPS\u3092\u4F7F\u308F\u305A\u6BD4\u8F03\
    \u3059\u308B\u3002\n            if a.y != b.y: cmp(a.y, b.y)\n            elif\
    \ a.x != b.x: cmp(a.x, b.x)\n            else: cmp(a.id, b.id)\n\n        when\
    \ T is SomeFloat:\n            for i, p in sites:\n                scratch[i]\
    \ = p\n            scratch.sort(cmpY)\n            let dx = sites[^1].x - sites[0].x\n\
    \            let dy = scratch[^1].y - scratch[0].y\n            if classify(dx\
    \ * dx + dy * dy) in {fcInf, fcNegInf, fcNan}:\n                raise newException(ValueError,\
    \ \"\u5EA7\u6A19\u7BC4\u56F2\u306E\u5BFE\u89D2\u7DDA\u306E\u4E8C\u4E57\u8DDD\u96E2\
    \u304C\u6709\u9650\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \")\n            for i in 1..<sites.len:\n                let gapX = sites[i].x\
    \ - sites[i - 1].x\n                let gapY = scratch[i].y - scratch[i - 1].y\n\
    \                if (gapX != 0 and gapX * gapX == 0) or (gapY != 0 and gapY *\
    \ gapY == 0):\n                    raise newException(ValueError, \"\u975E\u96F6\
    \u306E\u5EA7\u6A19\u5DEE\u306E\u4E8C\u4E57\u304C0\u306Bunderflow\u3057\u3066\u306F\
    \u3044\u3051\u307E\u305B\u3093\")\n\n        for i in 1..<sites.len:\n       \
    \     if sites[i - 1].x == sites[i].x and sites[i - 1].y == sites[i].y:\n    \
    \            let a = sites[i - 1].id\n                let b = sites[i].id\n  \
    \              return some(ClosestPairResult[T](distanceSquared: T(0), indices:\
    \ (min(a, b), max(a, b))))\n\n        var best = ClosestPairResult[T]()\n    \
    \    let initialDx = sites[0].x - sites[1].x\n        let initialDy = sites[0].y\
    \ - sites[1].y\n        best.distanceSquared = initialDx * initialDx + initialDy\
    \ * initialDy\n        best.indices = (min(sites[0].id, sites[1].id), max(sites[0].id,\
    \ sites[1].id))\n\n        proc consider(a, b: tuple[x, y: T, id: int]) =\n  \
    \          ## \u53B3\u5BC6\u306B\u5C0F\u3055\u3044\u4E8C\u4E57\u8DDD\u96E2\u304C\
    \u898B\u3064\u304B\u308C\u3070\u3001\u5143\u306E\u6DFB\u5B57\u3068\u3068\u3082\
    \u306B\u66F4\u65B0\u3059\u308B\u3002\n            let dx = a.x - b.x\n       \
    \     let dy = a.y - b.y\n            let distanceSquared = dx * dx + dy * dy\n\
    \            if distanceSquared < best.distanceSquared:\n                best\
    \ = ClosestPairResult[T](distanceSquared: distanceSquared,\n                 \
    \   indices: (min(a.id, b.id), max(a.id, b.id)))\n\n        proc solve(first,\
    \ last: int) =\n            ## x\u9806\u306E\u534A\u958B\u533A\u9593\u3092\u51E6\
    \u7406\u3057\u3001y\u9806\u306B\u3057\u3066\u8FD4\u3059\u3002\u30DE\u30FC\u30B8\
    \u3068\u5E2F\u306E\u8D70\u67FB\u306FO(M)\u6642\u9593\u3002\n            if last\
    \ - first <= 3:\n                for i in first..<last:\n                    for\
    \ j in i + 1..<last:\n                        consider(sites[i], sites[j])\n \
    \               for i in first + 1..<last:\n                    var j = i\n  \
    \                  while j > first and cmpY(sites[j], sites[j - 1]) < 0:\n   \
    \                     swap(sites[j], sites[j - 1])\n                        dec\
    \ j\n                return\n            let middle = first + (last - first) div\
    \ 2\n            let splitX = sites[middle].x\n            solve(first, middle)\n\
    \            solve(middle, last)\n            var left = first\n            var\
    \ right = middle\n            for i in first..<last:\n                if left\
    \ < middle and (right == last or cmpY(sites[left], sites[right]) <= 0):\n    \
    \                scratch[i] = sites[left]\n                    inc left\n    \
    \            else:\n                    scratch[i] = sites[right]\n          \
    \          inc right\n            for i in first..<last:\n                sites[i]\
    \ = scratch[i]\n            var count = 0\n            for i in first..<last:\n\
    \                let p = sites[i]\n                let dx = p.x - splitX\n   \
    \             if dx * dx >= best.distanceSquared:\n                    continue\n\
    \                var j = count - 1\n                while j >= 0:\n          \
    \          let dy = p.y - scratch[first + j].y\n                    if dy * dy\
    \ >= best.distanceSquared:\n                        break\n                  \
    \  consider(p, scratch[first + j])\n                    dec j\n              \
    \  scratch[first + count] = p\n                inc count\n\n        solve(0, sites.len)\n\
    \        some(best)\n\n    proc closest_pair*[T: SomeSignedInt](points: openArray[Point[T]]):\
    \ Option[ClosestPairResult[int64]] =\n        ## \u6700\u8FD1\u70B9\u5BFE\u306E\
    \u4E8C\u4E57\u8DDD\u96E2\u3068\u5143\u306E\u6DFB\u5B57\u5BFE(i < j)\u3092\u8FD4\
    \u3059\u3002O(N log N)\u6642\u9593\u3001O(N)\u9818\u57DF\u3002\u5165\u529B\u306F\
    \u5909\u66F4\u3057\u306A\u3044\u3002\n        ## N < 2\u306A\u3089none\u3001\u91CD\
    \u8907\u70B9\u306A\u3089\u8DDD\u96E20\u3001\u540C\u8DDD\u96E2\u306F\u4EFB\u610F\
    \u306E1\u7D44\u3002\u7B26\u53F7\u4ED8\u304D\u6574\u6570\u3092int64\u3067\u53B3\
    \u5BC6\u306B\u8A08\u7B97\u3059\u308B\u3002\n        ## \u5404\u8EF8\u306E\u6700\
    \u5927\u5024\u3068\u6700\u5C0F\u5024\u306E\u5DEE\u306F2*10^9\u4EE5\u4E0B\uFF08\
    \u7D76\u5BFE\u5024\u306F\u4E0D\u554F\uFF09\u3002\u5236\u7D04\u9055\u53CD\u306F\
    ValueError\u3002\n        ## \u4E8C\u4E57\u8DDD\u96E2\u306F\u6700\u59278*10^18\u3067\
    int64\u306B\u53CE\u307E\u308A\u3001\u6574\u6570\u3092float\u3078\u5909\u63DB\u3057\
    \u306A\u3044\u3002\n        var sites = newSeq[tuple[x, y: int64, id: int]](points.len)\n\
    \        var minX, maxX, minY, maxY: int64\n        for i, p in points:\n    \
    \        let x = int64(p.x)\n            let y = int64(p.y)\n            sites[i]\
    \ = (x, y, i)\n            if i == 0:\n                minX = x\n            \
    \    maxX = x\n                minY = y\n                maxY = y\n          \
    \  else:\n                minX = min(minX, x)\n                maxX = max(maxX,\
    \ x)\n                minY = min(minY, y)\n                maxY = max(maxY, y)\n\
    \        const span = 2_000_000_000'i64\n        if (minX <= high(int64) - span\
    \ and maxX > minX + span) or\n                (minY <= high(int64) - span and\
    \ maxY > minY + span):\n            raise newException(ValueError, \"\u5404\u8EF8\
    \u306E\u5EA7\u6A19\u5E45\u306F2*10^9\u4EE5\u4E0B\u3067\u3042\u308B\u5FC5\u8981\
    \u304C\u3042\u308A\u307E\u3059\")\n        closestPairImpl(sites)\n\n    proc\
    \ closest_pair*[T: SomeFloat](points: openArray[Point[T]]): Option[ClosestPairResult[float64]]\
    \ =\n        ## \u6700\u8FD1\u70B9\u5BFE\u306E\u4E8C\u4E57\u8DDD\u96E2\u3068\u5143\
    \u306E\u6DFB\u5B57\u5BFE(i < j)\u3092\u8FD4\u3059\u3002O(N log N)\u6642\u9593\u3001\
    O(N)\u9818\u57DF\u3002\u5165\u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n\
    \        ## N < 2\u306A\u3089none\u3001\u91CD\u8907\u70B9\u306A\u3089\u8DDD\u96E2\
    0\u3001\u540C\u8DDD\u96E2\u306F\u4EFB\u610F\u306E1\u7D44\u3002float32\u3082float64\u3067\
    \u8A08\u7B97\u3059\u308B\u3002\n        ## \u5EA7\u6A19\u3068\u5EA7\u6A19\u7BC4\
    \u56F2\u306E\u5BFE\u89D2\u7DDA\u306E\u4E8C\u4E57\u8DDD\u96E2\u306F\u6709\u9650\
    \u3001\u975E\u96F6\u306E\u5EA7\u6A19\u5DEE\u306E\u4E8C\u4E57\u306F0\u3078\u306E\
    underflow\u4E0D\u53EF\u3002\n        ## \u5236\u7D04\u9055\u53CD\u306FValueError\u3002\
    EPS\u3092\u4F7F\u308F\u305A\u901A\u5E38\u306E\u6D6E\u52D5\u5C0F\u6570\u70B9\u4E38\
    \u3081\u3067\u6BD4\u8F03\u3059\u308B\u305F\u3081\u3001\u53B3\u5BC6\u306A\u5B9F\
    \u6570\u89E3\u306F\u4FDD\u8A3C\u3057\u306A\u3044\u3002\n        var sites = newSeq[tuple[x,\
    \ y: float64, id: int]](points.len)\n        for i, p in points:\n           \
    \ let x = float64(p.x)\n            let y = float64(p.y)\n            if classify(x)\
    \ in {fcInf, fcNegInf, fcNan} or classify(y) in {fcInf, fcNegInf, fcNan}:\n  \
    \              raise newException(ValueError, \"\u5EA7\u6A19\u306F\u6709\u9650\
    \u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\")\n            sites[i]\
    \ = (x, y, i)\n        closestPairImpl(sites)\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  isVerificationFile: false
  path: cplib/geometry/closest_pair.nim
  requiredBy: []
  timestamp: '2026-11-13 04:16:54+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/closest_pair_test.nim
  - verify/geometry/closest_pair_test.nim
  - verify/geometry/CGL_5/closest_pair_cgl5a_test.nim
  - verify/geometry/CGL_5/closest_pair_cgl5a_test.nim
  - verify/AI/closest_pair_test.nim
  - verify/AI/closest_pair_test.nim
documentation_of: cplib/geometry/closest_pair.nim
layout: document
redirect_from:
- /library/cplib/geometry/closest_pair.nim
- /library/cplib/geometry/closest_pair.nim.html
title: cplib/geometry/closest_pair.nim
---
