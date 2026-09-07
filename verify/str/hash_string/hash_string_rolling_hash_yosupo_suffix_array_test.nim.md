---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/str/hash_string.nim
    title: cplib/str/hash_string.nim
  - icon: ':question:'
    path: cplib/str/hash_string.nim
    title: cplib/str/hash_string.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/suffixarray
    links:
    - https://judge.yosupo.jp/problem/suffixarray
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/suffixarray\n\
    include cplib/str/hash_string\n\n{.checks:off.}\nimport algorithm,sequtils,strutils\n\
    var S = stdin.readLine().initRollingHash()\nvar tmp : seq[RollingHash]\nfor i\
    \ in 0..<len(S):\n    tmp.add(S[i..<len(S)])\ntmp.sort()\n\necho tmp.mapit(it.l).join(\"\
    \ \")"
  dependsOn:
  - cplib/str/hash_string.nim
  - cplib/str/hash_string.nim
  isVerificationFile: true
  path: verify/str/hash_string/hash_string_rolling_hash_yosupo_suffix_array_test.nim
  requiredBy: []
  timestamp: '2026-09-08 05:46:27+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/str/hash_string/hash_string_rolling_hash_yosupo_suffix_array_test.nim
layout: document
redirect_from:
- /verify/verify/str/hash_string/hash_string_rolling_hash_yosupo_suffix_array_test.nim
- /verify/verify/str/hash_string/hash_string_rolling_hash_yosupo_suffix_array_test.nim.html
title: verify/str/hash_string/hash_string_rolling_hash_yosupo_suffix_array_test.nim
---
