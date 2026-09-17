---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
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
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primitive_root.nim
    title: cplib/math/primitive_root.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primitive_root.nim
    title: cplib/math/primitive_root.nim
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
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/modfast_test.nim
    title: verify/math/modfast_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/modfast_test.nim
    title: verify/math/modfast_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://maspypy.com/o1-mod-inv-mod-pow
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_MODFAST:\n    ## \u7D20\u6570\u6CD5\u306E\u9006\
    \u5143\u30FB\u539F\u59CB\u6839\u3092\u5E95\u3068\u3059\u308B\u96E2\u6563\u5BFE\
    \u6570\u30FB\u7D2F\u4E57\u3092\u3001\u524D\u8A08\u7B97\u5F8C O(1) \u3067\u6C42\
    \u3081\u308B\u3002\n    ## \u4F7F\u7528\u4F8B: let table = initModFast[modint1000000007_barrett]()\n\
    \    ## table.inv(2), table.log(2), table.pow(2, 100), table.powRoot(100)\n  \
    \  ## log \u306E\u5E95\u306F table.root \u3067\u53D6\u5F97\u3059\u308B\u3002\u5E95\
    \u306F\u69CB\u7BC9\u3054\u3068\u306B\u7570\u306A\u308B\u5834\u5408\u304C\u3042\
    \u308B\u3002\n    const CPLIB_MATH_MODFAST* = 1\n\n    import random\n    import\
    \ cplib/math/primitive_root\n    import cplib/modint/modint\n\n    # https://maspypy.com/o1-mod-inv-mod-pow\n\
    \    # 64 bit \u74B0\u5883\u7528\u3002\u6CD5\u306F 2 <= p < 2^30 \u306E\u7D20\u6570\
    \u3092\u6307\u5B9A\u3059\u308B\u3002\n    type ModFast*[T: BarrettModint or MontgomeryModint]\
    \ = object\n        modulus, generator, bucketShift, powerShift: int\n       \
    \ fractions: seq[tuple[a, b: uint16]]\n        logarithms, powerLow, powerHigh:\
    \ seq[uint32]\n\n    proc p*[T](self: ModFast[T]): int {.inline.} =\n        ##\
    \ \u69CB\u7BC9\u6642\u306E\u7D20\u6570\u6CD5\u3092\u8FD4\u3059\u3002O(1)\u3002\
    \n        self.modulus\n\n    proc checkModulus[T](self: ModFast[T]) {.inline.}\
    \ =\n        ## \u52D5\u7684 modint \u306E\u6CD5\u304C\u69CB\u7BC9\u6642\u304B\
    \u3089\u5909\u308F\u3063\u3066\u3044\u306A\u3044\u3053\u3068\u3092\u78BA\u8A8D\
    \u3059\u308B\u3002O(1)\u3002\n        assert self.modulus == T.umod.int, \"\u69CB\
    \u7BC9\u6642\u3068\u540C\u3058\u6CD5\u3092\u4F7F\u7528\u3057\u3066\u304F\u3060\
    \u3055\u3044\"\n\n    proc root*[T](self: ModFast[T]): T {.inline.} =\n      \
    \  ## \u5BFE\u6570\u306E\u5E95\u3068\u3057\u3066\u4F7F\u3046\u539F\u59CB\u6839\
    \u3092\u8FD4\u3059\u3002O(1)\u3002\n        self.checkModulus()\n        init(T,\
    \ self.generator)\n\n    proc powerRaw[T](self: ModFast[T], exponent: int): int\
    \ {.inline.} =\n        ## 0 <= exponent < p-1 \u306B\u5BFE\u3057\u3066\u539F\u59CB\
    \u6839\u306E\u7D2F\u4E57\u3092\u8FD4\u3059\u3002O(1)\u3002\n        int(self.powerLow[exponent\
    \ and ((1 shl self.powerShift) - 1)]) *\n            int(self.powerHigh[exponent\
    \ shr self.powerShift]) mod self.modulus\n\n    proc powRoot*[T](self: ModFast[T],\
    \ exponent: int): T {.inline.} =\n        ## \u539F\u59CB\u6839\u306E exponent\
    \ \u4E57\u3092\u8FD4\u3059\u3002\u8CA0\u306E\u6307\u6570\u3082\u8A31\u3059\u3002\
    O(1)\u3002\n        self.checkModulus()\n        var e = exponent mod (self.modulus\
    \ - 1)\n        if e < 0: e += self.modulus - 1\n        init(T, self.powerRaw(e))\n\
    \n    proc log*[T](self: ModFast[T], x: T or int): int {.inline.} =\n        ##\
    \ 1 <= x < p \u306E\u539F\u59CB\u6839\u3092\u5E95\u3068\u3059\u308B\u96E2\u6563\
    \u5BFE\u6570\u3092 [0,p-2] \u3067\u8FD4\u3059\u3002O(1)\u3002\n        self.checkModulus()\n\
    \        let x = when x is int: x else: x.val\n        assert 1 <= x and x < self.modulus\n\
    \        let fraction = self.fractions[x shr self.bucketShift]\n        let a\
    \ = x * int(fraction.b) - self.modulus * int(fraction.a)\n        result = int(self.logarithms[abs(a)])\
    \ - int(self.logarithms[int(fraction.b)])\n        if a < 0: result += (self.modulus\
    \ - 1) div 2\n        if result < 0: result += self.modulus - 1\n        if result\
    \ >= self.modulus - 1: result -= self.modulus - 1\n\n    proc inv*[T](self: ModFast[T],\
    \ x: T or int): T {.inline.} =\n        ## 1 <= x < p \u306E\u9006\u5143\u3092\
    \u8FD4\u3059\u3002\u5BFE\u6570\u8868\u3068\u7D2F\u4E57\u8868\u3092\u5171\u6709\
    \u3057 O(1)\u3002\n        let e = self.log(x)\n        init(T, self.powerRaw(if\
    \ e == 0: 0 else: self.modulus - 1 - e))\n\n    proc pow*[T](self: ModFast[T],\
    \ x: T or int, exponent: int): T {.inline.} =\n        ## 0 <= x < p \u306E\u7D2F\
    \u4E57\u3092 O(1) \u3067\u8FD4\u3059\u3002\u8CA0\u306E\u6307\u6570\u3082\u8A31\
    \u3059\u304C 0 \u306E\u8CA0\u4E57\u306F\u4E0D\u53EF\u30020^0=1\u3002\n       \
    \ self.checkModulus()\n        let x = when x is int: x else: x.val\n        assert\
    \ 0 <= x and x < self.modulus\n        if x == 0:\n            assert exponent\
    \ >= 0\n            return init(T, int(exponent == 0))\n        var e = exponent\
    \ mod (self.modulus - 1)\n        if e < 0: e += self.modulus - 1\n        init(T,\
    \ self.powerRaw(self.log(x) * e mod (self.modulus - 1)))\n\n    proc buildFractions[T](self:\
    \ var ModFast[T]): int =\n        ## Farey \u6570\u5217\u304B\u3089\u8FD1\u4F3C\
    \u5206\u6570\u8868\u3092 O(p^(2/3)) \u3067\u4F5C\u308A\u3001\u5FC5\u8981\u306A\
    \u5BFE\u6570\u8868\u306E\u4E0A\u9650\u3092\u8FD4\u3059\u3002\n        let p =\
    \ self.modulus\n        var n = 1\n        while n * n * n < p:\n            n\
    \ *= 2\n            inc self.bucketShift\n        self.fractions = newSeq[tuple[a,\
    \ b: uint16]]((p shr self.bucketShift) + 1)\n        var (a, b, c, d) = (0, 1,\
    \ 1, n)\n        while c <= n:\n            let left = (a * p div b) shr self.bucketShift\n\
    \            let right = (c * p div d) shr self.bucketShift\n            let fraction\
    \ = if b <= d: (uint16(a), uint16(b)) else: (uint16(c), uint16(d))\n         \
    \   for j in left..right: self.fractions[j] = fraction\n            if c == d:\
    \ break\n            let k = (n + b) div d\n            (a, b, c, d) = (c, d,\
    \ k * c - a, k * d - b)\n        # \u5404\u30D0\u30B1\u30C3\u30C8\u306E\u7AEF\u70B9\
    \u3067 |bx-ap| \u3092\u8A55\u4FA1\u3057\u3001\u5B9F\u969B\u306B\u5FC5\u8981\u306A\
    \u9818\u57DF\u3060\u3051\u78BA\u4FDD\u3059\u308B\u3002\n        for j, fraction\
    \ in self.fractions:\n            let lo = max(1, j shl self.bucketShift)\n  \
    \          let hi = min(p - 1, ((j + 1) shl self.bucketShift) - 1)\n         \
    \   if lo > hi: continue\n            result = max(result, int(fraction.b))\n\
    \            result = max(result, abs(lo * int(fraction.b) - p * int(fraction.a)))\n\
    \            result = max(result, abs(hi * int(fraction.b) - p * int(fraction.a)))\n\
    \n    proc buildLogarithms[T](self: var ModFast[T], limit: int) =\n        ##\
    \ \u5C0F\u7D20\u6570\u306E\u5BFE\u6570\u3092\u4E71\u629E\u3067\u6C42\u3081\u3001\
    \u5408\u6210\u6570\u3068\u5927\u304D\u306A\u7D20\u6570\u306E\u5BFE\u6570\u3092\
    \u6F38\u5316\u5F0F\u3067\u57CB\u3081\u308B\u3002\n        let p = self.modulus\n\
    \        let order = p - 1\n        self.logarithms = newSeq[uint32](limit + 1)\n\
    \        var least = newSeq[uint32](limit + 1)\n        for i in 2..limit:\n \
    \           if least[i] != 0: continue\n            least[i] = uint32(i)\n   \
    \         if i * i <= limit:\n                var j = i * i\n                while\
    \ j <= limit:\n                    if least[j] == 0: least[j] = uint32(i)\n  \
    \                  j += i\n\n        let step = min(order, 4 shl self.powerShift)\n\
    \        var capacity = 1\n        while capacity < 2 * step: capacity *= 2\n\
    \        var keys = newSeq[uint32](capacity)\n        var values = newSeq[uint32](capacity)\n\
    \        proc slot(x: int): int =\n            ## \u5270\u4F59\u5024\u3092\u5C02\
    \u7528\u30CF\u30C3\u30B7\u30E5\u8868\u306E\u6DFB\u5B57\u306B\u5909\u63DB\u3059\
    \u308B\u3002O(1)\u3002\n            int((uint32(x) * 2654435761u32) and uint32(capacity\
    \ - 1))\n        var value = 1\n        for e in 0..<step:\n            var h\
    \ = slot(value)\n            while keys[h] != 0: h = (h + 1) and (capacity - 1)\n\
    \            keys[h] = uint32(value)\n            values[h] = uint32(e)\n    \
    \        value = value * self.generator mod p\n        let giant = self.powerRaw((order\
    \ - step) mod order)\n        proc bsgs(x: int): int =\n            ## \u5171\u901A\
    \u306E baby step \u8868\u3067\u96E2\u6563\u5BFE\u6570\u3092\u6C42\u3081\u308B\u3002\
    \u671F\u5F85 O(p/step)\u3002\n            var x = x\n            var offset =\
    \ 0\n            while offset < order:\n                var h = slot(x)\n    \
    \            while keys[h] != 0:\n                    if int(keys[h]) == x: return\
    \ (offset + int(values[h])) mod order\n                    h = (h + 1) and (capacity\
    \ - 1)\n                x = x * giant mod p\n                offset += step\n\
    \            raise newException(ValueError, \"\u6CD5\u307E\u305F\u306F\u539F\u59CB\
    \u6839\u304C\u4E0D\u6B63\u3067\u3059\")\n\n        var rng = initRand(20260914)\n\
    \        for i in 2..limit:\n            if i * i > p:\n                self.logarithms[i]\
    \ = uint32((int(self.logarithms[p mod i]) +\n                    order div 2 +\
    \ order - int(self.logarithms[p div i])) mod order)\n            elif int(least[i])\
    \ < i:\n                self.logarithms[i] = uint32((int(self.logarithms[int(least[i])])\
    \ +\n                    int(self.logarithms[i div int(least[i])])) mod order)\n\
    \            elif i < 100:\n                self.logarithms[i] = uint32(bsgs(i))\n\
    \            else:\n                var found = false\n                for attempt\
    \ in 0..<128:\n                    let e = rng.rand(order - 1)\n             \
    \       var x = i * self.powerRaw(e) mod p\n                    var answer = order\
    \ - e\n                    for q in [2, 3, 5, 7, 11, 13, 17, 19]:\n          \
    \              while x mod q == 0:\n                            x = x div q\n\
    \                            answer += int(self.logarithms[q])\n             \
    \       if x > limit: continue\n                    while x >= i and int(least[x])\
    \ < i:\n                        let q = int(least[x])\n                      \
    \  x = x div q\n                        answer += int(self.logarithms[q])\n  \
    \                  if x < i:\n                        answer += int(self.logarithms[x])\n\
    \                        self.logarithms[i] = uint32(answer mod order)\n     \
    \                   found = true\n                        break\n            \
    \    if not found: self.logarithms[i] = uint32(bsgs(i))\n\n    proc initModFast*[T:\
    \ BarrettModint or MontgomeryModint](): ModFast[T] =\n        ## \u7D20\u6570\
    \ 2 <= p < 2^30 \u7528\u306E O(1) inv/log/pow \u3092\u69CB\u7BC9\u3059\u308B\u3002\
    64 bit \u74B0\u5883\u7528\u3002\n        ## \u7A7A\u9593 O(p^(2/3))\u3002\u69CB\
    \u7BC9\u306F\u7BE9\u30FB\u5206\u6570\u8868 O(p^(2/3) log log p) \u3068\u5C0F\u7D20\
    \u6570\u306E\u96E2\u6563\u5BFE\u6570\u3002\n        ## \u4E71\u629E\u306B\u3088\
    \u308B\u9AD8\u901F\u5316\u306F 128 \u56DE\u3067\u6253\u3061\u5207\u308A\u3001\u672A\
    \u89E3\u6C7A\u306A\u3089 BSGS \u3067\u78BA\u5B9F\u306B\u6C42\u3081\u308B\u3002\
    \n        ## BSGS \u306B\u89E3\u6C7A\u3092\u4EFB\u305B\u305F\u5834\u5408\u306E\
    \u69CB\u7BC9\u6642\u9593\u306F\u3001\u30CF\u30C3\u30B7\u30E5\u8868\u306E\u671F\
    \u5F85\u8A08\u7B97\u91CF\u3067 O(p/log p + p^(2/3) log log p)\u3002\n        ##\
    \ \u6CD5\u306F T.umod \u304B\u3089\u53D6\u5F97\u3059\u308B\u3002\u52D5\u7684 modint\
    \ \u306F\u5148\u306B setMod \u3057\u3001\u4F7F\u7528\u4E2D\u306F\u6CD5\u3092\u5909\
    \u66F4\u3057\u306A\u3044\u3002\n        let p = T.umod.int\n        assert sizeof(int)\
    \ >= 8\n        assert 2 <= p and p < (1 shl 30)\n        result.modulus = p\n\
    \        result.generator = if p == 2: 1 else: primitive_root(p)\n        var\
    \ width = 1\n        while width * width < p - 1:\n            width *= 2\n  \
    \          inc result.powerShift\n        result.powerLow = newSeq[uint32](width)\n\
    \        result.powerHigh = newSeq[uint32]((p - 2) div width + 1)\n        var\
    \ value = 1\n        for i in 0..<width:\n            result.powerLow[i] = uint32(value)\n\
    \            value = value * result.generator mod p\n        let stride = value\n\
    \        value = 1\n        for i in 0..<result.powerHigh.len:\n            result.powerHigh[i]\
    \ = uint32(value)\n            value = value * stride mod p\n        if p <= 64:\n\
    \            result.fractions = newSeq[tuple[a, b: uint16]](p)\n            result.logarithms\
    \ = newSeq[uint32](p)\n            value = 1\n            for e in 0..<p - 1:\n\
    \                result.fractions[value] = (0u16, 1u16)\n                result.logarithms[value]\
    \ = uint32(e)\n                value = value * result.generator mod p\n      \
    \  else:\n            let limit = result.buildFractions()\n            result.buildLogarithms(limit)\n"
  dependsOn:
  - cplib/str/run_length_encode.nim
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/math/primefactor.nim
  - cplib/math/powmod.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/primefactor.nim
  - cplib/math/isqrt.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/primitive_root.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inner_math.nim
  - cplib/modint/modint.nim
  - cplib/math/primitive_root.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: false
  path: cplib/math/modfast.nim
  requiredBy: []
  timestamp: '2026-09-14 18:23:55+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/modfast_test.nim
  - verify/math/modfast_test.nim
documentation_of: cplib/math/modfast.nim
layout: document
redirect_from:
- /library/cplib/math/modfast.nim
- /library/cplib/math/modfast.nim.html
title: cplib/math/modfast.nim
---
