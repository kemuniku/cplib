---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/itertools/combinations.nim
    title: cplib/itertools/combinations.nim
  - icon: ':heavy_check_mark:'
    path: cplib/itertools/combinations.nim
    title: cplib/itertools/combinations.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://yukicoder.me/problems/no/2561
    links:
    - https://yukicoder.me/problems/no/2561
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://yukicoder.me/problems/no/2561\nimport\
    \ math, sequtils\nimport cplib/itertools/combinations\n\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N, K = ii()\nvar A = newSeqWith(N, ii())\nvar ans\
    \ = 0\nfor x in combinations(A, K):\n    var S = sum(x)\n    if S mod 998 >= S\
    \ mod 998244353:\n        ans += 1\necho ans mod 998\n"
  dependsOn:
  - cplib/itertools/combinations.nim
  - cplib/itertools/combinations.nim
  isVerificationFile: true
  path: verify/itertools/itertools_combinations_2_test.nim
  requiredBy: []
  timestamp: '2023-12-05 14:32:07+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/itertools/itertools_combinations_2_test.nim
layout: document
redirect_from:
- /verify/verify/itertools/itertools_combinations_2_test.nim
- /verify/verify/itertools/itertools_combinations_2_test.nim.html
title: verify/itertools/itertools_combinations_2_test.nim
---
