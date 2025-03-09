---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/can_reverse_hash_string.nim
    title: cplib/str/can_reverse_hash_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/can_reverse_hash_string.nim
    title: cplib/str/can_reverse_hash_string.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/longest_common_substring
    links:
    - https://judge.yosupo.jp/problem/longest_common_substring
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/longest_common_substring\n\
    import cplib/str/can_reverse_hash_string\n\n{.checks:off.}\nimport algorithm,sequtils,strutils\n\
    import atcoder/string\nvar S = stdin.readLine()\nvar T = stdin.readLine()\nvar\
    \ SA = suffix_array((S & '$' & T))\nvar X = (S & '$' & T).initRollingHash()\n\
    var tmp : seq[RollingHash]\nfor i in 0..<len(X):\n    tmp.add(X[SA[i]..<len(X)])\n\
    var ans = 0\nvar a = 0\nvar b = 0\nvar c = 0\nvar d = 0\nfor i in 0..<(len(X)-1):\n\
    \    if (tmp[i].l in 0..<len(S) and tmp[i+1].l notin 0..<len(S)) or (tmp[i+1].l\
    \ in 0..<len(S) and tmp[i].l notin 0..<len(S)):\n        var lcp = LCP(tmp[i],tmp[i+1])\n\
    \        if ans < lcp:\n            ans = lcp\n            if tmp[i].l in 0..<len(S):\n\
    \                a = tmp[i].l\n                b = tmp[i].l+lcp\n            \
    \    c = tmp[i+1].l-len(S)-1\n                d = tmp[i+1].l+lcp-len(S)-1\n  \
    \          else:\n                a = tmp[i+1].l\n                b = tmp[i+1].l+lcp\n\
    \                c = tmp[i].l-len(S)-1\n                d = tmp[i].l+lcp-len(S)-1\n\
    echo a,\" \",b,\" \",c,\" \",d"
  dependsOn:
  - cplib/str/can_reverse_hash_string.nim
  - cplib/str/can_reverse_hash_string.nim
  isVerificationFile: true
  path: verify/str/can_reverse_hash_string/can_reverse_hash_string_LCS_test.nim
  requiredBy: []
  timestamp: '2024-08-31 11:41:07+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/can_reverse_hash_string/can_reverse_hash_string_LCS_test.nim
layout: document
redirect_from:
- /verify/verify/str/can_reverse_hash_string/can_reverse_hash_string_LCS_test.nim
- /verify/verify/str/can_reverse_hash_string/can_reverse_hash_string_LCS_test.nim.html
title: verify/str/can_reverse_hash_string/can_reverse_hash_string_LCS_test.nim
---
