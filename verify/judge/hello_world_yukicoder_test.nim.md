---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://yukicoder.me/problems/12
    links:
    - https://yukicoder.me/problems/12
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://yukicoder.me/problems/12

    discard stdin.readLine

    echo "Hello World!"

    '
  dependsOn: []
  isVerificationFile: true
  path: verify/judge/hello_world_yukicoder_test.nim
  requiredBy: []
  timestamp: '2023-11-03 12:47:02+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/judge/hello_world_yukicoder_test.nim
layout: document
redirect_from:
- /verify/verify/judge/hello_world_yukicoder_test.nim
- /verify/verify/judge/hello_world_yukicoder_test.nim.html
title: verify/judge/hello_world_yukicoder_test.nim
---
