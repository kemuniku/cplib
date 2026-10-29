---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/hamming_distance_test.nim
    title: verify/str/hamming_distance_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hamming_distance_test.nim
    title: verify/str/hamming_distance_test.nim
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
  code: "## \u5404\u30D0\u30A4\u30C8\u30921\u6587\u5B57\u3068\u3059\u308B\u30CF\u30DF\
    \u30F3\u30B0\u8DDD\u96E2\u3002\u5165\u529B\u306F\u540C\u3058\u9577\u3055\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n## x86\u306EGCC/Clang\u3067\
    \u306FAVX-512BW\u3001AVX2\u3001\u901A\u5E38\u30EB\u30FC\u30D7\u306E\u9806\u306B\
    \u5B9F\u884C\u6642\u306B\u9078\u629E\u3057\u307E\u3059\u3002\n## -d:hammingDistanceScalar\u3067\
    \u901A\u5E38\u7248\u3001-d:hammingDistanceAvx2\u3067AVX-512\u3092\u7121\u52B9\u306B\
    \u3067\u304D\u307E\u3059\u3002\n## nim c / nim cpp\u306B\u5BFE\u5FDC\u3057\u3001\
    \u5168\u4F53\u3078\u306E-mavx512bw\u306A\u3069\u306E\u6307\u5B9A\u306F\u4E0D\u8981\
    \u3067\u3059\u3002\nwhen not declared CPLIB_STR_HAMMING_DISTANCE:\n    const CPLIB_STR_HAMMING_DISTANCE*\
    \ = 1\n\n    when (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang))\
    \ and not defined(hammingDistanceScalar):\n        {.emit: \"\"\"\n#include <immintrin.h>\n\
    #include <stdint.h>\n#include <stddef.h>\n#ifdef __cplusplus\nextern \"C\" {\n\
    #endif\n\n__attribute__((target(\"avx2,popcnt\")))\nstatic size_t cplib_hamming_avx2(const\
    \ unsigned char *s, const unsigned char *t, size_t n) {\n    /* 32\u30D0\u30A4\
    \u30C8\u305A\u3064\u6BD4\u8F03\u3057\u3001\u4E0D\u4E00\u81F4\u6570\u3092\u52A0\
    \u7B97\u3059\u308B\u3002O(n)\u3002 */\n    size_t i = 0, count = 0;\n    for (;\
    \ n - i >= 32; i += 32) {\n        __m256i a = _mm256_loadu_si256((const __m256i\
    \ *)(s + i));\n        __m256i b = _mm256_loadu_si256((const __m256i *)(t + i));\n\
    \        unsigned int mask = (unsigned int)_mm256_movemask_epi8(_mm256_cmpeq_epi8(a,\
    \ b));\n        count += 32 - __builtin_popcount(mask);\n    }\n    for (; i <\
    \ n; ++i) count += s[i] != t[i];\n    return count;\n}\n\n__attribute__((target(\"\
    avx512f,avx512bw,popcnt\")))\nstatic size_t cplib_hamming_avx512(const unsigned\
    \ char *s, const unsigned char *t, size_t n) {\n    /* 64\u30D0\u30A4\u30C8\u305A\
    \u3064\u6BD4\u8F03\u3057\u3001\u7AEF\u6570\u306F\u30DE\u30B9\u30AF\u4ED8\u304D\
    \u30ED\u30FC\u30C9\u3067\u7BC4\u56F2\u5185\u3060\u3051\u8AAD\u3080\u3002O(n)\u3002\
    \ */\n    size_t i = 0, count = 0;\n    for (; n - i >= 64; i += 64) {\n     \
    \   __m512i a = _mm512_loadu_si512((const void *)(s + i));\n        __m512i b\
    \ = _mm512_loadu_si512((const void *)(t + i));\n        count += __builtin_popcountll((unsigned\
    \ long long)_mm512_cmpneq_epi8_mask(a, b));\n    }\n    if (i < n) {\n       \
    \ __mmask64 valid = (__mmask64)((UINT64_C(1) << (n - i)) - 1);\n        __m512i\
    \ a = _mm512_maskz_loadu_epi8(valid, (const void *)(s + i));\n        __m512i\
    \ b = _mm512_maskz_loadu_epi8(valid, (const void *)(t + i));\n        count +=\
    \ __builtin_popcountll((unsigned long long)(_mm512_cmpneq_epi8_mask(a, b) & valid));\n\
    \    }\n    return count;\n}\n\nsize_t cplib_hamming_distance(void *ss, void *tt,\
    \ size_t n, int avx512) {\n    /* CPU\u3068OS\u304C\u5BFE\u5FDC\u3059\u308B\u547D\
    \u4EE4\u30BB\u30C3\u30C8\u3067\u8DDD\u96E2\u3092\u6C42\u3081\u308B\u3002O(n)\u3002\
    \ */\n    const unsigned char *s = (const unsigned char *)ss;\n    const unsigned\
    \ char *t = (const unsigned char *)tt;\n    if (__builtin_cpu_supports(\"popcnt\"\
    )) {\n        if (avx512 && n >= 64 && __builtin_cpu_supports(\"avx512f\") &&\
    \ __builtin_cpu_supports(\"avx512bw\"))\n            return cplib_hamming_avx512(s,\
    \ t, n);\n        if (__builtin_cpu_supports(\"avx2\"))\n            return cplib_hamming_avx2(s,\
    \ t, n);\n    }\n    size_t count = 0;\n    for (size_t i = 0; i < n; ++i) count\
    \ += s[i] != t[i];\n    return count;\n}\n#ifdef __cplusplus\n}\n#endif\n\"\"\"\
    .}\n        proc hammingDistanceRaw(s, t: pointer, n: csize_t, avx512: cint):\
    \ csize_t\n            {.importc: \"cplib_hamming_distance\".}\n\n    proc hammingDistance*(s,\
    \ t: openArray[char]): int {.inline.} =\n        ## \u30D0\u30A4\u30C8\u5358\u4F4D\
    \u306E\u30CF\u30DF\u30F3\u30B0\u8DDD\u96E2\u3092\u6642\u9593O(N)\u3001\u8FFD\u52A0\
    \u7A7A\u9593O(1)\u3067\u8FD4\u3059\u3002\u9577\u3055\u306E\u4E0D\u4E00\u81F4\u306F\
    ValueError\u3002\n        if s.len != t.len:\n            raise newException(ValueError,\
    \ \"\u6587\u5B57\u5217\u306E\u9577\u3055\u304C\u4E00\u81F4\u3057\u307E\u305B\u3093\
    \")\n        when (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang))\
    \ and not defined(hammingDistanceScalar):\n            if s.len >= 32:\n     \
    \           return int(hammingDistanceRaw(unsafeAddr s[0], unsafeAddr t[0],\n\
    \                    csize_t(s.len), cint(not defined(hammingDistanceAvx2))))\n\
    \        for i in 0..<s.len:\n            result += int(s[i] != t[i])\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/hamming_distance.nim
  requiredBy: []
  timestamp: '2026-10-19 01:28:08+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/hamming_distance_test.nim
  - verify/str/hamming_distance_test.nim
documentation_of: cplib/str/hamming_distance.nim
layout: document
redirect_from:
- /library/cplib/str/hamming_distance.nim
- /library/cplib/str/hamming_distance.nim.html
title: cplib/str/hamming_distance.nim
---
