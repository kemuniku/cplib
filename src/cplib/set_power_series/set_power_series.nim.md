---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/private/subset_convolution_barrett.nim
    title: cplib/convolution/private/subset_convolution_barrett.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/private/subset_convolution_barrett.nim
    title: cplib/convolution/private/subset_convolution_barrett.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/subset_convolution.nim
    title: cplib/convolution/subset_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/subset_convolution.nim
    title: cplib/convolution/subset_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/exp_of_set_power_series_test.nim
    title: verify/set_power_series/exp_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/exp_of_set_power_series_test.nim
    title: verify/set_power_series/exp_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/log_of_set_power_series_test.nim
    title: verify/set_power_series/log_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/log_of_set_power_series_test.nim
    title: verify/set_power_series/log_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/polynomial_composite_set_power_series_test.nim
    title: verify/set_power_series/polynomial_composite_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/polynomial_composite_set_power_series_test.nim
    title: verify/set_power_series/polynomial_composite_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/power_projection_of_set_power_series_test.nim
    title: verify/set_power_series/power_projection_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/power_projection_of_set_power_series_test.nim
    title: verify/set_power_series/power_projection_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/set_power_series_regression_test.nim
    title: verify/set_power_series/set_power_series_regression_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/set_power_series_regression_test.nim
    title: verify/set_power_series/set_power_series_regression_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/subset_convolution_test.nim
    title: verify/set_power_series/subset_convolution_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/subset_convolution_test.nim
    title: verify/set_power_series/subset_convolution_test.nim
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
  code: "when not declared CPLIB_SET_POWER_SERIES_SET_POWER_SERIES:\n    const CPLIB_SET_POWER_SERIES_SET_POWER_SERIES*\
    \ = 1\n    import bitops\n    import cplib/convolution/subset_convolution\n  \
    \  import cplib/modint/modint\n    import cplib/math/isprime\n\n    proc setVariableCount(size:\
    \ int): int =\n        ## \u6B63\u306E2\u51AA\u9577\u3092\u691C\u67FB\u3057\u3001\
    \u96C6\u5408\u306E\u5909\u6570\u6570\u3092\u8FD4\u3059\u3002\n        assert size\
    \ > 0 and (size and (size - 1)) == 0, \"\u96C6\u5408\u51AA\u7D1A\u6570\u306E\u9577\
    \u3055\u306F\u6B63\u306E2\u51AA\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        fastLog2(size)\n\n    proc setComposeDerivatives[T: BarrettModint\
    \ or MontgomeryModint](derivatives, s: seq[T]): seq[T] =\n        ## \u5B9A\u6570\
    \u9805\u3067\u306E\u5FAE\u5206\u5024\u304B\u3089\u3001\u5909\u6570\u30921\u3064\
    \u305A\u3064\u8FFD\u52A0\u3057\u3066\u5408\u6210\u3059\u308B\u3002\n        let\
    \ n = setVariableCount(s.len)\n        var values = newSeq[seq[T]](n + 1)\n  \
    \      for k in 0..n: values[k] = @[derivatives[k]]\n        var width = 1\n \
    \       for v in 0..<n:\n            let h = s[width..<width * 2]\n          \
    \  for k in 0..<n - v:\n                let upper = subsetConvolution(values[k\
    \ + 1], h)\n                values[k].add(upper)\n            values.setLen(n\
    \ - v)\n            width *= 2\n        values[0]\n\n    proc setExp*[T: BarrettModint\
    \ or MontgomeryModint](s: seq[T]): seq[T] =\n        ## exp(s)\u3092O(n\xB2 2^n)\u6642\
    \u9593\u30FBO(n 2^n)\u8FFD\u52A0\u9818\u57DF\u3067\u8FD4\u3059\u3002s[0]=0\u3001\
    \u7D20\u6570\u6CD5>n\u3092\u8981\u6C42\u3059\u308B\u3002\n        let n = setVariableCount(s.len)\n\
    \        assert s[0].val == 0, \"exp\u306E\u5B9A\u6570\u9805\u306F0\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        assert T.umod.int\
    \ > n and isprime(T.umod.int), \"exp\u306F\u5909\u6570\u6570\u3088\u308A\u5927\
    \u304D\u3044\u7D20\u6570\u6CD5\u3092\u8981\u6C42\u3057\u307E\u3059\"\n       \
    \ result = @[init(T, 1)]\n        var width = 1\n        for v in 0..<n:\n   \
    \         let upper = subsetConvolution(result, s[width..<width * 2])\n      \
    \      result.add(upper)\n            width *= 2\n\n    proc setLog*[T: BarrettModint\
    \ or MontgomeryModint](s: seq[T]): seq[T] =\n        ## log(s)\u3092O(n\xB2 2^n)\u6642\
    \u9593\u30FBO(n 2^n)\u8FFD\u52A0\u9818\u57DF\u3067\u8FD4\u3059\u3002s[0]=1\u3001\
    \u7D20\u6570\u6CD5>n\u3092\u8981\u6C42\u3059\u308B\u3002\n        let n = setVariableCount(s.len)\n\
    \        assert s[0] == init(T, 1), \"log\u306E\u5B9A\u6570\u9805\u306F1\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        assert T.umod.int\
    \ > n and isprime(T.umod.int), \"log\u306F\u5909\u6570\u6570\u3088\u308A\u5927\
    \u304D\u3044\u7D20\u6570\u6CD5\u3092\u8981\u6C42\u3057\u307E\u3059\"\n       \
    \ var derivatives = newSeq[T](n + 1)\n        if n > 0: derivatives[1] = init(T,\
    \ 1)\n        for k in 2..n: derivatives[k] = derivatives[k - 1] * (-(k - 1))\n\
    \        setComposeDerivatives(derivatives, s)\n\n    proc setUnitInverse[T: BarrettModint\
    \ or MontgomeryModint](c: T): T =\n        ## \u9006\u5143\u3092\u8A08\u7B97\u3057\
    \u3001\u5408\u6210\u6570\u6CD5\u3067\u3082\u5358\u5143\u3067\u3042\u308B\u3053\
    \u3068\u3092\u691C\u67FB\u3059\u308B\u3002\n        assert c.val != 0, \"\u5B9A\
    \u6570\u9805\u306F\u5358\u5143\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        result = c.inv\n        assert c * result == init(T, 1),\
    \ \"\u5B9A\u6570\u9805\u306F\u5358\u5143\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n\n    proc setInv*[T: BarrettModint or MontgomeryModint](s:\
    \ seq[T]): seq[T] =\n        ## \u5358\u5143s\u306E\u9006\u5143\u3092O(n\xB2 2^n)\u6642\
    \u9593\u30FBO(n 2^n)\u8FFD\u52A0\u9818\u57DF\u3067\u8FD4\u3059\u3002\u5B9A\u6570\
    \u9805\u306B\u9006\u5143\u3092\u8981\u6C42\u3059\u308B\u3002\n        let n =\
    \ setVariableCount(s.len)\n        let inverse = setUnitInverse(s[0])\n      \
    \  var derivatives = newSeq[T](n + 1)\n        derivatives[0] = inverse\n    \
    \    for k in 1..n: derivatives[k] = derivatives[k - 1] * (-k) * inverse\n   \
    \     setComposeDerivatives(derivatives, s)\n\n    proc setScalarPower[T: BarrettModint\
    \ or MontgomeryModint](c: T, exponent: uint): T =\n        ## unsigned\u6307\u6570\
    \u306E\u4E8C\u5206\u7D2F\u4E57\u3002\u6700\u5C0Fint\u306E\u7D76\u5BFE\u5024\u3082\
    \u8868\u73FE\u3067\u304D\u308B\u3002\n        result = init(T, 1)\n        var\
    \ base = c\n        var e = exponent\n        while e > 0:\n            if (e\
    \ and 1) != 0: result *= base\n            e = e shr 1\n            if e > 0:\
    \ base *= base\n\n    proc setPow*[T: BarrettModint or MontgomeryModint](s: seq[T],\
    \ exponent: int): seq[T] =\n        ## s\u306E\u6574\u6570\u51AA\u3002O(n\xB2\
    \ 2^n+n log(|exponent|+1))\u6642\u9593\u30FBO(n 2^n)\u9818\u57DF\u3002\u8CA0\u6307\
    \u6570\u306F\u5358\u5143\u306E\u307F\u3002\n        let n = setVariableCount(s.len)\n\
    \        var derivatives = newSeq[T](n + 1)\n        var falling = init(T, 1)\n\
    \        if exponent >= 0:\n            for k in 0..min(n, exponent):\n      \
    \          derivatives[k] = falling * setScalarPower(s[0], uint(exponent - k))\n\
    \                falling *= init(T, exponent) - k\n        else:\n           \
    \ let inverse = setUnitInverse(s[0])\n            let magnitude = uint(-(exponent\
    \ + 1)) + 1u\n            derivatives[0] = setScalarPower(inverse, magnitude)\n\
    \            for k in 1..n:\n                derivatives[k] = derivatives[k -\
    \ 1] * (init(T, exponent) - (k - 1)) * inverse\n        setComposeDerivatives(derivatives,\
    \ s)\n\n    proc setSqrt*[T: BarrettModint or MontgomeryModint](s: seq[T], constantRoot:\
    \ T): seq[T] =\n        ## \u6307\u5B9A\u3057\u305F\u5B9A\u6570\u9805\u306E\u5E73\
    \u65B9\u6839\u3092\u6301\u3064\u5E73\u65B9\u6839\u3092O(n\xB2 2^n)\u6642\u9593\
    \u30FBO(n 2^n)\u9818\u57DF\u3067\u8FD4\u3059\u3002\n        ## constantRoot\xB2\
    =s[0]\u30012\u3068\u5B9A\u6570\u9805\u304C\u5358\u5143\u3067\u3042\u308B\u3053\
    \u3068\u3092\u8981\u6C42\u3059\u308B\u3002\u5168\u96F6\u3068root=0\u306F\u96F6\
    \u3092\u8FD4\u3059\u3002\n        let n = setVariableCount(s.len)\n        assert\
    \ constantRoot * constantRoot == s[0], \"\u6307\u5B9A\u3057\u305F\u5B9A\u6570\u9805\
    \u306E\u5E73\u65B9\u6839\u304C\u4E00\u81F4\u3057\u307E\u305B\u3093\"\n       \
    \ if constantRoot.val == 0:\n            for c in s: assert c.val == 0, \"\u5B9A\
    \u6570\u98050\u306E\u975E\u96F6\u96C6\u5408\u51AA\u7D1A\u6570\u306E\u5E73\u65B9\
    \u6839\u306F\u5BFE\u5FDC\u3057\u3066\u3044\u307E\u305B\u3093\"\n            return\
    \ newSeq[T](s.len)\n        let inverse = setUnitInverse(s[0])\n        let half\
    \ = setUnitInverse(init(T, 2))\n        var derivatives = newSeq[T](n + 1)\n \
    \       derivatives[0] = constantRoot\n        for k in 1..n: derivatives[k] =\
    \ derivatives[k - 1] * (half - (k - 1)) * inverse\n        setComposeDerivatives(derivatives,\
    \ s)\n\n    proc polynomialCompositeSetPowerSeries*[T: BarrettModint or MontgomeryModint](f,\
    \ s: seq[T]): seq[T] =\n        ## \u591A\u9805\u5F0Ff(s)\u3092O(n\xB2 2^n+n M)\u6642\
    \u9593\u30FBO(n 2^n+M)\u8FFD\u52A0\u9818\u57DF\u3067\u8FD4\u3059\u3002M=f.len\u3001\
    s\u306E\u5B9A\u6570\u9805\u306F\u4EFB\u610F\u3002\n        let n = setVariableCount(s.len)\n\
    \        var derivatives = newSeq[T](n + 1)\n        var polynomial = f\n    \
    \    for k in 0..n:\n            if polynomial.len == 0: break\n            var\
    \ value = init(T, 0)\n            for j in countdown(polynomial.high, 0): value\
    \ = value * s[0] + polynomial[j]\n            derivatives[k] = value\n       \
    \     for j in 1..<polynomial.len: polynomial[j - 1] = polynomial[j] * j\n   \
    \         polynomial.setLen(polynomial.len - 1)\n        setComposeDerivatives(derivatives,\
    \ s)\n\n    proc setPowerProjection*[T: BarrettModint or MontgomeryModint](s,\
    \ weights: seq[T], m: int): seq[T] =\n        ## [\u03A3_S weights[S] (s^k)[S]]_{k=0..<m}\
    \ \u3092\u8FD4\u3059\u3002O(n\xB2 2^n+n m)\u6642\u9593\u30FBO(n 2^n+m)\u8FFD\u52A0\
    \u9818\u57DF\u3002\n        let n = setVariableCount(s.len)\n        assert weights.len\
    \ == s.len, \"\u91CD\u307F\u306E\u9577\u3055\u306F\u96C6\u5408\u51AA\u7D1A\u6570\
    \u3068\u4E00\u81F4\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       assert m >= 0, \"\u51FA\u529B\u9577\u306F\u975E\u8CA0\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        if m == 0: return @[]\n\
    \        var adjoints = @[weights]\n        for v in countdown(n - 1, 0):\n  \
    \          let width = 1 shl v\n            let h = s[width..<width * 2]\n   \
    \         var next = newSeq[seq[T]](adjoints.len + 1)\n            for k in 0..<next.len:\
    \ next[k] = newSeq[T](width)\n            for k in 0..<adjoints.len:\n       \
    \         var reversed = newSeq[T](width)\n                for mask in 0..<width:\n\
    \                    next[k][mask] += adjoints[k][mask]\n                    reversed[width\
    \ - 1 - mask] = adjoints[k][width + mask]\n                let product = subsetConvolution(h,\
    \ reversed)\n                for mask in 0..<width: next[k + 1][mask] += product[width\
    \ - 1 - mask]\n            adjoints = move(next)\n        var powers = newSeq[T](m)\n\
    \        powers[0] = init(T, 1)\n        for k in 1..<m: powers[k] = powers[k\
    \ - 1] * s[0]\n        result = newSeq[T](m)\n        for k in 0..<m:\n      \
    \      var falling = init(T, 1)\n            for j in 0..min(k, n):\n        \
    \        result[k] += falling * powers[k - j] * adjoints[j][0]\n             \
    \   falling *= init(T, k) - j\n"
  dependsOn:
  - cplib/convolution/private/subset_convolution_barrett.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/subset_convolution.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/private/subset_convolution_barrett.nim
  - cplib/math/isprime.nim
  - cplib/convolution/subset_convolution.nim
  - cplib/math/isprime.nim
  - cplib/math/isqrt.nim
  isVerificationFile: false
  path: cplib/set_power_series/set_power_series.nim
  requiredBy: []
  timestamp: '2026-10-08 06:34:57+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/set_power_series/power_projection_of_set_power_series_test.nim
  - verify/set_power_series/power_projection_of_set_power_series_test.nim
  - verify/set_power_series/log_of_set_power_series_test.nim
  - verify/set_power_series/log_of_set_power_series_test.nim
  - verify/set_power_series/polynomial_composite_set_power_series_test.nim
  - verify/set_power_series/polynomial_composite_set_power_series_test.nim
  - verify/set_power_series/set_power_series_regression_test.nim
  - verify/set_power_series/set_power_series_regression_test.nim
  - verify/set_power_series/exp_of_set_power_series_test.nim
  - verify/set_power_series/exp_of_set_power_series_test.nim
  - verify/set_power_series/subset_convolution_test.nim
  - verify/set_power_series/subset_convolution_test.nim
documentation_of: cplib/set_power_series/set_power_series.nim
layout: document
redirect_from:
- /library/cplib/set_power_series/set_power_series.nim
- /library/cplib/set_power_series/set_power_series.nim.html
title: cplib/set_power_series/set_power_series.nim
---
