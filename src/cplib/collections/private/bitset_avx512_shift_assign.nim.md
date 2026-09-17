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
  code: "## \u7834\u58CA\u7684\u30B7\u30D5\u30C8\u3092\u5165\u529B\u3092\u58CA\u3055\
    \u306A\u3044\u65B9\u5411\u3067SIMD\u51E6\u7406\u3057\u307E\u3059\u3002\n{.emit:\
    \ \"\"\"\n#include <immintrin.h>\n#include <stdint.h>\n#include <stddef.h>\n__attribute__((target(\"\
    avx2\"))) static void cplib_assign_left_4(uint64_t *x, size_t n, size_t k) {\n\
    size_t off = k >> 6; unsigned b = k & 63;\nconst __m128i s = _mm_cvtsi32_si128(b),\
    \ t = _mm_cvtsi32_si128(64-b);\nsize_t end = n;\nwhile (end >= off + (b != 0)\
    \ + 4) {\nsize_t j = end - 4;\n__m256i v = _mm256_loadu_si256((const __m256i *)(x+(j-off)));\n\
    if (b) v = _mm256_or_si256(_mm256_sll_epi64(v,s), _mm256_srl_epi64(_mm256_loadu_si256((const\
    \ __m256i *)(x+(j-off-1))),t));\n_mm256_storeu_si256((__m256i *)(x+(j)), v);\n\
    end -= 4;\n}\nwhile (end > off) { size_t j = --end; uint64_t v = x[j-off] << b;\
    \ if (b && j > off) v |= x[j-off-1] >> (64-b); x[j] = v; }\nfor (size_t z = 0;\
    \ z < off; ++z) x[z] = 0;\n}\n__attribute__((target(\"avx2\"))) static void cplib_assign_right_4(uint64_t\
    \ *x, size_t n, size_t k) {\nsize_t off = k >> 6; unsigned b = k & 63;\nconst\
    \ __m128i s = _mm_cvtsi32_si128(b), t = _mm_cvtsi32_si128(64-b);\nsize_t j = 0,\
    \ count = n-off;\nwhile (j + 4 + (b != 0) <= count) {\n__m256i v = _mm256_loadu_si256((const\
    \ __m256i *)(x+(j+off)));\nif (b) v = _mm256_or_si256(_mm256_srl_epi64(v,s), _mm256_sll_epi64(_mm256_loadu_si256((const\
    \ __m256i *)(x+(j+off+1))),t));\n_mm256_storeu_si256((__m256i *)(x+(j)), v);\n\
    j += 4;\n}\nfor (; j < count; ++j) { uint64_t v = x[j+off] >> b; if (b && j+off+1\
    \ < n) v |= x[j+off+1] << (64-b); x[j] = v; }\nfor (; j < n; ++j) x[j] = 0;\n\
    }\n__attribute__((target(\"avx512f\"))) static void cplib_assign_left_8(uint64_t\
    \ *x, size_t n, size_t k) {\nsize_t off = k >> 6; unsigned b = k & 63;\nconst\
    \ __m128i s = _mm_cvtsi32_si128(b), t = _mm_cvtsi32_si128(64-b);\nsize_t end =\
    \ n;\nwhile (end >= off + (b != 0) + 8) {\nsize_t j = end - 8;\n__m512i v = _mm512_loadu_si512((const\
    \ void *)(x+(j-off)));\nif (b) v = _mm512_or_si512(_mm512_sll_epi64(v,s), _mm512_srl_epi64(_mm512_loadu_si512((const\
    \ void *)(x+(j-off-1))),t));\n_mm512_storeu_si512((void *)(x+(j)), v);\nend -=\
    \ 8;\n}\nwhile (end > off) { size_t j = --end; uint64_t v = x[j-off] << b; if\
    \ (b && j > off) v |= x[j-off-1] >> (64-b); x[j] = v; }\nfor (size_t z = 0; z\
    \ < off; ++z) x[z] = 0;\n}\n__attribute__((target(\"avx512f\"))) static void cplib_assign_right_8(uint64_t\
    \ *x, size_t n, size_t k) {\nsize_t off = k >> 6; unsigned b = k & 63;\nconst\
    \ __m128i s = _mm_cvtsi32_si128(b), t = _mm_cvtsi32_si128(64-b);\nsize_t j = 0,\
    \ count = n-off;\nwhile (j + 8 + (b != 0) <= count) {\n__m512i v = _mm512_loadu_si512((const\
    \ void *)(x+(j+off)));\nif (b) v = _mm512_or_si512(_mm512_srl_epi64(v,s), _mm512_sll_epi64(_mm512_loadu_si512((const\
    \ void *)(x+(j+off+1))),t));\n_mm512_storeu_si512((void *)(x+(j)), v);\nj += 8;\n\
    }\nfor (; j < count; ++j) { uint64_t v = x[j+off] >> b; if (b && j+off+1 < n)\
    \ v |= x[j+off+1] << (64-b); x[j] = v; }\nfor (; j < n; ++j) x[j] = 0;\n}\nstatic\
    \ void cplib_assign_left(uint64_t *x, size_t n, size_t k) {\nif (__builtin_cpu_supports(\"\
    avx512f\")) cplib_assign_left_8(x,n,k); else cplib_assign_left_4(x,n,k);\n}\n\
    static void cplib_assign_right(uint64_t *x, size_t n, size_t k) {\nif (__builtin_cpu_supports(\"\
    avx512f\")) cplib_assign_right_8(x,n,k); else cplib_assign_right_4(x,n,k);\n}\n\
    \"\"\".}\n\nproc avxShiftLeftAssign(x: ptr uint64, n, k: csize_t) {.importc: \"\
    cplib_assign_left\", nodecl.}\nproc avxShiftRightAssign(x: ptr uint64, n, k: csize_t)\
    \ {.importc: \"cplib_assign_right\", nodecl.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/private/bitset_avx512_shift_assign.nim
  requiredBy:
  - cplib/str/edit_distance_bitset.nim
  - cplib/str/edit_distance_bitset.nim
  - cplib/str/lcs_bitset.nim
  - cplib/str/lcs_bitset.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/bitset_avx512.nim
  timestamp: '2026-09-17 21:00:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/restore_lcs_bitset_test.nim
  - verify/str/restore_lcs_bitset_test.nim
  - verify/str/edit_distance_bitset_test.nim
  - verify/str/edit_distance_bitset_test.nim
  - verify/str/lcs_bitset_test.nim
  - verify/str/lcs_bitset_test.nim
  - verify/AI/bitset_avx512_fuse_test.nim
  - verify/AI/bitset_avx512_fuse_test.nim
  - verify/AI/bitset_avx512_fuse_arithmetic_test.nim
  - verify/AI/bitset_avx512_fuse_arithmetic_test.nim
  - verify/AI/edit_distance_bitset_test.nim
  - verify/AI/edit_distance_bitset_test.nim
  - verify/AI/bitset_avx512_fuse_block_test.nim
  - verify/AI/bitset_avx512_fuse_block_test.nim
  - verify/AI/bitset_avx512_prev_set_bit_test.nim
  - verify/AI/bitset_avx512_prev_set_bit_test.nim
  - verify/AI/bitset_avx512_shift_assign_test.nim
  - verify/AI/bitset_avx512_shift_assign_test.nim
  - verify/AI/bitset_avx512_add_test.nim
  - verify/AI/bitset_avx512_add_test.nim
documentation_of: cplib/collections/private/bitset_avx512_shift_assign.nim
layout: document
redirect_from:
- /library/cplib/collections/private/bitset_avx512_shift_assign.nim
- /library/cplib/collections/private/bitset_avx512_shift_assign.nim.html
title: cplib/collections/private/bitset_avx512_shift_assign.nim
---
