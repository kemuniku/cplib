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
    PROBLEM: https://judge.yosupo.jp/problem/suffixarray
    links:
    - https://judge.yosupo.jp/problem/suffixarray
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/suffixarray\n\
    import cplib/str/static_string\n\nimport algorithm,sequtils,strutils\nvar S =\
    \ stdin.readLine().toStaticString()\nvar tmp : seq[StaticString]\nfor i in 0..<len(S):\n\
    \    tmp.add(S[i..<len(S)])\ntmp.sort()\n\necho tmp.mapit(it.l).join(\" \")"
  dependsOn:
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  isVerificationFile: true
  path: verify/str/static_string/static_string_SA_test.nim
  requiredBy: []
  timestamp: '2024-07-19 08:40:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/static_string/static_string_SA_test.nim
layout: document
redirect_from:
- /verify/verify/str/static_string/static_string_SA_test.nim
- /verify/verify/str/static_string/static_string_SA_test.nim.html
title: verify/str/static_string/static_string_SA_test.nim
---