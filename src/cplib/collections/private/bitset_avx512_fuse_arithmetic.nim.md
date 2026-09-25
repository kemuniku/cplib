---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
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
    path: cplib/str/edit_distance_bitset.nim
    title: cplib/str/edit_distance_bitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/edit_distance_bitset.nim
    title: cplib/str/edit_distance_bitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/lcs_bitset.nim
    title: cplib/str/lcs_bitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/lcs_bitset.nim
    title: cplib/str/lcs_bitset.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_add_test.nim
    title: verify/AI/bitset_avx512_add_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_add_test.nim
    title: verify/AI/bitset_avx512_add_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_arithmetic_test.nim
    title: verify/AI/bitset_avx512_fuse_arithmetic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_arithmetic_test.nim
    title: verify/AI/bitset_avx512_fuse_arithmetic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_block_test.nim
    title: verify/AI/bitset_avx512_fuse_block_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_block_test.nim
    title: verify/AI/bitset_avx512_fuse_block_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_test.nim
    title: verify/AI/bitset_avx512_fuse_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_test.nim
    title: verify/AI/bitset_avx512_fuse_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_prev_set_bit_test.nim
    title: verify/AI/bitset_avx512_prev_set_bit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_prev_set_bit_test.nim
    title: verify/AI/bitset_avx512_prev_set_bit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_shift_assign_test.nim
    title: verify/AI/bitset_avx512_shift_assign_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_shift_assign_test.nim
    title: verify/AI/bitset_avx512_shift_assign_test.nim
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
  - icon: ':heavy_check_mark:'
    path: verify/str/lcs_bitset_test.nim
    title: verify/str/lcs_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/lcs_bitset_test.nim
    title: verify/str/lcs_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/restore_lcs_bitset_test.nim
    title: verify/str/restore_lcs_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/restore_lcs_bitset_test.nim
    title: verify/str/restore_lcs_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/backwards_index_simd_test.nim
    title: verify/utils/backwards_index_simd_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/backwards_index_simd_test.nim
    title: verify/utils/backwards_index_simd_test.nim
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
  code: "## \u878D\u5408\u30AB\u30FC\u30CD\u30EB\u306B\u57CB\u3081\u8FBC\u3080\u52A0\
    \u7B97\u30FB\u30B7\u30D5\u30C8\u7528\u306E\u88DC\u52A9\u95A2\u6570\u3067\u3059\
    \u3002\nconst fuseArithmeticPrefix = \"\"\"\n#ifndef CPLIB_FUSE_ARITHMETIC_HELPERS\n\
    #define CPLIB_FUSE_ARITHMETIC_HELPERS\n#include <immintrin.h>\n#include <stdint.h>\n\
    #include <stddef.h>\nstatic inline uint64_t cplib_fuse_add64(uint64_t a, uint64_t\
    \ b, unsigned *carry) {\nuint64_t sum = a+b, total = sum+*carry;\n*carry = (sum<a)\
    \ | (total<sum);\nreturn total;\n}\n__attribute__((target(\"avx512f\"))) static\
    \ inline __m512i cplib_fuse_add512(__m512i a, __m512i b, unsigned *carry) {\n\
    __m512i sum = _mm512_add_epi64(a,b);\nunsigned g = _mm512_cmp_epu64_mask(sum,a,_MM_CMPINT_LT);\n\
    unsigned p = _mm512_cmpeq_epi64_mask(sum,_mm512_set1_epi64(-1));\nunsigned c =\
    \ (p+(g<<1)+*carry)^p;\n*carry = c>>8;\nreturn _mm512_mask_add_epi64(sum,(__mmask8)c,sum,_mm512_set1_epi64(1));\n\
    }\nstatic inline uint64_t cplib_fuse_word(const uint64_t *x, size_t n, ptrdiff_t\
    \ i) {\nreturn i>=0 && (size_t)i<n ? x[i] : 0;\n}\nstatic inline uint64_t cplib_fuse_shift0(const\
    \ uint64_t *x, size_t n, size_t i, size_t k, int left) {\nptrdiff_t j = (ptrdiff_t)i\
    \ + (left ? -(ptrdiff_t)(k>>6) : (ptrdiff_t)(k>>6));\nunsigned b=k&63;\nuint64_t\
    \ a=cplib_fuse_word(x,n,j);\nif (!b) return a;\nreturn left ? (a<<b)|(cplib_fuse_word(x,n,j-1)>>(64-b))\
    \ : (a>>b)|(cplib_fuse_word(x,n,j+1)<<(64-b));\n}\n\"\"\"\nconst fuseArithmeticHelpers\
    \ = block:\n    var code = fuseArithmeticPrefix\n    for width in [256,512]:\n\
    \        let w = $width\n        let lanes = $(width div 64)\n        let target\
    \ = if width == 512: \"avx512f\" else: \"avx2\"\n        let castType = if width\
    \ == 512: \"void\" else: \"__m256i\"\n        code.add(\"__attribute__((target(\\\
    \"\" & target & \"\\\"))) static inline __m\" & w & \"i cplib_fuse_load\" & w\
    \ & \"(const uint64_t *x,size_t n,ptrdiff_t j) {\\n\")\n        code.add(\"if\
    \ (j>=0 && (size_t)j+\" & lanes & \"<=n) return _mm\" & w & \"_loadu_si\" & w\
    \ & \"((const \" & castType & \" *)(x+j));\\n\")\n        code.add(\"uint64_t\
    \ a[\" & lanes & \"]; for (int q=0;q<\" & lanes & \";++q) a[q]=cplib_fuse_word(x,n,j+q);\\\
    nreturn _mm\" & w & \"_loadu_si\" & w & \"((const \" & castType & \" *)a);\\n}\\\
    n\")\n        code.add(\"__attribute__((target(\\\"\" & target & \"\\\"))) static\
    \ inline __m\" & w & \"i cplib_fuse_shift\" & w & \"(const uint64_t *x,size_t\
    \ n,size_t i,size_t k,int left) {\\n\")\n        code.add(\"ptrdiff_t j=(ptrdiff_t)i+(left\
    \ ? -(ptrdiff_t)(k>>6) : (ptrdiff_t)(k>>6)); unsigned b=k&63;\\n\")\n        code.add(\"\
    __m\" & w & \"i a=cplib_fuse_load\" & w & \"(x,n,j); if (!b) return a;\\n\")\n\
    \        code.add(\"__m128i s=_mm_cvtsi32_si128(b), t=_mm_cvtsi32_si128(64-b);\\\
    n\")\n        for left in [true,false]:\n            let s1=if left: \"sll\" else:\
    \ \"srl\"\n            let s2=if left: \"srl\" else: \"sll\"\n            code.add((if\
    \ left: \"if (left) \" else: \"\") & \"return _mm\" & w & \"_or_si\" & w & \"\
    (_mm\" & w & \"_\" & s1 & \"_epi64(a,s),_mm\" & w & \"_\" & s2 & \"_epi64(cplib_fuse_load\"\
    \ & w & \"(x,n,j\" & (if left: \"-1\" else: \"+1\") & \"),t));\\n\")\n       \
    \ code.add(\"}\\n\")\n    code & \"#endif\\n\"\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  requiredBy:
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/str/lcs_bitset.nim
  - cplib/str/lcs_bitset.nim
  - cplib/str/edit_distance_bitset.nim
  - cplib/str/edit_distance_bitset.nim
  timestamp: '2026-09-17 21:00:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/backwards_index_simd_test.nim
  - verify/utils/backwards_index_simd_test.nim
  - verify/AI/bitset_avx512_add_test.nim
  - verify/AI/bitset_avx512_add_test.nim
  - verify/AI/bitset_avx512_prev_set_bit_test.nim
  - verify/AI/bitset_avx512_prev_set_bit_test.nim
  - verify/AI/bitset_avx512_shift_assign_test.nim
  - verify/AI/bitset_avx512_shift_assign_test.nim
  - verify/AI/bitset_avx512_fuse_test.nim
  - verify/AI/bitset_avx512_fuse_test.nim
  - verify/AI/bitset_avx512_fuse_block_test.nim
  - verify/AI/bitset_avx512_fuse_block_test.nim
  - verify/AI/edit_distance_bitset_test.nim
  - verify/AI/edit_distance_bitset_test.nim
  - verify/AI/bitset_avx512_fuse_arithmetic_test.nim
  - verify/AI/bitset_avx512_fuse_arithmetic_test.nim
  - verify/str/edit_distance_bitset_test.nim
  - verify/str/edit_distance_bitset_test.nim
  - verify/str/lcs_bitset_test.nim
  - verify/str/lcs_bitset_test.nim
  - verify/str/restore_lcs_bitset_test.nim
  - verify/str/restore_lcs_bitset_test.nim
documentation_of: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
layout: document
redirect_from:
- /library/cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
- /library/cplib/collections/private/bitset_avx512_fuse_arithmetic.nim.html
title: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
---
