---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/avx512utils_test.nim
    title: verify/AI/avx512utils_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/avx512utils_test.nim
    title: verify/AI/avx512utils_test.nim
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
  code: "## \u6574\u6570\u914D\u5217\u306E\u8981\u7D20\u3054\u3068\u306E\u52A0\u6E1B\
    \u7B97\u30FBmin/max\u30FBAND/OR/XOR\u3068\u3001\u5168\u4F53\u306Emin/max\u3002\
    \n## int/uint\u304A\u3088\u30738\u30FB16\u30FB32\u30FB64bit\u6574\u6570\u306B\u5BFE\
    \u5FDC\u3057\u3001\u52A0\u6E1B\u7B97\u306F\u30D3\u30C3\u30C8\u5E45\u3067\u6298\
    \u308A\u8FD4\u3059\u3002\n## array\u5165\u529B\u306E2\u5F15\u6570\u7248\u306F\
    array\u3001openArray/seq\u5165\u529B\u306F\u65B0\u3057\u3044seq\u3092\u8FD4\u3059\
    \u3002\n## 3\u5F15\u6570\u7248\u306Fdst\u3092\u518D\u5229\u7528\u3059\u308B\u3002\
    \u5165\u529B\u3068dst\u306F\u5B8C\u5168\u306B\u540C\u3058\u9818\u57DF\u3067\u3082\
    \u3088\u3044\u304C\u3001\n## \u958B\u59CB\u4F4D\u7F6E\u306E\u7570\u306A\u308B\u90E8\
    \u5206\u7684\u306A\u91CD\u306A\u308A\u306F\u4E0D\u53EF\u3002\u9577\u3055\u306E\
    \u4E0D\u4E00\u81F4\u3068\u7A7A\u5217\u306E\u96C6\u7D04\u306FValueError\u3002\n\
    ## x86\u306EGCC/Clang\u3067\u306F\u5B9F\u884C\u6642\u306BAVX-512F\uFF088/16bit\u306F\
    BW\u3082\uFF09\u3092\u78BA\u8A8D\u3059\u308B\u3002\n## \u975E\u5BFE\u5FDC\u74B0\
    \u5883\u3068-d:avx512utilsScalar\u6307\u5B9A\u6642\u306F\u901A\u5E38\u306E\u30EB\
    \u30FC\u30D7\u306B\u5207\u308A\u66FF\u3048\u308B\u3002\n## nim c / nim cpp\u306B\
    \u5BFE\u5FDC\u3002-mavx512f\u306A\u3069\u3092\u30D7\u30ED\u30B0\u30E9\u30E0\u5168\
    \u4F53\u306B\u6307\u5B9A\u3059\u308B\u5FC5\u8981\u306F\u306A\u3044\u3002\n\nwhen\
    \ not declared CPLIB_UTILS_AVX512UTILS:\n    const CPLIB_UTILS_AVX512UTILS* =\
    \ 1\n\n    type Avx512Integer* = int8 | uint8 | int16 | uint16 | int32 | uint32\
    \ | int64 | uint64 | int | uint\n\n    when (defined(amd64) or defined(i386))\
    \ and (defined(gcc) or defined(clang)) and not defined(avx512utilsScalar):\n \
    \       const avx512utilsNative = true\n        {.emit: \"\"\"\n#include <immintrin.h>\n\
    #include <stdint.h>\n#include <stddef.h>\n#include <string.h>\n#ifdef __cplusplus\n\
    extern \"C\" {\n#endif\n\nint cplib_avx512_available(int bytes) {\n    // OS\u306E\
    \u30EC\u30B8\u30B9\u30BF\u4FDD\u5B58\u5BFE\u5FDC\u3082\u542B\u3081\u3001\u5FC5\
    \u8981\u306A\u547D\u4EE4\u30BB\u30C3\u30C8\u3092\u78BA\u8A8D\u3059\u308B\u3002\
    O(1)\u3002\n    return __builtin_cpu_supports(\"avx512f\") &&\n        (bytes\
    \ >= 4 || __builtin_cpu_supports(\"avx512bw\"));\n}\n\n#define CPLIB_AVX_BINARY_CASE(T,\
    \ BITS, OP, EXPR) \\\n    case OP: \\\n        for (; i + lanes <= n; i += lanes)\
    \ { \\\n            __m512i x = _mm512_loadu_si512((const void*)(a + i * sizeof(T)));\
    \ \\\n            __m512i y = _mm512_loadu_si512((const void*)(b + i * sizeof(T)));\
    \ \\\n            _mm512_storeu_si512((void*)(d + i * sizeof(T)), EXPR); \\\n\
    \        } \\\n        if (i < n) { \\\n            uint64_t mask = UINT64_MAX\
    \ >> (64 - (n - i)); \\\n            __m512i x = _mm512_maskz_loadu_epi##BITS(mask,\
    \ (const void*)(a + i * sizeof(T))); \\\n            __m512i y = _mm512_maskz_loadu_epi##BITS(mask,\
    \ (const void*)(b + i * sizeof(T))); \\\n            _mm512_mask_storeu_epi##BITS((void*)(d\
    \ + i * sizeof(T)), mask, EXPR); \\\n        } \\\n        break;\n\n#define CPLIB_AVX_KERNEL(NAME,\
    \ T, BITS, SUFFIX, TARGET) \\\n__attribute__((target(TARGET))) \\\nvoid cplib_avx512_##NAME(void\
    \ *aa, void *bb, void *dd, size_t n, int op) { \\\n    /* \u540C\u3058\u4F4D\u7F6E\
    \u306E\u6574\u6570\u6F14\u7B97\u3092\u884C\u3044\u3001\u7AEF\u6570\u306F\u30DE\
    \u30B9\u30AF\u4ED8\u304D\u547D\u4EE4\u3067\u51E6\u7406\u3059\u308B\u3002O(n)\u3002\
    \ */ \\\n    const unsigned char *a = (const unsigned char*)aa, *b = (const unsigned\
    \ char*)bb; \\\n    unsigned char *d = (unsigned char*)dd; \\\n    const size_t\
    \ lanes = 64 / sizeof(T); \\\n    size_t i = 0; \\\n    switch (op) { \\\n   \
    \     CPLIB_AVX_BINARY_CASE(T, BITS, 0, _mm512_add_epi##BITS(x, y)) \\\n     \
    \   CPLIB_AVX_BINARY_CASE(T, BITS, 1, _mm512_sub_epi##BITS(x, y)) \\\n       \
    \ CPLIB_AVX_BINARY_CASE(T, BITS, 2, _mm512_min_##SUFFIX(x, y)) \\\n        CPLIB_AVX_BINARY_CASE(T,\
    \ BITS, 3, _mm512_max_##SUFFIX(x, y)) \\\n        CPLIB_AVX_BINARY_CASE(T, BITS,\
    \ 4, _mm512_and_si512(x, y)) \\\n        CPLIB_AVX_BINARY_CASE(T, BITS, 5, _mm512_or_si512(x,\
    \ y)) \\\n        CPLIB_AVX_BINARY_CASE(T, BITS, 6, _mm512_xor_si512(x, y)) \\\
    \n    } \\\n} \\\n__attribute__((target(TARGET))) \\\nvoid cplib_avx512_reduce_##NAME(void\
    \ *aa, void *dd, size_t n, int maximum) { \\\n    /* \u8907\u6570\u30EC\u30FC\u30F3\
    \u306Emin/max\u3092\u96C6\u7D04\u3059\u308B\u3002n>0\u3001O(n)\u3002 */ \\\n \
    \   const unsigned char *a = (const unsigned char*)aa; \\\n    const size_t lanes\
    \ = 64 / sizeof(T); \\\n    size_t i = 0; T best; memcpy(&best, a, sizeof(T));\
    \ \\\n    if (n >= lanes) { \\\n        __m512i v = _mm512_loadu_si512((const\
    \ void*)a); \\\n        i = lanes; \\\n        if (maximum) { \\\n           \
    \ for (; i + lanes <= n; i += lanes) \\\n                v = _mm512_max_##SUFFIX(v,\
    \ _mm512_loadu_si512((const void*)(a + i * sizeof(T)))); \\\n        } else {\
    \ \\\n            for (; i + lanes <= n; i += lanes) \\\n                v = _mm512_min_##SUFFIX(v,\
    \ _mm512_loadu_si512((const void*)(a + i * sizeof(T)))); \\\n        } \\\n  \
    \      T values[64 / sizeof(T)]; _mm512_storeu_si512((void*)values, v); \\\n \
    \       for (size_t j = 0; j < lanes; ++j) \\\n            if (maximum ? values[j]\
    \ > best : values[j] < best) best = values[j]; \\\n    } \\\n    for (; i < n;\
    \ ++i) { \\\n        T x; memcpy(&x, a + i * sizeof(T), sizeof(T)); \\\n     \
    \   if (maximum ? x > best : x < best) best = x; \\\n    } \\\n    memcpy(dd,\
    \ &best, sizeof(T)); \\\n}\nCPLIB_AVX_KERNEL(i8, int8_t, 8, epi8, \"avx512f,avx512bw\"\
    )\nCPLIB_AVX_KERNEL(u8, uint8_t, 8, epu8, \"avx512f,avx512bw\")\nCPLIB_AVX_KERNEL(i16,\
    \ int16_t, 16, epi16, \"avx512f,avx512bw\")\nCPLIB_AVX_KERNEL(u16, uint16_t, 16,\
    \ epu16, \"avx512f,avx512bw\")\nCPLIB_AVX_KERNEL(i32, int32_t, 32, epi32, \"avx512f\"\
    )\nCPLIB_AVX_KERNEL(u32, uint32_t, 32, epu32, \"avx512f\")\nCPLIB_AVX_KERNEL(i64,\
    \ int64_t, 64, epi64, \"avx512f\")\nCPLIB_AVX_KERNEL(u64, uint64_t, 64, epu64,\
    \ \"avx512f\")\n#undef CPLIB_AVX_KERNEL\n#undef CPLIB_AVX_BINARY_CASE\n#ifdef\
    \ __cplusplus\n}\n#endif\n\"\"\".}\n        proc nativeAvailable(bytes: cint):\
    \ cint {.importc: \"cplib_avx512_available\".}\n        proc binaryi8(a, b, dst:\
    \ pointer, n: csize_t, op: cint) {.importc: \"cplib_avx512_i8\".}\n        proc\
    \ reducei8(a, dst: pointer, n: csize_t, maximum: cint) {.importc: \"cplib_avx512_reduce_i8\"\
    .}\n        proc binaryu8(a, b, dst: pointer, n: csize_t, op: cint) {.importc:\
    \ \"cplib_avx512_u8\".}\n        proc reduceu8(a, dst: pointer, n: csize_t, maximum:\
    \ cint) {.importc: \"cplib_avx512_reduce_u8\".}\n        proc binaryi16(a, b,\
    \ dst: pointer, n: csize_t, op: cint) {.importc: \"cplib_avx512_i16\".}\n    \
    \    proc reducei16(a, dst: pointer, n: csize_t, maximum: cint) {.importc: \"\
    cplib_avx512_reduce_i16\".}\n        proc binaryu16(a, b, dst: pointer, n: csize_t,\
    \ op: cint) {.importc: \"cplib_avx512_u16\".}\n        proc reduceu16(a, dst:\
    \ pointer, n: csize_t, maximum: cint) {.importc: \"cplib_avx512_reduce_u16\".}\n\
    \        proc binaryi32(a, b, dst: pointer, n: csize_t, op: cint) {.importc: \"\
    cplib_avx512_i32\".}\n        proc reducei32(a, dst: pointer, n: csize_t, maximum:\
    \ cint) {.importc: \"cplib_avx512_reduce_i32\".}\n        proc binaryu32(a, b,\
    \ dst: pointer, n: csize_t, op: cint) {.importc: \"cplib_avx512_u32\".}\n    \
    \    proc reduceu32(a, dst: pointer, n: csize_t, maximum: cint) {.importc: \"\
    cplib_avx512_reduce_u32\".}\n        proc binaryi64(a, b, dst: pointer, n: csize_t,\
    \ op: cint) {.importc: \"cplib_avx512_i64\".}\n        proc reducei64(a, dst:\
    \ pointer, n: csize_t, maximum: cint) {.importc: \"cplib_avx512_reduce_i64\".}\n\
    \        proc binaryu64(a, b, dst: pointer, n: csize_t, op: cint) {.importc: \"\
    cplib_avx512_u64\".}\n        proc reduceu64(a, dst: pointer, n: csize_t, maximum:\
    \ cint) {.importc: \"cplib_avx512_reduce_u64\".}\n    else:\n        const avx512utilsNative\
    \ = false\n\n    proc avx512Available*[T: Avx512Integer](): bool {.inline.} =\n\
    \        ## \u578BT\u306B\u5FC5\u8981\u306AAVX-512\u3068OS\u306E\u5BFE\u5FDC\u72B6\
    \u6CC1\u3092\u8FD4\u3059\u3002O(1)\u3002\n        when avx512utilsNative:\n  \
    \          nativeAvailable(cint(sizeof(T))) != 0\n        else:\n            false\n\
    \n    template scalarBinary(x, y: typed, op: static[int]): untyped =\n       \
    \ when op == 0:\n            when x is SomeUnsignedInt: x + y\n            else:\
    \ x +% y\n        elif op == 1:\n            when x is SomeUnsignedInt: x - y\n\
    \            else: x -% y\n        elif op == 2: min(x, y)\n        elif op ==\
    \ 3: max(x, y)\n        elif op == 4: x and y\n        elif op == 5: x or y\n\
    \        else: x xor y\n\n    proc binaryImpl[T: Avx512Integer](a, b: openArray[T],\
    \ dst: var openArray[T], op: static[int]) {.inline.} =\n        ## \u9577\u3055\
    \u3092\u691C\u67FB\u3057\u3001SIMD\u307E\u305F\u306F\u901A\u5E38\u306E\u30EB\u30FC\
    \u30D7\u3067\u6F14\u7B97\u3059\u308B\u3002O(n)\u3002\n        if a.len != b.len\
    \ or a.len != dst.len:\n            raise newException(ValueError, \"\u5165\u529B\
    \u3068\u51FA\u529B\u306E\u9577\u3055\u304C\u4E00\u81F4\u3057\u3066\u3044\u307E\
    \u305B\u3093\")\n        if a.len == 0: return\n        when avx512utilsNative:\n\
    \            if avx512Available[T]():\n                when sizeof(T) == 1:\n\
    \                    when T is SomeUnsignedInt:\n                        binaryu8(unsafeAddr\
    \ a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))\n            \
    \        else:\n                        binaryi8(unsafeAddr a[0], unsafeAddr b[0],\
    \ addr dst[0], csize_t(a.len), cint(op))\n                elif sizeof(T) == 2:\n\
    \                    when T is SomeUnsignedInt:\n                        binaryu16(unsafeAddr\
    \ a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))\n            \
    \        else:\n                        binaryi16(unsafeAddr a[0], unsafeAddr\
    \ b[0], addr dst[0], csize_t(a.len), cint(op))\n                elif sizeof(T)\
    \ == 4:\n                    when T is SomeUnsignedInt:\n                    \
    \    binaryu32(unsafeAddr a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len),\
    \ cint(op))\n                    else:\n                        binaryi32(unsafeAddr\
    \ a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))\n            \
    \    elif sizeof(T) == 8:\n                    when T is SomeUnsignedInt:\n  \
    \                      binaryu64(unsafeAddr a[0], unsafeAddr b[0], addr dst[0],\
    \ csize_t(a.len), cint(op))\n                    else:\n                     \
    \   binaryi64(unsafeAddr a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))\n\
    \                return\n        for i in 0..<a.len:\n            dst[i] = scalarBinary(a[i],\
    \ b[i], op)\n\n    proc reduceImpl[T: Avx512Integer](a: openArray[T], maximum:\
    \ static[bool]): T {.inline.} =\n        ## \u7A7A\u5217\u3092\u62D2\u5426\u3057\
    \u3001\u5168\u4F53\u306Emin/max\u3092\u6C42\u3081\u308B\u3002O(n)\u3002\n    \
    \    if a.len == 0:\n            raise newException(ValueError, \"\u7A7A\u5217\
    \u306E\u6700\u5C0F\u5024\u30FB\u6700\u5927\u5024\u306F\u6C42\u3081\u3089\u308C\
    \u307E\u305B\u3093\")\n        when avx512utilsNative:\n            if avx512Available[T]():\n\
    \                when sizeof(T) == 1:\n                    when T is SomeUnsignedInt:\n\
    \                        reduceu8(unsafeAddr a[0], addr result, csize_t(a.len),\
    \ cint(maximum))\n                    else:\n                        reducei8(unsafeAddr\
    \ a[0], addr result, csize_t(a.len), cint(maximum))\n                elif sizeof(T)\
    \ == 2:\n                    when T is SomeUnsignedInt:\n                    \
    \    reduceu16(unsafeAddr a[0], addr result, csize_t(a.len), cint(maximum))\n\
    \                    else:\n                        reducei16(unsafeAddr a[0],\
    \ addr result, csize_t(a.len), cint(maximum))\n                elif sizeof(T)\
    \ == 4:\n                    when T is SomeUnsignedInt:\n                    \
    \    reduceu32(unsafeAddr a[0], addr result, csize_t(a.len), cint(maximum))\n\
    \                    else:\n                        reducei32(unsafeAddr a[0],\
    \ addr result, csize_t(a.len), cint(maximum))\n                elif sizeof(T)\
    \ == 8:\n                    when T is SomeUnsignedInt:\n                    \
    \    reduceu64(unsafeAddr a[0], addr result, csize_t(a.len), cint(maximum))\n\
    \                    else:\n                        reducei64(unsafeAddr a[0],\
    \ addr result, csize_t(a.len), cint(maximum))\n                return\n      \
    \  result = a[0]\n        for i in 1..<a.len:\n            when maximum: result\
    \ = max(result, a[i])\n            else: result = min(result, a[i])\n\n    proc\
    \ avx512Add*[T: Avx512Integer](a, b: openArray[T], dst: var openArray[T]) {.inline.}\
    \ =\n        ## \u5404\u8981\u7D20\u306E\u52A0\u7B97\u3092dst\u306B\u683C\u7D0D\
    \u3059\u308B\u3002O(n)\u3001\u8FFD\u52A0\u9818\u57DFO(1)\u3002\u5B8C\u5168\u306A\
    \u540C\u4E00\u9818\u57DF\u3078\u306E\u4E0A\u66F8\u304D\u3082\u53EF\u80FD\u3002\
    \n        binaryImpl(a, b, dst, 0)\n\n    proc avx512Add*[T: Avx512Integer](a,\
    \ b: openArray[T]): seq[T] =\n        ## \u5404\u8981\u7D20\u306E\u52A0\u7B97\u3092\
    \u65B0\u3057\u3044seq\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\
    \u57DFO(n)\u3002\n        if a.len != b.len:\n            raise newException(ValueError,\
    \ \"\u5165\u529B\u306E\u9577\u3055\u304C\u4E00\u81F4\u3057\u3066\u3044\u307E\u305B\
    \u3093\")\n        result = newSeq[T](a.len)\n        binaryImpl(a, b, result,\
    \ 0)\n\n    proc avx512Add*[I; T: Avx512Integer](a, b: array[I, T]): array[I,\
    \ T] =\n        ## \u5404\u8981\u7D20\u306E\u52A0\u7B97\u3092\u540C\u3058\u578B\
    \u306Earray\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DF\
    O(n)\u3002\n        binaryImpl(a, b, result, 0)\n\n    proc avx512Sub*[T: Avx512Integer](a,\
    \ b: openArray[T], dst: var openArray[T]) {.inline.} =\n        ## \u5404\u8981\
    \u7D20\u306E\u6E1B\u7B97\u3092dst\u306B\u683C\u7D0D\u3059\u308B\u3002O(n)\u3001\
    \u8FFD\u52A0\u9818\u57DFO(1)\u3002\u5B8C\u5168\u306A\u540C\u4E00\u9818\u57DF\u3078\
    \u306E\u4E0A\u66F8\u304D\u3082\u53EF\u80FD\u3002\n        binaryImpl(a, b, dst,\
    \ 1)\n\n    proc avx512Sub*[T: Avx512Integer](a, b: openArray[T]): seq[T] =\n\
    \        ## \u5404\u8981\u7D20\u306E\u6E1B\u7B97\u3092\u65B0\u3057\u3044seq\u3067\
    \u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(n)\u3002\n     \
    \   if a.len != b.len:\n            raise newException(ValueError, \"\u5165\u529B\
    \u306E\u9577\u3055\u304C\u4E00\u81F4\u3057\u3066\u3044\u307E\u305B\u3093\")\n\
    \        result = newSeq[T](a.len)\n        binaryImpl(a, b, result, 1)\n\n  \
    \  proc avx512Sub*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =\n  \
    \      ## \u5404\u8981\u7D20\u306E\u6E1B\u7B97\u3092\u540C\u3058\u578B\u306Earray\u3067\
    \u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(n)\u3002\n     \
    \   binaryImpl(a, b, result, 1)\n\n    proc avx512Min*[T: Avx512Integer](a, b:\
    \ openArray[T], dst: var openArray[T]) {.inline.} =\n        ## \u5404\u8981\u7D20\
    \u306E\u6700\u5C0F\u5024\u3092dst\u306B\u683C\u7D0D\u3059\u308B\u3002O(n)\u3001\
    \u8FFD\u52A0\u9818\u57DFO(1)\u3002\u5B8C\u5168\u306A\u540C\u4E00\u9818\u57DF\u3078\
    \u306E\u4E0A\u66F8\u304D\u3082\u53EF\u80FD\u3002\n        binaryImpl(a, b, dst,\
    \ 2)\n\n    proc avx512Min*[T: Avx512Integer](a, b: openArray[T]): seq[T] =\n\
    \        ## \u5404\u8981\u7D20\u306E\u6700\u5C0F\u5024\u3092\u65B0\u3057\u3044\
    seq\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(n)\u3002\
    \n        if a.len != b.len:\n            raise newException(ValueError, \"\u5165\
    \u529B\u306E\u9577\u3055\u304C\u4E00\u81F4\u3057\u3066\u3044\u307E\u305B\u3093\
    \")\n        result = newSeq[T](a.len)\n        binaryImpl(a, b, result, 2)\n\n\
    \    proc avx512Min*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =\n\
    \        ## \u5404\u8981\u7D20\u306E\u6700\u5C0F\u5024\u3092\u540C\u3058\u578B\
    \u306Earray\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DF\
    O(n)\u3002\n        binaryImpl(a, b, result, 2)\n\n    proc avx512Max*[T: Avx512Integer](a,\
    \ b: openArray[T], dst: var openArray[T]) {.inline.} =\n        ## \u5404\u8981\
    \u7D20\u306E\u6700\u5927\u5024\u3092dst\u306B\u683C\u7D0D\u3059\u308B\u3002O(n)\u3001\
    \u8FFD\u52A0\u9818\u57DFO(1)\u3002\u5B8C\u5168\u306A\u540C\u4E00\u9818\u57DF\u3078\
    \u306E\u4E0A\u66F8\u304D\u3082\u53EF\u80FD\u3002\n        binaryImpl(a, b, dst,\
    \ 3)\n\n    proc avx512Max*[T: Avx512Integer](a, b: openArray[T]): seq[T] =\n\
    \        ## \u5404\u8981\u7D20\u306E\u6700\u5927\u5024\u3092\u65B0\u3057\u3044\
    seq\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(n)\u3002\
    \n        if a.len != b.len:\n            raise newException(ValueError, \"\u5165\
    \u529B\u306E\u9577\u3055\u304C\u4E00\u81F4\u3057\u3066\u3044\u307E\u305B\u3093\
    \")\n        result = newSeq[T](a.len)\n        binaryImpl(a, b, result, 3)\n\n\
    \    proc avx512Max*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =\n\
    \        ## \u5404\u8981\u7D20\u306E\u6700\u5927\u5024\u3092\u540C\u3058\u578B\
    \u306Earray\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DF\
    O(n)\u3002\n        binaryImpl(a, b, result, 3)\n\n    proc avx512And*[T: Avx512Integer](a,\
    \ b: openArray[T], dst: var openArray[T]) {.inline.} =\n        ## \u5404\u8981\
    \u7D20\u306E\u30D3\u30C3\u30C8AND\u3092dst\u306B\u683C\u7D0D\u3059\u308B\u3002\
    O(n)\u3001\u8FFD\u52A0\u9818\u57DFO(1)\u3002\u5B8C\u5168\u306A\u540C\u4E00\u9818\
    \u57DF\u3078\u306E\u4E0A\u66F8\u304D\u3082\u53EF\u80FD\u3002\n        binaryImpl(a,\
    \ b, dst, 4)\n\n    proc avx512And*[T: Avx512Integer](a, b: openArray[T]): seq[T]\
    \ =\n        ## \u5404\u8981\u7D20\u306E\u30D3\u30C3\u30C8AND\u3092\u65B0\u3057\
    \u3044seq\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(n)\u3002\
    \n        if a.len != b.len:\n            raise newException(ValueError, \"\u5165\
    \u529B\u306E\u9577\u3055\u304C\u4E00\u81F4\u3057\u3066\u3044\u307E\u305B\u3093\
    \")\n        result = newSeq[T](a.len)\n        binaryImpl(a, b, result, 4)\n\n\
    \    proc avx512And*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =\n\
    \        ## \u5404\u8981\u7D20\u306E\u30D3\u30C3\u30C8AND\u3092\u540C\u3058\u578B\
    \u306Earray\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DF\
    O(n)\u3002\n        binaryImpl(a, b, result, 4)\n\n    proc avx512Or*[T: Avx512Integer](a,\
    \ b: openArray[T], dst: var openArray[T]) {.inline.} =\n        ## \u5404\u8981\
    \u7D20\u306E\u30D3\u30C3\u30C8OR\u3092dst\u306B\u683C\u7D0D\u3059\u308B\u3002\
    O(n)\u3001\u8FFD\u52A0\u9818\u57DFO(1)\u3002\u5B8C\u5168\u306A\u540C\u4E00\u9818\
    \u57DF\u3078\u306E\u4E0A\u66F8\u304D\u3082\u53EF\u80FD\u3002\n        binaryImpl(a,\
    \ b, dst, 5)\n\n    proc avx512Or*[T: Avx512Integer](a, b: openArray[T]): seq[T]\
    \ =\n        ## \u5404\u8981\u7D20\u306E\u30D3\u30C3\u30C8OR\u3092\u65B0\u3057\
    \u3044seq\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(n)\u3002\
    \n        if a.len != b.len:\n            raise newException(ValueError, \"\u5165\
    \u529B\u306E\u9577\u3055\u304C\u4E00\u81F4\u3057\u3066\u3044\u307E\u305B\u3093\
    \")\n        result = newSeq[T](a.len)\n        binaryImpl(a, b, result, 5)\n\n\
    \    proc avx512Or*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =\n \
    \       ## \u5404\u8981\u7D20\u306E\u30D3\u30C3\u30C8OR\u3092\u540C\u3058\u578B\
    \u306Earray\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DF\
    O(n)\u3002\n        binaryImpl(a, b, result, 5)\n\n    proc avx512Xor*[T: Avx512Integer](a,\
    \ b: openArray[T], dst: var openArray[T]) {.inline.} =\n        ## \u5404\u8981\
    \u7D20\u306E\u30D3\u30C3\u30C8XOR\u3092dst\u306B\u683C\u7D0D\u3059\u308B\u3002\
    O(n)\u3001\u8FFD\u52A0\u9818\u57DFO(1)\u3002\u5B8C\u5168\u306A\u540C\u4E00\u9818\
    \u57DF\u3078\u306E\u4E0A\u66F8\u304D\u3082\u53EF\u80FD\u3002\n        binaryImpl(a,\
    \ b, dst, 6)\n\n    proc avx512Xor*[T: Avx512Integer](a, b: openArray[T]): seq[T]\
    \ =\n        ## \u5404\u8981\u7D20\u306E\u30D3\u30C3\u30C8XOR\u3092\u65B0\u3057\
    \u3044seq\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DFO(n)\u3002\
    \n        if a.len != b.len:\n            raise newException(ValueError, \"\u5165\
    \u529B\u306E\u9577\u3055\u304C\u4E00\u81F4\u3057\u3066\u3044\u307E\u305B\u3093\
    \")\n        result = newSeq[T](a.len)\n        binaryImpl(a, b, result, 6)\n\n\
    \    proc avx512Xor*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =\n\
    \        ## \u5404\u8981\u7D20\u306E\u30D3\u30C3\u30C8XOR\u3092\u540C\u3058\u578B\
    \u306Earray\u3067\u8FD4\u3059\u3002\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DF\
    O(n)\u3002\n        binaryImpl(a, b, result, 6)\n\n    proc avx512Min*[T: Avx512Integer](a:\
    \ openArray[T]): T {.inline.} =\n        ## \u5168\u8981\u7D20\u306E\u6700\u5C0F\
    \u5024\u3092\u8FD4\u3059\u3002O(n)\u3001\u8FFD\u52A0\u9818\u57DFO(1)\u3002\u7A7A\
    \u5217\u306FValueError\u3002\n        reduceImpl(a, false)\n\n    proc avx512Max*[T:\
    \ Avx512Integer](a: openArray[T]): T {.inline.} =\n        ## \u5168\u8981\u7D20\
    \u306E\u6700\u5927\u5024\u3092\u8FD4\u3059\u3002O(n)\u3001\u8FFD\u52A0\u9818\u57DF\
    O(1)\u3002\u7A7A\u5217\u306FValueError\u3002\n        reduceImpl(a, true)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/avx512utils.nim
  requiredBy: []
  timestamp: '2026-09-23 01:31:49+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/avx512utils_test.nim
  - verify/AI/avx512utils_test.nim
documentation_of: cplib/utils/avx512utils.nim
layout: document
redirect_from:
- /library/cplib/utils/avx512utils.nim
- /library/cplib/utils/avx512utils.nim.html
title: cplib/utils/avx512utils.nim
---
