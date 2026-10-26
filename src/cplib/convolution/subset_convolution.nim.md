---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/private/subset_convolution_barrett.nim
    title: cplib/convolution/private/subset_convolution_barrett.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/private/subset_convolution_barrett.nim
    title: cplib/convolution/private/subset_convolution_barrett.nim
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
  code: "when not declared CPLIB_CONVOLUTION_SUBSET_CONVOLUTION:\n    const CPLIB_CONVOLUTION_SUBSET_CONVOLUTION*\
    \ = 1\n    import bitops\n    when defined(cpp) and (defined(gcc) or defined(clang)):\n\
    \        import cplib/modint/modint\n        import cplib/convolution/private/subset_convolution_barrett\n\
    \n    proc subsetConvolution*[T](a, b: seq[T]): seq[T] =\n        ## c[S] = \u03A3\
    _{U\u2286S} a[U] b[S xor U]\u3002O(n\xB2 2^n)\u6642\u9593\u30FBO(n 2^n)\u8FFD\u52A0\
    \u9818\u57DF\u3002\n        ## \u540C\u30582\u51AA\u9577\u306E\u5217\u3092\u53D7\
    \u3051\u53D6\u308A\u3001\u4E21\u65B9\u304C\u7A7A\u306A\u3089\u7A7A\u5217\u3092\
    \u8FD4\u3059\u3002\n        assert a.len == b.len, \"\u914D\u5217\u306E\u9577\u3055\
    \u306F\u4E00\u81F4\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       let size = a.len\n        if size == 0: return @[]\n        assert (size\
    \ and (size - 1)) == 0, \"\u914D\u5217\u306E\u9577\u3055\u306F2\u51AA\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        let n = fastLog2(size)\n\
    \        when defined(cpp) and (defined(gcc) or defined(clang)):\n           \
    \ when T is StaticBarrettModint:\n                when T.M > 1u32 and T.M <= (1u32\
    \ shl 30):\n                    if n <= 20: return subsetConvolutionBarrett(a,\
    \ b)\n        let stride = n + 1\n        var left = newSeq[T](size * stride)\n\
    \        var right = newSeq[T](size * stride)\n        var ranks = newSeq[uint8](size)\n\
    \        for mask in 0..<size:\n            let rank = countSetBits(mask)\n  \
    \          ranks[mask] = rank.uint8\n            let index = mask * stride + rank\n\
    \            left[index] = a[mask]\n            right[index] = b[mask]\n     \
    \   template zetaStage(bit, section, limit: untyped) =\n            var base =\
    \ section\n            while base < limit:\n                # \u65E2\u306B\u51E6\
    \u7406\u3057\u305F\u4E0B\u4F4Dbit\u3060\u3051\u304C\u5909\u308F\u308B\u306E\u3067\
    \u3001\u52A0\u7B97\u5143\u306Erank\u306F\u3053\u306E\u7BC4\u56F2\u306B\u9650\u3089\
    \u308C\u308B\u3002\n                let first = int(ranks[base])\n           \
    \     for j in 0..<bit:\n                    let lo = (base + j) * stride\n  \
    \                  let hi = lo + bit * stride\n                    # \u691C\u67FB\
    \u6E08\u307F\u306E\u884C\u5148\u982D\u304B\u3089\u30010..n\u5185\u306Erank\u306E\
    \u307F\u3092\u53C2\u7167\u3059\u308B\u3002\n                    let llo = cast[ptr\
    \ UncheckedArray[T]](addr left[lo])\n                    let lhi = cast[ptr UncheckedArray[T]](addr\
    \ left[hi])\n                    let rlo = cast[ptr UncheckedArray[T]](addr right[lo])\n\
    \                    let rhi = cast[ptr UncheckedArray[T]](addr right[hi])\n \
    \                   for d in first.uint32..uint32(int(ranks[base + j])):\n   \
    \                     lhi[d] += llo[d]\n                        rhi[d] += rlo[d]\n\
    \                base += bit * 2\n        # \u4E0B\u4F4Dbit\u306E\u5909\u63DB\u3092\
    \u30D6\u30ED\u30C3\u30AF\u5185\u3067\u5B8C\u4E86\u3055\u305B\u3001\u914D\u5217\
    \u5168\u4F53\u306E\u5F80\u5FA9\u3092\u6E1B\u3089\u3059\u3002\n        let blockBits\
    \ = min(n, 10)\n        let blockSize = 1 shl blockBits\n        var section =\
    \ 0\n        while section < size:\n            for h in 0..<blockBits:\n    \
    \            zetaStage(1 shl h, section, section + blockSize)\n            section\
    \ += blockSize\n        for h in blockBits..<n:\n            zetaStage(1 shl h,\
    \ 0, size)\n        for mask in 0..<size:\n            let offset = mask * stride\n\
    \            let rank = int(ranks[mask])\n            let lrow = cast[ptr UncheckedArray[T]](addr\
    \ left[offset])\n            let rrow = cast[ptr UncheckedArray[T]](addr right[offset])\n\
    \            # rank\u672A\u6E80\u306E\u9805\u306F\u4EE5\u5F8C\u306EMobius\u30FB\
    \u51FA\u529B\u3067\u4F7F\u308F\u305A\u30012*rank\u3092\u8D85\u3048\u308B\u9805\
    \u306F\u96F6\u3002\n            var d = uint32(min(n, 2 * rank))\n           \
    \ while true:\n                var value = default(T)\n                for k in\
    \ d - rank.uint32..rank.uint32:\n                    value += lrow[k] * rrow[d\
    \ - k]\n                lrow[d] = value\n                if d == rank.uint32:\
    \ break\n                dec d\n        template mobiusStage(bit, section, limit:\
    \ untyped) =\n            var base = section\n            while base < limit:\n\
    \                for j in 0..<bit:\n                    let lo = (base + j) *\
    \ stride\n                    let hi = lo + bit * stride\n                   \
    \ let llo = cast[ptr UncheckedArray[T]](addr left[lo])\n                    let\
    \ lhi = cast[ptr UncheckedArray[T]](addr left[hi])\n                    # \u3053\
    \u306E\u96C6\u5408\u4EE5\u4E0A\u306E\u51FA\u529B\u306B\u5FC5\u8981\u306A\u6B21\
    \u6570\u3060\u3051\u3092\u9006\u5909\u63DB\u3059\u308B\u3002\n               \
    \     let rank = int(ranks[base + j + bit])\n                    for d in rank.uint32..uint32(min(n,\
    \ 2 * (rank - 1))):\n                        lhi[d] -= llo[d]\n              \
    \  base += bit * 2\n        section = 0\n        while section < size:\n     \
    \       for h in 0..<blockBits:\n                mobiusStage(1 shl h, section,\
    \ section + blockSize)\n            section += blockSize\n        for h in blockBits..<n:\n\
    \            mobiusStage(1 shl h, 0, size)\n        result = newSeq[T](size)\n\
    \        for mask in 0..<size: result[mask] = left[mask * stride + int(ranks[mask])]\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/convolution/private/subset_convolution_barrett.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/private/subset_convolution_barrett.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  isVerificationFile: false
  path: cplib/convolution/subset_convolution.nim
  requiredBy:
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
documentation_of: cplib/convolution/subset_convolution.nim
layout: document
redirect_from:
- /library/cplib/convolution/subset_convolution.nim
- /library/cplib/convolution/subset_convolution.nim.html
title: cplib/convolution/subset_convolution.nim
---
