---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/range_linear_add_range_min_test.nim
    title: verify/AI/range_linear_add_range_min_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/range_linear_add_range_min_test.nim
    title: verify/AI/range_linear_add_range_min_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_linear_add_range_min_test.nim
    title: verify/collections/range_linear_add_range_min_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_linear_add_range_min_test.nim
    title: verify/collections/range_linear_add_range_min_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_RANGE_LINEAR_ADD_RANGE_MIN:\n    const\
    \ CPLIB_COLLECTIONS_RANGE_LINEAR_ADD_RANGE_MIN* = 1\n    import cplib/math/int128\n\
    \n    type\n        LinearMinPoint = tuple[x, y: int]\n        LinearMinNode =\
    \ object\n            left, right: LinearMinPoint\n            slope, intercept:\
    \ int\n        RangeLinearAddRangeMin* = ref object\n            length: int\n\
    \            nodes: seq[LinearMinNode]\n\n    proc shifted(p: LinearMinPoint,\
    \ slope, intercept: int): LinearMinPoint {.inline.} =\n        ## \u70B9\u306E\
    \u9AD8\u3055\u306B slope * x + intercept \u3092\u52A0\u3048\u307E\u3059\u3002\
    O(1)\u3002\n        (p.x, p.y + slope * p.x + intercept)\n\n    proc cross(a,\
    \ b, c, d: LinearMinPoint): Int128 {.inline.} =\n        ## \u30D9\u30AF\u30C8\
    \u30EB b-a \u3068 d-c \u306E\u5916\u7A4D\u3092128bit\u6574\u6570\u3067\u6C42\u3081\
    \u307E\u3059\u3002O(1)\u3002\n        (to_Int128(b.x) - a.x) * (to_Int128(d.y)\
    \ - c.y) -\n            (to_Int128(b.y) - a.y) * (to_Int128(d.x) - c.x)\n\n  \
    \  proc pull(self: RangeLinearAddRangeMin, k, border: int) =\n        ## \u5DE6\
    \u53F3\u306E\u4E0B\u5074\u51F8\u5305\u306E\u5171\u901A\u63A5\u7DDA\u3092\u6C42\
    \u3081\u307E\u3059\u3002O(log N)\u3002\n        var\n            l = k * 2\n \
    \           r = k * 2 + 1\n            ls = self.nodes[l].slope\n            lc\
    \ = self.nodes[l].intercept\n            rs = self.nodes[r].slope\n          \
    \  rc = self.nodes[r].intercept\n        while true:\n            let\n      \
    \          a = shifted(self.nodes[l].left, ls, lc)\n                b = shifted(self.nodes[l].right,\
    \ ls, lc)\n                c = shifted(self.nodes[r].left, rs, rc)\n         \
    \       d = shifted(self.nodes[r].right, rs, rc)\n                lLeaf = a.x\
    \ == b.x\n                rLeaf = c.x == d.x\n            if lLeaf and rLeaf:\n\
    \                self.nodes[k].left = a\n                self.nodes[k].right =\
    \ c\n                return\n            var descendLeft: bool\n            var\
    \ child: int\n            if not lLeaf and cross(a, b, a, c) < 0:\n          \
    \      descendLeft = true\n                child = l * 2\n            elif not\
    \ rLeaf and cross(b, c, b, d) < 0:\n                child = r * 2 + 1\n      \
    \      elif lLeaf:\n                child = r * 2\n            elif rLeaf:\n \
    \               descendLeft = true\n                child = l * 2 + 1\n      \
    \      else:\n                let\n                    c1 = cross(a, b, c, d)\n\
    \                    c2 = cross(a, b, c, b)\n                # \u63A5\u7DDA\u5019\
    \u88DC\u306E\u4EA4\u70B9\u304C\u5DE6\u53F3\u306E\u5883\u754C\u306E\u3069\u3061\
    \u3089\u5074\u306B\u3042\u308B\u304B\u3092\u5224\u5B9A\u3057\u307E\u3059\u3002\
    \n                descendLeft = if c1 == 0 and c2 == 0: c.x < border\n       \
    \             else: to_Int128(c.x - border) * c1 + to_Int128(d.x - c.x) * c2 <\
    \ 0\n                child = if descendLeft: l * 2 + 1 else: r * 2\n         \
    \   if descendLeft:\n                l = child\n                ls += self.nodes[l].slope\n\
    \                lc += self.nodes[l].intercept\n            else:\n          \
    \      r = child\n                rs += self.nodes[r].slope\n                rc\
    \ += self.nodes[r].intercept\n\n    proc build(self: RangeLinearAddRangeMin, v:\
    \ openArray[int], k, l, r: int) =\n        ## \u533A\u9593\u306E\u51F8\u5305\u3092\
    \u518D\u5E30\u7684\u306B\u69CB\u7BC9\u3057\u307E\u3059\u3002O(r-l)\u3002\n   \
    \     if r - l == 1:\n            self.nodes[k].left = (l, v[l])\n           \
    \ self.nodes[k].right = (l, v[l])\n            return\n        let m = (l + r)\
    \ shr 1\n        self.build(v, k * 2, l, m)\n        self.build(v, k * 2 + 1,\
    \ m, r)\n        self.pull(k, m)\n\n    proc initRangeLinearAddRangeMin*(v: openArray[int]):\
    \ RangeLinearAddRangeMin =\n        ## \u914D\u5217\u304B\u3089\u69CB\u7BC9\u3057\
    \u307E\u3059\u3002\u6642\u9593\u30FB\u7A7A\u9593 O(N)\u300264bit\u74B0\u5883\u306E\
    C++\u30D0\u30C3\u30AF\u30A8\u30F3\u30C9\u5C02\u7528\u3067\u3059\u3002\n      \
    \  ## \u5024\u30FB\u9045\u5EF6\u52A0\u7B97\u306E\u4FC2\u6570\u3068\u305D\u306E\
    \u9069\u7528\u6642\u306E\u4E2D\u9593\u5024\u306F int \u306B\u53CE\u3081\u3066\u304F\
    \u3060\u3055\u3044\u3002\n        ## \u5404\u7BC0\u70B9\u306F\u81EA\u8EAB\u306E\
    \u9045\u5EF6\u52A0\u7B97\u3092\u9664\u3044\u305F\u4E0B\u5074\u51F8\u5305\u306E\
    \u5171\u901A\u63A5\u7DDA\u3092\u4FDD\u6301\u3057\u307E\u3059\u3002\n        static:\
    \ doAssert sizeof(int) == 8\n        result = RangeLinearAddRangeMin(length: v.len,\
    \ nodes: newSeq[LinearMinNode](4 * v.len))\n        if v.len > 0:\n          \
    \  result.build(v, 1, 0, v.len)\n\n    proc push(self: RangeLinearAddRangeMin,\
    \ k: int) {.inline.} =\n        ## \u4E00\u6B21\u5F0F\u306E\u9045\u5EF6\u52A0\u7B97\
    \u3092\u5B50\u3078\u4F1D\u3048\u307E\u3059\u3002O(1)\u3002\n        for child\
    \ in k * 2..k * 2 + 1:\n            self.nodes[child].slope += self.nodes[k].slope\n\
    \            self.nodes[child].intercept += self.nodes[k].intercept\n        self.nodes[k].slope\
    \ = 0\n        self.nodes[k].intercept = 0\n\n    proc addImpl(self: RangeLinearAddRangeMin,\
    \ k, l, r, ql, qr, b, c: int) =\n        ## \u6307\u5B9A\u533A\u9593\u3078\u4E00\
    \u6B21\u5F0F\u3092\u52A0\u7B97\u3057\u3001\u5883\u754C\u4E0A\u306E\u63A5\u7DDA\
    \u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(log^2 N)\u3002\n        if ql <= l\
    \ and r <= qr:\n            self.nodes[k].slope += b\n            self.nodes[k].intercept\
    \ += c\n            return\n        self.push(k)\n        let m = (l + r) shr\
    \ 1\n        if ql < m:\n            self.addImpl(k * 2, l, m, ql, qr, b, c)\n\
    \        if m < qr:\n            self.addImpl(k * 2 + 1, m, r, ql, qr, b, c)\n\
    \        self.pull(k, m)\n\n    proc add*(self: RangeLinearAddRangeMin, l, r,\
    \ b, c: int) =\n        ## \u534A\u958B\u533A\u9593 [l,r) \u306E a[i] \u306B b*i+c\
    \ \u3092\u52A0\u3048\u307E\u3059\u3002O(log^2 N)\u3002\n        assert 0 <= l\
    \ and l <= r and r <= self.length\n        if l < r:\n            self.addImpl(1,\
    \ 0, self.length, l, r, b, c)\n\n    proc add*(self: RangeLinearAddRangeMin, segment:\
    \ HSlice[int, int], b, c: int) =\n        ## \u6307\u5B9A\u533A\u9593\u306E a[i]\
    \ \u306B b*i+c \u3092\u52A0\u3048\u307E\u3059\u3002\u6DFB\u5B57 i \u306F\u914D\
    \u5217\u5168\u4F53\u3067\u306E\u6DFB\u5B57\u3067\u3059\u3002O(log^2 N)\u3002\n\
    \        self.add(segment.a, segment.b + 1, b, c)\n\n    proc subtreeMin(self:\
    \ RangeLinearAddRangeMin, root, slope, intercept: int): int =\n        ## \u63A5\
    \u7DDA\u306E\u50BE\u304D\u3067\u5B50\u3092\u9078\u3073\u3001\u90E8\u5206\u6728\
    \u306E\u6700\u5C0F\u5024\u3092\u6C42\u3081\u307E\u3059\u3002O(log N)\u3002\n \
    \       var\n            k = root\n            s = slope\n            t = intercept\n\
    \        while true:\n            s += self.nodes[k].slope\n            t += self.nodes[k].intercept\n\
    \            let\n                a = shifted(self.nodes[k].left, s, t)\n    \
    \            b = shifted(self.nodes[k].right, s, t)\n            if a.x == b.x:\n\
    \                return a.y\n            k = if a.y < b.y: k * 2 else: k * 2 +\
    \ 1\n\n    proc prodImpl(self: RangeLinearAddRangeMin, k, l, r, ql, qr, slope,\
    \ intercept: int): int =\n        ## \u533A\u9593\u3092\u90E8\u5206\u6728\u3078\
    \u5206\u5272\u3057\u3066\u6700\u5C0F\u5024\u3092\u6C42\u3081\u307E\u3059\u3002\
    O(log^2 N)\u3002\n        if ql <= l and r <= qr:\n            return self.subtreeMin(k,\
    \ slope, intercept)\n        let\n            m = (l + r) shr 1\n            s\
    \ = slope + self.nodes[k].slope\n            t = intercept + self.nodes[k].intercept\n\
    \        result = high(int)\n        if ql < m:\n            result = self.prodImpl(k\
    \ * 2, l, m, ql, qr, s, t)\n        if m < qr:\n            result = min(result,\
    \ self.prodImpl(k * 2 + 1, m, r, ql, qr, s, t))\n\n    proc prod*(self: RangeLinearAddRangeMin,\
    \ l, r: int): int =\n        ## \u534A\u958B\u533A\u9593 [l,r) \u306E\u6700\u5C0F\
    \u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u533A\u9593\u306F high(int)\u3002\
    O(log^2 N)\u3002\n        assert 0 <= l and l <= r and r <= self.length\n    \
    \    if l == r: return high(int)\n        self.prodImpl(1, 0, self.length, l,\
    \ r, 0, 0)\n\n    proc prod*(self: RangeLinearAddRangeMin, segment: HSlice[int,\
    \ int]): int =\n        ## \u6307\u5B9A\u533A\u9593\u306E\u6700\u5C0F\u5024\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\u7A7A\u533A\u9593\u306F high(int)\u3002O(log^2\
    \ N)\u3002\n        self.prod(segment.a, segment.b + 1)\n\n    proc `[]`*(self:\
    \ RangeLinearAddRangeMin, segment: HSlice[int, int]): int =\n        ## \u6307\
    \u5B9A\u533A\u9593\u306E\u6700\u5C0F\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\
    O(log^2 N)\u3002\n        self.prod(segment)\n\n    proc `[]`*(self: RangeLinearAddRangeMin,\
    \ i: int): int =\n        ## a[i] \u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\
    \n        assert 0 <= i and i < self.length\n        self.prod(i, i + 1)\n\n \
    \   proc len*(self: RangeLinearAddRangeMin): int =\n        ## \u914D\u5217\u306E\
    \u9577\u3055\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        self.length\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  isVerificationFile: false
  path: cplib/collections/range_linear_add_range_min.nim
  requiredBy: []
  timestamp: '2026-09-09 00:03:57+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/range_linear_add_range_min_test.nim
  - verify/collections/range_linear_add_range_min_test.nim
  - verify/AI/range_linear_add_range_min_test.nim
  - verify/AI/range_linear_add_range_min_test.nim
documentation_of: cplib/collections/range_linear_add_range_min.nim
layout: document
redirect_from:
- /library/cplib/collections/range_linear_add_range_min.nim
- /library/cplib/collections/range_linear_add_range_min.nim.html
title: cplib/collections/range_linear_add_range_min.nim
---
