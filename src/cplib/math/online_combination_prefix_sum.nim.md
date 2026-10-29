---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination.nim
    title: cplib/math/combination.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination.nim
    title: cplib/math/combination.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/online_combination_prefix_sum_test.nim
    title: verify/math/online_combination_prefix_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/online_combination_prefix_sum_test.nim
    title: verify/math/online_combination_prefix_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/online_combination_prefix_sum_yosupo_test.nim
    title: verify/math/online_combination_prefix_sum_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/online_combination_prefix_sum_yosupo_test.nim
    title: verify/math/online_combination_prefix_sum_yosupo_test.nim
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
  code: "when not declared CPLIB_MATH_ONLINE_COMBINATION_PREFIX_SUM:\n    const CPLIB_MATH_ONLINE_COMBINATION_PREFIX_SUM*\
    \ = 1\n\n    import cplib/math/combination\n    import cplib/math/isqrt\n\n  \
    \  type OnlineCombinationPrefixSum*[ModInt] = object\n        maxN, width: int\n\
    \        modulus: uint32\n        fact, factInv: seq[ModInt]\n        powersOfTwo,\
    \ halfScaledFact: seq[ModInt]\n        samples: seq[seq[ModInt]]\n\n    proc initOnlineCombinationPrefixSum*[ModInt](maxN:\
    \ int): OnlineCombinationPrefixSum[ModInt] =\n        ## 0 <= n <= maxN \u306E\
    \u30AA\u30F3\u30E9\u30A4\u30F3\u4E8C\u9805\u4FC2\u6570\u548C\u3092\u524D\u8A08\
    \u7B97\u3059\u308B\u3002\u6642\u9593 O(N sqrt(N))\u3001\u7A7A\u9593 O(N)\u3002\
    \n        ## \u7D20\u6570\u6CD5 p\uFF08\u7D20\u6570\u6027\u306E\u5224\u5B9A\u306A\
    \u3057\uFF09\u3068 0 <= maxN < p \u304C\u5FC5\u8981\u3002\u7BC4\u56F2\u5916\u306F\
    \ ValueError\u3002\n        ## dynamic modint \u306E\u6CD5\u306F\u69CB\u7BC9\u524D\
    \u306B\u8A2D\u5B9A\u3057\u3001\u4F7F\u7528\u4E2D\u306F\u5909\u66F4\u3057\u306A\
    \u3044\u3002\n        ## N=0 \u3082\u5BFE\u5FDC\u3002\u30AA\u30D6\u30B8\u30A7\u30AF\
    \u30C8\u306F\u5FC5\u305A\u3053\u306E\u30B3\u30F3\u30B9\u30C8\u30E9\u30AF\u30BF\
    \u3067\u751F\u6210\u3059\u308B\u3002\n        ## \u5E45 B=floor(sqrt(N))+1 \u3068\
    \u3057\u3066 S(aB,bB)/2^(aB), 0<=b<=a \u3092\u4FDD\u5B58\u3059\u308B\u3002\n \
    \       ## \u8868\u306F m(m+1)/2 \u8981\u7D20\uFF08m=floor(N/B)+1\uFF09\u3067\
    \ O(N+1) \u7A7A\u9593\u3002\n        ## \u534A\u884C\u8D70\u67FB\u306B\u3088\u308A\
    \ O(N+N^2/B) \u6642\u9593\u3002\u30AF\u30A8\u30EA\u5217\u306E\u4E8B\u524D\u53D6\
    \u5F97\u30FB\u6574\u5217\u306F\u4E0D\u8981\u3002\n        if maxN < 0 or uint64(maxN)\
    \ >= uint64(ModInt.umod()):\n            raise newException(ValueError, \"0 <=\
    \ maxN < \u6CD5 \u304C\u5FC5\u8981\u3067\u3059\uFF08\u6CD5\u306F\u7D20\u6570\uFF09\
    \")\n        result.maxN = maxN\n        result.width = isqrt(maxN) + 1\n    \
    \    result.modulus = uint32(ModInt.umod())\n        let combination = initCombination[ModInt](maxN)\n\
    \        result.fact = combination.fact\n        result.factInv = combination.fact_inv\n\
    \        result.powersOfTwo = newSeq[ModInt](maxN + 1)\n        result.powersOfTwo[0]\
    \ = 1\n        for n in 1..maxN:\n            result.powersOfTwo[n] = result.powersOfTwo[n\
    \ - 1] * 2\n        # \u6CD5\u304C2\u306A\u3089 n<=1 \u3067\u3042\u308A\u3001\u30AF\
    \u30A8\u30EA\u306F\u3059\u3079\u3066\u7AEF\u70B9\u306E\u5206\u5C90\u3067\u51E6\
    \u7406\u3067\u304D\u308B\u3002\n        if result.modulus == 2:\n            return\n\
    \        let half = ModInt(int((uint64(result.modulus) + 1) div 2))\n        var\
    \ inversePowersOfTwo = newSeq[ModInt](maxN + 1)\n        inversePowersOfTwo[0]\
    \ = 1\n        for n in 1..maxN:\n            inversePowersOfTwo[n] = inversePowersOfTwo[n\
    \ - 1] * half\n        result.halfScaledFact = newSeq[ModInt](maxN + 1)\n    \
    \    for n in 0..maxN:\n            result.halfScaledFact[n] = result.fact[n]\
    \ * inversePowersOfTwo[n] * half\n        result.samples = newSeq[seq[ModInt]](maxN\
    \ div result.width + 1)\n        for row in 0..<result.samples.len:\n        \
    \    let n = row * result.width\n            result.samples[row] = newSeq[ModInt](row\
    \ + 1)\n            let rowFact = result.fact[n]\n            var sum: ModInt\
    \ = 0\n            var nextLow = 0\n            var lowColumn = 0\n          \
    \  var nextHigh = result.width - 1\n            var highColumn = row - 1\n   \
    \         result.samples[row][row] = result.powersOfTwo[n]\n            # n! \u306F\
    \u4FDD\u5B58\u6642\u3060\u3051\u639B\u3051\u3001\u524D\u534A\u306E\u548C\u304B\
    \u3089\u5BFE\u79F0\u306A\u5F8C\u534A\u306E prefix \u3082\u6C42\u3081\u308B\u3002\
    \n            for k in 0..(n div 2):\n                sum += result.factInv[k]\
    \ * result.factInv[n - k]\n                if k == nextLow:\n                \
    \    result.samples[row][lowColumn] = sum * rowFact\n                    inc lowColumn\n\
    \                    nextLow += result.width\n                # \u53CD\u5C04\u5143\
    \u306F (row - \u5217\u756A\u53F7) * width - 1\u3002\u5270\u4F59\u8A08\u7B97\u305B\
    \u305A\u6B21\u306E\u4F4D\u7F6E\u3092\u6301\u3064\u3002\n                if highColumn\
    \ >= 0 and k == nextHigh:\n                    result.samples[row][highColumn]\
    \ = result.powersOfTwo[n] - sum * rowFact\n                    dec highColumn\n\
    \                    nextHigh += result.width\n            for column in 0..row:\n\
    \                result.samples[row][column] *= inversePowersOfTwo[n]\n\n    proc\
    \ prefixSum*[ModInt](self: OnlineCombinationPrefixSum[ModInt], n, k: int): ModInt\
    \ =\n        ## sum(i=0..k, nCi)\uFF08\u53F3\u7AEF\u3092\u542B\u3080\uFF09\u3092\
    \ O(sqrt(N)) \u6642\u9593\u3001O(1) \u88DC\u52A9\u7A7A\u9593\u3067\u8FD4\u3059\
    \u3002\n        ## k<0 \u306F0\u3001k>=n \u306F2^n\u3002k \u306F\u4EFB\u610F\u306E\
    \ int \u3092\u53D7\u3051\u53D6\u308B\u3002\n        ## n \u304C [0,maxN] \u5916\
    \u3001\u307E\u305F\u306F\u73FE\u5728\u306E\u6CD5\u304C\u69CB\u7BC9\u6642\u3068\
    \u7570\u306A\u308B\u5834\u5408\u306F ValueError\u3002\n        ## \u8FD1\u3044\
    \u4FDD\u5B58\u70B9\u304B\u3089 n,k \u306E\u5404\u65B9\u5411\u3078\u79FB\u52D5\u3059\
    \u308B\u3002\u7AEF\u306E\u30D6\u30ED\u30C3\u30AF\u3092\u9664\u304D\u5404\u65B9\
    \u5411\u3067\u7D04B/2\u56DE\u4EE5\u5185\u3002\n        if n < 0 or n > self.maxN:\n\
    \            raise newException(ValueError, \"0 <= n <= maxN \u304C\u5FC5\u8981\
    \u3067\u3059\")\n        if uint32(ModInt.umod()) != self.modulus:\n         \
    \   raise newException(ValueError, \"\u69CB\u7BC9\u5F8C\u306B\u6CD5\u3092\u5909\
    \u66F4\u3057\u3066\u306F\u3044\u3051\u307E\u305B\u3093\")\n        if k < 0:\n\
    \            return ModInt(0)\n        if k >= n:\n            return self.powersOfTwo[n]\n\
    \        if k == 0:\n            return ModInt(1)\n        let\n            row\
    \ = min((n + self.width div 2) div self.width, self.samples.len - 1)\n       \
    \     column = min((k + self.width div 2) div self.width, row)\n            baseN\
    \ = row * self.width\n            baseK = column * self.width\n        result\
    \ = self.samples[row][column]\n        # S(x+1,k)/2^(x+1) = S(x,k)/2^x - x!/(2^(x+1)\
    \ k! (x-k)!)\u3002\n        var sum: ModInt = 0\n        if baseN <= n:\n    \
    \        for x in baseN..<n:\n                sum += self.halfScaledFact[x] *\
    \ self.factInv[x - baseK]\n            result -= sum * self.factInv[baseK]\n \
    \       else:\n            for x in max(n, baseK)..<baseN:\n                sum\
    \ += self.halfScaledFact[x] * self.factInv[x - baseK]\n            result += sum\
    \ * self.factInv[baseK]\n        result *= self.powersOfTwo[n]\n        sum =\
    \ 0\n        if baseK <= k:\n            for y in (baseK + 1)..k:\n          \
    \      sum += self.factInv[y] * self.factInv[n - y]\n            result += sum\
    \ * self.fact[n]\n        else:\n            for y in (k + 1)..min(baseK, n):\n\
    \                sum += self.factInv[y] * self.factInv[n - y]\n            result\
    \ -= sum * self.fact[n]\n\n    proc rangeSum*[ModInt](self: OnlineCombinationPrefixSum[ModInt],\
    \ n, l, r: int): ModInt =\n        ## sum(i=l..<r, nCi)\uFF08\u53F3\u7AEF\u3092\
    \u542B\u307E\u306A\u3044\uFF09\u3092 O(sqrt(N)) \u6642\u9593\u3067\u8FD4\u3059\
    \u3002l >= r \u306A\u3089 0\u3002\n        ## [0,n] \u5916\u306E\u9805\u306F0\u3002\
    l,r \u306F low(int), high(int) \u3092\u542B\u3080\u4EFB\u610F\u306E int\u3002\n\
    \        ## \u7A7A\u30FB\u9006\u8EE2\u533A\u9593\u3067\u3082 n \u3068\u73FE\u5728\
    \u306E\u6CD5\u3092\u691C\u67FB\u3059\u308B\u3002\u88DC\u52A9\u7A7A\u9593 O(1)\u3002\
    \n        let right = self.prefixSum(n, if r <= 0: -1 else: r - 1)\n        if\
    \ l >= r:\n            return ModInt(0)\n        let left = self.prefixSum(n,\
    \ if l <= 0: -1 else: l - 1)\n        return right - left\n"
  dependsOn:
  - cplib/math/combination.nim
  - cplib/math/combination.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  isVerificationFile: false
  path: cplib/math/online_combination_prefix_sum.nim
  requiredBy: []
  timestamp: '2026-10-26 00:17:02+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/online_combination_prefix_sum_yosupo_test.nim
  - verify/math/online_combination_prefix_sum_yosupo_test.nim
  - verify/math/online_combination_prefix_sum_test.nim
  - verify/math/online_combination_prefix_sum_test.nim
documentation_of: cplib/math/online_combination_prefix_sum.nim
layout: document
redirect_from:
- /library/cplib/math/online_combination_prefix_sum.nim
- /library/cplib/math/online_combination_prefix_sum.nim.html
title: cplib/math/online_combination_prefix_sum.nim
---
