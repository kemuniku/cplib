---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/aplusb
    links:
    - https://judge.yosupo.jp/problem/aplusb
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/aplusb

    import strscans


    var a, b: int

    discard stdin.readLine.scanf("$i $i", a, b)

    echo a + b

    '
  dependsOn: []
  isVerificationFile: true
  path: verify/judge/aplusb_library_checker_test.nim
  requiredBy: []
  timestamp: '2023-11-14 07:01:38+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/judge/aplusb_library_checker_test.nim
layout: document
redirect_from:
- /verify/verify/judge/aplusb_library_checker_test.nim
- /verify/verify/judge/aplusb_library_checker_test.nim.html
title: verify/judge/aplusb_library_checker_test.nim
---
