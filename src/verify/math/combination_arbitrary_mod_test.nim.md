---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination_arbitrary_mod.nim
    title: cplib/math/combination_arbitrary_mod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination_arbitrary_mod.nim
    title: cplib/math/combination_arbitrary_mod.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/binomial_coefficient
    links:
    - https://judge.yosupo.jp/problem/binomial_coefficient
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/binomial_coefficient\n\
    import sequtils, strutils\nimport cplib/math/combination_arbitrary_mod\n\nlet\
    \ tm = stdin.readLine.split.map(parseInt)\nlet c = initCombinationArbitraryMod(10_000_000,\
    \ tm[1])\nfor _ in 0..<tm[0]:\n    let nr = stdin.readLine.split.map(parseInt)\n\
    \    echo c.ncr(nr[0], nr[1])\n"
  dependsOn:
  - cplib/math/combination_arbitrary_mod.nim
  - cplib/math/combination_arbitrary_mod.nim
  isVerificationFile: true
  path: verify/math/combination_arbitrary_mod_test.nim
  requiredBy: []
  timestamp: '2026-09-18 12:34:22+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/combination_arbitrary_mod_test.nim
layout: document
redirect_from:
- /verify/verify/math/combination_arbitrary_mod_test.nim
- /verify/verify/math/combination_arbitrary_mod_test.nim.html
title: verify/math/combination_arbitrary_mod_test.nim
---
