---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/ntt.nim
    title: cplib/convolution/ntt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/ntt.nim
    title: cplib/convolution/ntt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
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
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_dynamic_barrett_test.nim
    title: verify/convolution/convolution/convolution_dynamic_barrett_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_dynamic_barrett_test.nim
    title: verify/convolution/convolution/convolution_dynamic_barrett_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
    title: verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
    title: verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_static_barrett_test.nim
    title: verify/convolution/convolution/convolution_static_barrett_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_static_barrett_test.nim
    title: verify/convolution/convolution/convolution_static_barrett_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_static_montgomery_test.nim
    title: verify/convolution/convolution/convolution_static_montgomery_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_static_montgomery_test.nim
    title: verify/convolution/convolution/convolution_static_montgomery_test.nim
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
  code: "when not declared CPLIB_CONVOLUTION_CONVOLUTION:\n    const CPLIB_CONVOLUTION_CONVOLUTION*\
    \ = 1\n    import bitops, sequtils, std/math\n    import cplib/modint/modint\n\
    \    import cplib/convolution/ntt\n    import cplib/math/inv_gcd\n\n    declarStaticMontgomeryModint(mint754974721,\
    \ 754974721u32)\n    declarStaticMontgomeryModint(mint167772161, 167772161u32)\n\
    \    declarStaticMontgomeryModint(mint469762049, 469762049u32)\n\n    proc convolution_naive*[T:\
    \ BarrettModint or MontgomeryModint or int](f, g: seq[T]): seq[T] =\n        var\
    \ ans = newSeqWith(f.len + g.len - 1, T(0))\n        if f.len > g.len:\n     \
    \       for i in 0..<f.len:\n                for j in 0..<g.len:\n           \
    \         ans[i+j] += f[i] * g[j]\n        else:\n            for j in 0..<g.len:\n\
    \                for i in 0..<f.len:\n                    ans[i+j] += f[i] * g[j]\n\
    \        return ans\n\n    proc convolution*[T: BarrettModint or MontgomeryModint](f,\
    \ g: seq[T]): seq[T] =\n        var f = f\n        var g = g\n        let m =\
    \ f.len\n        let n = g.len\n        let deg = m + n - 1\n        if min(n,\
    \ m) <= 60: return convolution_naive(f, g)\n        var l = (if deg == 1: 1 else:\
    \ (1 shl (fastLog2(deg - 1) + 1)))\n        f.setLen(l)\n        g.setLen(l)\n\
    \        ntt(f)\n        ntt(g)\n        for i in 0..<f.len:\n            f[i]\
    \ *= g[i]\n        intt(f)\n        f.setlen(deg)\n        return f\n\n\n    proc\
    \ convolution_ll*(f, g: seq[int]): seq[int] =\n        var n = f.len\n       \
    \ var m = g.len\n        if n == 0 or m == 0: return newSeq[int]()\n\n       \
    \ const\n            M1 = 754974721u\n            M2 = 167772161u\n          \
    \  M3 = 469762049u\n            M12 = M1 * M2\n            M23 = M2 * M3\n   \
    \         M31 = M3 * M1\n            M123 = M1 * M2 * M3\n            i1 = inv_gcd((M2\
    \ * M3).int, M1.int)[1].uint\n            i2 = inv_gcd((M3 * M1).int, M2.int)[1].uint\n\
    \            i3 = inv_gcd((M1 * M2).int, M3.int)[1].uint\n        # FIXME: mapit\u3067\
    f1, g1\u3092\u4F5C\u308D\u3046\u3068\u3059\u308B\u3068\u306A\u305C\u304B\u58CA\
    \u308C\u308B\u2026\u2026\n        var f1 = newSeq[mint754974721](n)\n        var\
    \ g1 = newSeq[mint754974721](m)\n        for i in 0..<n: f1[i] = mint754974721(f[i])\n\
    \        for i in 0..<m: g1[i] = mint754974721(g[i])\n        let c1 = convolution(f1,\
    \ g1)\n        var f2 = newSeq[mint167772161](n)\n        var g2 = newSeq[mint167772161](m)\n\
    \        for i in 0..<n: f2[i] = mint167772161(f[i])\n        for i in 0..<m:\
    \ g2[i] = mint167772161(g[i])\n        let c2 = convolution(f2, g2)\n        var\
    \ f3 = newSeq[mint469762049](n)\n        var g3 = newSeq[mint469762049](m)\n \
    \       for i in 0..<n: f3[i] = mint469762049(f[i])\n        for i in 0..<m: g3[i]\
    \ = mint469762049(g[i])\n        let c3 = convolution(f3, g3)\n        var ans\
    \ = newseqwith(n + m - 1, 0)\n        for i in 0..<ans.len:\n            var x\
    \ = 0.uint\n            x += (c1[i].val.uint * i1) mod M1 * M23\n            x\
    \ += (c2[i].val.uint * i2) mod M2 * M31\n            x += (c3[i].val.uint * i3)\
    \ mod M3 * M12\n            var diff = c1[i].val - floorMod(x.int, M1.int)\n \
    \           if diff < 0: diff += M1.int\n            const offset = [0u, 0u, M123,\
    \ 2u * M123, 3u * M123]\n            x -= offset[diff mod 5]\n            ans[i]\
    \ = cast[int](x)\n        return ans\n"
  dependsOn:
  - cplib/math/inv_gcd.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/convolution/ntt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/ntt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/inv_gcd.nim
  isVerificationFile: false
  path: cplib/convolution/convolution.nim
  requiredBy: []
  timestamp: '2026-03-21 18:55:19+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/convolution/convolution/convolution_dynamic_barrett_test.nim
  - verify/convolution/convolution/convolution_dynamic_barrett_test.nim
  - verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
  - verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
  - verify/convolution/convolution/convolution_static_montgomery_test.nim
  - verify/convolution/convolution/convolution_static_montgomery_test.nim
  - verify/convolution/convolution/convolution_static_barrett_test.nim
  - verify/convolution/convolution/convolution_static_barrett_test.nim
documentation_of: cplib/convolution/convolution.nim
layout: document
redirect_from:
- /library/cplib/convolution/convolution.nim
- /library/cplib/convolution/convolution.nim.html
title: cplib/convolution/convolution.nim
---
