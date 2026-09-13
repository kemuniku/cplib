---
data:
  _extendedDependsOn:
  - icon: ':x:'
    path: cplib/math/monoid_floor_sum.nim
    title: cplib/math/monoid_floor_sum.nim
  - icon: ':x:'
    path: cplib/math/monoid_floor_sum.nim
    title: cplib/math/monoid_floor_sum.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':x:'
    path: verify/math/generalized_floor_sum_test.nim
    title: verify/math/generalized_floor_sum_test.nim
  - icon: ':x:'
    path: verify/math/generalized_floor_sum_test.nim
    title: verify/math/generalized_floor_sum_test.nim
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_GENERALIZED_FLOOR_SUM:\n    const CPLIB_MATH_GENERALIZED_FLOOR_SUM*\
    \ = 1\n    import cplib/math/monoid_floor_sum\n\n    proc generalizedFloorSumTable*[T](n,\
    \ m, a, b, p, q: int): seq[seq[T]] =\n        ## result[j][k] = \u03A3(i=0..<n)\
    \ i^j * floor((a*i+b)/m)^k (0<=j<=p, 0<=k<=q)\u30020^0=1\u3002\n        ## n,a,b,p,q\
    \ >= 0\u3001m > 0\u3001a*n+b <= high(int) \u304C\u5FC5\u8981\u3002\n        ##\
    \ T \u306F int \u304B\u3089\u5909\u63DB\u3067\u304D\u308B\u53EF\u63DB\u74B0\u3067\
    \u3001\u65E2\u5B9A\u5024\u304C\u96F6\u306E\u578B\u3092\u6307\u5B9A\u3059\u308B\
    \u3002\u9664\u7B97\u306F\u4E0D\u8981\u3002\n        ## \u6642\u9593 O((p+1)(q+1)(p+q+2)log(m+1)log(n+a+b+2))\u3001\
    \u7A7A\u9593 O((p+q+2)^2)\u3002\n        ## \u6574\u6570\u578B\u3067\u306F\u7D50\
    \u679C\u3060\u3051\u3067\u306A\u304F\u9014\u4E2D\u306E\u74B0\u6F14\u7B97\u3082\
    \u578B\u306E\u7BC4\u56F2\u5185\u306B\u53CE\u307E\u308B\u5FC5\u8981\u304C\u3042\
    \u308B\u3002\n        assert n >= 0 and m > 0 and a >= 0 and b >= 0 and p >= 0\
    \ and q >= 0\n        assert n == 0 or a <= (high(int) - b) div n\n\n        proc\
    \ zeroTable(): seq[seq[T]] =\n            ## (p+1) \u884C (q+1) \u5217\u306E\u96F6\
    \u884C\u5217\u3092\u4F5C\u308B\u3002\n            result = newSeq[seq[T]](p +\
    \ 1)\n            for j in 0..p:\n                result[j] = newSeq[T](q + 1)\n\
    \n        if n == 0:\n            return zeroTable()\n\n        let one: T = 1\n\
    \        let degree = max(p, q)\n        var binom = newSeq[seq[T]](degree + 1)\n\
    \        for j in 0..degree:\n            binom[j] = newSeq[T](j + 1)\n      \
    \      binom[j][0] = one\n            binom[j][j] = one\n            for k in\
    \ 1..<j:\n                binom[j][k] = binom[j - 1][k - 1] + binom[j - 1][k]\n\
    \n        type Moment = object\n            dx, dy: T\n            sums: seq[seq[T]]\n\
    \n        proc combine(l, r: Moment): Moment =\n            ## \u53F3\u5074\u306E\
    \u5404\u30E2\u30FC\u30E1\u30F3\u30C8\u3092\u5DE6\u5074\u306E\u7D42\u70B9\u3060\
    \u3051\u5E73\u884C\u79FB\u52D5\u3057\u3066\u7D50\u5408\u3059\u308B\u3002O((p+1)(q+1)(p+q+2))\u3002\
    \n            var xp = newSeq[T](p + 1)\n            var yp = newSeq[T](q + 1)\n\
    \            xp[0] = one\n            yp[0] = one\n            for j in 1..p:\n\
    \                xp[j] = xp[j - 1] * l.dx\n            for k in 1..q:\n      \
    \          yp[k] = yp[k - 1] * l.dy\n\n            var shifted = zeroTable()\n\
    \            for j in 0..p:\n                for s in 0..j:\n                \
    \    let coefficient = binom[j][s] * xp[j - s]\n                    for k in 0..q:\n\
    \                        shifted[j][k] = shifted[j][k] + coefficient * r.sums[s][k]\n\
    \n            result = Moment(dx: l.dx + r.dx, dy: l.dy + r.dy, sums: zeroTable())\n\
    \            for k in 0..q:\n                for t in 0..k:\n                \
    \    let coefficient = binom[k][t] * yp[k - t]\n                    for j in 0..p:\n\
    \                        result.sums[j][k] = result.sums[j][k] + coefficient *\
    \ shifted[j][t]\n            for j in 0..p:\n                for k in 0..q:\n\
    \                    result.sums[j][k] = result.sums[j][k] + l.sums[j][k]\n\n\
    \        var x = Moment(dx: one, sums: zeroTable())\n        x.sums[0][0] = one\n\
    \        let y = Moment(dy: one, sums: zeroTable())\n        let e = Moment(sums:\
    \ zeroTable())\n        return monoidFloorSum(n, m, a, b, x, y, combine, e).sums\n\
    \n    proc generalizedFloorSum*[T](n, m, a, b, p, q: int): T =\n        ## \u03A3\
    (i=0..<n) i^p * floor((a*i+b)/m)^q \u3092\u8FD4\u3059\u3002\u6761\u4EF6\u30FB\u8A08\
    \u7B97\u91CF\u306F generalizedFloorSumTable \u3068\u540C\u3058\u3002\n       \
    \ return generalizedFloorSumTable[T](n, m, a, b, p, q)[p][q]\n"
  dependsOn:
  - cplib/math/monoid_floor_sum.nim
  - cplib/math/monoid_floor_sum.nim
  isVerificationFile: false
  path: cplib/math/generalized_floor_sum.nim
  requiredBy: []
  timestamp: '2026-09-12 15:14:35+09:00'
  verificationStatus: LIBRARY_ALL_WA
  verifiedWith:
  - verify/math/generalized_floor_sum_test.nim
  - verify/math/generalized_floor_sum_test.nim
documentation_of: cplib/math/generalized_floor_sum.nim
layout: document
redirect_from:
- /library/cplib/math/generalized_floor_sum.nim
- /library/cplib/math/generalized_floor_sum.nim.html
title: cplib/math/generalized_floor_sum.nim
---
