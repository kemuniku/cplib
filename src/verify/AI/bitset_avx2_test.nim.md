---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx2.nim
    title: cplib/collections/bitset_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx2.nim
    title: cplib/collections/bitset_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx2_impl.nim
    title: cplib/collections/private/bitset_avx2_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx2_impl.nim
    title: cplib/collections/private/bitset_avx2_impl.nim
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
    # AVX2\u5BFE\u5FDC\u306ECPU\u304C\u5FC5\u8981\u3067\u3059\u3002\necho \"Hello\
    \ World\"\n\nimport random\nimport cplib/collections/bitset_avx2\n\nproc checkBits(actual:\
    \ BitSetAvx2, expected: openArray[bool]) =\n    ## \u30D3\u30C3\u30C8\u5217\u3001\
    \u8981\u7D20\u5217\u6319\u3001\u6700\u4E0B\u4F4D\u30D3\u30C3\u30C8\u3001\u500B\
    \u6570\u3001\u6587\u5B57\u5217\u8868\u73FE\u3092\u7167\u5408\u3059\u308B\u3002\
    \n    assert actual.len == expected.len\n    var indexes: seq[int]\n    var representation\
    \ = newString(expected.len)\n    for i in 0..<expected.len:\n        assert actual[i]\
    \ == expected[i]\n        representation[expected.len - 1 - i] = if expected[i]:\
    \ '1' else: '0'\n        if expected[i]:\n            indexes.add(i)\n    var\
    \ actualIndexes: seq[int]\n    for i in actual:\n        actualIndexes.add(i)\n\
    \    assert actualIndexes == indexes\n    assert actual.popcount == indexes.len\n\
    \    assert actual.lowestBit == (if indexes.len == 0: -1 else: indexes[0])\n \
    \   assert $actual == representation\n\nproc combine(a, b: openArray[bool], operation:\
    \ char): seq[bool] =\n    ## bool \u914D\u5217\u4E0A\u3067\u4E8C\u9805\u6F14\u7B97\
    \u306E\u671F\u5F85\u5024\u3092\u4F5C\u308B\u3002\n    result = newSeq[bool](a.len)\n\
    \    for i in 0..<a.len:\n        case operation\n        of '&': result[i] =\
    \ a[i] and b[i]\n        of '|': result[i] = a[i] or b[i]\n        of '^': result[i]\
    \ = a[i] xor b[i]\n        else: assert false\n\nproc countBits(bits: openArray[bool]):\
    \ int =\n    ## bool \u914D\u5217\u306B\u542B\u307E\u308C\u308B\u771F\u306E\u500B\
    \u6570\u3092\u6570\u3048\u308B\u3002\n    for bit in bits:\n        if bit:\n\
    \            inc result\n\nproc checkPair(a, b: seq[bool]) =\n    ## \u4E8C\u9805\
    \u6F14\u7B97\u3068\u4EE3\u5165\u6F14\u7B97\u3092\u7167\u5408\u3057\u3001\u5143\
    \u306E\u5024\u304C\u5909\u66F4\u3055\u308C\u306A\u3044\u3053\u3068\u3092\u691C\
    \u8A3C\u3059\u308B\u3002\n    let x = initBitSet(a)\n    let y = initBitSet(b)\n\
    \    checkBits(x, a)\n    checkBits(y, b)\n    let expectedAnd = combine(a, b,\
    \ '&')\n    let expectedOr = combine(a, b, '|')\n    let expectedXor = combine(a,\
    \ b, '^')\n    checkBits(x & y, expectedAnd)\n    checkBits(x | y, expectedOr)\n\
    \    checkBits(x ^ y, expectedXor)\n    assert x.andpopcount(y) == countBits(expectedAnd)\n\
    \    assert x.orpopcount(y) == countBits(expectedOr)\n    assert x.xorpopcount(y)\
    \ == countBits(expectedXor)\n\n    var assigned = x\n    assigned &= y\n    checkBits(assigned,\
    \ expectedAnd)\n    checkBits(x, a)\n    assigned = x\n    assigned |= y\n   \
    \ checkBits(assigned, expectedOr)\n    checkBits(x, a)\n    assigned = x\n   \
    \ assigned ^= y\n    checkBits(assigned, expectedXor)\n    checkBits(x, a)\n \
    \   checkBits(y, b)\n\n    assigned = x\n    assigned &= assigned\n    checkBits(assigned,\
    \ a)\n    assigned |= assigned\n    checkBits(assigned, a)\n    assigned ^= assigned\n\
    \    checkBits(assigned, newSeq[bool](a.len))\n    checkBits(x, a)\n\nproc checkUnary(bits:\
    \ seq[bool]) =\n    ## \u5426\u5B9A\u3001\u30B7\u30D5\u30C8\u3001\u5404\u7A2E\u521D\
    \u671F\u5316\u3001\u30D3\u30C3\u30C8\u66F4\u65B0\u3068\u30B3\u30D4\u30FC\u306E\
    \u72EC\u7ACB\u6027\u3092\u691C\u8A3C\u3059\u308B\u3002\n    let n = bits.len\n\
    \    let x = initBitSet(bits)\n    var inverted = newSeq[bool](n)\n    var indexes:\
    \ seq[int]\n    for i in 0..<n:\n        inverted[i] = not bits[i]\n        if\
    \ bits[i]:\n            indexes.add(i)\n    checkBits(~x, inverted)\n    checkBits(~(~x),\
    \ bits)\n    checkBits(initBitSetFromIndexes(indexes, n), bits)\n    checkBits(initBitSet(n),\
    \ newSeq[bool](n))\n\n    var shifts = @[0, 1, 7, 63, 64, 65, 127, 128, 129, 191,\
    \ 192,\n                   193, 255, 256, 257, 511, 512, 513, n, n + 1, int.high]\n\
    \    if n > 0:\n        shifts.add(n - 1)\n    if n <= 257:\n        for shift\
    \ in 0..n:\n            if shift notin shifts:\n                shifts.add(shift)\n\
    \    for shift in shifts:\n        var left = newSeq[bool](n)\n        var right\
    \ = newSeq[bool](n)\n        for i in 0..<n:\n            left[i] = i >= shift\
    \ and bits[i - shift]\n            right[i] = shift < n and i < n - shift and\
    \ bits[i + shift]\n        checkBits(x << shift, left)\n        checkBits(x >>\
    \ shift, right)\n    checkBits(x, bits)\n\n    var assigned = x\n    for i in\
    \ 0..<n:\n        assigned[i] = inverted[i]\n    checkBits(assigned, inverted)\n\
    \    checkBits(x, bits)\n    for i in 0..<n:\n        assigned[i] = ord(bits[i])\n\
    \    checkBits(assigned, bits)\n\ntemplate expectError(errorType: typedesc, body:\
    \ untyped) =\n    ## \u6307\u5B9A\u3057\u305F\u7A2E\u985E\u306E\u4F8B\u5916\u304C\
    \u767A\u751F\u3059\u308B\u3053\u3068\u3092\u691C\u8A3C\u3059\u308B\u3002\n   \
    \ block:\n        var caught = false\n        try:\n            body\n       \
    \ except errorType:\n            caught = true\n        assert caught\n\nvar rng\
    \ = initRand(20260908)\nfor n in [0, 1, 2, 63, 64, 65, 127, 128, 129, 255, 256,\
    \ 257,\n          511, 512, 513, 8192, 8193, 16385]:\n    var a = newSeq[bool](n)\n\
    \    var b = newSeq[bool](n)\n    var ones = newSeq[bool](n)\n    let zeros =\
    \ newSeq[bool](n)\n    for i in 0..<n:\n        a[i] = rng.rand(1) == 1\n    \
    \    b[i] = rng.rand(1) == 1\n        ones[i] = true\n    checkPair(a, b)\n  \
    \  checkPair(ones, ones)\n    checkPair(ones, zeros)\n    checkUnary(a)\n    checkBits(~initBitSet(n),\
    \ ones)\n    if n > 0:\n        var singleton = initBitSet(n)\n        singleton[n\
    \ - 1] = true\n        assert singleton.lowestBit == n - 1\n        assert singleton.popcount\
    \ == 1\n        assert (singleton << 1).popcount == 0\n        assert (singleton\
    \ >> (n - 1))[0]\n\nvar empty: BitSetAvx2\ncheckBits(empty, newSeq[bool](0))\n\
    checkBits(initBitSet([true, false, true], 5), @[true, false, true, false, false])\n\
    checkBits(initBitSetFromIndexes([0, 0, 64, 64], 65),\n          block:\n     \
    \         var expected = newSeq[bool](65)\n              expected[0] = true\n\
    \              expected[64] = true\n              expected)\n\nexpectError(ValueError):\n\
    \    discard initBitSet(-1)\nexpectError(ValueError):\n    discard initBitSet([true],\
    \ 0)\nexpectError(ValueError):\n    discard initBitSet(newSeq[bool](0), -1)\n\
    expectError(ValueError):\n    discard initBitSetFromIndexes(newSeq[int](0), -1)\n\
    expectError(IndexDefect):\n    discard initBitSetFromIndexes([-1], 64)\nexpectError(IndexDefect):\n\
    \    discard initBitSetFromIndexes([64], 64)\nexpectError(IndexDefect):\n    discard\
    \ initBitSetFromIndexes([0], 0)\nfor n in [0, 1, 64, 257]:\n    expectError(IndexDefect):\n\
    \        discard initBitSet(n)[n]\n    expectError(IndexDefect):\n        var\
    \ x = initBitSet(n)\n        x[n] = true\n    expectError(IndexDefect):\n    \
    \    var x = initBitSet(n)\n        x[n] = 0\n    expectError(ValueError):\n \
    \       discard initBitSet(n) << -1\n    expectError(ValueError):\n        discard\
    \ initBitSet(n) >> -1\n\nlet small = initBitSet(64)\nlet large = initBitSet(65)\n\
    expectError(ValueError):\n    discard small & large\nexpectError(ValueError):\n\
    \    discard small | large\nexpectError(ValueError):\n    discard small ^ large\n\
    expectError(ValueError):\n    var x = small\n    x &= large\nexpectError(ValueError):\n\
    \    var x = small\n    x |= large\nexpectError(ValueError):\n    var x = small\n\
    \    x ^= large\nexpectError(ValueError):\n    discard small.andpopcount(large)\n\
    expectError(ValueError):\n    discard small.orpopcount(large)\nexpectError(ValueError):\n\
    \    discard small.xorpopcount(large)\n"
  dependsOn:
  - cplib/collections/bitset_avx2.nim
  - cplib/collections/bitset_avx2.nim
  - cplib/collections/private/bitset_avx2_impl.nim
  - cplib/collections/private/bitset_avx2_impl.nim
  isVerificationFile: true
  path: verify/AI/bitset_avx2_test.nim
  requiredBy: []
  timestamp: '2026-09-08 11:45:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_avx2_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_avx2_test.nim
- /verify/verify/AI/bitset_avx2_test.nim.html
title: verify/AI/bitset_avx2_test.nim
---
