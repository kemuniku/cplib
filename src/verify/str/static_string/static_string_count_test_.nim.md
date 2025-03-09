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
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc362/tasks/abc362_g
    links:
    - https://atcoder.jp/contests/abc362/tasks/abc362_g
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc362/tasks/abc362_g\n\
    import cplib/str/static_string\nimport strutils\nvar S = stdin.readLine()\nvar\
    \ Q = stdin.readLine().parseInt()\nvar SB = initStaticStringBase(S)\nfor i in\
    \ 0..<Q:\n    var T = stdin.readLine()\n    stdout.writeLine(SB.count(T))"
  dependsOn:
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  isVerificationFile: false
  path: verify/str/static_string/static_string_count_test_.nim
  requiredBy: []
  timestamp: '2024-09-21 17:03:37+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/str/static_string/static_string_count_test_.nim
layout: document
redirect_from:
- /library/verify/str/static_string/static_string_count_test_.nim
- /library/verify/str/static_string/static_string_count_test_.nim.html
title: verify/str/static_string/static_string_count_test_.nim
---
