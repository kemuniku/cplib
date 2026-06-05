---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_FENWICK2D:\n    const CPLIB_COLLECTIONS_FENWICK2D*\
    \ = 1\n    import algorithm\n    import sequtils\n\n\n    type Fenwick2D = ref\
    \ object\n        n: int\n        ys: seq[seq[int]]\n        bit: seq[seq[int]]\n\
    \n    proc initFenwick2D*(posVals: seq[seq[int]]): Fenwick2D =\n        let n\
    \ = posVals.len\n        var ys = newSeq[seq[int]](n + 1)\n        for p in 0..<n:\n\
    \            var i = p + 1\n            while i <= n:\n                ys[i].add(posVals[p])\n\
    \                i += i and -i\n        var bit = newSeq[seq[int]](n + 1)\n  \
    \      for i in 1..n:\n            ys[i].sort()\n            ys[i] = ys[i].deduplicate(true)\n\
    \            bit[i] = newSeq[int](ys[i].len + 1)\n        Fenwick2D(n: n, ys:\
    \ ys, bit: bit)\n\n    proc add*(self: Fenwick2D, p, y, delta: int) =\n      \
    \  var i = p + 1\n        while i <= self.n:\n            var k = self.ys[i].lowerBound(y)\
    \ + 1\n            while k < self.bit[i].len:\n                self.bit[i][k]\
    \ += delta\n                k += k and -k\n            i += i and -i\n\n    proc\
    \ prefix*(self: Fenwick2D, r, yUpper: int): int =\n        var i = r\n       \
    \ while i > 0:\n            var k = self.ys[i].lowerBound(yUpper)\n          \
    \  while k > 0:\n                result += self.bit[i][k]\n                k -=\
    \ k and -k\n            i -= i and -i\n\n    proc getLess*(self: Fenwick2D, l,\
    \ r, yUpper: int): int =\n        self.prefix(r, yUpper) - self.prefix(l, yUpper)\n\
    \n    proc get*(self: Fenwick2D, l, r, yLower, yUpper: int): int =\n        ##\
    \ \u9577\u65B9\u5F62\u9818\u57DF x in [l,r), y in [yLower,yUpper) \u306E\u548C\
    \u3092\u8FD4\u3057\u307E\u3059\u3002\n        self.getLess(l, r, yUpper) - self.getLess(l,\
    \ r, yLower)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/fenwick2d.nim
  requiredBy: []
  timestamp: '2026-06-06 00:59:23+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/fenwick2d.nim
layout: document
redirect_from:
- /library/cplib/collections/fenwick2d.nim
- /library/cplib/collections/fenwick2d.nim.html
title: cplib/collections/fenwick2d.nim
---
