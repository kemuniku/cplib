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
  code: "when not declared CPLIB_COLLECTIONS_CONVEX_HULL_TRICK_MONOTONE:\n    const\
    \ CPLIB_COLLECTIONS_CONVEX_HULL_TRICK_MONOTONE* = 1\n    import deques\n    import\
    \ cplib/math/int128\n    import cplib/collections/private/convex_hull_trick_impl\n\
    \n    type ConvexHullTrickMonotone* = object\n        hull: CHTMonotoneHull\n\
    \        xIncreasing: bool\n        hasX: bool\n        lastX: int\n\n    proc\
    \ initConvexHullTrickMonotone*(slopeIncreasing: bool = false,\n              \
    \                      xIncreasing: bool = true): ConvexHullTrickMonotone =\n\
    \        ## \u50BE\u304D\u30FB\u30AF\u30A8\u30EA\u5EA7\u6A19\u304C\u5358\u8ABF\
    \u306A\u6700\u5C0F\u5024CHT\u3092\u521D\u671F\u5316\u3057\u307E\u3059\u3002O(1)\u3002\
    \n        result.hull = initCHTMonotoneHull(slopeIncreasing)\n        result.xIncreasing\
    \ = xIncreasing\n\n    proc add_line*(self: var ConvexHullTrickMonotone, a, b:\
    \ int) =\n        ## ax+b\u3092\u8FFD\u52A0\u3057\u307E\u3059\u3002\u50BE\u304D\
    \u306F\u6307\u5B9A\u3057\u305F\u5411\u304D\u306B\u5358\u8ABF\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\u511F\u5374O(1)\u3002\n     \
    \   self.hull.chtAddLine(a, b)\n\n    proc get_min*(self: var ConvexHullTrickMonotone,\
    \ x: int): int =\n        ## \u6307\u5B9A\u3057\u305F\u5411\u304D\u306B\u5358\u8ABF\
    \u306A\u6574\u6570\u5EA7\u6A19x\u3067\u306E\u6700\u5C0F\u5024\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\u7A7A\u306E\u5834\u5408\u306Fassert\u3002\u511F\u5374O(1)\u3002\
    \n        assert self.hull.lines.len > 0, \"CHT: no lines\"\n        if self.hasX:\n\
    \            assert (if self.xIncreasing: self.lastX <= x else: x <= self.lastX),\n\
    \                \"CHT: query coordinates must be monotone\"\n        self.hasX\
    \ = true\n        self.lastX = x\n        if self.xIncreasing:\n            while\
    \ self.hull.lines.len >= 2 and\n                    chtValue(self.hull.lines[0],\
    \ x) >= chtValue(self.hull.lines[1], x):\n                discard self.hull.lines.popFirst()\n\
    \            return chtAnswer(chtValue(self.hull.lines[0], x))\n        else:\n\
    \            while self.hull.lines.len >= 2 and\n                    chtValue(self.hull.lines[^1],\
    \ x) >= chtValue(self.hull.lines[^2], x):\n                discard self.hull.lines.popLast()\n\
    \            return chtAnswer(chtValue(self.hull.lines[^1], x))\n"
  dependsOn:
  - cplib/collections/private/convex_hull_trick_impl.nim
  - cplib/collections/private/convex_hull_trick_impl.nim
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  isVerificationFile: false
  path: cplib/collections/convex_hull_trick_monotone.nim
  requiredBy: []
  timestamp: '2026-09-12 10:51:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/convex_hull_trick_test.nim
  - verify/collections/convex_hull_trick_test.nim
documentation_of: cplib/collections/convex_hull_trick_monotone.nim
layout: document
redirect_from:
- /library/cplib/collections/convex_hull_trick_monotone.nim
- /library/cplib/collections/convex_hull_trick_monotone.nim.html
title: cplib/collections/convex_hull_trick_monotone.nim
---
