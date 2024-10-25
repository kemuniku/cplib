---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    ERROR: 1e-6
    PROBLEM: https://atcoder.jp/contests/abc332/tasks/abc332_e
    links:
    - https://atcoder.jp/contests/abc332/tasks/abc332_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc332/tasks/abc332_e\n\
    # verification-helper: ERROR 1e-6\n{.checks: off.}\nimport cplib/utils/bititers\n\
    import sequtils, std/math\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\"\
    , varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar\
    \ N, D = ii()\nvar W = newSeqWith(N, float(ii()))\nvar avg = sum(W)/float(D)\n\
    var DP = newSeqWith(D+1, newSeqWith((1 shl N), 1e100))\nDP[0][0] = 0\nfor d in\
    \ 0..<D:\n    for i in 0..<(1 shl N):\n        for j in bitsuperset(i, N):\n \
    \           var k = i xor j\n            var tmp = 0.0\n            for l in standingbits(k):\n\
    \                tmp += W[l]\n            DP[d+1][j] = min(DP[d+1][j], DP[d][i]\
    \ + (tmp-avg)^2)\necho \"+\", DP[D][^1]/float(D)\n"
  dependsOn:
  - cplib/utils/bititers.nim
  - cplib/utils/bititers.nim
  isVerificationFile: true
  path: verify/utils/bititers_bitsuperset_test.nim
  requiredBy: []
  timestamp: '2024-10-25 15:54:28+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/bititers_bitsuperset_test.nim
layout: document
redirect_from:
- /verify/verify/utils/bititers_bitsuperset_test.nim
- /verify/verify/utils/bititers_bitsuperset_test.nim.html
title: verify/utils/bititers_bitsuperset_test.nim
---
