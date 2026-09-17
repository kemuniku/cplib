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
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/edit_distance_bitset_test.nim
    title: verify/AI/edit_distance_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/edit_distance_bitset_test.nim
    title: verify/AI/edit_distance_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/edit_distance_bitset_test.nim
    title: verify/str/edit_distance_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/edit_distance_bitset_test.nim
    title: verify/str/edit_distance_bitset_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_EDIT_DISTANCE_BITSET:\n    const CPLIB_STR_EDIT_DISTANCE_BITSET*\
    \ = 1\n\n    import cplib/collections/bitset_avx512\n\n    proc editDistance_bitset*(s,\
    \ t: string): int =\n        ## \u633F\u5165\u30FB\u524A\u9664\u30FB\u7F6E\u63DB\
    \u3092\u5404\u30B3\u30B9\u30C81\u3068\u3059\u308B\u7DE8\u96C6\u8DDD\u96E2\u3092\
    Myers\u6CD5\u3067\u8FD4\u3057\u307E\u3059\u3002\u5404\u30D0\u30A4\u30C8\u3092\
    1\u6587\u5B57\u3068\u3057\u3066\u6271\u3044\u307E\u3059\u3002\n        ## n =\
    \ max(|s|, |t|), m = min(|s|, |t|)\u3002\u6642\u9593O(n * ceil(m / 64))\u3001\u7A7A\
    \u9593O(256 * ceil(m / 64))\u30EF\u30FC\u30C9\u3002\n        ## AVX-512F\u5BFE\
    \u5FDC\u6642\u306E\u4E3B\u8981\u30EB\u30FC\u30D7\u306F512\u30D3\u30C3\u30C8\u5358\
    \u4F4D\u3067\u51E6\u7406\u3057\u3001\u6642\u9593O(n * ceil(m / 512))\u76F8\u5F53\
    \u3067\u3059\u3002\n        ## \u7A7A\u6587\u5B57\u5217\u306FO(1)\u3002bitset_avx512\u3068\
    \u540C\u3058\u304Famd64\u306EAVX2\u5BFE\u5FDCCPU\u3068GCC/Clang\u304C\u5FC5\u8981\
    \u3067\u3059\u3002\n        if s.len < t.len:\n            return editDistance_bitset(t,\
    \ s)\n        let m = t.len\n        if m == 0:\n            return s.len\n\n\
    \        var matches: array[256, BitSetAvx512]\n        for i, c in t:\n     \
    \       if matches[ord(c)].len == 0:\n                matches[ord(c)] = initBitSet(m)\n\
    \            matches[ord(c)][i] = true\n        # DP\u306E\u7E26\u65B9\u5411\u306E\
    \u5DEE\u5206\u304C+1\u3068-1\u306B\u306A\u308B\u4F4D\u7F6E\u3092\u30D3\u30C3\u30C8\
    \u5217\u3067\u4FDD\u6301\u3057\u307E\u3059\u3002\n        var positive = initBitSet(m)\n\
    \        positive.fill()\n        var negative = initBitSet(m)\n        result\
    \ = m\n\n        for c in s:\n            if matches[ord(c)].len == 0:\n     \
    \           matches[ord(c)] = initBitSet(m)\n            template equal: untyped\
    \ =\n                ## \u73FE\u5728\u306E\u6587\u5B57\u306E\u4E00\u81F4\u30DE\
    \u30B9\u30AF\u3092\u30B3\u30D4\u30FC\u305B\u305A\u53C2\u7167\u3057\u307E\u3059\
    \u3002\n                matches[ord(c)]\n            var positiveLast, negativeLast:\
    \ bool\n            fuse:\n                let vertical = equal or negative\n\
    \                let horizontal = (((equal and positive) + positive) xor positive)\
    \ or equal\n                let positiveHorizontal = not (horizontal or positive)\
    \ or negative\n                let negativeHorizontal = positive and horizontal\n\
    \                var shiftedPositive = positiveHorizontal shl 1\n            \
    \    shiftedPositive[0] = true\n                positive = not (vertical or shiftedPositive)\
    \ or (negativeHorizontal shl 1)\n                negative = shiftedPositive and\
    \ vertical\n                positiveLast = lastBit(positiveHorizontal)\n     \
    \           negativeLast = lastBit(negativeHorizontal)\n            result +=\
    \ ord(positiveLast) - ord(negativeLast)\n"
  dependsOn:
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_search_impl.nim
  isVerificationFile: false
  path: cplib/str/edit_distance_bitset.nim
  requiredBy: []
  timestamp: '2026-09-17 21:00:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/edit_distance_bitset_test.nim
  - verify/str/edit_distance_bitset_test.nim
  - verify/AI/edit_distance_bitset_test.nim
  - verify/AI/edit_distance_bitset_test.nim
documentation_of: cplib/str/edit_distance_bitset.nim
layout: document
redirect_from:
- /library/cplib/str/edit_distance_bitset.nim
- /library/cplib/str/edit_distance_bitset.nim.html
title: cplib/str/edit_distance_bitset.nim
---
