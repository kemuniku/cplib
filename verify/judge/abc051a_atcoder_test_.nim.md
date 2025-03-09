---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc051/tasks/abc051_a
    links:
    - https://atcoder.jp/contests/abc051/tasks/abc051_a
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://atcoder.jp/contests/abc051/tasks/abc051_a

    import strutils


    var s = stdin.readLine

    echo s.replace(",", " ")

    '
  dependsOn: []
  isVerificationFile: false
  path: verify/judge/abc051a_atcoder_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/judge/abc051a_atcoder_test_.nim
layout: document
redirect_from:
- /library/verify/judge/abc051a_atcoder_test_.nim
- /library/verify/judge/abc051a_atcoder_test_.nim.html
title: verify/judge/abc051a_atcoder_test_.nim
---
