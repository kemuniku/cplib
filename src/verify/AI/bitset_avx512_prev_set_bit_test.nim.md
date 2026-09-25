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
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
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
    import random\nimport cplib/collections/bitset_avx512\n\nproc check(bits: seq[bool])\
    \ =\n    let x = initBitSet(bits)\n    doAssert x.prevSetBit(-1) == -1\n    var\
    \ expected = -1\n    for start in 0..<bits.len:\n        if bits[start]: expected\
    \ = start\n        doAssert x.prevSetBit(start) == expected\n    var pos = x.prevSetBit(x.len\
    \ - 1)\n    var actual: seq[int]\n    while pos >= 0:\n        actual.add(pos)\n\
    \        pos = x.prevSetBit(pos - 1)\n    var indexes: seq[int]\n    for i in\
    \ countdown(bits.len - 1, 0):\n        if bits[i]: indexes.add(i)\n    doAssert\
    \ actual == indexes\n    when compileOption(\"boundChecks\"):\n        for invalid\
    \ in [-2, bits.len]:\n            var rejected = false\n            try:\n   \
    \             discard x.prevSetBit(invalid)\n            except IndexDefect:\n\
    \                rejected = true\n            doAssert rejected\n\nrandomize(156)\n\
    for n in [0, 1, 2, 63, 64, 65, 127, 128, 129, 511, 512, 513, 4097]:\n    var bits\
    \ = newSeq[bool](n)\n    check(bits)\n    for i in 0..<n: bits[i] = true\n   \
    \ check(bits)\n    for pos in [0, 63, 64, 127, 128, 511, 512, n-1]:\n        if\
    \ pos >= 0 and pos < n:\n            bits = newSeq[bool](n)\n            bits[pos]\
    \ = true\n            check(bits)\n    for trial in 0..<20:\n        for i in\
    \ 0..<n: bits[i] = rand(99) < (if trial mod 2 == 0: 1 else: 50)\n        check(bits)\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  isVerificationFile: true
  path: verify/AI/bitset_avx512_prev_set_bit_test.nim
  requiredBy: []
  timestamp: '2026-09-18 12:10:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_avx512_prev_set_bit_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_avx512_prev_set_bit_test.nim
- /verify/verify/AI/bitset_avx512_prev_set_bit_test.nim.html
title: verify/AI/bitset_avx512_prev_set_bit_test.nim
---
