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
    \ntest \"Dynamic Montgomery Integer Operation Test\":\n    type mint = modint_montgomery\n\
    \    mint.setMod(998244353)\n    for x in 1..10:\n        for y in 1..10:\n  \
    \          assert (x + mint(y)).val == (mint(x) + mint(y)).val\n            assert\
    \ (mint(x) + y).val == (mint(x) + mint(y)).val\ntest \"Static Montogomery Integer\
    \ Operation Test\":\n    type mint = modint998244353_montgomery\n    for x in\
    \ 1..10:\n        for y in 1..10:\n            assert (x + mint(y)).val == (mint(x)\
    \ + mint(y)).val\n            assert (mint(x) + y).val == (mint(x) + mint(y)).val\n\
    test \"Dynamic Barrett Integer Operation Test\":\n    type mint = modint_barrett\n\
    \    mint.setMod(998244353)\n    for x in 1..10:\n        for y in 1..10:\n  \
    \          assert (x + mint(y)).val == (mint(x) + mint(y)).val\n            assert\
    \ (mint(x) + y).val == (mint(x) + mint(y)).val\ntest \"Static Barrett Integer\
    \ Operation Test\":\n    type mint = modint998244353_barrett\n    for x in 1..10:\n\
    \        for y in 1..10:\n            assert (x + mint(y)).val == (mint(x) + mint(y)).val\n\
    \            assert (mint(x) + y).val == (mint(x) + mint(y)).val\n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/modint/integer_operation_test.nim
  requiredBy: []
  timestamp: '2024-10-13 17:03:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/modint/integer_operation_test.nim
layout: document
redirect_from:
- /verify/verify/modint/integer_operation_test.nim
- /verify/verify/modint/integer_operation_test.nim.html
title: verify/modint/integer_operation_test.nim
---
