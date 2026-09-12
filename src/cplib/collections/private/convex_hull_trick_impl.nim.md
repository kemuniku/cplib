---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick.nim
    title: cplib/collections/convex_hull_trick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick.nim
    title: cplib/collections/convex_hull_trick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick_monotone.nim
    title: cplib/collections/convex_hull_trick_monotone.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick_monotone.nim
    title: cplib/collections/convex_hull_trick_monotone.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick_monotone_slope.nim
    title: cplib/collections/convex_hull_trick_monotone_slope.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick_monotone_slope.nim
    title: cplib/collections/convex_hull_trick_monotone_slope.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/convex_hull_trick_line_add_get_min_test.nim
    title: verify/collections/convex_hull_trick_line_add_get_min_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/convex_hull_trick_line_add_get_min_test.nim
    title: verify/collections/convex_hull_trick_line_add_get_min_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_PRIVATE_CONVEX_HULL_TRICK_IMPL:\n   \
    \ const CPLIB_COLLECTIONS_PRIVATE_CONVEX_HULL_TRICK_IMPL* = 1\n    import deques\n\
    \    import cplib/math/int128\n\n    type\n        CHTLine* = object\n       \
    \     a*, b*: int\n            start*: Int128\n        CHTMonotoneHull* = object\n\
    \            lines*: Deque[CHTLine]\n            slopeIncreasing: bool\n     \
    \       hasSlope: bool\n            lastSlope: int\n\n    proc `<`*(l, r: CHTLine):\
    \ bool =\n        ## \u50BE\u304D\u306E\u964D\u9806\u3067\u6BD4\u8F03\u3057\u307E\
    \u3059\u3002\n        l.a > r.a\n\n    proc `<=`*(l, r: CHTLine): bool =\n   \
    \     ## \u50BE\u304D\u306E\u964D\u9806\u3067\u6BD4\u8F03\u3057\u307E\u3059\u3002\
    \n        l.a >= r.a\n\n    proc chtValue*(line: CHTLine, x: int): Int128 =\n\
    \        ## \u76F4\u7DDA\u306E\u5024\u3092128bit\u6574\u6570\u3067\u8A08\u7B97\
    \u3057\u307E\u3059\u3002O(1)\u3002\n        to_Int128(line.a) * to_Int128(x) +\
    \ to_Int128(line.b)\n\n    proc chtAnswer*(value: Int128): int =\n        ## \u6700\
    \u5C0F\u5024\u3092int\u306B\u5909\u63DB\u3057\u307E\u3059\u3002O(1)\u3002\n  \
    \      assert to_Int128(low(int)) <= value and value <= to_Int128(high(int)),\n\
    \            \"CHT: minimum does not fit in int\"\n        value.to_int\n\n  \
    \  proc chtStart*(l, r: CHTLine): Int128 =\n        ## \u50BE\u304D\u306E\u5C0F\
    \u3055\u3044r\u304Cl\u4EE5\u4E0B\u306B\u306A\u308B\u6700\u521D\u306E\u6574\u6570\
    \u5EA7\u6A19\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        let numerator\
    \ = to_Int128(r.b) - to_Int128(l.b)\n        let denominator = to_Int128(l.a)\
    \ - to_Int128(r.a)\n        assert denominator > 0\n        result = numerator\
    \ div denominator\n        if numerator mod denominator > 0:\n            result\
    \ += 1\n\n    proc chtRedundant*(l, m, r: CHTLine): bool =\n        ## \u50BE\u304D\
    \u304C\u964D\u9806\u306E3\u76F4\u7DDA\u306B\u3064\u3044\u3066\u3001\u4E2D\u592E\
    \u306E\u76F4\u7DDA\u304C\u4E0D\u8981\u304B\u5224\u5B9A\u3057\u307E\u3059\u3002\
    O(1)\u3002\n        chtStart(l, m) >= chtStart(m, r)\n\n    proc initCHTMonotoneHull*(slopeIncreasing:\
    \ bool = false): CHTMonotoneHull =\n        ## \u50BE\u304D\u304C\u5358\u8ABF\u306A\
    \u6700\u5C0F\u5024CHT\u3092\u521D\u671F\u5316\u3057\u307E\u3059\u3002\u65E2\u5B9A\
    \u306F\u5E83\u7FA9\u5358\u8ABF\u6E1B\u5C11\u3002O(1)\u3002\n        result.lines\
    \ = initDeque[CHTLine]()\n        result.slopeIncreasing = slopeIncreasing\n\n\
    \    proc chtAddLine*(self: var CHTMonotoneHull, a, b: int) =\n        ## ax+b\u3092\
    \u8FFD\u52A0\u3057\u307E\u3059\u3002\u50BE\u304D\u306F\u6307\u5B9A\u3057\u305F\
    \u5411\u304D\u306B\u5358\u8ABF\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\u3002\u511F\u5374O(1)\u3002\n        if self.hasSlope:\n        \
    \    assert (if self.slopeIncreasing: self.lastSlope <= a else: a <= self.lastSlope),\n\
    \                \"CHT: slopes must be monotone\"\n        self.hasSlope = true\n\
    \        self.lastSlope = a\n        let line = CHTLine(a: a, b: b)\n        if\
    \ self.slopeIncreasing:\n            if self.lines.len > 0 and self.lines[0].a\
    \ == a:\n                if self.lines[0].b <= b: return\n                discard\
    \ self.lines.popFirst()\n            while self.lines.len >= 2 and chtRedundant(line,\
    \ self.lines[0], self.lines[1]):\n                discard self.lines.popFirst()\n\
    \            self.lines.addFirst(line)\n        else:\n            if self.lines.len\
    \ > 0 and self.lines[^1].a == a:\n                if self.lines[^1].b <= b: return\n\
    \                discard self.lines.popLast()\n            while self.lines.len\
    \ >= 2 and chtRedundant(self.lines[^2], self.lines[^1], line):\n             \
    \   discard self.lines.popLast()\n            self.lines.addLast(line)\n\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  isVerificationFile: false
  path: cplib/collections/private/convex_hull_trick_impl.nim
  requiredBy:
  - cplib/collections/convex_hull_trick_monotone.nim
  - cplib/collections/convex_hull_trick_monotone.nim
  - cplib/collections/convex_hull_trick.nim
  - cplib/collections/convex_hull_trick.nim
  - cplib/collections/convex_hull_trick_monotone_slope.nim
  - cplib/collections/convex_hull_trick_monotone_slope.nim
  timestamp: '2026-09-12 10:51:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/convex_hull_trick_line_add_get_min_test.nim
  - verify/collections/convex_hull_trick_line_add_get_min_test.nim
  - verify/collections/convex_hull_trick_test.nim
  - verify/collections/convex_hull_trick_test.nim
documentation_of: cplib/collections/private/convex_hull_trick_impl.nim
layout: document
redirect_from:
- /library/cplib/collections/private/convex_hull_trick_impl.nim
- /library/cplib/collections/private/convex_hull_trick_impl.nim.html
title: cplib/collections/private/convex_hull_trick_impl.nim
---
