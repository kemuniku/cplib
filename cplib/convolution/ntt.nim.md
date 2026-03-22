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
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
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
    links:
    - https://tayu0110.hatenablog.com/entry/2023/05/06/023244
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# original: https://tayu0110.hatenablog.com/entry/2023/05/06/023244\nwhen\
    \ not declared CPLIB_CONVOLUTION_NTT:\n    const CPLIB_CONVOLUTION_NTT* = 1\n\
    \    import options, macros, tables, bitops\n    import cplib/modint/modint\n\
    \    proc ntt_powmod_compiletime(a, x, p: int): int =\n        var ans = 1\n \
    \       var a = a\n        var x = x\n        while x > 0:\n            if (x\
    \ and 1) == 1:\n                ans = (ans * a) mod p\n            a = (a * a)\
    \ mod p\n            x = (x shr 1)\n        return ans mod p\n\n    proc ntt_primefactor_compiletime(p:\
    \ int): seq[int] =\n        var x = p\n        var ans = newSeq[int]()\n     \
    \   for i in 2..p:\n            if i * i > p: break\n            if x mod i !=\
    \ 0: continue\n            ans.add(i)\n            while x mod i == 0:\n     \
    \           x = x div i\n        if x != 1: ans.add(x)\n        return ans\n\n\
    \    proc ntt_primitive_root_compiletime(p: int): int =\n        var pf = (p-1).ntt_primefactor_compiletime\n\
    \        for a in 3..<p:\n            proc check(): bool =\n                for\
    \ q in pf:\n                    if ntt_powmod_compiletime(a, (p-1) div q, p) ==\
    \ 1:\n                        return false\n                return true\n    \
    \        if check():\n                return a\n\n    proc nth_root(primitive_root,\
    \ nth, m: int): int = ntt_powmod_compiletime(primitive_root, (m - 1) div nth,\
    \ m)\n    type NttConfig = object\n        sum_e, m, forth_root, forth_root_inv,\
    \ primitive_root: int\n        rate2, rate3, irate2, irate3: array[30, int]\n\
    \    proc initNttConfig(m: int): NttConfig =\n        var sum_e = 0\n        var\
    \ rate2, rate3, irate2, irate3: array[30, int]\n        var prod = 1\n       \
    \ var iprod = 1\n        var primitive_root = ntt_primitive_root_compiletime(m)\n\
    \        while sum_e + 2 <= ((m - 1).countTrailingZeroBits - 1):\n           \
    \ var root = nth_root(primitive_root, 1 shl (sum_e + 2), m)\n            var iroot\
    \ = ntt_powmod_compiletime(root, m - 2, m)\n            rate2[sum_e] = (root *\
    \ iprod) mod m\n            irate2[sum_e] = (iroot * prod) mod m\n           \
    \ prod = (prod * root) mod m\n            iprod = (iprod * iroot) mod m\n    \
    \        sum_e += 1\n        sum_e = 0\n        prod = 1\n        iprod = 1\n\
    \        while sum_e + 3 <= ((m - 1).countTrailingZeroBits):\n            var\
    \ root = nth_root(primitive_root, 1 shl (sum_e + 3), m)\n            var iroot\
    \ = ntt_powmod_compiletime(root, m - 2, m)\n            rate3[sum_e] = (root *\
    \ iprod) mod m\n            irate3[sum_e] = (iroot * prod) mod m\n           \
    \ prod = (prod * root) mod m\n            iprod = (iprod * iroot) mod m\n    \
    \        sum_e += 1\n        var forth_root = nth_root(primitive_root, 4, m)\n\
    \        var forth_root_inv = ntt_powmod_compiletime(forth_root, m-2, m)\n   \
    \     return NttConfig(sum_e: sum_e + 2, m: m, forth_root: forth_root, forth_root_inv:\
    \ forth_root_inv, primitive_root: primitive_root, rate2: rate2, rate3: rate3,\
    \ irate2: irate2, irate3: irate3)\n\n    var ntt_config_cache {.compileTime.}:\
    \ Table[uint32, NimNode]\n    var dynamic_ntt_config = NttConfig()\n    macro\
    \ get_ntt_config[M: static[uint32]](self: typedesc[StaticBarrettModint[M] or StaticMontgomeryModint[M]]):\
    \ untyped =\n        if M notin ntt_config_cache:\n            let value = initNttConfig(int(M))\n\
    \            ntt_config_cache[M] = newLit(value)\n        result = ntt_config_cache[M]\n\
    \    proc get_ntt_config(self: typedesc[DynamicBarrettModint or DynamicMontgomeryModint]):\
    \ NttConfig =\n        if dynamic_ntt_config.m != self.umod.int:\n           \
    \ dynamic_ntt_config = initNttConfig(self.umod.int)\n        return dynamic_ntt_config\n\
    \n    proc ntt*[T: BarrettModint or MontgomeryModint](f: var seq[T]) =\n     \
    \   let n = f.len\n        if n <= 1: return\n        let ntt_config = get_ntt_config(T)\n\
    \        assert(n.popcount == 1, \"len(f) must be power of two, please add zeros\"\
    )\n        var width = n\n        while width > 1:\n            if width == 2:\n\
    \                let offset = (width shr 1)\n                var root = T(1)\n\
    \                for top in countup(0, n-1, width):\n                    for i\
    \ in top..<(top+offset):\n                        let (c0, c1) = (f[i], f[i+offset]\
    \ * root)\n                        f[i] = c0 + c1\n                        f[i+offset]\
    \ = c0 - c1\n                    let b = top div width\n                    root\
    \ *= ntt_config.rate2[countTrailingZeroBits(not b)]\n                width = (width\
    \ shr 1)\n            else:\n                let offset = (width shr 2)\n    \
    \            var root = T(1)\n                for top in countup(0, n-1, width):\n\
    \                    let root2 = root * root\n                    let root3 =\
    \ root * root2\n                    for i in top..<(top+offset):\n           \
    \             let (c0, c1, c2, c3) = (f[i], f[i+offset] * root, f[i+offset*2]\
    \ * root2, f[i+offset*3] * root3)\n                        let c0c2 = c0 + c2\n\
    \                        let c0c2n = c0 - c2\n                        let c1c3\
    \ = c1 + c3\n                        let c1c3nim = (c1 - c3) * ntt_config.forth_root\n\
    \                        f[i] = c0c2 + c1c3\n                        f[i+offset]\
    \ = c0c2 - c1c3\n                        f[i+offset*2] = c0c2n + c1c3nim\n   \
    \                     f[i+offset*3] = c0c2n - c1c3nim\n                    let\
    \ b = top div width\n                    root *= ntt_config.rate3[countTrailingZeroBits(not\
    \ b)]\n                width = (width shr 2)\n\n    proc intt*[T: BarrettModint\
    \ or MontgomeryModint](f: var seq[T]) =\n        let n = f.len\n        if n <=\
    \ 1: return\n        let ntt_config = get_ntt_config(T)\n        assert(n.popcount\
    \ == 1, \"len(f) must be power of two, please add zeros\")\n        var width\
    \ = (if n.countTrailingZeroBits mod 2 == 1: 2 else: 4)\n        while width <=\
    \ n:\n            if width == 2:\n                let offset = (width shr 1)\n\
    \                var root = T(1)\n                for top in countup(0, n-1, width):\n\
    \                    for i in top..<(top+offset):\n                        let\
    \ (c0, c1) = (f[i], f[i+offset])\n                        f[i] = c0 + c1\n   \
    \                     f[i+offset] = (c0 - c1) * root\n                    let\
    \ b = top div width\n                    root *= ntt_config.irate2[countTrailingZeroBits(not\
    \ b)]\n            else:\n                let offset = (width shr 2)\n       \
    \         var root = T(1)\n                for top in countup(0, n-1, width):\n\
    \                    let root2 = root * root\n                    let root3 =\
    \ root * root2\n                    for i in top..<(top+offset):\n           \
    \             let (c0, c1, c2, c3) = (f[i], f[i+offset], f[i+offset*2], f[i+offset*3])\n\
    \                        let c0c1 = c0 + c1\n                        let c0c1n\
    \ = c0 - c1\n                        let c2c3 = c2 + c3\n                    \
    \    let c2c3nim = (c2 - c3) * ntt_config.forth_root_inv\n                   \
    \     f[i] = c0c1 + c2c3\n                        f[i+offset] = (c0c1n + c2c3nim)\
    \ * root\n                        f[i+offset*2] = (c0c1 - c2c3) * root2\n    \
    \                    f[i+offset*3] = (c0c1n - c2c3nim) * root3\n             \
    \       let b = top div width\n                    root *= ntt_config.irate3[countTrailingZeroBits(not\
    \ b)]\n            width = (width shl 2)\n        var ninv = T(n).inv\n      \
    \  for i in 0..<n: f[i] *= ninv\n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  isVerificationFile: false
  path: cplib/convolution/ntt.nim
  requiredBy:
  - cplib/convolution/convolution.nim
  - cplib/convolution/convolution.nim
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
documentation_of: cplib/convolution/ntt.nim
layout: document
redirect_from:
- /library/cplib/convolution/ntt.nim
- /library/cplib/convolution/ntt.nim.html
title: cplib/convolution/ntt.nim
---
