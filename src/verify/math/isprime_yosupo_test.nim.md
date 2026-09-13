---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':question:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':question:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':question:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':question:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':question:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/primality_test
    links:
    - https://judge.yosupo.jp/problem/primality_test
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/primality_test\n\
    include cplib/tmpl/sheep\nimport cplib/math/isprime\n\nvar Q = ii()\n\nfor i in\
    \ 0..<Q:\n    var N = ii()\n    if isprime(N):\n        echo \"Yes\"\n    else:\n\
    \        echo \"No\"\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/tmpl/sheep.nim
  - cplib/math/isprime.nim
  - cplib/tmpl/sheep.nim
  - cplib/tmpl/fastio.nim
  - cplib/math/isprime.nim
  - cplib/tmpl/fastio.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/math/isprime_yosupo_test.nim
  requiredBy: []
  timestamp: '2026-09-13 12:59:41+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/math/isprime_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/math/isprime_yosupo_test.nim
- /verify/verify/math/isprime_yosupo_test.nim.html
title: verify/math/isprime_yosupo_test.nim
---
