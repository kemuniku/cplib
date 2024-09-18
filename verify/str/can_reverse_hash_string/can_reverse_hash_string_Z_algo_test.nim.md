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
    PROBLEM: https://judge.yosupo.jp/problem/zalgorithm
    links:
    - https://judge.yosupo.jp/problem/zalgorithm
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/zalgorithm\n\
    import cplib/str/can_reverse_hash_string\n\n{.checks:off.}\nimport algorithm,sequtils,strutils\n\
    var S = stdin.readLine().initRollingHash()\nvar ans : seq[int]\nfor i in 0..<len(S):\n\
    \    ans.add(LCP(S,S[i..<len(S)]))\n\necho ans.join(\" \")"
  dependsOn:
  - cplib/str/can_reverse_hash_string.nim
  - cplib/str/can_reverse_hash_string.nim
  isVerificationFile: true
  path: verify/str/can_reverse_hash_string/can_reverse_hash_string_Z_algo_test.nim
  requiredBy: []
  timestamp: '2024-08-31 11:41:07+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/can_reverse_hash_string/can_reverse_hash_string_Z_algo_test.nim
layout: document
redirect_from:
- /verify/verify/str/can_reverse_hash_string/can_reverse_hash_string_Z_algo_test.nim
- /verify/verify/str/can_reverse_hash_string/can_reverse_hash_string_Z_algo_test.nim.html
title: verify/str/can_reverse_hash_string/can_reverse_hash_string_Z_algo_test.nim
---
