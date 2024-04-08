---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/isqrt_test.nim
    title: verify/math/isqrt_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isqrt_test.nim
    title: verify/math/isqrt_test.nim
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
    path: verify/tmpl/citrus_and_qcfium_test.nim
    title: verify/tmpl/citrus_and_qcfium_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tmpl/citrus_and_qcfium_test.nim
    title: verify/tmpl/citrus_and_qcfium_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_ISQRT:\n    const CPLIB_MATH_ISQRT* = 1\n  \
    \  proc isqrt*(n: int): int =\n        var x = n\n        var y = (x + 1) shr\
    \ 1\n        while y < x:\n            x = y\n            y = (x + n div x) shr\
    \ 1\n        return x\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/isqrt.nim
  requiredBy:
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/tmpl/citrus.nim
  - cplib/tmpl/citrus.nim
  timestamp: '2024-02-07 16:25:18+00:00'
  verificationStatus: LIBRARY_ALL_AC
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
  - verify/math/isqrt_test.nim
  - verify/math/isqrt_test.nim
  - verify/tmpl/citrus_and_qcfium_test.nim
  - verify/tmpl/citrus_and_qcfium_test.nim
documentation_of: cplib/math/isqrt.nim
layout: document
redirect_from:
- /library/cplib/math/isqrt.nim
- /library/cplib/math/isqrt.nim.html
title: cplib/math/isqrt.nim
---