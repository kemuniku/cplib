---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/euler_phi.nim
    title: cplib/math/euler_phi.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/euler_phi.nim
    title: cplib/math/euler_phi.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://yukicoder.me/problems/no/2249
    links:
    - https://yukicoder.me/problems/no/2249
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://yukicoder.me/problems/no/2249\nimport\
    \ strutils, sequtils\nimport cplib/math/euler_phi\n\nvar t = stdin.readLine.parseint\n\
    var mx = 10000000\nvar li = euler_phi_list(mx)\nvar dp = newSeqWith(mx+1, 0)\n\
    for i in 2..mx:\n    dp[i] = dp[i-1] + li[i] * 1 + (i - 1 - li[i]) * 2\nvar ans\
    \ = newSeq[int](0)\nfor _ in 0..<t:\n    var n = stdin.readLine.parseint\n   \
    \ ans.add(dp[n])\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/math/euler_phi.nim
  - cplib/math/euler_phi.nim
  isVerificationFile: true
  path: verify/math/euler_phi_list_yukicoder_test.nim
  requiredBy: []
  timestamp: '2024-01-07 17:44:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/euler_phi_list_yukicoder_test.nim
layout: document
redirect_from:
- /verify/verify/math/euler_phi_list_yukicoder_test.nim
- /verify/verify/math/euler_phi_list_yukicoder_test.nim.html
title: verify/math/euler_phi_list_yukicoder_test.nim
---
