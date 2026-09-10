---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/product_tree.nim
    title: cplib/fps/product_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/product_tree.nim
    title: cplib/fps/product_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/shift_of_sampling_points.nim
    title: cplib/fps/shift_of_sampling_points.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/shift_of_sampling_points.nim
    title: cplib/fps/shift_of_sampling_points.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/taylor_shift.nim
    title: cplib/fps/taylor_shift.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/taylor_shift.nim
    title: cplib/fps/taylor_shift.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
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
    path: verify/AI/many_factorials_test.nim
    title: verify/AI/many_factorials_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/many_factorials_test.nim
    title: verify/AI/many_factorials_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/many_factorials_online_test.nim
    title: verify/math/many_factorials_online_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/many_factorials_online_test.nim
    title: verify/math/many_factorials_online_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/many_factorials_test.nim
    title: verify/math/many_factorials_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/many_factorials_test.nim
    title: verify/math/many_factorials_test.nim
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
  code: "when not declared CPLIB_MATH_MANY_FACTORIALS:\n    const CPLIB_MATH_MANY_FACTORIALS*\
    \ = 1\n\n    import algorithm\n    import cplib/fps/formal_power_series\n    import\
    \ cplib/fps/product_tree\n    import cplib/fps/shift_of_sampling_points\n    import\
    \ cplib/fps/taylor_shift\n    import cplib/modint/modint\n\n    type LargeFactorial*[T]\
    \ = object\n        modulus: uint32\n        maxN, blockSize: int\n        blocks:\
    \ seq[T]\n\n    proc factorialBlocks[T: BarrettModint or MontgomeryModint](\n\
    \            blockSize, blockCount: int): seq[T] =\n        ## B \u304C 2 \u306E\
    \u51AA\u306E\u3068\u304D\u3001(iB)! \u306E\u8868\u3092 O(M(B+blockCount)) \u3067\
    \u4F5C\u308B\u3002\n        var samples = @[init(T, 1)]\n        var width = 1\n\
    \        while width < blockSize:\n            # samples[j] \u306F (j*width+1)\
    \ \u304B\u3089 (j*width+width-1) \u307E\u3067\u306E\u7A4D\u3002\n            let\
    \ extended = samples & shiftOfSamplingPoints(\n                samples, init(T,\
    \ width), 3 * width)\n            var next = newSeq[T](2 * width)\n          \
    \  for i in 0..<next.len:\n                next[i] = extended[2 * i] * extended[2\
    \ * i + 1] *\n                    init(T, (2 * i + 1) * width)\n            samples\
    \ = move(next)\n            width *= 2\n        if blockCount > blockSize:\n \
    \           let extended = shiftOfSamplingPoints(\n                samples, init(T,\
    \ blockSize), blockCount - blockSize)\n            samples.add(extended)\n   \
    \     result = newSeq[T](blockCount + 1)\n        result[0] = init(T, 1)\n   \
    \     for i in 0..<blockCount:\n            result[i + 1] = result[i] * samples[i]\
    \ * init(T, (i + 1) * blockSize)\n\n    proc initLargeFactorial*[T: BarrettModint\
    \ or MontgomeryModint](\n            maxN: int = -1, blockSize: int = 1024): LargeFactorial[T]\
    \ =\n        ## \u7D20\u6570\u6CD5 p \u3067\u4E0A\u9650 N \u307E\u3067\u306E\u968E\
    \u4E57\u8868\u3092 O(M(B+N/B)) \u3067\u524D\u8A08\u7B97\u3057\u3001O(1+N/B) \u8981\
    \u7D20\u3092\u4FDD\u5B58\u3059\u308B\u3002\n        ## maxN=-1 \u306F p-1\u3001\
    \u305D\u308C\u4EE5\u5916\u306F min(maxN,p-1) \u307E\u3067\u5BFE\u5FDC\u3059\u308B\
    \u3002\n        ## B=blockSize \u306F\u6B63\u306E 2 \u306E\u51AA\u3067\u3001\u4E0A\
    \u9650\u304C\u5C0F\u3055\u3044\u5834\u5408\u306F\u7E2E\u5C0F\u3059\u308B\u3002\
    \n        doAssert maxN >= -1, \"\u968E\u4E57\u306E\u4E0A\u9650\u306F -1 \u307E\
    \u305F\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308B\"\n \
    \       doAssert blockSize > 0 and (blockSize and (blockSize - 1)) == 0,\n   \
    \         \"\u30D6\u30ED\u30C3\u30AF\u9593\u9694\u306F\u6B63\u306E 2 \u306E\u51AA\
    \u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308B\"\n        let modulus = T.umod.int\n\
    \        doAssert modulus >= 2, \"\u6CD5\u306F 2 \u4EE5\u4E0A\u306E\u7D20\u6570\
    \u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308B\"\n        result.modulus = T.umod\n\
    \        result.maxN = if maxN == -1: modulus - 1 else: min(maxN, modulus - 1)\n\
    \        result.blockSize = blockSize\n        while result.blockSize > max(1,\
    \ result.maxN): result.blockSize = result.blockSize div 2\n        result.blocks\
    \ = factorialBlocks[T](result.blockSize, result.maxN div result.blockSize)\n\n\
    \    proc fact*[T](table: LargeFactorial[T], n: int): T =\n        ## n! \u3092\
    \u524D\u8A08\u7B97\u3057\u305F\u8868\u304B\u3089 O(B) \u3067\u6C42\u3081\u308B\
    \u3002n >= p \u306B\u306F 0 \u3092\u8FD4\u3057\u3001\u8CA0\u6570\u30FB\u4E0A\u9650\
    \u8D85\u904E\u30FB\u69CB\u7BC9\u6642\u3068\u7570\u306A\u308B\u6CD5\u306F\u4E0D\
    \u53EF\u3002\n        doAssert table.blocks.len > 0, \"\u968E\u4E57\u8868\u306F\
    \u521D\u671F\u5316\u3059\u308B\u5FC5\u8981\u304C\u3042\u308B\"\n        doAssert\
    \ table.modulus == T.umod, \"\u968E\u4E57\u8868\u306F\u69CB\u7BC9\u6642\u3068\u540C\
    \u3058\u6CD5\u3067\u4F7F\u7528\u3059\u308B\u5FC5\u8981\u304C\u3042\u308B\"\n \
    \       doAssert n >= 0, \"\u968E\u4E57\u306E\u5F15\u6570\u306F\u975E\u8CA0\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308B\"\n        if n >= table.modulus.int:\
    \ return init(T, 0)\n        doAssert n <= table.maxN, \"\u968E\u4E57\u306E\u5F15\
    \u6570\u304C\u524D\u8A08\u7B97\u3057\u305F\u4E0A\u9650\u3092\u8D85\u3048\u3066\
    \u3044\u308B\"\n        let blockIndex = n div table.blockSize\n        result\
    \ = table.blocks[blockIndex]\n        for i in blockIndex * table.blockSize +\
    \ 1..n: result *= i\n\n    proc manyFactorials*[T: BarrettModint or MontgomeryModint](\n\
    \            ns: openArray[int]): seq[T] =\n        ## \u7D20\u6570 p \u3092\u6CD5\
    \u3068\u3059\u308B ns[i]! \u3092\u5165\u529B\u9806\u306B\u8FD4\u3059\u3002\u8CA0\
    \u6570\u306F\u4E0D\u53EF\u3001ns[i] >= p \u306B\u306F 0 \u3092\u8FD4\u3059\u3002\
    \n        ## NTT \u4F7F\u7528\u6642 O(sqrt(p) log p + Q log Q + Q log^3 p)\u3001\
    Q = ns.len\u3002\n        result = newSeq[T](ns.len)\n        let modulus = T.umod.int\n\
    \        var maxN = -1\n        for n in ns:\n            doAssert n >= 0, \"\u968E\
    \u4E57\u306E\u5F15\u6570\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308B\"\n            if n < modulus: maxN = max(maxN, n)\n        if maxN\
    \ < 0: return\n\n        const directFactorialLimit = 1024\n        if maxN <=\
    \ directFactorialLimit:\n            var fact = newSeq[T](maxN + 1)\n        \
    \    fact[0] = init(T, 1)\n            for i in 1..maxN: fact[i] = fact[i - 1]\
    \ * i\n            for i, n in ns:\n                if n < modulus: result[i]\
    \ = fact[n]\n            return\n\n        var blockSize = 1\n        while blockSize\
    \ * blockSize <= maxN: blockSize *= 2\n        let blocks = factorialBlocks[T](blockSize,\
    \ maxN div blockSize)\n        type Query = tuple[n, index: int]\n        var\
    \ queries = newSeqOfCap[Query](ns.len)\n        for i, n in ns:\n            if\
    \ n < modulus:\n                result[i] = blocks[n div blockSize]\n        \
    \        queries.add((n, i))\n        queries.sort(proc(a, b: Query): int = cmp(a.n,\
    \ b.n))\n\n        var polynomial = @[init(T, 1), init(T, 1)]\n        var width\
    \ = 1\n        while width < blockSize:\n            # polynomial \u306F (x+1)...(x+width)\u3001\
    \u5404\u533A\u9593\u306E\u59CB\u70B9\u306F 2*width \u306E\u500D\u6570\u3002\n\
    \            const directProductLimit = 32\n            if width <= directProductLimit:\n\
    \                for query in queries:\n                    if (query.n and width)\
    \ == 0: continue\n                    let start = query.n - query.n mod (2 * width)\n\
    \                    var product = init(T, 1)\n                    for i in 1..width:\
    \ product *= start + i\n                    result[query.index] *= product\n \
    \           else:\n                var points: seq[T]\n                var previous\
    \ = -1\n                for query in queries:\n                    if (query.n\
    \ and width) == 0: continue\n                    let start = query.n - query.n\
    \ mod (2 * width)\n                    if start != previous:\n               \
    \         points.add(init(T, start))\n                        previous = start\n\
    \                var values = newSeq[T](points.len)\n                var first\
    \ = 0\n                while first < points.len:\n                    let last\
    \ = min(first + width, points.len)\n                    let evaluated = multipointEvaluation(polynomial,\
    \ points[first..<last])\n                    for i in 0..<evaluated.len: values[first\
    \ + i] = evaluated[i]\n                    first = last\n                var pointIndex\
    \ = -1\n                previous = -1\n                for query in queries:\n\
    \                    if (query.n and width) == 0: continue\n                 \
    \   let start = query.n - query.n mod (2 * width)\n                    if start\
    \ != previous:\n                        inc pointIndex\n                     \
    \   previous = start\n                    result[query.index] *= values[pointIndex]\n\
    \            if 2 * width < blockSize:\n                polynomial = polynomial\
    \ * taylorShift(polynomial, init(T, width))\n            width *= 2\n"
  dependsOn:
  - cplib/math/inner_math.nim
  - cplib/math/isqrt.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/powmod.nim
  - cplib/math/inv_gcd.nim
  - cplib/fps/formal_power_series.nim
  - cplib/math/inner_math.nim
  - cplib/math/isqrt.nim
  - cplib/fps/taylor_shift.nim
  - cplib/fps/shift_of_sampling_points.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/powmod.nim
  - cplib/fps/taylor_shift.nim
  - cplib/math/isprime.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/modint.nim
  - cplib/fps/product_tree.nim
  - cplib/convolution/convolution.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/product_tree.nim
  - cplib/fps/shift_of_sampling_points.nim
  isVerificationFile: false
  path: cplib/math/many_factorials.nim
  requiredBy: []
  timestamp: '2026-09-10 05:48:00+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/many_factorials_online_test.nim
  - verify/math/many_factorials_online_test.nim
  - verify/math/many_factorials_test.nim
  - verify/math/many_factorials_test.nim
  - verify/AI/many_factorials_test.nim
  - verify/AI/many_factorials_test.nim
documentation_of: cplib/math/many_factorials.nim
layout: document
redirect_from:
- /library/cplib/math/many_factorials.nim
- /library/cplib/math/many_factorials.nim.html
title: cplib/math/many_factorials.nim
---
