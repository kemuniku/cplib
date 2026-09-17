---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse.nim
    title: cplib/collections/private/bitset_avx512_fuse.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse.nim
    title: cplib/collections/private/bitset_avx512_fuse.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
    title: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
    title: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_block.nim
    title: cplib/collections/private/bitset_avx512_fuse_block.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_block.nim
    title: cplib/collections/private/bitset_avx512_fuse_block.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_shift.nim
    title: cplib/collections/private/bitset_avx512_fuse_shift.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_shift.nim
    title: cplib/collections/private/bitset_avx512_fuse_shift.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_impl.nim
    title: cplib/collections/private/bitset_avx512_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_impl.nim
    title: cplib/collections/private/bitset_avx512_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_shift_assign.nim
    title: cplib/collections/private/bitset_avx512_shift_assign.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_shift_assign.nim
    title: cplib/collections/private/bitset_avx512_shift_assign.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_search_impl.nim
    title: cplib/collections/private/bitset_search_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_search_impl.nim
    title: cplib/collections/private/bitset_search_impl.nim
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
    import random\nimport cplib/collections/bitset_avx512\n\nproc add(a, b: seq[bool]):\
    \ seq[bool] =\n    result = newSeq[bool](a.len)\n    var carry = 0\n    for i\
    \ in 0..<a.len:\n        let total = ord(a[i]) + ord(b[i]) + carry\n        result[i]\
    \ = (total and 1) != 0\n        carry = total shr 1\n\nproc check(x: BitSetAvx512,\
    \ a: seq[bool]) =\n    doAssert x.len == a.len\n    var count = 0\n    for i,\
    \ v in a:\n        doAssert x[i] == v\n        count += ord(v)\n    doAssert x.popcount\
    \ == count\n\nvar rng = initRand(582173)\nfor n in [1, 2, 63, 64, 65, 127, 128,\
    \ 129, 255, 256, 257, 511, 512, 513,\n          575, 576, 577, 1023, 1024, 1025,\
    \ 4097]:\n    for trial in 0..<12:\n        var a, b, c = newSeq[bool](n)\n  \
    \      for i in 0..<n:\n            a[i] = trial == 0 or rng.rand(1) == 1\n  \
    \          b[i] = if trial == 0: i == 0 else: rng.rand(1) == 1\n            c[i]\
    \ = rng.rand(1) == 1\n        var x = initBitSet(a)\n        var y = initBitSet(b)\n\
    \        let z = initBitSet(c)\n        var highBefore, highAfter: bool\n    \
    \    fuse:\n            let total = (x + y) + z\n            let h = not (total\
    \ or x) or y\n            highBefore = lastBit(h)\n            var shifted = h\
    \ shl 1\n            shifted[0] = true\n            x = shifted xor (z shl 63)\n\
    \            y = x + total\n            highAfter = lastBit(y)\n        let total\
    \ = add(add(a,b),c)\n        var h, expectedX = newSeq[bool](n)\n        for i\
    \ in 0..<n: h[i] = not (total[i] or a[i]) or b[i]\n        for i in 0..<n:\n \
    \           expectedX[i] = (i == 0 or h[i-1]) xor (i >= 63 and c[i-63])\n    \
    \    let expectedY = add(expectedX,total)\n        check(x,expectedX)\n      \
    \  check(y,expectedY)\n        doAssert highBefore == h[^1] and highAfter == expectedY[^1]\n\
    \n        x = initBitSet(a)\n        y = initBitSet(b)\n        var expected =\
    \ newSeq[bool](n)\n        fuse:\n            let t = (x and y) shl 2\n      \
    \      x = (t or z) shl 63\n            y = x xor (t shl 0)\n        var t = newSeq[bool](n)\n\
    \        for i in 0..<n: t[i] = i >= 2 and a[i-2] and b[i-2]\n        for i in\
    \ 0..<n: expected[i] = i >= 63 and (t[i-63] or c[i-63])\n        check(x,expected)\n\
    \        for i in 0..<n: expected[i] = expected[i] xor t[i]\n        check(y,expected)\n\
    \n        x = initBitSet(a)\n        y = initBitSet(b)\n        fuse:\n      \
    \      x = not x\n            x[0] = false\n            y = x + y\n        for\
    \ i in 0..<n: expected[i] = i > 0 and not a[i]\n        check(x,expected)\n  \
    \      check(y,add(expected,b))\n\n        x = initBitSet(a)\n        y = initBitSet(b)\n\
    \        template alias: untyped = x\n        fuse:\n            x = x xor y\n\
    \            y = alias + y\n        for i in 0..<n: expected[i] = a[i] xor b[i]\n\
    \        check(x,expected)\n        check(y,add(expected,b))\n\n        x = initBitSet(a)\n\
    \        y = initBitSet(b)\n        let shift = 65\n        let expectedFallback\
    \ = ((x + y) >> shift) ^ z\n        fuse:\n            let t = x + y\n       \
    \     var shifted = t shr shift\n            x = shifted xor z\n            highAfter\
    \ = lastBit(x)\n        doAssert $x == $expectedFallback\n        doAssert highAfter\
    \ == expectedFallback.lastBit()\n\nblock:\n    var x = initBitSet(0)\n    var\
    \ y = initBitSet(0)\n    var bit = true\n    fuse:\n        let t = not x\n  \
    \      x = t + y\n        y = x shl 1\n        bit = lastBit(t)\n    doAssert\
    \ x.len == 0 and y.len == 0 and not bit\n    var caught = false\n    try:\n  \
    \      fuse:\n            let t = x shl 1\n            var u = t\n           \
    \ u[0] = true\n            x = u\n    except IndexDefect: caught = true\n    doAssert\
    \ caught\n\nblock:\n    var x = initBitSet(2)\n    var y = initBitSet(513)\n \
    \   y[512] = true\n    fuse:\n        x = y xor y\n        y = x or y\n    doAssert\
    \ x.len == 513 and x.popcount == 0 and y[512]\n    var flag: bool\n    fuse:\n\
    \        let t = not x\n        flag = lastBit(t)\n    doAssert flag\n\nproc generic[T](unused:\
    \ T) =\n    var x = initBitSet(513)\n    var flag: bool\n    fuse:\n        let\
    \ t = not x\n        x = t shl 1\n        flag = lastBit(x)\n    doAssert x.popcount\
    \ == 512 and flag\ngeneric(0)\ngeneric(0.0)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/bitset_avx512.nim
  isVerificationFile: true
  path: verify/AI/bitset_avx512_fuse_block_test.nim
  requiredBy: []
  timestamp: '2026-09-17 21:00:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_avx512_fuse_block_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_avx512_fuse_block_test.nim
- /verify/verify/AI/bitset_avx512_fuse_block_test.nim.html
title: verify/AI/bitset_avx512_fuse_block_test.nim
---
