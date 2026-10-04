---
data:
  _extendedDependsOn:
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
    path: verify/AI/multiplicative_prefix_sum_limit_test.nim
    title: verify/AI/multiplicative_prefix_sum_limit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/multiplicative_prefix_sum_limit_test.nim
    title: verify/AI/multiplicative_prefix_sum_limit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/multiplicative_prefix_sum_test.nim
    title: verify/AI/multiplicative_prefix_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/multiplicative_prefix_sum_test.nim
    title: verify/AI/multiplicative_prefix_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/sum_of_multiplicative_function_test.nim
    title: verify/math/sum_of_multiplicative_function_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/sum_of_multiplicative_function_test.nim
    title: verify/math/sum_of_multiplicative_function_test.nim
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
  code: "when not declared CPLIB_MATH_MULTIPLICATIVE_PREFIX_SUM:\n    const CPLIB_MATH_MULTIPLICATIVE_PREFIX_SUM*\
    \ = 1\n    import cplib/math/isqrt\n    import cplib/math/isprime\n    import\
    \ cplib/modint/modint\n\n    proc multiplicativePolynomialValue[T](coefficients:\
    \ openArray[T], n: int): T =\n        ## \u6607\u51AA\u9806\u306E\u591A\u9805\u5F0F\
    \u3092 Horner \u6CD5\u3067\u8A55\u4FA1\u3059\u308B\u3002O(\u6B21\u6570)\u3002\n\
    \        let x = init(T, n)\n        for i in countdown(coefficients.len - 1,\
    \ 0):\n            result = result * x + coefficients[i]\n\n    proc multiplicativePowerSumPolynomials[T](degree:\
    \ int): seq[seq[T]] =\n        ## sum(k=1..n, k^j) \u306E\u591A\u9805\u5F0F\u3092\
    \ j=0..degree \u306B\u3064\u3044\u3066\u4F5C\u308B\u3002O(degree^3)\u3002\n  \
    \      for j in 0..degree:\n            var binomial = newSeq[T](j + 2)\n    \
    \        binomial[0] = init(T, 1)\n            for k in 1..j + 1:\n          \
    \      binomial[k] = binomial[k - 1] * (j + 2 - k) / k\n            var polynomial\
    \ = binomial\n            polynomial[0] -= 1\n            for k in 0..<j:\n  \
    \              for t in 0..<result[k].len:\n                    polynomial[t]\
    \ -= binomial[k] * result[k][t]\n            let inverse = init(T, j + 1).inv\n\
    \            for x in polynomial.mitems:\n                x *= inverse\n     \
    \       result.add(polynomial)\n\n    proc multiplicativePrefixSum*[T: BarrettModint\
    \ or MontgomeryModint](\n            n: int, primeCoefficients: openArray[T],\n\
    \            primePower: proc(p, e: int): T {.closure.}): T =\n        ## f(1)+...+f(n)\
    \ \u3092\u6C42\u3081\u308B\u3002\u56FA\u5B9A\u6B21\u6570\u30FBO(1) \u306E primePower\
    \ \u306B\u5BFE\u3057\u6642\u9593 O~(n^(3/4))\u3001\u7A7A\u9593 O(sqrt(n))\u3002\
    \n        ## f(p)=sum(j, primeCoefficients[j]*p^j)\u3002primePower \u306F e>=2\
    \ \u306E f(p^e) \u3092\u8FD4\u3059\u3002\n        ## 0 <= n <= 2^40\u3002\u7D20\
    \u6570\u6CD5\u306F\u591A\u9805\u5F0F\u306E\u6B21\u6570+1\u3088\u308A\u5927\u304D\
    \u3044\u5FC5\u8981\u304C\u3042\u308B\u3002\n        assert n >= 0, \"n \u306F\u975E\
    \u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n       \
    \ assert n <= (1'i64 shl 40), \"n \u306F 2^40 \u4EE5\u4E0B\u3067\u3042\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\"\n        assert isprime(T.umod), \"\u6CD5\
    \u306F\u7D20\u6570\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \"\n        if n == 0:\n            return init(T, 0)\n        if n == 1:\n  \
    \          return init(T, 1)\n\n        var coefficients = @primeCoefficients\n\
    \        while coefficients.len > 0 and coefficients[^1].val == 0:\n         \
    \   coefficients.setLen(coefficients.len - 1)\n\n        # \u5C0F\u3055\u3044\u5165\
    \u529B\u3067\u306F\u7D20\u56E0\u6570\u5206\u89E3\u8868\u3067\u76F4\u63A5\u8A08\
    \u7B97\u3059\u308B\u3002\n        if n <= 4096:\n            var leastPrime =\
    \ newSeq[int](n + 1)\n            var values = newSeq[T](n + 1)\n            values[1]\
    \ = init(T, 1)\n            result = values[1]\n            for p in 2..n:\n \
    \               if leastPrime[p] == 0:\n                    for multiple in countup(p,\
    \ n, p):\n                        if leastPrime[multiple] == 0:\n            \
    \                leastPrime[multiple] = p\n                var rest = p\n    \
    \            let prime = leastPrime[p]\n                var exponent = 0\n   \
    \             while rest mod prime == 0:\n                    rest = rest div\
    \ prime\n                    inc exponent\n                let value = if exponent\
    \ == 1:\n                                multiplicativePolynomialValue(coefficients,\
    \ prime)\n                            else: primePower(prime, exponent)\n    \
    \            values[p] = values[rest] * value\n                result += values[p]\n\
    \            return\n\n        assert coefficients.len < T.umod.int,\n       \
    \     \"\u6CD5\u306F\u591A\u9805\u5F0F\u306E\u6B21\u6570+1\u3088\u308A\u5927\u304D\
    \u3044\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        let root = isqrt(n)\n\
    \        let largeCount = n div (root + 1)\n        var composite = newSeq[bool](root\
    \ + 1)\n        var primes: seq[int]\n        for p in 2..root:\n            if\
    \ composite[p]: continue\n            primes.add(p)\n            if p <= root\
    \ div p:\n                for multiple in countup(p * p, root, p):\n         \
    \           composite[multiple] = true\n\n        # small[x] \u3068 large[i] \u306B\
    \u3001x \u304A\u3088\u3073 floor(n/i) \u4EE5\u4E0B\u306E\u7D20\u6570\u3067\u306E\
    \u5024\u306E\u548C\u3092\u6301\u3064\u3002\n        var small = newSeq[T](root\
    \ + 1)\n        var large = newSeq[T](largeCount + 1)\n        let powerSums =\
    \ multiplicativePowerSumPolynomials[T](coefficients.len - 1)\n        for degree,\
    \ coefficient in coefficients:\n            if coefficient.val == 0: continue\n\
    \            var low = newSeq[T](root + 1)\n            var high = newSeq[T](largeCount\
    \ + 1)\n            for x in 1..root:\n                low[x] = multiplicativePolynomialValue(powerSums[degree],\
    \ x) - 1\n            for i in 1..largeCount:\n                high[i] = multiplicativePolynomialValue(powerSums[degree],\
    \ n div i) - 1\n            # p \u3088\u308A\u5C0F\u3055\u3044\u7D20\u56E0\u6570\
    \u3092\u9664\u53BB\u6E08\u307F\u306E\u8868\u304B\u3089\u3001\u6700\u5C0F\u7D20\
    \u56E0\u6570\u304C p \u306E\u5408\u6210\u6570\u3092\u9664\u304F\u3002\n      \
    \      for p in primes:\n                let weight = init(T, p).pow(degree)\n\
    \                let before = low[p - 1]\n                let bound = min(largeCount,\
    \ n div (p * p))\n                var ip = p\n                for i in 1..bound:\n\
    \                    let previous = if ip <= largeCount: high[ip]\n          \
    \                         else: low[n div ip]\n                    high[i] -=\
    \ weight * (previous - before)\n                    ip += p\n                for\
    \ x in countdown(root, p * p):\n                    low[x] -= weight * (low[x\
    \ div p] - before)\n            for x in 1..root:\n                small[x] +=\
    \ coefficient * low[x]\n            for i in 1..largeCount:\n                large[i]\
    \ += coefficient * high[i]\n\n        # \u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u306E\
    \u8A55\u4FA1\u3092\u7D20\u6570\u51AA\u3054\u3068\u306B\u4E00\u5EA6\u306B\u6291\
    \u3048\u3001\u5024\u3092\u9023\u7D9A\u3057\u305F\u914D\u5217\u306B\u4FDD\u5B58\
    \u3059\u308B\u3002\n        var offsets = newSeq[int](primes.len)\n        var\
    \ values: seq[T]\n        var primePrefix = newSeq[T](primes.len + 1)\n      \
    \  for i, p in primes:\n            offsets[i] = values.len\n            let value\
    \ = multiplicativePolynomialValue(coefficients, p)\n            primePrefix[i\
    \ + 1] = primePrefix[i] + value\n            values.add(value)\n            var\
    \ power = p\n            var e = 1\n            while power <= n div p:\n    \
    \            power *= p\n                inc e\n                values.add(primePower(p,\
    \ e))\n\n        var answer = init(T, 1) + large[1]\n        proc visit(limit,\
    \ start: int, weight: T) =\n            ## \u6700\u5C0F\u7D20\u56E0\u6570\u3068\
    \u305D\u306E\u6307\u6570\u3092\u56FA\u5B9A\u3057\u3001\u5408\u6210\u6570\u306E\
    \u5BC4\u4E0E\u3092\u52A0\u7B97\u3059\u308B\u3002\n            if weight.val ==\
    \ 0: return\n            var i = start\n            while i < primes.len and primes[i]\
    \ * primes[i] <= limit:\n                let p = primes[i]\n                var\
    \ power = p\n                var e = 1\n                while power <= limit div\
    \ p:\n                    let remaining = limit div power\n                  \
    \  let value = weight * values[offsets[i] + e - 1]\n                    let primeSum\
    \ = if remaining <= root: small[remaining]\n                                 \
    \  else: large[n div remaining]\n                    # p^(e+1) \u5358\u72EC\u3068\
    \u3001p^e \u306B p \u3088\u308A\u5927\u304D\u3044\u7D20\u6570\u3092\u4E00\u3064\
    \u639B\u3051\u308B\u5834\u5408\u3092\u307E\u3068\u3081\u308B\u3002\n         \
    \           answer += weight * values[offsets[i] + e] +\n                    \
    \          value * (primeSum - primePrefix[i + 1])\n                    visit(remaining,\
    \ i + 1, value)\n                    power *= p\n                    inc e\n \
    \               inc i\n        visit(n, 0, init(T, 1))\n        result = answer\n"
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  isVerificationFile: false
  path: cplib/math/multiplicative_prefix_sum.nim
  requiredBy: []
  timestamp: '2026-09-30 20:31:36+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/multiplicative_prefix_sum_limit_test.nim
  - verify/AI/multiplicative_prefix_sum_limit_test.nim
  - verify/AI/multiplicative_prefix_sum_test.nim
  - verify/AI/multiplicative_prefix_sum_test.nim
  - verify/math/sum_of_multiplicative_function_test.nim
  - verify/math/sum_of_multiplicative_function_test.nim
documentation_of: cplib/math/multiplicative_prefix_sum.nim
layout: document
redirect_from:
- /library/cplib/math/multiplicative_prefix_sum.nim
- /library/cplib/math/multiplicative_prefix_sum.nim.html
title: cplib/math/multiplicative_prefix_sum.nim
---
