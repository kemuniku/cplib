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
    import random, macros, sequtils\nimport cplib/collections/bitset_avx512\n\nrandomize(156)\n\
    \nproc check(a: BitSetAvx512, b: seq[bool]) =\n    doAssert a.len == b.len\n \
    \   for i, bit in b: doAssert a[i] == bit\n    var count = 0\n    for bit in b:\n\
    \        if bit: inc count\n    doAssert a.popcount == count\n\nmacro checkLogic():\
    \ untyped =\n    result = newStmtList()\n    for outer in [\"and\", \"or\", \"\
    xor\"]:\n        for inner in [\"and\", \"or\", \"xor\"]:\n            for dst\
    \ in [\"x\", \"y\", \"z\"]:\n                result.add parseStmt(\"\"\"\nblock:\n\
    \    var x = initBitSet(a)\n    var y = initBitSet(b)\n    var z = initBitSet(c)\n\
    \    fuse:\n        \"\"\" & dst & \" = x \" & outer & \" (y \" & inner & \" z)\\\
    n\" & \"\"\"\n    var expected = newSeq[bool](a.len)\n    for i in 0..<a.len:\n\
    \        expected[i] = a[i] \"\"\" & outer & \" (b[i] \" & inner & \" c[i])\\\
    n\" &\n                    \"    check(\" & dst & \", expected)\\n\")\n\nfor n\
    \ in [0, 1, 63, 64, 65, 127, 255, 256, 257, 511, 512, 513, 1025]:\n    for trial\
    \ in 0..<5:\n        var a, b, c, d: seq[bool]\n        for i in 0..<n:\n    \
    \        a.add(rand(1) == 1)\n            b.add(rand(1) == 1)\n            c.add(rand(1)\
    \ == 1)\n            d.add(rand(1) == 1)\n        checkLogic()\n        var x\
    \ = initBitSet(a)\n        var y = initBitSet(b)\n        var z = initBitSet(c)\n\
    \        var w = initBitSet(d)\n        var expected = newSeq[bool](n)\n     \
    \   fuse:\n            x = not ((x xor y) and (z or not w))\n        for i in\
    \ 0..<n: expected[i] = not ((a[i] xor b[i]) and (c[i] or not d[i]))\n        check(x,\
    \ expected)\n        fuse:\n            x = not x\n            x = x xor x\n \
    \           x = not x\n        check(x, newSeqWith(n, true))\n        for k in\
    \ [0, 1, 2, 63, 64, 65, 127, 255, 256, 511, 512, n, n+1, n+100]:\n           \
    \ x = initBitSet(a)\n            fuse:\n                x = x | (x << k)\n   \
    \         for i in 0..<n: expected[i] = a[i] or (i >= k and a[i-k])\n        \
    \    check(x, expected)\n            x = initBitSet(a)\n            fuse:\n  \
    \              x = (x shr k) or x\n            for i in 0..<n: expected[i] = a[i]\
    \ or (i+k < n and a[i+k])\n            check(x, expected)\n            x = initBitSet(a)\n\
    \            fuse:\n                x = (x shl k) or (x shr k)\n            for\
    \ i in 0..<n: expected[i] = (i >= k and a[i-k]) or (i+k < n and a[i+k])\n    \
    \        check(x, expected)\n        x = initBitSet(n+1)\n        fuse:\n    \
    \        x = y xor not z\n        for i in 0..<n: expected[i] = b[i] xor not c[i]\n\
    \        check(x, expected)\n\nblock:\n    var x = initBitSet(65)\n    var y =\
    \ initBitSet(64)\n    var rejected = false\n    try:\n        fuse: x = x or y\n\
    \    except ValueError: rejected = true\n    doAssert rejected\n    rejected =\
    \ false\n    try:\n        fuse: x = x or (x shl -1)\n    except ValueError: rejected\
    \ = true\n    doAssert rejected\n\nblock:\n    var xs = @[initBitSet(65)]\n  \
    \  var y = initBitSet(65)\n    y[64] = true\n    var calls = 0\n    proc source():\
    \ BitSetAvx512 =\n        inc calls\n        y\n    fuse:\n        xs[0] = xs[0]\
    \ or source()\n    doAssert calls == 1 and xs[0][64]\n\necho \"Hello World\"\n\
    \nproc inGeneric[T](unused: T) =\n    var x = initBitSet(513)\n    fuse:\n   \
    \     x = not x\n    doAssert x.popcount == 513\ninGeneric(1)\ninGeneric(1.0)\n\
    \nblock:\n    var x = initBitSet(513)\n    x[8] = true\n    let k = 65\n    fuse:\n\
    \        x = (x shl (k and 63)) or (x shr (k and 63))\n    doAssert x.popcount\
    \ == 2 and x[7] and x[9]\n\nfor n in [0, 1, 63, 64, 65, 511, 512, 513, 1025]:\n\
    \    var a, b, c: seq[bool]\n    for i in 0..<n:\n        a.add(rand(1) == 1)\n\
    \        b.add(rand(1) == 1)\n        c.add(rand(1) == 1)\n    var x = initBitSet(a)\n\
    \    let y = initBitSet(b)\n    let z = initBitSet(c)\n    var expected = newSeq[bool](n)\n\
    \    fuse:\n        x |= y and z\n    for i in 0..<n: expected[i] = a[i] or (b[i]\
    \ and c[i])\n    check(x, expected)\n    fuse:\n        x &= y or not z\n    for\
    \ i in 0..<n: expected[i] = expected[i] and (b[i] or not c[i])\n    check(x, expected)\n\
    \    fuse:\n        x ^= y xor z\n    for i in 0..<n: expected[i] = expected[i]\
    \ xor (b[i] xor c[i])\n    check(x, expected)\n    for k in [0, 1, 63, 64, 65,\
    \ 511, 512, n, n+1]:\n        x = initBitSet(a)\n        fuse:\n            x\
    \ |= x << k\n        for i in 0..<n: expected[i] = a[i] or (i >= k and a[i-k])\n\
    \        check(x, expected)\n        x = initBitSet(a)\n        fuse:\n      \
    \      x |= x shr k\n        for i in 0..<n: expected[i] = a[i] or (i+k < n and\
    \ a[i+k])\n        check(x, expected)\n        x = initBitSet(a)\n        fuse:\n\
    \            x ^= (y shl k) or (z shr k)\n        for i in 0..<n: expected[i]\
    \ = a[i] xor ((i >= k and b[i-k]) or (i+k < n and c[i+k]))\n        check(x, expected)\n\
    \nblock:\n    var xs = @[initBitSet(65)]\n    var y = initBitSet(65)\n    y[64]\
    \ = true\n    var calls = 0\n    proc index(): int =\n        inc calls\n    \
    \    0\n    fuse:\n        xs[index()] |= y and y\n    doAssert calls == 1 and\
    \ xs[0][64]\n"
  dependsOn:
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/bitset_avx512.nim
  isVerificationFile: true
  path: verify/AI/bitset_avx512_fuse_test.nim
  requiredBy: []
  timestamp: '2026-09-14 23:18:26+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_avx512_fuse_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_avx512_fuse_test.nim
- /verify/verify/AI/bitset_avx512_fuse_test.nim.html
title: verify/AI/bitset_avx512_fuse_test.nim
---
