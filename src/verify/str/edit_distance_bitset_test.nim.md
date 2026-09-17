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
    path: cplib/str/edit_distance_bitset.nim
    title: cplib/str/edit_distance_bitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/edit_distance_bitset.nim
    title: cplib/str/edit_distance_bitset.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/DPL_1_E
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/DPL_1_E
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/DPL_1_E


    import cplib/str/edit_distance_bitset


    let s = stdin.readLine()

    let t = stdin.readLine()

    echo editDistance_bitset(s, t)

    '
  dependsOn:
  - cplib/str/edit_distance_bitset.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/str/edit_distance_bitset.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/bitset_avx512.nim
  isVerificationFile: true
  path: verify/str/edit_distance_bitset_test.nim
  requiredBy: []
  timestamp: '2026-09-17 21:00:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/edit_distance_bitset_test.nim
layout: document
redirect_from:
- /verify/verify/str/edit_distance_bitset_test.nim
- /verify/verify/str/edit_distance_bitset_test.nim.html
title: verify/str/edit_distance_bitset_test.nim
---
