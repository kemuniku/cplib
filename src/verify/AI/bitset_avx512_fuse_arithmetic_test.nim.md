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
    \ in 0..<a.len:\n        let v = ord(a[i]) + ord(b[i]) + carry\n        result[i]\
    \ = (v and 1) != 0\n        carry = v shr 1\n\nproc check(x: BitSetAvx512, a:\
    \ seq[bool]) =\n    doAssert x.len == a.len\n    for i, v in a: doAssert x[i]\
    \ == v\n    var count = 0\n    for v in a: count += ord(v)\n    doAssert x.popcount\
    \ == count\n\nvar rng = initRand(47923)\nfor n in [0, 1, 63, 64, 65, 255, 256,\
    \ 257, 511, 512, 513, 1023, 1024, 1025, 4097]:\n    for trial in 0..<8:\n    \
    \    var a, b, c = newSeq[bool](n)\n        for i in 0..<n:\n            a[i]\
    \ = trial == 0 or rng.rand(1) == 1\n            b[i] = if trial == 0: i == 0 else:\
    \ rng.rand(1) == 1\n            c[i] = rng.rand(1) == 1\n        var x = initBitSet(a)\n\
    \        let y = initBitSet(b)\n        let z = initBitSet(c)\n        var dst\
    \ = initBitSet(n)\n        fuse: dst = x + y\n        check(dst, add(a,b))\n \
    \       fuse: x += y\n        check(x, add(a,b))\n        x = initBitSet(a)\n\
    \        fuse: x = ((x + y) + (z + x)) xor y\n        var expected = add(add(a,b),\
    \ add(c,a))\n        for i in 0..<n: expected[i] = expected[i] xor b[i]\n    \
    \    check(x, expected)\n        for k in [0, 1, 63, 64, 65, 255, 256, 511, 512,\
    \ 513, n, n+1, high(int)]:\n            x = initBitSet(a)\n            var l,\
    \ r = newSeq[bool](n)\n            for i in 0..<n:\n                l[i] = i >=\
    \ k and a[i-k]\n                r[i] = k < n-i and b[i+k]\n            fuse: x\
    \ = ((x shl k) + (y shr k)) xor z\n            expected = add(l,r)\n         \
    \   for i in 0..<n: expected[i] = expected[i] xor c[i]\n            check(x, expected)\n\
    \            x = initBitSet(a)\n            fuse: dst = (x shl k) + y\n      \
    \      check(dst, add(l,b))\n            fuse: x <<= k\n            check(x,l)\n\
    \            x = initBitSet(b)\n            fuse: x = x shr k\n            check(x,r)\n\
    \        x = initBitSet(n+1)\n        fuse: x = y + z\n        check(x, add(b,c))\n\
    \        x = initBitSet(a)\n        fuse: dst = (not (x + y)) shr 1\n        expected\
    \ = add(a,b)\n        for i in 0..<n:\n            expected[i] = i+1 < n and not\
    \ expected[i+1]\n        check(dst, expected)\n\nblock:\n    var x = initBitSet(65)\n\
    \    var y = initBitSet(64)\n    var raised = false\n    try:\n        fuse: x\
    \ = x + y\n    except ValueError: raised = true\n    doAssert raised\n    y =\
    \ initBitSet(65)\n    raised = false\n    try:\n        fuse: x = (y shl -1) +\
    \ y\n    except ValueError: raised = true\n    doAssert raised\n\necho \"Hello\
    \ World\"\n\nblock:\n    var x = initBitSet(0)\n    var y = initBitSet(513)\n\
    \    y[0] = true\n    var calls = 0\n    proc amount(): int =\n        inc calls\n\
    \        1\n    fuse: x = (y shl amount()) + y\n    doAssert calls == 1 and x.len\
    \ == 513 and x.popcount == 2 and x[0] and x[1]\n\nblock:\n    var xs = @[initBitSet(513)]\n\
    \    xs[0][62] = true\n    var calls = 0\n    proc index(): int =\n        inc\
    \ calls\n        0\n    let amount = 65\n    fuse: xs[index()] <<= (amount and\
    \ 63)\n    doAssert calls == 1 and xs[0][63] and xs[0].popcount == 1\n    fuse:\
    \ xs[index()] >>= (amount and 63)\n    doAssert calls == 2 and xs[0][62] and xs[0].popcount\
    \ == 1\n"
  dependsOn:
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_search_impl.nim
  isVerificationFile: true
  path: verify/AI/bitset_avx512_fuse_arithmetic_test.nim
  requiredBy: []
  timestamp: '2026-09-17 21:00:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_avx512_fuse_arithmetic_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_avx512_fuse_arithmetic_test.nim
- /verify/verify/AI/bitset_avx512_fuse_arithmetic_test.nim.html
title: verify/AI/bitset_avx512_fuse_arithmetic_test.nim
---
