---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/min_plus_convolution.nim
    title: cplib/convolution/min_plus_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/min_plus_convolution.nim
    title: cplib/convolution/min_plus_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/monotone_minima.nim
    title: cplib/utils/monotone_minima.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/monotone_minima.nim
    title: cplib/utils/monotone_minima.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/smawk.nim
    title: cplib/utils/smawk.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/smawk.nim
    title: cplib/utils/smawk.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import cplib/convolution/min_plus_convolution\nimport cplib/utils/smawk\nimport\
    \ cplib/utils/monotone_minima\nimport random, algorithm\n\nproc naive[T](a, b:\
    \ seq[T]): seq[T] =\n    if a.len == 0 or b.len == 0: return @[]\n    result =\
    \ newSeq[T](a.len + b.len - 1)\n    for k in 0..<result.len:\n        let lo =\
    \ max(0, k - b.len + 1)\n        result[k] = a[lo] + b[k - lo]\n        for i\
    \ in lo + 1..min(k, a.len - 1):\n            result[k] = min(result[k], a[i] +\
    \ b[k - i])\n\nproc checkConvex[T](a, b: seq[T]) =\n    let expected = naive(a,\
    \ b)\n    doAssert minPlusConvolutionConvexArbitraryMonotoneMinima(a, b) == expected\n\
    \    doAssert minPlusConvolutionConvexArbitrarySmawk(a, b) == expected\n\nproc\
    \ checkConcave[T](a, b: seq[T]) =\n    doAssert minPlusConvolutionConcaveArbitrary(a,\
    \ b) == naive(a, b)\n\nvar rng = initRand(712367)\nproc convex(n: int): seq[int64]\
    \ =\n    if n == 0: return @[]\n    var slopes = newSeq[int](n - 1)\n    for x\
    \ in slopes.mitems: x = rng.rand(-30..30)\n    slopes.sort()\n    result = newSeq[int64](n)\n\
    \    result[0] = rng.rand(-100..100)\n    for i in 1..<n: result[i] = result[i\
    \ - 1] + slopes[i - 1]\n\nfor n in 0..45:\n    for m in 0..45:\n        for rep\
    \ in 0..<3:\n            let a = convex(n)\n            let b = convex(m)\n  \
    \          var arbitrary = newSeq[int64](m)\n            for x in arbitrary.mitems:\
    \ x = rng.rand(-500..500)\n            checkConvex(a, arbitrary)\n           \
    \ doAssert minPlusConvolutionConvexConvex(a, b) == naive(a, b)\n            var\
    \ ca = a\n            var cb = b\n            for x in ca.mitems: x = -x\n   \
    \         for x in cb.mitems: x = -x\n            checkConcave(ca, arbitrary)\n\
    \            doAssert minPlusConvolutionConcaveConcave(ca, cb) == naive(ca, cb)\n\
    \nfor n in 0..6:\n    var count = 1\n    for i in 0..<n: count *= 3\n    for mask\
    \ in 0..<count:\n        var a = newSeq[int](n)\n        var q = mask\n      \
    \  for x in a.mitems:\n            x = q mod 3 - 1\n            q = q div 3\n\
    \        var isConvex = true\n        var isConcave = true\n        for i in 2..<n:\n\
    \            isConvex = isConvex and a[i] - a[i - 1] >= a[i - 1] - a[i - 2]\n\
    \            isConcave = isConcave and a[i] - a[i - 1] <= a[i - 1] - a[i - 2]\n\
    \        for m in 0..8:\n            var b = newSeq[int](m)\n            for x\
    \ in b.mitems: x = rng.rand(-2..2)\n            if isConvex: checkConvex(a, b)\n\
    \            if isConcave: checkConcave(a, b)\n\ncheckConvex(@[low(int64), -1,\
    \ high(int64)], @[0'i64])\ncheckConcave(@[high(int64), 0, low(int64)], @[0'i64])\n\
    checkConvex(@[1.0, 0.5, 1.0], @[2.5, -1.0, 3.0])\ncheckConcave(@[-1.0, -0.5, -1.0],\
    \ @[2.5, -1.0, 3.0])\nfor n in [1, 2, 3, 127, 10000]:\n    for m in [1, 2, 3]:\n\
    \        let a = convex(n)\n        let b = convex(m)\n        checkConvex(a,\
    \ b)\n        checkConvex(b, a)\n        var ca = a\n        for x in ca.mitems:\
    \ x = -x\n        checkConcave(ca, b)\n        var cb = b\n        for x in cb.mitems:\
    \ x = -x\n        checkConcave(cb, a)\n\nfor h in 0..40:\n    for w in 0..40:\n\
    \        proc better(row, oldCol, newCol: int): bool =\n            (row - newCol)\
    \ * (row - newCol) < (row - oldCol) * (row - oldCol)\n        let s = smawk(h,\
    \ w, better)\n        doAssert monotoneMinima(h, w, better) == s\n        for\
    \ r in 0..<h: doAssert s[r] == (if w == 0: -1 else: min(r, w - 1))\n        proc\
    \ tied(row, oldCol, newCol: int): bool = false\n        for x in smawk(h, w, tied):\
    \ doAssert x == (if w == 0: -1 else: 0)\n        var matrix = newSeq[seq[int]](h)\n\
    \        for r in 0..<h:\n            matrix[r] = newSeq[int](w)\n           \
    \ var delta = rng.rand(-10..10)\n            for c in 0..<w:\n               \
    \ delta -= rng.rand(0..3)\n                matrix[r][c] = if r == 0: rng.rand(-100..100)\n\
    \                               else: matrix[r - 1][c] + delta\n        proc mongeBetter(row,\
    \ oldCol, newCol: int): bool =\n            matrix[row][newCol] < matrix[row][oldCol]\n\
    \        let minima = smawk(h, w, mongeBetter)\n        for r in 0..<h:\n    \
    \        var best = -1\n            for c in 0..<w:\n                if best ==\
    \ -1 or matrix[r][c] < matrix[r][best]: best = c\n            doAssert minima[r]\
    \ == best\nfor n in [31, 32, 33, 63, 64, 65, 127, 128, 129, 255, 256, 257, 513]:\n\
    \    for m in [33, 65, 129, 257]:\n        var a = convex(n)\n        for x in\
    \ a.mitems: x = -x\n        var b = newSeq[int64](m)\n        for x in b.mitems:\
    \ x = rng.rand(-10000..10000)\n        checkConcave(a, b)\n        for i in 0..<n:\
    \ a[i] = int64(i) * 3\n        checkConcave(a, b)\n        for x in a.mitems:\
    \ x = 0\n        for x in b.mitems: x = 0\n        checkConcave(a, b)\n\nwhen\
    \ defined(debug):\n    template rejects(body: untyped) =\n        block:\n   \
    \         var rejected = false\n            try:\n                discard body\n\
    \            except AssertionDefect:\n                rejected = true\n      \
    \      doAssert rejected\n\n    rejects(minPlusConvolutionConvexConvex(@[0, 2,\
    \ 3], @[0]))\n    rejects(minPlusConvolutionConvexConvex(@[0], @[0, 2, 3]))\n\
    \    rejects(minPlusConvolutionConvexArbitraryMonotoneMinima(@[0, 2, 3], @[0]))\n\
    \    rejects(minPlusConvolutionConvexArbitrarySmawk(@[0, 2, 3], @[0]))\n    rejects(minPlusConvolutionConcaveConcave(@[0,\
    \ 1, 3], @[0]))\n    rejects(minPlusConvolutionConcaveConcave(@[0], @[0, 1, 3]))\n\
    \    rejects(minPlusConvolutionConcaveArbitrary(@[0, 1, 3], @[0]))\n    rejects(minPlusConvolutionConvexArbitrarySmawk(@[low(int64),\
    \ 0, high(int64)], @[0'i64]))\n    rejects(minPlusConvolutionConcaveArbitrary(@[high(int64),\
    \ -1, low(int64)], @[0'i64]))\n    rejects(minPlusConvolutionConvexConvex(@[0,\
    \ 2, 3], newSeq[int]()))\n    rejects(minPlusConvolutionConcaveConcave(newSeq[int](),\
    \ @[0, 1, 3]))\n    checkConvex(@[0'u64, 0, high(uint64)], @[0'u64])\n    checkConcave(@[high(uint64),\
    \ high(uint64), 0'u64], @[0'u64])\n    checkConvex(@[low(int8), -1'i8, high(int8)],\
    \ @[0'i8])\n    checkConcave(@[high(int8), 0'i8, low(int8)], @[0'i8])\n\necho\
    \ \"Hello World\"\n"
  dependsOn:
  - cplib/convolution/min_plus_convolution.nim
  - cplib/utils/monotone_minima.nim
  - cplib/utils/smawk.nim
  - cplib/utils/monotone_minima.nim
  - cplib/convolution/min_plus_convolution.nim
  - cplib/utils/smawk.nim
  isVerificationFile: true
  path: verify/AI/min_plus_convolution_test.nim
  requiredBy: []
  timestamp: '2026-09-14 23:21:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/min_plus_convolution_test.nim
layout: document
redirect_from:
- /verify/verify/AI/min_plus_convolution_test.nim
- /verify/verify/AI/min_plus_convolution_test.nim.html
title: verify/AI/min_plus_convolution_test.nim
---
