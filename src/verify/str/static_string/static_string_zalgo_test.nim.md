---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/zalgorithm
    links:
    - https://judge.yosupo.jp/problem/zalgorithm
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/zalgorithm\n\
    import cplib/str/static_string\n\nimport algorithm,sequtils,strutils\nvar S =\
    \ stdin.readLine().toStaticString()\nvar ans : seq[int]\nfor i in 0..<len(S):\n\
    \    ans.add(lcp(S,S[i..<len(S)]))\n\necho ans.join(\" \")"
  dependsOn:
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  isVerificationFile: true
  path: verify/str/static_string/static_string_zalgo_test.nim
  requiredBy: []
  timestamp: '2024-09-21 17:03:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/static_string/static_string_zalgo_test.nim
layout: document
redirect_from:
- /verify/verify/str/static_string/static_string_zalgo_test.nim
- /verify/verify/str/static_string/static_string_zalgo_test.nim.html
title: verify/str/static_string/static_string_zalgo_test.nim
---
