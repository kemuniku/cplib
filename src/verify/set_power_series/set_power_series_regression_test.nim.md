---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/bitwise_and_convolution.nim
    title: cplib/convolution/bitwise_and_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/bitwise_and_convolution.nim
    title: cplib/convolution/bitwise_and_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/bitwise_or_convolution.nim
    title: cplib/convolution/bitwise_or_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/bitwise_or_convolution.nim
    title: cplib/convolution/bitwise_or_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/private/subset_convolution_barrett.nim
    title: cplib/convolution/private/subset_convolution_barrett.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/private/subset_convolution_barrett.nim
    title: cplib/convolution/private/subset_convolution_barrett.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/set_transform.nim
    title: cplib/convolution/set_transform.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/set_transform.nim
    title: cplib/convolution/set_transform.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/subset_convolution.nim
    title: cplib/convolution/subset_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/subset_convolution.nim
    title: cplib/convolution/subset_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/xor_convolution.nim
    title: cplib/convolution/xor_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/xor_convolution.nim
    title: cplib/convolution/xor_convolution.nim
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
  - icon: ':heavy_check_mark:'
    path: cplib/set_power_series/set_power_series.nim
    title: cplib/set_power_series/set_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/set_power_series/set_power_series.nim
    title: cplib/set_power_series/set_power_series.nim
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
    import random, sequtils\nimport cplib/modint/modint\nimport cplib/convolution/set_transform\n\
    import cplib/convolution/bitwise_or_convolution\nimport cplib/convolution/subset_convolution\n\
    import cplib/convolution/bitwise_and_convolution\nimport cplib/convolution/xor_convolution\n\
    import cplib/set_power_series/set_power_series\n\nproc naive[T](a, b: seq[T]):\
    \ seq[T] =\n    result = newSeq[T](a.len)\n    for mask in 0..<a.len:\n      \
    \  var sub = mask\n        while true:\n            result[mask] += a[sub] * b[mask\
    \ xor sub]\n            if sub == 0: break\n            sub = (sub - 1) and mask\n\
    \nproc naivePow[T](a: seq[T], e: int): seq[T] =\n    result = newSeq[T](a.len)\n\
    \    result[0] = init(T, 1)\n    for k in 0..<e: result = naive(result, a)\n\n\
    proc naiveInv[T](a: seq[T]): seq[T] =\n    result = newSeq[T](a.len)\n    result[0]\
    \ = a[0].inv\n    for mask in 1..<a.len:\n        var sub = mask\n        while\
    \ sub > 0:\n            result[mask] -= a[sub] * result[mask xor sub]\n      \
    \      sub = (sub - 1) and mask\n        result[mask] *= result[0]\n\nproc naiveSqrt[T](a:\
    \ seq[T], root: T): seq[T] =\n    result = newSeq[T](a.len)\n    result[0] = root\n\
    \    for mask in 1..<a.len:\n        var sum = init(T, 0)\n        var sub = (mask\
    \ - 1) and mask\n        while sub > 0:\n            sum += result[sub] * result[mask\
    \ xor sub]\n            sub = (sub - 1) and mask\n        result[mask] = (a[mask]\
    \ - sum) / (root * 2)\n\nproc naiveBinaryPower[T](a: seq[T], exponent: uint):\
    \ seq[T] =\n    result = newSeq[T](a.len)\n    result[0] = init(T, 1)\n    var\
    \ base = a\n    var e = exponent\n    while e > 0:\n        if (e and 1) != 0:\
    \ result = naive(result, base)\n        e = e shr 1\n        if e > 0: base =\
    \ naive(base, base)\n\nproc check[T](a, b: seq[T], n: int) =\n    let original\
    \ = a\n    var orOracle = newSeq[T](a.len)\n    for i in 0..<a.len:\n        for\
    \ j in 0..<a.len: orOracle[i or j] += a[i] * b[j]\n    doAssert bitwiseOrConvolution(a,\
    \ b) == orOracle\n    var subset = a\n    var superset = a\n    subsetZetaTransform(subset)\n\
    \    supersetZetaTransform(superset)\n    subsetMobiusTransform(subset)\n    supersetMobiusTransform(superset)\n\
    \    doAssert subset == a and superset == a\n    doAssert subsetConvolution(a,\
    \ b) == naive(a, b)\n    doAssert subsetConvolution(a, a) == naive(a, a)\n   \
    \ var f = newSeq[T](n + 8)\n    for k in 0..<f.len: f[k] = init(T, k * k + 3)\n\
    \    let actual = polynomialCompositeSetPowerSeries(f, a)\n    var expected =\
    \ newSeq[T](a.len)\n    for k in 0..<f.len:\n        let power = naivePow(a, k)\n\
    \        for mask in 0..<a.len: expected[mask] += power[mask] * f[k]\n    doAssert\
    \ actual == expected\n    let projection = setPowerProjection(a, b, f.len)\n \
    \   for k in 0..<f.len:\n        let power = naivePow(a, k)\n        var dot =\
    \ init(T, 0)\n        for mask in 0..<a.len: dot += power[mask] * b[mask]\n  \
    \      doAssert projection[k] == dot\n    var lhs, rhs = init(T, 0)\n    for mask\
    \ in 0..<a.len: lhs += b[mask] * actual[mask]\n    for k in 0..<f.len: rhs +=\
    \ f[k] * projection[k]\n    doAssert lhs == rhs\n    doAssert polynomialCompositeSetPowerSeries(newSeq[T](),\
    \ a) == newSeq[T](a.len)\n    doAssert setPowerProjection(a, b, 0).len == 0\n\
    \    for e in [0, 1, 2, n, n + 2]: doAssert setPow(a, e) == naivePow(a, e)\n \
    \   var unit = a\n    unit[0] = init(T, 1)\n    doAssert setInv(unit) == naiveInv(unit)\n\
    \    doAssert setPow(unit, -3) == naivePow(naiveInv(unit), 3)\n    var identity\
    \ = newSeq[T](a.len)\n    identity[0] = init(T, 1)\n    doAssert naive(setPow(unit,\
    \ low(int)), setPow(unit, high(int))) == naiveInv(unit)\n    doAssert setPow(a,\
    \ high(int)) == naiveBinaryPower(a, uint(high(int)))\n    doAssert setPow(unit,\
    \ low(int)) == naiveBinaryPower(naiveInv(unit), uint(high(int)) + 1u)\n    if\
    \ T.umod.int > n and T.umod.int > 2:\n        var nilpotent = a\n        nilpotent[0]\
    \ = init(T, 0)\n        let exp = setExp(nilpotent)\n        var expOracle = identity\n\
    \        var factInv = init(T, 1)\n        for k in 1..n:\n            factInv\
    \ /= k\n            let power = naivePow(nilpotent, k)\n            for mask in\
    \ 0..<a.len: expOracle[mask] += power[mask] * factInv\n        doAssert exp ==\
    \ expOracle\n        doAssert setLog(exp) == nilpotent\n        doAssert setExp(setLog(unit))\
    \ == unit\n        var logOracle = newSeq[T](a.len)\n        var delta = unit\n\
    \        delta[0] = init(T, 0)\n        for k in 1..n:\n            let power\
    \ = naivePow(delta, k)\n            let factor = init(T, (if k mod 2 == 1: 1 else:\
    \ -1)) / init(T, k)\n            for mask in 0..<a.len: logOracle[mask] += power[mask]\
    \ * factor\n        doAssert setLog(unit) == logOracle\n        let squared =\
    \ naive(unit, unit)\n        doAssert setSqrt(squared, init(T, 1)) == unit\n \
    \       doAssert setSqrt(unit, init(T, 1)) == naiveSqrt(unit, init(T, 1))\n  \
    \      let opposite = setSqrt(squared, init(T, -1))\n        for mask in 0..<a.len:\
    \ doAssert opposite[mask] == -unit[mask]\n    doAssert setSqrt(newSeq[T](a.len),\
    \ init(T, 0)) == newSeq[T](a.len)\n    doAssert a == original\n\nfor n in 0..3:\n\
    \    let size = 1 shl n\n    for encoding in 0..<(1 shl size):\n        let a\
    \ = (0..<size).toSeq.mapIt((encoding shr it) and 1)\n        var subset, superset\
    \ = a\n        subsetZetaTransform(subset)\n        supersetZetaTransform(superset)\n\
    \        for mask in 0..<size:\n            var lo, hi = 0\n            for sub\
    \ in 0..<size:\n                if (mask and sub) == sub: lo += a[sub]\n     \
    \           if (mask and sub) == mask: hi += a[sub]\n            doAssert subset[mask]\
    \ == lo and superset[mask] == hi\n        subsetMobiusTransform(subset)\n    \
    \    supersetMobiusTransform(superset)\n        doAssert subset == a and superset\
    \ == a\n        var expectedOr, expectedAnd, expectedXor = newSeq[int](size)\n\
    \        for i in 0..<size:\n            for j in 0..<size:\n                expectedOr[i\
    \ or j] += a[i] * a[j]\n                expectedAnd[i and j] += a[i] * a[j]\n\
    \                expectedXor[i xor j] += a[i] * a[j]\n        doAssert bitwiseOrConvolution(a,\
    \ a) == expectedOr\n        doAssert bitwiseAndConvolution(a, a) == expectedAnd\n\
    \        doAssert xorConvolution(a, a) == expectedXor\n        doAssert subsetConvolution(a,\
    \ a) == naive(a, a)\n\nvar rng = initRand(20261002)\nfor n in 0..6:\n    for trial\
    \ in 0..<8:\n        let a = newSeqWith(1 shl n, rng.rand(0..100))\n        let\
    \ b = newSeqWith(1 shl n, rng.rand(0..100))\n        check(a.mapIt(init(modint998244353_barrett,\
    \ it)), b.mapIt(init(modint998244353_barrett, it)), n)\n        check(a.mapIt(init(modint998244353_montgomery,\
    \ it)), b.mapIt(init(modint998244353_montgomery, it)), n)\n        modint_barrett.setMod(998244353)\n\
    \        check(a.mapIt(init(modint_barrett, it)), b.mapIt(init(modint_barrett,\
    \ it)), n)\n        modint_montgomery.setMod(998244353)\n        check(a.mapIt(init(modint_montgomery,\
    \ it)), b.mapIt(init(modint_montgomery, it)), n)\n\nproc checkUnitConstants[T](coefficients:\
    \ seq[int], constants: seq[int]) =\n    for c in constants:\n        var a = coefficients.mapIt(init(T,\
    \ it))\n        a[0] = init(T, c)\n        let original = a\n        doAssert\
    \ setInv(a) == naiveInv(a)\n        doAssert setPow(a, -3) == naivePow(naiveInv(a),\
    \ 3)\n        doAssert setPow(a, low(int)) == naiveBinaryPower(naiveInv(a), uint(high(int))\
    \ + 1u)\n        for scalarRoot in [init(T, c), init(T, -c)]:\n            var\
    \ root = coefficients.mapIt(init(T, it))\n            root[0] = scalarRoot\n \
    \           let squared = naive(root, root)\n            doAssert setSqrt(squared,\
    \ scalarRoot) == root\n            var other = a\n            other[0] = scalarRoot\
    \ * scalarRoot\n            doAssert setSqrt(other, scalarRoot) == naiveSqrt(other,\
    \ scalarRoot)\n        doAssert a == original\n\nfor n in 0..4:\n    for trial\
    \ in 0..<4:\n        let coefficients = newSeqWith(1 shl n, rng.rand(-20..20))\n\
    \        checkUnitConstants[modint998244353_barrett](coefficients, @[2, 3, -2])\n\
    \        checkUnitConstants[modint998244353_montgomery](coefficients, @[2, 3,\
    \ -2])\n        modint_barrett.setMod(998244353)\n        checkUnitConstants[modint_barrett](coefficients,\
    \ @[2, 3, -2])\n        modint_montgomery.setMod(998244353)\n        checkUnitConstants[modint_montgomery](coefficients,\
    \ @[2, 3, -2])\n        modint_barrett.setMod(9)\n        checkUnitConstants[modint_barrett](coefficients,\
    \ @[2, 4, 5, 7, 8])\n        modint_montgomery.setMod(9)\n        checkUnitConstants[modint_montgomery](coefficients,\
    \ @[2, 4, 5, 7, 8])\n\nfor modulus in [2, 3, 5, 9]:\n    modint_barrett.setMod(modulus)\n\
    \    for code in 0..<81:\n        var a = newSeq[modint_barrett](4)\n        var\
    \ value = code\n        for mask in 0..<4:\n            a[mask] = init(modint_barrett,\
    \ value mod 3)\n            value = value div 3\n        # \u5C0F\u6A19\u6570\u30FB\
    \u5408\u6210\u6570\u6CD5\u3067\u306F\u9664\u7B97\u3092\u542B\u307E\u306A\u3044\
    \u6F14\u7B97\u3068\u5358\u5143\u306E\u9006\u5143\u3092\u78BA\u8A8D\u3059\u308B\
    \u3002\n        for e in 0..5: doAssert setPow(a, e) == naivePow(a, e)\n     \
    \   doAssert setPowerProjection(a, a, 7).len == 7\n        var polynomial = @[init(modint_barrett,\
    \ 2), init(modint_barrett, 1), init(modint_barrett, 2), init(modint_barrett, 1)]\n\
    \        var expected = newSeq[modint_barrett](4)\n        for e in 0..<polynomial.len:\n\
    \            let power = naivePow(a, e)\n            for mask in 0..<4: expected[mask]\
    \ += polynomial[e] * power[mask]\n        doAssert polynomialCompositeSetPowerSeries(polynomial,\
    \ a) == expected\n        let projected = setPowerProjection(a, a, 7)\n      \
    \  for e in 0..<7:\n            let power = naivePow(a, e)\n            var dot\
    \ = init(modint_barrett, 0)\n            for mask in 0..<4: dot += a[mask] * power[mask]\n\
    \            doAssert projected[e] == dot\n        a[0] = init(modint_barrett,\
    \ 1)\n        doAssert setInv(a) == naiveInv(a)\n        doAssert setPow(a, -2)\
    \ == naivePow(naiveInv(a), 2)\n        if modulus mod 2 == 1: doAssert setSqrt(naive(a,\
    \ a), init(modint_barrett, 1)) == a\n\ntemplate rejects(body: untyped) =\n   \
    \ block:\n        var rejected = false\n        try: body\n        except AssertionDefect:\
    \ rejected = true\n        doAssert rejected\n\nvar empty = newSeq[int]()\nsubsetZetaTransform(empty)\n\
    subsetMobiusTransform(empty)\nsupersetZetaTransform(empty)\nsupersetMobiusTransform(empty)\n\
    doAssert subsetConvolution(empty, empty).len == 0\ndoAssert bitwiseOrConvolution(empty,\
    \ empty).len == 0\nvar invalid = @[1, 2, 3]\nrejects(subsetZetaTransform(invalid))\n\
    rejects(subsetMobiusTransform(invalid))\nrejects(supersetZetaTransform(invalid))\n\
    rejects(supersetMobiusTransform(invalid))\nrejects:\n    discard subsetConvolution(@[1],\
    \ @[1, 2])\nrejects:\n    discard subsetConvolution(invalid, invalid)\nrejects:\n\
    \    discard bitwiseOrConvolution(@[1], @[1, 2])\nrejects:\n    discard bitwiseOrConvolution(invalid,\
    \ invalid)\ntype mint = modint998244353_barrett\nlet one = init(mint, 1)\nlet\
    \ zero = init(mint, 0)\nrejects:\n    discard setExp(newSeq[mint]())\nrejects:\n\
    \    discard setInv(@[one, one, one])\nrejects:\n    discard setExp(@[one])\n\
    rejects:\n    discard setLog(@[zero])\nrejects:\n    discard setInv(@[zero])\n\
    rejects:\n    discard setPow(@[zero, one], -1)\nrejects:\n    discard setSqrt(@[zero,\
    \ one], zero)\nrejects:\n    discard setSqrt(@[one], zero)\nrejects:\n    discard\
    \ setPowerProjection(@[one], @[one], -1)\nrejects:\n    discard setPowerProjection(@[one],\
    \ newSeq[mint](), 0)\nmodint_barrett.setMod(9)\nrejects:\n    discard setInv(@[init(modint_barrett,\
    \ 3)])\nrejects:\n    discard setExp(@[init(modint_barrett, 0)])\nfor c in [3,\
    \ 6]:\n    rejects:\n        discard setPow(@[init(modint_barrett, c), init(modint_barrett,\
    \ 1)], -1)\n    rejects:\n        discard setSqrt(@[init(modint_barrett, 0), init(modint_barrett,\
    \ 1)], init(modint_barrett, c))\nrejects:\n    discard setSqrt(@[init(mint, 2)],\
    \ init(mint, 1))\nmodint_barrett.setMod(2)\nrejects:\n    discard setExp(newSeq[modint_barrett](4))\n\
    rejects:\n    discard setSqrt(@[init(modint_barrett, 1)], init(modint_barrett,\
    \ 1))\necho \"Hello World\"\n"
  dependsOn:
  - cplib/convolution/private/subset_convolution_barrett.nim
  - cplib/set_power_series/set_power_series.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/set_transform.nim
  - cplib/convolution/bitwise_or_convolution.nim
  - cplib/convolution/bitwise_and_convolution.nim
  - cplib/convolution/private/subset_convolution_barrett.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/subset_convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/subset_convolution.nim
  - cplib/convolution/bitwise_and_convolution.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/xor_convolution.nim
  - cplib/set_power_series/set_power_series.nim
  - cplib/convolution/set_transform.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/xor_convolution.nim
  - cplib/math/isprime.nim
  - cplib/convolution/bitwise_or_convolution.nim
  isVerificationFile: true
  path: verify/set_power_series/set_power_series_regression_test.nim
  requiredBy: []
  timestamp: '2026-10-08 06:34:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/set_power_series/set_power_series_regression_test.nim
layout: document
redirect_from:
- /verify/verify/set_power_series/set_power_series_regression_test.nim
- /verify/verify/set_power_series/set_power_series_regression_test.nim.html
title: verify/set_power_series/set_power_series_regression_test.nim
---
