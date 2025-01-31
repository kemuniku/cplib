---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination.nim
    title: cplib/math/combination.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination.nim
    title: cplib/math/combination.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/binomial_coefficient_prime_mod
    links:
    - https://judge.yosupo.jp/problem/binomial_coefficient_prime_mod
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/binomial_coefficient_prime_mod\n\
    import sequtils, strutils\nimport atcoder/modint\nimport cplib/math/combination\n\
    \nvar t, m: int\n(t, m) = stdin.readLine.split.map(parseInt)\ntype mint = modint\n\
    mint.setMod(m)\nvar c = initCombination[mint](10_000_000)\nfor _ in 0..<t:\n \
    \   var n, k: int\n    (n, k) = stdin.readLine.split.map(parseInt)\n    echo c.ncr(n,\
    \ k).val\n"
  dependsOn:
  - cplib/math/combination.nim
  - cplib/math/combination.nim
  isVerificationFile: true
  path: verify/math/combination_test.nim
  requiredBy: []
  timestamp: '2024-09-20 23:06:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/combination_test.nim
layout: document
redirect_from:
- /verify/verify/math/combination_test.nim
- /verify/verify/math/combination_test.nim.html
title: verify/math/combination_test.nim
---
