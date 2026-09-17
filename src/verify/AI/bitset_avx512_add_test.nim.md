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
    \nimport random\nimport cplib/collections/bitset_avx512\ninclude cplib/collections/private/bitset_avx512_impl\n\
    \nproc addCarries(generated, propagated, carry: cuint): cuint {.importc: \"cplib_bs512_add_carries\"\
    , nodecl.}\n\nfor generated in 0..255:\n    for propagated in 0..255:\n      \
    \  if (generated and propagated) != 0:\n            continue\n        for incoming\
    \ in 0..1:\n            var carry = incoming\n            var expected = incoming\n\
    \            for lane in 0..<8:\n                carry = ((generated shr lane)\
    \ and 1) or (((propagated shr lane) and 1) and carry)\n                expected\
    \ = expected or (carry shl (lane + 1))\n            doAssert addCarries(generated.cuint,\
    \ propagated.cuint, incoming.cuint) == expected.cuint\n\nproc check(a, b: seq[bool])\
    \ =\n    var expected = newSeq[bool](a.len)\n    var carry = 0\n    for i in 0..<a.len:\n\
    \        let sum = ord(a[i]) + ord(b[i]) + carry\n        expected[i] = (sum and\
    \ 1) != 0\n        carry = sum shr 1\n    var x = initBitSet(a)\n    var y = initBitSet(b)\n\
    \    var dst = initBitSet(a.len)\n    dst.fill()\n    dst.addInto(x, y)\n    doAssert\
    \ $dst == $initBitSet(expected)\n    doAssert $x == $initBitSet(a)\n    doAssert\
    \ $y == $initBitSet(b)\n    x.addInto(x, y)\n    doAssert $x == $dst\n    x =\
    \ initBitSet(a)\n    y.addInto(x, y)\n    doAssert $y == $dst\n    dst.addInto(x,\
    \ x)\n    x.addInto(x, x)\n    doAssert $x == $dst\n\nvar rng = initRand(71283)\n\
    for n in [0, 1, 2, 63, 64, 65, 127, 128, 129, 255, 256, 257, 511, 512, 513, 1023,\
    \ 1024, 1025, 4097]:\n    var a = newSeq[bool](n)\n    var b = newSeq[bool](n)\n\
    \    check(a, b)\n    for i in 0..<n:\n        a[i] = true\n    if n > 0:\n  \
    \      b[0] = true\n    check(a, b)\n    check(a, a)\n    for trial in 0..<50:\n\
    \        for i in 0..<n:\n            a[i] = rng.rand(1) == 1\n            b[i]\
    \ = rng.rand(1) == 1\n        check(a, b)\n\nwhen compileOption(\"boundChecks\"\
    ):\n    var dst = initBitSet(1)\n    var raised = false\n    try:\n        dst.addInto(initBitSet(1),\
    \ initBitSet(2))\n    except ValueError:\n        raised = true\n    doAssert\
    \ raised\n    raised = false\n    try:\n        dst.addInto(initBitSet(2), initBitSet(2))\n\
    \    except ValueError:\n        raised = true\n    doAssert raised\n\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  isVerificationFile: true
  path: verify/AI/bitset_avx512_add_test.nim
  requiredBy: []
  timestamp: '2026-09-17 21:00:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_avx512_add_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_avx512_add_test.nim
- /verify/verify/AI/bitset_avx512_add_test.nim.html
title: verify/AI/bitset_avx512_add_test.nim
---
