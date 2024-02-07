---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/factorize
    links:
    - https://judge.yosupo.jp/problem/factorize
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/factorize\n\
    import cplib/math/primefactor\nimport strscans, strutils\n\nvar q: int\ndiscard\
    \ stdin.readLine.scanf(\"$i\", q)\nfor _ in 0..<q:\n    var a: int\n    discard\
    \ stdin.readLine.scanf(\"$i\", a)\n    var ans = primefactor(a)\n    if ans.len\
    \ == 0: echo 0\n    else: echo ans.len, \" \", ans.join(\" \")\n"
  dependsOn:
  - cplib/math/primefactor.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/math/primefactor.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  isVerificationFile: true
  path: verify/math/factorize_yosupo_test.nim
  requiredBy: []
  timestamp: '2023-12-25 07:39:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/factorize_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/math/factorize_yosupo_test.nim
- /verify/verify/math/factorize_yosupo_test.nim.html
title: verify/math/factorize_yosupo_test.nim
---