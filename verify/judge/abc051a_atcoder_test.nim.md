---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc051/tasks/abc051_a
    links:
    - https://atcoder.jp/contests/abc051/tasks/abc051_a
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://atcoder.jp/contests/abc051/tasks/abc051_a

    import strutils


    var s = stdin.readLine

    echo s.replace(",", " ")

    '
  dependsOn: []
  isVerificationFile: true
  path: verify/judge/abc051a_atcoder_test.nim
  requiredBy: []
  timestamp: '2023-11-11 17:30:49+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/judge/abc051a_atcoder_test.nim
layout: document
redirect_from:
- /verify/verify/judge/abc051a_atcoder_test.nim
- /verify/verify/judge/abc051a_atcoder_test.nim.html
title: verify/judge/abc051a_atcoder_test.nim
---
