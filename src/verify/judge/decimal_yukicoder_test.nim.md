---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    ERROR: 1e-4
    PROBLEM: https://yukicoder.me/problems/no/9003
    links:
    - https://yukicoder.me/problems/no/9003
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verify-helper: PROBLEM https://yukicoder.me/problems/no/9003

    # verify-helper: ERROR 1e-4

    import strscans, strformat


    var a: float

    discard stdin.readLine.scanf("$f", a)

    echo "decimal"

    echo &"{a:6f}"

    '
  dependsOn: []
  isVerificationFile: true
  path: verify/judge/decimal_yukicoder_test.nim
  requiredBy: []
  timestamp: '2023-11-02 23:17:10+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/judge/decimal_yukicoder_test.nim
layout: document
redirect_from:
- /verify/verify/judge/decimal_yukicoder_test.nim
- /verify/verify/judge/decimal_yukicoder_test.nim.html
title: verify/judge/decimal_yukicoder_test.nim
---
