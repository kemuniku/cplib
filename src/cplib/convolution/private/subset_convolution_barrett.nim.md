---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/subset_convolution.nim
    title: cplib/convolution/subset_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/subset_convolution.nim
    title: cplib/convolution/subset_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/set_power_series/set_power_series.nim
    title: cplib/set_power_series/set_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/set_power_series/set_power_series.nim
    title: cplib/set_power_series/set_power_series.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/exp_of_set_power_series_test.nim
    title: verify/set_power_series/exp_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/exp_of_set_power_series_test.nim
    title: verify/set_power_series/exp_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/log_of_set_power_series_test.nim
    title: verify/set_power_series/log_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/log_of_set_power_series_test.nim
    title: verify/set_power_series/log_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/polynomial_composite_set_power_series_test.nim
    title: verify/set_power_series/polynomial_composite_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/polynomial_composite_set_power_series_test.nim
    title: verify/set_power_series/polynomial_composite_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/power_projection_of_set_power_series_test.nim
    title: verify/set_power_series/power_projection_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/power_projection_of_set_power_series_test.nim
    title: verify/set_power_series/power_projection_of_set_power_series_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/set_power_series_regression_test.nim
    title: verify/set_power_series/set_power_series_regression_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/set_power_series_regression_test.nim
    title: verify/set_power_series/set_power_series_regression_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/subset_convolution_regression_test.nim
    title: verify/set_power_series/subset_convolution_regression_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/subset_convolution_regression_test.nim
    title: verify/set_power_series/subset_convolution_regression_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/subset_convolution_test.nim
    title: verify/set_power_series/subset_convolution_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/subset_convolution_test.nim
    title: verify/set_power_series/subset_convolution_test.nim
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
  code: "when not declared CPLIB_CONVOLUTION_PRIVATE_SUBSET_CONVOLUTION_BARRETT:\n\
    \    const CPLIB_CONVOLUTION_PRIVATE_SUBSET_CONVOLUTION_BARRETT* = 1\n    import\
    \ bitops\n    import cplib/modint/modint\n\n    {.emit: \"\"\"\n#include <cstdint>\n\
    #include <algorithm>\n#include <limits>\ntemplate<unsigned M>\nstatic void cplib_subset_barrett_kernel(unsigned\
    \ n, uint32_t* __restrict left, uint32_t* __restrict right, const uint8_t* ranks,\
    \ const uint32_t* offsets) {\n    const unsigned size = 1u << n;\n    // \u5404\
    \u7A4D\u306F(M-1)^2\u4EE5\u4E0B\u306A\u306E\u3067\u3001\u3053\u306E\u9805\u6570\
    \u3054\u3068\u306B\u5270\u4F59\u3092\u53D6\u308C\u3070uint64_t\u306B\u53CE\u307E\
    \u308B\u3002\n    constexpr uint64_t capacity = std::numeric_limits<uint64_t>::max()\
    \ / (uint64_t(M - 1) * (M - 1));\n    constexpr unsigned terms = capacity < 64\
    \ ? unsigned(capacity) : 64;\n    const unsigned blockBits = std::min(n, 12u),\
    \ blockSize = 1u << blockBits;\n    auto zetaStage = [&](unsigned bit, unsigned\
    \ section, unsigned limit) {\n        for (unsigned base = section; base < limit;\
    \ base += bit * 2) {\n            const unsigned first = ranks[base];\n      \
    \      for (unsigned j = 0; j < bit; ++j) {\n                uint32_t* llo = left\
    \ + offsets[base + j];\n                uint32_t* lhi = left + offsets[base +\
    \ j + bit];\n                uint32_t* rlo = right + offsets[base + j];\n    \
    \            uint32_t* rhi = right + offsets[base + j + bit];\n              \
    \  for (unsigned d = first; d <= unsigned(ranks[base + j]); ++d) {\n         \
    \           const uint32_t lv = lhi[d] + llo[d], rv = rhi[d] + rlo[d];\n     \
    \               lhi[d] = lv >= M ? lv - M : lv;\n                    rhi[d] =\
    \ rv >= M ? rv - M : rv;\n                }\n            }\n        }\n    };\n\
    \    for (unsigned section = 0; section < size; section += blockSize)\n      \
    \  for (unsigned h = 0; h < blockBits; ++h) zetaStage(1u << h, section, section\
    \ + blockSize);\n    for (unsigned h = blockBits; h < n; ++h) zetaStage(1u <<\
    \ h, 0, size);\n    for (unsigned mask = 0; mask < size; ++mask) {\n        uint32_t*\
    \ lrow = left + offsets[mask];\n        const uint32_t* rrow = right + offsets[mask];\n\
    \        const unsigned rank = ranks[mask];\n        // \u5165\u529B\u4FC2\u6570\
    \u3092\u58CA\u3055\u305A\u7A4D\u3092\u6C42\u3081\u3066\u304B\u3089\u3001\u5FC5\
    \u8981\u306A\u6B21\u6570\u3060\u3051\u3092\u540C\u3058\u884C\u306B\u8A70\u3081\
    \u308B\u3002\n        uint32_t output[21];\n        const unsigned lastDegree\
    \ = std::min(n, 2 * rank);\n        for (unsigned d = rank; d <= lastDegree; ++d)\
    \ {\n            const unsigned first = d - rank;\n            if (rank - first\
    \ + 1 <= terms) {\n                uint64_t sum = 0;\n                for (unsigned\
    \ k = first; k <= rank; ++k) sum += uint64_t(lrow[k]) * rrow[d - k];\n       \
    \         output[d - rank] = uint32_t(sum % M);\n            } else {\n      \
    \          uint64_t value = 0;\n                for (unsigned k = first; k <=\
    \ rank;) {\n                    const unsigned last = std::min(rank, k + terms\
    \ - 1);\n                    uint64_t sum = 0;\n                    for (unsigned\
    \ j = k; j <= last; ++j) sum += uint64_t(lrow[j]) * rrow[d - j];\n           \
    \         value += sum % M;\n                    k = last + 1;\n             \
    \   }\n                output[d - rank] = uint32_t(value % M);\n            }\n\
    \        }\n        for (unsigned d = rank; d <= lastDegree; ++d) lrow[d - rank]\
    \ = output[d - rank];\n    }\n    auto mobiusStage = [&](unsigned bit, unsigned\
    \ section, unsigned limit) {\n        for (unsigned base = section; base < limit;\
    \ base += 2 * bit) {\n            for (unsigned j = 0; j < bit; ++j) {\n     \
    \           const uint32_t* lo = left + offsets[base + j];\n                uint32_t*\
    \ hi = left + offsets[base + j + bit];\n                const unsigned rank =\
    \ ranks[base + j + bit];\n                if (rank < 2) continue;\n          \
    \      const unsigned last = std::min(n - rank, rank - 2);\n                for\
    \ (unsigned d = 0; d <= last; ++d) {\n                    // \u4E21\u4FC2\u6570\
    \u306FM\u672A\u6E80\u3001M<=2^30\u306A\u306E\u3067\u6700\u4E0A\u4F4Dbit\u3067\u8CA0\
    \u306E\u5DEE\u3092\u5224\u5225\u3067\u304D\u308B\u3002\n                    const\
    \ uint32_t v = hi[d] - lo[d + 1];\n                    hi[d] = (v & 0x80000000u)\
    \ ? v + M : v;\n                }\n            }\n        }\n    };\n    for (unsigned\
    \ section = 0; section < size; section += blockSize)\n        for (unsigned h\
    \ = 0; h < blockBits; ++h) mobiusStage(1u << h, section, section + blockSize);\n\
    \    for (unsigned h = blockBits; h < n; ++h) mobiusStage(1u << h, 0, size);\n\
    }\n\n    \"\"\".}\n    proc subsetConvolutionBarrett*[T: StaticBarrettModint](a,\
    \ b: seq[T]): seq[T] =\n        ## \u9759\u7684Barrett\u578B\u306Esubset convolution\u3002\
    O(n\xB2 2^n)\u6642\u9593\u30FBO(n 2^n)\u8FFD\u52A0\u9818\u57DF\u3002\n       \
    \ assert a.len == b.len, \"\u914D\u5217\u306E\u9577\u3055\u306F\u4E00\u81F4\u3059\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        let size = a.len\n\
    \        if size == 0: return @[]\n        assert (size and (size - 1)) == 0,\
    \ \"\u914D\u5217\u306E\u9577\u3055\u306F2\u51AA\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\"\n        let n = fastLog2(size)\n        assert n <=\
    \ 20\n        const modulus = T.M\n        static: assert modulus > 1u32 and modulus\
    \ <= (1u32 shl 30)\n        # zeta\u3067\u306Frank+1\u9805\u3060\u3051\u3092\u4FDD\
    \u5B58\u3059\u308B\u3002\u7A4D\u5F8C\u306F\u5FC5\u8981\u306A\u6B21\u6570rank..n\u3092\
    \u5148\u982D\u306B\u8A70\u3081\u308B\u3002\n        var ranks = newSeq[uint8](size)\n\
    \        var offsets = newSeq[uint32](size + 1)\n        for mask in 0..<size:\n\
    \            let rank = countSetBits(mask)\n            ranks[mask] = rank.uint8\n\
    \            offsets[mask + 1] = offsets[mask] + uint32(rank + 1)\n        var\
    \ left = newSeq[uint32](int(offsets[size]))\n        var right = newSeq[uint32](int(offsets[size]))\n\
    \        for mask in 0..<size:\n            let index = int(offsets[mask]) + int(ranks[mask])\n\
    \            left[index] = uint32(a[mask].val)\n            right[index] = uint32(b[mask].val)\n\
    \        const call = \"cplib_subset_barrett_kernel<\" & $modulus & \">(#, #,\
    \ #, #, #)\"\n        proc kernel(n: cuint, left, right: ptr uint32, ranks: ptr\
    \ uint8, offsets: ptr uint32) {.importcpp: call, nodecl.}\n        kernel(n.cuint,\
    \ addr left[0], addr right[0], addr ranks[0], addr offsets[0])\n        result\
    \ = newSeq[T](size)\n        for mask in 0..<size: result[mask] = init(T, int(left[int(offsets[mask])]))\n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  isVerificationFile: false
  path: cplib/convolution/private/subset_convolution_barrett.nim
  requiredBy:
  - cplib/convolution/subset_convolution.nim
  - cplib/convolution/subset_convolution.nim
  - cplib/set_power_series/set_power_series.nim
  - cplib/set_power_series/set_power_series.nim
  timestamp: '2026-10-08 06:34:57+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/set_power_series/power_projection_of_set_power_series_test.nim
  - verify/set_power_series/power_projection_of_set_power_series_test.nim
  - verify/set_power_series/log_of_set_power_series_test.nim
  - verify/set_power_series/log_of_set_power_series_test.nim
  - verify/set_power_series/polynomial_composite_set_power_series_test.nim
  - verify/set_power_series/polynomial_composite_set_power_series_test.nim
  - verify/set_power_series/subset_convolution_regression_test.nim
  - verify/set_power_series/subset_convolution_regression_test.nim
  - verify/set_power_series/set_power_series_regression_test.nim
  - verify/set_power_series/set_power_series_regression_test.nim
  - verify/set_power_series/exp_of_set_power_series_test.nim
  - verify/set_power_series/exp_of_set_power_series_test.nim
  - verify/set_power_series/subset_convolution_test.nim
  - verify/set_power_series/subset_convolution_test.nim
documentation_of: cplib/convolution/private/subset_convolution_barrett.nim
layout: document
redirect_from:
- /library/cplib/convolution/private/subset_convolution_barrett.nim
- /library/cplib/convolution/private/subset_convolution_barrett.nim.html
title: cplib/convolution/private/subset_convolution_barrett.nim
---
