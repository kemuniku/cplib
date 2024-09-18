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
    PROBLEM: https://atcoder.jp/contests/keyence2021/tasks/keyence2021_c
    links:
    - https://atcoder.jp/contests/keyence2021/tasks/keyence2021_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/keyence2021/tasks/keyence2021_c\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nproc getchar(): char {.importc:\
    \ \"getchar_unlocked\", header: \"<stdio.h>\", discardable.}\nimport sequtils,\
    \ strutils\nimport cplib/modint/modint\ntype mint = modint_barrett\nmint.setMod(998244353)\n\
    \nvar h, w, k = ii()\nvar s = newSeqWith(h, \"?\".repeat(w).join(\"\"))\nfor i\
    \ in 0..<k:\n    var x, y = ii()-1\n    var c = getchar()\n    s[x][y] = c\n\n\
    var dp = newSeqWith(h, newseqwith(w, mint(0)))\ndp[0][0] = mint(3).pow(h*w - k)\n\
    var mul = mint(2) * mint(3).inv\nfor i in 0..<h:\n    for j in 0..<w:\n      \
    \  if s[i][j] == 'D':\n            if i+1 in 0..<h: dp[i+1][j] += dp[i][j]\n \
    \       elif s[i][j] == 'R':\n            if j+1 in 0..<w: dp[i][j+1] += dp[i][j]\n\
    \        elif s[i][j] == 'X':\n            if i+1 in 0..<h: dp[i+1][j] += dp[i][j]\n\
    \            if j+1 in 0..<w: dp[i][j+1] += dp[i][j]\n        else:\n        \
    \    if i+1 in 0..<h: dp[i+1][j] += dp[i][j] * mul\n            if j+1 in 0..<w:\
    \ dp[i][j+1] += dp[i][j] * mul\necho dp[h-1][w-1].val\n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/modint/barrett/keyence2021_static_test.nim
  requiredBy: []
  timestamp: '2024-07-21 20:30:56+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/modint/barrett/keyence2021_static_test.nim
layout: document
redirect_from:
- /verify/verify/modint/barrett/keyence2021_static_test.nim
- /verify/verify/modint/barrett/keyence2021_static_test.nim.html
title: verify/modint/barrett/keyence2021_static_test.nim
---
