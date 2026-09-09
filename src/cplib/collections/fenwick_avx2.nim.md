---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/fenwick_tree_test.nim
    title: verify/AI/fenwick_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/fenwick_tree_test.nim
    title: verify/AI/fenwick_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/fenwick_tree_avx2_test.nim
    title: verify/collections/fenwick_tree_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/fenwick_tree_avx2_test.nim
    title: verify/collections/fenwick_tree_avx2_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_FENWICK_AVX2:\n    const CPLIB_COLLECTIONS_FENWICK_AVX2*\
    \ = 1\n    when not (defined(amd64) and (defined(gcc) or defined(clang))):\n \
    \       {.error: \"FenwickTreeAvx2 requires amd64 and GCC/Clang\".}\n\n    type\
    \ FenwickTreeAvx2* = object\n        size: int\n        height: int\n        offsets:\
    \ array[16, int]\n        data: seq[int]\n\n    {.emit: \"\"\"\n#include <immintrin.h>\n\
    #include <stddef.h>\n\nstatic NI cplib_fw16_sum(NI a, NI b) {\n    /* SIMD\u3068\
    \u540C\u3058\u6841\u3042\u3075\u308C\u52D5\u4F5C\u3092\u3001\u7B26\u53F7\u4ED8\
    \u304D\u6574\u6570\u306E\u672A\u5B9A\u7FA9\u52D5\u4F5C\u306A\u3057\u3067\u884C\
    \u3044\u307E\u3059\u3002 */\n    NI value;\n    __builtin_add_overflow(a, b, &value);\n\
    \    return value;\n}\nstatic NI cplib_fw16_diff(NI a, NI b) {\n    /* \u6E1B\u7B97\
    \u3082\u4E0B\u4F4D64bit\u3092\u4FDD\u6301\u3057\u307E\u3059\u3002 */\n    NI value;\n\
    \    __builtin_sub_overflow(a, b, &value);\n    return value;\n}\n\nstatic void\
    \ cplib_fw16_build(NI *data, const NI *offsets, NI height, NI n) {\n    /* \u4E0B\
    \u6BB5\u3092\u7D2F\u7A4D\u548C\u306B\u5909\u63DB\u3057\u306A\u304C\u3089\u3001\
    \u5B8C\u5168\u306A16\u8981\u7D20\u30D6\u30ED\u30C3\u30AF\u306E\u548C\u3092\u4E0A\
    \u6BB5\u3078\u6E21\u3057\u307E\u3059\u3002 */\n    for (NI h = 0; h < height;\
    \ ++h, n >>= 4) {\n        NI *base = data + offsets[h];\n        NI sum = 0;\n\
    \        for (NI i = 0; i <= n; ++i) {\n            if (!(i & 15)) {\n       \
    \         if (i) data[offsets[h + 1] + (i >> 4) - 1] = sum;\n                sum\
    \ = 0;\n            }\n            NI value = base[i];\n            base[i] =\
    \ sum;\n            sum = cplib_fw16_sum(sum, value);\n        }\n    }\n}\n\n\
    __attribute__((target(\"avx2\")))\nstatic void cplib_fw16_add(NI *data, const\
    \ NI *offsets,\n                           NI height, NI index, NI delta) {\n\
    \    /* \u5404\u6BB5\u306E16\u500B\u306E\u7D2F\u7A4D\u548C\u30924\u8981\u7D20\u305A\
    \u3064\u66F4\u65B0\u3057\u307E\u3059\u3002 */\n    const __m256i value = _mm256_set1_epi64x((long\
    \ long)delta);\n    for (NI h = 0; h < height; ++h, index >>= 4) {\n        NI\
    \ *base = data + offsets[h] + (index & ~(NI)15);\n        const __m256i pos =\
    \ _mm256_set1_epi64x(index & 15);\n        for (int k = 0; k < 16; k += 4) {\n\
    \            const __m256i mask = _mm256_cmpgt_epi64(\n                _mm256_setr_epi64x(k,\
    \ k + 1, k + 2, k + 3), pos);\n            __m256i *p = (__m256i *)(base + k);\n\
    \            _mm256_storeu_si256(p, _mm256_add_epi64(\n                _mm256_loadu_si256(p),\
    \ _mm256_and_si256(mask, value)));\n        }\n    }\n}\n\nstatic NI cplib_fw16_prefix(const\
    \ NI *data, const NI *offsets, NI r) {\n    /* \u5404\u6BB5\u304B\u30891\u500B\
    \u305A\u3064\u7D2F\u7A4D\u548C\u3092\u8AAD\u307F\u51FA\u3057\u307E\u3059\u3002\
    \ */\n    NI sum = 0;\n    for (NI h = 0; r; ++h, r >>= 4) sum = cplib_fw16_sum(sum,\
    \ data[offsets[h] + r]);\n    return sum;\n}\nstatic NI cplib_fw16_get(const NI\
    \ *data, const NI *offsets, NI l, NI r) {\n    /* \u5DE6\u53F3\u306E\u8AAD\u307F\
    \u51FA\u3057\u3092\u4E26\u5217\u5316\u3057\u3001\u540C\u3058\u7956\u5148\u306B\
    \u9054\u3057\u305F\u3089\u7D42\u4E86\u3057\u307E\u3059\u3002 */\n    NI sum =\
    \ 0;\n    for (NI h = 0; l != r; ++h, l >>= 4, r >>= 4)\n        sum = cplib_fw16_sum(sum,\
    \ cplib_fw16_diff(data[offsets[h] + r], data[offsets[h] + l]));\n    return sum;\n\
    }\n\n\"\"\".}\n\n    proc fw16Add(data: ptr int, offsets: ptr int, height, index:\
    \ int,\n            delta: int) {.importc: \"cplib_fw16_add\", nodecl.}\n    proc\
    \ fw16Build(data: ptr int, offsets: ptr int, height, n: int)\n        {.importc:\
    \ \"cplib_fw16_build\", nodecl.}\n    proc fw16Prefix(data: ptr int, offsets:\
    \ ptr int, r: int): int\n        {.importc: \"cplib_fw16_prefix\", nodecl.}\n\
    \    proc fw16Get(data: ptr int, offsets: ptr int, l, r: int): int\n        {.importc:\
    \ \"cplib_fw16_get\", nodecl.}\n\n    proc build(self: var FenwickTreeAvx2) =\n\
    \        ## \u521D\u671F\u5024\u3092\u683C\u7D0D\u6E08\u307F\u306E\u914D\u5217\
    \u304B\u3089\u3001\u5168\u6BB5\u306E\u7D2F\u7A4D\u548C\u3092O(n)\u3067\u69CB\u7BC9\
    \u3057\u307E\u3059\u3002\n        fw16Build(addr self.data[0], addr self.offsets[0],\
    \ self.height, self.size)\n\n    proc initFenwickTreeAvx2*(n: int): FenwickTreeAvx2\
    \ =\n        ## \u9577\u3055n\u306E\u96F6\u914D\u5217\u304B\u3089\u69CB\u7BC9\u3057\
    \u307E\u3059\u3002O(n)\u6642\u9593\u3001\u7D0416n/15\u500B\u306E64bit\u6574\u6570\
    \u3092\u4F7F\u3044\u307E\u3059\u3002\n        assert n >= 0\n        result.size\
    \ = n\n        var m = n\n        var size = 0\n        while true:\n        \
    \    result.offsets[result.height] = size\n            inc result.height\n   \
    \         size += (m + 16) and not 15\n            m = m shr 4\n            if\
    \ m == 0: break\n        result.data = newSeq[int](size + 15)\n        # \u30B3\
    \u30D4\u30FC\u5F8C\u3082\u6B63\u3057\u304F\u52D5\u4F5C\u3059\u308B\u3088\u3046\
    \u3001SIMD\u5074\u3067\u306F\u975E\u6574\u5217\u30ED\u30FC\u30C9\u3092\u4F7F\u3044\
    \u307E\u3059\u3002\n        let alignment = int((0'u - cast[uint](addr result.data[0]))\
    \ and 127) shr 3\n        for h in 0..<result.height:\n            result.offsets[h]\
    \ += alignment\n\n    proc initFenwickTreeAvx2*(values: openArray[int]): FenwickTreeAvx2\
    \ =\n        ## int\u914D\u5217\u304B\u3089O(n)\u6642\u9593\u30FB\u9818\u57DF\u3067\
    \u69CB\u7BC9\u3057\u307E\u3059\u3002\n        result = initFenwickTreeAvx2(values.len)\n\
    \        if values.len > 0:\n            copyMem(addr result.data[result.offsets[0]],\
    \ unsafeAddr values[0],\n                values.len * sizeof(int))\n        result.build()\n\
    \n    proc len*(self: FenwickTreeAvx2): int {.inline.} =\n        ## \u8981\u7D20\
    \u6570\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.size\n\n  \
    \  proc add*(self: var FenwickTreeAvx2, p: int, delta: int) =\n        ## a[p]\u306B\
    delta\u3092\u52A0\u3048\u307E\u3059\u3002O(log_16 n)\u56DE\u306ESIMD\u66F4\u65B0\
    \u3092\u884C\u3044\u307E\u3059\u3002\n        assert 0 <= p and p < self.size\n\
    \        fw16Add(addr self.data[0], addr self.offsets[0], self.height, p, delta)\n\
    \n    proc prefix*(self: FenwickTreeAvx2, r: int): int =\n        ## [0, r)\u306E\
    \u548C\u3092int\u3068\u3057\u3066O(log_16 n)\u3067\u8FD4\u3057\u307E\u3059\u3002\
    \n        assert 0 <= r and r <= self.size\n        if r == 0: return 0\n    \
    \    fw16Prefix(unsafeAddr self.data[0], unsafeAddr self.offsets[0], r)\n\n  \
    \  proc get*(self: FenwickTreeAvx2, l, r: int): int =\n        ## [l, r)\u306E\
    \u548C\u3092int\u3068\u3057\u3066O(log_16 n)\u3067\u8FD4\u3057\u307E\u3059\u3002\
    \n        assert 0 <= l and l <= r and r <= self.size\n        if l == r: return\
    \ 0\n        fw16Get(unsafeAddr self.data[0], unsafeAddr self.offsets[0], l, r)\n\
    \n    proc `[]`*(self: FenwickTreeAvx2, segment: HSlice[int, int]): int {.inline.}\
    \ =\n        ## \u30B9\u30E9\u30A4\u30B9\u306E\u548C\u3092O(log_16 n)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\n        self.get(segment.a, segment.b + 1)\n\n    proc\
    \ `[]`*(self: FenwickTreeAvx2, p: int): int {.inline.} =\n        ## a[p]\u3092\
    O(log_16 n)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.get(p, p + 1)\n\n\
    \    proc `[]=`*(self: var FenwickTreeAvx2, p: int, value: int) {.inline.} =\n\
    \        ## a[p]\u3092value\u306B\u5909\u66F4\u3057\u307E\u3059\u3002O(log_16\
    \ n)\u3067\u3059\u3002\n        self.add(p, value -% self.get(p, p + 1))\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/fenwick_avx2.nim
  requiredBy: []
  timestamp: '2026-09-09 00:25:17+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/fenwick_tree_avx2_test.nim
  - verify/collections/fenwick_tree_avx2_test.nim
  - verify/AI/fenwick_tree_test.nim
  - verify/AI/fenwick_tree_test.nim
documentation_of: cplib/collections/fenwick_avx2.nim
layout: document
redirect_from:
- /library/cplib/collections/fenwick_avx2.nim
- /library/cplib/collections/fenwick_avx2.nim.html
title: cplib/collections/fenwick_avx2.nim
---
