---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/wordsizetree_avx2_test.nim
    title: verify/AI/wordsizetree_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/wordsizetree_avx2_test.nim
    title: verify/AI/wordsizetree_avx2_test.nim
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
  code: "## 0..<2^24\u306E\u30AD\u30FC\u3092\u6271\u3046\u30013\u6BB5\u30FB256\u5206\
    \u5C90\u306E\u30D3\u30C3\u30C8\u96C6\u5408\u6728\u3067\u3059\u3002\nwhen not declared\
    \ CPLIB_COLLECTIONS_WORD_SIZE_TREE_AVX2:\n    const CPLIB_COLLECTIONS_WORD_SIZE_TREE_AVX2*\
    \ = 1\n    when not (defined(amd64) and (defined(gcc) or defined(clang))):\n \
    \       {.error: \"WordsizeTreeAvx2 requires amd64 and GCC/Clang\".}\n    const\
    \ WordsizeTreeAvx2Capacity* = 1 shl 24\n    type WordsizeTreeAvx2* = object\n\
    \        leaf: array[1 shl 18, uint64]\n        middle: array[1 shl 10, uint64]\n\
    \        top: array[4, uint64]\n    static: doAssert sizeof(bool) == 1\n    {.emit:\
    \ \"\"\"\n#include <immintrin.h>\n#include <stdint.h>\n#include <stddef.h>\n#define\
    \ WST_AVX __attribute__((target(\"avx2\")))\n/* \u5404\u30CE\u30FC\u30C9\u306E\
    256\u30D3\u30C3\u30C8\u3092\u3001\u9023\u7D9A\u3059\u308B4\u500B\u306E64\u30D3\
    \u30C3\u30C8\u6574\u6570\u306B\u683C\u7D0D\u3057\u307E\u3059\u3002 */\nWST_AVX\
    \ static inline unsigned wst_lanes(const uint64_t *p) {\n    /* \u975E\u96F6\u306E\
    64\u30D3\u30C3\u30C8\u6574\u6570\u306E\u4F4D\u7F6E\u3092\u30D3\u30C3\u30C8\u30DE\
    \u30B9\u30AF\u3067\u8FD4\u3057\u307E\u3059\u3002 */\n    __m256i v = _mm256_loadu_si256((const\
    \ __m256i *)p);\n    return (~(unsigned)_mm256_movemask_pd(_mm256_castsi256_pd(\n\
    \        _mm256_cmpeq_epi64(v, _mm256_setzero_si256())))) & 15u;\n}\nWST_AVX static\
    \ inline int wst_next(const uint64_t *p, int bit) {\n    /* \u30CE\u30FC\u30C9\
    \u5185\u3067bit\u4EE5\u4E0A\u306E\u6700\u5C0F\u306E\u8981\u7D20\u3092\u8FD4\u3057\
    \u3001\u5B58\u5728\u3057\u306A\u3051\u308C\u3070-1\u3092\u8FD4\u3057\u307E\u3059\
    \u3002 */\n    if (bit >= 256) return -1;\n    unsigned lane = (unsigned)bit >>\
    \ 6;\n    uint64_t word = p[lane] & (UINT64_MAX << (bit & 63));\n    if (word)\
    \ return (int)(lane * 64 + __builtin_ctzll(word));\n    unsigned mask = wst_lanes(p)\
    \ & (15u << (lane + 1));\n    if (!mask) return -1;\n    lane = __builtin_ctz(mask);\n\
    \    return (int)(lane * 64 + __builtin_ctzll(p[lane]));\n}\nWST_AVX static inline\
    \ int wst_prev(const uint64_t *p, int bit) {\n    /* \u30CE\u30FC\u30C9\u5185\u3067\
    bit\u4EE5\u4E0B\u306E\u6700\u5927\u306E\u8981\u7D20\u3092\u8FD4\u3057\u3001\u5B58\
    \u5728\u3057\u306A\u3051\u308C\u3070-1\u3092\u8FD4\u3057\u307E\u3059\u3002 */\n\
    \    if (bit < 0) return -1;\n    unsigned lane = (unsigned)bit >> 6;\n    uint64_t\
    \ word = p[lane] & (UINT64_MAX >> (63 - (bit & 63)));\n    if (word) return (int)(lane\
    \ * 64 + 63 - __builtin_clzll(word));\n    unsigned mask = wst_lanes(p) & ((1u\
    \ << lane) - 1);\n    if (!mask) return -1;\n    lane = 31 - __builtin_clz(mask);\n\
    \    return (int)(lane * 64 + 63 - __builtin_clzll(p[lane]));\n}\nWST_AVX static\
    \ void wst_init(const void *input, size_t n,\n                            uint64_t\
    \ *leaf, uint64_t *mid, uint64_t *top) {\n    /* \u771F\u507D\u5024\u914D\u5217\
    \u304B\u3089\u3001\u30BC\u30ED\u521D\u671F\u5316\u3055\u308C\u305F\u5404\u6BB5\
    \u306E\u30D3\u30C3\u30C8\u96C6\u5408\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\
    \ */\n    const unsigned char *v = (const unsigned char *)input;\n    size_t i\
    \ = 0;\n    const __m256i zero = _mm256_setzero_si256();\n    for (; i + 64 <=\
    \ n; i += 64) {\n        __m256i a = _mm256_loadu_si256((const __m256i *)(v +\
    \ i));\n        __m256i b = _mm256_loadu_si256((const __m256i *)(v + i + 32));\n\
    \        uint32_t lo = ~(uint32_t)_mm256_movemask_epi8(_mm256_cmpeq_epi8(a, zero));\n\
    \        uint32_t hi = ~(uint32_t)_mm256_movemask_epi8(_mm256_cmpeq_epi8(b, zero));\n\
    \        leaf[i >> 6] = (uint64_t)lo | ((uint64_t)hi << 32);\n    }\n    if (i\
    \ < n) {\n        uint64_t word = 0;\n        for (size_t j = 0; i + j < n; ++j)\
    \ word |= (uint64_t)(v[i+j] != 0) << j;\n        leaf[i >> 6] = word;\n    }\n\
    \    size_t nodes = (n + 255) >> 8;\n    for (size_t j = 0; j < nodes; ++j)\n\
    \        mid[j >> 6] |= (uint64_t)(wst_lanes(leaf + j * 4) != 0) << (j & 63);\n\
    \    for (size_t j = 0; j < ((nodes + 255) >> 8); ++j)\n        top[j >> 6] |=\
    \ (uint64_t)(wst_lanes(mid + j * 4) != 0) << (j & 63);\n}\nWST_AVX static void\
    \ wst_incl(uint64_t *leaf, uint64_t *mid, uint64_t *top, unsigned x) {\n    /*\
    \ \u8981\u7D20x\u3092\u8FFD\u52A0\u3057\u3001\u4E0A\u4F4D\u306E\u30D3\u30C3\u30C8\
    \u96C6\u5408\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002 */\n    leaf[x >> 6] |=\
    \ UINT64_C(1) << (x & 63);\n    x >>= 8;\n    mid[x >> 6] |= UINT64_C(1) << (x\
    \ & 63);\n    x >>= 8;\n    top[x >> 6] |= UINT64_C(1) << (x & 63);\n}\nWST_AVX\
    \ static void wst_excl(uint64_t *leaf, uint64_t *mid, uint64_t *top, unsigned\
    \ x) {\n    /* \u8981\u7D20x\u3092\u524A\u9664\u3057\u3001\u7A7A\u306B\u306A\u3063\
    \u305F\u30CE\u30FC\u30C9\u3092\u4E0A\u4F4D\u306E\u30D3\u30C3\u30C8\u96C6\u5408\
    \u304B\u3089\u9664\u304D\u307E\u3059\u3002 */\n    leaf[x >> 6] &= ~(UINT64_C(1)\
    \ << (x & 63));\n    x >>= 8;\n    if (wst_lanes(leaf + x * 4)) return;\n    mid[x\
    \ >> 6] &= ~(UINT64_C(1) << (x & 63));\n    x >>= 8;\n    if (wst_lanes(mid +\
    \ x * 4)) return;\n    top[x >> 6] &= ~(UINT64_C(1) << (x & 63));\n}\nWST_AVX\
    \ static int wst_ge(const uint64_t *leaf, const uint64_t *mid,\n             \
    \             const uint64_t *top, unsigned x) {\n    /* x\u4EE5\u4E0A\u306E\u6700\
    \u5C0F\u306E\u8981\u7D20\u3092\u8FD4\u3057\u3001\u5B58\u5728\u3057\u306A\u3051\
    \u308C\u3070-1\u3092\u8FD4\u3057\u307E\u3059\u3002 */\n    unsigned node = x >>\
    \ 8;\n    int bit = wst_next(leaf + node * 4, x & 255);\n    if (bit >= 0) return\
    \ (int)(node * 256 + bit);\n    unsigned parent = node >> 8;\n    bit = wst_next(mid\
    \ + parent * 4, (node & 255) + 1);\n    if (bit < 0) {\n        int upper = wst_next(top,\
    \ parent + 1);\n        if (upper < 0) return -1;\n        parent = (unsigned)upper;\n\
    \        bit = wst_next(mid + parent * 4, 0);\n    }\n    node = parent * 256\
    \ + bit;\n    return (int)(node * 256 + wst_next(leaf + node * 4, 0));\n}\nWST_AVX\
    \ static int wst_le(const uint64_t *leaf, const uint64_t *mid,\n             \
    \             const uint64_t *top, unsigned x) {\n    /* x\u4EE5\u4E0B\u306E\u6700\
    \u5927\u306E\u8981\u7D20\u3092\u8FD4\u3057\u3001\u5B58\u5728\u3057\u306A\u3051\
    \u308C\u3070-1\u3092\u8FD4\u3057\u307E\u3059\u3002 */\n    unsigned node = x >>\
    \ 8;\n    int bit = wst_prev(leaf + node * 4, x & 255);\n    if (bit >= 0) return\
    \ (int)(node * 256 + bit);\n    unsigned parent = node >> 8;\n    bit = wst_prev(mid\
    \ + parent * 4, (int)(node & 255) - 1);\n    if (bit < 0) {\n        int upper\
    \ = wst_prev(top, (int)parent - 1);\n        if (upper < 0) return -1;\n     \
    \   parent = (unsigned)upper;\n        bit = wst_prev(mid + parent * 4, 255);\n\
    \    }\n    node = parent * 256 + bit;\n    return (int)(node * 256 + wst_prev(leaf\
    \ + node * 4, 255));\n}\n#undef WST_AVX\n\"\"\".}\n    proc avxInit(input: pointer,\
    \ n: csize_t, leaf, middle, top: ptr uint64)\n        {.importc: \"wst_init\"\
    , nodecl.}\n    proc avxIncl(leaf, middle, top: ptr uint64, x: cuint)\n      \
    \  {.importc: \"wst_incl\", nodecl.}\n    proc avxExcl(leaf, middle, top: ptr\
    \ uint64, x: cuint)\n        {.importc: \"wst_excl\", nodecl.}\n    proc avxGe(leaf,\
    \ middle, top: ptr uint64, x: cuint): cint\n        {.importc: \"wst_ge\", nodecl.}\n\
    \    proc avxLe(leaf, middle, top: ptr uint64, x: cuint): cint\n        {.importc:\
    \ \"wst_le\", nodecl.}\n\n    proc initWordsizeTree*(): WordsizeTreeAvx2 =\n \
    \       ## \u7A7A\u306E\u30D3\u30C3\u30C8\u96C6\u5408\u6728\u3092\u4F5C\u6210\u3057\
    \u307E\u3059\u3002\n        discard\n\n    proc initWordsizeTree*(v: openArray[bool]):\
    \ WordsizeTreeAvx2 =\n        ## v[i]\u304C\u771F\u3067\u3042\u308B\u4F4D\u7F6E\
    i\u3092\u8981\u7D20\u3068\u3059\u308B\u30D3\u30C3\u30C8\u96C6\u5408\u6728\u3092\
    \u4F5C\u6210\u3057\u307E\u3059\u3002\n        assert v.len <= WordsizeTreeAvx2Capacity\n\
    \        if v.len > 0:\n            avxInit(unsafeAddr v[0], v.len.csize_t, addr\
    \ result.leaf[0],\n                addr result.middle[0], addr result.top[0])\n\
    \n    proc incl*(self: var WordsizeTreeAvx2, x: int) =\n        ## \u8981\u7D20\
    x\u3092\u8FFD\u52A0\u3057\u307E\u3059\u3002\n        assert x >= 0 and x < WordsizeTreeAvx2Capacity\n\
    \        avxIncl(addr self.leaf[0], addr self.middle[0], addr self.top[0], x.cuint)\n\
    \n    proc excl*(self: var WordsizeTreeAvx2, x: int) =\n        ## \u8981\u7D20\
    x\u3092\u524A\u9664\u3057\u307E\u3059\u3002\n        assert x >= 0 and x < WordsizeTreeAvx2Capacity\n\
    \        avxExcl(addr self.leaf[0], addr self.middle[0], addr self.top[0], x.cuint)\n\
    \n    proc `[]`*(self: var WordsizeTreeAvx2, x: int): bool =\n        ## \u8981\
    \u7D20x\u304C\u542B\u307E\u308C\u3066\u3044\u308B\u304B\u3092\u8FD4\u3057\u307E\
    \u3059\u3002\n        assert x >= 0 and x < WordsizeTreeAvx2Capacity\n       \
    \ (self.leaf[x shr 6] and (1'u64 shl (x and 63))) != 0\n\n    proc ge*(self: var\
    \ WordsizeTreeAvx2, x: int): int =\n        ## x\u4EE5\u4E0A\u306E\u6700\u5C0F\
    \u306E\u8981\u7D20\u3092\u8FD4\u3057\u3001\u5B58\u5728\u3057\u306A\u3051\u308C\
    \u3070-1\u3092\u8FD4\u3057\u307E\u3059\u3002\n        if x >= WordsizeTreeAvx2Capacity:\
    \ return -1\n        avxGe(addr self.leaf[0], addr self.middle[0], addr self.top[0],\
    \ max(x, 0).cuint).int\n\n    proc le*(self: var WordsizeTreeAvx2, x: int): int\
    \ =\n        ## x\u4EE5\u4E0B\u306E\u6700\u5927\u306E\u8981\u7D20\u3092\u8FD4\u3057\
    \u3001\u5B58\u5728\u3057\u306A\u3051\u308C\u3070-1\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\n        if x < 0: return -1\n        avxLe(addr self.leaf[0], addr self.middle[0],\
    \ addr self.top[0],\n            min(x, WordsizeTreeAvx2Capacity - 1).cuint).int\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/wordsizetree_avx2.nim
  requiredBy: []
  timestamp: '2026-09-08 05:12:42+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/wordsizetree_avx2_test.nim
  - verify/AI/wordsizetree_avx2_test.nim
documentation_of: cplib/collections/wordsizetree_avx2.nim
layout: document
redirect_from:
- /library/cplib/collections/wordsizetree_avx2.nim
- /library/cplib/collections/wordsizetree_avx2.nim.html
title: cplib/collections/wordsizetree_avx2.nim
---
