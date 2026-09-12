---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':warning:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  - icon: ':warning:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  - icon: ':warning:'
    path: cplib/collections/staticbitset_avx512.nim
    title: cplib/collections/staticbitset_avx512.nim
  - icon: ':warning:'
    path: cplib/collections/staticbitset_avx512.nim
    title: cplib/collections/staticbitset_avx512.nim
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "## \u52D5\u7684\u7248\u3068\u56FA\u5B9A\u9577\u7248\u3067\u5171\u6709\u3059\
    \u308BAVX2/AVX-512\u30AB\u30FC\u30CD\u30EB\u3067\u3059\u3002\u5B9F\u884C\u6642\
    \u306B\u547D\u4EE4\u3092\u9078\u629E\u3057\u307E\u3059\u3002\n{.emit: \"\"\"\n\
    #ifndef CPLIB_BITSET_AVX512_IMPL\n#define CPLIB_BITSET_AVX512_IMPL\n#include <immintrin.h>\n\
    #include <stdint.h>\n#include <stddef.h>\n#define CPLIB_BS_AVX2 __attribute__((target(\"\
    avx2\")))\n\n#define CPLIB_BS_BINARY(name, scalar, vector) \\\nCPLIB_BS_AVX2 static\
    \ void name(uint64_t *dst, const uint64_t *x, \\\n                           const\
    \ uint64_t *y, size_t n) { \\\n/* 256\u30D3\u30C3\u30C8\u305A\u3064\u8AD6\u7406\
    \u6F14\u7B97\u3057\u3001\u6B8B\u308A\u309264\u30D3\u30C3\u30C8\u305A\u3064\u51E6\
    \u7406\u3057\u307E\u3059\u3002 */ \\\nsize_t i = 0; \\\nfor (; i + 4 <= n; i +=\
    \ 4) { \\\n    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i)); \\\n\
    \    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i)); \\\n    _mm256_storeu_si256((__m256i\
    \ *)(dst + i), vector(a, b)); \\\n} \\\nfor (; i < n; ++i) dst[i] = x[i] scalar\
    \ y[i]; \\\n}\nCPLIB_BS_BINARY(cplib_bs512_and_avx2, &, _mm256_and_si256)\nCPLIB_BS_BINARY(cplib_bs512_or_avx2,\
    \ |, _mm256_or_si256)\nCPLIB_BS_BINARY(cplib_bs512_xor_avx2, ^, _mm256_xor_si256)\n\
    #undef CPLIB_BS_BINARY\n\nCPLIB_BS_AVX2 static void cplib_bs512_andnot_avx2(uint64_t\
    \ *dst, const uint64_t *x,\n                                       const uint64_t\
    \ *y, size_t n) {\n/* 256\u30D3\u30C3\u30C8\u305A\u3064\u5DEE\u96C6\u5408\u3092\
    \u6C42\u3081\u3001\u6B8B\u308A\u309264\u30D3\u30C3\u30C8\u305A\u3064\u51E6\u7406\
    \u3057\u307E\u3059\u3002 */\nsize_t i = 0;\nfor (; i + 4 <= n; i += 4) {\n   \
    \ __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));\n    __m256i b = _mm256_loadu_si256((const\
    \ __m256i *)(y + i));\n    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_andnot_si256(b,\
    \ a));\n}\nfor (; i < n; ++i) dst[i] = x[i] & ~y[i];\n}\n\nCPLIB_BS_AVX2 static\
    \ void cplib_bs512_not_avx2(uint64_t *dst, const uint64_t *x, size_t n) {\n/*\
    \ 256\u30D3\u30C3\u30C8\u305A\u3064\u53CD\u8EE2\u3057\u307E\u3059\u3002 */\nconst\
    \ __m256i ones = _mm256_set1_epi64x(-1);\nsize_t i = 0;\nfor (; i + 4 <= n; i\
    \ += 4)\n    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_xor_si256(\n   \
    \     _mm256_loadu_si256((const __m256i *)(x + i)), ones));\nfor (; i < n; ++i)\
    \ dst[i] = ~x[i];\n}\n\nCPLIB_BS_AVX2 static void cplib_bs512_shl_avx2(uint64_t\
    \ *dst, const uint64_t *x,\n                                 size_t n, size_t\
    \ shift) {\n/* \u30BC\u30ED\u521D\u671F\u5316\u6E08\u307F\u306E\u5225\u9818\u57DF\
    \u3078\u5DE6\u30B7\u30D5\u30C8\u3057\u3001\u96A3\u63A5\u30EF\u30FC\u30C9\u304B\
    \u3089\u306E\u6841\u4E0A\u304C\u308A\u3082\u51E6\u7406\u3057\u307E\u3059\u3002\
    \ */\nconst size_t offset = shift >> 6;\nconst unsigned bits = shift & 63;\nconst\
    \ size_t count = n - offset;\nsize_t i = 0;\nif (bits == 0) {\n    for (; i +\
    \ 4 <= count; i += 4)\n        _mm256_storeu_si256((__m256i *)(dst + offset +\
    \ i),\n            _mm256_loadu_si256((const __m256i *)(x + i)));\n    for (;\
    \ i < count; ++i) dst[offset + i] = x[i];\n    return;\n}\nconst __m128i left\
    \ = _mm_cvtsi32_si128(bits);\nconst __m128i right = _mm_cvtsi32_si128(64 - bits);\n\
    dst[offset] = x[0] << bits;\ni = 1;\nfor (; i + 4 <= count; i += 4) {\n    __m256i\
    \ a = _mm256_loadu_si256((const __m256i *)(x + i));\n    __m256i b = _mm256_loadu_si256((const\
    \ __m256i *)(x + i - 1));\n    _mm256_storeu_si256((__m256i *)(dst + offset +\
    \ i), _mm256_or_si256(\n        _mm256_sll_epi64(a, left), _mm256_srl_epi64(b,\
    \ right)));\n}\nfor (; i < count; ++i)\n    dst[offset + i] = (x[i] << bits) |\
    \ (x[i - 1] >> (64 - bits));\n}\n\nCPLIB_BS_AVX2 static void cplib_bs512_shr_avx2(uint64_t\
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
    \ inline __m256i cplib_bs512_byte_counts(__m256i x) {\n/* 4\u30D3\u30C3\u30C8\u306E\
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
    \       local = _mm256_add_epi8(local, cplib_bs512_byte_counts(vector)); \\\n\
    \    } \\\n    total = _mm256_add_epi64(total, _mm256_sad_epu8(local, _mm256_setzero_si256()));\
    \ \\\n} \\\nuint64_t lanes[4]; \\\n_mm256_storeu_si256((__m256i *)lanes, total);\
    \ \\\nsize_t result = lanes[0] + lanes[1] + lanes[2] + lanes[3]; \\\nfor (; i\
    \ < n; ++i) result += __builtin_popcountll(scalar); \\\nreturn result; \\\n}\n\
    CPLIB_BS_COUNT(cplib_bs512_popcount_avx2, x[i], a)\nCPLIB_BS_COUNT(cplib_bs512_andpopcount_avx2,\
    \ x[i] & y[i], _mm256_and_si256(a, b))\nCPLIB_BS_COUNT(cplib_bs512_orpopcount_avx2,\
    \ x[i] | y[i], _mm256_or_si256(a, b))\nCPLIB_BS_COUNT(cplib_bs512_xorpopcount_avx2,\
    \ x[i] ^ y[i], _mm256_xor_si256(a, b))\n#undef CPLIB_BS_COUNT\n\nCPLIB_BS_AVX2\
    \ static uint32_t cplib_bs512_bool_mask(const unsigned char *src) {\n    /* 32\u500B\
    \u306Ebool\u3092\u6BD4\u8F03\u3057\u3001\u975E\u30BC\u30ED\u306E\u4F4D\u7F6E\u3092\
    32\u30D3\u30C3\u30C8\u306E\u30DE\u30B9\u30AF\u306B\u8A70\u3081\u307E\u3059\u3002\
    \ */\n    __m256i values = _mm256_loadu_si256((const __m256i *)src);\n    return\
    \ ~(uint32_t)_mm256_movemask_epi8(\n        _mm256_cmpeq_epi8(values, _mm256_setzero_si256()));\n\
    }\n\nCPLIB_BS_AVX2 static void cplib_bs512_from_bools_avx2(uint64_t *dst, const\
    \ void *source,\n                                            size_t length, size_t\
    \ words) {\n    /* \u5165\u529B\u309264\u30D3\u30C3\u30C8\u305A\u3064\u8A70\u3081\
    \u3001\u7AEF\u6570\u3068\u5165\u529B\u3088\u308A\u5F8C\u308D\u306E\u30EF\u30FC\
    \u30C9\u3082\u3059\u3079\u3066\u66F8\u304D\u8FBC\u307F\u307E\u3059\u3002 */\n\
    \    const unsigned char *src = (const unsigned char *)source;\n    size_t i =\
    \ 0, word = 0;\n    for (; i + 64 <= length; i += 64) {\n        uint64_t low\
    \ = cplib_bs512_bool_mask(src + i);\n        uint64_t high = cplib_bs512_bool_mask(src\
    \ + i + 32);\n        dst[word++] = low | (high << 32);\n    }\n    if (i < length)\
    \ {\n        uint64_t value = 0;\n        size_t j = 0;\n        if (length -\
    \ i >= 32) {\n            value = cplib_bs512_bool_mask(src + i);\n          \
    \  j = 32;\n        }\n        for (; j < length - i; ++j)\n            value\
    \ |= (uint64_t)(src[i + j] != 0) << j;\n        dst[word++] = value;\n    }\n\
    \    for (; word < words; ++word) dst[word] = 0;\n}\n#define CPLIB_BS_AVX512 __attribute__((target(\"\
    avx512f\")))\n\n#define CPLIB_BS_BINARY(name, scalar, vector) \\\nCPLIB_BS_AVX512\
    \ static void name(uint64_t *dst, const uint64_t *x, \\\n                    \
    \       const uint64_t *y, size_t n) { \\\n/* 512\u30D3\u30C3\u30C8\u305A\u3064\
    \u8AD6\u7406\u6F14\u7B97\u3057\u3001\u6B8B\u308A\u309264\u30D3\u30C3\u30C8\u305A\
    \u3064\u51E6\u7406\u3057\u307E\u3059\u3002 */ \\\nsize_t i = 0; \\\nfor (; i +\
    \ 8 <= n; i += 8) { \\\n    __m512i a = _mm512_loadu_si512((const __m512i *)(x\
    \ + i)); \\\n    __m512i b = _mm512_loadu_si512((const __m512i *)(y + i)); \\\n\
    \    _mm512_storeu_si512((__m512i *)(dst + i), vector(a, b)); \\\n} \\\nfor (;\
    \ i < n; ++i) dst[i] = x[i] scalar y[i]; \\\n}\nCPLIB_BS_BINARY(cplib_bs512_and_avx512,\
    \ &, _mm512_and_si512)\nCPLIB_BS_BINARY(cplib_bs512_or_avx512, |, _mm512_or_si512)\n\
    CPLIB_BS_BINARY(cplib_bs512_xor_avx512, ^, _mm512_xor_si512)\n#undef CPLIB_BS_BINARY\n\
    \nCPLIB_BS_AVX512 static void cplib_bs512_andnot_avx512(uint64_t *dst, const uint64_t\
    \ *x,\n                                       const uint64_t *y, size_t n) {\n\
    /* 512\u30D3\u30C3\u30C8\u305A\u3064\u5DEE\u96C6\u5408\u3092\u6C42\u3081\u3001\
    \u6B8B\u308A\u309264\u30D3\u30C3\u30C8\u305A\u3064\u51E6\u7406\u3057\u307E\u3059\
    \u3002 */\nsize_t i = 0;\nfor (; i + 8 <= n; i += 8) {\n    __m512i a = _mm512_loadu_si512((const\
    \ __m512i *)(x + i));\n    __m512i b = _mm512_loadu_si512((const __m512i *)(y\
    \ + i));\n    _mm512_storeu_si512((__m512i *)(dst + i), _mm512_andnot_si512(b,\
    \ a));\n}\nfor (; i < n; ++i) dst[i] = x[i] & ~y[i];\n}\n\nCPLIB_BS_AVX512 static\
    \ void cplib_bs512_not_avx512(uint64_t *dst, const uint64_t *x, size_t n) {\n\
    /* 512\u30D3\u30C3\u30C8\u305A\u3064\u53CD\u8EE2\u3057\u307E\u3059\u3002 */\n\
    const __m512i ones = _mm512_set1_epi64(-1);\nsize_t i = 0;\nfor (; i + 8 <= n;\
    \ i += 8)\n    _mm512_storeu_si512((__m512i *)(dst + i), _mm512_xor_si512(\n \
    \       _mm512_loadu_si512((const __m512i *)(x + i)), ones));\nfor (; i < n; ++i)\
    \ dst[i] = ~x[i];\n}\n\nCPLIB_BS_AVX512 static void cplib_bs512_shl_avx512(uint64_t\
    \ *dst, const uint64_t *x,\n                                 size_t n, size_t\
    \ shift) {\n/* \u30BC\u30ED\u521D\u671F\u5316\u6E08\u307F\u306E\u5225\u9818\u57DF\
    \u3078\u5DE6\u30B7\u30D5\u30C8\u3057\u3001\u96A3\u63A5\u30EF\u30FC\u30C9\u304B\
    \u3089\u306E\u6841\u4E0A\u304C\u308A\u3082\u51E6\u7406\u3057\u307E\u3059\u3002\
    \ */\nconst size_t offset = shift >> 6;\nconst unsigned bits = shift & 63;\nconst\
    \ size_t count = n - offset;\nsize_t i = 0;\nif (bits == 0) {\n    for (; i +\
    \ 8 <= count; i += 8)\n        _mm512_storeu_si512((__m512i *)(dst + offset +\
    \ i),\n            _mm512_loadu_si512((const __m512i *)(x + i)));\n    for (;\
    \ i < count; ++i) dst[offset + i] = x[i];\n    return;\n}\nconst __m128i left\
    \ = _mm_cvtsi32_si128(bits);\nconst __m128i right = _mm_cvtsi32_si128(64 - bits);\n\
    dst[offset] = x[0] << bits;\ni = 1;\nfor (; i + 8 <= count; i += 8) {\n    __m512i\
    \ a = _mm512_loadu_si512((const __m512i *)(x + i));\n    __m512i b = _mm512_loadu_si512((const\
    \ __m512i *)(x + i - 1));\n    _mm512_storeu_si512((__m512i *)(dst + offset +\
    \ i), _mm512_or_si512(\n        _mm512_sll_epi64(a, left), _mm512_srl_epi64(b,\
    \ right)));\n}\nfor (; i < count; ++i)\n    dst[offset + i] = (x[i] << bits) |\
    \ (x[i - 1] >> (64 - bits));\n}\n\nCPLIB_BS_AVX512 static void cplib_bs512_shr_avx512(uint64_t\
    \ *dst, const uint64_t *x,\n                                 size_t n, size_t\
    \ shift) {\n/* \u30BC\u30ED\u521D\u671F\u5316\u6E08\u307F\u306E\u5225\u9818\u57DF\
    \u3078\u53F3\u30B7\u30D5\u30C8\u3057\u3001\u96A3\u63A5\u30EF\u30FC\u30C9\u304B\
    \u3089\u306E\u6841\u4E0B\u304C\u308A\u3082\u51E6\u7406\u3057\u307E\u3059\u3002\
    \ */\nconst size_t offset = shift >> 6;\nconst unsigned bits = shift & 63;\nconst\
    \ size_t count = n - offset;\nsize_t i = 0;\nif (bits == 0) {\n    for (; i +\
    \ 8 <= count; i += 8)\n        _mm512_storeu_si512((__m512i *)(dst + i),\n   \
    \         _mm512_loadu_si512((const __m512i *)(x + offset + i)));\n    for (;\
    \ i < count; ++i) dst[i] = x[offset + i];\n    return;\n}\nconst __m128i right\
    \ = _mm_cvtsi32_si128(bits);\nconst __m128i left = _mm_cvtsi32_si128(64 - bits);\n\
    for (; i + 8 < count; i += 8) {\n    __m512i a = _mm512_loadu_si512((const __m512i\
    \ *)(x + offset + i));\n    __m512i b = _mm512_loadu_si512((const __m512i *)(x\
    \ + offset + i + 1));\n    _mm512_storeu_si512((__m512i *)(dst + i), _mm512_or_si512(\n\
    \        _mm512_srl_epi64(a, right), _mm512_sll_epi64(b, left)));\n}\nfor (; i\
    \ + 1 < count; ++i)\n    dst[i] = (x[offset + i] >> bits) | (x[offset + i + 1]\
    \ << (64 - bits));\ndst[count - 1] = x[n - 1] >> bits;\n}\n\n\n#define CPLIB_BS_COUNT512(name,\
    \ scalar, vector) \\\n__attribute__((target(\"avx512f,avx512vpopcntdq\"))) \\\n\
    static size_t name(const uint64_t *x, const uint64_t *y, size_t n) { \\\n/* 64\u30D3\
    \u30C3\u30C8\u3054\u3068\u306E\u500B\u6570\u3092\u5C02\u7528\u547D\u4EE4\u3067\
    \u6C42\u3081\u3001\u6700\u5F8C\u306B\u96C6\u7D04\u3057\u307E\u3059\u3002 */ \\\
    \n__m512i total = _mm512_setzero_si512(); \\\nsize_t i = 0; \\\nfor (; i + 8 <=\
    \ n; i += 8) { \\\n    __m512i a = _mm512_loadu_si512((const void *)(x + i));\
    \ \\\n    __m512i b = _mm512_loadu_si512((const void *)(y + i)); \\\n    total\
    \ = _mm512_add_epi64(total, _mm512_popcnt_epi64(vector)); \\\n} \\\nuint64_t lanes[8];\
    \ \\\n_mm512_storeu_si512((void *)lanes, total); \\\nsize_t result = 0; \\\nfor\
    \ (size_t j = 0; j < 8; ++j) result += lanes[j]; \\\nfor (; i < n; ++i) result\
    \ += __builtin_popcountll(scalar); \\\nreturn result; \\\n}\nCPLIB_BS_COUNT512(cplib_bs512_popcount_avx512,\
    \ x[i], a)\nCPLIB_BS_COUNT512(cplib_bs512_andpopcount_avx512, x[i] & y[i], _mm512_and_si512(a,\
    \ b))\nCPLIB_BS_COUNT512(cplib_bs512_orpopcount_avx512, x[i] | y[i], _mm512_or_si512(a,\
    \ b))\nCPLIB_BS_COUNT512(cplib_bs512_xorpopcount_avx512, x[i] ^ y[i], _mm512_xor_si512(a,\
    \ b))\n#undef CPLIB_BS_COUNT512\n\n__attribute__((target(\"avx512f,avx512bw\"\
    )))\nstatic void cplib_bs512_from_bools_avx512(uint64_t *dst, const void *source,\n\
    \                                      size_t length, size_t words) {\n/* 64\u500B\
    \u306Ebool\u3092\u6BD4\u8F03\u3057\u3001\u6BD4\u8F03\u7D50\u679C\u306E\u30DE\u30B9\
    \u30AF\u3092\u305D\u306E\u307E\u307E1\u30EF\u30FC\u30C9\u306B\u3057\u307E\u3059\
    \u3002 */\nconst unsigned char *src = (const unsigned char *)source;\nsize_t i\
    \ = 0, word = 0;\nfor (; i + 64 <= length; i += 64) {\n    __m512i values = _mm512_loadu_si512((const\
    \ void *)(src + i));\n    dst[word++] = (uint64_t)_mm512_cmpneq_epi8_mask(values,\
    \ _mm512_setzero_si512());\n}\nif (i < length) {\n    uint64_t value = 0;\n  \
    \  for (size_t j = 0; j < length - i; ++j)\n        value |= (uint64_t)(src[i\
    \ + j] != 0) << j;\n    dst[word++] = value;\n}\nfor (; word < words; ++word)\
    \ dst[word] = 0;\n}\n\n/* CPU\u3068OS\u304C\u5BFE\u5FDC\u3059\u308B\u547D\u4EE4\
    \u3060\u3051\u3092\u9078\u3073\u307E\u3059\u3002\u516C\u958BAPI\u3068\u30C7\u30FC\
    \u30BF\u8868\u73FE\u306F\u5171\u901A\u3067\u3059\u3002 */\n\nstatic inline void\
    \ cplib_bs512_and(uint64_t *dst, const uint64_t *x, const uint64_t *y, size_t\
    \ n) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\")) {\n        cplib_bs512_and_avx512(dst,\
    \ x, y, n);\n    } else {\n        cplib_bs512_and_avx2(dst, x, y, n);\n    }\n\
    }\n\nstatic inline void cplib_bs512_or(uint64_t *dst, const uint64_t *x, const\
    \ uint64_t *y, size_t n) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\"\
    )) {\n        cplib_bs512_or_avx512(dst, x, y, n);\n    } else {\n        cplib_bs512_or_avx2(dst,\
    \ x, y, n);\n    }\n}\n\nstatic inline void cplib_bs512_xor(uint64_t *dst, const\
    \ uint64_t *x, const uint64_t *y, size_t n) {\n    if (n >= 8 && __builtin_cpu_supports(\"\
    avx512f\")) {\n        cplib_bs512_xor_avx512(dst, x, y, n);\n    } else {\n \
    \       cplib_bs512_xor_avx2(dst, x, y, n);\n    }\n}\n\nstatic inline void cplib_bs512_andnot(uint64_t\
    \ *dst, const uint64_t *x, const uint64_t *y, size_t n) {\n    if (n >= 8 && __builtin_cpu_supports(\"\
    avx512f\")) {\n        cplib_bs512_andnot_avx512(dst, x, y, n);\n    } else {\n\
    \        cplib_bs512_andnot_avx2(dst, x, y, n);\n    }\n}\n\nstatic inline void\
    \ cplib_bs512_not(uint64_t *dst, const uint64_t *x, size_t n) {\n    if (n >=\
    \ 8 && __builtin_cpu_supports(\"avx512f\")) {\n        cplib_bs512_not_avx512(dst,\
    \ x, n);\n    } else {\n        cplib_bs512_not_avx2(dst, x, n);\n    }\n}\n\n\
    static inline void cplib_bs512_shl(uint64_t *dst, const uint64_t *x, size_t n,\
    \ size_t shift) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\")) {\n\
    \        cplib_bs512_shl_avx512(dst, x, n, shift);\n    } else {\n        cplib_bs512_shl_avx2(dst,\
    \ x, n, shift);\n    }\n}\n\nstatic inline void cplib_bs512_shr(uint64_t *dst,\
    \ const uint64_t *x, size_t n, size_t shift) {\n    if (n >= 8 && __builtin_cpu_supports(\"\
    avx512f\")) {\n        cplib_bs512_shr_avx512(dst, x, n, shift);\n    } else {\n\
    \        cplib_bs512_shr_avx2(dst, x, n, shift);\n    }\n}\n\nstatic inline size_t\
    \ cplib_bs512_popcount(const uint64_t *x, const uint64_t *y, size_t n) {\n   \
    \ if (n >= 8 && __builtin_cpu_supports(\"avx512f\") && __builtin_cpu_supports(\"\
    avx512vpopcntdq\")) {\n        return cplib_bs512_popcount_avx512(x, y, n);\n\
    \    } else {\n        return cplib_bs512_popcount_avx2(x, y, n);\n    }\n}\n\n\
    static inline size_t cplib_bs512_andpopcount(const uint64_t *x, const uint64_t\
    \ *y, size_t n) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\") && __builtin_cpu_supports(\"\
    avx512vpopcntdq\")) {\n        return cplib_bs512_andpopcount_avx512(x, y, n);\n\
    \    } else {\n        return cplib_bs512_andpopcount_avx2(x, y, n);\n    }\n\
    }\n\nstatic inline size_t cplib_bs512_orpopcount(const uint64_t *x, const uint64_t\
    \ *y, size_t n) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\") && __builtin_cpu_supports(\"\
    avx512vpopcntdq\")) {\n        return cplib_bs512_orpopcount_avx512(x, y, n);\n\
    \    } else {\n        return cplib_bs512_orpopcount_avx2(x, y, n);\n    }\n}\n\
    \nstatic inline size_t cplib_bs512_xorpopcount(const uint64_t *x, const uint64_t\
    \ *y, size_t n) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\") && __builtin_cpu_supports(\"\
    avx512vpopcntdq\")) {\n        return cplib_bs512_xorpopcount_avx512(x, y, n);\n\
    \    } else {\n        return cplib_bs512_xorpopcount_avx2(x, y, n);\n    }\n\
    }\n\nstatic inline void cplib_bs512_from_bools(uint64_t *dst, const void *source,\
    \ size_t length, size_t words) {\n    if (length >= 64 && __builtin_cpu_supports(\"\
    avx512f\") && __builtin_cpu_supports(\"avx512bw\")) {\n        cplib_bs512_from_bools_avx512(dst,\
    \ source, length, words);\n    } else {\n        cplib_bs512_from_bools_avx2(dst,\
    \ source, length, words);\n    }\n}\nCPLIB_BS_AVX2 static void cplib_bs512_select_avx2(uint64_t\
    \ *dst, const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t\
    \ n) {\n/* 256\u30D3\u30C3\u30C8\u305A\u3064\u8907\u5408\u6F14\u7B97\u3057\u3001\
    \u4E00\u6642\u914D\u5217\u3092\u4F5C\u3089\u305A\u306B\u66F8\u304D\u8FBC\u307F\
    \u307E\u3059\u3002 */\nsize_t i = 0;\nfor (; i + 4 <= n; i += 4) {\n    __m256i\
    \ a = _mm256_loadu_si256((const __m256i *)(x + i));\n    __m256i b = _mm256_loadu_si256((const\
    \ __m256i *)(y + i));\n    __m256i c = _mm256_loadu_si256((const __m256i *)(z\
    \ + i));\n    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_xor_si256(a, _mm256_and_si256(_mm256_xor_si256(a,\
    \ b), c)));\n}\nfor (; i < n; ++i) {\n    uint64_t a = x[i], b = y[i], c = z[i];\n\
    \    dst[i] = (a & ~c) | (b & c);\n}\n}\n\nCPLIB_BS_AVX512 static void cplib_bs512_select_avx512(uint64_t\
    \ *dst, const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t\
    \ n) {\n/* \u771F\u7406\u5024\u8868\u306E\u6DFB\u5B57\u306F(a << 2) | (b << 1)\
    \ | c\u3067\u3059\u3002512\u30D3\u30C3\u30C8\u3042\u305F\u308A\u8AD6\u7406\u6F14\
    \u7B971\u547D\u4EE4\u3067\u3059\u3002 */\nsize_t i = 0;\nfor (; i + 8 <= n; i\
    \ += 8) {\n    __m512i a = _mm512_loadu_si512((const void *)(x + i));\n    __m512i\
    \ b = _mm512_loadu_si512((const void *)(y + i));\n    __m512i c = _mm512_loadu_si512((const\
    \ void *)(z + i));\n    _mm512_storeu_si512((void *)(dst + i), _mm512_ternarylogic_epi64(a,\
    \ b, c, 0xD8));\n}\nfor (; i < n; ++i) {\n    uint64_t a = x[i], b = y[i], c =\
    \ z[i];\n    dst[i] = (a & ~c) | (b & c);\n}\n}\nstatic inline void cplib_bs512_select(uint64_t\
    \ *dst, const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t\
    \ n) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\")) {\n        cplib_bs512_select_avx512(dst,\
    \ x, y, z, n);\n    } else {\n        cplib_bs512_select_avx2(dst, x, y, z, n);\n\
    \    }\n}\n\nCPLIB_BS_AVX2 static void cplib_bs512_orand_avx2(uint64_t *dst, const\
    \ uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t n) {\n/*\
    \ 256\u30D3\u30C3\u30C8\u305A\u3064\u8907\u5408\u6F14\u7B97\u3057\u3001\u4E00\u6642\
    \u914D\u5217\u3092\u4F5C\u3089\u305A\u306B\u66F8\u304D\u8FBC\u307F\u307E\u3059\
    \u3002 */\nsize_t i = 0;\nfor (; i + 4 <= n; i += 4) {\n    __m256i a = _mm256_loadu_si256((const\
    \ __m256i *)(x + i));\n    __m256i b = _mm256_loadu_si256((const __m256i *)(y\
    \ + i));\n    __m256i c = _mm256_loadu_si256((const __m256i *)(z + i));\n    _mm256_storeu_si256((__m256i\
    \ *)(dst + i), _mm256_or_si256(a, _mm256_and_si256(b, c)));\n}\nfor (; i < n;\
    \ ++i) {\n    uint64_t a = x[i], b = y[i], c = z[i];\n    dst[i] = a | (b & c);\n\
    }\n}\n\nCPLIB_BS_AVX512 static void cplib_bs512_orand_avx512(uint64_t *dst, const\
    \ uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t n) {\n/*\
    \ \u771F\u7406\u5024\u8868\u306E\u6DFB\u5B57\u306F(a << 2) | (b << 1) | c\u3067\
    \u3059\u3002512\u30D3\u30C3\u30C8\u3042\u305F\u308A\u8AD6\u7406\u6F14\u7B971\u547D\
    \u4EE4\u3067\u3059\u3002 */\nsize_t i = 0;\nfor (; i + 8 <= n; i += 8) {\n   \
    \ __m512i a = _mm512_loadu_si512((const void *)(x + i));\n    __m512i b = _mm512_loadu_si512((const\
    \ void *)(y + i));\n    __m512i c = _mm512_loadu_si512((const void *)(z + i));\n\
    \    _mm512_storeu_si512((void *)(dst + i), _mm512_ternarylogic_epi64(a, b, c,\
    \ 0xF8));\n}\nfor (; i < n; ++i) {\n    uint64_t a = x[i], b = y[i], c = z[i];\n\
    \    dst[i] = a | (b & c);\n}\n}\nstatic inline void cplib_bs512_orand(uint64_t\
    \ *dst, const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t\
    \ n) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\")) {\n        cplib_bs512_orand_avx512(dst,\
    \ x, y, z, n);\n    } else {\n        cplib_bs512_orand_avx2(dst, x, y, z, n);\n\
    \    }\n}\n\nCPLIB_BS_AVX2 static void cplib_bs512_andor_avx2(uint64_t *dst, const\
    \ uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t n) {\n/*\
    \ 256\u30D3\u30C3\u30C8\u305A\u3064\u8907\u5408\u6F14\u7B97\u3057\u3001\u4E00\u6642\
    \u914D\u5217\u3092\u4F5C\u3089\u305A\u306B\u66F8\u304D\u8FBC\u307F\u307E\u3059\
    \u3002 */\nsize_t i = 0;\nfor (; i + 4 <= n; i += 4) {\n    __m256i a = _mm256_loadu_si256((const\
    \ __m256i *)(x + i));\n    __m256i b = _mm256_loadu_si256((const __m256i *)(y\
    \ + i));\n    __m256i c = _mm256_loadu_si256((const __m256i *)(z + i));\n    _mm256_storeu_si256((__m256i\
    \ *)(dst + i), _mm256_and_si256(a, _mm256_or_si256(b, c)));\n}\nfor (; i < n;\
    \ ++i) {\n    uint64_t a = x[i], b = y[i], c = z[i];\n    dst[i] = a & (b | c);\n\
    }\n}\n\nCPLIB_BS_AVX512 static void cplib_bs512_andor_avx512(uint64_t *dst, const\
    \ uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t n) {\n/*\
    \ \u771F\u7406\u5024\u8868\u306E\u6DFB\u5B57\u306F(a << 2) | (b << 1) | c\u3067\
    \u3059\u3002512\u30D3\u30C3\u30C8\u3042\u305F\u308A\u8AD6\u7406\u6F14\u7B971\u547D\
    \u4EE4\u3067\u3059\u3002 */\nsize_t i = 0;\nfor (; i + 8 <= n; i += 8) {\n   \
    \ __m512i a = _mm512_loadu_si512((const void *)(x + i));\n    __m512i b = _mm512_loadu_si512((const\
    \ void *)(y + i));\n    __m512i c = _mm512_loadu_si512((const void *)(z + i));\n\
    \    _mm512_storeu_si512((void *)(dst + i), _mm512_ternarylogic_epi64(a, b, c,\
    \ 0xE0));\n}\nfor (; i < n; ++i) {\n    uint64_t a = x[i], b = y[i], c = z[i];\n\
    \    dst[i] = a & (b | c);\n}\n}\nstatic inline void cplib_bs512_andor(uint64_t\
    \ *dst, const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t\
    \ n) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\")) {\n        cplib_bs512_andor_avx512(dst,\
    \ x, y, z, n);\n    } else {\n        cplib_bs512_andor_avx2(dst, x, y, z, n);\n\
    \    }\n}\n\nCPLIB_BS_AVX2 static void cplib_bs512_xorand_avx2(uint64_t *dst,\
    \ const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t n)\
    \ {\n/* 256\u30D3\u30C3\u30C8\u305A\u3064\u8907\u5408\u6F14\u7B97\u3057\u3001\u4E00\
    \u6642\u914D\u5217\u3092\u4F5C\u3089\u305A\u306B\u66F8\u304D\u8FBC\u307F\u307E\
    \u3059\u3002 */\nsize_t i = 0;\nfor (; i + 4 <= n; i += 4) {\n    __m256i a =\
    \ _mm256_loadu_si256((const __m256i *)(x + i));\n    __m256i b = _mm256_loadu_si256((const\
    \ __m256i *)(y + i));\n    __m256i c = _mm256_loadu_si256((const __m256i *)(z\
    \ + i));\n    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_xor_si256(a, _mm256_and_si256(b,\
    \ c)));\n}\nfor (; i < n; ++i) {\n    uint64_t a = x[i], b = y[i], c = z[i];\n\
    \    dst[i] = a ^ (b & c);\n}\n}\n\nCPLIB_BS_AVX512 static void cplib_bs512_xorand_avx512(uint64_t\
    \ *dst, const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t\
    \ n) {\n/* \u771F\u7406\u5024\u8868\u306E\u6DFB\u5B57\u306F(a << 2) | (b << 1)\
    \ | c\u3067\u3059\u3002512\u30D3\u30C3\u30C8\u3042\u305F\u308A\u8AD6\u7406\u6F14\
    \u7B971\u547D\u4EE4\u3067\u3059\u3002 */\nsize_t i = 0;\nfor (; i + 8 <= n; i\
    \ += 8) {\n    __m512i a = _mm512_loadu_si512((const void *)(x + i));\n    __m512i\
    \ b = _mm512_loadu_si512((const void *)(y + i));\n    __m512i c = _mm512_loadu_si512((const\
    \ void *)(z + i));\n    _mm512_storeu_si512((void *)(dst + i), _mm512_ternarylogic_epi64(a,\
    \ b, c, 0x78));\n}\nfor (; i < n; ++i) {\n    uint64_t a = x[i], b = y[i], c =\
    \ z[i];\n    dst[i] = a ^ (b & c);\n}\n}\nstatic inline void cplib_bs512_xorand(uint64_t\
    \ *dst, const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t\
    \ n) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\")) {\n        cplib_bs512_xorand_avx512(dst,\
    \ x, y, z, n);\n    } else {\n        cplib_bs512_xorand_avx2(dst, x, y, z, n);\n\
    \    }\n}\n\nCPLIB_BS_AVX2 static void cplib_bs512_majority_avx2(uint64_t *dst,\
    \ const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t n)\
    \ {\n/* 256\u30D3\u30C3\u30C8\u305A\u3064\u8907\u5408\u6F14\u7B97\u3057\u3001\u4E00\
    \u6642\u914D\u5217\u3092\u4F5C\u3089\u305A\u306B\u66F8\u304D\u8FBC\u307F\u307E\
    \u3059\u3002 */\nsize_t i = 0;\nfor (; i + 4 <= n; i += 4) {\n    __m256i a =\
    \ _mm256_loadu_si256((const __m256i *)(x + i));\n    __m256i b = _mm256_loadu_si256((const\
    \ __m256i *)(y + i));\n    __m256i c = _mm256_loadu_si256((const __m256i *)(z\
    \ + i));\n    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_or_si256(_mm256_and_si256(a,\
    \ b), _mm256_and_si256(_mm256_or_si256(a, b), c)));\n}\nfor (; i < n; ++i) {\n\
    \    uint64_t a = x[i], b = y[i], c = z[i];\n    dst[i] = (a & b) | ((a | b) &\
    \ c);\n}\n}\n\nCPLIB_BS_AVX512 static void cplib_bs512_majority_avx512(uint64_t\
    \ *dst, const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t\
    \ n) {\n/* \u771F\u7406\u5024\u8868\u306E\u6DFB\u5B57\u306F(a << 2) | (b << 1)\
    \ | c\u3067\u3059\u3002512\u30D3\u30C3\u30C8\u3042\u305F\u308A\u8AD6\u7406\u6F14\
    \u7B971\u547D\u4EE4\u3067\u3059\u3002 */\nsize_t i = 0;\nfor (; i + 8 <= n; i\
    \ += 8) {\n    __m512i a = _mm512_loadu_si512((const void *)(x + i));\n    __m512i\
    \ b = _mm512_loadu_si512((const void *)(y + i));\n    __m512i c = _mm512_loadu_si512((const\
    \ void *)(z + i));\n    _mm512_storeu_si512((void *)(dst + i), _mm512_ternarylogic_epi64(a,\
    \ b, c, 0xE8));\n}\nfor (; i < n; ++i) {\n    uint64_t a = x[i], b = y[i], c =\
    \ z[i];\n    dst[i] = (a & b) | ((a | b) & c);\n}\n}\nstatic inline void cplib_bs512_majority(uint64_t\
    \ *dst, const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t\
    \ n) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\")) {\n        cplib_bs512_majority_avx512(dst,\
    \ x, y, z, n);\n    } else {\n        cplib_bs512_majority_avx2(dst, x, y, z,\
    \ n);\n    }\n}\n\nCPLIB_BS_AVX2 static void cplib_bs512_xnor_avx2(uint64_t *dst,\
    \ const uint64_t *x,\n        const uint64_t *y, const uint64_t *z, size_t n)\
    \ {\n/* 256\u30D3\u30C3\u30C8\u305A\u3064\u8907\u5408\u6F14\u7B97\u3057\u3001\u4E00\
    \u6642\u914D\u5217\u3092\u4F5C\u3089\u305A\u306B\u66F8\u304D\u8FBC\u307F\u307E\
    \u3059\u3002 */\nsize_t i = 0;\nfor (; i + 4 <= n; i += 4) {\n    __m256i a =\
    \ _mm256_loadu_si256((const __m256i *)(x + i));\n    __m256i b = _mm256_loadu_si256((const\
    \ __m256i *)(y + i));\n    __m256i c = _mm256_loadu_si256((const __m256i *)(z\
    \ + i));\n    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_xor_si256(_mm256_xor_si256(a,\
    \ b), _mm256_set1_epi64x(-1)));\n}\nfor (; i < n; ++i) {\n    uint64_t a = x[i],\
    \ b = y[i], c = z[i];\n    dst[i] = ~(a ^ b);\n}\n}\n\nCPLIB_BS_AVX512 static\
    \ void cplib_bs512_xnor_avx512(uint64_t *dst, const uint64_t *x,\n        const\
    \ uint64_t *y, const uint64_t *z, size_t n) {\n/* \u771F\u7406\u5024\u8868\u306E\
    \u6DFB\u5B57\u306F(a << 2) | (b << 1) | c\u3067\u3059\u3002512\u30D3\u30C3\u30C8\
    \u3042\u305F\u308A\u8AD6\u7406\u6F14\u7B971\u547D\u4EE4\u3067\u3059\u3002 */\n\
    size_t i = 0;\nfor (; i + 8 <= n; i += 8) {\n    __m512i a = _mm512_loadu_si512((const\
    \ void *)(x + i));\n    __m512i b = _mm512_loadu_si512((const void *)(y + i));\n\
    \    __m512i c = _mm512_loadu_si512((const void *)(z + i));\n    _mm512_storeu_si512((void\
    \ *)(dst + i), _mm512_ternarylogic_epi64(a, b, c, 0xC3));\n}\nfor (; i < n; ++i)\
    \ {\n    uint64_t a = x[i], b = y[i], c = z[i];\n    dst[i] = ~(a ^ b);\n}\n}\n\
    static inline void cplib_bs512_xnor(uint64_t *dst, const uint64_t *x,\n      \
    \  const uint64_t *y, const uint64_t *z, size_t n) {\n    if (n >= 8 && __builtin_cpu_supports(\"\
    avx512f\")) {\n        cplib_bs512_xnor_avx512(dst, x, y, z, n);\n    } else {\n\
    \        cplib_bs512_xnor_avx2(dst, x, y, z, n);\n    }\n}\n\n\n#define CPLIB_BS512_UPDATE_COUNT(name,\
    \ scalar, vector, truth, ternary) \\\nCPLIB_BS_AVX2 static size_t name##_avx2(uint64_t\
    \ *x, const uint64_t *y, \\\n                                     const uint64_t\
    \ *z, size_t bits) { \\\n/* \u66F4\u65B0\u5024\u3092\u4FDD\u5B58\u3057\u306A\u304C\
    \u3089\u500B\u6570\u3092\u6570\u3048\u307E\u3059\u3002\u6700\u5F8C\u306E\u4E0D\
    \u5B8C\u5168\u306A\u30EF\u30FC\u30C9\u306F\u5225\u9014\u30DE\u30B9\u30AF\u3057\
    \u307E\u3059\u3002 */ \\\nconst size_t full = bits >> 6, rem = bits & 63; \\\n\
    const size_t words = full + (rem != 0); \\\n__m256i total = _mm256_setzero_si256();\
    \ \\\nsize_t i = 0; \\\nwhile (i + 4 <= full) { \\\n    __m256i local = _mm256_setzero_si256();\
    \ \\\n    const size_t end = full - i < 64 ? full : i + 64; \\\n    for (; i +\
    \ 4 <= end; i += 4) { \\\n        __m256i a = _mm256_loadu_si256((const __m256i\
    \ *)(x + i)); \\\n        __m256i b = _mm256_loadu_si256((const __m256i *)(y +\
    \ i)); \\\n        __m256i c = ternary ? _mm256_loadu_si256((const __m256i *)(z\
    \ + i)) : a; \\\n        __m256i value = vector; \\\n        local = _mm256_add_epi8(local,\
    \ cplib_bs512_byte_counts(value)); \\\n        _mm256_storeu_si256((__m256i *)(x\
    \ + i), value); \\\n    } \\\n    total = _mm256_add_epi64(total, _mm256_sad_epu8(local,\
    \ _mm256_setzero_si256())); \\\n} \\\nuint64_t lanes[4]; \\\n_mm256_storeu_si256((__m256i\
    \ *)lanes, total); \\\nsize_t result = lanes[0] + lanes[1] + lanes[2] + lanes[3];\
    \ \\\nfor (; i < words; ++i) { \\\n    uint64_t a = x[i], b = y[i], c = ternary\
    \ ? z[i] : a; \\\n    uint64_t value = scalar; \\\n    if (i == full) value &=\
    \ (UINT64_C(1) << rem) - 1; \\\n    x[i] = value; \\\n    result += __builtin_popcountll(value);\
    \ \\\n} \\\nreturn result; \\\n} \\\n__attribute__((target(\"avx512f,avx512vpopcntdq\"\
    ))) \\\nstatic size_t name##_avx512(uint64_t *x, const uint64_t *y, const uint64_t\
    \ *z, size_t bits) { \\\n/* 512\u30D3\u30C3\u30C8\u3054\u3068\u306B\u8AD6\u7406\
    \u6F14\u7B97\u30FB\u500B\u6570\u8A08\u7B97\u30FB\u7D2F\u7A4D\u3092\u884C\u3044\
    \u3001\u4E00\u6642\u96C6\u5408\u3092\u4F5C\u308A\u307E\u305B\u3093\u3002 */ \\\
    \nconst size_t full = bits >> 6, rem = bits & 63; \\\nconst size_t words = full\
    \ + (rem != 0); \\\n__m512i total = _mm512_setzero_si512(); \\\nsize_t i = 0;\
    \ \\\nfor (; i + 8 <= full; i += 8) { \\\n    __m512i a = _mm512_loadu_si512((const\
    \ void *)(x + i)); \\\n    __m512i b = _mm512_loadu_si512((const void *)(y + i));\
    \ \\\n    __m512i c = ternary ? _mm512_loadu_si512((const void *)(z + i)) : a;\
    \ \\\n    __m512i value = _mm512_ternarylogic_epi64(a, b, c, truth); \\\n    total\
    \ = _mm512_add_epi64(total, _mm512_popcnt_epi64(value)); \\\n    _mm512_storeu_si512((void\
    \ *)(x + i), value); \\\n} \\\nuint64_t lanes[8]; \\\n_mm512_storeu_si512((void\
    \ *)lanes, total); \\\nsize_t result = 0; \\\nfor (size_t j = 0; j < 8; ++j) result\
    \ += lanes[j]; \\\nfor (; i < words; ++i) { \\\n    uint64_t a = x[i], b = y[i],\
    \ c = ternary ? z[i] : a; \\\n    uint64_t value = scalar; \\\n    if (i == full)\
    \ value &= (UINT64_C(1) << rem) - 1; \\\n    x[i] = value; \\\n    result += __builtin_popcountll(value);\
    \ \\\n} \\\nreturn result; \\\n} \\\nstatic inline size_t name(uint64_t *x, const\
    \ uint64_t *y, const uint64_t *z, size_t bits) { \\\n    if (bits >= 512 && __builtin_cpu_supports(\"\
    avx512f\") && \\\n            __builtin_cpu_supports(\"avx512vpopcntdq\")) { \\\
    \n        return name##_avx512(x, y, z, bits); \\\n    } \\\n    return name##_avx2(x,\
    \ y, z, bits); \\\n}\nCPLIB_BS512_UPDATE_COUNT(cplib_bs512_and_update_count, a\
    \ & b, _mm256_and_si256(a, b), 0xC0, 0)\nCPLIB_BS512_UPDATE_COUNT(cplib_bs512_or_update_count,\
    \ a | b, _mm256_or_si256(a, b), 0xFC, 0)\nCPLIB_BS512_UPDATE_COUNT(cplib_bs512_xor_update_count,\
    \ a ^ b, _mm256_xor_si256(a, b), 0x3C, 0)\nCPLIB_BS512_UPDATE_COUNT(cplib_bs512_andnot_update_count,\
    \ a & ~b, _mm256_andnot_si256(b, a), 0x30, 0)\nCPLIB_BS512_UPDATE_COUNT(cplib_bs512_select_update_count,\
    \ (a & ~c) | (b & c), _mm256_xor_si256(a, _mm256_and_si256(_mm256_xor_si256(a,\
    \ b), c)), 0xD8, 1)\nCPLIB_BS512_UPDATE_COUNT(cplib_bs512_orand_update_count,\
    \ a | (b & c), _mm256_or_si256(a, _mm256_and_si256(b, c)), 0xF8, 1)\nCPLIB_BS512_UPDATE_COUNT(cplib_bs512_andor_update_count,\
    \ a & (b | c), _mm256_and_si256(a, _mm256_or_si256(b, c)), 0xE0, 1)\nCPLIB_BS512_UPDATE_COUNT(cplib_bs512_xorand_update_count,\
    \ a ^ (b & c), _mm256_xor_si256(a, _mm256_and_si256(b, c)), 0x78, 1)\nCPLIB_BS512_UPDATE_COUNT(cplib_bs512_xnor_update_count,\
    \ ~(a ^ b), _mm256_xor_si256(_mm256_xor_si256(a, b), _mm256_set1_epi64x(-1)),\
    \ 0xC3, 0)\n#undef CPLIB_BS512_UPDATE_COUNT\n\n\n#define CPLIB_BS_COUNT_RANGE(name,\
    \ count, value) \\\nstatic inline size_t name(const uint64_t *x, const uint64_t\
    \ *y, size_t l, size_t r) { \\\n/* \u4E21\u7AEF\u306E\u90E8\u5206\u30EF\u30FC\u30C9\
    \u3060\u3051\u3092\u30DE\u30B9\u30AF\u3057\u3001\u4E2D\u592E\u306E\u5B8C\u5168\
    \u306A\u30EF\u30FC\u30C9\u306F\u65E2\u5B58\u306ESIMD\u30AB\u30FC\u30CD\u30EB\u3067\
    \u6570\u3048\u307E\u3059\u3002 */ \\\nif (l == r) return 0; \\\nsize_t first =\
    \ l >> 6, last = (r - 1) >> 6; \\\nconst uint64_t leftMask = UINT64_MAX << (l\
    \ & 63); \\\nconst uint64_t rightMask = UINT64_MAX >> (63 - ((r - 1) & 63)); \\\
    \nsize_t i = first; \\\nif (first == last) return __builtin_popcountll((value)\
    \ & leftMask & rightMask); \\\nsize_t result = 0, end = last + 1; \\\nif ((l &\
    \ 63) != 0) { \\\n    result += __builtin_popcountll((value) & leftMask); \\\n\
    \    ++first; \\\n} \\\nif ((r & 63) != 0) { \\\n    i = last; \\\n    result\
    \ += __builtin_popcountll((value) & rightMask); \\\n    --end; \\\n} \\\nif (first\
    \ < end) result += count(x + first, y + first, end - first); \\\nreturn result;\
    \ \\\n}\nCPLIB_BS_COUNT_RANGE(cplib_bs512_popcount_range, cplib_bs512_popcount,\
    \ x[i])\nCPLIB_BS_COUNT_RANGE(cplib_bs512_andpopcount_range, cplib_bs512_andpopcount,\
    \ x[i] & y[i])\nCPLIB_BS_COUNT_RANGE(cplib_bs512_orpopcount_range, cplib_bs512_orpopcount,\
    \ x[i] | y[i])\nCPLIB_BS_COUNT_RANGE(cplib_bs512_xorpopcount_range, cplib_bs512_xorpopcount,\
    \ x[i] ^ y[i])\n#undef CPLIB_BS_COUNT_RANGE\n\nCPLIB_BS_AVX2 static void cplib_bs512_from_string_char_avx2(uint64_t\
    \ *dst, const void *source,\n        const void *reference, unsigned char match,\
    \ size_t length, size_t words) {\n/* 32\u30D0\u30A4\u30C8\u305A\u3064\u6BD4\u8F03\
    \u3057\u3001\u6BD4\u8F03\u7D50\u679C\u306E\u30DE\u30B9\u30AF\u3092\u76F4\u63A5\
    \u30D3\u30C3\u30C8\u96C6\u5408\u3078\u683C\u7D0D\u3057\u307E\u3059\u3002 */\n\
    const unsigned char *src = (const unsigned char *)source;\nconst unsigned char\
    \ *ref = (const unsigned char *)reference;\nsize_t i = 0, word = 0;\nwhile (i\
    \ < length) {\n    uint64_t value = 0;\n    size_t j = 0, limit = length - i <\
    \ 64 ? length - i : 64;\n    for (; j + 32 <= limit; j += 32) {\n        size_t\
    \ pos = i + j;\n        __m256i a = _mm256_loadu_si256((const __m256i *)(src +\
    \ pos));\n        __m256i b = _mm256_set1_epi8((char)match);\n        uint32_t\
    \ mask = (uint32_t)_mm256_movemask_epi8(_mm256_cmpeq_epi8(a, b));\n        value\
    \ |= (uint64_t)mask << j;\n    }\n    for (; j < limit; ++j) value |= (uint64_t)(src[i\
    \ + j] == match) << j;\n    dst[word++] = value;\n    i += limit;\n}\nfor (; word\
    \ < words; ++word) dst[word] = 0;\n}\n\n__attribute__((target(\"avx512f,avx512bw\"\
    )))\nstatic void cplib_bs512_from_string_char_avx512(uint64_t *dst, const void\
    \ *source,\n        const void *reference, unsigned char match, size_t length,\
    \ size_t words) {\n/* 64\u30D0\u30A4\u30C8\u306E\u6BD4\u8F03\u30DE\u30B9\u30AF\
    \u30921\u30EF\u30FC\u30C9\u306B\u3057\u307E\u3059\u3002\u672B\u5C3E\u306F\u5165\
    \u529B\u7BC4\u56F2\u5185\u3060\u3051\u3092\u8AAD\u307F\u307E\u3059\u3002 */\n\
    const unsigned char *src = (const unsigned char *)source;\nconst unsigned char\
    \ *ref = (const unsigned char *)reference;\nsize_t i = 0, word = 0;\nfor (; i\
    \ + 64 <= length; i += 64) {\n    __m512i a = _mm512_loadu_si512((const void *)(src\
    \ + i));\n    __m512i b = _mm512_set1_epi8((char)match);\n    dst[word++] = (uint64_t)_mm512_cmpeq_epi8_mask(a,\
    \ b);\n}\nif (i < length) {\n    cplib_bs512_from_string_char_avx2(dst + word,\
    \ src + i, NULL, match, length - i, words - word);\n} else {\n    for (; word\
    \ < words; ++word) dst[word] = 0;\n}\n}\nstatic inline void cplib_bs512_from_string_char(uint64_t\
    \ *dst, const void *source,\n        const void *reference, unsigned char match,\
    \ size_t length, size_t words) {\n    if (length >= 64 && __builtin_cpu_supports(\"\
    avx512f\") && __builtin_cpu_supports(\"avx512bw\")) {\n        cplib_bs512_from_string_char_avx512(dst,\
    \ source, reference, match, length, words);\n    } else {\n        cplib_bs512_from_string_char_avx2(dst,\
    \ source, reference, match, length, words);\n    }\n}\n\nCPLIB_BS_AVX2 static\
    \ void cplib_bs512_from_string_equal_avx2(uint64_t *dst, const void *source,\n\
    \        const void *reference, unsigned char match, size_t length, size_t words)\
    \ {\n/* 32\u30D0\u30A4\u30C8\u305A\u3064\u6BD4\u8F03\u3057\u3001\u6BD4\u8F03\u7D50\
    \u679C\u306E\u30DE\u30B9\u30AF\u3092\u76F4\u63A5\u30D3\u30C3\u30C8\u96C6\u5408\
    \u3078\u683C\u7D0D\u3057\u307E\u3059\u3002 */\nconst unsigned char *src = (const\
    \ unsigned char *)source;\nconst unsigned char *ref = (const unsigned char *)reference;\n\
    size_t i = 0, word = 0;\nwhile (i < length) {\n    uint64_t value = 0;\n    size_t\
    \ j = 0, limit = length - i < 64 ? length - i : 64;\n    for (; j + 32 <= limit;\
    \ j += 32) {\n        size_t pos = i + j;\n        __m256i a = _mm256_loadu_si256((const\
    \ __m256i *)(src + pos));\n        __m256i b = _mm256_loadu_si256((const __m256i\
    \ *)(ref + pos));\n        uint32_t mask = (uint32_t)_mm256_movemask_epi8(_mm256_cmpeq_epi8(a,\
    \ b));\n        value |= (uint64_t)mask << j;\n    }\n    for (; j < limit; ++j)\
    \ value |= (uint64_t)(src[i + j] == ref[i + j]) << j;\n    dst[word++] = value;\n\
    \    i += limit;\n}\nfor (; word < words; ++word) dst[word] = 0;\n}\n\n__attribute__((target(\"\
    avx512f,avx512bw\")))\nstatic void cplib_bs512_from_string_equal_avx512(uint64_t\
    \ *dst, const void *source,\n        const void *reference, unsigned char match,\
    \ size_t length, size_t words) {\n/* 64\u30D0\u30A4\u30C8\u306E\u6BD4\u8F03\u30DE\
    \u30B9\u30AF\u30921\u30EF\u30FC\u30C9\u306B\u3057\u307E\u3059\u3002\u672B\u5C3E\
    \u306F\u5165\u529B\u7BC4\u56F2\u5185\u3060\u3051\u3092\u8AAD\u307F\u307E\u3059\
    \u3002 */\nconst unsigned char *src = (const unsigned char *)source;\nconst unsigned\
    \ char *ref = (const unsigned char *)reference;\nsize_t i = 0, word = 0;\nfor\
    \ (; i + 64 <= length; i += 64) {\n    __m512i a = _mm512_loadu_si512((const void\
    \ *)(src + i));\n    __m512i b = _mm512_loadu_si512((const void *)(ref + i));\n\
    \    dst[word++] = (uint64_t)_mm512_cmpeq_epi8_mask(a, b);\n}\nif (i < length)\
    \ {\n    cplib_bs512_from_string_equal_avx2(dst + word, src + i, ref + i, match,\
    \ length - i, words - word);\n} else {\n    for (; word < words; ++word) dst[word]\
    \ = 0;\n}\n}\nstatic inline void cplib_bs512_from_string_equal(uint64_t *dst,\
    \ const void *source,\n        const void *reference, unsigned char match, size_t\
    \ length, size_t words) {\n    if (length >= 64 && __builtin_cpu_supports(\"avx512f\"\
    ) && __builtin_cpu_supports(\"avx512bw\")) {\n        cplib_bs512_from_string_equal_avx512(dst,\
    \ source, reference, match, length, words);\n    } else {\n        cplib_bs512_from_string_equal_avx2(dst,\
    \ source, reference, match, length, words);\n    }\n}\n\nCPLIB_BS_AVX2 static\
    \ int cplib_bs512_intersects_avx2(const uint64_t *x, const uint64_t *y, size_t\
    \ n) {\n/* \u7D50\u679C\u304C\u78BA\u5B9A\u3057\u305F\u30D6\u30ED\u30C3\u30AF\u3067\
    \u7D42\u4E86\u3057\u3001\u500B\u6570\u306F\u6570\u3048\u307E\u305B\u3093\u3002\
    \ */\nsize_t i = 0;\nfor (; i + 4 <= n; i += 4) {\n    __m256i a = _mm256_loadu_si256((const\
    \ __m256i *)(x + i));\n    __m256i b = _mm256_loadu_si256((const __m256i *)(y\
    \ + i));\n    if (!_mm256_testz_si256(a, b)) return 1;\n}\nfor (; i < n; ++i)\
    \ if ((x[i] & y[i]) != 0) return 1;\nreturn 0;\n}\n\nCPLIB_BS_AVX512 static int\
    \ cplib_bs512_intersects_avx512(const uint64_t *x, const uint64_t *y, size_t n)\
    \ {\n/* \u7D50\u679C\u304C\u78BA\u5B9A\u3057\u305F\u30D6\u30ED\u30C3\u30AF\u3067\
    \u7D42\u4E86\u3057\u3001\u500B\u6570\u306F\u6570\u3048\u307E\u305B\u3093\u3002\
    \ */\nsize_t i = 0;\nfor (; i + 8 <= n; i += 8) {\n    __m512i a = _mm512_loadu_si512((const\
    \ void *)(x + i));\n    __m512i b = _mm512_loadu_si512((const void *)(y + i));\n\
    \    if (_mm512_test_epi64_mask(a, b) != 0) return 1;\n}\nfor (; i < n; ++i) if\
    \ ((x[i] & y[i]) != 0) return 1;\nreturn 0;\n}\n\nstatic inline int cplib_bs512_intersects(const\
    \ uint64_t *x, const uint64_t *y, size_t n) {\n    if (n >= 8 && __builtin_cpu_supports(\"\
    avx512f\")) return cplib_bs512_intersects_avx512(x, y, n);\n    return cplib_bs512_intersects_avx2(x,\
    \ y, n);\n}\n\nCPLIB_BS_AVX2 static int cplib_bs512_subset_avx2(const uint64_t\
    \ *x, const uint64_t *y, size_t n) {\n/* \u7D50\u679C\u304C\u78BA\u5B9A\u3057\u305F\
    \u30D6\u30ED\u30C3\u30AF\u3067\u7D42\u4E86\u3057\u3001\u500B\u6570\u306F\u6570\
    \u3048\u307E\u305B\u3093\u3002 */\nsize_t i = 0;\nfor (; i + 4 <= n; i += 4) {\n\
    \    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));\n    __m256i b\
    \ = _mm256_loadu_si256((const __m256i *)(y + i));\n    if (!_mm256_testc_si256(b,\
    \ a)) return 0;\n}\nfor (; i < n; ++i) if ((x[i] & ~y[i]) != 0) return 0;\nreturn\
    \ 1;\n}\n\nCPLIB_BS_AVX512 static int cplib_bs512_subset_avx512(const uint64_t\
    \ *x, const uint64_t *y, size_t n) {\n/* \u7D50\u679C\u304C\u78BA\u5B9A\u3057\u305F\
    \u30D6\u30ED\u30C3\u30AF\u3067\u7D42\u4E86\u3057\u3001\u500B\u6570\u306F\u6570\
    \u3048\u307E\u305B\u3093\u3002 */\nsize_t i = 0;\nfor (; i + 8 <= n; i += 8) {\n\
    \    __m512i a = _mm512_loadu_si512((const void *)(x + i));\n    __m512i b = _mm512_loadu_si512((const\
    \ void *)(y + i));\n    __m512i c = _mm512_andnot_si512(b, a);\n    if (_mm512_test_epi64_mask(c,\
    \ c) != 0) return 0;\n}\nfor (; i < n; ++i) if ((x[i] & ~y[i]) != 0) return 0;\n\
    return 1;\n}\n\nstatic inline int cplib_bs512_subset(const uint64_t *x, const\
    \ uint64_t *y, size_t n) {\n    if (n >= 8 && __builtin_cpu_supports(\"avx512f\"\
    )) return cplib_bs512_subset_avx512(x, y, n);\n    return cplib_bs512_subset_avx2(x,\
    \ y, n);\n}\n\nCPLIB_BS_AVX2 static void cplib_bs512_set_range_avx2(uint64_t *x,\
    \ size_t l, size_t r) {\n/* \u4E21\u7AEF\u3060\u3051\u3092\u30DE\u30B9\u30AF\u3057\
    \u3001\u4E2D\u592E\u306E\u5B8C\u5168\u306A\u30EF\u30FC\u30C9\u3092\u307E\u3068\
    \u3081\u3066\u66F4\u65B0\u3057\u307E\u3059\u3002 */\nif (l == r) return;\nsize_t\
    \ first = l >> 6, last = (r - 1) >> 6;\nuint64_t mask = UINT64_MAX << (l & 63);\n\
    const uint64_t rightMask = UINT64_MAX >> (63 - ((r - 1) & 63));\nif (first ==\
    \ last) {\n    mask &= rightMask;\n    x[first] |= mask;\n    return;\n}\nsize_t\
    \ end = last + 1;\nif ((l & 63) != 0) { x[first] |= mask; ++first; }\nif ((r &\
    \ 63) != 0) { mask = rightMask; x[last] |= mask; --end; }\nsize_t i = first;\n\
    for (; i + 4 <= end; i += 4)\n    _mm256_storeu_si256((__m256i *)(x + i), _mm256_set1_epi64x(-1));\n\
    for (; i < end; ++i) { x[i] = UINT64_MAX; }\n}\n\nCPLIB_BS_AVX512 static void\
    \ cplib_bs512_set_range_avx512(uint64_t *x, size_t l, size_t r) {\n/* \u4E21\u7AEF\
    \u3060\u3051\u3092\u30DE\u30B9\u30AF\u3057\u3001\u4E2D\u592E\u306E\u5B8C\u5168\
    \u306A\u30EF\u30FC\u30C9\u3092\u307E\u3068\u3081\u3066\u66F4\u65B0\u3057\u307E\
    \u3059\u3002 */\nif (l == r) return;\nsize_t first = l >> 6, last = (r - 1) >>\
    \ 6;\nuint64_t mask = UINT64_MAX << (l & 63);\nconst uint64_t rightMask = UINT64_MAX\
    \ >> (63 - ((r - 1) & 63));\nif (first == last) {\n    mask &= rightMask;\n  \
    \  x[first] |= mask;\n    return;\n}\nsize_t end = last + 1;\nif ((l & 63) !=\
    \ 0) { x[first] |= mask; ++first; }\nif ((r & 63) != 0) { mask = rightMask; x[last]\
    \ |= mask; --end; }\nsize_t i = first;\nfor (; i + 8 <= end; i += 8)\n    _mm512_storeu_si512((void\
    \ *)(x + i), _mm512_set1_epi64(-1));\nfor (; i < end; ++i) { x[i] = UINT64_MAX;\
    \ }\n}\n\nstatic inline void cplib_bs512_set_range(uint64_t *x, size_t l, size_t\
    \ r) {\n    if (r - l >= 512 && __builtin_cpu_supports(\"avx512f\")) cplib_bs512_set_range_avx512(x,\
    \ l, r);\n    else cplib_bs512_set_range_avx2(x, l, r);\n}\n\nCPLIB_BS_AVX2 static\
    \ void cplib_bs512_clear_range_avx2(uint64_t *x, size_t l, size_t r) {\n/* \u4E21\
    \u7AEF\u3060\u3051\u3092\u30DE\u30B9\u30AF\u3057\u3001\u4E2D\u592E\u306E\u5B8C\
    \u5168\u306A\u30EF\u30FC\u30C9\u3092\u307E\u3068\u3081\u3066\u66F4\u65B0\u3057\
    \u307E\u3059\u3002 */\nif (l == r) return;\nsize_t first = l >> 6, last = (r -\
    \ 1) >> 6;\nuint64_t mask = UINT64_MAX << (l & 63);\nconst uint64_t rightMask\
    \ = UINT64_MAX >> (63 - ((r - 1) & 63));\nif (first == last) {\n    mask &= rightMask;\n\
    \    x[first] &= ~mask;\n    return;\n}\nsize_t end = last + 1;\nif ((l & 63)\
    \ != 0) { x[first] &= ~mask; ++first; }\nif ((r & 63) != 0) { mask = rightMask;\
    \ x[last] &= ~mask; --end; }\nsize_t i = first;\nfor (; i + 4 <= end; i += 4)\n\
    \    _mm256_storeu_si256((__m256i *)(x + i), _mm256_setzero_si256());\nfor (;\
    \ i < end; ++i) { x[i] = 0; }\n}\n\nCPLIB_BS_AVX512 static void cplib_bs512_clear_range_avx512(uint64_t\
    \ *x, size_t l, size_t r) {\n/* \u4E21\u7AEF\u3060\u3051\u3092\u30DE\u30B9\u30AF\
    \u3057\u3001\u4E2D\u592E\u306E\u5B8C\u5168\u306A\u30EF\u30FC\u30C9\u3092\u307E\
    \u3068\u3081\u3066\u66F4\u65B0\u3057\u307E\u3059\u3002 */\nif (l == r) return;\n\
    size_t first = l >> 6, last = (r - 1) >> 6;\nuint64_t mask = UINT64_MAX << (l\
    \ & 63);\nconst uint64_t rightMask = UINT64_MAX >> (63 - ((r - 1) & 63));\nif\
    \ (first == last) {\n    mask &= rightMask;\n    x[first] &= ~mask;\n    return;\n\
    }\nsize_t end = last + 1;\nif ((l & 63) != 0) { x[first] &= ~mask; ++first; }\n\
    if ((r & 63) != 0) { mask = rightMask; x[last] &= ~mask; --end; }\nsize_t i =\
    \ first;\nfor (; i + 8 <= end; i += 8)\n    _mm512_storeu_si512((void *)(x + i),\
    \ _mm512_setzero_si512());\nfor (; i < end; ++i) { x[i] = 0; }\n}\n\nstatic inline\
    \ void cplib_bs512_clear_range(uint64_t *x, size_t l, size_t r) {\n    if (r -\
    \ l >= 512 && __builtin_cpu_supports(\"avx512f\")) cplib_bs512_clear_range_avx512(x,\
    \ l, r);\n    else cplib_bs512_clear_range_avx2(x, l, r);\n}\n\nCPLIB_BS_AVX2\
    \ static void cplib_bs512_flip_range_avx2(uint64_t *x, size_t l, size_t r) {\n\
    /* \u4E21\u7AEF\u3060\u3051\u3092\u30DE\u30B9\u30AF\u3057\u3001\u4E2D\u592E\u306E\
    \u5B8C\u5168\u306A\u30EF\u30FC\u30C9\u3092\u307E\u3068\u3081\u3066\u66F4\u65B0\
    \u3057\u307E\u3059\u3002 */\nif (l == r) return;\nsize_t first = l >> 6, last\
    \ = (r - 1) >> 6;\nuint64_t mask = UINT64_MAX << (l & 63);\nconst uint64_t rightMask\
    \ = UINT64_MAX >> (63 - ((r - 1) & 63));\nif (first == last) {\n    mask &= rightMask;\n\
    \    x[first] ^= mask;\n    return;\n}\nsize_t end = last + 1;\nif ((l & 63) !=\
    \ 0) { x[first] ^= mask; ++first; }\nif ((r & 63) != 0) { mask = rightMask; x[last]\
    \ ^= mask; --end; }\nsize_t i = first;\nfor (; i + 4 <= end; i += 4)\n    _mm256_storeu_si256((__m256i\
    \ *)(x + i), _mm256_xor_si256(_mm256_loadu_si256((const __m256i *)(x + i)), _mm256_set1_epi64x(-1)));\n\
    for (; i < end; ++i) { x[i] = ~x[i]; }\n}\n\nCPLIB_BS_AVX512 static void cplib_bs512_flip_range_avx512(uint64_t\
    \ *x, size_t l, size_t r) {\n/* \u4E21\u7AEF\u3060\u3051\u3092\u30DE\u30B9\u30AF\
    \u3057\u3001\u4E2D\u592E\u306E\u5B8C\u5168\u306A\u30EF\u30FC\u30C9\u3092\u307E\
    \u3068\u3081\u3066\u66F4\u65B0\u3057\u307E\u3059\u3002 */\nif (l == r) return;\n\
    size_t first = l >> 6, last = (r - 1) >> 6;\nuint64_t mask = UINT64_MAX << (l\
    \ & 63);\nconst uint64_t rightMask = UINT64_MAX >> (63 - ((r - 1) & 63));\nif\
    \ (first == last) {\n    mask &= rightMask;\n    x[first] ^= mask;\n    return;\n\
    }\nsize_t end = last + 1;\nif ((l & 63) != 0) { x[first] ^= mask; ++first; }\n\
    if ((r & 63) != 0) { mask = rightMask; x[last] ^= mask; --end; }\nsize_t i = first;\n\
    for (; i + 8 <= end; i += 8)\n    _mm512_storeu_si512((void *)(x + i), _mm512_xor_si512(_mm512_loadu_si512((const\
    \ void *)(x + i)), _mm512_set1_epi64(-1)));\nfor (; i < end; ++i) { x[i] = ~x[i];\
    \ }\n}\n\nstatic inline void cplib_bs512_flip_range(uint64_t *x, size_t l, size_t\
    \ r) {\n    if (r - l >= 512 && __builtin_cpu_supports(\"avx512f\")) cplib_bs512_flip_range_avx512(x,\
    \ l, r);\n    else cplib_bs512_flip_range_avx2(x, l, r);\n}\n\nCPLIB_BS_AVX2 static\
    \ int cplib_bs512_cmp_avx2(const uint64_t *x, const uint64_t *y, size_t n) {\n\
    /* 256\u30D3\u30C3\u30C8\u305A\u3064\u4E00\u81F4\u5224\u5B9A\u3057\u3001\u6700\
    \u521D\u306E\u76F8\u9055\u30EF\u30FC\u30C9\u306E\u6700\u4E0B\u4F4D\u306E\u76F8\
    \u9055\u30D3\u30C3\u30C8\u3067\u6BD4\u8F03\u3057\u307E\u3059\u3002 */\nsize_t\
    \ i = 0;\nfor (; i + 4 <= n; i += 4) {\n    __m256i a = _mm256_loadu_si256((const\
    \ __m256i *)(x + i));\n    __m256i b = _mm256_loadu_si256((const __m256i *)(y\
    \ + i));\n    unsigned mask = (unsigned)(~_mm256_movemask_pd(_mm256_castsi256_pd(_mm256_cmpeq_epi64(a,\
    \ b)))) & 15u;\n    if (mask != 0) {\n        size_t j = i + __builtin_ctz(mask);\n\
    \        uint64_t diff = x[j] ^ y[j];\n        return ((x[j] >> __builtin_ctzll(diff))\
    \ & 1) ? 1 : -1;\n    }\n}\nfor (; i < n; ++i) {\n    uint64_t diff = x[i] ^ y[i];\n\
    \    if (diff != 0) return ((x[i] >> __builtin_ctzll(diff)) & 1) ? 1 : -1;\n}\n\
    return 0;\n}\n\nCPLIB_BS_AVX512 static int cplib_bs512_cmp_avx512(const uint64_t\
    \ *x, const uint64_t *y, size_t n) {\n/* 512\u30D3\u30C3\u30C8\u305A\u3064\u4E00\
    \u81F4\u5224\u5B9A\u3057\u3001\u6700\u521D\u306E\u76F8\u9055\u30EF\u30FC\u30C9\
    \u306E\u6700\u4E0B\u4F4D\u306E\u76F8\u9055\u30D3\u30C3\u30C8\u3067\u6BD4\u8F03\
    \u3057\u307E\u3059\u3002 */\nsize_t i = 0;\nfor (; i + 8 <= n; i += 8) {\n   \
    \ __m512i a = _mm512_loadu_si512((const void *)(x + i));\n    __m512i b = _mm512_loadu_si512((const\
    \ void *)(y + i));\n    unsigned mask = (unsigned)_mm512_cmpneq_epi64_mask(a,\
    \ b);\n    if (mask != 0) {\n        size_t j = i + __builtin_ctz(mask);\n   \
    \     uint64_t diff = x[j] ^ y[j];\n        return ((x[j] >> __builtin_ctzll(diff))\
    \ & 1) ? 1 : -1;\n    }\n}\nfor (; i < n; ++i) {\n    uint64_t diff = x[i] ^ y[i];\n\
    \    if (diff != 0) return ((x[i] >> __builtin_ctzll(diff)) & 1) ? 1 : -1;\n}\n\
    return 0;\n}\n\nstatic int cplib_bs512_cmp(const uint64_t *x, const uint64_t *y,\
    \ size_t n) {\n/* \u5BFE\u5FDCCPU\u3067\u306F512\u30D3\u30C3\u30C8\u305A\u3064\
    \u6BD4\u8F03\u3057\u3001\u305D\u308C\u4EE5\u5916\u306FAVX2\u3092\u4F7F\u3044\u307E\
    \u3059\u3002 */\nif (n >= 8 && __builtin_cpu_supports(\"avx512f\")) return cplib_bs512_cmp_avx512(x,\
    \ y, n);\nreturn cplib_bs512_cmp_avx2(x, y, n);\n}\n\n\nCPLIB_BS_AVX2 static int\
    \ cplib_bs512_all_avx2(const uint64_t *x, size_t bits) {\n/* 256\u30D3\u30C3\u30C8\
    \u305A\u3064\u5224\u5B9A\u3057\u3001\u7D50\u679C\u304C\u78BA\u5B9A\u3057\u305F\
    \u3089\u7D42\u4E86\u3057\u307E\u3059\u3002\u672B\u5C3E\u306E\u7121\u52B9\u30D3\
    \u30C3\u30C8\u306F\u7121\u8996\u3057\u307E\u3059\u3002 */\nconst size_t n = bits\
    \ >> 6;\nconst __m256i ones = _mm256_set1_epi64x(-1);\nsize_t i = 0;\nfor (; i\
    \ + 4 <= n; i += 4) {\n    __m256i value = _mm256_loadu_si256((const __m256i *)(x\
    \ + i));\n    if (!_mm256_testc_si256(value, ones)) return 0;\n}\nfor (; i < n;\
    \ ++i) {\n    if (x[i] != UINT64_MAX) return 0;\n}\nconst unsigned remaining =\
    \ bits & 63;\nif (remaining != 0) {\n    const uint64_t mask = (UINT64_C(1) <<\
    \ remaining) - 1;\n    return (x[n] & mask) == mask;\n}\nreturn 1;\n}\n\nCPLIB_BS_AVX512\
    \ static int cplib_bs512_all_avx512(const uint64_t *x, size_t bits) {\n/* 512\u30D3\
    \u30C3\u30C8\u305A\u3064\u5224\u5B9A\u3057\u3001\u7D50\u679C\u304C\u78BA\u5B9A\
    \u3057\u305F\u3089\u7D42\u4E86\u3057\u307E\u3059\u3002\u672B\u5C3E\u306E\u7121\
    \u52B9\u30D3\u30C3\u30C8\u306F\u7121\u8996\u3057\u307E\u3059\u3002 */\nconst size_t\
    \ n = bits >> 6;\nconst __m512i expected = _mm512_set1_epi64(-1);\nsize_t i =\
    \ 0;\nfor (; i + 8 <= n; i += 8) {\n    __m512i value = _mm512_loadu_si512((const\
    \ void *)(x + i));\n    if (_mm512_cmpneq_epi64_mask(value, expected) != 0) return\
    \ 0;\n}\nfor (; i < n; ++i) {\n    if (x[i] != UINT64_MAX) return 0;\n}\nconst\
    \ unsigned remaining = bits & 63;\nif (remaining != 0) {\n    const uint64_t mask\
    \ = (UINT64_C(1) << remaining) - 1;\n    return (x[n] & mask) == mask;\n}\nreturn\
    \ 1;\n}\n\nstatic inline int cplib_bs512_all(const uint64_t *x, size_t bits) {\n\
    /* \u5BFE\u5FDCCPU\u3067\u306F512\u30D3\u30C3\u30C8\u305A\u3064\u5224\u5B9A\u3057\
    \u3001\u305D\u308C\u4EE5\u5916\u306FAVX2\u3092\u4F7F\u3044\u307E\u3059\u3002 */\n\
    if (bits >= 512 && __builtin_cpu_supports(\"avx512f\")) return cplib_bs512_all_avx512(x,\
    \ bits);\nreturn cplib_bs512_all_avx2(x, bits);\n}\n\nCPLIB_BS_AVX2 static int\
    \ cplib_bs512_any_avx2(const uint64_t *x, size_t bits) {\n/* 256\u30D3\u30C3\u30C8\
    \u305A\u3064\u5224\u5B9A\u3057\u3001\u7D50\u679C\u304C\u78BA\u5B9A\u3057\u305F\
    \u3089\u7D42\u4E86\u3057\u307E\u3059\u3002\u672B\u5C3E\u306E\u7121\u52B9\u30D3\
    \u30C3\u30C8\u306F\u7121\u8996\u3057\u307E\u3059\u3002 */\nconst size_t n = bits\
    \ >> 6;\nsize_t i = 0;\nfor (; i + 4 <= n; i += 4) {\n    __m256i value = _mm256_loadu_si256((const\
    \ __m256i *)(x + i));\n    if (!_mm256_testz_si256(value, value)) return 1;\n\
    }\nfor (; i < n; ++i) {\n    if (x[i] != 0) return 1;\n}\nconst unsigned remaining\
    \ = bits & 63;\nif (remaining != 0) {\n    const uint64_t mask = (UINT64_C(1)\
    \ << remaining) - 1;\n    return (x[n] & mask) != 0;\n}\nreturn 0;\n}\n\nCPLIB_BS_AVX512\
    \ static int cplib_bs512_any_avx512(const uint64_t *x, size_t bits) {\n/* 512\u30D3\
    \u30C3\u30C8\u305A\u3064\u5224\u5B9A\u3057\u3001\u7D50\u679C\u304C\u78BA\u5B9A\
    \u3057\u305F\u3089\u7D42\u4E86\u3057\u307E\u3059\u3002\u672B\u5C3E\u306E\u7121\
    \u52B9\u30D3\u30C3\u30C8\u306F\u7121\u8996\u3057\u307E\u3059\u3002 */\nconst size_t\
    \ n = bits >> 6;\nconst __m512i expected = _mm512_setzero_si512();\nsize_t i =\
    \ 0;\nfor (; i + 8 <= n; i += 8) {\n    __m512i value = _mm512_loadu_si512((const\
    \ void *)(x + i));\n    if (_mm512_cmpneq_epi64_mask(value, expected) != 0) return\
    \ 1;\n}\nfor (; i < n; ++i) {\n    if (x[i] != 0) return 1;\n}\nconst unsigned\
    \ remaining = bits & 63;\nif (remaining != 0) {\n    const uint64_t mask = (UINT64_C(1)\
    \ << remaining) - 1;\n    return (x[n] & mask) != 0;\n}\nreturn 0;\n}\n\nstatic\
    \ inline int cplib_bs512_any(const uint64_t *x, size_t bits) {\n/* \u5BFE\u5FDC\
    CPU\u3067\u306F512\u30D3\u30C3\u30C8\u305A\u3064\u5224\u5B9A\u3057\u3001\u305D\
    \u308C\u4EE5\u5916\u306FAVX2\u3092\u4F7F\u3044\u307E\u3059\u3002 */\nif (bits\
    \ >= 512 && __builtin_cpu_supports(\"avx512f\")) return cplib_bs512_any_avx512(x,\
    \ bits);\nreturn cplib_bs512_any_avx2(x, bits);\n}\n\n#undef CPLIB_BS_AVX512\n\
    #undef CPLIB_BS_AVX2\n#endif\n\"\"\".}\n\nproc avxAnd(dst, x, y: ptr uint64, n:\
    \ csize_t) {.importc: \"cplib_bs512_and\", nodecl.}\nproc avxAndNot(dst, x, y:\
    \ ptr uint64, n: csize_t) {.importc: \"cplib_bs512_andnot\", nodecl.}\nproc avxOr(dst,\
    \ x, y: ptr uint64, n: csize_t) {.importc: \"cplib_bs512_or\", nodecl.}\nproc\
    \ avxXor(dst, x, y: ptr uint64, n: csize_t) {.importc: \"cplib_bs512_xor\", nodecl.}\n\
    proc avxNot(dst, x: ptr uint64, n: csize_t) {.importc: \"cplib_bs512_not\", nodecl.}\n\
    proc avxShl(dst, x: ptr uint64, n, shift: csize_t) {.importc: \"cplib_bs512_shl\"\
    , nodecl.}\nproc avxShr(dst, x: ptr uint64, n, shift: csize_t) {.importc: \"cplib_bs512_shr\"\
    , nodecl.}\nproc avxPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc:\
    \ \"cplib_bs512_popcount\", nodecl.}\nproc avxAndPopcount(x, y: ptr uint64, n:\
    \ csize_t): csize_t {.importc: \"cplib_bs512_andpopcount\", nodecl.}\nproc avxOrPopcount(x,\
    \ y: ptr uint64, n: csize_t): csize_t {.importc: \"cplib_bs512_orpopcount\", nodecl.}\n\
    proc avxXorPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc: \"cplib_bs512_xorpopcount\"\
    , nodecl.}\nproc avxFromBools(dst: ptr uint64, src: pointer, length, words: csize_t)\
    \ {.importc: \"cplib_bs512_from_bools\", nodecl.}\n\nproc avxSelectAssign(dst,\
    \ x, y, z: ptr uint64, n: csize_t) {.importc: \"cplib_bs512_select\", nodecl.}\n\
    \nproc avxOrAndAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: \"cplib_bs512_orand\"\
    , nodecl.}\n\nproc avxAndOrAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc:\
    \ \"cplib_bs512_andor\", nodecl.}\n\nproc avxXorAndAssign(dst, x, y, z: ptr uint64,\
    \ n: csize_t) {.importc: \"cplib_bs512_xorand\", nodecl.}\n\nproc avxMajority(dst,\
    \ x, y, z: ptr uint64, n: csize_t) {.importc: \"cplib_bs512_majority\", nodecl.}\n\
    \nproc avxXnorAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: \"cplib_bs512_xnor\"\
    , nodecl.}\n\nproc avxAndAssignPopcount(x, y, z: ptr uint64, bits: csize_t): csize_t\
    \ {.importc: \"cplib_bs512_and_update_count\", nodecl.}\n\nproc avxOrAssignPopcount(x,\
    \ y, z: ptr uint64, bits: csize_t): csize_t {.importc: \"cplib_bs512_or_update_count\"\
    , nodecl.}\n\nproc avxXorAssignPopcount(x, y, z: ptr uint64, bits: csize_t): csize_t\
    \ {.importc: \"cplib_bs512_xor_update_count\", nodecl.}\n\nproc avxAndNotAssignPopcount(x,\
    \ y, z: ptr uint64, bits: csize_t): csize_t {.importc: \"cplib_bs512_andnot_update_count\"\
    , nodecl.}\n\nproc avxSelectAssignPopcount(x, y, z: ptr uint64, bits: csize_t):\
    \ csize_t {.importc: \"cplib_bs512_select_update_count\", nodecl.}\n\nproc avxOrAndAssignPopcount(x,\
    \ y, z: ptr uint64, bits: csize_t): csize_t {.importc: \"cplib_bs512_orand_update_count\"\
    , nodecl.}\n\nproc avxAndOrAssignPopcount(x, y, z: ptr uint64, bits: csize_t):\
    \ csize_t {.importc: \"cplib_bs512_andor_update_count\", nodecl.}\n\nproc avxXorAndAssignPopcount(x,\
    \ y, z: ptr uint64, bits: csize_t): csize_t {.importc: \"cplib_bs512_xorand_update_count\"\
    , nodecl.}\n\nproc avxXnorAssignPopcount(x, y, z: ptr uint64, bits: csize_t):\
    \ csize_t {.importc: \"cplib_bs512_xnor_update_count\", nodecl.}\n\nproc avxPopcountRange(x,\
    \ y: ptr uint64, l, r: csize_t): csize_t {.importc: \"cplib_bs512_popcount_range\"\
    , nodecl.}\n\nproc avxAndpopcountRange(x, y: ptr uint64, l, r: csize_t): csize_t\
    \ {.importc: \"cplib_bs512_andpopcount_range\", nodecl.}\n\nproc avxOrpopcountRange(x,\
    \ y: ptr uint64, l, r: csize_t): csize_t {.importc: \"cplib_bs512_orpopcount_range\"\
    , nodecl.}\n\nproc avxXorpopcountRange(x, y: ptr uint64, l, r: csize_t): csize_t\
    \ {.importc: \"cplib_bs512_xorpopcount_range\", nodecl.}\n\nproc avxFromStringChar(dst:\
    \ ptr uint64, source, reference: pointer, match: uint8, length, words: csize_t)\
    \ {.importc: \"cplib_bs512_from_string_char\", nodecl.}\n\nproc avxFromStringEqual(dst:\
    \ ptr uint64, source, reference: pointer, match: uint8, length, words: csize_t)\
    \ {.importc: \"cplib_bs512_from_string_equal\", nodecl.}\n\nproc avxIntersects(x,\
    \ y: ptr uint64, n: csize_t): cint {.importc: \"cplib_bs512_intersects\", nodecl.}\n\
    \nproc avxSubset(x, y: ptr uint64, n: csize_t): cint {.importc: \"cplib_bs512_subset\"\
    , nodecl.}\n\nproc avxSetRange(x: ptr uint64, l, r: csize_t) {.importc: \"cplib_bs512_set_range\"\
    , nodecl.}\n\nproc avxClearRange(x: ptr uint64, l, r: csize_t) {.importc: \"cplib_bs512_clear_range\"\
    , nodecl.}\n\nproc avxFlipRange(x: ptr uint64, l, r: csize_t) {.importc: \"cplib_bs512_flip_range\"\
    , nodecl.}\n\nproc avxCmp(x, y: ptr uint64, n: csize_t): cint {.importc: \"cplib_bs512_cmp\"\
    , nodecl.}\n\nproc avxAll(x: ptr uint64, bits: csize_t): cint {.importc: \"cplib_bs512_all\"\
    , nodecl.}\n\nproc avxAny(x: ptr uint64, bits: csize_t): cint {.importc: \"cplib_bs512_any\"\
    , nodecl.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/private/bitset_avx512_impl.nim
  requiredBy:
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/staticbitset_avx512.nim
  - cplib/collections/staticbitset_avx512.nim
  timestamp: '2026-09-13 04:30:30+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/private/bitset_avx512_impl.nim
layout: document
redirect_from:
- /library/cplib/collections/private/bitset_avx512_impl.nim
- /library/cplib/collections/private/bitset_avx512_impl.nim.html
title: cplib/collections/private/bitset_avx512_impl.nim
---
