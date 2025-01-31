---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/lcs.nim
    title: cplib/str/lcs.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/lcs.nim
    title: cplib/str/lcs.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ALDS1_10_C
    links:
    - https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ALDS1_10_C
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ALDS1_10_C\n\
    \nimport sequtils,strutils\nimport cplib/str/lcs\n\nfor _ in 0..<(stdin.readLine().parseInt()):\n\
    \    var S = stdin.readline().toseq()\n    var T = stdin.readline().toseq()\n\
    \    echo LCS(S,T)"
  dependsOn:
  - cplib/str/lcs.nim
  - cplib/str/lcs.nim
  isVerificationFile: true
  path: verify/str/lcs_test.nim
  requiredBy: []
  timestamp: '2024-10-29 00:42:25+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/lcs_test.nim
layout: document
redirect_from:
- /verify/verify/str/lcs_test.nim
- /verify/verify/str/lcs_test.nim.html
title: verify/str/lcs_test.nim
---
