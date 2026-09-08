---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx2.nim
    title: cplib/collections/bitset_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx2.nim
    title: cplib/collections/bitset_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticbitset_avx2.nim
    title: cplib/collections/staticbitset_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticbitset_avx2.nim
    title: cplib/collections/staticbitset_avx2.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx2_test.nim
    title: verify/AI/bitset_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx2_test.nim
    title: verify/AI/bitset_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/staticbitset_avx2_test.nim
    title: verify/AI/staticbitset_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/staticbitset_avx2_test.nim
    title: verify/AI/staticbitset_avx2_test.nim
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
  code: "## \u52D5\u7684\u7248\u3068\u9759\u7684\u7248\u306E\u4E21\u65B9\u3067\u4F7F\
    \u3046AVX2\u30AB\u30FC\u30CD\u30EB\u3067\u3059\u3002\u5404\u30E2\u30B8\u30E5\u30FC\
    \u30EB\u306Binclude\u3057\u307E\u3059\u3002\n{.emit: \"\"\"\n#ifndef CPLIB_BITSET_AVX2_IMPL\n\
    #define CPLIB_BITSET_AVX2_IMPL\n#include <immintrin.h>\n#include <stdint.h>\n\
    #include <stddef.h>\n#define CPLIB_BS_AVX2 __attribute__((target(\"avx2\")))\n\
    \n#define CPLIB_BS_BINARY(name, scalar, vector) \\\nCPLIB_BS_AVX2 static void\
    \ name(uint64_t *dst, const uint64_t *x, \\\n                           const\
    \ uint64_t *y, size_t n) { \\\n/* 256\u30D3\u30C3\u30C8\u305A\u3064\u8AD6\u7406\
    \u6F14\u7B97\u3057\u3001\u6B8B\u308A\u309264\u30D3\u30C3\u30C8\u305A\u3064\u51E6\
    \u7406\u3057\u307E\u3059\u3002 */ \\\nsize_t i = 0; \\\nfor (; i + 4 <= n; i +=\
    \ 4) { \\\n    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i)); \\\n\
    \    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i)); \\\n    _mm256_storeu_si256((__m256i\
    \ *)(dst + i), vector(a, b)); \\\n} \\\nfor (; i < n; ++i) dst[i] = x[i] scalar\
    \ y[i]; \\\n}\nCPLIB_BS_BINARY(cplib_bs_and, &, _mm256_and_si256)\nCPLIB_BS_BINARY(cplib_bs_or,\
    \ |, _mm256_or_si256)\nCPLIB_BS_BINARY(cplib_bs_xor, ^, _mm256_xor_si256)\n#undef\
    \ CPLIB_BS_BINARY\n\nCPLIB_BS_AVX2 static void cplib_bs_not(uint64_t *dst, const\
    \ uint64_t *x, size_t n) {\n/* 256\u30D3\u30C3\u30C8\u305A\u3064\u53CD\u8EE2\u3057\
    \u307E\u3059\u3002 */\nconst __m256i ones = _mm256_set1_epi64x(-1);\nsize_t i\
    \ = 0;\nfor (; i + 4 <= n; i += 4)\n    _mm256_storeu_si256((__m256i *)(dst +\
    \ i), _mm256_xor_si256(\n        _mm256_loadu_si256((const __m256i *)(x + i)),\
    \ ones));\nfor (; i < n; ++i) dst[i] = ~x[i];\n}\n\nCPLIB_BS_AVX2 static void\
    \ cplib_bs_shl(uint64_t *dst, const uint64_t *x,\n                           \
    \      size_t n, size_t shift) {\n/* \u30BC\u30ED\u521D\u671F\u5316\u6E08\u307F\
    \u306E\u5225\u9818\u57DF\u3078\u5DE6\u30B7\u30D5\u30C8\u3057\u3001\u96A3\u63A5\
    \u30EF\u30FC\u30C9\u304B\u3089\u306E\u6841\u4E0A\u304C\u308A\u3082\u51E6\u7406\
    \u3057\u307E\u3059\u3002 */\nconst size_t offset = shift >> 6;\nconst unsigned\
    \ bits = shift & 63;\nconst size_t count = n - offset;\nsize_t i = 0;\nif (bits\
    \ == 0) {\n    for (; i + 4 <= count; i += 4)\n        _mm256_storeu_si256((__m256i\
    \ *)(dst + offset + i),\n            _mm256_loadu_si256((const __m256i *)(x +\
    \ i)));\n    for (; i < count; ++i) dst[offset + i] = x[i];\n    return;\n}\n\
    const __m128i left = _mm_cvtsi32_si128(bits);\nconst __m128i right = _mm_cvtsi32_si128(64\
    \ - bits);\ndst[offset] = x[0] << bits;\ni = 1;\nfor (; i + 4 <= count; i += 4)\
    \ {\n    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));\n    __m256i\
    \ b = _mm256_loadu_si256((const __m256i *)(x + i - 1));\n    _mm256_storeu_si256((__m256i\
    \ *)(dst + offset + i), _mm256_or_si256(\n        _mm256_sll_epi64(a, left), _mm256_srl_epi64(b,\
    \ right)));\n}\nfor (; i < count; ++i)\n    dst[offset + i] = (x[i] << bits) |\
    \ (x[i - 1] >> (64 - bits));\n}\n\nCPLIB_BS_AVX2 static void cplib_bs_shr(uint64_t\
    \ *dst, const uint64_t *x,\n                                 size_t n, size_t\
    \ shift) {\n/* \u30BC\u30ED\u521D\u671F\u5316\u6E08\u307F\u306E\u5225\u9818\u57DF\
    \u3078\u53F3\u30B7\u30D5\u30C8\u3057\u3001\u96A3\u63A5\u30EF\u30FC\u30C9\u304B\
    \u3089\u306E\u6841\u4E0B\u304C\u308A\u3082\u51E6\u7406\u3057\u307E\u3059\u3002\
    \ */\nconst size_t offset = shift >> 6;\nconst unsigned bits = shift & 63;\nconst\
    \ size_t count = n - offset;\nsize_t i = 0;\nif (bits == 0) {\n    for (; i +\
    \ 4 <= count; i += 4)\n        _mm256_storeu_si256((__m256i *)(dst + i),\n   \
    \         _mm256_loadu_si256((const __m256i *)(x + offset + i)));\n    for (;\
    \ i < count; ++i) dst[i] = x[offset + i];\n    return;\n}\nconst __m128i right\
    \ = _mm_cvtsi32_si128(bits);\nconst __m128i left = _mm_cvtsi32_si128(64 - bits);\n\
    for (; i + 4 < count; i += 4) {\n    __m256i a = _mm256_loadu_si256((const __m256i\
    \ *)(x + offset + i));\n    __m256i b = _mm256_loadu_si256((const __m256i *)(x\
    \ + offset + i + 1));\n    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_or_si256(\n\
    \        _mm256_srl_epi64(a, right), _mm256_sll_epi64(b, left)));\n}\nfor (; i\
    \ + 1 < count; ++i)\n    dst[i] = (x[offset + i] >> bits) | (x[offset + i + 1]\
    \ << (64 - bits));\ndst[count - 1] = x[n - 1] >> bits;\n}\n\nCPLIB_BS_AVX2 static\
    \ inline __m256i cplib_bs_byte_counts(__m256i x) {\n/* 4\u30D3\u30C3\u30C8\u306E\
    \u53C2\u7167\u8868\u304B\u3089\u5404\u30D0\u30A4\u30C8\u306E\u7ACB\u3063\u3066\
    \u3044\u308B\u30D3\u30C3\u30C8\u6570\u3092\u6C42\u3081\u307E\u3059\u3002 */\n\
    const __m256i table = _mm256_setr_epi8(\n    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2,\
    \ 3, 2, 3, 3, 4,\n    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4);\nconst\
    \ __m256i mask = _mm256_set1_epi8(15);\nreturn _mm256_add_epi8(\n    _mm256_shuffle_epi8(table,\
    \ _mm256_and_si256(x, mask)),\n    _mm256_shuffle_epi8(table, _mm256_and_si256(_mm256_srli_epi16(x,\
    \ 4), mask)));\n}\n\n#define CPLIB_BS_COUNT(name, scalar, vector) \\\nCPLIB_BS_AVX2\
    \ static size_t name(const uint64_t *x, const uint64_t *y, size_t n) { \\\n/*\
    \ 16\u30D9\u30AF\u30C8\u30EB\u3054\u3068\u306B\u30D0\u30A4\u30C8\u306E\u548C\u3092\
    64\u30D3\u30C3\u30C8\u3078\u96C6\u7D04\u3057\u3001\u6841\u3042\u3075\u308C\u3092\
    \u9632\u304E\u307E\u3059\u3002 */ \\\n__m256i total = _mm256_setzero_si256();\
    \ \\\nsize_t i = 0; \\\nwhile (i + 4 <= n) { \\\n    __m256i local = _mm256_setzero_si256();\
    \ \\\n    size_t end = n - i < 64 ? n : i + 64; \\\n    for (; i + 4 <= end; i\
    \ += 4) { \\\n        __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));\
    \ \\\n        __m256i b = _mm256_loadu_si256((const __m256i *)(y + i)); \\\n \
    \       local = _mm256_add_epi8(local, cplib_bs_byte_counts(vector)); \\\n   \
    \ } \\\n    total = _mm256_add_epi64(total, _mm256_sad_epu8(local, _mm256_setzero_si256()));\
    \ \\\n} \\\nuint64_t lanes[4]; \\\n_mm256_storeu_si256((__m256i *)lanes, total);\
    \ \\\nsize_t result = lanes[0] + lanes[1] + lanes[2] + lanes[3]; \\\nfor (; i\
    \ < n; ++i) result += __builtin_popcountll(scalar); \\\nreturn result; \\\n}\n\
    CPLIB_BS_COUNT(cplib_bs_popcount, x[i], a)\nCPLIB_BS_COUNT(cplib_bs_andpopcount,\
    \ x[i] & y[i], _mm256_and_si256(a, b))\nCPLIB_BS_COUNT(cplib_bs_orpopcount, x[i]\
    \ | y[i], _mm256_or_si256(a, b))\nCPLIB_BS_COUNT(cplib_bs_xorpopcount, x[i] ^\
    \ y[i], _mm256_xor_si256(a, b))\n#undef CPLIB_BS_COUNT\n\nCPLIB_BS_AVX2 static\
    \ uint32_t cplib_bs_bool_mask(const unsigned char *src) {\n    /* 32\u500B\u306E\
    bool\u3092\u6BD4\u8F03\u3057\u3001\u975E\u30BC\u30ED\u306E\u4F4D\u7F6E\u309232\u30D3\
    \u30C3\u30C8\u306E\u30DE\u30B9\u30AF\u306B\u8A70\u3081\u307E\u3059\u3002 */\n\
    \    __m256i values = _mm256_loadu_si256((const __m256i *)src);\n    return ~(uint32_t)_mm256_movemask_epi8(\n\
    \        _mm256_cmpeq_epi8(values, _mm256_setzero_si256()));\n}\n\nCPLIB_BS_AVX2\
    \ static void cplib_bs_from_bools(uint64_t *dst, const void *source,\n       \
    \                                     size_t length, size_t words) {\n    /* \u5165\
    \u529B\u309264\u30D3\u30C3\u30C8\u305A\u3064\u8A70\u3081\u3001\u7AEF\u6570\u3068\
    \u5165\u529B\u3088\u308A\u5F8C\u308D\u306E\u30EF\u30FC\u30C9\u3082\u3059\u3079\
    \u3066\u66F8\u304D\u8FBC\u307F\u307E\u3059\u3002 */\n    const unsigned char *src\
    \ = (const unsigned char *)source;\n    size_t i = 0, word = 0;\n    for (; i\
    \ + 64 <= length; i += 64) {\n        uint64_t low = cplib_bs_bool_mask(src +\
    \ i);\n        uint64_t high = cplib_bs_bool_mask(src + i + 32);\n        dst[word++]\
    \ = low | (high << 32);\n    }\n    if (i < length) {\n        uint64_t value\
    \ = 0;\n        size_t j = 0;\n        if (length - i >= 32) {\n            value\
    \ = cplib_bs_bool_mask(src + i);\n            j = 32;\n        }\n        for\
    \ (; j < length - i; ++j)\n            value |= (uint64_t)(src[i + j] != 0) <<\
    \ j;\n        dst[word++] = value;\n    }\n    for (; word < words; ++word) dst[word]\
    \ = 0;\n}\n#undef CPLIB_BS_AVX2\n#endif\n\"\"\".}\n\nproc avxAnd(dst, x, y: ptr\
    \ uint64, n: csize_t) {.importc: \"cplib_bs_and\", nodecl.}\nproc avxOr(dst, x,\
    \ y: ptr uint64, n: csize_t) {.importc: \"cplib_bs_or\", nodecl.}\nproc avxXor(dst,\
    \ x, y: ptr uint64, n: csize_t) {.importc: \"cplib_bs_xor\", nodecl.}\nproc avxNot(dst,\
    \ x: ptr uint64, n: csize_t) {.importc: \"cplib_bs_not\", nodecl.}\nproc avxShl(dst,\
    \ x: ptr uint64, n, shift: csize_t) {.importc: \"cplib_bs_shl\", nodecl.}\nproc\
    \ avxShr(dst, x: ptr uint64, n, shift: csize_t) {.importc: \"cplib_bs_shr\", nodecl.}\n\
    proc avxPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc: \"cplib_bs_popcount\"\
    , nodecl.}\nproc avxAndPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc:\
    \ \"cplib_bs_andpopcount\", nodecl.}\nproc avxOrPopcount(x, y: ptr uint64, n:\
    \ csize_t): csize_t {.importc: \"cplib_bs_orpopcount\", nodecl.}\nproc avxXorPopcount(x,\
    \ y: ptr uint64, n: csize_t): csize_t {.importc: \"cplib_bs_xorpopcount\", nodecl.}\n\
    proc avxFromBools(dst: ptr uint64, src: pointer, length, words: csize_t) {.importc:\
    \ \"cplib_bs_from_bools\", nodecl.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/private/bitset_avx2_impl.nim
  requiredBy:
  - cplib/collections/bitset_avx2.nim
  - cplib/collections/bitset_avx2.nim
  - cplib/collections/staticbitset_avx2.nim
  - cplib/collections/staticbitset_avx2.nim
  timestamp: '2026-09-08 11:45:42+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/staticbitset_avx2_test.nim
  - verify/AI/staticbitset_avx2_test.nim
  - verify/AI/bitset_avx2_test.nim
  - verify/AI/bitset_avx2_test.nim
documentation_of: cplib/collections/private/bitset_avx2_impl.nim
layout: document
redirect_from:
- /library/cplib/collections/private/bitset_avx2_impl.nim
- /library/cplib/collections/private/bitset_avx2_impl.nim.html
title: cplib/collections/private/bitset_avx2_impl.nim
---
