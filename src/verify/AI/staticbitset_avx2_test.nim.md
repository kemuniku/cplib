---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx2_impl.nim
    title: cplib/collections/private/bitset_avx2_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx2_impl.nim
    title: cplib/collections/private/bitset_avx2_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticbitset_avx2.nim
    title: cplib/collections/staticbitset_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticbitset_avx2.nim
    title: cplib/collections/staticbitset_avx2.nim
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
    \ World\"\n\nimport random\nimport cplib/collections/staticbitset_avx2\n\nproc\
    \ checkBits[size](actual: BitSet[size], expected: openArray[bool]) =\n    ## \u5168\
    \u30D3\u30C3\u30C8\u3001\u500B\u6570\u3001\u5217\u6319\u3001\u6700\u4E0B\u4F4D\
    \u30D3\u30C3\u30C8\u3001\u6587\u5B57\u5217\u8868\u73FE\u3092bool\u914D\u5217\u3068\
    \u7167\u5408\u3057\u307E\u3059\u3002\n    assert actual.len == expected.len\n\
    \    var indexes, actualIndexes: seq[int]\n    var representation = newString(size)\n\
    \    for i in 0..<size:\n        assert actual[i] == expected[i]\n        representation[size\
    \ - i - 1] = if expected[i]: '1' else: '0'\n        if expected[i]:\n        \
    \    indexes.add(i)\n    for i in actual:\n        actualIndexes.add(i)\n    assert\
    \ actualIndexes == indexes\n    assert actual.popcount == indexes.len\n    assert\
    \ actual.lowestBit == (if indexes.len == 0: -1 else: indexes[0])\n    assert $actual\
    \ == representation\n\ntemplate expectError(errorType: typedesc, body: untyped)\
    \ =\n    ## \u6307\u5B9A\u3057\u305F\u7A2E\u985E\u306E\u4F8B\u5916\u304C\u767A\
    \u751F\u3059\u308B\u3053\u3068\u3092\u691C\u8A3C\u3057\u307E\u3059\u3002\n   \
    \ block:\n        var caught = false\n        try:\n            body\n       \
    \ except errorType:\n            caught = true\n        assert caught\n\nproc\
    \ checkSize[size: static int]() =\n    ## \u5883\u754C\u30B5\u30A4\u30BA\u3067\
    \u8AD6\u7406\u6F14\u7B97\u3001\u30B7\u30D5\u30C8\u3001\u30B3\u30D4\u30FC\u3001\
    \u7BC4\u56F2\u691C\u67FB\u3092\u691C\u8A3C\u3057\u307E\u3059\u3002\n    var rng\
    \ = initRand(20260908 + size)\n    for pattern in 0..<4:\n        var a, b = newSeq[bool](size)\n\
    \        var indexes: seq[int]\n        for i in 0..<size:\n            a[i] =\
    \ if pattern < 2: pattern == 1 else: rng.rand(1) == 1\n            b[i] = if pattern\
    \ < 2: true else: rng.rand(1) == 1\n            if a[i]:\n                indexes.add(i)\n\
    \        let x = initBitSet(a, size)\n        let y = initBitSet(b, size)\n  \
    \      checkBits(x, a)\n        checkBits(y, b)\n\n        checkBits(initBitSetFromIndexes(indexes,\
    \ size), a)\n        checkBits(initBitSet(size), newSeq[bool](size))\n       \
    \ var expectedAnd, expectedOr, expectedXor, inverted = newSeq[bool](size)\n  \
    \      var andCount, orCount, xorCount: int\n        for i in 0..<size:\n    \
    \        expectedAnd[i] = a[i] and b[i]\n            expectedOr[i] = a[i] or b[i]\n\
    \            expectedXor[i] = a[i] xor b[i]\n            inverted[i] = not a[i]\n\
    \            andCount += ord(expectedAnd[i])\n            orCount += ord(expectedOr[i])\n\
    \            xorCount += ord(expectedXor[i])\n        checkBits(x & y, expectedAnd)\n\
    \        checkBits(x | y, expectedOr)\n        checkBits(x ^ y, expectedXor)\n\
    \        checkBits(~x, inverted)\n        assert andpopcount(x, y) == andCount\n\
    \        assert orpopcount(x, y) == orCount\n        assert xorpopcount(x, y)\
    \ == xorCount\n        var assigned = x\n        assigned &= y\n        checkBits(assigned,\
    \ expectedAnd)\n        assigned = x\n        assigned |= y\n        checkBits(assigned,\
    \ expectedOr)\n        assigned = x\n        assigned ^= y\n        checkBits(assigned,\
    \ expectedXor)\n        assigned = x\n        assigned &= assigned\n        checkBits(assigned,\
    \ a)\n        assigned |= assigned\n        checkBits(assigned, a)\n        assigned\
    \ ^= assigned\n        checkBits(assigned, newSeq[bool](size))\n        assigned\
    \ = x\n        for i in 0..<size:\n            assigned[i] = not a[i]\n      \
    \  checkBits(assigned, inverted)\n        for i in 0..<size:\n            assigned[i]\
    \ = ord(a[i])\n            assigned[i] = 2\n        checkBits(assigned, a)\n\n\
    \        var shifts = @[0, 1, 13, 31, 32, 33, 63, 64, 65, 127, 128, 129,\n   \
    \                    191, 192, 193, 255, 256, 257, 511, 512, 513, size, size +\
    \ 1, int.high]\n        when size > 0:\n            shifts.add(size - 1)\n   \
    \     when size <= 257:\n            for shift in 0..size:\n                if\
    \ shift notin shifts:\n                    shifts.add(shift)\n        for shift\
    \ in shifts:\n            var left, right = newSeq[bool](size)\n            for\
    \ i in 0..<size:\n                left[i] = i >= shift and a[i - shift]\n    \
    \            right[i] = shift < size and i < size - shift and a[i + shift]\n \
    \           checkBits(x << shift, left)\n            checkBits(x >> shift, right)\n\
    \        checkBits(x, a)\n        checkBits(y, b)\n\n    for length in [0, 1,\
    \ 7, 8, 9, 31, 32, 33, 63, 64, 65, 127, 128, 129, size]:\n        if length >\
    \ size:\n            continue\n        var source = newSeq[bool](length)\n   \
    \     var expected = newSeq[bool](size)\n        for i in 0..<length:\n      \
    \      source[i] = i mod 3 != 0\n            expected[i] = source[i]\n       \
    \ checkBits(initBitSet(source, size), expected)\n        var padded = newSeq[bool](length\
    \ + 2)\n        for i in 0..<padded.len:\n            padded[i] = true\n     \
    \   for i in 0..<length:\n            padded[i + 1] = source[i]\n        if length\
    \ > 0:\n            checkBits(initBitSet(padded.toOpenArray(1, length), size),\
    \ expected)\n\n    var empty: BitSet[size]\n    checkBits(empty, newSeq[bool](size))\n\
    \    expectError(ValueError):\n        discard initBitSet(newSeq[bool](size +\
    \ 1), size)\n    expectError(ValueError):\n        discard empty << -1\n    expectError(ValueError):\n\
    \        discard empty >> -1\n    expectError(IndexDefect):\n        discard empty[size]\n\
    \    expectError(IndexDefect):\n        empty[size] = true\n    expectError(IndexDefect):\n\
    \        empty[size] = 0\n    expectError(IndexDefect):\n        discard initBitSetFromIndexes([-1],\
    \ size)\n    expectError(IndexDefect):\n        discard initBitSetFromIndexes([size],\
    \ size)\n\ncheckSize[0]()\ncheckSize[1]()\ncheckSize[7]()\ncheckSize[8]()\ncheckSize[9]()\n\
    checkSize[31]()\ncheckSize[32]()\ncheckSize[33]()\ncheckSize[63]()\ncheckSize[64]()\n\
    checkSize[65]()\ncheckSize[127]()\ncheckSize[128]()\ncheckSize[129]()\ncheckSize[255]()\n\
    checkSize[256]()\ncheckSize[257]()\ncheckSize[511]()\ncheckSize[512]()\ncheckSize[513]()\n\
    checkSize[8192]()\ncheckSize[8193]()\ncheckSize[16385]()\n\ncheckBits(initBitSet([true,\
    \ false, true], 5), @[true, false, true, false, false])\nassert initBitSetFromIndexes([0,\
    \ 0, 64, 64], 65).popcount == 2\nfor value in 0..<256:\n    var bits: BitSet[8]\n\
    \    var expected = newString(8)\n    for i in 0..<8:\n        bits[i] = (value\
    \ shr i) and 1\n        expected[7 - i] = if ((value shr i) and 1) != 0: '1' else:\
    \ '0'\n    assert $bits == expected\nstatic:\n    doAssert not compiles(initBitSet(-1))\n\
    \    doAssert not compiles(initBitSet(64) & initBitSet(65))\n"
  dependsOn:
  - cplib/collections/staticbitset_avx2.nim
  - cplib/collections/private/bitset_avx2_impl.nim
  - cplib/collections/staticbitset_avx2.nim
  - cplib/collections/private/bitset_avx2_impl.nim
  isVerificationFile: true
  path: verify/AI/staticbitset_avx2_test.nim
  requiredBy: []
  timestamp: '2026-09-08 11:45:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/staticbitset_avx2_test.nim
layout: document
redirect_from:
- /verify/verify/AI/staticbitset_avx2_test.nim
- /verify/verify/AI/staticbitset_avx2_test.nim.html
title: verify/AI/staticbitset_avx2_test.nim
---
