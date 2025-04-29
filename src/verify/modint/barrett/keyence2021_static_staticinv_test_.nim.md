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
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/keyence2021/tasks/keyence2021_c
    links:
    - https://atcoder.jp/contests/keyence2021/tasks/keyence2021_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/keyence2021/tasks/keyence2021_c\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nproc getchar(): char {.importc:\
    \ \"getchar_unlocked\", header: \"<stdio.h>\", discardable.}\nimport sequtils,\
    \ strutils\nimport cplib/modint/modint\ntype mint = modint998244353_barrett\n\n\
    var h, w, k = ii()\nvar s = newSeqWith(h, \"?\".repeat(w).join(\"\"))\nfor i in\
    \ 0..<k:\n    var x, y = ii()-1\n    var c = getchar()\n    s[x][y] = c\n\nvar\
    \ dp = newSeqWith(h, newseqwith(w, mint(0)))\ndp[0][0] = mint(3).pow(h*w - k)\n\
    for i in 0..<h:\n    for j in 0..<w:\n        if s[i][j] == 'D':\n           \
    \ if i+1 in 0..<h: dp[i+1][j] += dp[i][j]\n        elif s[i][j] == 'R':\n    \
    \        if j+1 in 0..<w: dp[i][j+1] += dp[i][j]\n        elif s[i][j] == 'X':\n\
    \            if i+1 in 0..<h: dp[i+1][j] += dp[i][j]\n            if j+1 in 0..<w:\
    \ dp[i][j+1] += dp[i][j]\n        else:\n            if i+1 in 0..<h: dp[i+1][j]\
    \ += dp[i][j] * 2 / 3\n            if j+1 in 0..<w: dp[i][j+1] += dp[i][j] * 2\
    \ / 3\necho dp[h-1][w-1].val\n"
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  isVerificationFile: false
  path: verify/modint/barrett/keyence2021_static_staticinv_test_.nim
  requiredBy: []
  timestamp: '2025-04-27 18:34:28+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/modint/barrett/keyence2021_static_staticinv_test_.nim
layout: document
redirect_from:
- /library/verify/modint/barrett/keyence2021_static_staticinv_test_.nim
- /library/verify/modint/barrett/keyence2021_static_staticinv_test_.nim.html
title: verify/modint/barrett/keyence2021_static_staticinv_test_.nim
---
