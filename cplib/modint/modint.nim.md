---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':question:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':question:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':question:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':question:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':question:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/abc277g_dynamic_test.nim
    title: verify/modint/barrett/abc277g_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/abc277g_dynamic_test.nim
    title: verify/modint/barrett/abc277g_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/abc277g_static_test.nim
    title: verify/modint/barrett/abc277g_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/abc277g_static_test.nim
    title: verify/modint/barrett/abc277g_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/dpr_dynamic_test.nim
    title: verify/modint/barrett/dpr_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/dpr_dynamic_test.nim
    title: verify/modint/barrett/dpr_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/dpr_static_test.nim
    title: verify/modint/barrett/dpr_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/dpr_static_test.nim
    title: verify/modint/barrett/dpr_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/keyence2021_dynamic_test.nim
    title: verify/modint/barrett/keyence2021_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/keyence2021_dynamic_test.nim
    title: verify/modint/barrett/keyence2021_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/keyence2021_static_test.nim
    title: verify/modint/barrett/keyence2021_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/barrett/keyence2021_static_test.nim
    title: verify/modint/barrett/keyence2021_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/abc277g_dynamic_test.nim
    title: verify/modint/montgomery/abc277g_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/abc277g_dynamic_test.nim
    title: verify/modint/montgomery/abc277g_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/abc277g_static_test.nim
    title: verify/modint/montgomery/abc277g_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/abc277g_static_test.nim
    title: verify/modint/montgomery/abc277g_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/dpr_dynamic_test.nim
    title: verify/modint/montgomery/dpr_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/dpr_dynamic_test.nim
    title: verify/modint/montgomery/dpr_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/dpr_static_test.nim
    title: verify/modint/montgomery/dpr_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/dpr_static_test.nim
    title: verify/modint/montgomery/dpr_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/keyence2021_static_test.nim
    title: verify/modint/montgomery/keyence2021_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/keyence2021_static_test.nim
    title: verify/modint/montgomery/keyence2021_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/keyence2021c_dynamic_test.nim
    title: verify/modint/montgomery/keyence2021c_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/modint/montgomery/keyence2021c_dynamic_test.nim
    title: verify/modint/montgomery/keyence2021c_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_path_dynamic_test.nim
    title: verify/tree/diameter_path_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_path_dynamic_test.nim
    title: verify/tree/diameter_path_dynamic_test.nim
  - icon: ':x:'
    path: verify/tree/diameter_path_static_test.nim
    title: verify/tree/diameter_path_static_test.nim
  - icon: ':x:'
    path: verify/tree/diameter_path_static_test.nim
    title: verify/tree/diameter_path_static_test.nim
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':question:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MODINT_MODINT:\n    const CPLIB_MODINT_MODINT* =\
    \ 1\n    include cplib/modint/barrett_impl\n    include cplib/modint/montgomery_impl\n\
    \    import std/math, std/algorithm\n    import cplib/math/isqrt\n    declarStaticMontgomeryModint(mint998244353_montgomery,\
    \ 998244353u32)\n    declarStaticMontgomeryModint(mint1000000007_montgomery, 1000000007u32)\n\
    \    declarDynamicMontgomeryModint(mint_montgomery, 1u32)\n    declarStaticBarrettModint(mint998244353_barrett,\
    \ 998244353u32)\n    declarStaticBarrettModint(mint1000000007_barrett, 1000000007u32)\n\
    \    declarDynamicBarrettModint(mint_barrett, 1u32)\n    func `+`*(a, b: MontgomeryModint\
    \ or BarrettModint): auto = (result = a; result += b)\n    func `-`*(a, b: MontgomeryModint\
    \ or BarrettModint): auto = (result = a; result -= b)\n    func `*`*(a, b: MontgomeryModint\
    \ or BarrettModint): auto = (result = a; result *= b)\n    func `/`*(a, b: MontgomeryModint\
    \ or BarrettModint): auto = (result = a; result /= b)\n    func `+`*(a: MontgomeryModint\
    \ or BarrettModint, b: SomeInteger): auto = (result = a; result += b)\n    func\
    \ `-`*(a: MontgomeryModint or BarrettModint, b: SomeInteger): auto = (result =\
    \ a; result -= b)\n    func `*`*(a: MontgomeryModint or BarrettModint, b: SomeInteger):\
    \ auto = (result = a; result *= b)\n    func `/`*(a: MontgomeryModint or BarrettModint,\
    \ b: SomeInteger): auto = (result = a; result /= b)\n    func `+`*(a: SomeInteger,\
    \ b: MontgomeryModint or BarrettModint): auto = b + a\n    func `-`*(a: SomeInteger,\
    \ b: MontgomeryModint or BarrettModint): auto = b - a\n    func `*`*(a: SomeInteger,\
    \ b: MontgomeryModint or BarrettModint): auto = b * a\n    func `/`*(a: SomeInteger,\
    \ b: MontgomeryModint or BarrettModint): auto = b / a\n    func pow*(a: MontgomeryModint\
    \ or BarrettModint, n: int): auto =\n        result = init(typeof(a), 1)\n   \
    \     var a = a\n        var n = n\n        while n > 0:\n            if (n and\
    \ 1) == 1: result *= a\n            a *= a\n            n = (n shr 1)\n    func\
    \ `$`*(a: MontgomeryModint or BarrettModint): string = $(a.val)\n    proc estimate_rational*(a:\
    \ MontgomeryModint or BarrettModint, ub: int = isqrt(typeof(a).mod)): string =\n\
    \        var v: seq[tuple[s, n, d: int]]\n        for d in 1..ub:\n          \
    \  var n = (a * d).val\n            if n * 2 > a.mod:\n                n = - (a.mod\
    \ - n)\n            if gcd(n, d) > 1: continue\n            v.add((n.abs + d,\
    \ n, d))\n        v.sort\n        return $v[0].n & \"/\" & $v[0].d\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: false
  path: cplib/modint/modint.nim
  requiredBy: []
  timestamp: '2024-04-08 07:09:25+09:00'
  verificationStatus: LIBRARY_SOME_WA
  verifiedWith:
  - verify/modint/barrett/keyence2021_dynamic_test.nim
  - verify/modint/barrett/keyence2021_dynamic_test.nim
  - verify/modint/barrett/keyence2021_static_test.nim
  - verify/modint/barrett/keyence2021_static_test.nim
  - verify/modint/barrett/dpr_static_test.nim
  - verify/modint/barrett/dpr_static_test.nim
  - verify/modint/barrett/dpr_dynamic_test.nim
  - verify/modint/barrett/dpr_dynamic_test.nim
  - verify/modint/barrett/abc277g_dynamic_test.nim
  - verify/modint/barrett/abc277g_dynamic_test.nim
  - verify/modint/barrett/abc277g_static_test.nim
  - verify/modint/barrett/abc277g_static_test.nim
  - verify/modint/montgomery/keyence2021_static_test.nim
  - verify/modint/montgomery/keyence2021_static_test.nim
  - verify/modint/montgomery/dpr_static_test.nim
  - verify/modint/montgomery/dpr_static_test.nim
  - verify/modint/montgomery/dpr_dynamic_test.nim
  - verify/modint/montgomery/dpr_dynamic_test.nim
  - verify/modint/montgomery/keyence2021c_dynamic_test.nim
  - verify/modint/montgomery/keyence2021c_dynamic_test.nim
  - verify/modint/montgomery/abc277g_dynamic_test.nim
  - verify/modint/montgomery/abc277g_dynamic_test.nim
  - verify/modint/montgomery/abc277g_static_test.nim
  - verify/modint/montgomery/abc277g_static_test.nim
  - verify/tree/diameter_path_static_test.nim
  - verify/tree/diameter_path_static_test.nim
  - verify/tree/diameter_path_dynamic_test.nim
  - verify/tree/diameter_path_dynamic_test.nim
documentation_of: cplib/modint/modint.nim
layout: document
redirect_from:
- /library/cplib/modint/modint.nim
- /library/cplib/modint/modint.nim.html
title: cplib/modint/modint.nim
---