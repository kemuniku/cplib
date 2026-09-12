---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/convex_hull_trick_impl.nim
    title: cplib/collections/private/convex_hull_trick_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/convex_hull_trick_impl.nim
    title: cplib/collections/private/convex_hull_trick_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/convex_hull_trick_test.nim
    title: verify/collections/convex_hull_trick_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/convex_hull_trick_test.nim
    title: verify/collections/convex_hull_trick_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_CONVEX_HULL_TRICK_MONOTONE_SLOPE:\n \
    \   const CPLIB_COLLECTIONS_CONVEX_HULL_TRICK_MONOTONE_SLOPE* = 1\n    import\
    \ deques\n    import cplib/math/int128\n    import cplib/collections/private/convex_hull_trick_impl\n\
    \n    type ConvexHullTrickMonotoneSlope* = object\n        hull: CHTMonotoneHull\n\
    \n    proc initConvexHullTrickMonotoneSlope*(slopeIncreasing: bool = false): ConvexHullTrickMonotoneSlope\
    \ =\n        ## \u50BE\u304D\u304C\u5358\u8ABF\u306A\u6700\u5C0F\u5024CHT\u3092\
    \u521D\u671F\u5316\u3057\u307E\u3059\u3002\u65E2\u5B9A\u306F\u5E83\u7FA9\u5358\
    \u8ABF\u6E1B\u5C11\u3002O(1)\u3002\n        result.hull = initCHTMonotoneHull(slopeIncreasing)\n\
    \n    proc add_line*(self: var ConvexHullTrickMonotoneSlope, a, b: int) =\n  \
    \      ## ax+b\u3092\u8FFD\u52A0\u3057\u307E\u3059\u3002\u50BE\u304D\u306F\u6307\
    \u5B9A\u3057\u305F\u5411\u304D\u306B\u5358\u8ABF\u3067\u3042\u308B\u5FC5\u8981\
    \u304C\u3042\u308A\u307E\u3059\u3002\u511F\u5374O(1)\u3002\n        self.hull.chtAddLine(a,\
    \ b)\n\n    proc get_min*(self: ConvexHullTrickMonotoneSlope, x: int): int =\n\
    \        ## \u4EFB\u610F\u306E\u6574\u6570\u5EA7\u6A19x\u3067\u306E\u6700\u5C0F\
    \u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u306E\u5834\u5408\u306Fassert\u3002\
    O(log N)\u3002\n        assert self.hull.lines.len > 0, \"CHT: no lines\"\n  \
    \      var l = 0\n        var r = self.hull.lines.len - 1\n        while l < r:\n\
    \            let m = l + (r - l) div 2\n            if chtValue(self.hull.lines[m],\
    \ x) >= chtValue(self.hull.lines[m + 1], x):\n                l = m + 1\n    \
    \        else:\n                r = m\n        chtAnswer(chtValue(self.hull.lines[l],\
    \ x))\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/collections/private/convex_hull_trick_impl.nim
  - cplib/math/int128.nim
  - cplib/collections/private/convex_hull_trick_impl.nim
  isVerificationFile: false
  path: cplib/collections/convex_hull_trick_monotone_slope.nim
  requiredBy: []
  timestamp: '2026-09-12 10:51:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/convex_hull_trick_test.nim
  - verify/collections/convex_hull_trick_test.nim
documentation_of: cplib/collections/convex_hull_trick_monotone_slope.nim
layout: document
redirect_from:
- /library/cplib/collections/convex_hull_trick_monotone_slope.nim
- /library/cplib/collections/convex_hull_trick_monotone_slope.nim.html
title: cplib/collections/convex_hull_trick_monotone_slope.nim
---
