---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/hash_string.nim
    title: cplib/str/hash_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/hash_string.nim
    title: cplib/str/hash_string.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/number_of_substrings
    links:
    - https://judge.yosupo.jp/problem/number_of_substrings
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings\n\
    include cplib/str/hash_string\n\n{.checks:off.}\nimport algorithm,sequtils,strutils\n\
    var S = stdin.readLine().initRollingHash()\nvar tmp : seq[RollingHash]\nfor i\
    \ in 0..<len(S):\n    tmp.add(S[i..<len(S)])\ntmp.sort()\nvar sm = 0\nfor i in\
    \ 0..<(len(S)-1):\n    sm += LCP(tmp[i],tmp[i+1])\necho len(S)*(len(S)+1) div\
    \ 2 - sm"
  dependsOn:
  - cplib/str/hash_string.nim
  - cplib/str/hash_string.nim
  isVerificationFile: true
  path: verify/str/hash_string/hash_string_LCP_test.nim
  requiredBy: []
  timestamp: '2024-08-31 00:22:23+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/hash_string/hash_string_LCP_test.nim
layout: document
redirect_from:
- /verify/verify/str/hash_string/hash_string_LCP_test.nim
- /verify/verify/str/hash_string/hash_string_LCP_test.nim.html
title: verify/str/hash_string/hash_string_LCP_test.nim
---
