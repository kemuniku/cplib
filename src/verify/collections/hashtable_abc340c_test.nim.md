---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/hashtable.nim
    title: cplib/collections/hashtable.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/hashtable.nim
    title: cplib/collections/hashtable.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc340/tasks/abc340_c
    links:
    - https://atcoder.jp/contests/abc340/tasks/abc340_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc340/tasks/abc340_c\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nimport cplib/collections/hashtable\n\
    \nvar n = ii()\nvar dp = initHashTable[int, int](100)\nproc dfs(x: int): int =\n\
    \    if x < 2: return 0\n    if x in dp: return dp[x]\n    dp[x] = x\n    dp[x]\
    \ += dfs(x div 2)\n    dp[x] += dfs((x+1) div 2)\n    return dp[x]\necho dfs(n)\n"
  dependsOn:
  - cplib/collections/hashtable.nim
  - cplib/collections/hashtable.nim
  isVerificationFile: true
  path: verify/collections/hashtable_abc340c_test.nim
  requiredBy: []
  timestamp: '2024-03-21 10:31:56+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/hashtable_abc340c_test.nim
layout: document
redirect_from:
- /verify/verify/collections/hashtable_abc340c_test.nim
- /verify/verify/collections/hashtable_abc340c_test.nim.html
title: verify/collections/hashtable_abc340c_test.nim
---
