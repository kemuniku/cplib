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
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':question:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':question:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':question:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport unittest\nimport cplib/modint/modint\n\naddOutputFormatter(newConsoleOutputFormatter(OutputLevel.PRINT_FAILURES))\n\
    \ntest \"Dynamic Montogomery Zero Division Test\":\n    type mint = modint_montgomery\n\
    \    mint.setMod(998244353)\n    expect(Defect):\n        discard mint(0).inv\n\
    test \"Static Montogomery Zero Division Test\":\n    type mint = modint998244353_montgomery\n\
    \    expect(Defect):\n        discard mint(0).inv\ntest \"Dynamic Barrett Zero\
    \ Division Test\":\n    type mint = modint_barrett\n    mint.setMod(998244353)\n\
    \    expect(Defect):\n        discard mint(0).inv\ntest \"Static Barrett Zero\
    \ Division Test\":\n    type mint = modint998244353_barrett\n    expect(Defect):\n\
    \        discard mint(0).inv\n\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/modint/check_zerodivision_test.nim
  requiredBy: []
  timestamp: '2024-07-21 20:30:56+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/modint/check_zerodivision_test.nim
layout: document
redirect_from:
- /verify/verify/modint/check_zerodivision_test.nim
- /verify/verify/modint/check_zerodivision_test.nim.html
title: verify/modint/check_zerodivision_test.nim
---
